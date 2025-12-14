# IA Pràctica 2 - Sistema Basat en el Coneixement (SBC)

Aquest programa és capaç de **recomanar una propietats òptimes** segons les preferències d'un client utilitzant un sistema expert basat en regles implementat en CLIPS.

El sistema avalua diferents ofertes de lloguer considerant criteris restrictius (hard) com el preu, superfície i nombre de dormitoris, així com criteris preferibles (soft) com la proximitat a serveis, qualitat de la vivenda i característiques addicionals.

### Estructura del projecte

- **`ontologia.clp`** - Definició de classes i estructura del domini
- **`expert.clp`** - Sistema expert amb regles de recomanació
- **`exe.clp`** - Fitxer principal executable amb menú interactiu
- **`vivendes-barcelona.clp`** - Base de dades amb 50 vivendes a Barcelona
- **`clients-barcelona.clp`** - Base de dades amb 18 perfils de clients
- **`prova-*.clp`** - Jocs de prova per validar el sistema
- **`informe-practica2.pdf`** - Informe de la pràctica amb tot explicat

### Execució

El fitxer executable es el `exe.clp`, aquest fitxer s'encarrega de carregar l'ontologia, la
inicialització (vivendes, clients) i el sistema expert.

La comanda per executar el programa des de un terminal (clips instalat en el directori de treball) és el següent:

```bash
clips -f exe.clp
```

Una vegada executat, espera un moment i prem Enter per accedir al menú interactiu.

Les opcions són intuïtives, i permeten:
```
  1. Afegir un nou client
  2. Llistar totes les instàncies de client
  3. Afegir una nova oferta de lloguer
  4. Mostrar totes les ofertes de lloguer
  5. Mostrar les recomanacions per a un client en concret
  6. Sortir del menú interactiu
```

Depenent de l'opció escollida, la terminal mostrarà les instruccions per introduir les dades necessàries de manera interactiva.

### Canviar els fitxers d'entrada

Per utilitzar diferents bases de dades o jocs de prova, edita el fitxer `exe.clp` i comenta/descomenta les línies d'inicialització corresponents:

```clips
;;; Opció 1: Base de dades completa de Barcelona
(load "vivendes-barcelona.clp")
(load "clients-barcelona.clp")

;;; Opció 2: Jocs de prova específics
;;;(load "prova-molt-recomenat.clp")
;;;(load "prova-recomenat.clp")
```

Per suposat, també es pot fer manualment des de Clips.
