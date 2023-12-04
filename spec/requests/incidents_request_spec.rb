require 'rails_helper'

RSpec.describe "Incidents", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/incidents/index"
      expect(response).to have_http_status(:success)
    end
  end

end
