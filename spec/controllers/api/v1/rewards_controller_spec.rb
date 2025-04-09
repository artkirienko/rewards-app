require 'rails_helper'

RSpec.describe Api::V1::RewardsController, type: :controller do
  let(:valid_attributes) do
    {
      name: 'Test Reward',
      description: 'A test reward description',
      points: 100
    }
  end

  let(:invalid_attributes) do
    {
      name: '',
      description: '',
      points: -1
    }
  end

  let(:reward) { Reward.create!(valid_attributes) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns all rewards' do
      reward
      get :index
      expect(JSON.parse(response.body).length).to eq(1)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: reward.id }
      expect(response).to be_successful
    end

    it 'returns the requested reward' do
      get :show, params: { id: reward.id }
      expect(JSON.parse(response.body)['id']).to eq(reward.id)
    end

    context 'when reward is not found' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect {
          get :show, params: { id: -1 } # Use an ID guaranteed not to exist
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Reward' do
        skip 'Move to Api::V1::Admin::RewardsController'
        expect {
          post :create, params: { reward: valid_attributes }
        }.to change(Reward, :count).by(1)
      end

      it 'renders a JSON response with the new reward' do
        skip 'Move to Api::V1::Admin::RewardsController'
        post :create, params: { reward: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors' do
        skip 'Move to Api::V1::Admin::RewardsController'
        post :create, params: { reward: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end

      it 'does not create a new Reward' do
        skip 'Move to Api::V1::Admin::RewardsController'
        expect {
          post :create, params: { reward: invalid_attributes }
        }.not_to change(Reward, :count)
      end
    end
  end

  describe 'POST #redeem' do
    it 'returns a no_content response' do
      post :redeem, params: { reward_id: reward.id }
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          name: 'Updated Reward',
          description: 'Updated description',
          points: 200
        }
      end

      it 'updates the requested reward' do
        skip 'Move to Api::V1::Admin::RewardsController'
        put :update, params: { id: reward.id, reward: new_attributes }
        reward.reload
        expect(reward.name).to eq('Updated Reward')
      end

      it 'renders a JSON response with the reward' do
        skip 'Move to Api::V1::Admin::RewardsController'
        put :update, params: { id: reward.id, reward: new_attributes }
        expect(response).to be_successful
        expect(response.content_type).to include('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors' do
        skip 'Move to Api::V1::Admin::RewardsController'
        put :update, params: { id: reward.id, reward: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested reward' do
      skip 'Move to Api::V1::Admin::RewardsController'
      reward
      expect {
        delete :destroy, params: { id: reward.id }
      }.to change(Reward, :count).by(-1)
    end

    it 'returns a no content response' do
      skip 'Move to Api::V1::Admin::RewardsController'
      delete :destroy, params: { id: reward.id }
      expect(response).to have_http_status(:no_content)
    end
  end
end
