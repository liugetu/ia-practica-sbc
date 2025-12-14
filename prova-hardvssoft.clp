;;; ---------------------------------------------------------
;;; prova-hardvssoft.clp
;;; Joc de prova per comparar criteris hard vs soft
;;; 
;;; - Oferta 1: Compleix TOTS els criteris HARD però CAP dels SOFT
;;; - Oferta 2: Compleix TOTS els criteris SOFT però CAP dels HARD
;;; 
;;; Criteris HARD: preu, superficie, dormitoris
;;; Criteris SOFT: serveis propers, lloc de treball/estudi, 
;;;                qualitat, llum, característiques, durada contracte, numBanys
;;; ---------------------------------------------------------

(definstances prova-hardvssoft

  ;;; ------------------------------
  ;;; BARRIS
  ;;; ------------------------------

  ([barri-gracia] of Neighbourhood
    (NeighbourhoodName "Gràcia")
    (safety 4)
    (averagePrice 900.0)
  )

  ([barri-oferta1] of Neighbourhood
    (NeighbourhoodName "Zona Lluny")
    (safety 2)
    (averagePrice 600.0)
  )

  ;;; ------------------------------
  ;;; LOCALITZACIONS
  ;;; ------------------------------

  ([loc-gracia] of Location
    (latitude 41.403)
    (longitude 2.160)
    (isSituated [barri-gracia])
  )

  ([loc-oferta1] of Location
    (latitude 41.450)
    (longitude 2.250)
    (isSituated [barri-oferta1])
  )

  ([loc-oferta2] of Location
    (latitude 41.403)
    (longitude 2.160)
    (isSituated [barri-gracia])
  )

  ;;; ------------------------------
  ;;; HABITACIONS
  ;;; ------------------------------

  ([room-hard-1] of Room
    (isDouble TRUE))
  ([room-hard-2] of Room
    (isDouble FALSE))
  ([room-soft-1] of Room
    (isDouble TRUE))

  ;;; ------------------------------
  ;;; SERVEIS
  ;;; ------------------------------

  ([parc-oferta2] of GreenArea
    (serviceName "Parc del Barri")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-oferta2])
  )

  ([health-oferta2] of HealthCenter
    (serviceName "CAP Gràcia")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-oferta2])
  )

  ([supermarket-oferta2] of Supermarket
    (serviceName "Mercadona Gràcia")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-oferta2])
  )

  ([transport-oferta2] of Transport
    (serviceName "Metro Fontana")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-oferta2])
  )

  ;;; ------------------------------
  ;;; PROPIETATS
  ;;; ------------------------------

  ;; OFERTA 1: Compleix criteris HARD però NO els SOFT
  ;; Preu: 750€ (OK), Superfície: 55m² (OK), Dormitoris: 2 (OK)
  ;; Però: lluny de Gràcia, sense serveis, baixa qualitat, poca llum
  ([pis-hard] of Apartment
    (address "Carrer Lluny, 1")
    (area 55)
    (naturalLight 1)
    (state 1)
    (floor 0)
    (numBathrooms 1)
    (hasSquatters FALSE)
    (hasDampness FALSE)
    (hasLeaks FALSE)
    (isSoundproof FALSE)
    (hasRoom [room-hard-1] [room-hard-2])
    (locatedAt [loc-oferta1])
  )

  ;; OFERTA 2: Compleix criteris SOFT però NO els HARD
  ;; Preu: 1200€ (NO OK), Superfície: 40m² (NO OK), Dormitoris: 1 (NO OK)
  ;; Però: a Gràcia, amb tots els serveis, excel·lent qualitat, molta llum
  ([pis-soft] of Apartment
    (address "Carrer de Gràcia, 123")
    (area 40)
    (naturalLight 5)
    (state 5)
    (floor 3)
    (numBathrooms 2)
    (hasSquatters FALSE)
    (hasDampness FALSE)
    (hasLeaks FALSE)
    (isSoundproof TRUE)
    (hasRoom [room-soft-1])
    (locatedAt [loc-oferta2])
  )

  ;;; ------------------------------
  ;;; PERFILS DE CLIENT
  ;;; ------------------------------

  ([perfil-hardvssoft] of Individual)

  ;;; ------------------------------
  ;;; CLIENTS
  ;;; ------------------------------

  ([client-hardvssoft] of Client
    (hasProfile [perfil-hardvssoft])
    (clientAge 28)
    (clientMaxPrice 800.0)
    (numTenants 1)
    (minArea 50)
    (minDorms 2)
    (minReasonablePrice 600)
    (needsDoubleBedroom no)
    (priceFlexibility 5)
    (wantsGreenArea si)
    (wantsHealthCenter si)
    (wantsNightLife no)
    (wantsSchool no)
    (wantsStadium no)
    (wantsSupermarket si)
    (wantsTransport si)
    (minMonthsClient 12)
    (worksOrStudies [loc-gracia])
  )

  ;;; ------------------------------
  ;;; OFERTES DE LLOGUER
  ;;; ------------------------------

  ([oferta-hard] of RentalOffer
    (hasProperty [pis-hard])
    (maxPeople 2)
    (minMonths 24)
    (price 750.0)
  )

  ([oferta-soft] of RentalOffer
    (hasProperty [pis-soft])
    (hasFeature [FeatureBalcony] [FeatureAirOrHeating] [FeatureFurniture] [FeatureAppliances])
    (maxPeople 1)
    (minMonths 6)
    (price 1200.0)
  )

  ;;; ------------------------------
  ;;; PROXIMITATS
  ;;; ------------------------------

  ([prox-oferta2-parc] of Proximity
    (nearProperty [pis-soft])
    (nearService [parc-oferta2])
    (distanceCategory 0)
  )

  ([prox-oferta2-health] of Proximity
    (nearProperty [pis-soft])
    (nearService [health-oferta2])
    (distanceCategory 0)
  )

  ([prox-oferta2-supermarket] of Proximity
    (nearProperty [pis-soft])
    (nearService [supermarket-oferta2])
    (distanceCategory 0)
  )

  ([prox-oferta2-transport] of Proximity
    (nearProperty [pis-soft])
    (nearService [transport-oferta2])
    (distanceCategory 0)
  )

) ;; fi de definstances prova-hardvssoft
