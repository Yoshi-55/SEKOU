# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Jobs', type: :request do
  let(:user) { create(:user) }
  let(:group) { create(:group, owner: user) }
  let(:job) { create(:job, client: user, group: group) }

  it 'GET /jobs ログイン済みなら表示されること' do
    sign_in user
    get jobs_path
    expect(response).to have_http_status(:ok)
  end

  it 'GET /jobs/new 未ログインならログインページにリダイレクトされること' do
    get new_job_path
    expect(response).to redirect_to(new_user_session_path)
  end

  it 'GET /jobs/new ログイン済みなら表示されること' do
    sign_in user
    get new_job_path
    expect(response).to have_http_status(:ok)
  end

  it 'POST /jobs 未ログインならログインページにリダイレクトされること' do
    post jobs_path, params: { job: { title: '案件' } }
    expect(response).to redirect_to(new_user_session_path)
  end

  it 'POST /jobs ログイン済みなら案件が作成されること' do
    sign_in user
    params = { job: { title: '新規案件', description: '詳細', job_type: 'car_wrapping',
                      location: '東京都', budget: 25_000, scheduled_date: 1.week.from_now,
                      required_people: 2, group_id: group.id } }
    expect { post jobs_path, params: params }.to change(Job, :count).by(1)
  end

  it 'DELETE /jobs/:id 未ログインならログインページにリダイレクトされること' do
    delete job_path(job)
    expect(response).to redirect_to(new_user_session_path)
  end

  it 'DELETE /jobs/:id オーナーなら削除できること' do
    sign_in user
    job
    expect { delete job_path(job) }.to change(Job, :count).by(-1)
  end
end
