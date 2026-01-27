class AppliesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_apply, only: [:show, :accept, :reject, :cancel]
  before_action :set_job, only: [:new, :create]

  def index
    if current_user.is_a?(Craftsman)
      @applies = current_user.applies.includes(:job).recent
    else
      redirect_to root_path, alert: '職人のみアクセスできます。'
    end
  end

  def show
    unless can_view_apply?
      redirect_to root_path, alert: 'アクセス権限がありません。'
    end
  end

  def new
    if current_user.is_a?(Craftsman)
      if @job.applies.exists?(craftsman: current_user)
        redirect_to @job, alert: 'この案件には既に応募済みです。'
      else
        @apply = @job.applies.build
      end
    else
      redirect_to root_path, alert: '職人のみ応募できます。'
    end
  end

  def create
    if current_user.is_a?(Craftsman)
      @apply = @job.applies.build(apply_params)
      @apply.craftsman = current_user

      if @apply.save
        redirect_to applies_path, notice: '応募が完了しました。'
      else
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to root_path, alert: '職人のみ応募できます。'
    end
  end

  def accept
    if current_user.is_a?(Client) && @apply.job.client == current_user
      @apply.accept!
      redirect_to job_path(@apply.job), notice: '応募を承認しました。'
    else
      redirect_to root_path, alert: 'アクセス権限がありません。'
    end
  end

  def reject
    if current_user.is_a?(Client) && @apply.job.client == current_user
      @apply.reject!
      redirect_to job_path(@apply.job), notice: '応募を不採用にしました。'
    else
      redirect_to root_path, alert: 'アクセス権限がありません。'
    end
  end

  def cancel
    if current_user.is_a?(Craftsman) && @apply.craftsman == current_user
      if @apply.cancel!
        redirect_to applies_path, notice: '応募をキャンセルしました。'
      else
        redirect_to applies_path, alert: '応募のキャンセルができませんでした。'
      end
    else
      redirect_to root_path, alert: 'アクセス権限がありません。'
    end
  end

  private

  def set_apply
    @apply = Apply.find(params[:id])
  end

  def set_job
    @job = Job.find(params[:job_id])
  end

  def apply_params
    params.require(:apply).permit(:message, :desired_budget, :available_date)
  end

  def can_view_apply?
    (current_user.is_a?(Craftsman) && @apply.craftsman == current_user) ||
    (current_user.is_a?(Client) && @apply.job.client == current_user)
  end
end
