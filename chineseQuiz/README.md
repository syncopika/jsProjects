<h2>chineseQuiz</h2>
* small app intended to test the user's knowledge of a random Chinese character's definition and pinyin.    
http://syncopika.tumblr.com/chinesequizapp
    
~~My next step is to try to collect as many characters as I can and format each in a table, i.e. {value: "熊", pinyin: xiong2, ...}    
I think I can achieve this with web-scraping!~~    
    
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
<b>updated output!</b> I intended to capture also the traditional form of some characters, but it looks like it's not working too well yet.
```
var characters = [

//1 STROKE RADICAL CHARACTERS
{value: '丨', pinyin: 'gun3', definition: "Kangxi radical №2;Shuōwén Jiězì radical №10;"},
{value: '丩', pinyin: 'jiu1', definition: "wind, gather, collect, rectify, supervise, accuse, twist;hinged cord;"},
{value: '丫;ㄚ', pinyin: 'ya1', definition: "bifurcation;fork;"},
{value: '丬;爿', pinyin: '', definition: "half of tree trunk;rad. no. 90;"},
{value: '丯;丰', pinyin: 'jie4', definition: "dense;"},
{value: '丮;丸', pinyin: 'ji3,ji2', definition: "to catch;"},
{value: '丰;丯', pinyin: 'feng1', definition: "beautiful, colourful;abundant, lush, bountiful, plenty ;55th hexagram of the I Ching ;"},
{value: '中', pinyin: 'zhong1,zhong4', definition: "middle, center;medium, intermediary;(dialectal) all right, OK;within, among, in;while, in the process of, during, in the middle of;China, Chinese;A surname​. Zhong;"},
{value: '申;田', pinyin: 'shen1', definition: "to state to a superior, report;to extend;ninth of twelve earthly branches ;"},
{value: '凸', pinyin: 'tu1,tu2,die2', definition: "protrude, bulge out, convex;"},
{value: '由;田', pinyin: 'you2', definition: "cause, reason;from;"},
{value: '卡;𠧗', pinyin: 'ka3,qia3,ka3,ka3,ka3,ka3', definition: "to wedge; to get stuck; to be jammed; to become tightly wedged;to clip; to fasten;to scrag; to choke;(of videos) to freeze up, to buffer, to stop loading;a pin, a fastener;a checkpoint, a checkpost;"},
{value: '且;旦', pinyin: 'qie3', definition: "moreover, also ;about to, will soon ;"},
{value: '凹', pinyin: 'ao1', definition: "concave, hollow, depressed;a pass, valley;"},
{value: '甲;田', pinyin: 'jia3,jia3', definition: "armor, shell;fingernails;the first of the ten heavenly stems;"},
{value: '北', pinyin: 'bei3,bo4', definition: "north; northern;"},
{value: '丱;卝', pinyin: 'guan4,kuang4', definition: "child's hairstyle bound in two tufts;ore;"},
{value: '电;電', pinyin: '', definition: ""},
{value: '曲;麹', pinyin: 'qu1,qu3', definition: "crooked, bent;wrong, false;sheet music;yeast, mold;"},
{value: '串', pinyin: 'chuan4,guan4', definition: "string;relatives;conspire;skewer;"},
{value: '卥', pinyin: '', definition: "(same as 西) west, western;westward, occident;"},
{value: '畅;暢', pinyin: '', definition: ""},
{value: '丳', pinyin: 'chan3', definition: "spit, grill;a skewer;"},
{value: '非;韭', pinyin: 'fei1', definition: "not be; is not; not;wrong; incorrect;to reproach; to blame;(colloquial) Used to insist on something. to have got to; to simply must不行，我非得走。  ―  Bùxíng, wǒ fēi děi zǒu.  ―  No, I must go.;Abbreviation of ;"},
{value: '临;臨', pinyin: '', definition: ""},
...
```
The most current implementation gathers the simplified and traditional characters from one webpage, and relies on another webpage for the definition. After trying out this program on a larger list containing over 500 characters, I think this program is too slow and inefficient to be used to actually gather as many characters as possible. Based on output (every time a character was processed) to the command line, it seemed to take on average between 1 and 2 seconds per character (so I think it runs approximately O(n)). 

