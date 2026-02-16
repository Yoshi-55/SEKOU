# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Groups', type: :request do
  let(:owner) { create(:user) }
  let(:member) { create(:user) }
  let(:other_user) { create(:user) }
  let(:group) { create(:group, owner: owner) }

  before do
    group.group_memberships.find_or_create_by!(user: member, role: :member)
  end

  describe 'GET /groups' do
    context '未ログインの場合' do
      it 'ログインページにリダイレクトされること' do
        get groups_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ログイン済みの場合' do
      before { sign_in owner }

      it '正常に表示されること' do
        get groups_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /groups/:id' do
    context 'グループメンバーの場合' do
      before { sign_in member }

      it '正常に表示されること' do
        get group_path(group)
        expect(response).to have_http_status(:ok)
      end
    end

    context '非メンバーの場合' do
      before { sign_in other_user }

      it 'グループ一覧にリダイレクトされること' do
        get group_path(group)
        expect(response).to redirect_to(groups_path)
      end
    end
  end

  describe 'POST /groups' do
    let(:valid_params) { { group: { name: 'テストグループ', description: '説明文' } } }

    context '未ログインの場合' do
      it 'ログインページにリダイレクトされること' do
        post groups_path, params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ログイン済みの場合' do
      before { sign_in owner }

      it 'グループが作成されること' do
        expect { post groups_path, params: valid_params }.to change(Group, :count).by(1)
      end

      it 'オーナーが自動でメンバーに追加されること' do
        post groups_path, params: valid_params
        expect(Group.last.members).to include(owner)
      end
    end
  end

  describe 'POST /groups/:id/add_member' do
    context 'オーナーの場合' do
      before { sign_in owner }

      it '既存ユーザーを追加できること' do
        expect {
          post add_member_group_path(group), params: { email: other_user.email }
        }.to change { group.members.count }.by(1)
        expect(response).to redirect_to(group_path(group))
      end

      it '存在しないメールアドレスはエラーになること' do
        post add_member_group_path(group), params: { email: 'notexist@example.com' }
        expect(response).to redirect_to(group_path(group))
        follow_redirect!
        expect(response.body).to include('ユーザーが見つかりませんでした')
      end

      it '空のメールアドレスはエラーになること' do
        post add_member_group_path(group), params: { email: '' }
        expect(response).to redirect_to(group_path(group))
      end

      it '既存メンバーを追加しようとするとエラーになること' do
        post add_member_group_path(group), params: { email: member.email }
        expect(response).to redirect_to(group_path(group))
      end
    end

    context 'オーナー以外の場合' do
      before { sign_in member }

      it '追加できないこと' do
        post add_member_group_path(group), params: { email: other_user.email }
        expect(response).to redirect_to(group_path(group))
      end
    end
  end

  describe 'DELETE /groups/:id' do
    context 'オーナーの場合' do
      before { sign_in owner }

      it 'グループが削除されること' do
        group
        expect { delete group_path(group) }.to change(Group, :count).by(-1)
      end

      it 'グループ一覧にリダイレクトされること' do
        delete group_path(group)
        expect(response).to redirect_to(groups_path)
      end
    end

    context 'メンバー（非オーナー）の場合' do
      before { sign_in member }

      it '削除できないこと' do
        delete group_path(group)
        expect(response).to redirect_to(group_path(group))
      end
    end
  end
end
