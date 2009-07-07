class Faculty < ActiveRecord::Base
  has_many :groups

  def name
    "#{full_name} (#{short_name})"
  end

  def navigation_list_title
    short_name.to_s
  end
end
