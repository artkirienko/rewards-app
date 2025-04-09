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

  describe "POST /rewards/:reward_id/redeem" do
    let(:reward) { Reward.create! valid_attributes }

    it "returns http no_content" do
      pending 'Update when current_user imlementation is ready'
      post api_v1_reward_redeem_path(reward)
      expect(response).to have_http_status(:no_content)
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
