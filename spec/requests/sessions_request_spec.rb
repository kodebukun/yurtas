require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:position) { create(:position) }
  let(:user) { create(:user, position_ids: [position.id]) }

  describe "POST /login" do
    context "正しいログイン情報のとき" do
      it "indexにリダイレクトされる" do
        post '/login', params: { session: { login_id: user.login_id, password: 'password' } }
        expect(response).to redirect_to(index_url)
      end
    end

    context "パスワードが間違っているとき" do
      it "home/topが表示される" do
        post '/login', params: { session: { login_id: user.login_id, password: 'wrong' } }
        expect(response).to have_http_status(:ok)
      end
    end

    context "存在しないlogin_idのとき" do
      it "home/topが表示される" do
        post '/login', params: { session: { login_id: 'nonexistent', password: 'password' } }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "DELETE /logout" do
    it "rootにリダイレクトされる" do
      post '/login', params: { session: { login_id: user.login_id, password: 'password' } }
      delete '/logout'
      expect(response).to redirect_to(root_url)
    end
  end
end
