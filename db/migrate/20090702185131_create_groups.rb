class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name, :limit => 16, :null => false
      t.integer :year, :null => false
      t.integer :semester, :null => false
      
      t.references :faculty, :null => false

      t.integer :outer_id, :null => false, :unique => true

      t.timestamps
    end

    if ActiveRecord::Base::connection.kind_of? ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
      execute 'ALTER TABLE groups
                  ADD CONSTRAINT groups_outer_id_u
                  UNIQUE(outer_id)'

      execute 'ALTER TABLE groups
                  ADD CONSTRAINT groups_year_check
                  CHECK(year >= 1960)'

      execute 'ALTER TABLE groups
                  ADD CONSTRAINT groups_faculty_id_fk
                  FOREIGN KEY(faculty_id)
                  REFERENCES faculties(id)'
      
      execute 'ALTER TABLE groups
                  ADD CONSTRAINT groups_name_year_u
                  UNIQUE(name, year)'
    end
  end

  def self.down
    drop_table :groups
  end
end
