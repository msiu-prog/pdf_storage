class CreateSubjects < ActiveRecord::Migration
  def self.up
    create_table :subjects do |t|
      t.text :name, :null => false

      t.integer :outer_id, :null => false

      t.timestamps
    end

    if ActiveRecord::Base::connection.kind_of? ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
      execute 'ALTER TABLE subjects
                  ADD CONSTRAINT subjects_outer_id_u
                  UNIQUE(outer_id)'

      execute 'ALTER TABLE subjects
                  ADD CONSTRAINT subjects_name_u
                  UNIQUE(name)'
    end
  end

  def self.down
    drop_table :subjects
  end
end
