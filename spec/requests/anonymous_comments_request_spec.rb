require 'rails_helper'

RSpec.describe "AnonymousComments", type: :request do
  let(:position) { create(:position) }
  let(:user) { create(:user, position_ids: [position.id]) }
  let(:anonymous_post) { create(:anonymous_post, user_id: user.id) }

  def login(u)
    post '/login', params: { session: { login_id: u.login_id, password: 'password' } }
  end

  describe "GET /anonymous_comments/new" do
    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        get new_anonymous_comment_url
        expect(response).to redirect_to(root_url)
      end
    end

    context "ログイン済みのとき" do
      it "200が返る" do
        login(user)
        get new_anonymous_comment_url, params: { post_id: anonymous_post.id }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
