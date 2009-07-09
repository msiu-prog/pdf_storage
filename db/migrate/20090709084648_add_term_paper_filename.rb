class AddTermPaperFilename < ActiveRecord::Migration
  def self.up
    add_column :term_papers, :filename, :string

    TermPaper.find(:all).each do |tp|
      tp.filename = "termpaper.pdf"
      tp.save
    end
    
    change_column :term_papers, :filename, :string, :null => false
  end

  def self.down
    remove_column :term_papers, :filename
  end
end
