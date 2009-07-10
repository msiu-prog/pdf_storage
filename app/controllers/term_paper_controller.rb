class TermPaperController < ApplicationController
  before_filter :preset_year, :prepare_for_navigation_list
  before_filter :clear_errors, :except => :list_students

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
    @term_paper.mark = -1
  end

  def create_commit
    @term_paper = TermPaper.new(params[:term_paper])
    @term_paper.save
    unless @term_paper.errors.empty?
      @group_subject = @term_paper.group_subject
      @student = @term_paper.student
      navigation_objects(@group_subject)
      render :action => "create"
    else
      redirect_to :action => "list_students", :id => @term_paper.group_subject_id
    end
  end
 
  def multi_create
    @group_subject = GroupSubject.find(params[:id])
    navigation_objects(@group_subject)

    @students = @group.students.sort do |a, b|
      100*(a.last_name <=> b.last_name) +
      10*(a.first_name <=> b.first_name) +
      (a.second_name <=> b.second_name)
    end

    @term_papers = @students.map do |s|
      TermPaper.new(:group_subject_id => @group_subject.id, :student_id => s.id, :mark => -1)
    end
  end

  def multi_create_commit
    term_papers = params[:term_papers] || Hash.new
    term_papers.each_value do |tp|
      if tp && (tp[:mark] && tp[:mark].to_i >= 0 || tp[:up_file])
        res = false
        if tp[:mark] && tp[:mark].to_i >=0 && tp[:up_file]
          new_term_paper = TermPaper.new(tp)
          new_term_paper.teacher_name = params[:teacher_name]
          new_term_paper.group_subject_id = params[:group_subject_id]
          res = new_term_paper.save
        end
        session[:term_papers_add_res][tp[:student_id].to_i] = res
        session[:errors] ||= !res
      end
    end
    session[:group_subject_id] = params[:group_subject_id].to_i
    redirect_to :action => "list_students", :id => params[:group_subject_id]
  end
 
  def download
    @term_paper = TermPaper.find(params[:id])
    send_data @term_paper.file, :filename => @term_paper.filename
  end

  def history
    @group_subject = GroupSubject.find(params[:group_subject_id])
    @student = Student.find(params[:student_id])
    navigation_objects(@group_subject)
    @term_papers = TermPaper.find(:all, :conditions => ["group_subject_id = ? AND student_id = ?", @group_subject.id, @student.id], :order => "updated_at DESC")
  end

  private
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

  def clear_errors
    unless params[:action] == "multi_create" && params[:id].to_i == session[:group_subject_id]
      session[:group_subject_id] = 0
      session[:term_papers_add_res] = Hash.new
    end
    session[:errors] = false
  end
end
