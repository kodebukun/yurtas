require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }
  let(:post) { build(:post, user: user) }

  describe 'バリデーション' do
    it '有効なpostは有効' do
      expect(post).to be_valid
    end

    it 'titleが空だと無効' do
      post.title = ''
      expect(post).not_to be_valid
      expect(post.errors[:title]).to be_present
    end

    it 'titleが140文字を超えると無効' do
      post.title = 'a' * 141
      expect(post).not_to be_valid
      expect(post.errors[:title]).to be_present
    end

    it 'contentが空だと無効' do
      post.content = ''
      expect(post).not_to be_valid
      expect(post.errors[:content]).to be_present
    end

    it 'user_idが空だと無効' do
      post.user = nil
      expect(post).not_to be_valid
      expect(post.errors[:user]).to be_present
    end
  end
end
