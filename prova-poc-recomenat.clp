;;; ---------------------------------------------------------
;;; prova-poc-recomenat.clp
;;; Joc de prova per generar una recomanació "poc recomenat"
;;; ---------------------------------------------------------

(definstances prova-poc-recomenat

  ;;; ---------------------------------------------------------
  ;;; Perfil i Client jove professional
  ;;; ---------------------------------------------------------

  ([perfil-test-individual] of Individual
  )

  ([client-test-poc-recomenat] of Client
    (hasProfile [perfil-test-individual])
    (clientAge 28)
    
    ;; Pressupost ajustat
    (clientMaxPrice 800.0)
    (minReasonablePrice 600)
    (priceFlexibility 15)     ; 15% de flexibilitat
    
    ;; Requisits moderats
    (minArea 50)
    (minDorms 3)
    (numTenants 1)
    
    ;; Preferències d'ubicació
    (worksOrStudies [loc-centre])
    
    ;; Preferències de serveis
    (wantsGreenArea no)
    (wantsHealthCenter no)
    (wantsNightLife si)     ; Vol oci nocturn
    (wantsSchool no)
    (wantsStadium no)
    (wantsSupermarket si)
    (wantsTransport si)     ; Vol transport
    
    (minMonthsClient 6)
  )

  ;;; ---------------------------------------------------------
  ;;; Oferta que compleix parcialment (preu una mica alt)
  ;;; ---------------------------------------------------------

  ([barri-test-oci] of Neighbourhood
    (NeighbourhoodName "Zona d'Oci")
    (safety 3)
    (averagePrice 850.0)
  )

  ([loc-test-oci] of Location
    (latitude 41.385)
    (longitude 2.170)
    (isSituated [barri-test-oci])
  )

  ([dorm-test-1] of Room
    (isDouble TRUE)
  )

  ([dorm-test-2] of Room
    (isDouble FALSE)
  )

  ;; Propietat adequada però cara
  ([pis-test-poc-adequat] of Apartment
    (area 55)                 ; Adequat (client vol 50m²)
    (locatedAt [loc-test-oci])
    (hasRoom [dorm-test-1] [dorm-test-2])  ; 2 dormitoris (adequat)
    (floor 3)
    (numBathrooms 1)
    (naturalLight 3)
    (state 4)
    (hasDampness FALSE)
    (hasSquatters FALSE)
    (hasLeaks FALSE)
    (isSoundproof FALSE)
  )

  ;; Oferta amb preu lleugerament per sobre pero dins flexibilitat
  ([oferta-test-poc-adequada] of RentalOffer
    (price 900.0)             ; 900€ > 800€ però <= 920€ (800*1.15)
    (hasProperty [pis-test-poc-adequat])
    (maxPeople 2)
    (minMonths 6)
  )

)
