module ApplicationHelper
  def free_mode?
    ENV['FREE_MODE'] == 'true'
  end
end
