require 'rails_helper'

RSpec.describe Incident, type: :model do
  let(:user) { create(:user) }
  let(:department) { create(:department) }
  let(:incident) { build(:incident, user: user, department: department) }

  describe 'バリデーション' do
    it '有効なincidentは有効' do
      expect(incident).to be_valid
    end

    it 'shiftが空だと無効' do
      incident.shift = ''
      expect(incident).not_to be_valid
      expect(incident.errors[:shift]).to be_present
    end

    it 'occurred_atが空だと無効' do
      incident.occurred_at = nil
      expect(incident).not_to be_valid
      expect(incident.errors[:occurred_at]).to be_present
    end

    it 'titleが空だと無効' do
      incident.title = ''
      expect(incident).not_to be_valid
      expect(incident.errors[:title]).to be_present
    end

    it 'placeが空だと無効' do
      incident.place = ''
      expect(incident).not_to be_valid
      expect(incident.errors[:place]).to be_present
    end

    it 'placeが140文字を超えると無効' do
      incident.place = 'a' * 141
      expect(incident).not_to be_valid
      expect(incident.errors[:place]).to be_present
    end

    it 'yearsが空だと無効' do
      incident.years = nil
      expect(incident).not_to be_valid
      expect(incident.errors[:years]).to be_present
    end

    it 'targetが空だと無効' do
      incident.target = ''
      expect(incident).not_to be_valid
      expect(incident.errors[:target]).to be_present
    end

    it 'happenedが空だと無効' do
      incident.happened = ''
      expect(incident).not_to be_valid
      expect(incident.errors[:happened]).to be_present
    end

    it 'happenedが140文字を超えると無効' do
      incident.happened = 'a' * 141
      expect(incident).not_to be_valid
      expect(incident.errors[:happened]).to be_present
    end

    it 'excuseが空だと無効' do
      incident.excuse = ''
      expect(incident).not_to be_valid
      expect(incident.errors[:excuse]).to be_present
    end

    it 'user_idが空だと無効' do
      incident.user = nil
      expect(incident).not_to be_valid
      expect(incident.errors[:user]).to be_present
    end
  end
end
