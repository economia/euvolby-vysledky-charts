require! {
    xml: xml2js
    fs
    iconv.Iconv
}
iconv = new Iconv \iso-8859-2 \utf-8
iconvWin = new Iconv \cp1250 \utf-8
(err, file) <~ fs.readFile "#__dirname/../data/eprkl.xml"
file = iconvWin.convert file
(err, stranyXml) <~ xml.parseString file
strany_zkratky = []
stranyXml.EP_RKL.EP_RKL_ROW.forEach ->
    cislo = parseInt it.ESTRANA.0, 10
    zkratka = it.ZKRATKAE8.0
    strany_zkratky[cislo] = zkratka
(err, file) <~ fs.readFile "#__dirname/../data/vysledky.xml"
file = iconv.convert file
(err, xml) <~ xml.parseString file
ucast = xml.VYSLEDKY.CR.0.UCAST.0.$
strany = xml.VYSLEDKY.CR.0.STRANA

ucast = 0.01 * parseFloat ucast.UCAST_PROC
strany .= map (xml) ->
    nazev = xml.$.NAZ_STR
    cislo = parseInt xml.$.ESTRANA, 10
    zkratka = strany_zkratky[cislo]
    hlasy = 0.01 * parseFloat xml.HLASY_STRANA.0.$.PROC_HLASU
    hlasy_count = parseInt xml.HLASY_STRANA.0.$.HLASY, 10
    mandaty = if xml.MANDATY_STRANA
         xml.MANDATY_STRANA.0.POSLANEC.map ->
            jmeno = it.$.JMENO
            prijmeni = it.$.PRIJMENI
            pred_hlasy = parseInt it.$.PREDNOSTNI_HLASY, 10
            {jmeno, prijmeni, pred_hlasy}
    else
        []
    {nazev, zkratka, hlasy, hlasy_count, mandaty}
strany.sort (a, b) -> b.hlasy - a.hlasy
<~ fs.writeFile "#__dirname/../data/vysledky.json", JSON.stringify {strany, ucast}
