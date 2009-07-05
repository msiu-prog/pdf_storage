require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

desc "test"
task(:qq) do
	  puts Student.find(:all).inspect
	  
	  st = Student.new
	  st.first_name = "A"
	  st.second_name = "B"
	  st.last_name = "C"
	  st.outer_id = 100
	  st.save!
	  
	  puts Student.find(:all).inspect
end
