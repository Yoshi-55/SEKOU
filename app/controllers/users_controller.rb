class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    if @user.is_a?(Client)
      @jobs = @user.jobs.order(created_at: :desc).limit(5)
    elsif @user.is_a?(Craftsman)
      @applies = @user.applies.includes(:job).order(created_at: :desc).limit(5)
    end
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
    permitted_params = [:name, :phone, :company_name, :prefecture]

    if current_user.is_a?(Craftsman)
      permitted_params += [:skills, :bio, :years_of_experience]
    elsif current_user.is_a?(Client)
      permitted_params += [:company_address]
    end

    params.require(:user).permit(permitted_params)
  end
end
