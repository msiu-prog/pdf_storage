class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.string :first_name, :limit => 256, :null => false
      t.string :last_name, :limit => 256, :null => false
      t.string :second_name, :limit => 256, :null => false

      t.integer :outer_id, :null => false, :unique => true

      t.timestamps
    end

    if ActiveRecord::Base::connection.kind_of? ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
      execute 'ALTER TABLE students
                  ADD CONSTRAINT students_outer_id_u
                  UNIQUE(outer_id)'
    end
  end

  def self.down
    drop_table :students
  end
end
