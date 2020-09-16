# Progetto-Reti-Logiche-2020 - a.a. 2019/2020
Lo scopo del progetto è di implementare un componente che rispettasse la codifica a bassa dissipazione di potenza denominata "Working Zone".

## Descrizione Generale
Il metodo di codifica Working Zone è un metodo pensato per il Bus Indirizzi che si usa per trasformare il valore di un indirizzo quando questo viene trasmesso, se appartiene a certi intervalli (detti appunto working-zone). Una working-zone è definita come un intervallo di indirizzi di dimensione fissa che parte da un indirizzo base. All’interno dello schema di codifica possono esistere multiple working-zone.

## Implementazione
Il compontente consiste essenzialmente in una macchina a stati, che salvando in registri locali i valori delle Working Zone, procede poi a controllare l'appartenenza in one hot del valore da codificare a una delle Working Zone attraverso un algoritmo di ricerca iterativa.
Si è deciso di salvare in dei registri locali le working zone poiché si è ritenuto che molteplici valori dovessero essere confrontati con le Working Zone, mentre l'algoritmo di ricerca iterativa si è rivelato il più semplice e adatto per rispettare sia la filosofia della codifica a bassa dissipazione di potenza che nell'affrontare il problema che le Working Zone non fossero ordinate e presumibilmente alcune potessero assumere lo stesso valore (risolvendo in questo modo dei casi limite).

## Test Bench
Si è usufruito delle Test Bench offerte dalle specifiche e in seguito si ha provato diverse situazioni di reset per verificare il corretto comportamento del componente.

## Sviluppatori
[Stefano Zaffiretti](https://github.com/StefanoZaffiretti)
[Eugenio Terzi](https://github.com/EugenioTerzi)
