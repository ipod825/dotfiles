#!/usr/bin/env python

import re
from urllib.request import Request, urlopen

url = 'https://www.citibank.com.tw/TWGCB/apba/fxrts/InitializeSubApp.do?TTC=29&selectedBCC=TWD'

req = Request(url, headers={'User-Agent': 'XYZ/3.0'})
html = urlopen(req, timeout=20).read().decode('utf-8')

i = 0
for m in re.finditer(r'>([0-9]+.[0-9]+)<', html):
    res = m.group(1)
    i += 1
    if i == 2:
        break

print(res[:5])
