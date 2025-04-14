require 'rails_helper'

RSpec.describe BonusesController, type: :controller do
  let(:valid_attributes) do
    {
      name: 'Test Bonus',
      description: 'A test bonus description',
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

  let(:bonus) { Bonus.create!(valid_attributes) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns all bonuses' do
      bonus
      get :index
      expect(JSON.parse(response.body).length).to eq(1)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: bonus.id }
      expect(response).to be_successful
    end

    it 'returns the requested bonus' do
      get :show, params: { id: bonus.id }
      expect(JSON.parse(response.body)['id']).to eq(bonus.id)
    end

    context 'when bonus is not found' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect {
          get :show, params: { id: -1 } # Use an ID guaranteed not to exist
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Bonus' do
        expect {
          post :create, params: { bonus: valid_attributes }
        }.to change(Bonus, :count).by(1)
      end

      it 'renders a JSON response with the new bonus' do
        post :create, params: { bonus: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors' do
        post :create, params: { bonus: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end

      it 'does not create a new Bonus' do
        expect {
          post :create, params: { bonus: invalid_attributes }
        }.not_to change(Bonus, :count)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          name: 'Updated Bonus',
          description: 'Updated description',
          points: 200
        }
      end

      it 'updates the requested bonus' do
        put :update, params: { id: bonus.id, bonus: new_attributes }
        bonus.reload
        expect(bonus.name).to eq('Updated Bonus')
      end

      it 'renders a JSON response with the bonus' do
        put :update, params: { id: bonus.id, bonus: new_attributes }
        expect(response).to be_successful
        expect(response.content_type).to include('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors' do
        put :update, params: { id: bonus.id, bonus: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested bonus' do
      bonus
      expect {
        delete :destroy, params: { id: bonus.id }
      }.to change(Bonus, :count).by(-1)
    end

    it 'returns a no content response' do
      delete :destroy, params: { id: bonus.id }
      expect(response).to have_http_status(:no_content)
    end
  end
end
