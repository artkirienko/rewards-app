# spec/requests/api/v1/accounts_controller_spec.rb
require 'rails_helper'

RSpec.describe "Api::V1::AccountsController", type: :request do
  let(:user) {
    FactoryBot.create(
      :user,
      name: "Test User",
      email_address: "test@example.com",
      points: 100,
      password: "password"
    )
  }
  let(:login_credentials) do
    {
      user: {
        email: user.email_address,
        password: "password"
      }
    }
  end
  let(:headers) { { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' } }
  let(:auth_token) do
    post '/api/v1/login', params: login_credentials.to_json, headers: headers
    json_response['token'] || JSON.parse(response.body).dig('meta', 'token')
  end
  let(:auth_headers) { headers.merge('Authorization' => "Bearer #{auth_token}") }

  describe "Authentication" do
    it "successfully logs in and returns a token" do
      post '/api/v1/login', params: login_credentials.to_json, headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_response['token'] || json_response.dig('meta', 'token')).to be_present
    end
  end

  describe "GET /api/v1/account" do
    context "with valid authentication" do
      before do
        get "/api/v1/account", headers: auth_headers
      end

      it "returns successful response" do
        expect(response).to have_http_status(:ok)
      end

      it "returns user details" do
        expect(json_response).to include(
          "name" => "Test User",
          "email_address" => "test@example.com"
        )
      end
    end

    context "without authentication" do
      it "returns unauthorized status" do
        get "/api/v1/account"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /api/v1/account/balance" do
    context "with valid authentication" do
      before do
        get "/api/v1/account/balance", headers: auth_headers
      end

      it "returns successful response" do
        expect(response).to have_http_status(:ok)
      end

      it "returns user's points balance" do
        expect(json_response).to eq("points" => 100)
      end
    end
  end

  describe "GET /api/v1/account/history" do
    let(:reward) { FactoryBot.create(:reward, name: "Test Reward", description: "Reward Description", points: 50) }

    before do
      FactoryBot.create(
        :points_event,
        user: user,
        source: reward,
        points: -50,
        created_at: 2.days.ago
      )
    end

    context "with valid authentication" do
      before do
        get "/api/v1/account/history", headers: auth_headers
      end

      it "returns successful response" do
        expect(response).to have_http_status(:ok)
      end

      it "returns points event history" do
        expect(json_response).to be_an(Array)
        expect(json_response.first).to include(
          "points" => -50,
          "type" => "Reward",
          "name" => "Test Reward",
          "description" => "Reward Description"
        )
        expect(json_response.first["created_at"]).to be_present
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end
