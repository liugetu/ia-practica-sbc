;;; ---------------------------------------------------------
;;; prova-molt-recomenat.clp
;;; Joc de prova per generar una recomanació "molt recomenat"
;;; (tots els criteris complerts + característiques destacades)
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
    (needsDoubleBedroom TRUE)
    
    ;; Preferències d'ubicació
    (worksOrStudies [loc-eixample])
    
    ;; Preferències de serveis (família necessita molts serveis)
    (wantsGreenArea TRUE)
    (wantsHealthCenter TRUE)
    (wantsNightLife FALSE)
    (wantsSchool TRUE)        ; Important per als nens
    (wantsStadium FALSE)
    (wantsSupermarket TRUE)
    (wantsTransport TRUE)
    
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
    (naturalLight 9)
    (state 9)                 ; Excel·lent estat
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

;;; Executar el sistema expert
(run)
