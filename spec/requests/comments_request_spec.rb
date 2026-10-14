require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:position) { create(:position) }
  let(:user) { create(:user, position_ids: [position.id]) }
  let(:post_record) { create(:post, user: user) }
  let(:comment) { create(:comment, user_id: user.id, post_id: post_record.id) }

  # position_id: 5 は「卒業生」を表す固定ID（ensure_graduateが参照）
  let(:graduate_position) { create(:position, id: 5) }
  let(:graduate_user) { create(:user, position_ids: [graduate_position.id]) }

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

  describe "POST /comments" do
    context "未ログインのとき" do
      it "コメントが作成されず、rootにリダイレクトされる" do
        expect {
          post comments_url, params: { comment: { content: "テストコメント", post_id: post_record.id } }
        }.not_to change(Comment, :count)
        expect(response).to redirect_to(root_url)
      end
    end

    context "ログイン済みで有効なパラメータのとき" do
      it "コメントが作成され、投稿詳細にリダイレクトされる" do
        login(user)
        expect {
          post comments_url, params: { comment: { content: "テストコメント", post_id: post_record.id } }
        }.to change(Comment, :count).by(1)
        expect(Comment.last.user_id).to eq(user.id)
        expect(response).to redirect_to(post_url(post_record))
      end
    end

    context "contentが空のとき" do
      it "コメントが作成されず、newが再描画される" do
        login(user)
        expect {
          post comments_url, params: { comment: { content: "", post_id: post_record.id } }
        }.not_to change(Comment, :count)
        expect(response).to have_http_status(:ok)
      end
    end

    context "卒業生がログインしているとき" do
      it "コメントが作成されず、権限がありませんとなる" do
        login(graduate_user)
        expect {
          post comments_url, params: { comment: { content: "テストコメント", post_id: post_record.id } }
        }.not_to change(Comment, :count)
        expect(response).to redirect_to(index_url)
      end
    end
  end

  describe "PATCH /comments/:id" do
    context "未ログインのとき" do
      it "更新されず、rootにリダイレクトされる" do
        patch comment_url(comment), params: { comment: { content: "更新後のコメント" } }
        expect(comment.reload.content).not_to eq("更新後のコメント")
        expect(response).to redirect_to(root_url)
      end
    end

    context "本人がログインしているとき" do
      it "コメントが更新され、投稿詳細にリダイレクトされる" do
        login(user)
        patch comment_url(comment), params: { comment: { content: "更新後のコメント" } }
        expect(comment.reload.content).to eq("更新後のコメント")
        expect(response).to redirect_to(post_url(post_record))
      end
    end

    context "本人以外がログインしているとき" do
      it "更新されず、権限がありませんとなる" do
        other_position = create(:position)
        other_user = create(:user, position_ids: [other_position.id])
        login(other_user)
        patch comment_url(comment), params: { comment: { content: "更新後のコメント" } }
        expect(comment.reload.content).not_to eq("更新後のコメント")
        expect(response).to redirect_to(index_url)
      end
    end

    context "卒業生が自分のコメントを更新しようとしたとき" do
      it "更新されず、権限がありませんとなる" do
        graduate_comment = create(:comment, user_id: graduate_user.id, post_id: post_record.id)
        login(graduate_user)
        patch comment_url(graduate_comment), params: { comment: { content: "更新後のコメント" } }
        expect(graduate_comment.reload.content).not_to eq("更新後のコメント")
        expect(response).to redirect_to(index_url)
      end
    end
  end

  describe "DELETE /comments/:id" do
    context "未ログインのとき" do
      it "削除されず、rootにリダイレクトされる" do
        comment
        expect {
          delete comment_url(comment)
        }.not_to change(Comment, :count)
        expect(response).to redirect_to(root_url)
      end
    end

    context "本人がログインしているとき" do
      it "コメントが削除され、投稿詳細にリダイレクトされる" do
        comment
        login(user)
        expect {
          delete comment_url(comment)
        }.to change(Comment, :count).by(-1)
        expect(response).to redirect_to(post_url(post_record))
      end
    end

    context "本人以外がログインしているとき" do
      it "削除されず、権限がありませんとなる" do
        comment
        other_position = create(:position)
        other_user = create(:user, position_ids: [other_position.id])
        login(other_user)
        expect {
          delete comment_url(comment)
        }.not_to change(Comment, :count)
        expect(response).to redirect_to(index_url)
      end
    end

    context "卒業生が自分のコメントを削除しようとしたとき" do
      it "削除されず、権限がありませんとなる" do
        graduate_comment = create(:comment, user_id: graduate_user.id, post_id: post_record.id)
        login(graduate_user)
        expect {
          delete comment_url(graduate_comment)
        }.not_to change(Comment, :count)
        expect(response).to redirect_to(index_url)
      end
    end
  end
end
