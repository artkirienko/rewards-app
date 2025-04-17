# spec/services/reward_redeemer_spec.rb
require 'rails_helper'

RSpec.describe RewardRedeemer do
  describe '#call' do
    let(:user) { create(:user, points: 100) }
    let(:reward) { create(:reward, points: 50) }
    let(:service) { described_class.new(user, reward) }

    context 'when user has enough points' do
      it 'successfully redeems the reward' do
        result = service.call

        expect(result.success?).to be true
        expect(result.points_left).to eq(50)
        expect(result.points_used).to eq(50)

        user.reload
        expect(user.points).to eq(50)

        points_event = PointsEvent.last
        expect(points_event).to have_attributes(
          user_id: user.id,
          source_type: 'Reward',
          source_id: reward.id,
          points: -50
        )
      end
    end

    context 'when user does not have enough points' do
      let(:user) { create(:user, points: 30) }

      it 'returns failure with appropriate message' do
        result = service.call

        expect(result.success?).to be false
        expect(result.error).to eq('Not enough points')

        user.reload
        expect(user.points).to eq(30)
        expect(PointsEvent.count).to eq(0)
      end
    end

    context 'when database operation fails' do
      before do
        allow(PointsEvent).to receive(:create!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'returns failure and rolls back transaction' do
        result = service.call

        expect(result.success?).to be false
        expect(result.error).to be_present

        user.reload
        expect(user.points).to eq(100)
        expect(PointsEvent.count).to eq(0)
      end
    end

    context 'when redeeming with exact points' do
      let(:user) { create(:user, points: 50) }
      let(:reward) { create(:reward, points: 50) }

      it 'redeems successfully leaving zero points' do
        result = service.call

        expect(result.success?).to be true
        expect(result.points_left).to eq(0)
        expect(result.points_used).to eq(50)

        user.reload
        expect(user.points).to eq(0)
      end
    end

    context 'when redeeming a zero-point reward' do
      let(:reward) { create(:reward, points: 0) }

      it 'redeems successfully with no points change' do
        result = service.call

        expect(result.success?).to be true
        expect(result.points_left).to eq(100)
        expect(result.points_used).to eq(0)

        user.reload
        expect(user.points).to eq(100)
      end
    end
  end
end
