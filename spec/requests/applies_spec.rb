# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Applies', type: :request do
  let(:craftsman) { create(:user) }

  it 'GET /applies 未ログインならログインページにリダイレクトされること' do
    get applies_path
    expect(response).to redirect_to(new_user_session_path)
  end

  it 'GET /applies ログイン済みなら表示されること' do
    sign_in craftsman
    get applies_path
    expect(response).to have_http_status(:ok)
  end
end
