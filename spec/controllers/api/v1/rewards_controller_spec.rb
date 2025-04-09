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

  describe 'POST #redeem' do
    let(:user) { FactoryBot.create(:user, points: 100) }
    let(:reward) { FactoryBot.create(:reward, points: 50) }
    let(:devise_mapping) { Devise.mappings[:user] }

    before do
      request.env["devise.mapping"] = devise_mapping
      sign_in user
    end

    context 'when user is authenticated' do
      context 'with sufficient points' do
        it 'redeems the reward successfully' do
          post :redeem, params: { reward_id: reward.id }, format: :json

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to include(
            'message' => 'Reward redeemed successfully',
            'points_left' => 50,
            'points_used' => 50
          )
          expect(user.reload.points).to eq(50)
          expect(PointsEvent.find_by(user: user, source: reward)).to be_present
        end
      end

      context 'with insufficient points' do
        let(:user) { FactoryBot.create(:user, points: 20) }

        it 'returns an error' do
          post :redeem, params: { reward_id: reward.id }, format: :json

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to include(
            'error' => 'Not enough points'
          )
          expect(user.reload.points).to eq(20)
          expect(PointsEvent.find_by(user: user, source: reward)).to be_nil
        end
      end

      context 'with invalid reward id' do
        it 'returns not found error' do
          post :redeem, params: { reward_id: 'nonexistent' }, format: :json

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when user is not authenticated' do
      before do
        sign_out user
      end

      it 'returns unauthorized error' do
        post :redeem, params: { reward_id: reward.id }, format: :json

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include('error')
      end
    end
  end
end
