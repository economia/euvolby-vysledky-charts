container = d3.select ig.containers.base
heading = container.append \h3
    ..html "Výsledky eurovoleb"

linkToDetails = container.append \a
    ..html "<span class='content'>Jak to dopadlo ve vaší obci</span> <span class='raquo'>&raquo;</span>"
    ..attr \class \detailsLink
    ..attr \href \http://data.blog.ihned.cz/c1-62241760-podivejte-se-kdo-vyhral-u-vas-vysledky-voleb-ve-vsech-obcich
