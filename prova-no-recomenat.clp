;;; ---------------------------------------------------------
;;; prova-no-recomenat.clp
;;; Joc de prova per generar una recomanació "no recomenat"
;;; ---------------------------------------------------------

(definstances prova-no-recomenat

  ;;; ---------------------------------------------------------
  ;;; Perfil i Client amb requisits molt estrictes i específics
  ;;; ---------------------------------------------------------

  ([perfil-test-estudiant] of Student
  )

  ([client-test-no-recomenat] of Client
    (hasProfile [perfil-test-estudiant])
    (clientAge 22)
    
    ;; Pressupost molt limitat
    (clientMaxPrice 400.0)    ; Pressupost molt baix
    (minReasonablePrice 350)
    (priceFlexibility 5)      ; Només 5% de flexibilitat
    
    ;; Requisits de mida i habitacions
    (minArea 80)              ; Vol una vivenda gran
    (minDorms 3)              ; Vol 3 dormitoris
    (numTenants 1)
    
    ;; Preferències d'ubicació
    (worksOrStudies [loc-campus-nord])
    
    ;; Preferències de serveis
    (wantsGreenArea si)     ; Necessita espais verds
    (wantsHealthCenter si)  ; Necessita centre de salut proper
    (wantsNightLife no)    ; No li interessa l'oci nocturn
    (wantsSchool no)       ; No necessita escola
    (wantsStadium no)      ; No necessita estadi
    (wantsSupermarket si)   ; Necessita supermercat proper
    (wantsTransport no)
    
    (minMonthsClient 12)
  )

  ;;; ---------------------------------------------------------
  ;;; Oferta que NO compleix els requisits del client
  ;;; ---------------------------------------------------------

  ([barri-periferia] of Neighbourhood
    (NeighbourhoodName "Periferia Verda")
    (safety 5)
    (averagePrice 1200.0)
  )


  ;; Localització diferent i lluny del campus
  ([loc-test-lluny] of Location
    (latitude 41.50)          ; Molt allunyat del campus
    (longitude 2.25)
    (isSituated [barri-periferia])
  )

  ;; Només 1 habitació (client en vol 3)
  ([dorm-test] of Room
    (isDouble FALSE)
  )

  ;; Propietat petita i cara amb problemes
  ([pis-test-no-adequat] of Apartment
    (area 35)                 ; Massa petit (client vol 80m²)
    (locatedAt [loc-test-lluny])
    (hasRoom [dorm-test])     ; Només 1 habitació
    (floor 5)
    (numBathrooms 1)
    (naturalLight 3)
    (state 2)                 ; Mal estat
    (hasDampness TRUE)        ; Té humitats
    (hasSquatters TRUE)
    (hasLeaks TRUE)
    (isSoundproof FALSE)
  )

  ;; Oferta de lloguer cara
  ([oferta-test-no-adequada] of RentalOffer
    (price 1200.0)            ; Massa car (client té màxim 400€)
    (hasProperty [pis-test-no-adequat])
    (maxPeople 2)
    (minMonths 6)
  )

)
