#chinese character collector 

require "open-uri"
require "openssl"
require "open_uri_redirections"
require "nokogiri"


#pinyin converter

def pinyin_convert(pinyin)
	convertedPinyin = ""
		if (pinyin.index('ù') != nil)
			pinyin.gsub!('ù', 'u')
			convertedPinyin = pinyin + '4'
		elsif (pinyin.index('ǔ') != nil)          
			pinyin.gsub!('ǔ', 'u')
			convertedPinyin = pinyin + '3'
		elsif (pinyin.index('ú') != nil)
			pinyin.gsub!('ú', 'u')
			convertedPinyin = pinyin + '2'
		elsif (pinyin.index('ū') != nil)
			pinyin.gsub!('ū', 'u')
			convertedPinyin = pinyin + '1'
		#a
		elsif (pinyin.index('à') != nil)
			pinyin.gsub!('à', 'a')
			convertedPinyin = pinyin + '4'
		elsif (pinyin.index('ǎ') != nil)
			pinyin.gsub!('ǎ', 'a')
			convertedPinyin = pinyin + '3'
		elsif (pinyin.index('á') != nil)
			pinyin.gsub!('á', 'a')
			convertedPinyin = pinyin + '2'
		elsif (pinyin.index('ā') != nil)
			pinyin.gsub!('ā', 'a')
			convertedPinyin = pinyin + '1'
		#e
		elsif (pinyin.index('è') != nil)
			pinyin.gsub!('è', 'e')
			convertedPinyin = pinyin + '4'
		elsif (pinyin.index('ě') != nil)
			pinyin.gsub!('ě', 'e')
			convertedPinyin = pinyin + '3'
		elsif (pinyin.index('é') != nil)
			pinyin.gsub!('é', 'e')
			convertedPinyin = pinyin + '2'
		elsif (pinyin.index('ē') != nil)
			pinyin.gsub!('ē', 'e')
			convertedPinyin = pinyin + '1'
		#i
		elsif (pinyin.index('ì') != nil)
			pinyin.gsub!('ì', 'i')
			convertedPinyin = pinyin + '4'
		elsif (pinyin.index('ǐ') != nil)
			pinyin.gsub!('ǐ', 'i')
			convertedPinyin = pinyin + '3'
		elsif (pinyin.index('í') != nil)
			pinyin.gsub!('í', 'i')
			convertedPinyin = pinyin + '2'
		elsif (pinyin.index('ī') != nil)
			pinyin.gsub!('ī', 'i')
			convertedPinyin = pinyin + '1'	 
		#o
		elsif (pinyin.index('ò') != nil)
			pinyin.gsub!('ò', 'o')
			convertedPinyin = pinyin + '4'
		elsif (pinyin.index('ǒ') != nil)
			pinyin.gsub!('ǒ', 'o')
			convertedPinyin = pinyin + '3'
		elsif (pinyin.index('ó') != nil)
			pinyin.gsub!('ó', 'o')
			convertedPinyin = pinyin + '2'
		elsif (pinyin.index('ō') != nil)
			pinyin.gsub!('ō', 'o')
			convertedPinyin = pinyin + '1'
		#assuming there are no unicode chars. in the pinyin, which could happen occasionally
		else
			convertedPinyin = pinyin
	end
	return convertedPinyin
end


#use chinese-tools to find characters, use wiktionary to get definition
base_url1 = 'http://www.chinese-tools.com/tools/sinograms.html?r='
base_url2 = 'https://en.wiktionary.org/wiki/'

doc1 = Nokogiri::HTML(open(base_url1))

newfile = "test.js"
file = File.open(newfile, "w")

file.puts "//data provided by Wiktionary (https://en.wiktionary.org/wiki/) under Creative Commons Attribution-ShareAlike 3.0. some pinyin provided by chinese-tools. thanks to chinese-tools and wiktionary!"
file.puts "var characters = ["

#don't forget to change the range of 'i' appropriately to get the actual characters
for i in 22..22 do

#change ul (i.e. to ul[2]) to access the other radicals depending on stroke counts
#the index outside the parentheses indicates which radical in the n-stroke group is specified 
radical = doc1.xpath('(//td/div[3]/div[2]/ul[2]/li/a)[' + i.to_s + ']').text

#puts URI.escape(base_url1 + radical)

newURL = URI.escape(base_url1 + radical)

#READ http://stackoverflow.com/questions/1834342/chinese-character-in-url-with-java
#http://www.justinweiss.com/articles/3-steps-to-fix-encoding-problems-in-ruby/
#URI.escape is super helpful in converting the url to a usable form after attaching a Chinese char in UTF-8


doc2 = Nokogiri::HTML(open(newURL))
#at this point you're on the page with all the characters that have that radical

counter = 1

while (doc2.xpath('(//td/div[3]/div[2]/ul/li/a)[' + counter.to_s + ']').text != "")	
	
	puts "currently accessing character number " + counter.to_s + "!"
	
	counterPinyin = 1
	character = doc2.xpath('(//td/div[3]/div[2]/ul/li/a)[' + counter.to_s + ']').text

	#if character has a SIMPLIFIED version, please include it also
	base_url3 = 'http://www.chinese-tools.com/tools/sinograms.html?q='
	newURL2 = URI.escape(base_url3 + character)
	doc4 = Nokogiri::HTML(open(newURL2))
	if (doc4.xpath('(//div[2]/div[1]/div[2]/div[3]/div)[1]').text == "Simplified")
		character = character + ";" + doc4.xpath('(//div[2]/div[1]/div[2]/div[3]/div)[2]').text
	end
	
	pinyin = ""
	
	#sometimes, wiktionary does not explicitly provide a pinyin (but provides a redirect to another variant character with the same pinyin -__-) so in cases like that, get the pinyin from the chinese-tools page
	#nevermind, just get pinyin from chinese-tools. it's better ^_6
	altPinyinCounter = 1
	#if (doc3.xpath('(//tt/span/a)[1]').text == "")
		#if wiktionary pinyin is not present, use chinese-tools
		while (doc4.xpath('(//div[2]/div[' + altPinyinCounter.to_s + ']/div[1]/span)[2]').text != "")
			altPinyin = doc4.xpath('(//div[2]/div[' + altPinyinCounter.to_s + ']/div[1]/span)[2]').text
			pinyin = pinyin + pinyin_convert(altPinyin) + ","
			altPinyinCounter = altPinyinCounter + 1
		end
		#strip off trailing commas
		pinyin = pinyin[0..(pinyin.length-1)]
	#end
  
	#for wiktionary
	newURL = URI.escape(base_url2 + character)
	
	begin #need begin in order to rescue an exception
	doc3 = Nokogiri::HTML(open(newURL, :allow_redirections => :all, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
	
	####### IMPORTANT!!! sometimes there is not an entry yet for a particular character in wiktionary. therefore, handle those exceptions HERE!!!! #######
	
	#IF FAILURE
	rescue OpenURI::HTTPError => e
		if e.message == "404 Not Found"
			file.puts "{value: " + "'" + character + "'" + ", " + "pinyin: " + "'" + pinyin[0..(pinyin.length-2)] + "'" + ", " + "definition:\"\" " + "}" + ","
			file.print ""
			counter = counter + 1 #next doesn't automatically increment??
			next
		end
		
	#IF SUCCESS
	else
	
=begin
	#not working too well because some characters are simplified versions of other characters, but they themselves have different meanings -__-

	#what if the character has an alternative version/traditional version?
	if (doc3.xpath('(//div/b/a)[1]').text != "")
	character = character + ";" + doc3.xpath('(//div/b/a)[1]').text
	end
=end

	
=begin
	while (doc3.xpath('(//tt/span/a)[' + counterPinyin.to_s + ']').text != "")	
		#fix pinyin here (i.e. ǔ => u3)
		pinyin2 = doc3.xpath('(//tt/span/a)[' + counterPinyin.to_s + ']').text
		pinyin = pinyin + pinyin_convert(pinyin2) + "," #doc3.xpath('(//tt/span/a)[' + counterPinyin.to_s + ']').text
		counterPinyin = counterPinyin + 1
	end
=end
	
	definition = ""
	#for definition, ignore child elements (i.e. if there are quotations for a definition)
	#collect multiple definitions
	definitionCounter = 1
	while (doc3.xpath('(//ol[1]/li)[' + definitionCounter.to_s + ']').text != "")
	addDefinition = doc3.xpath('(//div[4]/ol[1]/li)[' + definitionCounter.to_s + ']').text
	
	#remove line breaks
	addDefinition.gsub!("\n", "")
	
	#revise definition to exclude quotations/excess stuff. 
	#try to avoid as many chinese characters, if any, in the definition as possible
	hasCharacter = "";
	
	addDefinition.each_char{ |c|
		#char.ord == 40 is for left parentheses
		if ((c.ord >= 19968 && c.ord <= 40959) || (c.ord == 40))
			hasCharacter = c
			break
		end
	}
	
	stop = addDefinition.index(hasCharacter)
	
	if !(stop.nil?)
	addDefinition = addDefinition[0..stop-1]
	end
	
=begin
hopefully this will shave off some of the time it takes for this program to run. 
I can manually remove the daggers easily. 
	#some definitions have a dagger ("†") in front. ignore them here.
	#EDIT: it actually indicates an obsolete definition. oh well. 
	if addDefinition[0] == '†'
		addDefinition = addDefinition[1..(addDefinition.length-1)]
	end 
=end 

	
	#lastly, some definitions might be blank, which are concatenated to definition and semi-colons get stacked.
	#prevent that here	
	if addDefinition != ""
	definition = definition + addDefinition + ";"     #//ol[1]/li/a)[1]
	end
	
	definitionCounter = definitionCounter + 1
	end
	
	#put everything together
	file.puts "{value: " + "'" + character + "'" + ", " + "pinyin: " + "'" + pinyin[0..(pinyin.length-2)] + "'" + ", " + "definition: " + "\"" + definition.strip + "\"" + "}" + ","
	file.print ""
	counter = counter + 1

end #end begin
end  #end while
end 


#close array
file.puts "]"

puts "done!"
