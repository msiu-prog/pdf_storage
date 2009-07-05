class GroupSubject < ActiveRecord::Base
  belongs_to :subject
  belongs_to :group

  has_many :term_papers
end
