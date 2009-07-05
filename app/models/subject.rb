class Subject < ActiveRecord::Base
  has_many :group_subjects
  has_many :groups, :through => :group_subjects
end
