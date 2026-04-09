require 'rails_helper'

RSpec.describe "WorkPosts", type: :request do
  let(:position) { create(:position) }
  let(:user) { create(:user, position_ids: [position.id]) }
  let(:work) { create(:work) }
  let(:post_record) { create(:post, user: user) }

  def login(u)
    post '/login', params: { session: { login_id: u.login_id, password: 'password' } }
  end

  describe "GET /work_posts" do
    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        get work_posts_url
        expect(response).to redirect_to(root_url)
      end
    end

    context "ログイン済みのとき" do
      it "200が返る" do
        login(user)
        get work_posts_url, params: { work_id: work.id }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /work_posts/new" do
    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        get new_work_post_url
        expect(response).to redirect_to(root_url)
      end
    end

    context "ログイン済みのとき" do
      it "200が返る" do
        login(user)
        get new_work_post_url, params: { work_id: work.id }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /work_posts/:id/edit" do
    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        get edit_work_post_url(post_record)
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
