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

  describe '.search' do
    let!(:title_hit) { create(:post, user: user, title: '放射線安全講習のお知らせ', content: '詳細は後日') }
    let!(:content_hit) { create(:post, user: user, title: '連絡事項', content: '来週は放射線の勉強会です') }
    let!(:no_hit) { create(:post, user: user, title: '忘年会', content: '会場は未定') }

    it 'タイトルに一致する投稿を返す' do
      expect(Post.search('講習')).to contain_exactly(title_hit)
    end

    it '本文に一致する投稿を返す' do
      expect(Post.search('勉強会')).to contain_exactly(content_hit)
    end

    it 'タイトルと本文の両方を対象に検索する' do
      expect(Post.search('放射線')).to contain_exactly(title_hit, content_hit)
    end

    it '半角スペース区切りでAND検索になる' do
      expect(Post.search('放射線 勉強会')).to contain_exactly(content_hit)
    end

    it '全角スペース区切りでもAND検索になる' do
      expect(Post.search('放射線　勉強会')).to contain_exactly(content_hit)
    end

    it '大文字・小文字を区別しない' do
      mri = create(:post, user: user, title: 'MRI点検', content: '本文')
      expect(Post.search('mri')).to contain_exactly(mri)
    end

    it '%や_をワイルドカードとして扱わない' do
      percent = create(:post, user: user, title: '稼働率100%', content: '本文')
      expect(Post.search('100%')).to contain_exactly(percent)
      expect(Post.search('%')).to contain_exactly(percent)
      expect(Post.search('_')).to be_empty
    end

    it 'キーワードが空のときは絞り込まない' do
      expect(Post.search('')).to contain_exactly(title_hit, content_hit, no_hit)
      expect(Post.search(nil)).to contain_exactly(title_hit, content_hit, no_hit)
      expect(Post.search(' 　')).to contain_exactly(title_hit, content_hit, no_hit)
    end
  end

  describe '.visible_to' do
    let(:my_work) { create(:work) }
    let(:other_work) { create(:work) }
    let(:department) { create(:department) }

    let!(:general_post) { create(:post, user: user, meeting: true) }
    let!(:department_post) { create(:post, user: user, department: department, meeting: false) }
    let!(:my_work_private) { create(:post, user: user, work: my_work, meeting: false) }
    let!(:other_work_private) { create(:post, user: user, work: other_work, meeting: false) }
    let!(:other_work_public) { create(:post, user: user, work: other_work, meeting: true) }

    before { user.works << my_work }

    it '所属していない係りの非公開投稿以外を返す' do
      expect(Post.visible_to(user)).to contain_exactly(
        general_post, department_post, my_work_private, other_work_public
      )
    end

    it '係りに所属していないユーザーには係りの非公開投稿を返さない' do
      no_work_user = create(:user)
      expect(Post.visible_to(no_work_user)).to contain_exactly(
        general_post, department_post, other_work_public
      )
    end
  end
end
