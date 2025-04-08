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

  describe 'health check route' do
    it 'routes to rails health check' do
      expect(get('/up')).to route_to('rails/health#show')
    end
  end
end
