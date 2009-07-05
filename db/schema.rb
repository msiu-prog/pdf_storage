# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090703102246) do

  create_table "faculties", :force => true do |t|
    t.string   "short_name", :limit => 16, :null => false
    t.text     "full_name"
    t.integer  "number",                   :null => false
    t.integer  "outer_id",                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "faculties", ["number"], :name => "faculties_number_u", :unique => true
  add_index "faculties", ["outer_id"], :name => "faculties_outer_id_u", :unique => true

  create_table "group_students", :force => true do |t|
    t.integer  "student_id", :null => false
    t.integer  "group_id",   :null => false
    t.integer  "outer_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_students", ["group_id", "student_id"], :name => "group_students_student_id_group_id_u", :unique => true
  add_index "group_students", ["outer_id"], :name => "group_students_outer_id_u", :unique => true

  create_table "group_subjects", :force => true do |t|
    t.integer  "subject_id", :null => false
    t.integer  "group_id",   :null => false
    t.integer  "outer_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_subjects", ["group_id", "subject_id"], :name => "group_subjects_subject_id_group_id_u", :unique => true
  add_index "group_subjects", ["outer_id"], :name => "group_subjects_outer_id_u", :unique => true

  create_table "groups", :force => true do |t|
    t.string   "name",       :limit => 16, :null => false
    t.integer  "year",                     :null => false
    t.integer  "faculty_id",               :null => false
    t.integer  "outer_id",                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["name", "year"], :name => "groups_name_year_u", :unique => true
  add_index "groups", ["outer_id"], :name => "groups_outer_id_u", :unique => true

  create_table "students", :force => true do |t|
    t.string   "first_name",  :limit => 256, :null => false
    t.string   "last_name",   :limit => 256, :null => false
    t.string   "second_name", :limit => 256, :null => false
    t.integer  "outer_id",                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "students", ["outer_id"], :name => "students_outer_id_u", :unique => true

  create_table "subjects", :force => true do |t|
    t.text     "name",       :null => false
    t.integer  "outer_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subjects", ["name"], :name => "subjects_name_u", :unique => true
  add_index "subjects", ["outer_id"], :name => "subjects_outer_id_u", :unique => true

  create_table "term_papers", :force => true do |t|
    t.integer  "student_id",       :null => false
    t.integer  "group_subject_id", :null => false
    t.text     "teacher_name",     :null => false
    t.integer  "mark",             :null => false
    t.binary   "file",             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
