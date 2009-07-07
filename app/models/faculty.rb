class Faculty < ActiveRecord::Base
  has_many :groups

  def name
    "#{full_name} (#{short_name})"
  end
end
