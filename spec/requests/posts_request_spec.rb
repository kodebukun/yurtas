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

  describe "GET /posts/:id（work紐付き投稿）" do
    let(:work) { create(:work) }
    let(:work_with_display_name) { create(:work, :with_display_name) }
    let(:work_post) { create(:post, user: user, work: work) }
    let(:work_post_with_display_name) { create(:post, user: user, work: work_with_display_name) }

    context "ログイン済みで所属係りの投稿を見るとき" do
      before { login(user) }

      it "display_nameがないworkはnameが掲示板リンクに表示される" do
        user.works << work
        get post_url(work_post)
        expect(response.body).to include("#{work.name}の掲示板へ")
      end

      it "display_nameがあるworkはdisplay_nameが掲示板リンクに表示される" do
        user.works << work_with_display_name
        get post_url(work_post_with_display_name)
        expect(response.body).to include("事業場安全衛生の掲示板へ")
        expect(response.body).not_to include("飯田地区事業場安全衛生の掲示板へ")
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

  describe "検索" do
    let(:department) { create(:department, name: "MRI") }
    let(:my_work) { create(:work, name: "医療安全") }
    let(:other_work) { create(:work, name: "放射線管理") }

    let!(:general_post) { create(:post, user: user, title: "全体 点検のお知らせ", meeting: true) }
    let!(:department_public) { create(:post, user: user, title: "部署 点検（全体にも表示）", department: department, meeting: true) }
    let!(:department_private) { create(:post, user: user, title: "部署 点検", department: department, meeting: false) }
    let!(:my_work_private) { create(:post, user: user, title: "所属係り 点検", work: my_work, meeting: false) }
    let!(:other_work_private) { create(:post, user: user, title: "他の係り 点検", work: other_work, meeting: false) }
    let!(:unmatched_post) { create(:post, user: user, title: "忘年会", meeting: true) }

    def link_to_post(p)
      %(href="#{post_path(p)}")
    end

    before { user.works << my_work }

    describe "GET /posts/search（掲示板トップからの検索）" do
      context "未ログインのとき" do
        it "rootにリダイレクトされる" do
          get search_posts_url, params: { keyword: "点検" }
          expect(response).to redirect_to(root_url)
        end
      end

      context "ログイン済みのとき" do
        before { login(user) }

        it "全体・部署・係りの掲示板を横断して検索する" do
          get search_posts_url, params: { keyword: "点検" }
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("検索結果：4件")
          [general_post, department_public, department_private, my_work_private].each do |p|
            expect(response.body).to include(link_to_post(p))
          end
          expect(response.body).not_to include(link_to_post(unmatched_post))
        end

        it "所属していない係りの非公開投稿は表示しない" do
          get search_posts_url, params: { keyword: "点検" }
          expect(response.body).not_to include(link_to_post(other_work_private))
        end

        it "どの掲示板の投稿かバッジで表示する" do
          get search_posts_url, params: { keyword: "点検" }
          expect(response.body).to include('<span class="badge badge-primary mb-2">全体の掲示板')
          expect(response.body).to include('<span class="badge badge-info mb-2">MRIの掲示板')
          expect(response.body).to include('<span class="badge badge-success mb-2">医療安全の掲示板')
        end

        it "一致した語をハイライトする" do
          get search_posts_url, params: { keyword: "点検" }
          expect(response.body).to include("<mark>点検</mark>")
        end

        it "キーワードが空のときは結果を表示しない" do
          get search_posts_url, params: { keyword: "" }
          expect(response).to have_http_status(:ok)
          expect(response.body).not_to include("検索結果")
          expect(response.body).not_to include(link_to_post(general_post))
        end

        it "キーワードをエスケープして表示する" do
          get search_posts_url, params: { keyword: "<script>alert(1)</script>" }
          expect(response).to have_http_status(:ok)
          expect(response.body).not_to include("<script>alert(1)</script>")
        end

        it "10件ごとにページ分割する" do
          create_list(:post, 10, user: user, title: "点検 追加分", meeting: true)
          get search_posts_url, params: { keyword: "点検", page: 2 }
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("検索結果：14件")
          expect(response.body.scan('class="list-group-item"').size).to eq(4)
        end
      end
    end

    describe "GET /posts/top" do
      it "掲示板トップに横断検索のフォームがある" do
        login(user)
        get top_posts_url
        expect(response.body).to include(%(action="#{search_posts_path}"))
      end
    end

    describe "GET /posts?keyword=（全体の掲示板内の検索）" do
      before { login(user) }

      it "全体の掲示板に表示される投稿だけを検索する" do
        get posts_url, params: { keyword: "点検" }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("検索結果：2件")
        expect(response.body).to include(link_to_post(general_post))
        expect(response.body).to include(link_to_post(department_public))
      end

      it "全体の掲示板に表示しない部署・係りの投稿は含めない" do
        get posts_url, params: { keyword: "点検" }
        [department_private, my_work_private, other_work_private].each do |p|
          expect(response.body).not_to include(link_to_post(p))
        end
      end

      it "検索をクリアするリンクを表示する" do
        get posts_url, params: { keyword: "点検" }
        expect(response.body).to include("検索をクリア")
      end

      it "キーワードがないときは全体の掲示板の投稿をすべて表示する" do
        get posts_url
        expect(response.body).not_to include("検索結果")
        [general_post, department_public, unmatched_post].each do |p|
          expect(response.body).to include(link_to_post(p))
        end
      end

      it "検索フォームの送信先は全体の掲示板" do
        get posts_url
        expect(response.body).to include(%(action="#{posts_path}"))
      end
    end
  end
end
