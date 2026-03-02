# frozen_string_literal: true

class JobsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_job, only: %i[show edit update destroy]
  before_action :authorize_job_owner!, only: %i[edit update destroy]

  def index
    @jobs = filter_jobs_by_group(Job.published_jobs.recent)
    @jobs = apply_filters(@jobs)
    @jobs = apply_sorting(@jobs)
    @jobs = filter_by_visibility(@jobs)
    @jobs = Kaminari.paginate_array(@jobs).page(params[:page]).per(20)
  end

  def show
    unless user_signed_in? && @job.visible_to?(current_user)
      redirect_to root_path, alert: 'この案件にアクセスする権限がありません。'
      return
    end

    @applies = @job.applies.includes(:craftsman) if @job.client == current_user
    @accepted = @job.applies.accepted.exists?(craftsman: current_user) unless @job.client == current_user
  end

  def posted
    @jobs = current_user.jobs.includes(:applies).recent.page(params[:page]).per(20)
  end

  def new
    @job = current_user.jobs.build
  end

  def edit
    return unless @job.applies.accepted.exists?

    redirect_to @job, alert: '承認済みの応募がある案件は編集できません。'
  end

  def create
    @job = current_user.jobs.build(job_params)
    @job.status = :published
    @job.published_at = Time.current
    @job.expires_at = 30.days.from_now

    if @job.save
      redirect_to @job, notice: '案件を掲載しました。'
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @job.applies.accepted.exists?
      redirect_to @job, alert: '承認済みの応募がある案件は編集できません。'
    elsif @job.update(job_params)
      redirect_to @job, notice: '案件を更新しました。'
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @job.applies.accepted.exists?
      redirect_to @job, alert: '承認済みの応募がある案件は削除できません。'
    else
      @job.destroy
      redirect_to posted_jobs_path, notice: '案件を削除しました。'
    end
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(
      :title, :description, :job_type, :location, :address,
      :budget, :start_date, :end_date, :required_people, :group_id,
      notified_member_ids: []
    )
  end

  def authorize_job_owner!
    return if @job.client == current_user

    redirect_to root_path, alert: 'アクセス権限がありません。'
  end

  def filter_jobs_by_group(jobs)
    return jobs.none unless user_signed_in?

    group_ids = current_user.groups.pluck(:id)
    group_ids.any? ? jobs.where(group_id: group_ids) : jobs.none
  end

  def apply_filters(jobs)
    jobs = jobs.where(job_type: params[:job_type]) if params[:job_type].present?
    jobs = jobs.where(location: params[:location]) if params[:location].present?
    jobs = jobs.where(budget: (params[:min_budget])..) if params[:min_budget].present?
    jobs = jobs.where(budget: ..(params[:max_budget])) if params[:max_budget].present?
    jobs
  end

  def apply_sorting(jobs)
    case params[:sort]
    when 'budget_desc'
      jobs.order(budget: :desc)
    when 'budget_asc'
      jobs.order(budget: :asc)
    when 'date'
      jobs.order(start_date: :asc)
    else
      jobs.recent
    end
  end

  def filter_by_visibility(jobs)
    return jobs unless user_signed_in?

    jobs.select { |job| job.visible_to?(current_user) }
  end
end
