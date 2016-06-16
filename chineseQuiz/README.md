<h2>chineseQuiz</h2>
* small app intended to test the user's knowledge of a random Chinese character's definition and pinyin. 
    
My next step is to try to collect as many characters as I can and format each in a table, i.e. {value: "熊", pinyin: xiong2, ...}    
I think I can achieve this with web-scraping!    
    
ccGetter2.rb gets a few characters with this radical: "丨"; below is the output:        
```
var characters = [
{value: '丨', pinyin: 'gǔn', definition: "Kangxi radical №2"}
,{value: '丩', pinyin: 'jiū', definition: "wind, gather, collect, rectify, supervise, accuse, twist"}
,{value: '丫', pinyin: 'yā', definition: "bifurcation"}
,{value: '丬', pinyin: '', definition: "half of tree trunk"}
,{value: '丯', pinyin: 'jiè', definition: "dense"}
,{value: '丮', pinyin: 'jǐ,jí', definition: "to catch"}
,{value: '丰', pinyin: 'fēng', definition: "beautiful, colourful"}
,{value: '中', pinyin: 'zhōng,zhòng', definition: "middle, center"}
,{value: '申', pinyin: 'shēn', definition: "to state to a superior, report"}
,{value: '凸', pinyin: 'tū,tú,dié', definition: "protrude, bulge out, convex"}
,{value: '由', pinyin: 'yóu', definition: "cause, reason"}
,{value: '卡', pinyin: 'qiǎ,kǎ,kǎ,kǎ,kǎ,kǎ', definition: "to wedge; to get stuck; to be jammed; to become tightly wedged"}
,{value: '且', pinyin: 'qiě', definition: "moreover, also (post-subject)"}
,{value: '凹', pinyin: 'āo', definition: "concave, hollow, depressed"}
,{value: '甲', pinyin: 'jiǎ,jiǎ', definition: "armor, shell"}
,{value: '北', pinyin: 'běi,bò', definition: "north, northern"}
,{value: '丱', pinyin: 'guàn,kuàng', definition: "child's hairstyle bound in two tufts"}
,{value: '电', pinyin: '', definition: ""}
,{value: '曲', pinyin: 'qū,qǔ', definition: "crooked, bent"}
,{value: '串', pinyin: 'chuàn,guàn', definition: "string"}
,{value: '卥', pinyin: '', definition: "(same as 西) west, western"}
,{value: '畅', pinyin: '', definition: ""}
,{value: '丳', pinyin: 'chǎn', definition: "spit, grill"}
,{value: '非', pinyin: 'fēi', definition: "not, negative, non-"}
,{value: '临', pinyin: '', definition: ""}
,]

```    
my next step is to convert the pinyin to something more simple, i.e. "gǔn" should be converted to "gun3".    
I also want to figure out how to include multiple definitions and different pinyin. 

