require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:position) { create(:position) }
  let(:user) { create(:user, position_ids: [position.id]) }
  let(:post_record) { create(:post, user: user) }
  let(:comment) { create(:comment, user_id: user.id, post_id: post_record.id) }

  def login(u)
    post '/login', params: { session: { login_id: u.login_id, password: 'password' } }
  end

  describe "GET /comments/new" do
    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        get new_comment_url
        expect(response).to redirect_to(root_url)
      end
    end

    context "ログイン済みのとき" do
      it "200が返る" do
        login(user)
        get new_comment_url
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /comments/:id/edit" do
    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        get edit_comment_url(comment)
        expect(response).to redirect_to(root_url)
      end
    end

    context "ログイン済みのとき" do
      it "200が返る" do
        login(user)
        get edit_comment_url(comment)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
