Aquest programa és capaç de recomanar una propietat òptima segons les preferències d’un client.

El sistema utilitza CLIPS i es compon de:
    · ontologia.clp — Definicions de classes i ontologia.
    · inicialitzacio.clp — Dades inicials i instàncies base.
    · expert.clp — Regles del sistema expert.

Per compilar i executar el sistema:

;;; Load the ontology (class definitions)
(load "ontologia.clp")

;;; Load the initialization data (instances)
(load "inicialitzacio.clp")

;;; Load the expert system rules
(load "expert.clp")

;;; Reset the expert system
(reset)

;;; (Opcional) Crear noves instàncies aquí

;;; Run the expert system
(run)

És possible crear noves instàncies seguint els formats següent:

(make-instance [nou-client-1] of Client
  (hasProfile [perfil])
  (clientAge 25)
  (clientMaxPrice 800.0)
  (numTenants 1)
  (minArea 40)
  (minDorms 1)
  (minReasonablePrice 600)
  (needsDoubleBedroom no)
  (priceFlexibility 15)
  (wantsGreenArea indiferent)
  (wantsHealthCenter indiferent)
  (wantsNightLife si)
  (wantsSchool no)
  (wantsStadium indiferent)
  (wantsSupermarket si)
  (wantsTransport si)
  (minMonthsClient 6)
)

Els perfils acceptats són:
    · Couple
    · Elderly
    · Family
    · Student
    · YungAdult
(Actualment, no hi ha diferències funcionals entre perfils)

(make-instance [loc-nueva-zona] of Location
  (latitude 41.395)
  (longitude 2.175)
)

(make-instance [nueva-prop-dorm-1] of Room
  (isDouble TRUE)
)
(make-instance [nueva-prop-dorm-2] of Room
  (isDouble FALSE)
)

(make-instance [prop-pis-nou] of Apartment
  (address "C/ Nova 25, Barri Modern")
  (area 80)
  (naturalLight 2)
  (state 4)
  (floor 5)
  (hasRoom [nueva-prop-dorm-1] [nueva-prop-dorm-2])
  (locatedAt [loc-nueva-zona])
)

(make-instance [oferta-pis-nou] of RentalOffer
  (hasProperty [prop-pis-nou])
  (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureAirOrHeating])
  (maxPeople 3)
  (minMonths 12)
  (price 1000.0)
)

Per a poder visualitzar totes les recomanacions creades, executar la següent comanda:

(do-for-all-instances
  ((?r Recommendation))
  TRUE
  (printout t
    "Client: " ?r:recommendedFor
    "  Oferta: " ?r:aboutOffer
    "  Nivell: " ?r:recommendationLevel
    crlf))