require 'rails_helper'

RSpec.describe "/users", type: :request do
  let!(:user) { User.create(name: "Alice", email_address: "alice@example.com", points: 10) }

  describe "GET /index" do
    it "returns a successful response" do
      get users_path
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).first["email_address"]).to eq("alice@example.com")
    end
  end

  describe "GET /show" do
    it "returns the user" do
      get user_path(user)
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq("Alice")
    end
  end

  describe "POST /create" do
    let(:valid_params) do
      {
        user: {
          name: "Bob",
          email_address: "bob@example.com",
          points: 20
        }
      }
    end

    let(:invalid_params) do
      {
        user: {
          name: "",
          email_address: "bademail",
          points: -5
        }
      }
    end

    it "creates a new user with valid params" do
      expect {
        post users_path, params: valid_params
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["email_address"]).to eq("bob@example.com")
    end

    it "does not create a user with invalid params" do
      post users_path, params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to include("name", "email_address", "points")
    end
  end

  describe "PATCH /update" do
    it "updates the user" do
      patch user_path(user), params: { user: { name: "Alice Updated" } }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq("Alice Updated")
    end
  end

  describe "DELETE /destroy" do
    it "deletes the user" do
      expect {
        delete user_path(user)
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
