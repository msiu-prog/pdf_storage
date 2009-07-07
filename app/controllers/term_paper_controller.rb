class TermPaperController < ApplicationController
  before_filter :preset_year, :prepare_for_navigation_list

  def prepare_for_navigation_list
    @faculty = nil
    @group = nil
    @subject = nil
  end
  
  def preset_year
    unless session[:year]
      session[:year] = Time.now.instance_eval{|t| t.year - 1 + t.month/9}
    end
  end

  def change_year
    if params[:post]
      session[:year] = params[:post][:year].to_i
      redirect_to ""
    else
      @year = session[:year]
      @year_list = Group.find(:all, :order => "year ASC").map{|g| g.year}.uniq
    end
  end

  def list_faculties
    @faculties = Faculty.find(:all)
  end

  def list_groups
    begin
      @faculties = [@faculty = Faculty.find(params[:id])]
    rescue ActiveRecord::RecordNotFound
      @faculties = Faculty.find(:all)
    end

    @groups = Hash.new
    @faculties.each do |f|
      @groups[f.id] = Group.find(:all, :conditions => ["faculty_id = ? AND year = ?", f.id, session[:year]], :order => "name ASC").inject(Hash.new{Array.new}) do |groups, g|
        groups[(g.semester + 1)/2] <<= g
        groups
      end
    end
  end
  
  def list_subjects
    @group = Group.find(params[:id])
    @subjects = @group.group_subjects
    navigation_objects(@group)
  end

  def list_students
    @group_subject = GroupSubject.find(params[:id])
    navigation_objects(@group_subject)
    # @group = @group_subject.group
    @students = @group.students.sort do |a, b|
      100*(a.last_name <=> b.last_name) +
      10*(a.first_name <=> b.first_name) +
      (a.second_name <=> b.second_name)
    end
  end

  def create
    @group_subject = GroupSubject.find(params[:group_subject_id])
    @student = Student.find(params[:student_id])
    navigation_objects(@group_subject)
    @term_paper = TermPaper.new
    @term_paper.group_subject_id = @group_subject.id
    @term_paper.student_id = @student.id
    @term_paper.mark = 0
  end

  def navigation_objects(object)
    if object.kind_of? GroupSubject
      @group = object.group
      @subject = object.subject
      navigation_objects(@group)
    elsif object.kind_of? Group
      @faculty = object.faculty
      navigation_objects(@faculty)
    end
  end
end
