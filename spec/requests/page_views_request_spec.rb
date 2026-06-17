require 'rails_helper'

RSpec.describe "PageViews", type: :request do
  let(:position) { create(:position) }
  let(:user) { create(:user, position_ids: [position.id]) }
  let(:admin_user) { create(:user, admin: true, position_ids: [position.id]) }

  def login(u)
    post '/login', params: { session: { login_id: u.login_id, password: 'password' } }
  end

  # -------------------------------------------------------------------
  # GET /page_views アクセス制御
  # -------------------------------------------------------------------
  describe "GET /page_views" do
    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        get page_views_url
        expect(response).to redirect_to(root_url)
      end
    end

    context "管理者でないとき" do
      it "rootにリダイレクトされる" do
        login(user)
        get page_views_url
        expect(response).to redirect_to(root_url)
      end
    end

    context "管理者のとき" do
      it "200が返る" do
        login(admin_user)
        get page_views_url
        expect(response).to have_http_status(:ok)
      end
    end
  end

  # -------------------------------------------------------------------
  # GET /page_views フィルター
  # -------------------------------------------------------------------
  describe "GET /page_views フィルター" do
    before do
      login(admin_user)
      travel_to Time.zone.local(2026, 5, 10, 12, 0, 0) do
        create(:page_view, user: user, page: "home")
      end
      travel_to Time.zone.local(2026, 6, 17, 10, 0, 0) do
        create(:page_view, user: user, page: "opi")
      end
    end

    context "月フィルター（2026-06）を指定したとき" do
      it "その月のレコードのみ返る" do
        login(admin_user)
        get page_views_url, params: { month: "2026-06" }
        expect(response.body).to include("opi")
        expect(response.body).not_to include("home")
      end
    end

    context "日フィルター（2026-05-10）を指定したとき" do
      it "その日のレコードのみ返る" do
        login(admin_user)
        get page_views_url, params: { date: "2026-05-10" }
        expect(response.body).to include("home")
        expect(response.body).not_to include("opi")
      end
    end
  end

  # -------------------------------------------------------------------
  # record_page_view（HomeController / AnonymousPostsController 経由）
  # -------------------------------------------------------------------
  describe "record_page_view" do
    context "/index にアクセスしたとき" do
      it "PageViewが作成される" do
        login(user)
        expect { get index_url }.to change(PageView, :count).by(1)
      end

      it "page: 'home' で記録される" do
        login(user)
        get index_url
        expect(PageView.last.page).to eq "home"
      end
    end

    context "/anonymous_posts にアクセスしたとき" do
      it "page: 'opi' で記録される" do
        login(user)
        get anonymous_posts_url
        expect(PageView.last.page).to eq "opi"
      end
    end

    context "30分以内に同じページに再アクセスしたとき" do
      it "新規レコードは作成されず、updated_atが更新される" do
        login(user)
        get index_url
        pv = PageView.last
        original_updated_at = pv.updated_at

        travel_to 20.minutes.from_now do
          expect { get index_url }.not_to change(PageView, :count)
          expect(pv.reload.updated_at).to be > original_updated_at
        end
      end
    end

    context "30分以上経過後に同じページに再アクセスしたとき" do
      it "新規レコードが作成される" do
        login(user)
        get index_url

        travel_to 31.minutes.from_now do
          expect { get index_url }.to change(PageView, :count).by(1)
        end
      end
    end
  end
end
