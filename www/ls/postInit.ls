ig.ie8 = -1 isnt navigator.appVersion.indexOf "MSIE 8"
if not ig.ie8
    style = document.createElement 'style'
        ..innerHTML = ig.data.style
    document.getElementsByTagName 'head' .0.appendChild style
else
    style = document.createElement 'link'
        ..rel = "stylesheet"
        ..type = "text/css"
        ..href = "http://datasklad.ihned.cz/euvolby-dlazdice/www/screen.css"
    document.getElementsByTagName 'head' .0.appendChild style
