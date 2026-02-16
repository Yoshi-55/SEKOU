# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  describe 'GET /' do
    it 'ホームページが表示されること' do
      get root_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /terms' do
    it '利用規約ページが表示されること' do
      get terms_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /privacy' do
    it 'プライバシーポリシーページが表示されること' do
      get privacy_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /company' do
    it '運営会社ページが表示されること' do
      get company_path
      expect(response).to have_http_status(:ok)
    end
  end
end
