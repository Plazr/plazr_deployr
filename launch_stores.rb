#!/usr/bin/env ruby

class LaunchStores

	def initialize
		Dir.chdir("../plazr_stores")
	end

	def launch (id=0)
		store_id = 3000 + id
        system("rails s -d -p #{store_id}")
		#system("rails s -e production -d -p #{store_id}")
	end

	def run
		# store names in format "id_name"
		store_list = Dir["*"].reject{|o| not File.directory?(o)}

		# remove the store template from the list
		store_list.delete_if {|o| o == "plazr_store_template"}

		store_list.each do |store|
			folder = store.split("_")
			launch(folder[0])
		end
	end



end

if __FILE__ == $0
	ls = LaunchStores.new
	ls.run
end
