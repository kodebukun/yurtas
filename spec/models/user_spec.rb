require 'rails_helper'

RSpec.describe User, type: :model do
  let(:position) { create(:position) }
  let(:user) { build(:user, position_ids: [position.id]) }

  describe 'バリデーション' do
    it '有効なユーザーは有効' do
      expect(user).to be_valid
    end

    it 'nameが空だと無効' do
      user.name = ''
      expect(user).not_to be_valid
      expect(user.errors[:name]).to be_present
    end

    it 'nameが30文字を超えると無効' do
      user.name = 'a' * 31
      expect(user).not_to be_valid
      expect(user.errors[:name]).to be_present
    end

    it 'login_idが空だと無効' do
      user.login_id = ''
      expect(user).not_to be_valid
      expect(user.errors[:login_id]).to be_present
    end

    it 'login_idが重複していると無効' do
      create(:user, login_id: 99999, position_ids: [position.id])
      user.login_id = 99999
      expect(user).not_to be_valid
      expect(user.errors[:login_id]).to be_present
    end

    it 'position_idsが空だと無効' do
      user.position_ids = []
      expect(user).not_to be_valid
      expect(user.errors[:position_ids]).to be_present
    end
  end

  describe 'add_to_ranking コールバック（create時）' do
    context 'call: true でユーザーを作成したとき' do
      it 'Rankingレコードが作成される' do
        expect {
          create(:user, position_ids: [position.id], call: true)
        }.to change(Ranking, :count).by(1)
      end

      it '既存ランキングの最下位（最大rank+1）に追加される' do
        first_user = create(:user, position_ids: [position.id], call: true)
        new_user = create(:user, position_ids: [position.id], call: true)
        expect(new_user.ranking.rank).to eq(first_user.ranking.rank + 1)
      end

      it 'Rankingが1件も無い場合はrank=1で追加される' do
        Ranking.delete_all
        new_user = create(:user, position_ids: [position.id], call: true)
        expect(new_user.ranking.rank).to eq(1)
      end
    end

    context 'call: false でユーザーを作成したとき' do
      it 'Rankingレコードは作成されない' do
        expect {
          create(:user, position_ids: [position.id], call: false)
        }.not_to change(Ranking, :count)
      end
    end
  end

  describe 'sync_ranking コールバック' do
    let!(:user_in_call) { create(:user, position_ids: [position.id], call: true) }

    context 'call が false → true に変わったとき' do
      let!(:target_user) { create(:user, position_ids: [position.id], call: false) }

      it 'Rankingレコードが作成される' do
        expect {
          target_user.update!(call: true)
        }.to change(Ranking, :count).by(1)
      end

      it '既存ランキングの最下位（最大rank+1）に追加される' do
        target_user.update!(call: true)
        expect(target_user.ranking.rank).to eq(user_in_call.ranking.rank + 1)
      end

      it 'Rankingが1件も無い場合はrank=1で追加される' do
        Ranking.delete_all
        target_user.update!(call: true)
        expect(target_user.ranking.rank).to eq(1)
      end
    end

    context 'call が true → false に変わったとき' do
      # user_in_call は after_create で rank=1 が自動作成される
      let!(:user2) { create(:user, position_ids: [position.id], call: true) }
      let!(:user3) { create(:user, position_ids: [position.id], call: true) }

      it 'Rankingレコードが削除される' do
        expect {
          user_in_call.update!(call: false)
        }.to change(Ranking, :count).by(-1)
      end

      it '削除されたユーザーのRankingが存在しなくなる' do
        user_in_call.update!(call: false)
        expect(Ranking.find_by(user_id: user_in_call.id)).to be_nil
      end

      it '後続のランクが1ずつ詰まる' do
        rank2_before = user2.ranking.rank
        rank3_before = user3.ranking.rank
        user_in_call.update!(call: false)
        expect(user2.ranking.reload.rank).to eq(rank2_before - 1)
        expect(user3.ranking.reload.rank).to eq(rank3_before - 1)
      end
    end

    context 'call 以外の属性を更新したとき' do
      let!(:target_user) { create(:user, position_ids: [position.id], call: false) }

      it 'Rankingテーブルは変化しない' do
        expect {
          target_user.update!(name: '別の名前')
        }.not_to change(Ranking, :count)
      end
    end
  end
end
