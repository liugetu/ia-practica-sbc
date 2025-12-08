;;; ---------------------------------------------------------
;;; vivendes.clp
;;; Base de dades amb aproximadament 20 viviendas de diversos tipus i qualitats
;;;
;;; Es pressuposa que abans s'ha carregat ontologia.clp
;;; (defclass Property, Apartment, House, Duplex, Room, Location,
;;;  PropertyFeature, Service (+ subclasses), Proximity,
;;;  ClientProfile (+ subclasses), Client, RentalOffer, Recommendation, ...)

(definstances vivendes

  ;;; ------------------------------
  ;;; BARRIS (NEIGHBOURHOODS)
  ;;; ------------------------------

  ([barri-centre] of Neighbourhood
    (NeighbourhoodName "Centre")
    (safety 4)
    (averagePrice 1100.0)
  )

  ([barri-campus] of Neighbourhood
    (NeighbourhoodName "Zona Campus")
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

  ([barri-montjuic] of Neighbourhood
    (NeighbourhoodName "Montjuïc")
    (safety 3)
    (averagePrice 850.0)
  )

  ([barri-gracia] of Neighbourhood
    (NeighbourhoodName "Gràcia")
    (safety 4)
    (averagePrice 1050.0)
  )

  ([barri-sagrada-familia] of Neighbourhood
    (NeighbourhoodName "Sagrada Família")
    (safety 4)
    (averagePrice 1150.0)
  )

  ([barri-sants] of Neighbourhood
    (NeighbourhoodName "Sants")
    (safety 3)
    (averagePrice 900.0)
  )

  ([barri-diagonal] of Neighbourhood
    (NeighbourhoodName "Diagonal")
    (safety 5)
    (averagePrice 1300.0)
  )

  ([barri-eixample] of Neighbourhood
    (NeighbourhoodName "Eixample")
    (safety 4)
    (averagePrice 1000.0)
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
    (isSituated [barri-campus])
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
    (isSituated [barri-campus])
  )

  ([loc-zona-esportiva] of Location
    (latitude 41.400)
    (longitude 2.125)
    (isSituated [barri-campus])
  )

  ([loc-eixample-sud] of Location
    (latitude 41.389)
    (longitude 2.169)
    (isSituated [barri-eixample])
  )

  ([loc-montjuic] of Location
    (latitude 41.365)
    (longitude 2.162)
    (isSituated [barri-montjuic])
  )

  ([loc-gracia] of Location
    (latitude 41.415)
    (longitude 2.155)
    (isSituated [barri-gracia])
  )

  ([loc-sagrada-familia] of Location
    (latitude 41.404)
    (longitude 2.174)
    (isSituated [barri-sagrada-familia])
  )

  ([loc-sants] of Location
    (latitude 41.375)
    (longitude 2.140)
    (isSituated [barri-sants])
  )

  ([loc-diagonal] of Location
    (latitude 41.395)
    (longitude 2.155)
    (isSituated [barri-diagonal])
  )

  ;;; ------------------------------
  ;;; HABITACIONS
  ;;; ------------------------------

  ;; Vivienda 1 - Pis centre lluminós
  ([viv1-dorm-1] of Room (isDouble TRUE))
  ([viv1-dorm-2] of Room (isDouble FALSE))

  ;; Vivienda 2 - Pis campus petit
  ([viv2-dorm-1] of Room (isDouble TRUE))

  ;; Vivienda 3 - Casa perifèria espaciosa
  ([viv3-dorm-1] of Room (isDouble TRUE))
  ([viv3-dorm-2] of Room (isDouble FALSE))
  ([viv3-dorm-3] of Room (isDouble FALSE))

  ;; Vivienda 4 - Dúplex de luxe
  ([viv4-dorm-1] of Room (isDouble TRUE))
  ([viv4-dorm-2] of Room (isDouble TRUE))
  ([viv4-dorm-3] of Room (isDouble FALSE))

  ;; Vivienda 5 - Pis Eixample renovada
  ([viv5-dorm-1] of Room (isDouble TRUE))
  ([viv5-dorm-2] of Room (isDouble FALSE))

  ;; Vivienda 6 - Pis Gràcia
  ([viv6-dorm-1] of Room (isDouble TRUE))
  ([viv6-dorm-2] of Room (isDouble FALSE))

  ;; Vivienda 7 - Casa adosada Sants
  ([viv7-dorm-1] of Room (isDouble TRUE))
  ([viv7-dorm-2] of Room (isDouble FALSE))
  ([viv7-dorm-3] of Room (isDouble FALSE))

  ;; Vivienda 8 - Pis modest Montjuïc
  ([viv8-dorm-1] of Room (isDouble TRUE))

  ;; Vivienda 9 - Duplex Sagrada Familia
  ([viv9-dorm-1] of Room (isDouble TRUE))
  ([viv9-dorm-2] of Room (isDouble TRUE))

  ;; Vivienda 10 - Pis bàsic Diagonal
  ([viv10-dorm-1] of Room (isDouble FALSE))

  ;; Vivienda 11 - Pentus centre
  ([viv11-dorm-1] of Room (isDouble TRUE))
  ([viv11-dorm-2] of Room (isDouble TRUE))
  ([viv11-dorm-3] of Room (isDouble FALSE))

  ;; Vivienda 12 - Pis petit Campus
  ([viv12-dorm-1] of Room (isDouble FALSE))

  ;; Vivienda 13 - Casa gran Perifèria
  ([viv13-dorm-1] of Room (isDouble TRUE))
  ([viv13-dorm-2] of Room (isDouble TRUE))
  ([viv13-dorm-3] of Room (isDouble FALSE))
  ([viv13-dorm-4] of Room (isDouble FALSE))

  ;; Vivienda 14 - Pis Zona Oci
  ([viv14-dorm-1] of Room (isDouble TRUE))
  ([viv14-dorm-2] of Room (isDouble FALSE))

  ;; Vivienda 15 - Apartament Plaça Major
  ([viv15-dorm-1] of Room (isDouble TRUE))

  ;; Vivienda 16 - Duplex Gràcia
  ([viv16-dorm-1] of Room (isDouble TRUE))
  ([viv16-dorm-2] of Room (isDouble FALSE))

  ;; Vivienda 17 - Casa Barri Universitari
  ([viv17-dorm-1] of Room (isDouble TRUE))
  ([viv17-dorm-2] of Room (isDouble FALSE))
  ([viv17-dorm-3] of Room (isDouble FALSE))

  ;; Vivienda 18 - Pis Zona Esportiva
  ([viv18-dorm-1] of Room (isDouble TRUE))
  ([viv18-dorm-2] of Room (isDouble FALSE))

  ;; Vivienda 19 - Duplex Diagonal
  ([viv19-dorm-1] of Room (isDouble TRUE))
  ([viv19-dorm-2] of Room (isDouble TRUE))

  ;; Vivienda 20 - Pis moderm Eixample
  ([viv20-dorm-1] of Room (isDouble TRUE))
  ([viv20-dorm-2] of Room (isDouble FALSE))

  ;;; ------------------------------
  ;;; PROPIETATS (IMMOBLES) - 20 VIVIENDAS
  ;;; ------------------------------

  ;; Vivienda 1 - Pis centre lluminós i de qualitat
  ([viv1] of Apartment
    (address "C/ Major 10, Barri Centre")
    (area 75)
    (naturalLight 3)
    (state 4)
    (floor 3)
    (hasRoom [viv1-dorm-1] [viv1-dorm-2])
    (locatedAt [loc-centre])
  )

  ;; Vivienda 2 - Pis petit campus
  ([viv2] of Apartment
    (address "Av. Universitat 5, Zona Campus")
    (area 50)
    (naturalLight 1)
    (state 2)
    (floor 1)
    (hasRoom [viv2-dorm-1])
    (locatedAt [loc-campus])
  )

  ;; Vivienda 3 - Casa adossada perifèria verda
  ([viv3] of House
    (address "Passatge dels Pins 12, Urbanització Verda")
    (area 130)
    (naturalLight 2)
    (state 3)
    (hasRoom [viv3-dorm-1] [viv3-dorm-2] [viv3-dorm-3])
    (locatedAt [loc-periferia-verda])
  )

  ;; Vivienda 4 - Dúplex de luxe zona oci
  ([viv4] of Duplex
    (address "Rbla. Nova 3, Barri Centre")
    (area 120)
    (naturalLight 3)
    (state 5)
    (floor 6)
    (hasRoom [viv4-dorm-1] [viv4-dorm-2] [viv4-dorm-3])
    (locatedAt [loc-zona-oci])
  )

  ;; Vivienda 5 - Pis renovada Eixample Sud
  ([viv5] of Apartment
    (address "C/ Provença 125, Eixample Sud")
    (area 85)
    (naturalLight 3)
    (state 5)
    (floor 2)
    (hasRoom [viv5-dorm-1] [viv5-dorm-2])
    (locatedAt [loc-eixample-sud])
  )

  ;; Vivienda 6 - Pis amb encant Gràcia
  ([viv6] of Apartment
    (address "C/ Verdi 42, Barri Gràcia")
    (area 70)
    (naturalLight 2)
    (state 4)
    (floor 2)
    (hasRoom [viv6-dorm-1] [viv6-dorm-2])
    (locatedAt [loc-gracia])
  )

  ;; Vivienda 7 - Casa adosada Sants
  ([viv7] of House
    (address "C/ Numància 88, Sants")
    (area 110)
    (naturalLight 2)
    (state 3)
    (hasRoom [viv7-dorm-1] [viv7-dorm-2] [viv7-dorm-3])
    (locatedAt [loc-sants])
  )

  ;; Vivienda 8 - Pis modest Montjuïc
  ([viv8] of Apartment
    (address "Av. Parallel 200, Montjuïc")
    (area 55)
    (naturalLight 1)
    (state 2)
    (floor 2)
    (hasRoom [viv8-dorm-1])
    (locatedAt [loc-montjuic])
  )

  ;; Vivienda 9 - Duplex modern Sagrada Familia
  ([viv9] of Duplex
    (address "C/ Còrsega 350, Sagrada Familia")
    (area 100)
    (naturalLight 2)
    (state 4)
    (floor 3)
    (hasRoom [viv9-dorm-1] [viv9-dorm-2])
    (locatedAt [loc-sagrada-familia])
  )

  ;; Vivienda 10 - Pis bàsic Diagonal
  ([viv10] of Apartment
    (address "Av. Diagonal 500, Diagonal")
    (area 45)
    (naturalLight 1)
    (state 2)
    (floor 1)
    (hasRoom [viv10-dorm-1])
    (locatedAt [loc-diagonal])
  )

  ;; Vivienda 11 - Pentús de luxe centre
  ([viv11] of Apartment
    (address "C/ Aribau 1, Plaça Reial")
    (area 110)
    (naturalLight 3)
    (state 5)
    (floor 7)
    (hasRoom [viv11-dorm-1] [viv11-dorm-2] [viv11-dorm-3])
    (locatedAt [loc-centre])
  )

  ;; Vivienda 12 - Pis petit campus economica
  ([viv12] of Apartment
    (address "Passeig de Sant Joan 10, Barri Universitari")
    (area 40)
    (naturalLight 0)
    (state 1)
    (floor 1)
    (hasRoom [viv12-dorm-1])
    (locatedAt [loc-barri-universitari])
  )

  ;; Vivienda 13 - Casa gran familiar perifèria
  ([viv13] of House
    (address "Avda. Gran Via 456, Perifèria Verda")
    (area 160)
    (naturalLight 2)
    (state 4)
    (hasRoom [viv13-dorm-1] [viv13-dorm-2] [viv13-dorm-3] [viv13-dorm-4])
    (locatedAt [loc-periferia-verda])
  )

  ;; Vivienda 14 - Pis vibrante zona oci
  ([viv14] of Apartment
    (address "C/ Blai 30, Zona Oci")
    (area 65)
    (naturalLight 2)
    (state 3)
    (floor 2)
    (hasRoom [viv14-dorm-1] [viv14-dorm-2])
    (locatedAt [loc-zona-oci])
  )

  ;; Vivienda 15 - Apartament costet Plaça Major
  ([viv15] of Apartment
    (address "Plaça Reial 5, Centre")
    (area 55)
    (naturalLight 2)
    (state 4)
    (floor 2)
    (hasRoom [viv15-dorm-1])
    (locatedAt [loc-plaça-major])
  )

  ;; Vivienda 16 - Duplex amb terrassa Gràcia
  ([viv16] of Duplex
    (address "Plaça Sun 20, Barri Gràcia")
    (area 85)
    (naturalLight 3)
    (state 4)
    (floor 3)
    (hasRoom [viv16-dorm-1] [viv16-dorm-2])
    (locatedAt [loc-gracia])
  )

  ;; Vivienda 17 - Casa de 3 dorms barri universitari
  ([viv17] of House
    (address "C/ Còrsega 100, Barri Universitari")
    (area 95)
    (naturalLight 2)
    (state 3)
    (hasRoom [viv17-dorm-1] [viv17-dorm-2] [viv17-dorm-3])
    (locatedAt [loc-barri-universitari])
  )

  ;; Vivienda 18 - Pis esportiva zona esportiva
  ([viv18] of Apartment
    (address "C/ Estadi 22, Zona Esportiva")
    (area 70)
    (naturalLight 2)
    (state 3)
    (floor 2)
    (hasRoom [viv18-dorm-1] [viv18-dorm-2])
    (locatedAt [loc-zona-esportiva])
  )

  ;; Vivienda 19 - Duplex premium diagonal
  ([viv19] of Duplex
    (address "Av. Diagonal 600, Diagonal")
    (area 115)
    (naturalLight 3)
    (state 5)
    (floor 5)
    (hasRoom [viv19-dorm-1] [viv19-dorm-2])
    (locatedAt [loc-diagonal])
  )

  ;; Vivienda 20 - Pis moderm eixample
  ([viv20] of Apartment
    (address "C/ Balmes 200, Eixample Nord")
    (area 80)
    (naturalLight 3)
    (state 4)
    (floor 3)
    (hasRoom [viv20-dorm-1] [viv20-dorm-2])
    (locatedAt [loc-eixample-sud])
  )

  ;;; ------------------------------
  ;;; OFERTES DE LLOGUER (20 VIVIENDAS)
  ;;; ------------------------------

  ([oferta-viv1] of RentalOffer
    (hasProperty [viv1])
    (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureAirOrHeating])
    (maxPeople 3)
    (minMonths 12)
    (price 950.0)
  )

  ([oferta-viv2] of RentalOffer
    (hasProperty [viv2])
    (hasFeature [FeatureFurniture])
    (maxPeople 1)
    (minMonths 10)
    (price 500.0)
  )

  ([oferta-viv3] of RentalOffer
    (hasProperty [viv3])
    (hasFeature [FeatureYard] [FeatureGarage] [FeaturePetsAllowed])
    (maxPeople 5)
    (minMonths 12)
    (price 1300.0)
  )

  ([oferta-viv4] of RentalOffer
    (hasProperty [viv4])
    (hasFeature [FeatureTerrace] [FeatureElevator] [FeatureViews] [FeatureAirOrHeating])
    (maxPeople 4)
    (minMonths 12)
    (price 1650.0)
  )

  ([oferta-viv5] of RentalOffer
    (hasProperty [viv5])
    (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureAirOrHeating] [FeatureTerrace])
    (maxPeople 3)
    (minMonths 12)
    (price 1050.0)
  )

  ([oferta-viv6] of RentalOffer
    (hasProperty [viv6])
    (hasFeature [FeatureBalcony] [FeatureFurniture])
    (maxPeople 3)
    (minMonths 12)
    (price 800.0)
  )

  ([oferta-viv7] of RentalOffer
    (hasProperty [viv7])
    (hasFeature [FeatureYard] [FeatureGarage])
    (maxPeople 5)
    (minMonths 12)
    (price 1200.0)
  )

  ([oferta-viv8] of RentalOffer
    (hasProperty [viv8])
    (hasFeature [FeatureFurniture])
    (maxPeople 2)
    (minMonths 6)
    (price 550.0)
  )

  ([oferta-viv9] of RentalOffer
    (hasProperty [viv9])
    (hasFeature [FeatureTerrace] [FeatureElevator] [FeatureAirOrHeating])
    (maxPeople 3)
    (minMonths 12)
    (price 1200.0)
  )

  ([oferta-viv10] of RentalOffer
    (hasProperty [viv10])
    (hasFeature)
    (maxPeople 1)
    (minMonths 6)
    (price 400.0)
  )

  ([oferta-viv11] of RentalOffer
    (hasProperty [viv11])
    (hasFeature [FeatureElevator] [FeatureTerrace] [FeatureViews] [FeatureAirOrHeating] [FeatureAppliances])
    (maxPeople 4)
    (minMonths 12)
    (price 1800.0)
  )

  ([oferta-viv12] of RentalOffer
    (hasProperty [viv12])
    (hasFeature)
    (maxPeople 1)
    (minMonths 10)
    (price 380.0)
  )

  ([oferta-viv13] of RentalOffer
    (hasProperty [viv13])
    (hasFeature [FeatureYard] [FeatureGarage] [FeaturePool])
    (maxPeople 6)
    (minMonths 12)
    (price 1600.0)
  )

  ([oferta-viv14] of RentalOffer
    (hasProperty [viv14])
    (hasFeature [FeatureBalcony] [FeatureAppliances])
    (maxPeople 3)
    (minMonths 12)
    (price 900.0)
  )

  ([oferta-viv15] of RentalOffer
    (hasProperty [viv15])
    (hasFeature [FeatureBalcony] [FeatureViews])
    (maxPeople 2)
    (minMonths 12)
    (price 700.0)
  )

  ([oferta-viv16] of RentalOffer
    (hasProperty [viv16])
    (hasFeature [FeatureTerrace] [FeatureBalcony] [FeatureViews])
    (maxPeople 3)
    (minMonths 12)
    (price 1000.0)
  )

  ([oferta-viv17] of RentalOffer
    (hasProperty [viv17])
    (hasFeature [FeatureGarage] [FeatureFurniture])
    (maxPeople 4)
    (minMonths 12)
    (price 1100.0)
  )

  ([oferta-viv18] of RentalOffer
    (hasProperty [viv18])
    (hasFeature [FeatureBalcony] [FeatureAppliances])
    (maxPeople 3)
    (minMonths 12)
    (price 850.0)
  )

  ([oferta-viv19] of RentalOffer
    (hasProperty [viv19])
    (hasFeature [FeatureTerrace] [FeatureElevator] [FeatureViews] [FeatureAirOrHeating])
    (maxPeople 4)
    (minMonths 12)
    (price 1550.0)
  )

  ([oferta-viv20] of RentalOffer
    (hasProperty [viv20])
    (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureAirOrHeating] [FeatureAppliances])
    (maxPeople 3)
    (minMonths 12)
    (price 950.0)
  )

) ;; fi de definstances vivendes
