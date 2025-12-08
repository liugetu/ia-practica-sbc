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
  ;;; BARRIS (NEIGHBOURHOODS)
  ;;; ------------------------------

  ([barri-centre] of Neighbourhood
    (NeighbourhoodName "Centre")
    (safety 4)
    (averagePrice 1100.0)
  )

  ([barri-universitari] of Neighbourhood
    (NeighbourhoodName "Zona Universitaria")
    (safety 4)
    (averagePrice 800.0)
  )

  ([barri-periferia] of Neighbourhood
    (NeighbourhoodName "Periferia Verda")
    (safety 5)
    (averagePrice 1200.0)
  )

  ([barri-oci] of Neighbourhood
    (NeighbourhoodName "Zona d'Oci")
    (safety 2)
    (averagePrice 900.0)
  )

  ([barri-eixample] of Neighbourhood
    (NeighbourhoodName "Eixample")
    (safety 4)
    (averagePrice 1000.0)
  )

  ([barri-horrible] of Neighbourhood
    (NeighbourhoodName "Zona Degradada")
    (safety 0)
    (averagePrice 400.0)
  )

  ;;; ------------------------------
  ;;; LOCALITZACIONS
  ;;; ------------------------------

  ([loc-centre] of Location
    (latitude 41.390)
    (longitude 2.170)
    (isSituated [barri-centre])
  )

  ([loc-campus] of Location
    (latitude 41.404)
    (longitude 2.118)
    (isSituated [barri-universitari])
  )

  ([loc-periferia-verda] of Location
    (latitude 41.430)
    (longitude 2.150)
    (isSituated [barri-periferia])
  )

  ([loc-zona-oci] of Location
    (latitude 41.385)
    (longitude 2.180)
    (isSituated [barri-oci])
  )

  ([loc-plaça-major] of Location
    (latitude 41.388)
    (longitude 2.168)
    (isSituated [barri-centre])
  )

  ([loc-zona-alta] of Location
    (latitude 41.392)
    (longitude 2.172)
    (isSituated [barri-centre])
  )

  ([loc-barri-universitari] of Location
    (latitude 41.403)
    (longitude 2.119)
    (isSituated [barri-universitari])
  )

  ([loc-zona-esportiva] of Location
    (latitude 41.400)
    (longitude 2.125)
    (isSituated [barri-universitari])
  )

  ([loc-eixample-sud] of Location
    (latitude 41.389)
    (longitude 2.169)
    (isSituated [barri-eixample])
  )

  ([loc-horrible-choice] of Location
    (latitude 41.395)
    (longitude 2.175)
    (isSituated [barri-horrible])
  )

  ;;; ------------------------------
  ;;; HABITACIONS
  ;;; ------------------------------

  ;; Pis centre
  ([pis-centre-dorm-1] of Room
    (isDouble TRUE))
  ([pis-centre-dorm-2] of Room
    (isDouble FALSE))

  ;; Pis campus
  ([pis-campus-dorm-1] of Room
    (isDouble TRUE))
  ([pis-campus-dorm-2] of Room
    (isDouble FALSE))

  ;; Casa perifèria
  ([casa-periferia-dorm-1] of Room
    (isDouble TRUE))
  ([casa-periferia-dorm-2] of Room
    (isDouble FALSE))
  ([casa-periferia-dorm-3] of Room
    (isDouble FALSE))

  ;; Dúplex centre
  ([duplex-centre-dorm-1] of Room
    (isDouble TRUE))
  ([duplex-centre-dorm-2] of Room
    (isDouble FALSE))

  ;; Pis eixample
  ([pis-eixample-dorm-1] of Room
    (isDouble TRUE))
  ([pis-eixample-dorm-2] of Room
    (isDouble TRUE))

  ;; Propietat horrible
  ([horrible-dorm-1] of Room
    (isDouble FALSE))

  ;;; ------------------------------
  ;;; SERVEIS
  ;;; ------------------------------

  ([parc-central] of GreenArea
    (serviceName "Parc Central")
    (serviceNoiseLevel 1)
    (ServiceLocatedAt [loc-plaça-major])
  )

  ([cap-centre] of HealthCenter
    (serviceName "CAP Centre")
    (serviceNoiseLevel 1)
    (ServiceLocatedAt [loc-zona-alta])
  )

  ([zona-bars-centre] of Nightlife
    (serviceName "Zona bars centre")
    (serviceNoiseLevel 3)
    (ServiceLocatedAt [loc-zona-oci])
  )

  ([escola-publica-centre] of School
    (serviceName "Escola Pública Centre")
    (serviceNoiseLevel 1)
    (ServiceLocatedAt [loc-centre])
  )

  ([estadi-municipal] of Stadium
    (serviceName "Estadi Municipal")
    (serviceNoiseLevel 2)
    (ServiceLocatedAt [loc-zona-esportiva])
  )

  ([super-centre] of Supermarket
    (serviceName "Supermercat Centre")
    (serviceNoiseLevel 0)
    (ServiceLocatedAt [loc-centre])
  )

  ([super-campus] of Supermarket
    (serviceName "Supermercat Campus")
    (serviceNoiseLevel 0)
    (ServiceLocatedAt [loc-barri-universitari])
  )

  ([metro-l1-centre] of Transport
    (serviceName "Metro L1 - Estació Centre")
    (serviceNoiseLevel 0)
    (ServiceLocatedAt [loc-centre])
  )

  ([bus-campus] of Transport
    (serviceName "Bus universitat")
    (serviceNoiseLevel 1)
    (ServiceLocatedAt [loc-barri-universitari])
  )

  ([parc-eixample] of GreenArea
    (serviceName "Parc de l'Eixample")
    (serviceNoiseLevel 0)
    (ServiceLocatedAt [loc-eixample-sud])
  )

  ([cap-eixample] of HealthCenter
    (serviceName "CAP Eixample Sud")
    (serviceNoiseLevel 0)
    (ServiceLocatedAt [loc-eixample-sud])
  )

  ([super-eixample] of Supermarket
    (serviceName "Supermercat Eixample")
    (serviceNoiseLevel 0)
    (ServiceLocatedAt [loc-eixample-sud])
  )

  ([metro-eixample] of Transport
    (serviceName "Metro L2 - Eixample")
    (serviceNoiseLevel 0)
    (ServiceLocatedAt [loc-eixample-sud])
  )

  ;;; ------------------------------
  ;;; PROPIETATS (IMMOBLES)
  ;;; ------------------------------

  ;; Pis lluminós al centre
  ([prop-pis-centre] of Apartment
    (address "C/ Major 10, Barri Centre")
    (area 75)
    (naturalLight 3)
    (state 4)
    (floor 3)
    (hasRoom [pis-centre-dorm-1] [pis-centre-dorm-2])
    (locatedAt [loc-centre])
  )

  ;; Pis a prop del campus universitari
  ([prop-pis-campus] of Apartment
    (address "Av. Universitat 5, Zona Campus")
    (area 60)
    (naturalLight 0)
    (state 3)
    (floor 2)
    (hasRoom [pis-campus-dorm-1] [pis-campus-dorm-2])
    (locatedAt [loc-campus])
  )

  ;; Casa adossada en zona tranquil·la i verda
  ([prop-casa-periferia] of House
    (address "Passatge dels Pins 12, Urbanització Verda")
    (area 120)
    (naturalLight 1)
    (state 1)
    (hasRoom [casa-periferia-dorm-1]
             [casa-periferia-dorm-2]
             [casa-periferia-dorm-3])
    (locatedAt [loc-periferia-verda])
  )

  ;; Dúplex modern al centre amb terrassa
  ([prop-duplex-centre] of Duplex
    (address "Rbla. Nova 3, Barri Centre")
    (area 90)
    (naturalLight 2)
    (state 4)
    (floor 6)
    (hasRoom [duplex-centre-dorm-1]
             [duplex-centre-dorm-2])
    (locatedAt [loc-zona-oci])
  )

  ;; Pis renovat a l'Eixample Sud
  ([prop-pis-eixample] of Apartment
    (address "C/ Provença 125, Eixample Sud")
    (area 85)
    (naturalLight 3)
    (state 5)
    (floor 2)
    (hasRoom [pis-eixample-dorm-1] [pis-eixample-dorm-2])
    (locatedAt [loc-eixample-sud])
  )

  ;; Propietat horrible - per provar els descartes instantanis
  ([prop-horrible-choice] of Apartment
    (address "C/ de l'Horror 666, Barri Roig")
    (area 30)
    (naturalLight 0)
    (state 0)
    (floor 5)
    (hasSquatters si)
    (hasDampness si)
    (hasLeaks si)
    (hasRoom [horrible-dorm-1])
    (locatedAt [loc-horrible-choice])
  )

  ;;; ------------------------------
  ;;; PERFILS DE CLIENT
  ;;; ------------------------------

  ([perfil-parella-jove] of Couple)
  ([perfil-familia]      of Family
    (numElderly 0)
    (numChildren 2))
  ([perfil-estudiants]   of Student)
  ([perfil-gent-gran]    of Elderly)
  ([perfil-jove-solter]  of Individual)

  ;;; ------------------------------
  ;;; CLIENTS
  ;;; ------------------------------

  ;; Parella jove que vol centre i oci nocturn
  ([client-parella-centre] of Client
    (hasProfile [perfil-parella-jove])
    (prefersFeature [FeatureElevator] [FeatureBalcony])
    (clientAge 30)
    (clientMaxPrice 1100.0)
    (numTenants 2)
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
    (minMonthsClient 12)
    (worksOrStudies [loc-centre])
  )

  ;; Família amb criatures que vol escola i zones verdes
  ([client-familia-verda] of Client
    (hasProfile [perfil-familia])
    (prefersFeature [FeatureYard] [FeatureGarage])
    (clientAge 38)
    (clientMaxPrice 1400.0)
    (numTenants 4)
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
    (minMonthsClient 24)
    (worksOrStudies [loc-periferia-verda])
  )

  ;; Estudiants que volen estar a prop del campus i del transport
  ([client-estudiants-campus] of Client
    (hasProfile [perfil-estudiants])
    (prefersFeature [FeatureAppliances] [FeatureFurniture])
    (clientAge 21)
    (clientMaxPrice 800.0)
    (numTenants 3)
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
    (minMonthsClient 10)
    (worksOrStudies [loc-campus])
  )

  ;; Persona gran que prioritza la salut i la tranquil·litat
  ([client-gent-gran-tranquil] of Client
    (hasProfile [perfil-gent-gran])
    (prefersFeature [FeatureElevator])
    (clientAge 72)
    (clientMaxPrice 900.0)
    (numTenants 1)
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
    (minMonthsClient 12)
  )

  ;; Jove solter que vol centre però amb pressupost limitat
  ([client-jove-centre-lowcost] of Client
    (hasProfile [perfil-jove-solter])
    (prefersFeature [FeatureTerrace] [FeatureViews])
    (clientAge 27)
    (clientMaxPrice 950.0)
    (numTenants 1)
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
    (minMonthsClient 6)
    (worksOrStudies [loc-plaça-major])
  )

  ;; Parella professional que busca comoditat i serveis
  ([client-parella-professional] of Client
    (hasProfile [perfil-parella-jove])
    (prefersFeature [FeatureElevator] [FeatureBalcony] [FeatureAirOrHeating] [FeatureTerrace])
    (clientAge 30)
    (clientMaxPrice 1000.0)
    (numTenants 2)
    (minArea 70)
    (minDorms 2)
    (minReasonablePrice 800)
    (needsDoubleBedroom si)
    (priceFlexibility 20)
    (wantsGreenArea si)
    (wantsHealthCenter si)
    (wantsNightLife indiferent)
    (wantsSchool indiferent)
    (wantsStadium indiferent)
    (wantsSupermarket si)
    (wantsTransport si)
    (minMonthsClient 12)
    (worksOrStudies [loc-zona-alta])
  )

  ;;; ------------------------------
  ;;; OFERTES DE LLOGUER
  ;;; ------------------------------

  ;; Oferta pel pis del centre
  ([oferta-pis-centre] of RentalOffer
    (hasProperty [prop-pis-centre])
    (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureAirOrHeating] [FeatureAppliances])
    (maxPeople 3)
    (minMonths 12)
    (price 950.0)
  )

  ;; Oferta pel pis del campus
  ([oferta-pis-campus] of RentalOffer
    (hasProperty [prop-pis-campus])
    (hasFeature [FeatureFurniture] [FeatureAppliances])
    (maxPeople 3)
    (minMonths 10)
    (price 750.0)
  )

  ;; Oferta per la casa de la perifèria
  ([oferta-casa-periferia] of RentalOffer
    (hasProperty [prop-casa-periferia])
    (hasFeature [FeatureYard] [FeatureGarage] [FeaturePetsAllowed])
    (maxPeople 5)
    (minMonths 12)
    (price 1350.0)
  )

  ;; Oferta pel dúplex del centre
  ([oferta-duplex-centre] of RentalOffer
    (hasProperty [prop-duplex-centre])
    (hasFeature [FeatureTerrace] [FeatureElevator] [FeatureViews])
    (maxPeople 4)
    (minMonths 12)
    (price 1600.0)
  )

  ;; Oferta pel pis de l'Eixample
  ([oferta-pis-eixample] of RentalOffer
    (hasProperty [prop-pis-eixample])
    (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureAirOrHeating] [FeatureTerrace] [FeatureAppliances] [FeatureFurniture])
    (maxPeople 3)
    (minMonths 12)
    (price 950.0)
  )

  ;; Oferta per la propiedad horrible
  ([oferta-horrible-choice] of RentalOffer
    (hasProperty [prop-horrible-choice])
    (hasFeature)
    (maxPeople 1)
    (minMonths 6)
    (price 300.0)
  )

) ;; fi de definstances inicialitzacio