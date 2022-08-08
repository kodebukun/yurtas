require 'rails_helper'

RSpec.describe "AnonymousPosts", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/anonymous_posts/index"
      expect(response).to have_http_status(:success)
    end
  end

end
