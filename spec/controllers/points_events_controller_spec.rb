require 'rails_helper'

RSpec.describe PointsEventsController, type: :controller do
  let(:user) { User.create!(name: 'Test User', email_address: 'test@example.com', points: 0) }
  let(:bonus) { Bonus.create!(name: 'Test Bonus', description: 'Test Description', points: 100) }
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
  let(:points_event) do
    PointsEvent.create!(
      user_id: user.id,
      source_id: bonus.id,
      source_type: 'Bonus',
      points: 50
    )
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns all points events' do
      PointsEvent.create!(
        user_id: user.id,
        source_id: bonus.id,
        source_type: 'Bonus',
        points: 25
      )
      PointsEvent.create!(
        user_id: user.id,
        source_id: bonus.id,
        source_type: 'Bonus',
        points: 75
      )
      get :index
      expect(JSON.parse(response.body).length).to eq(2)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: points_event.id }
      expect(response).to be_successful
    end

    it 'returns the requested points event' do
      get :show, params: { id: points_event.id }
      expect(JSON.parse(response.body)['id']).to eq(points_event.id)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new PointsEvent' do
        expect {
          post :create, params: { points_event: valid_attributes }
        }.to change(PointsEvent, :count).by(1)
      end

      it 'renders a JSON response with the new points_event' do
        post :create, params: { points_event: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)['points']).to eq(100)
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors' do
        post :create, params: { points_event: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          points: 200
        }
      end

      it 'updates the requested points_event' do
        put :update, params: { id: points_event.id, points_event: new_attributes }
        points_event.reload
        expect(points_event.points).to eq(200)
      end

      it 'renders a JSON response with the points_event' do
        put :update, params: { id: points_event.id, points_event: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors' do
        put :update, params: { id: points_event.id, points_event: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested points_event' do
      points_event_to_delete = points_event
      expect {
        delete :destroy, params: { id: points_event_to_delete.id }
      }.to change(PointsEvent, :count).by(-1)
    end

    it 'returns a no content response' do
      delete :destroy, params: { id: points_event.id }
      expect(response).to have_http_status(:no_content)
    end
  end
end
