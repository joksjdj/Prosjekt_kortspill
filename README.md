# Prosjekt_kortspill
 
Dette er et prosjekt hvor spillerne kan spille en rekke kort spill.
Prosjekte er bygd på Rust som backend og HTML med JS og CSS som frontend.

## Planer:

- Flere kortspill
- Anonymt/Ingen login
- Åpent spill eller lokket (passord)
- Sparke ut uønskede spillere
- Søk
- Chat
- Kansje tourtaments
- Koble til en DB

## Setup:

Jeg kjører den på en raspberry pi 5 og installasjonen er bassert på linux.

For starte webserveren må du først sette opp DB, ved å følge instruksene i .sql filen.
DB-en lagrer middlertidig brukere og spillene som er aktivet.
Passord, navn og alt sensitivt er slettet etter vært spill.