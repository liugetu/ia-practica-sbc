;;; ---------------------------------------------------------
;;; ontologia.clp
;;; Translated by owl2clips
;;; Translated to CLIPS from ontology alquileres.ttl
;;; :Date 22/11/2025 13:24:03

(defclass ClientProfile "Tipus de client: jove, famÃ­lia, estudiant, persona gran, etc."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot hasConstraint
        (type INSTANCE)
        (create-accessor read-write))
    (multislot prefers
        (type INSTANCE)
        (create-accessor read-write))
    (multislot minDorms
        (type INTEGER)
        (create-accessor read-write))
    (multislot familySize
        (type INTEGER)
        (create-accessor read-write))
    (multislot minReasonablePrice
        (type INTEGER)
        (create-accessor read-write))
    (multislot minArea
        (type INTEGER)
        (create-accessor read-write))
    (multislot needsDoubleBedroom
        (type SYMBOL)
        (create-accessor read-write))
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

(defclass Property "Component fÃ­sic: caracterÃ­stiques intrÃ­nseques de l'habitatge."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; Relaciona una propietat amb una de les seves habitacions
    (multislot hasRoom
        (type INSTANCE)
        (create-accessor read-write))
    ;;; Relaciona un immoble amb la seva ubicaciÃ³/coordenades
    (multislot locatedAt
        (type INSTANCE)
        (create-accessor read-write))
    (multislot allowsPets
        (type SYMBOL)
        (create-accessor read-write))
    (multislot area
        (type INTEGER)
        (create-accessor read-write))
    (multislot isFurnished
        (type SYMBOL)
        (create-accessor read-write))
    (multislot hasAirOrHeating
        (type SYMBOL)
        (create-accessor read-write))
    (multislot hasAppliances
        (type SYMBOL)
        (create-accessor read-write))
    (multislot naturalLight
        (type INTEGER)
        (create-accessor read-write))
    (multislot hasPool
        (type SYMBOL)
        (create-accessor read-write))
    (multislot hasElevator
        (type SYMBOL)
        (create-accessor read-write))
    (multislot hasTerrace
        (type SYMBOL)
        (create-accessor read-write))
    (multislot hasBalcony
        (type SYMBOL)
        (create-accessor read-write))
    (multislot hasGarage
        (type SYMBOL)
        (create-accessor read-write))
    (multislot hasViews
        (type SYMBOL)
        (create-accessor read-write))
    (multislot address
        (type STRING)
        (create-accessor read-write))
    (multislot state
        (type INTEGER)
        (create-accessor read-write))
    (multislot hasYard
        (type SYMBOL)
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

(defclass Constraint "Tipus de restricciÃ³ estricta que pot descartar ofertes (p. ex. no accepten mascotes)."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass Location "Coordenades i referÃ¨ncies administratives (districte, adreÃ§a)."
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

(defclass Preference "PreferÃ¨ncies i restriccions del client (preu mÃ xim, distÃ ncies, no mascotes...)."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass RecommendationLevel "Etiqueta que indica quina Ã©s la idoneÃ¯tat d'una oferta per a un client."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass RentalOffer "InstÃ ncia que representa una oferta concreta (piso, dÃºplex, casa...)."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; Relaciona un immoble amb una de les seves possibles ofertes de lloguer
    (multislot hasProperty
        (type INSTANCE)
        (create-accessor read-write))
    (multislot recommendedFor
        (type INSTANCE)
        (create-accessor read-write))
    ;;; Ãštil per explicar per quÃ¨ una oferta Ã©s parcialment adequada o no adequada.
    (multislot violatesConstraint
        (type INSTANCE)
        (create-accessor read-write))
    (multislot price
        (type FLOAT)
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
)

(defclass Room "Modela dormitoris (simple/doble) i altres estances si cal."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass Client "Guarda les preferÃ¨ncies/restriccions del client"
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; Relaciona un client amb el seu perfil (grup socioeconomic predeterminat)
    (multislot hasProfile
        (type INSTANCE)
        (create-accessor read-write))
    (multislot clientAge
        (type INTEGER)
        (create-accessor read-write))
    (multislot clientMaxPrice
        (type FLOAT)
        (create-accessor read-write))
    (multislot hasCar
        (type SYMBOL)
        (create-accessor read-write))
    (multislot priceFlexibility
        (type INTEGER)
        (create-accessor read-write))
    (multislot wantsSchool
        (type SYMBOL)
        (create-accessor read-write))
    (multislot prefersElevator
        (type SYMBOL)
        (create-accessor read-write))
    (multislot wantsGreenArea
        (type SYMBOL)
        (create-accessor read-write))
    (multislot prefersTerrace
        (type SYMBOL)
        (create-accessor read-write))
    (multislot prefersViews
        (type SYMBOL)
        (create-accessor read-write))
    (multislot prefersPool
        (type SYMBOL)
        (create-accessor read-write))
    (multislot prefersFurniture
        (type SYMBOL)
        (create-accessor read-write))
    (multislot prefersAppliances
        (type SYMBOL)
        (create-accessor read-write))
    (multislot wantsNightLife
        (type SYMBOL)
        (create-accessor read-write))
    (multislot prefersYard
        (type SYMBOL)
        (create-accessor read-write))
    (multislot wantsStadium
        (type SYMBOL)
        (create-accessor read-write))
    (multislot prefersAirOrHeating
        (type SYMBOL)
        (create-accessor read-write))
    (multislot wantsTransport
        (type SYMBOL)
        (create-accessor read-write))
    (multislot prefersGarage
        (type SYMBOL)
        (create-accessor read-write))
    (multislot prefersBalcony
        (type SYMBOL)
        (create-accessor read-write))
    (multislot wantsHealthCenter
        (type SYMBOL)
        (create-accessor read-write))
)

(defclass Proximity "Classe intermitja que diu la proximitat d'una propietat a un serveri"
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; RelaciÃ³ que s'utilitza quan un servei estÃ  dins d'una distÃ ncia definida (p. ex. <=500 m).
    (multislot nearService
        (type INSTANCE)
        (create-accessor read-write))
    (multislot nearProperty
        (type INSTANCE)
        (create-accessor read-write))
    ;;; Si una Property estÃ  a prop (0), a mitja distÃ ncia (1)
    (multislot distanceCategory
        (type INTEGER)
        (create-accessor read-write))
)

(definstances instances
)
