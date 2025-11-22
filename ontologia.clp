;;; ---------------------------------------------------------
;;; ontologia.clp
;;; Translated by owl2clips
;;; Translated to CLIPS from ontology alquileres.ttl
;;; :Date 22/11/2025 14:03:46

(defclass Constraint "Classe abstracta per representar restriccions estrictes que poden descartar ofertes (p. ex. no accepten mascotes)."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; CaracterÃ­stica que queda obligada o prohibida per la restricciÃ³.
    (multislot restrictsFeature
        (type INSTANCE)
        (create-accessor read-write))
    ;;; Tipus o categoria de la restricciÃ³ declarada.
    (multislot consType
        (type STRING)
        (create-accessor read-write))
    ;;; Valor que s'ha de complir literalment per satisfer la restricciÃ³.
    (multislot requiredValue
        (type STRING)
        (create-accessor read-write))
)

(defclass HardFeatureConstraint "Restringeix caracterÃ­stiques binÃ ries (p. ex. mascotes prohibides, cal ascensor)."
    (is-a Constraint)
    (role concrete)
    (pattern-match reactive)
)

(defclass NumericConstraint "Restriccions algebraiques sobre valors numÃ¨rics (pressupost, superfÃ­cie, places)."
    (is-a Constraint)
    (role concrete)
    (pattern-match reactive)
    ;;; Llindar numÃ¨ric d'una restricciÃ³ (p. ex. preu â¤ 1200).
    (multislot limitValue
        (type FLOAT)
        (create-accessor read-write))
)

(defclass ServiceDistanceConstraint "Exigeix distÃ ncies mÃ ximes a un tipus de servei concret."
    (is-a Constraint)
    (role concrete)
    (pattern-match reactive)
    ;;; Servei al qual s'aplica una restricciÃ³ de distÃ ncia.
    (multislot constrainsService
        (type INSTANCE)
        (create-accessor read-write))
    ;;; DistÃ ncia mÃ xima admissible per a una restricciÃ³ de servei.
    (multislot maxDistanceMeters
        (type FLOAT)
        (create-accessor read-write))
)

(defclass Property "Component fÃ­sic: caracterÃ­stiques intrÃ­nseques de l'habitatge."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; EnllaÃ§a una propietat amb una caracterÃ­stica concreta (piscina, balcÃ³, ascensor...).
    (multislot offersFeature
        (type INSTANCE)
        (create-accessor read-write))
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

(defclass Preference "Condicions toves que orienten la recomanaciÃ³ (pressupost desitjat, caracterÃ­stiques valorades, proximitat)."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; Categoria textual de la preferÃ¨ncia (piscina, pressupost, transport...).
    (multislot prefType
        (type STRING)
        (create-accessor read-write))
    ;;; Valor objectiu expressat pel client (p. ex. 'si', 'mÃ­n. 3', 'menys de 950').
    (multislot prefValue
        (type STRING)
        (create-accessor read-write))
    ;;; ImportÃ ncia relativa (0-1 o percentatge) d'una preferÃ¨ncia.
    (multislot preferenceWeight
        (type FLOAT)
        (create-accessor read-write))
    ;;; Unitat utilitzada per interpretar el valor (EUR, m2, minuts...).
    (multislot prefUnit
        (type STRING)
        (create-accessor read-write))
    ;;; Indica si la preferÃ¨ncia s'hauria de tractar gairebÃ© com una restricciÃ³.
    (multislot isHardPreference
        (type SYMBOL)
        (create-accessor read-write))
)

(defclass FeaturePreference "PreferÃ¨ncies sobre caracterÃ­stiques de l'immoble (piscina, balcÃ³, ascensor, etc.)."
    (is-a Preference)
    (role concrete)
    (pattern-match reactive)
    ;;; Indica quina caracterÃ­stica concreta avalua una preferÃ¨ncia.
    (multislot appliesToFeature
        (type INSTANCE)
        (create-accessor read-write))
)

(defclass NumericPreference "PreferÃ¨ncies que involucren un valor numÃ¨ric (pressupost, m2 mÃ­nims, distÃ ncies concretes)."
    (is-a Preference)
    (role concrete)
    (pattern-match reactive)
    ;;; Valor numÃ¨ric objectiu d'una preferÃ¨ncia (p. ex. lloguer mÃ xim).
    (multislot numericTarget
        (type FLOAT)
        (create-accessor read-write))
)

(defclass ServiceProximityPreference "PreferÃ¨ncies relatives a la distÃ ncia respecte a un servei o punt d'interÃ¨s."
    (is-a Preference)
    (role concrete)
    (pattern-match reactive)
    ;;; Servei o punt d'interÃ¨s sobre el qual s'expressa una preferÃ¨ncia de distÃ ncia.
    (multislot targetsService
        (type INSTANCE)
        (create-accessor read-write))
    ;;; Categoria esperada (p. ex. proper, mitjÃ , lluny).
    (multislot preferredDistanceCategory
        (type STRING)
        (create-accessor read-write))
    ;;; DistÃ ncia mÃ xima o ideal expressada en metres.
    (multislot preferredDistanceMeters
        (type FLOAT)
        (create-accessor read-write))
)

(defclass ClientProfile "Tipus de client: jove, famÃ­lia, estudiant, persona gran, etc."
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

(defclass Student
    (is-a ClientProfile)
    (role concrete)
    (pattern-match reactive)
)

(defclass YoungAdult
    (is-a ClientProfile)
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

(defclass PropertyFeature "CaracterÃ­stiques observables de la propietat utilitzades a les recomanacions (piscina, ascensor, terrassa, etc.)."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass Recommendation "Entitat que explica la relaciÃ³ oferta-client, amb justificacions i nivell de qualitat."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; Oferta concreta que avalua aquesta recomanaciÃ³.
    (multislot recommendedOffer
        (type INSTANCE)
        (create-accessor read-write))
    ;;; Client destinatari d'una recomanaciÃ³ concreta.
    (multislot recommendedFor
        (type INSTANCE)
        (create-accessor read-write))
    ;;; Explica quines preferÃ¨ncies es consideren cobertes per la recomanaciÃ³.
    (multislot satisfiesPreference
        (type INSTANCE)
        (create-accessor read-write))
    ;;; Justifica quines restriccions no satisfÃ  una recomanaciÃ³ concreta.
    (multislot violatesConstraint
        (type INSTANCE)
        (create-accessor read-write))
    ;;; Etiqueta qualitativa (p. ex. molt recomanable, adequada, parcial).
    (multislot recommendationLevel
        (type STRING)
        (create-accessor read-write))
)

(defclass RentalOffer "InstÃ ncia que representa una oferta concreta (piso, dÃºplex, casa...)."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; Relaciona un immoble amb una de les seves possibles ofertes de lloguer
    (multislot hasProperty
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

(defclass Client "Individu que encapsula dades personals i es relaciona amb preferÃ¨ncies i restriccions estructurades."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; Relaciona un client amb les restriccions estrictes que ha declarat.
    (multislot hasConstraint
        (type INSTANCE)
        (create-accessor read-write))
    ;;; Resum de les preferÃ¨ncies declarades per un client en forma d'objectes reutilitzables.
    (multislot hasPreference
        (type INSTANCE)
        (create-accessor read-write))
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

(defclass ProximityRelation "Classe intermitja que diu la proximitat d'una propietat a un serveri"
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
