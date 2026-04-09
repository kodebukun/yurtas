require 'rails_helper'

RSpec.describe "Attendances", type: :request do
  let(:position) { create(:position) }
  let(:user) { create(:user, position_ids: [position.id]) }

  def login(u)
    post '/login', params: { session: { login_id: u.login_id, password: 'password' } }
  end

  describe "PATCH /attendances/ranking_bulk_update" do
    # call: true でユーザーを作ると after_create で Ranking が自動生成される
    let!(:user1) { create(:user, position_ids: [position.id], call: true) }
    let!(:user2) { create(:user, position_ids: [position.id], call: true) }
    let!(:user3) { create(:user, position_ids: [position.id], call: true) }

    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        patch ranking_bulk_update_attendances_path,
              params: { user_ids: [user1.id, user2.id, user3.id] }
        expect(response).to redirect_to(root_url)
      end
    end

    context "ログイン済みのとき" do
      before { login(user) }

      context "user_idsが正しい順序で渡されたとき" do
        let(:new_order) { [user3.id, user1.id, user2.id] }

        it "ranking_attendances_urlにリダイレクトされる" do
          patch ranking_bulk_update_attendances_path,
                params: { user_ids: new_order }
          expect(response).to redirect_to(ranking_attendances_url)
        end

        it "タップ順にrankが1始まりで更新される" do
          patch ranking_bulk_update_attendances_path,
                params: { user_ids: new_order }
          expect(user3.ranking.reload.rank).to eq(1)
          expect(user1.ranking.reload.rank).to eq(2)
          expect(user2.ranking.reload.rank).to eq(3)
        end

        it "全Rankingレコードのrankが重複しない" do
          patch ranking_bulk_update_attendances_path,
                params: { user_ids: new_order }
          ranks = Ranking.where(user_id: new_order).pluck(:rank)
          expect(ranks.uniq.length).to eq(ranks.length)
        end
      end

      context "user_idsが空のとき" do
        it "ranking_attendances_urlにリダイレクトされる" do
          patch ranking_bulk_update_attendances_path, params: { user_ids: [] }
          expect(response).to redirect_to(ranking_attendances_url)
        end

        it "Rankingのrankは変化しない" do
          rank1_before = user1.ranking.rank
          patch ranking_bulk_update_attendances_path, params: { user_ids: [] }
          expect(user1.ranking.reload.rank).to eq(rank1_before)
        end
      end

      context "user_idsパラメーター自体が存在しないとき" do
        it "ranking_attendances_urlにリダイレクトされる" do
          patch ranking_bulk_update_attendances_path
          expect(response).to redirect_to(ranking_attendances_url)
        end
      end
    end
  end
end
