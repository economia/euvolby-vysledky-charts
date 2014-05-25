return if not ig.containers.vejir
container = d3.select ig.containers.vejir

container.append \h3
    ..html "Složení Evropského parlamentu"
# container.append \a
#     ..attr \href \#
#     ..html "<span class='content'>Detailní evropské výsledky</span> <span class='raquo'>&raquo</span>"
helpArea = container.append \span
    ..attr \class \helpArea


vysledky = ig.data.vysledky_eu
descriptions =
    "ALDE"       : "Liberální demokraté, české ANO"
    "ECR"        : "Konzervativci, česká ODS"
    "EFD"        : "Liberálové, čeští Svobodní"
    "GREENS/EFA" : "Zelení, česká Strana Zelených"
    "NA"         : "Stany nezařazené do frakce"
    "S&D"        : "Sociální demokraté, česká ČSSD"
    "GUE/NGL"    : "Komunisté, česká KSČM"
    "EPP"        : "Lidovci, čeští KDU-ČSL a TOP 09"
    "Others"     : "Ostatní, dosud nerozřazené strany"

colors =
    "ALDE"       : \#FFD700
    "ECR"        : \#0054A5
    "EFD"        : \#40E0D0
    "GREENS/EFA" : \#009900
    "NA"         : \#999999
    "S&D"        : \#F10000
    "GUE/NGL"    : \#990000
    "EPP"        : \#87CEFA

displayHelp = ({name, seats, percent}) ->
    helpArea.html "Frakce <b>#name</b>:<br /> <b>#seats</b> křesel, tj. <b>#{Math.round percent * 100} %</b><br />#{descriptions[name]}"
hideHelp = ->
    helpArea.html "Po najetí myši na díl grafu se zde zobrazí podrobné informace o&nbsp;politické frakci"
if not ig.ie8
    svg = container.append \svg
        ..attr \height 150
        ..attr \width 300
    arc = d3.svg.arc!
    arcDefinition =
        innerRadius: 80
        outerRadius: 147
        startAngle: Math.PI * 3 / 2
        endAngle: Math.PI
    svg.selectAll \path .data vysledky .enter!append \path
        ..attr \transform 'translate(150, 150)'
        ..attr \fill -> colors[it.name]
        ..attr \d ->
            arcAngle = Math.PI * it.percent
            arcDefinition.endAngle = arcDefinition.startAngle + arcAngle
            d = arc arcDefinition
            arcDefinition.startAngle += arcAngle
            d
        ..on \mouseover displayHelp
        ..on \click displayHelp
        ..on \mouseout hideHelp
else
    container.append \div
        ..attr \class \bar
        ..selectAll \div .data vysledky .enter!append \div
            ..attr \class \group
            ..style \background-color -> colors[it.name]
            ..style \width -> "#{Math.round it.percent * 100}%"
            ..on \mouseover displayHelp
            ..on \click displayHelp
            ..on \mouseout hideHelp
hideHelp!
