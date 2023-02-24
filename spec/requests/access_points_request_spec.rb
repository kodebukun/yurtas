require 'rails_helper'

RSpec.describe "AccessPoints", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/access_points/index"
      expect(response).to have_http_status(:success)
    end
  end

end
