class PagesController < ApplicationController
  def home
    @recent_jobs = Job.published_jobs.recent.limit(5)
  end
end
