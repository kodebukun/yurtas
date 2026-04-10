require 'rails_helper'

RSpec.describe "WorkPosts", type: :request do
  let(:position) { create(:position) }
  let(:user) { create(:user, position_ids: [position.id]) }
  let(:work) { create(:work) }
  let(:work_with_display_name) { create(:work, :with_display_name) }
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

      it "display_nameがある係りの掲示板も200が返る" do
        login(user)
        get work_posts_url, params: { work_id: work_with_display_name.id }
        expect(response).to have_http_status(:ok)
      end

      it "display_nameがある場合、掲示板ページにdisplay_nameが表示される" do
        login(user)
        get work_posts_url, params: { work_id: work_with_display_name.id }
        expect(response.body).to include("事業場安全衛生")
        expect(response.body).not_to include("飯田地区事業場安全衛生")
      end
    end
  end

  describe "GET /work_posts/top" do
    context "ログイン済みのとき" do
      it "display_nameがある係りはdisplay_nameで表示される" do
        login(user)
        work_with_display_name  # 生成しておく
        get top_work_posts_url
        expect(response.body).to include("事業場安全衛生")
        expect(response.body).not_to include("飯田地区事業場安全衛生")
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

      it "display_nameがある係りの新規投稿ページも200が返る" do
        login(user)
        get new_work_post_url, params: { work_id: work_with_display_name.id }
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

  describe "POST /work_posts（係り投稿のcreate）" do
    let(:work_post_record) { create(:post, user: user, work: work) }

    context "ログイン済みで自分の係り投稿を削除するとき" do
      it "投稿が削除される" do
        login(user)
        work_post_record  # 生成しておく
        expect {
          delete work_post_url(work_post_record, work_id: work.id)
        }.to change(Post, :count).by(-1)
      end
    end
  end
end
