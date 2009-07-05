class CreateTermPapers < ActiveRecord::Migration
  def self.up
    create_table :term_papers do |t|
      t.references :student, :null => false
      t.references :group_subject, :null => false
      t.text :teacher_name, :null => false
      t.integer :mark, :null => false
      t.binary :file, :null => false

      t.timestamps
    end

    if ActiveRecord::Base::connection.kind_of? ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
      execute 'ALTER TABLE term_papers
                  ADD CONSTRAINT term_papers_student_id_fk
                  FOREIGN KEY(student_id)
                  REFERENCES students(id)'
    
      execute 'ALTER TABLE term_papers
                  ADD CONSTRAINT term_papers_group_subject_id_fk
                  FOREIGN KEY(group_subject_id)
                  REFERENCES group_subjects(id)'

      execute 'ALTER TABLE term_papers
                  ADD CONSTRAINT term_papers_mark_check
                  CHECK(mark IN (0, 1, 2, 3, 4, 5))'
    end
  end

  def self.down
    drop_table :term_papers
  end
end
