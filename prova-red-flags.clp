;;; ---------------------------------------------------------
;;; prova-squatters.clp
;;; Ofertes de prova (squatters)
;;; ---------------------------------------------------------

(definstances prova-squatters

	([perfil-elderly-02] of Elderly)

	([barri-poblenou] of Neighbourhood
		(NeighbourhoodName "Poblenou")
		(safety 4)
		(averagePrice 1000.0)
	)

	([loc-poblenou] of Location
		(latitude 41.405)
		(longitude 2.200)
		(isSituated [barri-poblenou])
	)

    ([parc-poblenou] of GreenArea
        (serviceName "Parc del Centre del Poblenou")
        (serviceNoiseLevel 0)
        (serviceLocatedAt [loc-poblenou])
    )

    ([cap-poblenou] of HealthCenter
        (serviceName "CAP Poblenou")
        (serviceNoiseLevel 0)
        (serviceLocatedAt [loc-poblenou])
    )

    ([super-poblenou] of Supermarket
        (serviceName "Lidl Poblenou")
        (serviceNoiseLevel 0)
        (serviceLocatedAt [loc-poblenou])
    )

    ([metro-bogatell] of Transport
        (serviceName "Metro Bogatell L4")
        (serviceNoiseLevel 0)
        (serviceLocatedAt [loc-poblenou])
    )

	([room-51-01] of Room (isDouble TRUE))

	([viv-poblenou-09] of Apartment
		(address "A/ d'Icària 204, Poblenou")
		(area 75)
		(naturalLight 2)
		(state 4)
		(floor 3)
        (hasSquatters TRUE)
		(numBathrooms 1)
		(hasRoom [room-51-01] [room-51-02])
		(locatedAt [loc-poblenou])
	)

	([oferta-squatters-01] of RentalOffer
		(hasProperty [viv-poblenou-09])
		(hasFeature [FeatureElevator] [FeatureBalcony] [FeatureAppliances])
		(price 950)
		(maxPeople 3)
		(minMonths 12)
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
)