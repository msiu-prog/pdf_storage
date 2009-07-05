class Student < ActiveRecord::Base
  has_many :group_students
  has_many :groups, :through => :group_students

  has_many :term_papers
end
