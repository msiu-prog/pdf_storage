class GroupSubject < ActiveRecord::Base
  belongs_to :subject
  belongs_to :group

  has_many :term_papers

  def navigation_list_title
    subject.navigation_list_title
  end
end
