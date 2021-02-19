require 'rails_helper'

RSpec.describe "Manuals", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/manuals/index"
      expect(response).to have_http_status(:success)
    end
  end

end
