require 'rails_helper'

RSpec.describe "Breaches", type: :request do
  let(:position) { create(:position) }
  let(:user) { create(:user, position_ids: [position.id]) }
  let(:admin_user) { create(:user, admin: true, position_ids: [position.id]) }

  def login(u)
    post '/login', params: { session: { login_id: u.login_id, password: 'password' } }
  end

  describe "GET /breaches" do
    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        get breaches_url
        expect(response).to redirect_to(root_url)
      end
    end

    context "管理者でないとき" do
      it "indexにリダイレクトされる" do
        login(user)
        get breaches_url
        expect(response).to redirect_to(index_url)
      end
    end

    context "管理者のとき" do
      it "200が返る" do
        login(admin_user)
        get breaches_url
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
