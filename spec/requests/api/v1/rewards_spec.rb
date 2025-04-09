require 'rails_helper'

RSpec.describe "Api::V1::Rewards", type: :request do
  let(:valid_attributes) do
    {
      name: "Test Reward",
      description: "This is a test reward",
      points: 100
    }
  end

  let(:invalid_attributes) do
    {
      name: "",
      description: "",
      points: -1
    }
  end

  describe "GET /rewards" do
    it "returns a success response" do
      Reward.create! valid_attributes
      get api_v1_rewards_path
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include("application/json")
      expect(JSON.parse(response.body)).to be_an(Array)
    end
  end

  describe "GET /rewards/:id" do
    context "when the record exists" do
      let(:reward) { Reward.create! valid_attributes }

      it "returns the reward" do
        get api_v1_reward_path(reward.id)
        expect(response).to have_http_status(:success)
        expect(response.content_type).to include("application/json")
        expect(JSON.parse(response.body)["id"]).to eq(reward.id)
      end
    end

    context "when the record does not exist" do
      it "returns not found" do
        get api_v1_reward_path(999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /api/v1/rewards/:id/redeem" do
    let(:user) { FactoryBot.create(:user, points: 100) }
    let(:reward) { FactoryBot.create(:reward, points: 50) }
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:auth_headers) { headers.merge('Authorization' => "Bearer #{jwt_token}") }
    let(:jwt_token) do
      post "/login",
           params: { user: { email: user.email_address, password: user.password } },
           headers: headers
      JSON.parse(response.body)['token']
    end

    context "when user is authenticated" do
      context "with sufficient points" do
        it "redeems the reward successfully" do
          post "/api/v1/rewards/#{reward.id}/redeem", headers: auth_headers

          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response['message']).to eq("Reward redeemed successfully")
          expect(json_response['points_left']).to eq(50)
          expect(json_response['points_used']).to eq(50)

          user.reload
          expect(user.points).to eq(50)

          points_event = PointsEvent.last
          expect(points_event.user).to eq(user)
          expect(points_event.source).to eq(reward)
          expect(points_event.points).to eq(-50)
        end
      end

      context "with insufficient points" do
        let(:user) { FactoryBot.create(:user, points: 30) }

        it "returns an error" do
          post "/api/v1/rewards/#{reward.id}/redeem", headers: auth_headers

          expect(response).to have_http_status(:unprocessable_entity)
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to eq("Not enough points")

          user.reload
          expect(user.points).to eq(30)
          expect(PointsEvent.count).to eq(0)
        end
      end

      context "with invalid reward id" do
        it "returns not found" do
          post "/api/v1/rewards/999/redeem", headers: auth_headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "when user is not authenticated" do
      it "returns unauthorized" do
        post "/api/v1/rewards/#{reward.id}/redeem", headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  # Negative tests for unsupported methods
  describe "POST /rewards" do
    context "with valid parameters" do
      it "does not create a new Reward" do
        post api_v1_rewards_path, params: { reward: valid_attributes }

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).not_to include("application/json")
      end
    end

    context "with invalid parameters" do
      it "does not create a new Reward" do
        post api_v1_rewards_path, params: { reward: invalid_attributes }

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).not_to include("application/json")
      end
    end
  end

  describe "PUT /rewards/:id" do
    let(:reward) { Reward.create! valid_attributes }
    let(:new_attributes) do
      {
        name: "Updated Reward",
        description: "Updated description",
        points: 200
      }
    end

    context "with valid parameters" do
      it "does not update the requested reward" do
        put api_v1_reward_path(reward.id), params: { reward: new_attributes }
        reward.reload
        expect(response).to have_http_status(:not_found)
        expect(response.content_type).not_to include("application/json")
      end
    end

    context "with invalid parameters" do
      it "does not return unprocessable entity" do
        put api_v1_reward_path(reward.id), params: { reward: invalid_attributes }
        expect(response).to have_http_status(:not_found)
        expect(response.content_type).not_to include("application/json")
      end
    end
  end

  describe "DELETE /rewards/:id" do
    let!(:reward) { Reward.create! valid_attributes }

    it "does not destroy the requested reward" do
      delete api_v1_reward_path(reward.id)
      expect(response).to have_http_status(:not_found)
    end
  end
end
