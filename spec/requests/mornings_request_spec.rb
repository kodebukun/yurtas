require 'rails_helper'

RSpec.describe "Mornings", type: :request do
  let(:position) { create(:position) }
  let(:user) { create(:user, position_ids: [position.id]) }
  let(:morning) { create(:morning, user_id: user.id) }

  def login(u)
    post '/login', params: { session: { login_id: u.login_id, password: 'password' } }
  end

  describe "GET /mornings" do
    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        get mornings_url
        expect(response).to redirect_to(root_url)
      end
    end

    context "ログイン済みのとき" do
      it "200が返る" do
        login(user)
        get mornings_url
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /mornings?keyword=（検索）" do
    let!(:hit) { create(:morning, user_id: user.id, title: "11/5 朝ミーティング", content: "CT装置の点検があります") }
    let!(:miss) { create(:morning, user_id: user.id, title: "11/6 朝ミーティング", content: "特になし") }

    before { login(user) }

    it "キーワードに一致する朝ミーティングだけを表示する" do
      get mornings_url, params: { keyword: "点検" }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("検索結果：1件")
      expect(response.body).to include(%(href="#{morning_path(hit)}"))
      expect(response.body).not_to include(%(href="#{morning_path(miss)}"))
      expect(response.body).to include("<mark>点検</mark>")
      expect(response.body).to include("検索をクリア")
    end

    it "キーワードがないときはすべて表示する" do
      get mornings_url
      expect(response.body).not_to include("検索結果")
      expect(response.body).to include(%(href="#{morning_path(hit)}"))
      expect(response.body).to include(%(href="#{morning_path(miss)}"))
    end
  end

  describe "GET /mornings/:id" do
    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        get morning_url(morning)
        expect(response).to redirect_to(root_url)
      end
    end

    context "ログイン済みのとき" do
      it "200が返る" do
        login(user)
        get morning_url(morning)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /mornings/new" do
    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        get new_morning_url
        expect(response).to redirect_to(root_url)
      end
    end

    context "ログイン済みのとき" do
      it "200が返る" do
        login(user)
        get new_morning_url
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /mornings/:id/edit" do
    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        get edit_morning_url(morning)
        expect(response).to redirect_to(root_url)
      end
    end

    context "ログイン済みのとき" do
      it "200が返る" do
        login(user)
        get edit_morning_url(morning)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
