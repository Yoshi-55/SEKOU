# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @jobs = @user.jobs.order(created_at: :desc).limit(5)
    @applies = @user.applies.includes(:job).order(created_at: :desc).limit(5)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: 'プロフィールを更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :phone, :company_name, :prefecture,
      :company_address, :skills, :bio, :years_of_experience
    )
  end
end
