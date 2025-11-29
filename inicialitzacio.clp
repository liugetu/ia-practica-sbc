;;; ---------------------------------------------------------
;;; inicialització.clp
;;; Fets/instàncies d'exemple per provar el sistema d'alquiler
;;;
;;; Es pressuposa que abans s'ha carregat ontologia.clp
;;; (defclass Property, Apartment, House, Duplex, Room, Location,
;;;  PropertyFeature, Service (+ subclasses), Proximity,
;;;  ClientProfile (+ subclasses), Client, RentalOffer, Recommendation, ...)

(definstances inicialitzacio

  ;;; ------------------------------
  ;;; LOCALITZACIONS
  ;;; ------------------------------

  ([loc-centre] of Location
    (latitude 41.390)
    (longitude 2.170)
  )

  ([loc-campus] of Location
    (latitude 41.404)
    (longitude 2.118)
  )

  ([loc-periferia-verda] of Location
    (latitude 41.430)
    (longitude 2.150)
  )

  ([loc-zona-oci] of Location
    (latitude 41.385)
    (longitude 2.180)
  )

  ;;; ------------------------------
  ;;; HABITACIONS
  ;;; ------------------------------

  ;; Pis centre
  ([pis-centre-dorm-1] of Room)
  ([pis-centre-dorm-2] of Room)
  ([pis-centre-sala]    of Room)

  ;; Pis campus
  ([pis-campus-dorm-1] of Room)
  ([pis-campus-dorm-2] of Room)
  ([pis-campus-sala]   of Room)

  ;; Casa perifèria
  ([casa-periferia-dorm-1] of Room)
  ([casa-periferia-dorm-2] of Room)
  ([casa-periferia-dorm-3] of Room)
  ([casa-periferia-sala]   of Room)

  ;; Dúplex centre
  ([duplex-centre-dorm-1] of Room)
  ([duplex-centre-dorm-2] of Room)
  ([duplex-centre-estudi] of Room)
  ([duplex-centre-sala]   of Room)

  ;;; ------------------------------
  ;;; CARACTERÍSTIQUES DE LA PROPIETAT
  ;;; ------------------------------

  ([feat-ascensor]          of PropertyFeature)
  ([feat-balco]             of PropertyFeature)
  ([feat-terrassa]          of PropertyFeature)
  ([feat-jardi]             of PropertyFeature)
  ([feat-garatge]           of PropertyFeature)
  ([feat-calefaccio]        of PropertyFeature)
  ([feat-electrodomestics]  of PropertyFeature)
  ([feat-mobiliari]         of PropertyFeature)
  ([feat-accepta-mascotes]  of PropertyFeature)
  ([feat-piscina-comunit]   of PropertyFeature)
  ([feat-vistes-ciutat]     of PropertyFeature)

  ;;; ------------------------------
  ;;; SERVEIS
  ;;; ------------------------------

  ([parc-central] of GreenArea
    (serviceName "Parc Central")
    (serviceNoiseLevel 2)
  )

  ([cap-centre] of HealthCenter
    (serviceName "CAP Centre")
    (serviceNoiseLevel 3)
  )

  ([zona-bars-centre] of Nightlife
    (serviceName "Zona bars centre")
    (serviceNoiseLevel 8)
  )

  ([escola-publica-centre] of School
    (serviceName "Escola Pública Centre")
    (serviceNoiseLevel 4)
  )

  ([estadi-municipal] of Stadium
    (serviceName "Estadi Municipal")
    (serviceNoiseLevel 7)
  )

  ([super-centre] of Supermarket
    (serviceName "Supermercat Centre")
    (serviceNoiseLevel 4)
  )

  ([super-campus] of Supermarket
    (serviceName "Supermercat Campus")
    (serviceNoiseLevel 3)
  )

  ([metro-l1-centre] of Transport
    (serviceName "Metro L1 - Estació Centre")
    (serviceNoiseLevel 7)
  )

  ([bus-campus] of Transport
    (serviceName "Bus universitat")
    (serviceNoiseLevel 5)
  )

  ;;; ------------------------------
  ;;; PROPIETATS (IMMOBLES)
  ;;; ------------------------------

  ;; Pis lluminós al centre
  ([prop-pis-centre] of Apartment
    (address "C/ Major 10, Barri Centre")
    (area 75)
    (naturalLight 8)
    (state 8)
    (floor "3a planta amb ascensor")
    (hasRoom [pis-centre-dorm-1] [pis-centre-dorm-2] [pis-centre-sala])
    (locatedAt [loc-centre])
  )

  ;; Pis a prop del campus universitari
  ([prop-pis-campus] of Apartment
    (address "Av. Universitat 5, Zona Campus")
    (area 60)
    (naturalLight 7)
    (state 7)
    (floor "2a planta sense ascensor")
    (hasRoom [pis-campus-dorm-1] [pis-campus-dorm-2] [pis-campus-sala])
    (locatedAt [loc-campus])
  )

  ;; Casa adossada en zona tranquil·la i verda
  ([prop-casa-periferia] of House
    (address "Passatge dels Pins 12, Urbanització Verda")
    (area 120)
    (naturalLight 8)
    (state 9)
    (hasRoom [casa-periferia-dorm-1]
             [casa-periferia-dorm-2]
             [casa-periferia-dorm-3]
             [casa-periferia-sala])
    (locatedAt [loc-periferia-verda])
  )

  ;; Dúplex modern al centre amb terrassa
  ([prop-duplex-centre] of Duplex
    (address "Rbla. Nova 3, Barri Centre")
    (area 90)
    (naturalLight 9)
    (state 9)
    (floor "Àtic dúplex")
    (hasRoom [duplex-centre-dorm-1]
             [duplex-centre-dorm-2]
             [duplex-centre-estudi]
             [duplex-centre-sala])
    (locatedAt [loc-zona-oci])
  )

  ;;; ------------------------------
  ;;; PROXIMITATS PROPIETAT - SERVEI
  ;;; distanceCategory: 0 = a prop, 1 = distància mitjana
  ;;; ------------------------------

  ;; Propietat: prop-pis-centre
  ([prox-pis-centre-parc] of Proximity
    (nearProperty [prop-pis-centre])
    (nearService  [parc-central])
    (distanceCategory 0)
  )

  ([prox-pis-centre-metro] of Proximity
    (nearProperty [prop-pis-centre])
    (nearService  [metro-l1-centre])
    (distanceCategory 0)
  )

  ([prox-pis-centre-super] of Proximity
    (nearProperty [prop-pis-centre])
    (nearService  [super-centre])
    (distanceCategory 0)
  )

  ([prox-pis-centre-escola] of Proximity
    (nearProperty [prop-pis-centre])
    (nearService  [escola-publica-centre])
    (distanceCategory 0)
  )

  ([prox-pis-centre-oci] of Proximity
    (nearProperty [prop-pis-centre])
    (nearService  [zona-bars-centre])
    (distanceCategory 0)
  )

  ;; Propietat: prop-pis-campus
  ([prox-pis-campus-bus] of Proximity
    (nearProperty [prop-pis-campus])
    (nearService  [bus-campus])
    (distanceCategory 0)
  )

  ([prox-pis-campus-super] of Proximity
    (nearProperty [prop-pis-campus])
    (nearService  [super-campus])
    (distanceCategory 0)
  )

  ([prox-pis-campus-estadi] of Proximity
    (nearProperty [prop-pis-campus])
    (nearService  [estadi-municipal])
    (distanceCategory 1)
  )

  ;; Propietat: prop-casa-periferia
  ([prox-casa-periferia-parc] of Proximity
    (nearProperty [prop-casa-periferia])
    (nearService  [parc-central])
    (distanceCategory 1)
  )

  ([prox-casa-periferia-cap] of Proximity
    (nearProperty [prop-casa-periferia])
    (nearService  [cap-centre])
    (distanceCategory 1)
  )

  ;; Propietat: prop-duplex-centre
  ([prox-duplex-centre-oci] of Proximity
    (nearProperty [prop-duplex-centre])
    (nearService  [zona-bars-centre])
    (distanceCategory 0)
  )

  ([prox-duplex-centre-metro] of Proximity
    (nearProperty [prop-duplex-centre])
    (nearService  [metro-l1-centre])
    (distanceCategory 0)
  )

  ([prox-duplex-centre-super] of Proximity
    (nearProperty [prop-duplex-centre])
    (nearService  [super-centre])
    (distanceCategory 0)
  )

  ;;; ------------------------------
  ;;; PERFILS DE CLIENT
  ;;; ------------------------------

  ([perfil-parella-jove] of Couple)
  ([perfil-familia]      of Family)
  ([perfil-estudiants]   of Students)
  ([perfil-gent-gran]    of Elderly)
  ([perfil-jove-solter]  of YoungAdult)

  ;;; ------------------------------
  ;;; CLIENTS
  ;;; ------------------------------

  ;; Parella jove que vol centre i oci nocturn
  ([client-parella-centre] of Client
    (hasProfile [perfil-parella-jove])
    (prefersFeature [feat-ascensor] [feat-balco])
    (clientAge 30)
    (clientMaxPrice 1100.0)
    (familySize 2)
    (minArea 60)
    (minDorms 1)
    (minReasonablePrice 900)
    (needsDoubleBedroom si)
    (priceFlexibility 10)
    (wantsGreenArea indiferent)
    (wantsHealthCenter indiferent)
    (wantsNightLife si)
    (wantsSchool no)
    (wantsStadium indiferent)
    (wantsSupermarket si)
    (wantsTransport si)
  )

  ;; Família amb criatures que vol escola i zones verdes
  ([client-familia-verda] of Client
    (hasProfile [perfil-familia])
    (prefersFeature [feat-jardi] [feat-garatge])
    (clientAge 38)
    (clientMaxPrice 1400.0)
    (familySize 4)
    (minArea 100)
    (minDorms 3)
    (minReasonablePrice 1100)
    (needsDoubleBedroom si)
    (priceFlexibility 15)
    (wantsGreenArea si)
    (wantsHealthCenter si)
    (wantsNightLife no)
    (wantsSchool si)
    (wantsStadium indiferent)
    (wantsSupermarket si)
    (wantsTransport si)
  )

  ;; Estudiants que volen estar a prop del campus i del transport
  ([client-estudiants-campus] of Client
    (hasProfile [perfil-estudiants])
    (prefersFeature [feat-electrodomestics] [feat-mobiliari])
    (clientAge 21)
    (clientMaxPrice 800.0)
    (familySize 3)
    (minArea 55)
    (minDorms 3)
    (minReasonablePrice 600)
    (needsDoubleBedroom no)
    (priceFlexibility 5)
    (wantsGreenArea indiferent)
    (wantsHealthCenter indiferent)
    (wantsNightLife si)
    (wantsSchool no)
    (wantsStadium si)
    (wantsSupermarket si)
    (wantsTransport si)
  )

  ;; Persona gran que prioritza la salut i la tranquil·litat
  ([client-gent-gran-tranquil] of Client
    (hasProfile [perfil-gent-gran])
    (prefersFeature [feat-ascensor])
    (clientAge 72)
    (clientMaxPrice 900.0)
    (familySize 1)
    (minArea 50)
    (minDorms 1)
    (minReasonablePrice 700)
    (needsDoubleBedroom no)
    (priceFlexibility 5)
    (wantsGreenArea si)
    (wantsHealthCenter si)
    (wantsNightLife no)
    (wantsSchool no)
    (wantsStadium no)
    (wantsSupermarket si)
    (wantsTransport indiferent)
  )

  ;; Jove solter que vol centre però amb pressupost limitat
  ([client-jove-centre-lowcost] of Client
    (hasProfile [perfil-jove-solter])
    (prefersFeature [feat-terrassa] [feat-vistes-ciutat])
    (clientAge 27)
    (clientMaxPrice 950.0)
    (familySize 1)
    (minArea 45)
    (minDorms 1)
    (minReasonablePrice 750)
    (needsDoubleBedroom no)
    (priceFlexibility 10)
    (wantsGreenArea indiferent)
    (wantsHealthCenter indiferent)
    (wantsNightLife si)
    (wantsSchool no)
    (wantsStadium indiferent)
    (wantsSupermarket si)
    (wantsTransport si)
  )

  ;;; ------------------------------
  ;;; OFERTES DE LLOGUER
  ;;; ------------------------------

  ;; Oferta pel pis del centre
  ([oferta-pis-centre] of RentalOffer
    (hasProperty [prop-pis-centre])
    (hasFeature [feat-ascensor] [feat-balco] [feat-calefaccio] [feat-electrodomestics])
    (maxPeople 3)
    (minMonths 12)
    (price 950.0)
  )

  ;; Oferta pel pis del campus
  ([oferta-pis-campus] of RentalOffer
    (hasProperty [prop-pis-campus])
    (hasFeature [feat-mobiliari] [feat-electrodomestics])
    (maxPeople 3)
    (minMonths 10)
    (price 750.0)
  )

  ;; Oferta per la casa de la perifèria
  ([oferta-casa-periferia] of RentalOffer
    (hasProperty [prop-casa-periferia])
    (hasFeature [feat-jardi] [feat-garatge] [feat-accepta-mascotes])
    (maxPeople 5)
    (minMonths 12)
    (price 1350.0)
  )

  ;; Oferta pel dúplex del centre
  ([oferta-duplex-centre] of RentalOffer
    (hasProperty [prop-duplex-centre])
    (hasFeature [feat-terrassa] [feat-ascensor] [feat-vistes-ciutat])
    (maxPeople 4)
    (minMonths 12)
    (price 1600.0)
  )

  ;;; ------------------------------
  ;;; RECOMANACIONS D'EXEMPLE (PER PROVES)
  ;;; ------------------------------

  ([recom-parella-centre-1] of Recommendation
    (aboutOffer [oferta-pis-centre])
    (recommendedFor [client-parella-centre])
    (recommendationLevel "molt recomanable")
  )

  ([recom-parella-centre-2] of Recommendation
    (aboutOffer [oferta-duplex-centre])
    (recommendedFor [client-parella-centre])
    (recommendationLevel "acceptable")
  )

  ([recom-familia-casa] of Recommendation
    (aboutOffer [oferta-casa-periferia])
    (recommendedFor [client-familia-verda])
    (recommendationLevel "molt recomanable")
  )

  ([recom-estudiants-campus] of Recommendation
    (aboutOffer [oferta-pis-campus])
    (recommendedFor [client-estudiants-campus])
    (recommendationLevel "molt recomanable")
  )

  ([recom-gent-gran-centre] of Recommendation
    (aboutOffer [oferta-pis-centre])
    (recommendedFor [client-gent-gran-tranquil])
    (recommendationLevel "adequat si el soroll és acceptable")
  )

  ([recom-jove-centre-lowcost] of Recommendation
    (aboutOffer [oferta-pis-centre])
    (recommendedFor [client-jove-centre-lowcost])
    (recommendationLevel "molt recomanable")
  )

) ;; fi de definstances inicialitzacio