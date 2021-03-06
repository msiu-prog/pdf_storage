module TermPaperHelper
  def navigation_list(main, faculty = nil, group = nil, group_subject = nil)
    nodes = [faculty, group, group_subject].inject([]) do |list, node|
      break list unless node
      list << node
      list
    end

    actions = ["list_groups", "list_subjects", "list_students"]

    (0 ... nodes.size).map do |i|
      link_to nodes[i].navigation_list_title, :action => actions[i], :id => nodes[i].id
    end.unshift(link_to main.to_s, :action => "list_faculties")
  end

  def mark(term_paper)
    return "" unless term_paper
    term_paper.mark_string
  end

  def mark_list
    (TermPaper::MARKS.to_a << [-1, ""]).map{|k, v| [v, k]}.sort_by{|e| e.last}
  end

  def download_link(term_paper, label = "скачать")
    return "&mdash;" unless term_paper
    link_to label.to_s, :action => "download", :id => term_paper.id
  end

  def student_row_type(student)
    if session[:term_papers_add_res][student.id].nil? || @group_subject.id != session[:group_subject_id]
      "student"
    elsif session[:term_papers_add_res][student.id]
      "student_added"
    else
      "student_not_added"
    end
  end

  def html_options_for_student(student)
    {:class => student_row_type(student), :id => dom_id(student, nil)}
  end
end
