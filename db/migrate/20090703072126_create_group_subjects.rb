class CreateGroupSubjects < ActiveRecord::Migration
  def self.up
    create_table :group_subjects do |t|
      t.references :subject, :null => false
      t.references :group, :null => false

      t.integer :outer_id, :null => false

      t.timestamps
    end

    if ActiveRecord::Base::connection.kind_of? ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
      execute 'ALTER TABLE group_subjects
                  ADD CONSTRAINT group_subjects_outer_id_u
                  UNIQUE(outer_id)'

      execute 'ALTER TABLE group_subjects
                  ADD CONSTRAINT group_subjects_subject_id_group_id_u
                  UNIQUE(subject_id, group_id)'

      execute 'ALTER TABLE group_subjects
                  ADD CONSTRAINT group_subjects_subject_id_fk
                  FOREIGN KEY(subject_id)
                  REFERENCES subjects(id)'
    
      execute 'ALTER TABLE group_subjects
                  ADD CONSTRAINT group_subjects_group_id_fk
                  FOREIGN KEY(group_id)
                  REFERENCES groups(id)'
    end
  end

  def self.down
    drop_table :group_subjects
  end
end
