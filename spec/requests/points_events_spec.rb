require 'rails_helper'

RSpec.describe "PointsEvents", type: :request do
  let(:user) do
    User.create!(
      name: "Test User",
      email_address: "test#{SecureRandom.hex(4)}@example.com",
      points: 0
    )
  end

  let(:bonus) do
    Bonus.create!(
      name: "Test Bonus",
      description: "A test bonus",
      points: 100
    )
  end

  let(:valid_attributes) do
    {
      user_id: user.id,
      source_id: bonus.id,
      source_type: 'Bonus',
      points: 100
    }
  end

  let(:invalid_attributes) do
    {
      user_id: nil,
      source_id: nil,
      source_type: nil,
      points: nil
    }
  end

  before do
    PointsEvent.delete_all
    User.delete_all
    Bonus.delete_all
  end

  describe "GET /points_events" do
    it "returns a success response" do
      PointsEvent.create!(
        user: user,
        source: bonus,
        points: 100
      )
      get points_events_path
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq("application/json; charset=utf-8")
    end
  end

  describe "GET /points_events/:id" do
    context "with valid id" do
      it "returns the points event" do
        points_event = PointsEvent.create!(
          user: user,
          source: bonus,
          points: 100
        )
        get points_event_path(points_event)
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["id"]).to eq(points_event.id)
      end
    end

    context "with invalid id" do
      it "returns not found" do
        get points_event_path(id: 9999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /points_events" do
    context "with valid params" do
      it "creates a new PointsEvent" do
        expect {
          post points_events_path, params: { points_event: valid_attributes }
        }.to change(PointsEvent, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end

    context "with invalid params" do
      it "returns unprocessable entity" do
        post points_events_path, params: { points_event: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key("user")
        expect(JSON.parse(response.body)).to have_key("source")
        expect(JSON.parse(response.body)).to have_key("points")
      end
    end
  end

  describe "PUT /points_events/:id" do
    let(:points_event) do
      PointsEvent.create!(
        user: user,
        source: bonus,
        points: 100
      )
    end
    let(:new_attributes) { { points: 200 } }

    context "with valid params" do
      it "updates the requested points_event" do
        put points_event_path(points_event), params: { points_event: new_attributes }
        points_event.reload
        expect(points_event.points).to eq(200)
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      it "returns unprocessable entity" do
        put points_event_path(points_event), params: { points_event: { points: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /points_events/:id" do
    let(:points_event) do
      PointsEvent.create!(
        user: user,
        source: bonus,
        points: 100
      )
    end

    it "destroys the requested points_event" do
      points_event

      expect {
        delete points_event_path(points_event)
      }.to change(PointsEvent, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
