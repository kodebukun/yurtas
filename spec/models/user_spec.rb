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
end
