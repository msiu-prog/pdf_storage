module TermPaperHelper
  def navigation_list(main, faculty = nil, group = nil, subject = nil)
    nodes = [faculty, group, subject].inject([]) do |list, node|
      break list unless node
      list << node
      list
    end

    actions = ["list_groups", "list_subjects", "list_students"]

    (0 ... nodes.size).map do |i|
      link_to nodes[i].name, :action => actions[i], :id => nodes[i].id
    end.unshift(link_to main.to_s, :action => "list_faculties")
  end

  def mark(term_paper)
    return "" unless term_paper
    term_paper.mark_string
  end

  def download_link(term_paper)
    return "&mdash;" unless term_paper
    "download me"
  end
end
