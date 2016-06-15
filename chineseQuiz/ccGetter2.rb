#chinese character collector 

require "open-uri"
require "openssl"
require "open_uri_redirections"
require "nokogiri"

base_url1 = 'http://www.chinese-tools.com/tools/sinograms.html?r='
base_url2 = 'https://en.wiktionary.org/wiki/'

doc1 = Nokogiri::HTML(open(base_url1))

radical = doc1.xpath('(//td/div[3]/div[2]/ul[1]/li/a)[1]').text

newfile = "test.js"
file = File.open(newfile, "w")

#puts URI.escape(base_url1 + radical)

newURL = URI.escape(base_url1 + radical)

#READ http://stackoverflow.com/questions/1834342/chinese-character-in-url-with-java
#http://www.justinweiss.com/articles/3-steps-to-fix-encoding-problems-in-ruby/
#URI.escape is super helpful in converting the url to a usable form after attaching a Chinese char in UTF-8


doc2 = Nokogiri::HTML(open(newURL))
#at this point you're on the page with all the characters that have that radical

file.puts "var characters = ["

counter = 1
while (doc2.xpath('(//td/div[3]/div[2]/ul/li/a)[' + counter.to_s + ']').text != "")	
	character = doc2.xpath('(//td/div[3]/div[2]/ul/li/a)[' + counter.to_s + ']').text
    
	newURL = URI.escape(base_url2 + character)
	doc3 = Nokogiri::HTML(open(newURL, :allow_redirections => :all, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
	
	pinyin = doc3.xpath('(//tt/span/a)[1]').text
	definition =  doc3.xpath('(//div[4]/ol/li/a)[1]').text     #//ol[1]/li/a)[1]
	file.puts "{value: " + "'" + character + "'" + ", " + "pinyin: " + "'" + pinyin + "'" + ", " + "definition: " + "'" + definition + "'" + "}"
	file.print ","
	counter = counter + 1
end 

file.puts "]"

puts "done!"
