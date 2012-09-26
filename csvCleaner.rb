#this script should take in as an argument a list (which will be user input for the moment), which contains variables that we want to keep from a .csv file
#the output should be a new .csv file that has only the fields of the variables in the above argument list

#testing with the user input "V1,V6,V8,V9"

require 'csv'
require 'find'

#this could be troublesome for the user, if they constantly make mistakes (could be a ton of variable); this feature is subject
#change, perhaps they should type up the variables they want in a text file or something; in other words, this is a temporary fix
#p "Please enter the name of the variables that you want to keep, seperating each by a comma (WARNING: Variable names are Caps Sensitive!)"

varExtract = IO.readlines("save_variables.txt")

#variables should now be an array of the variables that we want to keep from the csv file
variables = varExtract[0]
variables = variables.split(',')

#loc = location of the csv file we want to 'clean'
loc = ARGV[0]

#we will use a helper function that takes a csv file, gets the desired variables, and creates a new 'clean' csv file that 
#only contains only those variables and their corresponding values

#naming convention kinda sucks here; names of arguments subject to change
def cleanIt(path, variables)
	reader = CSV.open(path, 'r', ?,, ?\r)
	
	#retrieving the name of the file
	baseName = File.basename(path)
	
	#keeping track of the indices we want to keep (these correspond to the variables we wanna keep)
	goodIndices = {}
	
	cleanString = ""
	
	row1 = reader.shift
	row1.each do |item|
		if variables.include?(item)
			goodIndices[row1.index(item)]=true
		end
	end
	
	reader.close
	
	CSV.open(path,'r', ?,, ?\r) do |row|
		tempStr = row.select { |item| goodIndices[row.index(item)]==true }.join(',') + "\n"
		cleanString +=  tempStr
	end
	
	writer = File.new(baseName.insert(-5,"_clean"), 'w')
	writer.write(cleanString)
	writer.close
end

Find.find(loc) do |path|
	if !FileTest.directory? path and path =~ /.csv$/
		#run the helper function
		cleanIt(path, variables)
	else
		next
	end
end