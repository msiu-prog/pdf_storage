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
  validates_presence_of :teacher_name, :message => "Должен быть указан преподаватель"
  validates_presence_of :mark, :message => "Должна быть указана оценка"
  validates_presence_of :file, :message => "Должен присутствовать файл"
  validates_presence_of :filename, :message => nil

  def validate
    g_id = self.group_subject.group.id    
    unless self.student.groups.inject(false){|res, g| res || (g.id == g_id)}
      errors.add("group_subject_id", "У данного студента нет такого предмета")
    end
  end

  def self.human_attribute_name(attr)
    ""
  end

  def mark_string
    MARKS[mark]
  end

  def up_file=(uploaded_file)
    self.filename = uploaded_file.original_filename
    self.file = uploaded_file.read
  end

  def filename=(new_filename)
    write_attribute("filename", sanitize_filename(new_filename))
  end

  private
  def sanitize_filename(filename)
    File.basename(filename).gsub(/[^\w\.\-]/, "_")
  end
end
