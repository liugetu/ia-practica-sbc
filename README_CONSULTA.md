# Sistema de Consulta de Recomanacions - CLIPS

Aquest fitxer permet consultar les recomanacions d'alquiler generades pel sistema expert.

## Ús

### Opció 1: Execució interactiva amb menú

```bash
clips -f run_query_all2.clp
```

El menú ofereix tres opcions:

1. **Mostrar totes les recomanacions**: Mostra totes les recomanacions generades per tots els clients
2. **Mostrar recomanacions d'un client específic**: Demana el nom d'un client i mostra només les seves recomanacions amb detalls de les ofertes
3. **Sortir**: Surt del sistema

### Opció 2: Consulta específica per script

Per consultar un client específic directament des de codi:

```clips
(load "ontologia.clp")
(load "inicialitzacio.clp")
(load "expert.clp")
(reset)
(run)

;; Carregar la funció
(load "run_query_all2.clp")

;; Consultar un client (amb claudàtors)
(mostrar-recomanacions-client [client-parella-centre])
```

## Clients disponibles

Els clients existents al sistema són:

- `[client-parella-centre]` - Parella jove que busca pis al centre
- `[client-familia-verda]` - Família que prefereix zones verdes
- `[client-estudiants-campus]` - Estudiants que volen estar a prop del campus
- `[client-gent-gran-tranquil]` - Gent gran que necessita tranquil·litat
- `[client-jove-centre-lowcost]` - Jove que busca preu baix al centre

## Exemple de sortida

```
=== RECOMANACIONS PER AL CLIENT [client-parella-centre] ===

  Oferta: [oferta-pis-centre]
    Adreça: C/ Major 10, Barri Centre
    Preu: 950.0 €/mes
    Superfície: 75 m2
    Nivell: molt recomenat
  ----------------------------------------
  Oferta: [oferta-duplex-centre]
    Adreça: Rbla. Nova 3, Barri Centre
    Preu: 1600.0 €/mes
    Superfície: 90 m2
    Nivell: recomenat
  ----------------------------------------
```

## Funcions disponibles

### `mostrar-totes-recomanacions`

Mostra un resum de totes les recomanacions generades.

### `mostrar-recomanacions-client ?nom-client`

Mostra les recomanacions per un client específic amb informació detallada:
- Nom de l'oferta
- Adreça del immoble
- Preu mensual
- Superfície
- Nivell de recomanació

**Paràmetres:**
- `?nom-client`: El nom de la instància del client (amb claudàtors, p.ex. `[client-parella-centre]`)

### `menu-interactiu`

Inicia el menú interactiu per consultar les recomanacions.

## Notes tècniques

- Els noms de clients han d'incloure els claudàtors: `[nom-client]`
- El sistema carrega automàticament l'ontologia, les dades d'inicialització i el sistema expert
- Les recomanacions es generen executant `(run)` després de `(reset)`
- Si un client no existeix, el sistema mostra un missatge d'error
