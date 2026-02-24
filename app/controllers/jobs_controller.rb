# frozen_string_literal: true

class JobsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_job, only: %i[show edit update destroy]
  before_action :authorize_job_owner!, only: %i[edit update destroy]

  def index
    @jobs = Job.published_jobs.recent

    # グループによる表示制限（全案件がグループ限定）
    if user_signed_in?
      # ログインユーザーが所属するグループの案件のみ表示
      group_ids = current_user.groups.pluck(:id)
      @jobs = @jobs.where(group_id: group_ids) if group_ids.any?
    else
      # 未ログインユーザーは何も表示しない
      @jobs = @jobs.none
    end

    # フィルタリング
    @jobs = @jobs.where(job_type: params[:job_type]) if params[:job_type].present?
    @jobs = @jobs.where(location: params[:location]) if params[:location].present?
    @jobs = @jobs.where('budget >= ?', params[:min_budget]) if params[:min_budget].present?
    @jobs = @jobs.where('budget <= ?', params[:max_budget]) if params[:max_budget].present?

    # ソート
    @jobs = case params[:sort]
            when 'budget_desc'
              @jobs.order(budget: :desc)
            when 'budget_asc'
              @jobs.order(budget: :asc)
            when 'date'
              @jobs.order(scheduled_date: :asc)
            else
              @jobs.recent
            end

    @jobs = @jobs.page(params[:page]).per(20)
  end

  def show
    # グループメンバーのみアクセス可能
    unless user_signed_in? && (@job.client == current_user || @job.group.member_ids.include?(current_user.id))
      redirect_to root_path, alert: 'この案件にアクセスする権限がありません。'
      return
    end

    if user_signed_in? && @job.client == current_user
      @applies = @job.applies.includes(:craftsman)
    elsif user_signed_in?
      @accepted = @job.applies.accepted.exists?(craftsman: current_user)
    end
  end

  def posted
    @jobs = current_user.jobs.includes(:applies).recent.page(params[:page]).per(20)
  end

  def new
    @job = current_user.jobs.build
  end

  def create
    @job = current_user.jobs.build(job_params)
    @job.status = :published
    @job.published_at = Time.current
    @job.expires_at = Time.current + 30.days

    if @job.save
      redirect_to @job, notice: '案件を掲載しました。'

    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    return unless @job.applies.accepted.exists?

    redirect_to @job, alert: '承認済みの応募がある案件は編集できません。'
  end

  def update
    if @job.applies.accepted.exists?
      redirect_to @job, alert: '承認済みの応募がある案件は編集できません。'
    elsif @job.update(job_params)
      redirect_to @job, notice: '案件を更新しました。'
    else
      render :edit, status: :unprocessable_entity
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
end
