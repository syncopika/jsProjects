=begin
small script to format arrays like this:

before:
[
  { 
    "country": "Croatia", 
    "value": 0.8333333333333334 
  }, 
  { 
    "country": "Russia", 
    "value": 0.15714285714285717 
  }, 
  ...
  ]
  
after:
[
{     "country": "Croatia",     "value": 0.8333333333333334   }, 
{     "country": "Russia",     "value": 0.15714285714285717   }, 
]

I came across this problem when I wanted to hardcode some csv data for my charts. I used the console in Chrome and copied the arrays.
It gets hard to look at when there are many keys, so I wanted to reformat the hashes.
=end

#make a new file with the formatted array
newFile = File.open("newArray.txt", "w")

#select file with the unformatted array
file = File.open( "noFormatArray.txt", "r")

counter = 0
file.readlines.each do |line|
	
	#this firs if condition might not be necessary
	#if the variable is not declared
	if(line.include?("]") || line.include?("["))
		newFile.puts line
	elsif !(line.include?("{") && line.include?("}"))
		newLine = line.gsub("\n", "")
		newFile.print newLine
		counter = counter + 1
	end
	
	#the counter limit will depend on how
	#many keys you have in each hash
	if (counter == 4)
		newFile.puts
		counter = 0
	end
end
newFile.close
