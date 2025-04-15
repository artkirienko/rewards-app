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

  describe 'rewards routes' do
    it 'routes to #index' do
      expect(get('/rewards')).to route_to('rewards#index')
    end

    it 'routes to #show' do
      expect(get('/rewards/1')).to route_to('rewards#show', id: '1')
    end

    it 'routes to #create' do
      expect(post('/rewards')).to route_to('rewards#create')
    end

    it 'routes to #update via PUT' do
      expect(put('/rewards/1')).to route_to('rewards#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch('/rewards/1')).to route_to('rewards#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete('/rewards/1')).to route_to('rewards#destroy', id: '1')
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

  describe 'health check route' do
    it 'routes to rails health check' do
      expect(get('/up')).to route_to('rails/health#show')
    end
  end
end
