require 'rails_helper'

RSpec.describe "Bonuses", type: :request do
  let(:valid_attributes) do
    {
      name: "Test Bonus",
      description: "This is a test bonus",
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

  describe "GET /bonuses" do
    it "returns a success response" do
      Bonus.create! valid_attributes
      get bonuses_path
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include("application/json")
      expect(JSON.parse(response.body)).to be_an(Array)
    end
  end

  describe "GET /bonuses/:id" do
    context "when the record exists" do
      let(:bonus) { Bonus.create! valid_attributes }

      it "returns the bonus" do
        get bonus_path(bonus.id)
        expect(response).to have_http_status(:success)
        expect(response.content_type).to include("application/json")
        expect(JSON.parse(response.body)["id"]).to eq(bonus.id)
      end
    end

    context "when the record does not exist" do
      it "returns not found" do
        get bonus_path(999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /bonuses" do
    context "with valid parameters" do
      it "creates a new Bonus" do
        expect {
          post bonuses_path, params: { bonus: valid_attributes }
        }.to change(Bonus, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response.content_type).to include("application/json")
        expect(JSON.parse(response.body)["name"]).to eq("Test Bonus")
      end
    end

    context "with invalid parameters" do
      it "does not create a new Bonus" do
        expect {
          post bonuses_path, params: { bonus: invalid_attributes }
        }.not_to change(Bonus, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include("application/json")
      end
    end
  end

  describe "PUT /bonuses/:id" do
    let(:bonus) { Bonus.create! valid_attributes }
    let(:new_attributes) do
      {
        name: "Updated Bonus",
        description: "Updated description",
        points: 200
      }
    end

    context "with valid parameters" do
      it "updates the requested bonus" do
        put bonus_path(bonus.id), params: { bonus: new_attributes }
        bonus.reload
        expect(response).to have_http_status(:success)
        expect(response.content_type).to include("application/json")
        expect(bonus.name).to eq("Updated Bonus")
      end
    end

    context "with invalid parameters" do
      it "returns unprocessable entity" do
        put bonus_path(bonus.id), params: { bonus: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include("application/json")
      end
    end
  end

  describe "DELETE /bonuses/:id" do
    let!(:bonus) { Bonus.create! valid_attributes }

    it "destroys the requested bonus" do
      expect {
        delete bonus_path(bonus.id)
      }.to change(Bonus, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
