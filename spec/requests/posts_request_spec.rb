require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:position) { create(:position) }
  let(:user) { create(:user, position_ids: [position.id]) }
  let(:other_user) { create(:user, position_ids: [position.id]) }
  # post はリクエストスペックのHTTPメソッドと名前が衝突するため post_record を使用
  let(:post_record) { create(:post, user: user) }

  def login(u)
    post '/login', params: { session: { login_id: u.login_id, password: 'password' } }
  end

  describe "GET /posts" do
    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        get posts_url
        expect(response).to redirect_to(root_url)
      end
    end

    context "ログイン済みのとき" do
      it "200が返る" do
        login(user)
        get posts_url
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /posts/:id" do
    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        get post_url(post_record)
        expect(response).to redirect_to(root_url)
      end
    end

    context "ログイン済みのとき" do
      it "200が返る" do
        login(user)
        get post_url(post_record)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /posts/new" do
    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        get new_post_url
        expect(response).to redirect_to(root_url)
      end
    end

    context "ログイン済みのとき" do
      it "200が返る" do
        login(user)
        get new_post_url
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "DELETE /posts/:id" do
    context "投稿者本人のとき" do
      it "投稿が削除される" do
        login(user)
        post_record  # カウント計測前に生成しておく
        expect { delete post_url(post_record) }.to change(Post, :count).by(-1)
      end
    end

    context "投稿者でないとき" do
      it "postsにリダイレクトされる" do
        login(other_user)
        delete post_url(post_record)
        expect(response).to redirect_to(posts_url)
      end
    end
  end
end
