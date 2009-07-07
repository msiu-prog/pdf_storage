class TermPaper < ActiveRecord::Base
  MARKS = {
    0 => "не зачтено",
    1 => "зачтено",
    2 => "неуд.",
    3 => "удовл.",
    4 => "хорошо",
    5 => "отлично"
  }
  
  belongs_to :student
  belongs_to :group_subject

  def mark_string
    MARKS[mark]
  end
end
