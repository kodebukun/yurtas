require 'rails_helper'

RSpec.describe "Incidents", type: :request do
  let(:position) { create(:position) }
  let(:user) { create(:user, position_ids: [position.id]) }
  let(:department) { create(:department) }

  def login(u)
    post '/login', params: { session: { login_id: u.login_id, password: 'password' } }
  end

  describe "GET /incidents" do
    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        get incidents_url
        expect(response).to redirect_to(root_url)
      end
    end

    context "ログイン済みのとき" do
      it "200が返る" do
        login(user)
        get incidents_url, params: { department_id: department.id }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
