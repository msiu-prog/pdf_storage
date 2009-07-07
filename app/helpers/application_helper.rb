# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def study_period(year = nil)
    year ||= session[:year]
    year.instance_eval{|y| "#{y}/#{y.next}" }
  end
end
