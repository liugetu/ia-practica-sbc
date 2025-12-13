;;; ---------------------------------------------------------
;;; vivendes-barcelona.clp
;;; Base de dades amb vivendes i serveis de Barcelona
;;; ---------------------------------------------------------

(definstances vivendes-barcelona

  ;;; ------------------------------
  ;;; BARRIS DE BARCELONA
  ;;; ------------------------------

  ([barri-gracia] of Neighbourhood
    (NeighbourhoodName "Gràcia")
    (safety 4)
    (averagePrice 1050.0)
  )

  ([barri-sarria] of Neighbourhood
    (NeighbourhoodName "Sarrià-Sant Gervasi")
    (safety 5)
    (averagePrice 1400.0)
  )

  ([barri-eixample] of Neighbourhood
    (NeighbourhoodName "Eixample")
    (safety 4)
    (averagePrice 1150.0)
  )

  ([barri-poblenou] of Neighbourhood
    (NeighbourhoodName "Poblenou")
    (safety 4)
    (averagePrice 1000.0)
  )

  ([barri-raval] of Neighbourhood
    (NeighbourhoodName "El Raval")
    (safety 2)
    (averagePrice 850.0)
  )

  ([barri-gotico] of Neighbourhood
    (NeighbourhoodName "Barri Gòtic")
    (safety 3)
    (averagePrice 1200.0)
  )

  ([barri-sants] of Neighbourhood
    (NeighbourhoodName "Sants-Montjuïc")
    (safety 3)
    (averagePrice 900.0)
  )

  ([barri-horta] of Neighbourhood
    (NeighbourhoodName "Horta-Guinardó")
    (safety 4)
    (averagePrice 850.0)
  )

  ([barri-sant-marti] of Neighbourhood
    (NeighbourhoodName "Sant Martí")
    (safety 3)
    (averagePrice 900.0)
  )

  ([barri-nou-barris] of Neighbourhood
    (NeighbourhoodName "Nou Barris")
    (safety 3)
    (averagePrice 750.0)
  )

  ([barri-les-corts] of Neighbourhood
    (NeighbourhoodName "Les Corts")
    (safety 4)
    (averagePrice 1100.0)
  )

  ([barri-sant-andreu] of Neighbourhood
    (NeighbourhoodName "Sant Andreu")
    (safety 3)
    (averagePrice 800.0)
  )

  ;;; ------------------------------
  ;;; LOCALITZACIONS
  ;;; ------------------------------

  ([loc-gracia] of Location
    (latitude 41.403)
    (longitude 2.160)
    (isSituated [barri-gracia])
  )

  ([loc-sarria] of Location
    (latitude 41.400)
    (longitude 2.120)
    (isSituated [barri-sarria])
  )

  ([loc-eixample-dreta] of Location
    (latitude 41.395)
    (longitude 2.165)
    (isSituated [barri-eixample])
  )

  ([loc-eixample-esquerra] of Location
    (latitude 41.390)
    (longitude 2.155)
    (isSituated [barri-eixample])
  )

  ([loc-poblenou] of Location
    (latitude 41.405)
    (longitude 2.200)
    (isSituated [barri-poblenou])
  )

  ([loc-raval] of Location
    (latitude 41.380)
    (longitude 2.168)
    (isSituated [barri-raval])
  )

  ([loc-gotico] of Location
    (latitude 41.383)
    (longitude 2.176)
    (isSituated [barri-gotico])
  )

  ([loc-sants] of Location
    (latitude 41.379)
    (longitude 2.140)
    (isSituated [barri-sants])
  )

  ([loc-horta] of Location
    (latitude 41.430)
    (longitude 2.165)
    (isSituated [barri-horta])
  )

  ([loc-sant-marti] of Location
    (latitude 41.415)
    (longitude 2.195)
    (isSituated [barri-sant-marti])
  )

  ([loc-nou-barris] of Location
    (latitude 41.440)
    (longitude 2.175)
    (isSituated [barri-nou-barris])
  )

  ([loc-les-corts] of Location
    (latitude 41.385)
    (longitude 2.132)
    (isSituated [barri-les-corts])
  )

  ([loc-sant-andreu] of Location
    (latitude 41.435)
    (longitude 2.188)
    (isSituated [barri-sant-andreu])
  )

  ;;; ------------------------------
  ;;; SERVEIS
  ;;; ------------------------------

  ;; Zones Verdes
  ([parc-guell] of GreenArea
    (serviceName "Parc Güell")
    (serviceNoiseLevel 1)
    (serviceLocatedAt [loc-gracia])
  )

  ([parc-ciutadella] of GreenArea
    (serviceName "Parc de la Ciutadella")
    (serviceNoiseLevel 1)
    (serviceLocatedAt [loc-gotico])
  )

  ([jardins-pedralbes] of GreenArea
    (serviceName "Jardins de Pedralbes")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-sarria])
  )

  ([parc-poblenou] of GreenArea
    (serviceName "Parc del Centre del Poblenou")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-poblenou])
  )

  ([parc-collserola] of GreenArea
    (serviceName "Parc Natural de Collserola")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-horta])
  )

  ;; Centres de Salut
  ([cap-gracia] of HealthCenter
    (serviceName "CAP Gràcia")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-gracia])
  )

  ([cap-sarria] of HealthCenter
    (serviceName "CAP Sarrià")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-sarria])
  )

  ([cap-eixample] of HealthCenter
    (serviceName "CAP Eixample")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-eixample-dreta])
  )

  ([cap-poblenou] of HealthCenter
    (serviceName "CAP Poblenou")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-poblenou])
  )

  ([cap-raval] of HealthCenter
    (serviceName "CAP Raval Nord")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-raval])
  )

  ;; Escoles
  ([escola-gracia] of School
    (serviceName "Escola Pública Gràcia")
    (serviceNoiseLevel 1)
    (serviceLocatedAt [loc-gracia])
  )

  ([escola-sarria] of School
    (serviceName "Col·legi Sarrià")
    (serviceNoiseLevel 1)
    (serviceLocatedAt [loc-sarria])
  )

  ([escola-eixample] of School
    (serviceName "Escola Eixample")
    (serviceNoiseLevel 1)
    (serviceLocatedAt [loc-eixample-esquerra])
  )

  ([escola-poblenou] of School
    (serviceName "Escola Poblenou")
    (serviceNoiseLevel 1)
    (serviceLocatedAt [loc-poblenou])
  )

  ;; Vida Nocturna
  ([vida-nocturna-raval] of Nightlife
    (serviceName "Zona de bars del Raval")
    (serviceNoiseLevel 3)
    (serviceLocatedAt [loc-raval])
  )

  ([vida-nocturna-gotico] of Nightlife
    (serviceName "Zona de copes Gòtic")
    (serviceNoiseLevel 3)
    (serviceLocatedAt [loc-gotico])
  )

  ([vida-nocturna-gracia] of Nightlife
    (serviceName "Plaça del Sol")
    (serviceNoiseLevel 2)
    (serviceLocatedAt [loc-gracia])
  )

  ;; Estadis
  ([camp-nou] of Stadium
    (serviceName "Camp Nou")
    (serviceNoiseLevel 2)
    (serviceLocatedAt [loc-les-corts])
  )

  ([estadi-olimpic] of Stadium
    (serviceName "Estadi Olímpic Lluís Companys")
    (serviceNoiseLevel 1)
    (serviceLocatedAt [loc-sants])
  )

  ;; Supermercats
  ([super-gracia] of Supermarket
    (serviceName "Mercadona Gràcia")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-gracia])
  )

  ([super-sarria] of Supermarket
    (serviceName "Caprabo Sarrià")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-sarria])
  )

  ([super-eixample] of Supermarket
    (serviceName "Carrefour Eixample")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-eixample-dreta])
  )

  ([super-poblenou] of Supermarket
    (serviceName "Lidl Poblenou")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-poblenou])
  )

  ([super-raval] of Supermarket
    (serviceName "Mercadona Raval")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-raval])
  )

  ([super-sants] of Supermarket
    (serviceName "Bonpreu Sants")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-sants])
  )

  ;; Transport
  ([metro-fontana] of Transport
    (serviceName "Metro Fontana L3")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-gracia])
  )

  ([metro-sarria] of Transport
    (serviceName "FGC Sarrià")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-sarria])
  )

  ([metro-passeig-gracia] of Transport
    (serviceName "Metro Passeig de Gràcia L2/L3/L4")
    (serviceNoiseLevel 1)
    (serviceLocatedAt [loc-eixample-dreta])
  )

  ([metro-bogatell] of Transport
    (serviceName "Metro Bogatell L4")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-poblenou])
  )

  ([metro-liceu] of Transport
    (serviceName "Metro Liceu L3")
    (serviceNoiseLevel 0)
    (serviceLocatedAt [loc-raval])
  )

  ([metro-sants] of Transport
    (serviceName "Sants Estació L3/L5")
    (serviceNoiseLevel 1)
    (serviceLocatedAt [loc-sants])
  )

  ;;; ------------------------------
  ;;; HABITACIONS
  ;;; ------------------------------

  ;; Habitacions per les 50 vivendes
  ([room-01-01] of Room (isDouble TRUE))
  ([room-01-02] of Room (isDouble FALSE))
  ([room-02-01] of Room (isDouble TRUE))
  ([room-02-02] of Room (isDouble FALSE))
  ([room-03-01] of Room (isDouble TRUE))
  ([room-03-02] of Room (isDouble TRUE))
  ([room-04-01] of Room (isDouble FALSE))
  ([room-05-01] of Room (isDouble TRUE))
  ([room-05-02] of Room (isDouble FALSE))
  ([room-05-03] of Room (isDouble FALSE))
  ([room-06-01] of Room (isDouble TRUE))
  ([room-06-02] of Room (isDouble FALSE))
  ([room-06-03] of Room (isDouble FALSE))
  ([room-07-01] of Room (isDouble TRUE))
  ([room-08-01] of Room (isDouble TRUE))
  ([room-08-02] of Room (isDouble FALSE))
  ([room-09-01] of Room (isDouble TRUE))
  ([room-09-02] of Room (isDouble TRUE))
  ([room-10-01] of Room (isDouble TRUE))
  ([room-10-02] of Room (isDouble FALSE))
  ([room-10-03] of Room (isDouble FALSE))
  ([room-10-04] of Room (isDouble FALSE))
  ([room-11-01] of Room (isDouble TRUE))
  ([room-11-02] of Room (isDouble FALSE))
  ([room-12-01] of Room (isDouble FALSE))
  ([room-13-01] of Room (isDouble TRUE))
  ([room-13-02] of Room (isDouble TRUE))
  ([room-14-01] of Room (isDouble TRUE))
  ([room-14-02] of Room (isDouble FALSE))
  ([room-15-01] of Room (isDouble TRUE))
  ([room-16-01] of Room (isDouble TRUE))
  ([room-16-02] of Room (isDouble FALSE))
  ([room-16-03] of Room (isDouble FALSE))
  ([room-17-01] of Room (isDouble TRUE))
  ([room-17-02] of Room (isDouble FALSE))
  ([room-18-01] of Room (isDouble TRUE))
  ([room-18-02] of Room (isDouble FALSE))
  ([room-19-01] of Room (isDouble TRUE))
  ([room-19-02] of Room (isDouble TRUE))
  ([room-20-01] of Room (isDouble TRUE))
  ([room-20-02] of Room (isDouble FALSE))
  ([room-21-01] of Room (isDouble FALSE))
  ([room-22-01] of Room (isDouble TRUE))
  ([room-22-02] of Room (isDouble FALSE))
  ([room-23-01] of Room (isDouble TRUE))
  ([room-23-02] of Room (isDouble FALSE))
  ([room-23-03] of Room (isDouble FALSE))
  ([room-24-01] of Room (isDouble TRUE))
  ([room-24-02] of Room (isDouble TRUE))
  ([room-25-01] of Room (isDouble TRUE))
  ([room-25-02] of Room (isDouble FALSE))
  ([room-26-01] of Room (isDouble TRUE))
  ([room-27-01] of Room (isDouble FALSE))
  ([room-28-01] of Room (isDouble TRUE))
  ([room-28-02] of Room (isDouble FALSE))
  ([room-29-01] of Room (isDouble TRUE))
  ([room-29-02] of Room (isDouble TRUE))
  ([room-29-03] of Room (isDouble FALSE))
  ([room-30-01] of Room (isDouble TRUE))
  ([room-30-02] of Room (isDouble FALSE))
  ([room-31-01] of Room (isDouble TRUE))
  ([room-31-02] of Room (isDouble FALSE))
  ([room-32-01] of Room (isDouble FALSE))
  ([room-33-01] of Room (isDouble TRUE))
  ([room-33-02] of Room (isDouble FALSE))
  ([room-34-01] of Room (isDouble TRUE))
  ([room-34-02] of Room (isDouble TRUE))
  ([room-35-01] of Room (isDouble TRUE))
  ([room-35-02] of Room (isDouble FALSE))
  ([room-36-01] of Room (isDouble TRUE))
  ([room-36-02] of Room (isDouble FALSE))
  ([room-36-03] of Room (isDouble FALSE))
  ([room-37-01] of Room (isDouble TRUE))
  ([room-38-01] of Room (isDouble TRUE))
  ([room-38-02] of Room (isDouble FALSE))
  ([room-39-01] of Room (isDouble TRUE))
  ([room-39-02] of Room (isDouble FALSE))
  ([room-40-01] of Room (isDouble TRUE))
  ([room-40-02] of Room (isDouble TRUE))
  ([room-41-01] of Room (isDouble FALSE))
  ([room-42-01] of Room (isDouble TRUE))
  ([room-42-02] of Room (isDouble FALSE))
  ([room-43-01] of Room (isDouble TRUE))
  ([room-43-02] of Room (isDouble FALSE))
  ([room-43-03] of Room (isDouble FALSE))
  ([room-44-01] of Room (isDouble TRUE))
  ([room-44-02] of Room (isDouble FALSE))
  ([room-45-01] of Room (isDouble TRUE))
  ([room-45-02] of Room (isDouble TRUE))
  ([room-46-01] of Room (isDouble TRUE))
  ([room-47-01] of Room (isDouble TRUE))
  ([room-47-02] of Room (isDouble FALSE))
  ([room-48-01] of Room (isDouble TRUE))
  ([room-48-02] of Room (isDouble FALSE))
  ([room-48-03] of Room (isDouble FALSE))
  ([room-49-01] of Room (isDouble TRUE))
  ([room-49-02] of Room (isDouble FALSE))
  ([room-50-01] of Room (isDouble TRUE))
  ([room-50-02] of Room (isDouble FALSE))

  ;;; ------------------------------
  ;;; PROPIETATS
  ;;; ------------------------------

  ;; GRÀCIA (10 vivendes)
  ([viv-gracia-01] of Apartment
    (address "C/ Verdi 45, Gràcia")
    (area 65)
    (naturalLight 2)
    (state 4)
    (floor 3)
    (numBathrooms 1)
    (hasRoom [room-01-01] [room-01-02])
    (locatedAt [loc-gracia])
  )

  ([viv-gracia-02] of Apartment
    (address "C/ Torrent de l'Olla 82, Gràcia")
    (area 75)
    (naturalLight 3)
    (state 5)
    (floor 2)
    (numBathrooms 1)
    (isSoundproof TRUE)
    (hasRoom [room-02-01] [room-02-02])
    (locatedAt [loc-gracia])
  )

  ([viv-gracia-03] of Apartment
    (address "Plaça del Sol 12, Gràcia")
    (area 80)
    (naturalLight 3)
    (state 4)
    (floor 4)
    (numBathrooms 2)
    (hasRoom [room-03-01] [room-03-02])
    (locatedAt [loc-gracia])
  )

  ([viv-gracia-04] of Apartment
    (address "C/ Gran de Gràcia 155, Gràcia")
    (area 50)
    (naturalLight 1)
    (state 3)
    (floor 1)
    (numBathrooms 1)
    (hasRoom [room-04-01])
    (locatedAt [loc-gracia])
  )

  ([viv-gracia-05] of Duplex
    (address "C/ Astúries 28, Gràcia")
    (area 95)
    (naturalLight 3)
    (state 5)
    (floor 5)
    (numBathrooms 2)
    (isSoundproof TRUE)
    (hasRoom [room-05-01] [room-05-02] [room-05-03])
    (locatedAt [loc-gracia])
  )

  ([viv-gracia-06] of House
    (address "Passatge Permanyer 8, Gràcia")
    (area 120)
    (naturalLight 3)
    (state 5)
    (numBathrooms 2)
    (isSoundproof TRUE)
    (hasRoom [room-06-01] [room-06-02] [room-06-03])
    (locatedAt [loc-gracia])
  )

  ([viv-gracia-07] of Apartment
    (address "C/ Bruniquer 15, Gràcia")
    (area 55)
    (naturalLight 2)
    (state 3)
    (floor 2)
    (numBathrooms 1)
    (hasRoom [room-07-01])
    (locatedAt [loc-gracia])
  )

  ([viv-gracia-08] of Apartment
    (address "C/ Vallirana 72, Gràcia")
    (area 70)
    (naturalLight 2)
    (state 4)
    (floor 3)
    (numBathrooms 1)
    (hasRoom [room-08-01] [room-08-02])
    (locatedAt [loc-gracia])
  )

  ([viv-gracia-09] of Apartment
    (address "C/ Mozart 21, Gràcia")
    (area 85)
    (naturalLight 3)
    (state 5)
    (floor 6)
    (numBathrooms 2)
    (isSoundproof TRUE)
    (hasRoom [room-09-01] [room-09-02])
    (locatedAt [loc-gracia])
  )

  ([viv-gracia-10] of Duplex
    (address "C/ Ros de Olano 9, Gràcia")
    (area 110)
    (naturalLight 3)
    (state 5)
    (floor 7)
    (numBathrooms 3)
    (isSoundproof TRUE)
    (hasRoom [room-10-01] [room-10-02] [room-10-03] [room-10-04])
    (locatedAt [loc-gracia])
  )

  ;; SARRIÀ (8 vivendes)
  ([viv-sarria-01] of Apartment
    (address "C/ Major de Sarrià 45, Sarrià")
    (area 90)
    (naturalLight 3)
    (state 5)
    (floor 2)
    (numBathrooms 2)
    (isSoundproof TRUE)
    (hasRoom [room-11-01] [room-11-02])
    (locatedAt [loc-sarria])
  )

  ([viv-sarria-02] of Apartment
    (address "Plaça de Sarrià 8, Sarrià")
    (area 45)
    (naturalLight 2)
    (state 4)
    (floor 1)
    (numBathrooms 1)
    (hasRoom [room-12-01])
    (locatedAt [loc-sarria])
  )

  ([viv-sarria-03] of House
    (address "C/ Anglí 62, Sarrià")
    (area 150)
    (naturalLight 3)
    (state 5)
    (numBathrooms 3)
    (isSoundproof TRUE)
    (hasRoom [room-13-01] [room-13-02])
    (locatedAt [loc-sarria])
  )

  ([viv-sarria-04] of Apartment
    (address "Passeig de la Bonanova 88, Sarrià")
    (area 75)
    (naturalLight 3)
    (state 5)
    (floor 4)
    (numBathrooms 1)
    (isSoundproof TRUE)
    (hasRoom [room-14-01] [room-14-02])
    (locatedAt [loc-sarria])
  )

  ([viv-sarria-05] of Apartment
    (address "C/ Mandri 33, Sarrià")
    (area 60)
    (naturalLight 2)
    (state 4)
    (floor 3)
    (numBathrooms 1)
    (hasRoom [room-15-01])
    (locatedAt [loc-sarria])
  )

  ([viv-sarria-06] of House
    (address "C/ Eduard Conde 18, Sarrià")
    (area 180)
    (naturalLight 3)
    (state 5)
    (numBathrooms 3)
    (isSoundproof TRUE)
    (hasRoom [room-16-01] [room-16-02] [room-16-03])
    (locatedAt [loc-sarria])
  )

  ([viv-sarria-07] of Apartment
    (address "Via Augusta 122, Sarrià")
    (area 70)
    (naturalLight 3)
    (state 5)
    (floor 5)
    (numBathrooms 2)
    (isSoundproof TRUE)
    (hasRoom [room-17-01] [room-17-02])
    (locatedAt [loc-sarria])
  )

  ([viv-sarria-08] of Duplex
    (address "C/ Caponata 5, Sarrià")
    (area 130)
    (naturalLight 3)
    (state 5)
    (floor 6)
    (numBathrooms 2)
    (isSoundproof TRUE)
    (hasRoom [room-18-01] [room-18-02])
    (locatedAt [loc-sarria])
  )

  ;; EIXAMPLE (10 vivendes)
  ([viv-eixample-01] of Apartment
    (address "C/ Provença 256, Eixample")
    (area 85)
    (naturalLight 3)
    (state 5)
    (floor 3)
    (numBathrooms 2)
    (isSoundproof TRUE)
    (hasRoom [room-19-01] [room-19-02])
    (locatedAt [loc-eixample-dreta])
  )

  ([viv-eixample-02] of Apartment
    (address "Passeig de Gràcia 102, Eixample")
    (area 95)
    (naturalLight 3)
    (state 5)
    (floor 4)
    (numBathrooms 2)
    (isSoundproof TRUE)
    (hasRoom [room-20-01] [room-20-02])
    (locatedAt [loc-eixample-dreta])
  )

  ([viv-eixample-03] of Apartment
    (address "C/ Balmes 178, Eixample")
    (area 50)
    (naturalLight 2)
    (state 3)
    (floor 1)
    (numBathrooms 1)
    (hasRoom [room-21-01])
    (locatedAt [loc-eixample-dreta])
  )

  ([viv-eixample-04] of Apartment
    (address "C/ Girona 88, Eixample")
    (area 70)
    (naturalLight 2)
    (state 4)
    (floor 2)
    (numBathrooms 1)
    (hasRoom [room-22-01] [room-22-02])
    (locatedAt [loc-eixample-esquerra])
  )

  ([viv-eixample-05] of Duplex
    (address "C/ Aribau 145, Eixample")
    (area 100)
    (naturalLight 3)
    (state 5)
    (floor 5)
    (numBathrooms 2)
    (isSoundproof TRUE)
    (hasRoom [room-23-01] [room-23-02] [room-23-03])
    (locatedAt [loc-eixample-esquerra])
  )

  ([viv-eixample-06] of Apartment
    (address "C/ Diputació 312, Eixample")
    (area 90)
    (naturalLight 3)
    (state 5)
    (floor 4)
    (numBathrooms 2)
    (isSoundproof TRUE)
    (hasRoom [room-24-01] [room-24-02])
    (locatedAt [loc-eixample-dreta])
  )

  ([viv-eixample-07] of Apartment
    (address "C/ Enric Granados 65, Eixample")
    (area 75)
    (naturalLight 2)
    (state 4)
    (floor 3)
    (numBathrooms 1)
    (hasRoom [room-25-01] [room-25-02])
    (locatedAt [loc-eixample-esquerra])
  )

  ([viv-eixample-08] of Apartment
    (address "Ronda Universitat 22, Eixample")
    (area 55)
    (naturalLight 1)
    (state 3)
    (floor 2)
    (numBathrooms 1)
    (hasRoom [room-26-01])
    (locatedAt [loc-eixample-esquerra])
  )

  ([viv-eixample-09] of Apartment
    (address "C/ Consell de Cent 405, Eixample")
    (area 45)
    (naturalLight 1)
    (state 2)
    (floor 0)
    (numBathrooms 1)
    (hasRoom [room-27-01])
    (locatedAt [loc-eixample-dreta])
  )

  ([viv-eixample-10] of Apartment
    (address "C/ València 288, Eixample")
    (area 80)
    (naturalLight 3)
    (state 5)
    (floor 5)
    (numBathrooms 2)
    (isSoundproof TRUE)
    (hasRoom [room-28-01] [room-28-02])
    (locatedAt [loc-eixample-dreta])
  )

  ;; POBLENOU (8 vivendes)
  ([viv-poblenou-01] of Apartment
    (address "Rambla del Poblenou 125, Poblenou")
    (area 95)
    (naturalLight 3)
    (state 5)
    (floor 2)
    (numBathrooms 2)
    (isSoundproof TRUE)
    (hasRoom [room-29-01] [room-29-02] [room-29-03])
    (locatedAt [loc-poblenou])
  )

  ([viv-poblenou-02] of Apartment
    (address "C/ Llull 182, Poblenou")
    (area 70)
    (naturalLight 2)
    (state 4)
    (floor 3)
    (numBathrooms 1)
    (hasRoom [room-30-01] [room-30-02])
    (locatedAt [loc-poblenou])
  )

  ([viv-poblenou-03] of Apartment
    (address "Av. Diagonal 215, Poblenou")
    (area 75)
    (naturalLight 3)
    (state 4)
    (floor 4)
    (numBathrooms 1)
    (hasRoom [room-31-01] [room-31-02])
    (locatedAt [loc-poblenou])
  )

  ([viv-poblenou-04] of Apartment
    (address "C/ Pamplona 88, Poblenou")
    (area 55)
    (naturalLight 2)
    (state 3)
    (floor 1)
    (numBathrooms 1)
    (hasRoom [room-32-01])
    (locatedAt [loc-poblenou])
  )

  ([viv-poblenou-05] of Apartment
    (address "C/ Pere IV 245, Poblenou")
    (area 80)
    (naturalLight 2)
    (state 4)
    (floor 2)
    (numBathrooms 2)
    (hasRoom [room-33-01] [room-33-02])
    (locatedAt [loc-poblenou])
  )

  ([viv-poblenou-06] of Duplex
    (address "C/ Pujades 155, Poblenou")
    (area 105)
    (naturalLight 3)
    (state 5)
    (floor 6)
    (numBathrooms 2)
    (isSoundproof TRUE)
    (hasRoom [room-34-01] [room-34-02])
    (locatedAt [loc-poblenou])
  )

  ([viv-poblenou-07] of Apartment
    (address "C/ Tànger 72, Poblenou")
    (area 65)
    (naturalLight 2)
    (state 3)
    (floor 3)
    (numBathrooms 1)
    (hasRoom [room-35-01] [room-35-02])
    (locatedAt [loc-poblenou])
  )

  ([viv-poblenou-08] of House
    (address "C/ Bilbao 18, Poblenou")
    (area 140)
    (naturalLight 3)
    (state 5)
    (numBathrooms 3)
    (isSoundproof TRUE)
    (hasRoom [room-36-01] [room-36-02] [room-36-03])
    (locatedAt [loc-poblenou])
  )

  ;; RAVAL (5 vivendes)
  ([viv-raval-01] of Apartment
    (address "C/ Hospital 78, El Raval")
    (area 60)
    (naturalLight 1)
    (state 2)
    (floor 2)
    (numBathrooms 1)
    (hasRoom [room-37-01])
    (locatedAt [loc-raval])
  )

  ([viv-raval-02] of Apartment
    (address "C/ Robador 22, El Raval")
    (area 45)
    (naturalLight 0)
    (state 1)
    (floor 1)
    (numBathrooms 1)
    (hasDampness TRUE)
    (hasRoom [room-38-01] [room-38-02])
    (locatedAt [loc-raval])
  )

  ([viv-raval-03] of Apartment
    (address "Rambla del Raval 35, El Raval")
    (area 70)
    (naturalLight 2)
    (state 3)
    (floor 3)
    (numBathrooms 1)
    (hasRoom [room-39-01] [room-39-02])
    (locatedAt [loc-raval])
  )

  ([viv-raval-04] of Apartment
    (address "C/ Joaquín Costa 45, El Raval")
    (area 80)
    (naturalLight 2)
    (state 4)
    (floor 4)
    (numBathrooms 2)
    (isSoundproof FALSE)
    (hasRoom [room-40-01] [room-40-02])
    (locatedAt [loc-raval])
  )

  ([viv-raval-05] of Apartment
    (address "C/ Carme 12, El Raval")
    (area 50)
    (naturalLight 1)
    (state 2)
    (floor 1)
    (numBathrooms 1)
    (hasRoom [room-41-01])
    (locatedAt [loc-raval])
  )

  ;; BARRI GÒTIC (3 vivendes)
  ([viv-gotico-01] of Apartment
    (address "C/ Ferran 28, Barri Gòtic")
    (area 75)
    (naturalLight 1)
    (state 4)
    (floor 2)
    (numBathrooms 1)
    (hasRoom [room-42-01] [room-42-02])
    (locatedAt [loc-gotico])
  )

  ([viv-gotico-02] of Apartment
    (address "Plaça Sant Jaume 8, Barri Gòtic")
    (area 90)
    (naturalLight 2)
    (state 5)
    (floor 3)
    (numBathrooms 2)
    (isSoundproof TRUE)
    (hasRoom [room-43-01] [room-43-02] [room-43-03])
    (locatedAt [loc-gotico])
  )

  ([viv-gotico-03] of Apartment
    (address "C/ Avinyo 15, Barri Gòtic")
    (area 65)
    (naturalLight 1)
    (state 3)
    (floor 1)
    (numBathrooms 1)
    (hasRoom [room-44-01] [room-44-02])
    (locatedAt [loc-gotico])
  )

  ;; ALTRES BARRIS (6 vivendes)
  ([viv-sants-01] of Apartment
    (address "C/ Sants 245, Sants")
    (area 70)
    (naturalLight 2)
    (state 3)
    (floor 2)
    (numBathrooms 1)
    (hasRoom [room-45-01] [room-45-02])
    (locatedAt [loc-sants])
  )

  ([viv-horta-01] of House
    (address "C/ Horta 88, Horta")
    (area 110)
    (naturalLight 3)
    (state 4)
    (numBathrooms 2)
    (hasRoom [room-46-01])
    (locatedAt [loc-horta])
  )

  ([viv-nou-barris-01] of Apartment
    (address "C/ Via Júlia 45, Nou Barris")
    (area 65)
    (naturalLight 2)
    (state 3)
    (floor 3)
    (numBathrooms 1)
    (hasRoom [room-47-01] [room-47-02])
    (locatedAt [loc-nou-barris])
  )

  ([viv-les-corts-01] of Apartment
    (address "C/ Numància 125, Les Corts")
    (area 80)
    (naturalLight 2)
    (state 4)
    (floor 4)
    (numBathrooms 2)
    (hasRoom [room-48-01] [room-48-02] [room-48-03])
    (locatedAt [loc-les-corts])
  )

  ([viv-sant-marti-01] of Apartment
    (address "C/ Guipúscoa 78, Sant Martí")
    (area 60)
    (naturalLight 2)
    (state 3)
    (floor 2)
    (numBathrooms 1)
    (hasRoom [room-49-01] [room-49-02])
    (locatedAt [loc-sant-marti])
  )

  ([viv-sant-andreu-01] of Apartment
    (address "C/ Gran de Sant Andreu 155, Sant Andreu")
    (area 70)
    (naturalLight 2)
    (state 3)
    (floor 3)
    (numBathrooms 1)
    (hasRoom [room-50-01] [room-50-02])
    (locatedAt [loc-sant-andreu])
  )

  ;;; ------------------------------
  ;;; OFERTES DE LLOGUER
  ;;; ------------------------------

  ;; Ofertes Gràcia
  ([oferta-gracia-01] of RentalOffer
    (hasProperty [viv-gracia-01])
    (hasFeature [FeatureElevator] [FeatureBalcony])
    (price 900.0)
    (maxPeople 3)
    (minMonths 12)
  )

  ([oferta-gracia-02] of RentalOffer
    (hasProperty [viv-gracia-02])
    (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureAirOrHeating] [FeatureAppliances])
    (price 1100.0)
    (maxPeople 3)
    (minMonths 12)
  )

  ([oferta-gracia-03] of RentalOffer
    (hasProperty [viv-gracia-03])
    (hasFeature [FeatureElevator] [FeatureTerrace] [FeatureViews])
    (price 1200.0)
    (maxPeople 4)
    (minMonths 12)
  )

  ([oferta-gracia-04] of RentalOffer
    (hasProperty [viv-gracia-04])
    (hasFeature [FeatureFurniture])
    (price 650.0)
    (maxPeople 2)
    (minMonths 6)
  )

  ([oferta-gracia-05] of RentalOffer
    (hasProperty [viv-gracia-05])
    (hasFeature [FeatureElevator] [FeatureTerrace] [FeatureAirOrHeating] [FeatureAppliances])
    (price 1400.0)
    (maxPeople 4)
    (minMonths 12)
  )

  ([oferta-gracia-06] of RentalOffer
    (hasProperty [viv-gracia-06])
    (hasFeature [FeatureYard] [FeatureTerrace] [FeatureAirOrHeating] [FeaturePetsAllowed])
    (price 1800.0)
    (maxPeople 5)
    (minMonths 24)
  )

  ([oferta-gracia-07] of RentalOffer
    (hasProperty [viv-gracia-07])
    (hasFeature [FeatureFurniture] [FeatureAppliances])
    (price 750.0)
    (maxPeople 2)
    (minMonths 6)
  )

  ([oferta-gracia-08] of RentalOffer
    (hasProperty [viv-gracia-08])
    (hasFeature [FeatureBalcony] [FeatureAppliances])
    (price 950.0)
    (maxPeople 3)
    (minMonths 12)
  )

  ([oferta-gracia-09] of RentalOffer
    (hasProperty [viv-gracia-09])
    (hasFeature [FeatureElevator] [FeatureTerrace] [FeatureViews] [FeatureAirOrHeating])
    (price 1300.0)
    (maxPeople 4)
    (minMonths 12)
  )

  ([oferta-gracia-10] of RentalOffer
    (hasProperty [viv-gracia-10])
    (hasFeature [FeatureElevator] [FeatureTerrace] [FeatureViews] [FeatureAirOrHeating] [FeatureAppliances])
    (price 1700.0)
    (maxPeople 5)
    (minMonths 24)
  )

  ;; Ofertes Sarrià
  ([oferta-sarria-01] of RentalOffer
    (hasProperty [viv-sarria-01])
    (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureAirOrHeating] [FeatureAppliances])
    (price 1500.0)
    (maxPeople 3)
    (minMonths 12)
  )

  ([oferta-sarria-02] of RentalOffer
    (hasProperty [viv-sarria-02])
    (hasFeature [FeatureFurniture] [FeatureAppliances])
    (price 950.0)
    (maxPeople 2)
    (minMonths 6)
  )

  ([oferta-sarria-03] of RentalOffer
    (hasProperty [viv-sarria-03])
    (hasFeature [FeatureYard] [FeatureGarage] [FeatureTerrace] [FeatureAirOrHeating] [FeaturePetsAllowed])
    (price 2500.0)
    (maxPeople 5)
    (minMonths 24)
  )

  ([oferta-sarria-04] of RentalOffer
    (hasProperty [viv-sarria-04])
    (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureAirOrHeating] [FeatureViews])
    (price 1350.0)
    (maxPeople 3)
    (minMonths 12)
  )

  ([oferta-sarria-05] of RentalOffer
    (hasProperty [viv-sarria-05])
    (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureAppliances])
    (price 1100.0)
    (maxPeople 2)
    (minMonths 12)
  )

  ([oferta-sarria-06] of RentalOffer
    (hasProperty [viv-sarria-06])
    (hasFeature [FeatureYard] [FeatureGarage] [FeatureTerrace] [FeatureAirOrHeating] [FeatureAppliances] [FeaturePetsAllowed])
    (price 3000.0)
    (maxPeople 6)
    (minMonths 24)
  )

  ([oferta-sarria-07] of RentalOffer
    (hasProperty [viv-sarria-07])
    (hasFeature [FeatureElevator] [FeatureTerrace] [FeatureViews] [FeatureAirOrHeating])
    (price 1400.0)
    (maxPeople 3)
    (minMonths 12)
  )

  ([oferta-sarria-08] of RentalOffer
    (hasProperty [viv-sarria-08])
    (hasFeature [FeatureElevator] [FeatureTerrace] [FeatureViews] [FeatureAirOrHeating] [FeatureAppliances])
    (price 2000.0)
    (maxPeople 4)
    (minMonths 24)
  )

  ;; Ofertes Eixample
  ([oferta-eixample-01] of RentalOffer
    (hasProperty [viv-eixample-01])
    (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureAirOrHeating] [FeatureAppliances])
    (price 1250.0)
    (maxPeople 4)
    (minMonths 12)
  )

  ([oferta-eixample-02] of RentalOffer
    (hasProperty [viv-eixample-02])
    (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureTerrace] [FeatureViews] [FeatureAirOrHeating])
    (price 1450.0)
    (maxPeople 4)
    (minMonths 12)
  )

  ([oferta-eixample-03] of RentalOffer
    (hasProperty [viv-eixample-03])
    (hasFeature [FeatureFurniture] [FeatureAppliances])
    (price 700.0)
    (maxPeople 2)
    (minMonths 6)
  )

  ([oferta-eixample-04] of RentalOffer
    (hasProperty [viv-eixample-04])
    (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureAppliances])
    (price 1000.0)
    (maxPeople 3)
    (minMonths 12)
  )

  ([oferta-eixample-05] of RentalOffer
    (hasProperty [viv-eixample-05])
    (hasFeature [FeatureElevator] [FeatureTerrace] [FeatureAirOrHeating] [FeatureAppliances])
    (price 1500.0)
    (maxPeople 4)
    (minMonths 12)
  )

  ([oferta-eixample-06] of RentalOffer
    (hasProperty [viv-eixample-06])
    (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureAirOrHeating] [FeatureAppliances])
    (price 1350.0)
    (maxPeople 4)
    (minMonths 12)
  )

  ([oferta-eixample-07] of RentalOffer
    (hasProperty [viv-eixample-07])
    (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureAppliances])
    (price 1050.0)
    (maxPeople 3)
    (minMonths 12)
  )

  ([oferta-eixample-08] of RentalOffer
    (hasProperty [viv-eixample-08])
    (hasFeature [FeatureFurniture])
    (price 650.0)
    (maxPeople 2)
    (minMonths 6)
  )

  ([oferta-eixample-09] of RentalOffer
    (hasProperty [viv-eixample-09])
    (hasFeature [FeatureFurniture])
    (price 550.0)
    (maxPeople 1)
    (minMonths 6)
  )

  ([oferta-eixample-10] of RentalOffer
    (hasProperty [viv-eixample-10])
    (hasFeature [FeatureElevator] [FeatureTerrace] [FeatureViews] [FeatureAirOrHeating])
    (price 1250.0)
    (maxPeople 3)
    (minMonths 12)
  )

  ;; Ofertes Poblenou
  ([oferta-poblenou-01] of RentalOffer
    (hasProperty [viv-poblenou-01])
    (hasFeature [FeatureElevator] [FeatureTerrace] [FeatureAirOrHeating] [FeatureAppliances])
    (price 1400.0)
    (maxPeople 4)
    (minMonths 12)
  )

  ([oferta-poblenou-02] of RentalOffer
    (hasProperty [viv-poblenou-02])
    (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureAppliances])
    (price 950.0)
    (maxPeople 3)
    (minMonths 12)
  )

  ([oferta-poblenou-03] of RentalOffer
    (hasProperty [viv-poblenou-03])
    (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureViews] [FeatureAppliances])
    (price 1050.0)
    (maxPeople 3)
    (minMonths 12)
  )

  ([oferta-poblenou-04] of RentalOffer
    (hasProperty [viv-poblenou-04])
    (hasFeature [FeatureFurniture] [FeatureAppliances])
    (price 750.0)
    (maxPeople 2)
    (minMonths 6)
  )

  ([oferta-poblenou-05] of RentalOffer
    (hasProperty [viv-poblenou-05])
    (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureAppliances])
    (price 1100.0)
    (maxPeople 3)
    (minMonths 12)
  )

  ([oferta-poblenou-06] of RentalOffer
    (hasProperty [viv-poblenou-06])
    (hasFeature [FeatureElevator] [FeatureTerrace] [FeatureViews] [FeatureAirOrHeating] [FeatureAppliances])
    (price 1600.0)
    (maxPeople 4)
    (minMonths 12)
  )

  ([oferta-poblenou-07] of RentalOffer
    (hasProperty [viv-poblenou-07])
    (hasFeature [FeatureElevator] [FeatureAppliances])
    (price 850.0)
    (maxPeople 2)
    (minMonths 12)
  )

  ([oferta-poblenou-08] of RentalOffer
    (hasProperty [viv-poblenou-08])
    (hasFeature [FeatureYard] [FeatureTerrace] [FeatureAirOrHeating] [FeaturePetsAllowed])
    (price 2200.0)
    (maxPeople 5)
    (minMonths 24)
  )

  ;; Ofertes Raval
  ([oferta-raval-01] of RentalOffer
    (hasProperty [viv-raval-01])
    (hasFeature [FeatureFurniture])
    (price 650.0)
    (maxPeople 2)
    (minMonths 6)
  )

  ([oferta-raval-02] of RentalOffer
    (hasProperty [viv-raval-02])
    (hasFeature [FeatureFurniture])
    (price 500.0)
    (maxPeople 2)
    (minMonths 6)
  )

  ([oferta-raval-03] of RentalOffer
    (hasProperty [viv-raval-03])
    (hasFeature [FeatureElevator] [FeatureAppliances])
    (price 800.0)
    (maxPeople 3)
    (minMonths 12)
  )

  ([oferta-raval-04] of RentalOffer
    (hasProperty [viv-raval-04])
    (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureAppliances])
    (price 950.0)
    (maxPeople 3)
    (minMonths 12)
  )

  ([oferta-raval-05] of RentalOffer
    (hasProperty [viv-raval-05])
    (hasFeature [FeatureFurniture])
    (price 600.0)
    (maxPeople 2)
    (minMonths 6)
  )

  ;; Ofertes Barri Gòtic
  ([oferta-gotico-01] of RentalOffer
    (hasProperty [viv-gotico-01])
    (hasFeature [FeatureElevator] [FeatureAppliances])
    (price 1100.0)
    (maxPeople 3)
    (minMonths 12)
  )

  ([oferta-gotico-02] of RentalOffer
    (hasProperty [viv-gotico-02])
    (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureAirOrHeating] [FeatureAppliances])
    (price 1400.0)
    (maxPeople 4)
    (minMonths 12)
  )

  ([oferta-gotico-03] of RentalOffer
    (hasProperty [viv-gotico-03])
    (hasFeature [FeatureAppliances])
    (price 900.0)
    (maxPeople 3)
    (minMonths 12)
  )

  ;; Ofertes altres barris
  ([oferta-sants-01] of RentalOffer
    (hasProperty [viv-sants-01])
    (hasFeature [FeatureElevator] [FeatureAppliances])
    (price 850.0)
    (maxPeople 3)
    (minMonths 12)
  )

  ([oferta-horta-01] of RentalOffer
    (hasProperty [viv-horta-01])
    (hasFeature [FeatureYard] [FeatureTerrace] [FeaturePetsAllowed])
    (price 1600.0)
    (maxPeople 4)
    (minMonths 24)
  )

  ([oferta-nou-barris-01] of RentalOffer
    (hasProperty [viv-nou-barris-01])
    (hasFeature [FeatureElevator] [FeatureAppliances])
    (price 700.0)
    (maxPeople 3)
    (minMonths 12)
  )

  ([oferta-les-corts-01] of RentalOffer
    (hasProperty [viv-les-corts-01])
    (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureAppliances])
    (price 1150.0)
    (maxPeople 4)
    (minMonths 12)
  )

  ([oferta-sant-marti-01] of RentalOffer
    (hasProperty [viv-sant-marti-01])
    (hasFeature [FeatureElevator] [FeatureAppliances])
    (price 800.0)
    (maxPeople 3)
    (minMonths 12)
  )

  ([oferta-sant-andreu-01] of RentalOffer
    (hasProperty [viv-sant-andreu-01])
    (hasFeature [FeatureElevator] [FeatureBalcony] [FeatureAppliances])
    (price 750.0)
    (maxPeople 3)
    (minMonths 12)
  )

) ;; fi de definstances vivendes-barcelona
