class TermPaper < ActiveRecord::Base
  belongs_to :student
  belongs_to :group_subject
end
