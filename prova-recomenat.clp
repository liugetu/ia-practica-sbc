;;; ---------------------------------------------------------
;;; prova-recomenat.clp
;;; Joc de prova per generar una recomanació "recomenat"
;;; (tots els criteris complerts, sense destacar especialment)
;;; ---------------------------------------------------------

(definstances prova-recomenat

  ;;; ---------------------------------------------------------
  ;;; Perfil i Client parella jove
  ;;; ---------------------------------------------------------

  ([perfil-test-couple] of Couple
  )

  ([client-test-recomenat] of Client
    (hasProfile [perfil-test-couple])
    (clientAge 30)
    
    ;; Pressupost raonable
    (clientMaxPrice 950.0)
    (minReasonablePrice 700)
    (priceFlexibility 10)
    
    ;; Requisits estàndard
    (minArea 60)
    (minDorms 2)
    (numTenants 2)
    
    ;; Preferències d'ubicació
    (worksOrStudies [loc-gracia])
    
    ;; Preferències de serveis
    (wantsGreenArea TRUE)
    (wantsHealthCenter TRUE)
    (wantsNightLife FALSE)
    (wantsSchool FALSE)
    (wantsStadium FALSE)
    (wantsSupermarket TRUE)
    (wantsTransport TRUE)
    
    (minMonthsClient 12)
  )

  ;;; ---------------------------------------------------------
  ;;; Oferta que compleix tots els criteris adequadament
  ;;; ---------------------------------------------------------

  ([barri-test-gracia] of Neighbourhood
    (NeighbourhoodName "Gràcia")
    (safety 4)
    (averagePrice 900.0)
  )

  ([loc-test-gracia] of Location
    (latitude 41.403)
    (longitude 2.160)
    (isSituated [barri-test-gracia])
  )

  ([room-test-1] of Room
    (isDouble TRUE)           ; Dormitori doble
  )

  ([room-test-2] of Room
    (isDouble FALSE)
  )

  ;; Propietat adequada en tots els aspectes
  ([pis-test-adequat] of Apartment
    (area 65)                 ; Adequat (client vol 60m²)
    (locatedAt [loc-test-gracia])
    (hasRoom [room-test-1] [room-test-2])  ; 2 dormitoris
    (floor 2)
    (numBathrooms 1)
    (naturalLight 8)
    (state 8)
    (hasDampness FALSE)
    (hasSquatters FALSE)
    (hasLeaks FALSE)
    (isSoundproof TRUE)
  )

  ;; Oferta amb preu adequat dins del pressupost
  ([oferta-test-adequada] of RentalOffer
    (price 850.0)             ; Dins del pressupost (< 950€)
    (hasProperty [pis-test-adequat])
    (maxPeople 2)
    (minMonths 12)
  )

)

;;; Executar el sistema expert
(run)
