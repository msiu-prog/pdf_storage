class CreateGroupStudents < ActiveRecord::Migration
  def self.up
    create_table :group_students do |t|
      t.references :student, :null => false
      t.references :group, :null => false
      
      t.integer :outer_id, :null => false

      t.timestamps
    end
    
    if ActiveRecord::Base::connection.kind_of? ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
      execute 'ALTER TABLE group_students
                  ADD CONSTRAINT group_students_outer_id_u
                  UNIQUE(outer_id)'

      execute 'ALTER TABLE group_students
                  ADD CONSTRAINT group_students_student_id_group_id_u
                  UNIQUE(student_id, group_id)'

      execute 'ALTER TABLE group_students
                  ADD CONSTRAINT group_students_student_id_fk
                  FOREIGN KEY(student_id)
                  REFERENCES students(id)'
    
      execute 'ALTER TABLE group_students
                  ADD CONSTRAINT group_students_group_id_fk
                  FOREIGN KEY(group_id)
                  REFERENCES groups(id)'
    end
  end

  def self.down
    drop_table :group_students
  end
end
