require 'rails_helper'

RSpec.describe "UserAccessPoints", type: :request do
  let(:position) { create(:position) }
  let(:user) { create(:user, position_ids: [position.id]) }

  def login(u)
    post '/login', params: { session: { login_id: u.login_id, password: 'password' } }
  end

  describe "GET /user_access_points/:id/edit" do
    context "未ログインのとき" do
      it "rootにリダイレクトされる" do
        get "/user_access_points/1/edit"
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
