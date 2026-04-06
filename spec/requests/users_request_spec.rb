require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:position) { create(:position) }
  let(:user) { create(:user, position_ids: [position.id]) }
  let(:admin_user) { create(:user, admin: true, position_ids: [position.id]) }
  let(:other_user) { create(:user, position_ids: [position.id]) }

  def login(u)
    post '/login', params: { session: { login_id: u.login_id, password: 'password' } }
  end

  describe "GET /users" do
    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        get users_url
        expect(response).to redirect_to(root_url)
      end
    end

    context "ログイン済みのとき" do
      it "200が返る" do
        login(user)
        get users_url
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /users/:id" do
    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        get user_url(user)
        expect(response).to redirect_to(root_url)
      end
    end

    context "ログイン済みのとき" do
      it "200が返る" do
        login(user)
        get user_url(user)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /users/new" do
    context "管理者でないとき" do
      it "rootにリダイレクトされる" do
        login(user)
        get new_user_url
        expect(response).to redirect_to(root_url)
      end
    end

    context "管理者のとき" do
      it "200が返る" do
        login(admin_user)
        get new_user_url
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /users/:id/edit" do
    context "本人のとき" do
      it "200が返る" do
        login(user)
        get edit_user_url(user)
        expect(response).to have_http_status(:ok)
      end
    end

    context "他のユーザーのとき" do
      it "indexにリダイレクトされる" do
        login(user)
        get edit_user_url(other_user)
        expect(response).to redirect_to(index_url)
      end
    end
  end

  describe "POST /users" do
    let(:valid_params) do
      {
        user: {
          name: "新規ユーザー",
          login_id: 99001,
          email: "newuser@example.com",
          password: "password",
          password_confirmation: "password",
          position_ids: [position.id]
        }
      }
    end
    let(:invalid_params) do
      {
        user: {
          name: "",
          login_id: 99002,
          password: "password",
          password_confirmation: "password",
          position_ids: [position.id]
        }
      }
    end

    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        post users_url, params: valid_params
        expect(response).to redirect_to(root_url)
      end
    end

    context "管理者でないとき" do
      it "rootにリダイレクトされる" do
        login(user)
        post users_url, params: valid_params
        expect(response).to redirect_to(root_url)
      end
    end

    context "管理者のとき" do
      context "有効なパラメーターのとき" do
        it "ユーザーが作成される" do
          login(admin_user)
          expect { post users_url, params: valid_params }.to change(User, :count).by(1)
        end

        it "作成したユーザーのshowにリダイレクトされる" do
          login(admin_user)
          post users_url, params: valid_params
          expect(response).to redirect_to(user_url(User.last))
        end
      end

      context "無効なパラメーターのとき" do
        it "200が返る" do
          login(admin_user)
          post users_url, params: invalid_params
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe "DELETE /users/:id" do
    context "管理者でないとき" do
      it "rootにリダイレクトされる" do
        login(user)
        delete user_url(other_user)
        expect(response).to redirect_to(root_url)
      end
    end

    context "管理者のとき" do
      it "ユーザーが削除される" do
        login(admin_user)
        other_user  # カウント計測前に生成しておく
        expect { delete user_url(other_user) }.to change(User, :count).by(-1)
      end
    end
  end
end
