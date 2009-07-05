class CreateFaculties < ActiveRecord::Migration
  def self.up
    create_table :faculties do |t|
      t.string :short_name, :limit => 16, :null => false
      t.text :full_name
      t.integer :number, :null => false

      t.integer :outer_id, :null => false, :unique => true

      t.timestamps
    end

    if ActiveRecord::Base::connection.kind_of? ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
      execute 'ALTER TABLE faculties
                  ADD CONSTRAINT faculties_outer_id_u
                  UNIQUE(outer_id)'

      execute 'ALTER TABLE faculties
                  ADD CONSTRAINT faculties_number_u
                  UNIQUE(number)'
    end
  end

  def self.down
    drop_table :faculties
  end
end
