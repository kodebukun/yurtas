require 'rails_helper'

RSpec.describe "DepartmentPosts", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/department_posts/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/department_posts/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/department_posts/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
