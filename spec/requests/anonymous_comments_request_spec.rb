require 'rails_helper'

RSpec.describe "AnonymousComments", type: :request do

  describe "GET /new" do
    it "returns http success" do
      get "/anonymous_comments/new"
      expect(response).to have_http_status(:success)
    end
  end

end
