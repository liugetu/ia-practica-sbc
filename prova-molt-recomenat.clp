;;; ---------------------------------------------------------
;;; prova-molt-recomenat.clp
;;; Joc de prova per generar una recomanació "molt recomenat"
;;; ---------------------------------------------------------

(definstances prova-molt-recomenat

  ;;; ---------------------------------------------------------
  ;;; Perfil i Client família
  ;;; ---------------------------------------------------------

  ([perfil-test-family] of Family
    (numChildren 2)
    (numElderly 0)
  )

  ([client-test-molt-recomenat] of Client
    (hasProfile [perfil-test-family])
    (clientAge 35)
    
    ;; Pressupost amb marge
    (clientMaxPrice 1200.0)
    (minReasonablePrice 800)
    (priceFlexibility 10)
    
    ;; Requisits familiars
    (minArea 70)
    (minDorms 3)
    (numTenants 4)
    (needsDoubleBedroom si)
    
    ;; Preferències d'ubicació
    (worksOrStudies [loc-eixample])
    
    ;; Preferències de serveis (família necessita molts serveis)
    (wantsGreenArea si)
    (wantsHealthCenter si)
    (wantsNightLife no)
    (wantsSchool si)        ; Important per als nens
    (wantsStadium no)
    (wantsSupermarket si)
    (wantsTransport si)
    
    (minMonthsClient 24)
  )

  ;;; ---------------------------------------------------------
  ;;; Oferta excel·lent que supera les expectatives
  ;;; ---------------------------------------------------------

  ([barri-test-residencial] of Neighbourhood
    (NeighbourhoodName "Zona Residencial")
    (safety 5)
    (averagePrice 1100.0)
  )

  ([loc-test-residencial] of Location
    (latitude 41.395)
    (longitude 2.165)
    (isSituated [barri-test-residencial])
  )

  ([parc-test-residencial] of GreenArea
    (serviceName "Parc Residencial")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-test-residencial])
  )

  ([cap-test-residencial] of HealthCenter
    (serviceName "CAP Residencial")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-test-residencial])
  )

  ([escola-test-residencial] of School
    (serviceName "Escola Residencial")
    (serviceNoiseLevel 1)
    (serviceLocatedAt [loc-test-residencial])
  )

  ([super-test-residencial] of Supermarket
    (serviceName "Supermercat Residencial")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-test-residencial])
  )

  ([metro-test-residencial] of Transport
    (serviceName "Metro Residencial")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-test-residencial])
  )

  ;; Tres dormitoris (un d'ells doble)
  ([habitacio-principal] of Room
    (isDouble TRUE)           ; Dormitori doble
  )

  ([habitacio-nens-1] of Room
    (isDouble FALSE)
  )

  ([habitacio-nens-2] of Room
    (isDouble FALSE)
  )

  ;; Propietat excel·lent amb molts avantatges
  ([casa-test-excel·lent] of House
    (area 120)                ; Molt més gran que el mínim (70m²)
    (locatedAt [loc-test-residencial])
    (hasRoom [habitacio-principal] [habitacio-nens-1] [habitacio-nens-2])
    (numBathrooms 2)
    (naturalLight 3)
    (state 5)                 ; Excel·lent estat
    (hasDampness FALSE)
    (hasSquatters FALSE)
    (hasLeaks FALSE)
    (isSoundproof TRUE)
  )

  ;; Oferta amb preu excel·lent (molt per sota del màxim i del preu mitjà del barri)
  ([oferta-test-excel·lent] of RentalOffer
    (price 900.0)             ; Excel·lent preu: < 75% del màxim (1200€)
                              ; i < preu mitjà barri (1100€)
    (hasProperty [casa-test-excel·lent])
    (maxPeople 5)
    (minMonths 12)
  )

)