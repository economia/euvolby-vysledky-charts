maxHeight = 160px
container = d3.select ig.containers.base
pekac = container.append \div
    ..attr \class \pekac
barchartArea = pekac.append \div
    ..attr \class \barchartArea
barchartBelt = barchartArea.append \div
    ..attr \class \barchartBelt
formatPercents = ({hlasy}) ->
    if hlasy > 0.1
        "#{Math.round hlasy * 100} %"
    else
        "#{(hlasy * 100).toFixed 1 .replace '.' ','} %"

{strany, ucast} = ig.data.vysledky
y = d3.scale.linear!
    ..domain [0 strany.0.hlasy]
    ..range [0 150]
for strana in strany
    strana.height = Math.round y strana.hlasy

drawMandat = ({jmeno, prijmeni})->
    mandatArea.html "#jmeno #prijmeni"

drawVoteCount = ({nazev, hlasy_count}) ->
    mandatArea.html "#nazev: celkem #{ig.utils.formatPrice hlasy_count} hlasů"

drawMandatEmpty = ({zkratka}) ->
    mandatArea.html "#zkratka nezískala žádný mandát"

clearMandat = ->
    mandatArea.html "Po najetí myši na sloupek se zde zobrazí jméno poslance"

mandatArea = pekac.append \div
    ..attr \class \mandatArea
    ..html "Po najetí myši na sloupek se zde zobrazí jméno poslance"

parties = barchartBelt.selectAll \div.bar .data strany .enter!append \div
    ..attr \class \party
    ..append \div
        ..attr \class \value
        ..attr \title ({nazev, hlasy_count}) -> "#nazev: celkem #{ig.utils.formatPrice hlasy_count} hlasů"
        ..html formatPercents
        ..on \click drawVoteCount
        ..on \mouseover drawVoteCount
        ..on \mouseout clearMandat
    ..append \div
        ..attr \class \name
        ..html (.zkratka)
    ..append \div
        ..attr \class \bar
        ..classed \empty (.mandaty.length == 0)
        ..style \height -> "#{it.height}px"
        ..selectAll \div.mandat .data (.mandaty) .enter!append \div
            ..attr \class \mandat
            ..attr \title ({jmeno, prijmeni})-> "#jmeno #prijmeni"
            ..style \height (mandat, i, parentI) ->
                parent = strany[parentI]
                totalHeight = parent.height
                height = totalHeight / parent.mandaty.length
                "#{height}px"
            ..style \bottom (mandat, i, parentI) ->
                parent = strany[parentI]
                totalHeight = parent.height
                height = totalHeight / parent.mandaty.length
                "#{height * i}px"
            ..on \click drawMandat
            ..on \mouseover drawMandat
            ..on \mouseout clearMandat

parties.selectAll \.bar.empty
    ..on \mouseover drawMandatEmpty
    ..on \click drawMandatEmpty
    ..on \mouseout clearMandat
supplementalGroup = pekac.append \div
    ..attr \class \supplemental

ig.supplementalCircles.prepare supplementalGroup
ig.supplementalCircles.set ucast

ig.supplementalPaginator.init do
    barchartArea
    barchartBelt
    Math.ceil strany.length / 7
