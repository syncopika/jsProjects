#chinese character collector 

require "open-uri"
require "openssl"
require "open_uri_redirections"
require "nokogiri"

base_url1 = 'http://www.chinese-tools.com/tools/sinograms.html?r='
base_url2 = 'https://en.wiktionary.org/wiki/'

doc1 = Nokogiri::HTML(open(base_url1))

#change ul (i.e. to ul[2]) to access the other radicals depending on stroke counts
#the index outside the parentheses indicates which radical in the n-stroke group is specified 

newfile = "test.js"
file = File.open(newfile, "w")

file.puts "//data provided by Wiktionary (https://en.wiktionary.org/wiki/) under Creative Commons Attribution-ShareAlike 3.0. thank you Wiktionary! :D"
file.puts "var characters = ["

for i in 1..8 do

radical = doc1.xpath('(//td/div[3]/div[2]/ul[1]/li/a)[' + i.to_s + ']').text

#puts URI.escape(base_url1 + radical)

newURL = URI.escape(base_url1 + radical)

#READ http://stackoverflow.com/questions/1834342/chinese-character-in-url-with-java
#http://www.justinweiss.com/articles/3-steps-to-fix-encoding-problems-in-ruby/
#URI.escape is super helpful in converting the url to a usable form after attaching a Chinese char in UTF-8


doc2 = Nokogiri::HTML(open(newURL))
#at this point you're on the page with all the characters that have that radical

counter = 1

while (doc2.xpath('(//td/div[3]/div[2]/ul/li/a)[' + counter.to_s + ']').text != "")	
	counterPinyin = 1
	character = doc2.xpath('(//td/div[3]/div[2]/ul/li/a)[' + counter.to_s + ']').text
    
	newURL = URI.escape(base_url2 + character)
	doc3 = Nokogiri::HTML(open(newURL, :allow_redirections => :all, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
	
	#what if the character has an alternative version/traditional version?
	if (doc3.xpath('(//div/b/a)[1]').text != "")
	character = character + ";" + doc3.xpath('(//div/b/a)[1]').text
	end
	
	pinyin = ""
	while (doc3.xpath('(//tt/span/a)[' + counterPinyin.to_s + ']').text != "")	
		
		#fix pinyin here (i.e. ǔ => u3)
		pinyinCheck = doc3.xpath('(//tt/span/a)[' + counterPinyin.to_s + ']').text
		
		if (pinyinCheck.index('ù') != nil)
			pinyinCheck.gsub!('ù', 'u')
			pinyinCheck = pinyinCheck += '4'
		elsif (pinyinCheck.index('ǔ') != nil)          
			pinyinCheck.gsub!('ǔ', 'u')
			pinyinCheck = pinyinCheck += '3'
		elsif (pinyinCheck.index('ú') != nil)
			pinyinCheck.gsub!('ú', 'u')
			pinyinCheck = pinyinCheck += '2'
		elsif (pinyinCheck.index('ū') != nil)
			pinyinCheck.gsub!('ū', 'u')
			pinyinCheck = pinyinCheck += '1'
		#a
		elsif (pinyinCheck.index('à') != nil)
			pinyinCheck.gsub!('à', 'a')
			pinyinCheck = pinyinCheck + '4'
		elsif (pinyinCheck.index('ǎ') != nil)
			pinyinCheck.gsub!('ǎ', 'a')
			pinyinCheck = pinyinCheck + '3'
		elsif (pinyinCheck.index('á') != nil)
			pinyinCheck.gsub!('á', 'a')
			pinyinCheck = pinyinCheck + '2'
		elsif (pinyinCheck.index('ā') != nil)
			pinyinCheck.gsub!('ā', 'a')
			pinyinCheck = pinyinCheck + '1'
		#e
		elsif (pinyinCheck.index('è') != nil)
			pinyinCheck.gsub!('è', 'e')
			pinyinCheck = pinyinCheck + '4'
		elsif (pinyinCheck.index('ě') != nil)
			pinyinCheck.gsub!('ě', 'e')
			pinyinCheck = pinyinCheck + '3'
		elsif (pinyinCheck.index('é') != nil)
			pinyinCheck.gsub!('é', 'e')
			pinyinCheck = pinyinCheck + '2'
		elsif (pinyinCheck.index('ē') != nil)
			pinyinCheck.gsub!('ē', 'e')
			pinyinCheck = pinyinCheck + '1'
		#i
		elsif (pinyinCheck.index('ì') != nil)
			pinyinCheck.gsub!('ì', 'i')
			pinyinCheck = pinyinCheck + '4'
		elsif (pinyinCheck.index('ǐ') != nil)
			pinyinCheck.gsub!('ǐ', 'i')
			pinyinCheck = pinyinCheck + '3'
		elsif (pinyinCheck.index('í') != nil)
			pinyinCheck.gsub!('í', 'i')
			pinyinCheck = pinyinCheck + '2'
		elsif (pinyinCheck.index('ī') != nil)
			pinyinCheck.gsub!('ī', 'i')
			pinyinCheck = pinyinCheck + '1'	 
		#o
		elsif (pinyinCheck.index('ò') != nil)
			pinyinCheck.gsub!('ò', 'o')
			pinyinCheck = pinyinCheck + '4'
		elsif (pinyinCheck.index('ǒ') != nil)
			pinyinCheck.gsub!('ǒ', 'o')
			pinyinCheck = pinyinCheck + '3'
		elsif (pinyinCheck.index('ó') != nil)
			pinyinCheck.gsub!('ó', 'o')
			pinyinCheck = pinyinCheck + '2'
		elsif (pinyinCheck.index('ō') != nil)
			pinyinCheck.gsub!('ō', 'o')
			pinyinCheck = pinyinCheck + '1'	
			
		end
		
		pinyin = pinyin + pinyinCheck + "," #doc3.xpath('(//tt/span/a)[' + counterPinyin.to_s + ']').text
		counterPinyin = counterPinyin + 1
	end
	
	
	definition = ""
	#for definition, ignore child elements (i.e. if there are quotations for a definition)
	#collect multiple definitions
	definitionCounter = 1
	while (doc3.xpath('(//ol[1]/li)[' + definitionCounter.to_s + ']').text != "")
	addDefinition = doc3.xpath('(//div[4]/ol[1]/li)[' + definitionCounter.to_s + ']').text
	
	#remove line breaks
	addDefinition.gsub!("\n", "")
	
	#revise definition to exclude quotations
	hasCharacter = "";
	
	addDefinition.each_char{ |c|
		if ((c.ord >= 19968 && c.ord <= 40959) || (c.ord == 40))
			hasCharacter = c
			break
		end
	}
	
	stop = addDefinition.index(hasCharacter)
	
	if !(stop.nil?)
	addDefinition = addDefinition[0..stop-1]
	end
	
	definition = definition + addDefinition + ";"     #//ol[1]/li/a)[1]
	definitionCounter = definitionCounter + 1
	end
	
	#put everything together
	file.puts "{value: " + "'" + character + "'" + ", " + "pinyin: " + "'" + pinyin[0..(pinyin.length-2)] + "'" + ", " + "definition: " + "\"" + definition.strip + "\"" + "}" + ","
	file.print ""
	counter = counter + 1
end 

end
#close array
file.puts "]"

puts "done!"
