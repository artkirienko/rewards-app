require 'rails_helper'

RSpec.describe Reward, type: :model do
  subject(:reward) { described_class.new(valid_attributes) }

  let(:valid_attributes) do
    {
      name: "Test Reward",
      description: "A test reward description",
      points: 50
    }
  end

  describe 'validations' do
    it 'is valid with all required attributes' do
      expect(reward).to be_valid
    end

    context 'when validating name' do
      it 'requires a name' do
        reward.name = nil
        expect(reward).not_to be_valid
        expect(reward.errors[:name]).to include("can't be blank")
      end

      it 'rejects names longer than 255 characters' do
        reward.name = "a" * 256
        expect(reward).not_to be_valid
        expect(reward.errors[:name]).to include("is too long (maximum is 255 characters)")
      end

      it 'accepts names exactly 255 characters' do
        reward.name = "a" * 255
        expect(reward).to be_valid
      end
    end

    context 'when validating description' do
      it 'requires a description' do
        reward.description = nil
        expect(reward).not_to be_valid
        expect(reward.errors[:description]).to include("can't be blank")
      end

      it 'rejects descriptions longer than 500 characters' do
        reward.description = "a" * 501
        expect(reward).not_to be_valid
        expect(reward.errors[:description]).to include("is too long (maximum is 500 characters)")
      end

      it 'accepts descriptions exactly 500 characters' do
        reward.description = "a" * 500
        expect(reward).to be_valid
      end
    end

    context 'when validating points' do
      it 'requires points to be present' do
        reward.points = nil
        expect(reward).not_to be_valid
        expect(reward.errors[:points]).to include("is not a number")
      end

      it 'requires points to be an integer' do
        reward.points = 5.5
        expect(reward).not_to be_valid
        expect(reward.errors[:points]).to include("must be an integer")
      end

      it 'rejects negative points' do
        reward.points = -10
        expect(reward).not_to be_valid
        expect(reward.errors[:points]).to include("must be greater than or equal to 0")
      end

      it 'accepts zero points' do
        reward.points = 0
        expect(reward).to be_valid
      end

      it 'accepts positive integer points' do
        reward.points = 100
        expect(reward).to be_valid
      end

      it 'rejects non-numeric points' do
        reward.points = "not_a_number"
        expect(reward).not_to be_valid
        expect(reward.errors[:points]).to include("is not a number")
      end
    end
  end

  describe 'associations' do
    it 'has many points_events' do
      association = described_class.reflect_on_association(:points_events)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:as]).to eq(:source)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'can have associated points_events' do
      reward = described_class.create!(valid_attributes)
      user = create(:user)

      points_event = PointsEvent.new(
        user_id: user.id,
        source_type: "Reward",
        source_id: reward.id,
        points: 50
      )

      expect(points_event.save).to be true
      expect(reward.points_events).to include(points_event)
    end
  end
end
