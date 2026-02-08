# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: %i[show edit update destroy add_member remove_member]
  before_action :authorize_owner!, only: %i[edit update destroy add_member remove_member]

  def index
    @groups = current_user.groups.includes(:owner, :members)
  end

  def new
    @group = current_user.owned_groups.build
  end

  def create
    @group = current_user.owned_groups.build(group_params)

    if @group.save
      redirect_to @group, notice: 'グループを作成しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    return if @group.members.include?(current_user)

    redirect_to groups_path, alert: 'このグループにアクセスする権限がありません。'
  end

  def edit; end

  def update
    if @group.update(group_params)
      redirect_to @group, notice: 'グループを更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path, notice: 'グループを削除しました。'
  end

  def add_member
    user = User.find_by(email: params[:email])

    if user.nil?
      redirect_to @group, alert: 'ユーザーが見つかりませんでした。'
    elsif @group.members.include?(user)
      redirect_to @group, alert: 'このユーザーは既にメンバーです。'
    else
      @group.group_memberships.create!(user: user, role: :member)
      redirect_to @group, notice: "#{user.name}さんをグループに追加しました。"
    end
  end

  def remove_member
    membership = @group.group_memberships.find_by(user_id: params[:user_id])

    if membership.nil?
      redirect_to @group, alert: 'メンバーが見つかりませんでした。'
    elsif membership.user == @group.owner
      redirect_to @group, alert: 'オーナーは削除できません。'
    else
      user_name = membership.user.name
      membership.destroy
      redirect_to @group, notice: "#{user_name}さんをグループから削除しました。"
    end
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :description)
  end

  def authorize_owner!
    return if @group.owner == current_user

    redirect_to @group, alert: 'オーナーのみが実行できます。'
  end
end
