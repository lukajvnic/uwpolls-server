require 'rails_helper'

RSpec.describe "Polls", type: :request do
  describe "GET /create_poll" do
    it "returns http success" do
      get "/poll/create_poll"
      expect(response).to have_http_status(:success)
    end
  end

end
