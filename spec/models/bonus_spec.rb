require 'rails_helper'

RSpec.describe Bonus, type: :model do
  let(:valid_attributes) do
    {
      name: "Test Bonus",
      description: "A test bonus description",
      points: 50
    }
  end

  describe 'validations' do
    subject(:bonus) { described_class.new(valid_attributes) }

    it 'is valid with valid attributes' do
      expect(bonus).to be_valid
    end

    context 'when validating name' do
      it 'requires a name' do
        bonus.name = nil
        expect(bonus).not_to be_valid
        expect(bonus.errors[:name]).to include("can't be blank")
      end

      it 'rejects names longer than 255 characters' do
        bonus.name = "a" * 256
        expect(bonus).not_to be_valid
        expect(bonus.errors[:name]).to include("is too long (maximum is 255 characters)")
      end

      it 'accepts names exactly 255 characters' do
        bonus.name = "a" * 255
        expect(bonus).to be_valid
      end
    end

    context 'when validating description' do
      it 'requires a description' do
        bonus.description = nil
        expect(bonus).not_to be_valid
        expect(bonus.errors[:description]).to include("can't be blank")
      end

      it 'rejects descriptions longer than 500 characters' do
        bonus.description = "a" * 501
        expect(bonus).not_to be_valid
        expect(bonus.errors[:description]).to include("is too long (maximum is 500 characters)")
      end

      it 'accepts descriptions exactly 500 characters' do
        bonus.description = "a" * 500
        expect(bonus).to be_valid
      end
    end

    context 'when validating points' do
      it 'requires points' do
        bonus.points = nil
        expect(bonus).not_to be_valid
        expect(bonus.errors[:points]).to include("is not a number")
      end

      it 'rejects non-numeric points' do
        bonus.points = "not_a_number"
        expect(bonus).not_to be_valid
        expect(bonus.errors[:points]).to include("is not a number")
      end

      it 'rejects non-integer points' do
        bonus.points = 5.5
        expect(bonus).not_to be_valid
        expect(bonus.errors[:points]).to include("must be an integer")
      end

      it 'rejects negative points' do
        bonus.points = -1
        expect(bonus).not_to be_valid
        expect(bonus.errors[:points]).to include("must be greater than or equal to 0")
      end

      it 'accepts zero points' do
        bonus.points = 0
        expect(bonus).to be_valid
      end

      it 'accepts positive integer points' do
        bonus.points = 100
        expect(bonus).to be_valid
      end
    end
  end

  describe 'associations' do
    let(:bonus) { described_class.create!(valid_attributes) }
    let(:user) { User.create!(name: "Test User", email_address: "test@example.com", points: 0) }

    it 'has many points_events' do
      expect(described_class.reflect_on_association(:points_events).macro).to eq(:has_many)
    end

    it 'can have associated points_events' do
      points_event = PointsEvent.create!(
        user: user,
        source: bonus,
        points: bonus.points
      )
      expect(bonus.points_events).to include(points_event)
    end

    it 'destroys associated points_events when destroyed' do
      PointsEvent.create!(
        user: user,
        source: bonus,
        points: bonus.points
      )
      expect { bonus.destroy }.to change(PointsEvent, :count).by(-1)
    end
  end
end
