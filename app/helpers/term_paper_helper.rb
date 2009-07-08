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
    TermPaper::MARKS.map{|k, v| [v, k]}.sort_by{|e| e.last}
  end

  def download_link(term_paper, label = "скачать")
    return "&mdash;" unless term_paper
    link_to label.to_s, :action => "download", :id => term_paper.id
  end
end
