require 'rails_helper'

RSpec.describe "Devices", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/devices/index"
      expect(response).to have_http_status(:success)
    end
  end

end
