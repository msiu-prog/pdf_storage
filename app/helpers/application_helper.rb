# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def study_period(year = nil)
    year ||= session[:year]
    year.instance_eval{|y| "#{y}/#{y.next}" }
  end

  def put_copyright
    "&copy; ИВЦ МГИУ, 2008-#{[2009, Time.now.year].max}."
  end

  def add_featurebox(box)
    @featureboxes ||= Array.new
    @featureboxes.unshift box
  end

  def get_featureboxes
    @featureboxes || Array.new
  end
end
