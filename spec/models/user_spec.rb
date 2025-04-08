require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it 'has many points_events' do
      association = described_class.reflect_on_association(:points_events)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end
  end

  describe 'validations' do
    subject(:user) { described_class.new(name: 'Jane Smith', email_address: 'jane@example.com', points: 100) }

    context 'with valid attributes' do
      it 'is valid' do
        expect(user).to be_valid
      end
    end

    context 'when checking presence validations' do
      it 'requires name' do
        user.name = nil
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include("can't be blank")
      end

      it 'requires email_address' do
        user.email_address = nil
        expect(user).not_to be_valid
        expect(user.errors[:email_address]).to include("can't be blank")
      end

      it 'requires points' do
        user.points = nil
        expect(user).not_to be_valid
        expect(user.errors[:points]).to include("can't be blank")
      end
    end

    context 'when checking uniqueness validations' do
      it 'requires unique email_address' do
        described_class.create!(name: 'Existing User', email_address: 'jane@example.com', points: 0)
        expect(user).not_to be_valid
        expect(user.errors[:email_address]).to include('has already been taken')
      end
    end

    context 'when checking points numericality validations' do
      it 'rejects negative points' do
        user.points = -1
        expect(user).not_to be_valid
        expect(user.errors[:points]).to include('must be greater than or equal to 0')
      end

      it 'rejects non-integer points' do
        user.points = 5.5
        expect(user).not_to be_valid
        expect(user.errors[:points]).to include('must be an integer')
      end

      it 'accepts zero points' do
        user.points = 0
        expect(user).to be_valid
      end

      it 'accepts positive integer points' do
        user.points = 1000
        expect(user).to be_valid
      end
    end

    context 'when checking length validations' do
      it 'rejects name longer than 255 characters' do
        user.name = 'a' * 256
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include('is too long (maximum is 255 characters)')
      end

      it 'accepts name with 255 characters' do
        user.name = 'a' * 255
        expect(user).to be_valid
      end

      it 'rejects email_address longer than 255 characters' do
        user.email_address = "#{'a' * 255}@example.com"
        expect(user).not_to be_valid
        expect(user.errors[:email_address]).to include('is too long (maximum is 255 characters)')
      end

      it 'accepts email_address with 255 characters' do
        user.email_address = "#{'a' * 243}@example.com"
        expect(user).to be_valid
      end
    end

    context 'when checking email format validations' do
      valid_emails = [
        'test@example.com',
        'user.name+alias@example.co.uk',
        'user-name@sub.domain.com'
      ]

      invalid_emails = [
        'plainaddress',
        '@missingusername.com',
        'user@.com',
        'user name@example.com'
      ]

      valid_emails.each do |email|
        it "accepts valid email format: #{email}" do
          user.email_address = email
          expect(user).to be_valid
        end
      end

      invalid_emails.each do |email|
        it "rejects invalid email format: #{email}" do
          user.email_address = email
          expect(user).not_to be_valid
          expect(user.errors[:email_address]).to include('is invalid')
        end
      end
    end
  end

  describe 'dependent destroy' do
    it 'destroys associated points_events when user is destroyed' do
      user = described_class.create!(name: 'Test User', email_address: 'test@example.com', points: 0)
      bonus = Bonus.create!(name: 'Test Bonus', description: 'Test', points: 100)
      user.points_events.create!(source: bonus, points: 100)

      expect {
        user.destroy
      }.to change(PointsEvent, :count).by(-1)
    end
  end
end
