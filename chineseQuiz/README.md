<h2>chineseQuiz</h2>
* small app intended to test the user's knowledge of a random Chinese character's definition and pinyin. 
    
My next step is to try to collect as many characters as I can and format each in a table, i.e. {value: "熊", pinyin: xiong2, ...}    
I think I can achieve this with web-scraping!    
    
ccGetter2.rb gets a few characters with this radical: "丨"; below is the output:        
```
var characters = [
{value: '丨', pinyin: 'gǔn', definition: 'rod'}
,{value: '丩', pinyin: 'jiū', definition: 'wind'}
,{value: '丫', pinyin: 'yā', definition: 'bifurcation'}
,{value: '丬', pinyin: '', definition: 'half'}
,{value: '丯', pinyin: 'jiè', definition: 'dense'}
,{value: '丮', pinyin: 'jǐ', definition: 'catch'}
,{value: '丰', pinyin: 'fēng', definition: 'beautiful'}
,{value: '中', pinyin: 'zhōng', definition: 'middle'}
,{value: '申', pinyin: 'shēn', definition: 'state'}
,{value: '凸', pinyin: 'tū', definition: 'protrude'}
,{value: '由', pinyin: 'yóu', definition: 'cause'}
,{value: '卡', pinyin: 'qiǎ', definition: 'wedge'}
,{value: '且', pinyin: 'qiě', definition: 'moreover'}
,{value: '凹', pinyin: 'āo', definition: 'concave'}
,{value: '甲', pinyin: 'jiǎ', definition: 'armor'}
,{value: '北', pinyin: 'běi', definition: 'north'}
,{value: '丱', pinyin: 'guàn', definition: 'child'}
,{value: '电', pinyin: '', definition: ''}
,{value: '曲', pinyin: 'qū', definition: 'crooked'}
,{value: '串', pinyin: 'chuàn', definition: 'string'}
,{value: '卥', pinyin: '', definition: '西'}
,{value: '畅', pinyin: '', definition: ''}
,{value: '丳', pinyin: 'chǎn', definition: 'spit'}
,{value: '非', pinyin: 'fēi', definition: 'not'}
,{value: '临', pinyin: '', definition: ''}
,]
```    
my next step is to convert the pinyin to something more simple, i.e. "gǔn" should be converted to "gun3".    
I also want to figure out how to include multiple definitions and different pinyin. 

