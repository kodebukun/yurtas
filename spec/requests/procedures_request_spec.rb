require 'rails_helper'

RSpec.describe "Procedures", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/procedures/index"
      expect(response).to have_http_status(:success)
    end
  end

end
