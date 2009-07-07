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

  validates_associated :student, :group_subject
  validates_presence_of :teacher_name, :message => "Преподаватель должен быть указан"
  validates_presence_of :mark, :message => "Оценка должна быть указана"
  validates_presence_of :file, :message => "Должен присутствовать файл"

  def self.human_attribute_name(attr)
    ""
  end

  def mark_string
    MARKS[mark]
  end

  def up_file=(uploaded_file)
    self.file = uploaded_file.read
  end
end
