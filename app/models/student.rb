class Student < ActiveRecord::Base
  has_many :group_students
  has_many :groups, :through => :group_students

  has_many :term_papers
  
  def full_name
    [last_name, first_name, second_name].join(" ")
  end

  def last_term_paper(group_subject_id)
    TermPaper.find(:first, :conditions => ["student_id = ? AND group_subject_id = ?", self.id, group_subject_id], :order => "updated_at DESC")
  end
end
