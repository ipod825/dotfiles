#!/usr/bin/env python

import re
import urllib.request

with urllib.request.urlopen(
        'https://www.citibank.com.tw/TWGCB/apba/fxrts/InitializeSubApp.do?TTC=29&selectedBCC=TWD'
) as response:
    html = response.read().decode('utf8')
    i = 0
    for m in re.finditer(r'>([0-9]+.[0-9]+)<', html):
        res = m.group(1)
        i += 1
        if i == 2:
            break

    print(res[:5])
