;;; ---------------------------------------------------------
;;; ontologia.clp
;;; Translated by owl2clips
;;; Translated to CLIPS from ontology alquileres.ttl
;;; :Date 08/12/2025 18:56:38

(defclass Property "Component físic: característiques intrínseques de l'habitatge."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; Relaciona una propietat amb una de les seves habitacions
    (multislot hasRoom
        (type INSTANCE)
        (create-accessor read-write))
    ;;; Relaciona un immoble amb la seva ubicació/coordenades
    (multislot locatedAt
        (type INSTANCE)
        (create-accessor read-write))
    (multislot address
        (type STRING)
        (create-accessor read-write))
    ;;; Superfície de l'immoble
    (multislot area
        (type INTEGER)
        (create-accessor read-write))
    (multislot naturalLight
        (type INTEGER)
        (create-accessor read-write))
    (multislot state
        (type INTEGER)
        (create-accessor read-write))
    ;;; Indica si la propietat té okupes il·legals (squatters)
    (multislot hasSquatters
        (type SYMBOL)
        (create-accessor read-write))
    ;;; Representa el número de lavabos d'una propietat
    (multislot numBathrooms
        (type INTEGER)
        (create-accessor read-write))
    ;;; Indica si la propietat té humitats (damp)
    (multislot hasDampness
        (type SYMBOL)
        (create-accessor read-write))
    ;;; Indica si la propietat té fugues (d'aigua, gas...) (leaks)
    (multislot hasLeaks
        (type SYMBOL)
        (create-accessor read-write))
)

(defclass Apartment
    (is-a Property)
    (role concrete)
    (pattern-match reactive)
    ;;; Planta on esta situat el pis o duplex
    (multislot floor
        (type INTEGER)
        (create-accessor read-write))
)

(defclass Duplex
    (is-a Property)
    (role concrete)
    (pattern-match reactive)
    ;;; Planta on esta situat el pis o duplex
    (multislot floor
        (type INTEGER)
        (create-accessor read-write))
)

(defclass House
    (is-a Property)
    (role concrete)
    (pattern-match reactive)
)

(defclass Service "Transport, supermercat, escola, centre de salut, oci, etc."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; Relaciona un servei amb la seva ubicació/coordenades
    (multislot serviceLocatedAt
        (type INSTANCE)
        (create-accessor read-write))
    ;;; Nom del servei
    (multislot serviceName
        (type STRING)
        (create-accessor read-write))
    (multislot serviceNoiseLevel
        (type INTEGER)
        (create-accessor read-write))
)

(defclass GreenArea
    (is-a Service)
    (role concrete)
    (pattern-match reactive)
)

(defclass HealthCenter
    (is-a Service)
    (role concrete)
    (pattern-match reactive)
)

(defclass Nightlife
    (is-a Service)
    (role concrete)
    (pattern-match reactive)
)

(defclass School
    (is-a Service)
    (role concrete)
    (pattern-match reactive)
)

(defclass Stadium
    (is-a Service)
    (role concrete)
    (pattern-match reactive)
)

(defclass Supermarket
    (is-a Service)
    (role concrete)
    (pattern-match reactive)
)

(defclass Transport
    (is-a Service)
    (role concrete)
    (pattern-match reactive)
)

(defclass ClientProfile "Tipus de client: jove, família, estudiant, persona gran, etc."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass Couple
    (is-a ClientProfile)
    (role concrete)
    (pattern-match reactive)
)

(defclass Elderly
    (is-a ClientProfile)
    (role concrete)
    (pattern-match reactive)
)

(defclass Family
    (is-a ClientProfile)
    (role concrete)
    (pattern-match reactive)
<<<<<<< HEAD
    ;;; Numero de "tenants" que son avis
    (multislot numElderly
        (type INTEGER)
        (create-accessor read-write))
    ;;; Numero de "tenants" que són nens
=======
    (multislot numElderly
        (type INTEGER)
        (create-accessor read-write))
>>>>>>> cea2762b2eba4d781340cff5a464e8b939c2980a
    (multislot numChildren
        (type INTEGER)
        (create-accessor read-write))
)

(defclass Student
    (is-a ClientProfile)
    (role concrete)
    (pattern-match reactive)
)

(defclass Individual
    (is-a ClientProfile)
    (role concrete)
    (pattern-match reactive)
)

(defclass Client "Guarda les preferències/restriccions del client"
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; Relaciona un client amb el seu perfil (grup socioeconomic predeterminat)
    (multislot hasProfile
        (type INSTANCE)
        (create-accessor read-write))
    ;;; El client té preferència per la característica
    (multislot prefersFeature
        (type INSTANCE)
        (create-accessor read-write))
    ;;; Associa el lloc de trabll o estudi del client a una localització
    (multislot worksOrStudies
        (type INSTANCE)
        (create-accessor read-write))
    ;;; Edat del client
    (multislot clientAge
        (type INTEGER)
        (create-accessor read-write))
    ;;; Preu màxim que es pot permetre de pagar el client
    (multislot clientMaxPrice
        (type FLOAT)
        (create-accessor read-write))
    (multislot numTenants
        (type INTEGER)
        (create-accessor read-write))
    (multislot minArea
        (type INTEGER)
        (create-accessor read-write))
    (multislot minDorms
        (type INTEGER)
        (create-accessor read-write))
    (multislot minReasonablePrice
        (type INTEGER)
        (create-accessor read-write))
    (multislot needsDoubleBedroom
        (type SYMBOL)
        (create-accessor read-write))
    ;;; Flexibilitat respecte el preu màxim que es pot permetre (en percentatge)
    (multislot priceFlexibility
        (type INTEGER)
        (create-accessor read-write))
    (multislot wantsGreenArea
        (type SYMBOL)
        (create-accessor read-write))
    (multislot wantsHealthCenter
        (type SYMBOL)
        (create-accessor read-write))
    (multislot wantsNightLife
        (type SYMBOL)
        (create-accessor read-write))
    (multislot wantsSchool
        (type SYMBOL)
        (create-accessor read-write))
    (multislot wantsStadium
        (type SYMBOL)
        (create-accessor read-write))
    (multislot wantsSupermarket
        (type SYMBOL)
        (create-accessor read-write))
    (multislot wantsTransport
        (type SYMBOL)
        (create-accessor read-write))
    ;;; Indica el mínim número de mesos que el client vol llogar el pis
    (multislot minMonthsClient
        (type INTEGER)
        (create-accessor read-write))
    ;;; Lloc on el client treballa o estudia (màxim 1, pot ser nil)
    (slot worksOrStudies
        (type INSTANCE)
        (create-accessor read-write))
)

(defclass Location "Coordenades i referències administratives (districte, adreça)."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; Coordenada de latitud de l'immoble
    (multislot latitude
        (type FLOAT)
        (create-accessor read-write))
    ;;; Coordenada de longitud de l'immoble
    (multislot longitude
        (type FLOAT)
        (create-accessor read-write))
    ;;; Relació: una Location pertany a un Neighbourhood
    (multislot isSituated
        (type INSTANCE)
        (create-accessor read-write))
)

(defclass Neighbourhood "Representa un barri amb les seves característiques."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; Nom del barri
    (multislot NeighbourhoodName
        (type STRING)
        (create-accessor read-write))
    ;;; Nivell de seguretat del barri
    (multislot safety
        (type INTEGER)
        (create-accessor read-write))
    ;;; Preu mitjà del barri
    (multislot averagePrice
        (type FLOAT)
        (create-accessor read-write))
)

(defclass PropertyFeature "Defineix les possibles característiques d'una propietat"
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass Proximity "Classe intermitja que diu la proximitat d'una propietat a un serveri"
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot nearProperty
        (type INSTANCE)
        (create-accessor read-write))
    ;;; Relació que s'utilitza quan un servei està dins d'una distància definida (p. ex. <=500 m).
    (multislot nearService
        (type INSTANCE)
        (create-accessor read-write))
    ;;; Si una Property està a prop (0), a mitja distància (1), lluny (2)
    (multislot distanceCategory
        (type INTEGER)
        (create-accessor read-write))
)

(defclass Recommendation "Entitat que documenta la relació entre una oferta i un client amb un nivell de recomanació."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; Oferta concreta que descriu aquesta recomanació.
    (multislot aboutOffer
        (type INSTANCE)
        (create-accessor read-write))
    ;;; Associa una recomanació amb el client destinatari.
    (multislot recommendedFor
        (type INSTANCE)
        (create-accessor read-write))
    ;;; Etiqueta textual del grau d'idoneïtat (p. ex. molt recomanable).
    (multislot recommendationLevel
        (type STRING)
        (create-accessor read-write))
)

(defclass RentalOffer "Instància que representa una oferta concreta (piso, dúplex, casa...)."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; La propietat té la característica
    (multislot hasFeature
        (type INSTANCE)
        (create-accessor read-write))
    ;;; Relaciona un immoble amb una de les seves possibles ofertes de lloguer
    (multislot hasProperty
        (type INSTANCE)
        (create-accessor read-write))
    (multislot maxPeople
        (type INTEGER)
        (create-accessor read-write))
    (multislot minMonths
        (type INTEGER)
        (create-accessor read-write))
    ;;; Preu mensual en euros que es demana per aquella oferta de lloguer
    (multislot price
        (type FLOAT)
        (create-accessor read-write))
)

(defclass Room "Modela dormitoris (simple/doble) i altres estances si cal."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; Indica si la habitació és doble o no
    (multislot isDouble
        (type SYMBOL)
        (create-accessor read-write))
)

(defclass Neighbourhood "Representa un barri"
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; Representa la seguretat del barri, 0 (no hi ha), 5 (supersegur)
    (multislot safety
        (type SYMBOL)
        (create-accessor read-write))
    ;;; Preu mitjà de les propietats situades al barri
    (multislot averagePrice
        (type FLOAT)
        (create-accessor read-write))
    ;;; Nom del barri
    (multislot neighbourhoodName
        (type STRING)
        (create-accessor read-write))
)

(definstances instances
    ([FeatureAirOrHeating] of Característica
    )

    ([FeatureAppliances] of Característica
    )

    ([FeatureBalcony] of Característica
    )

    ([FeatureElevator] of Característica
    )

    ([FeatureFurniture] of Característica
    )

    ([FeatureGarage] of Característica
    )

    ([FeaturePool] of Característica
    )

    ([FeatureTerrace] of Característica
    )

    ([FeatureViews] of Característica
    )

    ([FeatureYard] of Característica
    )

    ;;; permeten / volen tenir mascotes
    ([petsAllowed] of Característica
    )

)
