require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject(:user) { described_class.new(name: 'John Doe', email_address: 'john.doe@example.com', points: 10) }

    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    shared_examples_for 'is not valid without' do |attribute, error_message|
      it "is not valid without #{attribute}" do
        user.send("#{attribute}=", nil) # Dynamically set attribute to nil
        expect(user).not_to be_valid
        expect(user.errors[attribute]).to include(error_message)
      end
    end

    it_behaves_like 'is not valid without', :name, "can't be blank"
    it_behaves_like 'is not valid without', :email_address, "can't be blank"

    it 'is not valid with a duplicate email_address' do
      described_class.create!(name: 'John Doe', email_address: 'john.doe@example.com', points: 10)
      user.email_address = 'john.doe@example.com'
      expect(user).not_to be_valid
      expect(user.errors[:email_address]).to include('has already been taken')
    end

    it 'is not valid with negative points' do
      user.points = -5
      expect(user).not_to be_valid
      expect(user.errors[:points]).to include('must be greater than or equal to 0')
    end

    it 'is not valid with non-integer points' do
      user.points = 10.5
      expect(user).not_to be_valid
      expect(user.errors[:points]).to include('must be an integer')
    end

    describe 'length validations' do
      it 'is not valid with a name exceeding 255 characters' do
        user.name = 'a' * 256
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include('is too long (maximum is 255 characters)')
      end

      it 'is not valid with an email_address exceeding 255 characters' do
        user.email_address = "#{'a' * 255}@example.com"
        expect(user).not_to be_valid
        expect(user.errors[:email_address]).to include('is too long (maximum is 255 characters)')
      end
    end

    describe 'email format validation' do
      it 'is not valid with an invalid email format' do
        invalid_emails = [ 'invalid', 'invalid@' ]
        invalid_emails.each do |email|
          user.email_address = email
          expect(user).not_to be_valid
          expect(user.errors[:email_address]).to include('is invalid')
        end
      end

      it 'is valid with a valid email format' do
        valid_emails = [ 'valid@example.com', 'valid.user@example.com', 'valid+user@example.com', 'v@example.com' ]
        valid_emails.each do |email|
          user.email_address = email
          expect(user).to be_valid
        end
      end
    end
  end
end
