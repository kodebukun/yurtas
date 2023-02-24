require 'rails_helper'

RSpec.describe "UserAccessPoints", type: :request do

  describe "GET /new" do
    it "returns http success" do
      get "/user_access_points/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/user_access_points/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/user_access_points/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
