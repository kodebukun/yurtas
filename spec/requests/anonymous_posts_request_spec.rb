require 'rails_helper'

RSpec.describe "AnonymousPosts", type: :request do
  let(:position) { create(:position) }
  let(:user) { create(:user, position_ids: [position.id]) }

  def login(u)
    post '/login', params: { session: { login_id: u.login_id, password: 'password' } }
  end

  describe "GET /anonymous_posts" do
    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        get anonymous_posts_url
        expect(response).to redirect_to(root_url)
      end
    end

    context "ログイン済みのとき" do
      it "200が返る" do
        login(user)
        get anonymous_posts_url
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
