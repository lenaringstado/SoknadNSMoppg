---
title: "Veiledning"
author: "Rapporteket"
date: "4/10/2019"
output: 
  html_document: 
    keep_md: yes
---

# Lag et register i Rapporteket
Beskrivelsen under er ikke nødvendigvis utfyllende og forutsetter kjennskap til RStudio og bruk av git og GitHub. Som en ekstra støtte anbefales [R pacakges](http://r-pkgs.had.co.nz/) av Hadley Wickham og spesielt [beskrivelsen av git og GitHub](http://r-pkgs.had.co.nz/git.html#git-rstudio).

## Prøv tom applikasjon
1. Hent ned prosjektet [rapRegTemplate](https://github.com/Rapporteket/rapRegTemplate) til RStudio (for mer info, se [her](https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects))
1. Åpne fila inst/shinyApps/app1/ui.R og start Shiny-applikasjonen ("Run App")
1. Navigér i applikasjonen for å se på struktur og farger (innhold mangler)

## Lag ditt eget prosjekt basert på templatet
1. Lag et nytt prosjekt i RStudio som en R-pakke
1. Gi pakken et navn som gjerne gjenspeiler overordnet funksjon i pakken, eksempelvis "testRegister"
1. Valgfritt: hak gjerne av for "Create a git repository" også da det vil gi nyttig kunnskap når egne registre skal utvikles seinere
1. Trykk "Create Project".
1. Kopier inn alle filer fra katalogene "inst/" og "R/" i "rapRegTemplate" og legg disse i tilsvarende kataloger i den nye pakken
1. I toppen av "server.ui" endre avhengigheten til R-pakken "rapRegTemplate" til din egen R-pakke
1. Endre DESCRIPTION-fila slik at den blir nogenlunde tilssvarende den som finnes i "rapRegTemplate", særlig det som er gitt under "Depends:", "Imports:" og "Remotes:"
1. Bygg, installér og last pakken i R
1. Test gjerne at innebygget Shiny-applikasjon fungerer på samme vis som i prosjektet "rapRegTemplate"

## Last registerdata
### Alternativ 1: med Docker/Rapporteket
a. Åpne fila R/GetRegData.R
a. Se på de tre delene av funksjonen som definerer registernavn og sql-spørringen samt den som bruker de to forrige til å hente data (og som returnerer ei dataramme fra funksjonen)
a. Sjekk at egen konfigurasjon (i fila /home/rstudio/rap_config) er i henhold til det datagrunnlaget som er gjort tilgjengelig
a. Prøv funksjonen fra kommandolinja (Console i RStudio), _e.g._ `df <- getRegData("navn_på_register")`
a. Sjekk at du får returnert ei dataramme med X observasjoner for Y variabler, _e.g._ `attributes(df)`

### Alternativ 2: uten Docker/Rapporteket
a. Åpne fila R/GetFakeRegData.R
a. Se at funksjonen returnerer et kjedelig og irrelevant innebygget datasett :-(
a. Prøv funksjonen fra kommandolinja (Console i RStudio), _e.g._ `df <- getFakeRegData()`
a. Sjekk at du får returnert ei dataramme med X observasjoner for Y variabler, _e.g._ `attributes(df)`

## Lag innhold i Shiny-applikasjonen, steg 1
Utgangspunket for de neste stegene er bruk av det innebygde datasettet "mtcars", jf. "Alternativ 2" over.

1. Åpne fila inst/shinyApps/app1/ui.R
1. Bla ned til kommentaren ## Brukervalg fordeling av kategorier
1. (Angi ev hvilke linjer som ev skal kommenteres "inn")
1. Lag brukervalg for variabel (må beskrives nærmere når eksempelapplikasjonen er klar)
1. Lag brukervalg for begrensning i tid (må beskrives nærmere når eksempelapplikasjonen er klar)
1. Lag brukervalg for filtrering av observasjoner (må beskrives nærmere når eksempelapplikasjonen er klar)
1. Lagre fila, start applikasjonen og sjekk at brukervalgene vises og at man kan velge de ulike kategoriene slik de ble definert over

## Lag innhold i Shiny-applikasjonen, steg 2
1. Åpne fila inst/shinyApps/app1/server.R
1. Bla ned til kommentaren ## Hent data
1. Hent data på samme måte som gjort under "Last registerdata" over (vis R-kommandoen)
1. Bla ned til kommentaren ## Fordeling av kategorier, figur
1. (Angi hvile linjer som ev skal kommenteres "inn")
1. Lag reaktivt søylediagram (her blir de mye mer tekst og basis R-kode)
1. Bla ned til kommentaren ## Fordeling av kategorier, tabell
1. (Angi hvile linjer som ev skal kommenteres "inn")
1. Lag reaktiv tabell (her blir det også mye mer tekst og basis R-kode)
1. Lagre fila, start applikasjonen og sjekk at figur og tabell er på plass og at disse reagerer på ulike brukervalg

## Lag innhold i Shiny-applikasjonen, steg 3
(Tilsvarende steg 1, men med fordeling over tid)

## Lag innhold i Shiny-applikasjonen, steg 4
(Samme som steg 2, men med fordeling over tid)

## Sjekk inn endringer i git
1. Git er et verktøy for versjonskontroll som gir mulighet for å spore endringer og samarbeide om kode. Basale funksjoner i git er svært nyttinge, men kan virke forvirrende i starten. Sørg for at egen kode (bestandig) versjonshåndteres (i git) og at koden finnes sentralisert og tilgjengelig for deg selv og andre (på GitHub)
1. Sett opp git lokalt og etabler et sentralt repository for din R-pakke gjennom å følge Hadley Wickhams veiledning
1. NB Ved etablering av et nøkkelpar for bruk av Secure Shell (ssh) i kommunikasjonen med GitHub (generelt lurt men også nødvendig for avansert bruk av Rapporteket) er det viktig å påse at disse blir etablert på din egen fysiske datamaskin (og ikke inne i docker-containeren)


## Dytt (push) R-pakken til GitHub
1. Om du ikke allerede har gjort det, lag din egen bruker på GitHub (se over)
1. Valgfritt: om du ikke allerede har gjort det, bli medlem av organisasjonen Rapporteket på GitHub
1. Under din egen side på GitHub, opprett et Repository med navn tilsvarende din egen pakke (e.g. "testRegister)
1. I RStudio, push pakken til ditt nye Repository på GitHub (skjermdumper, men kan bli hårete bak proxy)
