from pathlib import Path

c.editor.command = ['kitty', 'nvim', '-f', '{file}']
c.editor.encoding = 'utf-8'
c.tabs.position = 'top'
c.tabs.width = '10%'
c.tabs.background = True
c.auto_save.session = True
c.hints.mode = 'letter'
c.content.cookies.accept = 'all'
c.fonts.default_size = '12pt'
c.fonts.web.size.default = 20
c.zoom.default = '125%'
c.aliases = {
    "q": "tab-close",
    "qa": "quit",
    'help': 'help --tab',
}
c.content.pdfjs = True
c.input.insert_mode.plugins = True
c.scrolling.smooth = True
c.scrolling.bar = 'always'
c.completion.use_best_match = True
c.url.incdec_segments = ['path', 'query']
c.statusbar.position = 'top'
c.input.insert_mode.auto_load = True
c.downloads.location.directory = f'{Path.home()}/Downloads'
c.tabs.show_switching_delay = 3000
c.session.lazy_restore = True

c.url.searchengines['g'] = 'https://www.google.com.ar/search?q={}'
c.url.searchengines[
    'ec'] = 'https://translate.google.com/#view=home&op=translate&sl=auto&tl=zh-TW&text={}'
c.url.searchengines[
    'amzn'] = 'https://www.amazon.com/s/ref=nb_sb_noss_2?url=search-alias%3Daps&field-keywords={}'
c.url.searchengines[
    'drive'] = 'https://drive.google.com/corp/drive/u/0/search?q={}'
c.url.searchengines[
    'ce'] = 'https://translate.google.com/#view=home&op=translate&sl=auto&tl=en&text={}'
c.url.searchengines['keep'] = 'https://keep.google.com/#search/text%253D{}'
c.url.searchengines[
    'map'] = 'https://www.google.com/maps/search/{}?hl=en&source=opensearch'
c.url.searchengines[
    'scholar'] = 'https://scholar.google.com/scholar?hl=en&as_sdt=0%2C5&q={}&btnG='
c.url.searchengines[
    'yt'] = 'https://www.youtube.com/results?search_query={}&utm_source=opensearch'

c.url.searchengines["DEFAULT"] = "https://www.google.com.ar/search?q={}"

c.bindings.commands['normal'] = {
    'h': 'back',
    'l': 'forward',
    '<ctrl-h>': 'tab-prev',
    '<ctrl-l>': 'tab-next',
    '<ctrl-shift-tab>': 'tab-prev',
    '<ctrl-tab>': 'tab-next',
    'GF': 'hint links fill :spawn google-chrome  {hint-url}',
    'Go': 'set-cmd-text :spawn google-chrome ',
    ';': 'set-cmd-text :',
    '<ctrl-t>': 'set-cmd-text -s :open -t',
    'tp': 'tab-pin',
    '<shift-k>': 'zoom-in',
    '<shift-j>': 'zoom-out',
    'd': 'fake-key <space>',
    'u': 'fake-key <shift-space>',
    'x': 'tab-close',
    'X': 'undo',
    '<backspace>': 'enter-mode insert ;; fake-key <backspace>',
    '<delete>': 'enter-mode insert ;; fake-key <delete>',
    '<alt-m>': 'fake-key <space> ;; spawn --userscript view_in_mpv',
    '<alt-d>': 'download-clear',
    '<alt-p>': 'spawn --userscript qute-pass',
    '<alt-f>':
    'config-cycle statusbar.hide ;; config-cycle tabs.show switching always ;; fullscreen',
    '<F11>':
    'config-cycle statusbar.hide ;; config-cycle tabs.show switching always ;; fullscreen',
    '<ctrl-shift-p>': 'open -p',
    '<ctrl-alt-h>': 'tab-move -',
    '<ctrl-alt-l>': 'tab-move +',
}

c.bindings.commands['hint'] = {
    '<ctrl-c>': 'leave-mode',
}

c.bindings.commands['caret'] = {
    '<ctrl-c>': 'leave-mode',
}

c.bindings.commands['command'] = {
    '<ctrl-k>': 'command-history-prev',
    '<ctrl-j>': 'command-history-next',
    '<ctrl-u>': 'leave-mode',
    '<alt-h>': 'rl-beginning-of-line',
    '<alt-l>': 'rl-end-of-line',
}

c.bindings.commands['insert'] = {
    'jk': 'leave-mode',
    '<alt-h>': 'fake-key <home>',
    '<alt-l>': 'fake-key <end>',
    '<alt-p>': 'spawn --userscript qute-pass',
    '<alt-shift-p>': 'spawn --userscript qute-pass --password-only',
    '<ctrl-alt-h>': 'fake-key <ctrl-left>',
    '<ctrl-alt-l>': 'fake-key <ctrl-right>',
    '<ctrl-h>': 'fake-key <left>',
    '<ctrl-l>': 'fake-key <right>',
    '<ctrl-k>': 'fake-key <up>',
    '<ctrl-j>': 'fake-key <down>',
    '<ctrl-u>': 'fake-key <shift-home><delete>',
    '<ctrl-shift-alt-h>': 'fake-key <ctrl-shift-left>',
    '<ctrl-shift-alt-l>': 'fake-key <ctrl-shift-right>',
    '<ctrl-shift-h>': 'fake-key <shift-left>',
    '<ctrl-shift-l>': 'fake-key <shift-right>',
    '<ctrl-shift-j>': 'fake-key <shift-down>',
    '<ctrl-shift-k>': 'fake-key <shift-up>',
    '<ctrl-w>': 'fake-key <ctrl-shift-left><delete>',
    '<alt-d>': 'fake-key <ctrl-shift-right><delete>',
    '<alt-d>': 'fake-key <ctrl-shift-right><delete>',
}
