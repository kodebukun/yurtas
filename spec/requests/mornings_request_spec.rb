require 'rails_helper'

RSpec.describe "Mornings", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/mornings/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/mornings/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/mornings/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/mornings/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
