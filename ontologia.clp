;;; ---------------------------------------------------------
;;; ontologia.clp
;;; Translated by owl2clips
;;; Translated to CLIPS from ontology alquileres.ttl
;;; :Date 28/11/2025 10:54:33

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
)

(defclass Students
    (is-a ClientProfile)
    (role concrete)
    (pattern-match reactive)
)

(defclass YoungAdult
    (is-a ClientProfile)
    (role concrete)
    (pattern-match reactive)
)

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
    (multislot allowsPets
        (type SYMBOL)
        (create-accessor read-write))
    (multislot area
        (type INTEGER)
        (create-accessor read-write))
    (multislot naturalLight
        (type INTEGER)
        (create-accessor read-write))
    (multislot state
        (type INTEGER)
        (create-accessor read-write))
)

(defclass Apartment
    (is-a Property)
    (role concrete)
    (pattern-match reactive)
    (multislot floor
        (type STRING)
        (create-accessor read-write))
)

(defclass Duplex
    (is-a Property)
    (role concrete)
    (pattern-match reactive)
    (multislot floor
        (type STRING)
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
    (multislot clientAge
        (type INTEGER)
        (create-accessor read-write))
    (multislot clientMaxPrice
        (type FLOAT)
        (create-accessor read-write))
    (multislot familySize
        (type INTEGER)
        (create-accessor read-write))
    (multislot hasCar
        (type SYMBOL)
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
    (multislot wantsTransport
        (type SYMBOL)
        (create-accessor read-write))
)

(defclass Location "Coordenades i referències administratives (districte, adreça)."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot latitude
        (type FLOAT)
        (create-accessor read-write))
    (multislot longitude
        (type FLOAT)
        (create-accessor read-write))
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
    ;;; Si una Property està a prop (0), a mitja distància (1)
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
    ;;; Relaciona un immoble amb una de les seves possibles ofertes de lloguer
    (multislot hasProperty
        (type INSTANCE)
        (create-accessor read-write))
    ;;; Útil per explicar per què una oferta és parcialment adequada o no adequada.
    (multislot violatesConstraint
        (type INSTANCE)
        (create-accessor read-write))
    ;;; La propietat té la característica
    (multislot hasFeature
        (type INSTANCE)
        (create-accessor read-write))
    (multislot maxPeople
        (type INTEGER)
        (create-accessor read-write))
    (multislot minMonths
        (type INTEGER)
        (create-accessor read-write))
    (multislot petsAllowed
        (type SYMBOL)
        (create-accessor read-write))
    (multislot price
        (type FLOAT)
        (create-accessor read-write))
)

(defclass Room "Modela dormitoris (simple/doble) i altres estances si cal."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass PropertyFeature "Defineix les possibles característiques d'una propietat"
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(definstances instances
    ([FeatureTerrace] of Característica
    )

    ([FeatureViews] of Característica
    )

    ([FeatureGarage] of Característica
    )

    ([FeaturePool] of Característica
    )

    ([FeatureAppliances] of Característica
    )

    ([FeatureYard] of Característica
    )

    ([FeatureFurniture] of Característica
    )

    ([FeatureBalcony] of Característica
    )

    ([FeatureAirOrHeating] of Característica
    )

    ([FeatureElevator] of Característica
    )

)
