# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Jobs', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:group) { create(:group, owner: user) }
  let(:job) { create(:job, client: user, group: group) }

  describe 'GET /jobs' do
    context '未ログインの場合' do
      it '案件一覧が空であること' do
        get jobs_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'ログイン済みの場合' do
      before { sign_in user }

      it '正常にレスポンスが返ること' do
        get jobs_path
        expect(response).to have_http_status(:ok)
      end

      it '自分のグループの案件が表示されること' do
        job
        get jobs_path
        expect(response.body).to include(job.title)
      end
    end
  end

  describe 'GET /jobs/:id' do
    context '未ログインの場合' do
      it 'ルートにリダイレクトされること' do
        get job_path(job)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'グループメンバーの場合' do
      before { sign_in user }

      it '正常に表示されること' do
        get job_path(job)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'グループ非メンバーの場合' do
      before { sign_in other_user }

      it 'ルートにリダイレクトされること' do
        get job_path(job)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET /jobs/new' do
    context '未ログインの場合' do
      it 'ログインページにリダイレクトされること' do
        get new_job_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ログイン済みの場合' do
      before { sign_in user }

      it '正常に表示されること' do
        get new_job_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST /jobs' do
    let(:valid_params) do
      {
        job: {
          title: '新規案件',
          description: '詳細説明です。',
          job_type: 'car_wrapping',
          location: '東京都',
          budget: 25_000,
          scheduled_date: 1.week.from_now,
          required_people: 2,
          group_id: group.id
        }
      }
    end

    context '未ログインの場合' do
      it 'ログインページにリダイレクトされること' do
        post jobs_path, params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ログイン済みの場合' do
      before { sign_in user }

      it '案件が作成されること' do
        expect { post jobs_path, params: valid_params }.to change(Job, :count).by(1)
      end

      it '作成後に案件詳細にリダイレクトされること' do
        post jobs_path, params: valid_params
        expect(response).to redirect_to(job_path(Job.last))
      end

      it '無効なパラメータではフォームが再表示されること' do
        post jobs_path, params: { job: { title: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /jobs/:id' do
    context '未ログインの場合' do
      it 'ログインページにリダイレクトされること' do
        delete job_path(job)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context '案件オーナーの場合' do
      before { sign_in user }

      it '案件が削除されること' do
        job
        expect { delete job_path(job) }.to change(Job, :count).by(-1)
      end

      it '削除後に掲載案件一覧にリダイレクトされること' do
        delete job_path(job)
        expect(response).to redirect_to(posted_jobs_path)
      end
    end

    context '他人の案件の場合' do
      before { sign_in other_user }

      it '削除できずリダイレクトされること' do
        delete job_path(job)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
