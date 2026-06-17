require 'rails_helper'

RSpec.describe PageView, type: :model do
  let(:position) { create(:position) }
  let(:user) { create(:user, position_ids: [position.id]) }

  describe "アソシエーション" do
    it "userに属する" do
      pv = create(:page_view, user: user)
      expect(pv.user).to eq user
    end
  end

  describe "バリデーション" do
    it "user_idとpageがあれば有効" do
      pv = build(:page_view, user: user)
      expect(pv).to be_valid
    end

    it "userがなければ無効" do
      pv = build(:page_view, user: nil)
      expect(pv).not_to be_valid
    end
  end
end
