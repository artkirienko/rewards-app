require 'rails_helper'

RSpec.describe Api::V1::AccountsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:devise_mapping) { Devise.mappings[:user] }

  describe 'GET #show' do
    before do
      request.env["devise.mapping"] = devise_mapping
      sign_in user
      get :show, format: :json
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the user name and email' do
      json_response = JSON.parse(response.body)
      expect(json_response).to include('name', 'email_address')
      expect(json_response['name']).to eq(user.name)
      expect(json_response['email_address']).to eq(user.email_address)
    end

    it 'does not return the user points' do
      json_response = JSON.parse(response.body)
      expect(json_response).not_to include('points')
    end
  end

  describe 'GET #balance' do
    let(:user) { FactoryBot.create(:user, points: 100) }

    before do
      request.env["devise.mapping"] = devise_mapping
      sign_in user
      get :balance, format: :json
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the user points' do
      json_response = JSON.parse(response.body)
      expect(json_response).to include('points')
      expect(json_response['points']).to eq(user.points)
    end

    it 'does not return the user name or email' do
      json_response = JSON.parse(response.body)
      expect(json_response).not_to include('name', 'email_address')
    end
  end

  describe 'GET #history' do
    let(:reward_one) { FactoryBot.create(:reward, name: 'Reward 1', description: 'Description 1') }
    let(:reward_two) { FactoryBot.create(:reward, name: 'Reward 2', description: 'Description 2') }
    let!(:event_one) { FactoryBot.create(:points_event, user: user, source: reward_one, points: 10) }
    let!(:event_two) { FactoryBot.create(:points_event, user: user, source: reward_two, points: -5) }

    before do
      request.env["devise.mapping"] = devise_mapping
      sign_in user
      get :history, format: :json
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the points history' do
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(2)
    end

    it 'returns the points history in descending order' do
      json_response = JSON.parse(response.body)
      expect(json_response[0]['points']).to eq(event_two.points)
      expect(json_response[1]['points']).to eq(event_one.points)
    end

    it 'includes reward details' do
      json_response = JSON.parse(response.body)
      expect(json_response[0]).to include('name', 'description')
      expect(json_response[0]['type']).to eq('Reward')
    end
  end
end
