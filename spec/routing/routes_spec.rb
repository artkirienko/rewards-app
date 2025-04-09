require 'rails_helper'

RSpec.describe 'Routes', type: :routing do
  describe 'api v1 rewards routes' do
    it 'routes to #index' do
      expect(get('/api/v1/rewards')).to route_to('api/v1/rewards#index')
    end

    it 'routes to #show' do
      expect(get('/api/v1/rewards/1')).to route_to('api/v1/rewards#show', id: '1')
    end

    it "routes to #redeem" do
      expect(post: "/api/v1/rewards/1/redeem").to route_to("api/v1/rewards#redeem", reward_id: "1")
    end

    # Negative tests for unsupported methods
    it 'does not route to #create' do
      expect(post('/api/v1/rewards')).not_to be_routable
    end

    it 'does not route to #update via PUT' do
      expect(put('/api/v1/rewards/1')).not_to be_routable
    end

    it 'does not route to #update via PATCH' do
      expect(patch('/api/v1/rewards/1')).not_to be_routable
    end

    it 'does not route to #destroy' do
      expect(delete('/api/v1/rewards/1')).not_to be_routable
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
