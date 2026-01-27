require 'rails_helper'

RSpec.describe "Applies", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/applies/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/applies/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/applies/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /accept" do
    it "returns http success" do
      get "/applies/accept"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /reject" do
    it "returns http success" do
      get "/applies/reject"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /cancel" do
    it "returns http success" do
      get "/applies/cancel"
      expect(response).to have_http_status(:success)
    end
  end

end
