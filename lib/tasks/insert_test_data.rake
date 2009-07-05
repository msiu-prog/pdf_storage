require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
require 'yaml'

# RAILS_ROOT

def get_data(file)
  array = []
  dirty = YAML.load_file("#{RAILS_ROOT}/lib/tasks/test_data/#{file}")
  
  dirty.each do |row|
    h = Hash.new
    row.each do |k, v|
      h[k.to_sym] = v
    end
    array << h
  end
  
  array
end

namespace :insert do
  task(:clear) do
    [GroupStudent, GroupSubject, Student, Subject, Group, Faculty].each do |model|
      model.destroy_all
    end
  end
  
  task(:all => [:faculties, :groups, :students, :subjects,
                :groups_students, :groups_subjects]) do
    puts "ok..."
  end

  task(:groups_subjects) do
    groups_subjects = get_data("groups_subjects_map.yml")

    outer_id = 1
    groups_subjects.each do |row|
      g_id = row.delete(:group_outer_id)
      g = Group.find(:first, :conditions => ["outer_id = ?", g_id])
      row[:subject_outer_ids].each do |s_id|
        id = Subject.find(:first, :conditions => ["outer_id = ?", s_id]).id
        g.group_subjects.create(:subject_id => id, :outer_id => outer_id)
        outer_id += 1
      end
    end
  end

  task(:subjects) do
    subjects = get_data("subjects.yml")

    subjects.each do |row|
      Subject.create(row)
    end
  end
  
  task(:groups_students) do
    groups_students = get_data("groups_students_map.yml")
    
    outer_id = 1
    groups_students.each do |row|
      s_id = row.delete(:id_postfix)
      Student.find(:all, :conditions => ["outer_id%10000 = ?", s_id]).each do |s|
        row[:groups_outer_ids].each do |i|
          g_id = Group.find(:first, :conditions => ["outer_id = ?", i]).id
          s.group_students.create(:group_id => g_id, :outer_id => outer_id)
          outer_id += 1
        end
      end
    end
  end

  task(:students) do
    students = get_data("students.yml")
    
    students.each do |row|
      Student.create(row)
    end
  end
  
  task(:groups) do
    groups = get_data("groups.yml")

    groups.each do |row|
      f_id = row.delete(:faculty_outer_id)
      Faculty.find(:first, :conditions => ["outer_id = ?", f_id]).groups.create(row)
    end
  end
  
  task(:faculties) do
    faculties = get_data("faculties.yml")

    faculties.each do |row|
      f = Faculty.create(row)
    end
  end
end
