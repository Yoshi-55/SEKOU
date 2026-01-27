class JobsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_action :authorize_client!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @jobs = Job.published_jobs.recent

    # フィルタリング
    @jobs = @jobs.where(job_type: params[:job_type]) if params[:job_type].present?
    @jobs = @jobs.where(location: params[:location]) if params[:location].present?
    @jobs = @jobs.where('budget >= ?', params[:min_budget]) if params[:min_budget].present?
    @jobs = @jobs.where('budget <= ?', params[:max_budget]) if params[:max_budget].present?

    # ソート
    case params[:sort]
    when 'budget_desc'
      @jobs = @jobs.order(budget: :desc)
    when 'budget_asc'
      @jobs = @jobs.order(budget: :asc)
    when 'date'
      @jobs = @jobs.order(scheduled_date: :asc)
    else
      @jobs = @jobs.recent
    end

    @jobs = @jobs.page(params[:page]).per(20)
  end

  def show
    @applies = @job.applies.includes(:craftsman) if user_signed_in? && current_user.is_a?(Client) && @job.client == current_user
  end

  def new
    @job = current_user.jobs.build
  end

  def create
    @job = current_user.jobs.build(job_params)
    @job.status = :draft

    if @job.save
      redirect_to new_payment_path(job_id: @job.id), notice: '案件を作成しました。決済に進んでください。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    unless @job.draft? || @job.pending_payment?
      redirect_to @job, alert: '公開済みの案件は編集できません。'
    end
  end

  def update
    if @job.draft? || @job.pending_payment?
      if @job.update(job_params)
        redirect_to @job, notice: '案件を更新しました。'
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to @job, alert: '公開済みの案件は編集できません。'
    end
  end

  def destroy
    if @job.draft? || @job.pending_payment?
      @job.destroy
      redirect_to root_path, notice: '案件を削除しました。'
    else
      redirect_to @job, alert: '公開済みの案件は削除できません。'
    end
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(
      :title, :description, :job_type, :location, :address,
      :budget, :scheduled_date, :required_people,
      :featured, :urgent, :extended_period,
      images: []
    )
  end

  def authorize_client!
    unless current_user.is_a?(Client)
      redirect_to root_path, alert: '依頼主のみアクセスできます。'
    end
  end
end
