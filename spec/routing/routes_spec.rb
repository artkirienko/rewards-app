require 'rails_helper'

RSpec.describe 'Routes', type: :routing do
  describe 'users routes' do
    it 'routes to #index' do
      expect(get('/users')).to route_to('users#index')
    end

    it 'routes to #show' do
      expect(get('/users/1')).to route_to('users#show', id: '1')
    end

    it 'routes to #create' do
      expect(post('/users')).to route_to('users#create')
    end

    it 'routes to #update via PUT' do
      expect(put('/users/1')).to route_to('users#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch('/users/1')).to route_to('users#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete('/users/1')).to route_to('users#destroy', id: '1')
    end
  end

  describe 'api v1 rewards routes' do
    it 'routes to #index' do
      expect(get('/api/v1/rewards')).to route_to('api/v1/rewards#index')
    end

    it 'routes to #show' do
      expect(get('/api/v1/rewards/1')).to route_to('api/v1/rewards#show', id: '1')
    end

    it 'routes to #create' do
      expect(post('/api/v1/rewards')).to route_to('api/v1/rewards#create')
    end

    it 'routes to #update via PUT' do
      expect(put('/api/v1/rewards/1')).to route_to('api/v1/rewards#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch('/api/v1/rewards/1')).to route_to('api/v1/rewards#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete('/api/v1/rewards/1')).to route_to('api/v1/rewards#destroy', id: '1')
    end

    it "routes to #redeem" do
      expect(post: "/api/v1/rewards/1/redeem").to route_to("api/v1/rewards#redeem", reward_id: "1")
    end
  end

  describe 'bonuses routes' do
    it 'routes to #index' do
      expect(get('/bonuses')).to route_to('bonuses#index')
    end

    it 'routes to #show' do
      expect(get('/bonuses/1')).to route_to('bonuses#show', id: '1')
    end

    it 'routes to #create' do
      expect(post('/bonuses')).to route_to('bonuses#create')
    end

    it 'routes to #update via PUT' do
      expect(put('/bonuses/1')).to route_to('bonuses#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch('/bonuses/1')).to route_to('bonuses#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete('/bonuses/1')).to route_to('bonuses#destroy', id: '1')
    end
  end

  describe 'points_events routes' do
    it 'routes to #index' do
      expect(get('/points_events')).to route_to('points_events#index')
    end

    it 'routes to #show' do
      expect(get('/points_events/1')).to route_to('points_events#show', id: '1')
    end

    it 'routes to #create' do
      expect(post('/points_events')).to route_to('points_events#create')
    end

    it 'routes to #update via PUT' do
      expect(put('/points_events/1')).to route_to('points_events#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch('/points_events/1')).to route_to('points_events#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete('/points_events/1')).to route_to('points_events#destroy', id: '1')
    end
  end

  describe 'api v1 account routes' do
    it "routes GET /api/v1/account to accounts#show" do
      expect(get: "/api/v1/account").to route_to(
        controller: "api/v1/accounts",
        action: "show"
      )
    end

    it "routes GET /api/v1/account/balance to accounts#balance" do
      expect(get: "/api/v1/account/balance").to route_to(
        controller: "api/v1/accounts",
        action: "balance"
      )
    end

    it "routes GET /api/v1/account/history to accounts#history" do
      expect(get: "/api/v1/account/history").to route_to(
        controller: "api/v1/accounts",
        action: "history"
      )
    end

    # Negative tests for unsupported methods
    it "does not route POST /api/v1/account" do
      expect(post: "/api/v1/account").not_to be_routable
    end

    it "does not route PUT /api/v1/account" do
      expect(put: "/api/v1/account").not_to be_routable
    end

    it "does not route PATCH /api/v1/account" do
      expect(patch: "/api/v1/account").not_to be_routable
    end

    it "does not route DELETE /api/v1/account" do
      expect(delete: "/api/v1/account").not_to be_routable
    end
  end

  describe 'health check route' do
    it 'routes to rails health check' do
      expect(get('/up')).to route_to('rails/health#show')
    end
  end
end
