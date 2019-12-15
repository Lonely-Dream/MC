import requests
import re
url="http://tmsl.nxu.edu.cn"
headers={
    'Accept': 'text/html, application/xhtml+xml, image/jxr, */*',
    'Accept - Encoding':'gzip, deflate',
    'Accept-Language':'zh-Hans-CN, zh-Hans; q=0.5',
    'Connection':'Keep-Alive',
    
    'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36 Edge/15.15063'
    }
'''
'Host':'zhannei.baidu.com',
'''
text="123"
pattern='.*?<li><span>(.*?)</span>.*?title="(.*?)</a></li>.*?'
p=re.compile(pattern)
r=requests.get(url,headers=headers)
if r.status_code==200:
    r.encoding=r.apparent_encoding
    print(r.encoding)
    text=r.text
    result=p.findall(text)
    for it in result:
        print(it)
    #print(matchobj)
    #print(r.text)
else:
    print(r.status_code)
    print("ERROR")
