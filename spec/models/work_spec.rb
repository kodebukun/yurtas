require 'rails_helper'

RSpec.describe Work, type: :model do
  describe '#label' do
    context 'display_nameが設定されている場合' do
      it 'display_nameを返す' do
        work = build(:work, :with_display_name)
        expect(work.label).to eq("事業場安全衛生")
      end
    end

    context 'display_nameがnilの場合' do
      it 'nameを返す' do
        work = build(:work, name: "勉強会", display_name: nil)
        expect(work.label).to eq("勉強会")
      end
    end

    context 'display_nameが空文字の場合' do
      it 'nameを返す' do
        work = build(:work, name: "勉強会", display_name: "")
        expect(work.label).to eq("勉強会")
      end
    end
  end
end
