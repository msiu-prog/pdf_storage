class Group < ActiveRecord::Base
  belongs_to :faculty
  has_many :group_students
  has_many :students, :through => :group_students
  has_many :group_subjects
  has_many :subjects, :through => :group_subjects

  def navigation_list_title
    name.to_s
  end
end
