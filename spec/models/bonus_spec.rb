require 'rails_helper'

RSpec.describe Bonus, type: :model do
  let(:valid_attributes) do
    {
      name: "Sample Bonus",
      description: "This is a description for the sample bonus.",
      points: 100
    }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      bonus = described_class.new(valid_attributes)
      expect(bonus).to be_valid
    end

    it 'is not valid without a name' do
      attributes = valid_attributes.merge(name: nil)
      bonus = described_class.new(attributes)
      expect(bonus).not_to be_valid
      expect(bonus.errors[:name]).to include("can't be blank")
    end

    it 'is not valid with a name longer than 255 characters' do
      attributes = valid_attributes.merge(name: 'a' * 256) # Generate a string of 256 'a's
      bonus = described_class.new(attributes)
      expect(bonus).not_to be_valid
      expect(bonus.errors[:name]).to include("is too long (maximum is 255 characters)")
    end

    it 'is valid with a name of exactly 255 characters' do
      attributes = valid_attributes.merge(name: 'a' * 255)
      bonus = described_class.new(attributes)
      expect(bonus).to be_valid
    end

    it 'is not valid without a description' do
      attributes = valid_attributes.merge(description: nil)
      bonus = described_class.new(attributes)
      expect(bonus).not_to be_valid
      expect(bonus.errors[:description]).to include("can't be blank")
    end

    it 'is not valid with a description longer than 500 characters' do
      attributes = valid_attributes.merge(description: 'a' * 501)
      bonus = described_class.new(attributes)
      expect(bonus).not_to be_valid
      expect(bonus.errors[:description]).to include("is too long (maximum is 500 characters)")
    end

    it 'is valid with a description of exactly 500 characters' do
      attributes = valid_attributes.merge(description: 'a' * 500)
      bonus = described_class.new(attributes)
      expect(bonus).to be_valid
    end

    it 'is not valid if points is not a number' do
      attributes = valid_attributes.merge(points: 'abc') # Non-numeric string
      bonus = described_class.new(attributes)
      expect(bonus).not_to be_valid
      expect(bonus.errors[:points]).to include("is not a number")
    end

    it 'is not valid if points is not an integer' do
      attributes = valid_attributes.merge(points: 10.5) # Float
      bonus = described_class.new(attributes)
      expect(bonus).not_to be_valid
      expect(bonus.errors[:points]).to include("must be an integer")
    end

    it 'is not valid if points is less than 0' do
      attributes = valid_attributes.merge(points: -1)
      bonus = described_class.new(attributes)
      expect(bonus).not_to be_valid
      expect(bonus.errors[:points]).to include("must be greater than or equal to 0")
    end

    it 'is valid if points is 0' do
      attributes = valid_attributes.merge(points: 0)
      bonus = described_class.new(attributes)
      expect(bonus).to be_valid
    end

    it 'is valid if points is a positive integer' do
      attributes = valid_attributes.merge(points: 1000)
      bonus = described_class.new(attributes)
      expect(bonus).to be_valid
    end

    it 'is not valid if points is nil' do
      attributes = valid_attributes.merge(points: nil)
      bonus = described_class.new(attributes)
      expect(bonus).not_to be_valid
      expect(bonus.errors[:points]).to include("is not a number")
    end
  end
end
