# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Groups', type: :request do
  let(:owner) { create(:user) }
  let(:group) { create(:group, owner: owner) }

  it 'GET /groups 未ログインならログインページにリダイレクトされること' do
    get groups_path
    expect(response).to redirect_to(new_user_session_path)
  end

  it 'GET /groups ログイン済みなら表示されること' do
    sign_in owner
    get groups_path
    expect(response).to have_http_status(:ok)
  end

  it 'POST /groups 未ログインならログインページにリダイレクトされること' do
    post groups_path, params: { group: { name: 'テスト', description: '説明' } }
    expect(response).to redirect_to(new_user_session_path)
  end

  it 'POST /groups ログイン済みならグループが作成されること' do
    sign_in owner
    expect {
      post groups_path, params: { group: { name: 'テスト', description: '説明' } }
    }.to change(Group, :count).by(1)
  end

  it 'DELETE /groups/:id オーナーなら削除できること' do
    sign_in owner
    group
    expect { delete group_path(group) }.to change(Group, :count).by(-1)
  end
end
