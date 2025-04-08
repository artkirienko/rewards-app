require 'rails_helper'

RSpec.describe PointsEvent, type: :model do
  subject(:points_event) {
    described_class.new(
      user: user,
      source: bonus,
      points: 100
    )
  }

  let(:user) { User.create(name: "Test User", email_address: "test#{rand(1000)}@example.com", points: 0) }
  let(:bonus) { Bonus.create(name: "Test Bonus", description: "Test Description", points: 100) }
  let(:reward) { Reward.create(name: "Test Reward", description: "Test Description", points: 50) }

  describe "associations" do
    it "belongs to user" do
      expect(described_class.reflect_on_association(:user).macro).to eq(:belongs_to)
      expect(described_class.reflect_on_association(:user).options[:optional]).to be_nil
    end

    it "belongs to polymorphic source" do
      expect(described_class.reflect_on_association(:source).macro).to eq(:belongs_to)
      expect(described_class.reflect_on_association(:source).options[:polymorphic]).to be true
    end
  end

  describe "validations" do
    it "is valid with valid attributes" do
      expect(points_event).to be_valid
    end

    describe "points" do
      it "requires points" do
        points_event.points = nil
        expect(points_event).not_to be_valid
        expect(points_event.errors[:points]).to include("can't be blank")
      end

      it "requires points to be an integer" do
        points_event.points = 10.5
        expect(points_event).not_to be_valid
        expect(points_event.errors[:points]).to include("must be an integer")

        points_event.points = "not a number"
        expect(points_event).not_to be_valid
        expect(points_event.errors[:points]).to include("is not a number")
      end
    end

    describe "user" do
      it "requires a user" do
        points_event.user = nil
        expect(points_event).not_to be_valid
        expect(points_event.errors[:user]).to include("must exist")
      end
    end

    describe "source" do
      it "requires a source" do
        points_event.source = nil
        expect(points_event).not_to be_valid
        expect(points_event.errors[:source]).to include("must exist")
      end

      it "accepts Bonus as source" do
        points_event = described_class.new(
          user: user,
          source: bonus,
          points: 100
        )
        expect(points_event).to be_valid
        expect(points_event.source_type).to eq("Bonus")
      end

      it "accepts Reward as source" do
        points_event = described_class.new(
          user: user,
          source: reward,
          points: -50
        )
        expect(points_event).to be_valid
        expect(points_event.source_type).to eq("Reward")
      end
    end
  end
end
