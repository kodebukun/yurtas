require 'rails_helper'

RSpec.describe Ranking, type: :model do
  let(:position) { create(:position) }
  let(:user) { create(:user, position_ids: [position.id]) }
  let(:ranking) { build(:ranking, user: user) }

  describe 'バリデーション' do
    it '有効なランキングは有効' do
      expect(ranking).to be_valid
    end

    it 'rankが空だと無効' do
      ranking.rank = nil
      expect(ranking).not_to be_valid
      expect(ranking.errors[:rank]).to be_present
    end

    it 'user_idが空だと無効' do
      ranking.user_id = nil
      expect(ranking).not_to be_valid
      expect(ranking.errors[:user_id]).to be_present
    end

    it '同じuser_idのRankingは2件作れない' do
      ranking.save!
      duplicate = build(:ranking, user: user, rank: 2)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:user_id]).to be_present
    end
  end
end
