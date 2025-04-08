require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { User.create!(name: "Test User", email_address: "test@example.com", points: 10) }
  let(:valid_attributes) { { name: "New User", email_address: "new@example.com", points: 20 } }
  let(:invalid_attributes) { { name: nil, email_address: "invalid-email", points: -5 } }

  def json_response
    JSON.parse(response.body)
  end

  # Test suite for the INDEX action (GET /users)
  describe "GET #index" do
    it "returns a success response (HTTP 200 OK)" do
      get :index
      expect(response).to be_successful
    end

    it "returns all users as JSON" do
      get :index
      expect(json_response).to eq(User.all.as_json)
    end
  end

  # Test suite for the SHOW action (GET /users/:id)
  describe "GET #show" do
    context "when the user exists" do
      it "returns a success response (HTTP 200 OK)" do
        get :show, params: { id: user.id }
        expect(response).to be_successful
      end

      it "returns the requested user as JSON" do
        get :show, params: { id: user.id }
        expect(json_response).to eq(user.as_json)
      end
    end

    context "when the user does not exist" do
      it "raises ActiveRecord::RecordNotFound" do
        expect {
          get :show, params: { id: -1 } # Use an ID guaranteed not to exist.
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  # Test suite for the CREATE action (POST /users)
  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new User" do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it "returns the created user as JSON" do
        post :create, params: { user: valid_attributes }
        expect(json_response).to include("name" => "New User", "email_address" => "new@example.com", "points" => 20)
      end

      it "returns a 201 Created status" do
        post :create, params: { user: valid_attributes }
        expect(response).to have_http_status(:created)
      end

      it "sets the Location header" do
        post :create, params: { user: valid_attributes }
        created_user = User.last
        expect(response.location).to eq(user_url(created_user))
      end
    end

    context "with invalid parameters" do
      it "does not create a new User" do
        expect {
          post :create, params: { user: invalid_attributes }
        }.not_to change(User, :count)
      end

      it "returns validation errors as JSON" do
        post :create, params: { user: invalid_attributes }
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(json_response['name']).to include("can't be blank")
        expect(json_response['email_address']).to include("is invalid")
        expect(json_response['points']).to include("must be greater than or equal to 0")
      end

      it "returns an 422 Unprocessable Entity status" do
        post :create, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with missing 'user' parameter key" do
       it "raises ActionController::ParameterMissing" do
        expect {
          post :create, params: { wrong_key: valid_attributes }
        }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end

  # Test suite for the UPDATE action (PUT /users/:id or PATCH /users/:id)
  # Using PUT for testing updates.
  describe "PUT #update" do
    context "when the user exists" do
      context "with valid parameters" do
        let(:new_attributes) { { name: "Updated Name", points: 55 } }

        it "updates the requested user" do
          put :update, params: { id: user.id, user: new_attributes }
          user.reload
          expect(user.name).to eq("Updated Name")
          expect(user.points).to eq(55)
          expect(user.email_address).to eq("test@example.com")
        end

        it "returns the updated user as JSON" do
          put :update, params: { id: user.id, user: new_attributes }
          expect(response).to be_successful
          expect(json_response).to include("name" => "Updated Name", "points" => 55)
        end
      end

      context "with invalid parameters" do
        it "does not update the user" do
          original_name = user.name
          put :update, params: { id: user.id, user: invalid_attributes }
          user.reload
          expect(user.name).to eq(original_name)
          expect(user.name).not_to be_nil
        end

        it "returns validation errors as JSON" do
          put :update, params: { id: user.id, user: invalid_attributes }
          expect(response.content_type).to eq("application/json; charset=utf-8")
          expect(json_response['name']).to be_present
          expect(json_response['email_address']).to be_present
          expect(json_response['points']).to be_present
        end

        it "returns an 422 Unprocessable Entity status" do
          put :update, params: { id: user.id, user: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context "with missing 'user' parameter key" do
        it "raises ActionController::ParameterMissing" do
          expect {
            put :update, params: { id: user.id, wrong_key: valid_attributes }
          }.to raise_error(ActionController::ParameterMissing)
        end
      end
    end

    context "when the user does not exist" do
      it "raises ActiveRecord::RecordNotFound" do
        expect {
          put :update, params: { id: -1, user: valid_attributes }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  # Test suite for the DESTROY action (DELETE /users/:id)
  describe "DELETE #destroy" do
    context "when the user exists" do
      it "destroys the requested user" do
        expect {
          delete :destroy, params: { id: user.id }
        }.to change(User, :count).by(-1)
      end

      it "returns a 204 No Content status" do
        delete :destroy, params: { id: user.id }
        expect(response).to have_http_status(:no_content)
      end

       it "returns an empty response body" do
        delete :destroy, params: { id: user.id }
        expect(response.body).to be_empty
      end
    end

    context "when the user does not exist" do
      it "raises ActiveRecord::RecordNotFound" do
        expect {
          delete :destroy, params: { id: -1 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
