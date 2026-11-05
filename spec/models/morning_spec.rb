require 'rails_helper'

RSpec.describe Morning, type: :model do
  let(:user) { create(:user) }

  describe '.search' do
    let!(:title_hit) { create(:morning, user: user, title: '11/5 朝ミーティング', content: '特になし') }
    let!(:content_hit) { create(:morning, user: user, title: '11/6 朝ミーティング', content: 'CT装置の点検があります') }

    it 'タイトルと本文の両方を対象に検索する' do
      expect(Morning.search('11/5')).to contain_exactly(title_hit)
      expect(Morning.search('ct')).to contain_exactly(content_hit)
    end

    it 'スペース区切りでAND検索になる' do
      expect(Morning.search('朝ミーティング　点検')).to contain_exactly(content_hit)
    end

    it 'キーワードが空のときは絞り込まない' do
      expect(Morning.search('')).to contain_exactly(title_hit, content_hit)
    end
  end
end
