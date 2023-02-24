require 'rails_helper'

RSpec.describe "Wifis", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/wifis/index"
      expect(response).to have_http_status(:success)
    end
  end

end
