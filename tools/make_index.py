#!/usr/bin/env python3
"""Turn the web editor (web/rong-studio.html) into the app's offline page.

The web page loads fabric.js and fonts from CDNs; inside the app everything
comes from android/assets, so this swaps those links for local files and
wraps the page in a full HTML document.

Usage: python3 tools/make_index.py web/rong-studio.html android/assets/index.html
"""
import re
import sys

src, dst = sys.argv[1], sys.argv[2]
s = open(src, encoding="utf-8").read()

s = re.sub(r'<link rel="preconnect"[^>]*>\n?', "", s)
s = re.sub(r'<link rel="stylesheet" href="https://fonts.googleapis.com[^>]*>',
           '<link rel="stylesheet" href="fonts.css">', s)
s = s.replace(
    '<script src="https://cdnjs.cloudflare.com/ajax/libs/fabric.js/5.3.0/fabric.min.js"></script>',
    '<script src="fabric.min.js"></script>\n<script src="tess/tesseract.min.js"></script>')

for leftover in ("fonts.googleapis", "cdnjs.cloudflare"):
    if leftover in s:
        sys.exit(f"make_index: {leftover} link still present; update the replacements above")

head = ('<!doctype html><html lang="bn"><head><meta charset="utf-8">'
        '<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover,user-scalable=no">\n'
        '<style>:root{color-scheme:light}body{margin:0;font:14px system-ui,sans-serif}img{max-width:100%}'
        '[hidden]{display:none!important}*{-webkit-tap-highlight-color:transparent}</style></head><body>')
open(dst, "w", encoding="utf-8").write(head + s + "</body></html>")
print(f"make_index: wrote {dst}")
