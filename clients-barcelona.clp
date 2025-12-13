;;; ---------------------------------------------------------
;;; clients-barcelona.clp
;;; Base de dades amb diferents tipus de clients
;;; ---------------------------------------------------------

(definstances clients-barcelona

  ;;; ------------------------------
  ;;; PERFILS DE CLIENT
  ;;; ------------------------------

  ([perfil-couple-01] of Couple)
  ([perfil-couple-02] of Couple)
  ([perfil-couple-03] of Couple)
  
  ([perfil-family-01] of Family
    (numChildren 2)
    (numElderly 0))
  ([perfil-family-02] of Family
    (numChildren 1)
    (numElderly 0))
  ([perfil-family-03] of Family
    (numChildren 3)
    (numElderly 1))
  
  ([perfil-student-01] of Student)
  ([perfil-student-02] of Student)
  ([perfil-student-03] of Student)
  
  ([perfil-elderly-01] of Elderly)
  ([perfil-elderly-02] of Elderly)
  
  ([perfil-individual-01] of Individual)
  ([perfil-individual-02] of Individual)
  ([perfil-individual-03] of Individual)

  ;;; ------------------------------
  ;;; CLIENTS - PARELLES
  ;;; ------------------------------

  ;; Parella jove professional a Gràcia
  ([client-couple-gracia] of Client
    (hasProfile [perfil-couple-01])
    (prefersFeature [FeatureElevator] [FeatureBalcony] [FeatureAirOrHeating])
    (clientAge 32)
    (clientMaxPrice 1200.0)
    (numTenants 2)
    (minArea 65)
    (minDorms 2)
    (minReasonablePrice 900)
    (needsDoubleBedroom si)
    (priceFlexibility 10)
    (wantsGreenArea si)
    (wantsHealthCenter si)
    (wantsNightLife si)
    (wantsSchool no)
    (wantsStadium indiferent)
    (wantsSupermarket si)
    (wantsTransport si)
    (minMonthsClient 12)
    (worksOrStudies [loc-gracia])
  )

  ;; Parella que treballa a l'Eixample
  ([client-couple-eixample] of Client
    (hasProfile [perfil-couple-02])
    (prefersFeature [FeatureElevator] [FeatureTerrace] [FeatureAirOrHeating])
    (clientAge 35)
    (clientMaxPrice 1400.0)
    (numTenants 2)
    (minArea 70)
    (minDorms 2)
    (minReasonablePrice 1000)
    (needsDoubleBedroom si)
    (priceFlexibility 15)
    (wantsGreenArea si)
    (wantsHealthCenter si)
    (wantsNightLife indiferent)
    (wantsSchool no)
    (wantsStadium indiferent)
    (wantsSupermarket si)
    (wantsTransport si)
    (minMonthsClient 12)
    (worksOrStudies [loc-eixample-dreta])
  )

  ;; Parella jove amb pressupost limitat
  ([client-couple-lowbudget] of Client
    (hasProfile [perfil-couple-03])
    (prefersFeature [FeatureAppliances] [FeatureFurniture])
    (clientAge 28)
    (clientMaxPrice 900.0)
    (numTenants 2)
    (minArea 55)
    (minDorms 1)
    (minReasonablePrice 700)
    (needsDoubleBedroom si)
    (priceFlexibility 10)
    (wantsGreenArea indiferent)
    (wantsHealthCenter indiferent)
    (wantsNightLife si)
    (wantsSchool no)
    (wantsStadium indiferent)
    (wantsSupermarket si)
    (wantsTransport si)
    (minMonthsClient 6)
    (worksOrStudies [loc-poblenou])
  )

  ;;; ------------------------------
  ;;; CLIENTS - FAMÍLIES
  ;;; ------------------------------

  ;; Família amb 2 nens busca a Sarrià
  ([client-family-sarria] of Client
    (hasProfile [perfil-family-01])
    (prefersFeature [FeatureYard] [FeatureGarage] [FeaturePetsAllowed])
    (clientAge 40)
    (clientMaxPrice 2000.0)
    (numTenants 4)
    (minArea 100)
    (minDorms 3)
    (minReasonablePrice 1400)
    (needsDoubleBedroom si)
    (priceFlexibility 20)
    (wantsGreenArea si)
    (wantsHealthCenter si)
    (wantsNightLife no)
    (wantsSchool si)
    (wantsStadium indiferent)
    (wantsSupermarket si)
    (wantsTransport si)
    (minMonthsClient 24)
    (worksOrStudies [loc-sarria])
  )

  ;; Família amb 1 nen a l'Eixample
  ([client-family-eixample] of Client
    (hasProfile [perfil-family-02])
    (prefersFeature [FeatureElevator] [FeatureBalcony] [FeatureAirOrHeating])
    (clientAge 37)
    (clientMaxPrice 1500.0)
    (numTenants 3)
    (minArea 80)
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
    (worksOrStudies [loc-eixample-esquerra])
  )

  ;; Família gran amb 3 nens i un avi
  ([client-family-large] of Client
    (hasProfile [perfil-family-03])
    (prefersFeature [FeatureElevator] [FeatureYard] [FeatureTerrace])
    (clientAge 42)
    (clientMaxPrice 2500.0)
    (numTenants 6)
    (minArea 130)
    (minDorms 4)
    (minReasonablePrice 1800)
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
    (worksOrStudies [loc-horta])
  )

  ;;; ------------------------------
  ;;; CLIENTS - ESTUDIANTS
  ;;; ------------------------------

  ;; Estudiants compartint pis a Gràcia
  ([client-students-gracia] of Client
    (hasProfile [perfil-student-01])
    (prefersFeature [FeatureFurniture] [FeatureAppliances])
    (clientAge 21)
    (clientMaxPrice 900.0)
    (numTenants 3)
    (minArea 65)
    (minDorms 3)
    (minReasonablePrice 650)
    (needsDoubleBedroom no)
    (priceFlexibility 5)
    (wantsGreenArea indiferent)
    (wantsHealthCenter indiferent)
    (wantsNightLife si)
    (wantsSchool no)
    (wantsStadium indiferent)
    (wantsSupermarket si)
    (wantsTransport si)
    (minMonthsClient 10)
    (worksOrStudies [loc-eixample-dreta])
  )

  ;; Estudiants al Raval (pressupost molt ajustat)
  ([client-students-raval] of Client
    (hasProfile [perfil-student-02])
    (prefersFeature [FeatureFurniture] [FeatureAppliances])
    (clientAge 20)
    (clientMaxPrice 700.0)
    (numTenants 3)
    (minArea 55)
    (minDorms 3)
    (minReasonablePrice 500)
    (needsDoubleBedroom no)
    (priceFlexibility 5)
    (wantsGreenArea indiferent)
    (wantsHealthCenter indiferent)
    (wantsNightLife si)
    (wantsSchool no)
    (wantsStadium indiferent)
    (wantsSupermarket si)
    (wantsTransport si)
    (minMonthsClient 10)
    (worksOrStudies [loc-gotico])
  )

  ;; Estudiant individual al Poblenou
  ([client-student-poblenou] of Client
    (hasProfile [perfil-student-03])
    (prefersFeature [FeatureFurniture] [FeatureAppliances])
    (clientAge 23)
    (clientMaxPrice 750.0)
    (numTenants 1)
    (minArea 40)
    (minDorms 1)
    (minReasonablePrice 550)
    (needsDoubleBedroom no)
    (priceFlexibility 10)
    (wantsGreenArea indiferent)
    (wantsHealthCenter indiferent)
    (wantsNightLife si)
    (wantsSchool no)
    (wantsStadium indiferent)
    (wantsSupermarket si)
    (wantsTransport si)
    (minMonthsClient 10)
    (worksOrStudies [loc-poblenou])
  )

  ;;; ------------------------------
  ;;; CLIENTS - GENT GRAN
  ;;; ------------------------------

  ;; Persona gran a Sarrià
  ([client-elderly-sarria] of Client
    (hasProfile [perfil-elderly-01])
    (prefersFeature [FeatureElevator])
    (clientAge 68)
    (clientMaxPrice 1000.0)
    (numTenants 1)
    (minArea 50)
    (minDorms 1)
    (minReasonablePrice 750)
    (needsDoubleBedroom no)
    (priceFlexibility 10)
    (wantsGreenArea si)
    (wantsHealthCenter si)
    (wantsNightLife no)
    (wantsSchool no)
    (wantsStadium no)
    (wantsSupermarket si)
    (wantsTransport si)
    (minMonthsClient 12)
    (worksOrStudies [loc-sarria])
  )

  ;; Persona gran a l'Eixample
  ([client-elderly-eixample] of Client
    (hasProfile [perfil-elderly-02])
    (prefersFeature [FeatureElevator])
    (clientAge 72)
    (clientMaxPrice 950.0)
    (numTenants 1)
    (minArea 45)
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
    (wantsTransport si)
    (minMonthsClient 12)
    (worksOrStudies [loc-eixample-dreta])
  )

  ;;; ------------------------------
  ;;; CLIENTS - INDIVIDUALS
  ;;; ------------------------------

  ;; Jove professional a Gràcia
  ([client-individual-gracia] of Client
    (hasProfile [perfil-individual-01])
    (prefersFeature [FeatureBalcony] [FeatureTerrace])
    (clientAge 29)
    (clientMaxPrice 950.0)
    (numTenants 1)
    (minArea 45)
    (minDorms 1)
    (minReasonablePrice 750)
    (needsDoubleBedroom no)
    (priceFlexibility 10)
    (wantsGreenArea si)
    (wantsHealthCenter indiferent)
    (wantsNightLife si)
    (wantsSchool no)
    (wantsStadium indiferent)
    (wantsSupermarket si)
    (wantsTransport si)
    (minMonthsClient 6)
    (worksOrStudies [loc-gracia])
  )

  ;; Professional al Poblenou
  ([client-individual-poblenou] of Client
    (hasProfile [perfil-individual-02])
    (prefersFeature [FeatureElevator] [FeatureViews] [FeatureAirOrHeating])
    (clientAge 33)
    (clientMaxPrice 1100.0)
    (numTenants 1)
    (minArea 55)
    (minDorms 1)
    (minReasonablePrice 850)
    (needsDoubleBedroom no)
    (priceFlexibility 15)
    (wantsGreenArea si)
    (wantsHealthCenter si)
    (wantsNightLife indiferent)
    (wantsSchool no)
    (wantsStadium indiferent)
    (wantsSupermarket si)
    (wantsTransport si)
    (minMonthsClient 12)
    (worksOrStudies [loc-poblenou])
  )

  ;; Jove al Raval amb pressupost limitat
  ([client-individual-raval] of Client
    (hasProfile [perfil-individual-03])
    (prefersFeature [FeatureFurniture])
    (clientAge 26)
    (clientMaxPrice 700.0)
    (numTenants 1)
    (minArea 35)
    (minDorms 1)
    (minReasonablePrice 550)
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
    (worksOrStudies [loc-raval])
  )

  ;;; ------------------------------
  ;;; CLIENTS ADDICIONALS AMB DIFERENTS NECESSITATS
  ;;; ------------------------------

  ;; Freelancer que treballa des de casa
  ([client-freelancer-home] of Client
    (hasProfile [perfil-individual-01])
    (prefersFeature [FeatureBalcony] [FeatureViews])
    (clientAge 31)
    (clientMaxPrice 1000.0)
    (numTenants 1)
    (minArea 50)
    (minDorms 2)
    (minReasonablePrice 800)
    (needsDoubleBedroom no)
    (priceFlexibility 10)
    (wantsGreenArea si)
    (wantsHealthCenter indiferent)
    (wantsNightLife indiferent)
    (wantsSchool no)
    (wantsStadium indiferent)
    (wantsSupermarket si)
    (wantsTransport si)
    (minMonthsClient 12)
  )

  ;; Parella que vol viure prop del Camp Nou
  ([client-couple-campnou] of Client
    (hasProfile [perfil-couple-01])
    (prefersFeature [FeatureElevator] [FeatureBalcony])
    (clientAge 34)
    (clientMaxPrice 1200.0)
    (numTenants 2)
    (minArea 70)
    (minDorms 2)
    (minReasonablePrice 900)
    (needsDoubleBedroom si)
    (priceFlexibility 15)
    (wantsGreenArea indiferent)
    (wantsHealthCenter si)
    (wantsNightLife indiferent)
    (wantsSchool no)
    (wantsStadium si)
    (wantsSupermarket si)
    (wantsTransport si)
    (minMonthsClient 12)
    (worksOrStudies [loc-les-corts])
  )

  ;; Família que necessita zona tranquil·la
  ([client-family-quiet] of Client
    (hasProfile [perfil-family-02])
    (prefersFeature [FeatureYard] [FeatureTerrace])
    (clientAge 39)
    (clientMaxPrice 1800.0)
    (numTenants 3)
    (minArea 90)
    (minDorms 3)
    (minReasonablePrice 1300)
    (needsDoubleBedroom si)
    (priceFlexibility 15)
    (wantsGreenArea si)
    (wantsHealthCenter si)
    (wantsNightLife no)
    (wantsSchool si)
    (wantsStadium no)
    (wantsSupermarket si)
    (wantsTransport si)
    (minMonthsClient 24)
    (worksOrStudies [loc-horta])
  )

  ;; Estudiant internacional recent arribat
  ([client-student-international] of Client
    (hasProfile [perfil-student-01])
    (prefersFeature [FeatureFurniture] [FeatureAppliances])
    (clientAge 22)
    (clientMaxPrice 800.0)
    (numTenants 1)
    (minArea 40)
    (minDorms 1)
    (minReasonablePrice 600)
    (needsDoubleBedroom no)
    (priceFlexibility 10)
    (wantsGreenArea indiferent)
    (wantsHealthCenter indiferent)
    (wantsNightLife si)
    (wantsSchool no)
    (wantsStadium indiferent)
    (wantsSupermarket si)
    (wantsTransport si)
    (minMonthsClient 10)
    (worksOrStudies [loc-eixample-dreta])
  )

) ;; fi de definstances clients-barcelona
