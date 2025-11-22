;;; ---------------------------------------------------------
;;; ontologia.clp
;;; Translated by owl2clips
;;; Translated to CLIPS from ontology alquileres.ttl
;;; :Date 22/11/2025 12:08:04

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
    (multislot allowsPets
        (type SYMBOL)
        (create-accessor read-write))
    (multislot area
        (type INTEGER)
        (create-accessor read-write))
    (multislot isFurnished
        (type SYMBOL)
        (create-accessor read-write))
    (multislot R1O0pLg0VGSnWZT6dgJpRV
        (type SYMBOL)
        (create-accessor read-write))
    (multislot R1SFCCuCpn6muLxyHnX8u8
        (type SYMBOL)
        (create-accessor read-write))
    (multislot R74VPorJymDh21w9Y2Kp1kP
        (type INTEGER)
        (create-accessor read-write))
    (multislot R7atn1wTPkXSHzsOpUG5ikh
        (type SYMBOL)
        (create-accessor read-write))
    (multislot R7uxQflJSq5NnYcyxSDxic2
        (type SYMBOL)
        (create-accessor read-write))
    (multislot R8mTFlPLyTVgpskPUI82zsX
        (type SYMBOL)
        (create-accessor read-write))
    (multislot R8tBBBYTGa9KATVMBd5yOt
        (type SYMBOL)
        (create-accessor read-write))
    (multislot R9Hj1Il7UdYCOuzMzbRh7hE
        (type SYMBOL)
        (create-accessor read-write))
    (multislot R9UCzIEHEnc18VZEiD9ioO2
        (type SYMBOL)
        (create-accessor read-write))
    (multislot RE2i5hP4gk8l5PVT4f3mgM
        (type STRING)
        (create-accessor read-write))
    (multislot RJpPp7bhsimEuNBAKo8Gst
        (type INTEGER)
        (create-accessor read-write))
    (multislot RZwZ0HTVDxD9O692xosHQQ
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

(defclass ClientProfile "Tipus de client: jove, família, estudiant, persona gran, etc."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot hasConstraint
        (type INSTANCE)
        (create-accessor read-write))
    (multislot prefers
        (type INSTANCE)
        (create-accessor read-write))
    (multislot R8H0zmLKMYr8BIhs8BmFbuf
        (type INTEGER)
        (create-accessor read-write))
    (multislot RBN03MKzvambdcNjlzLit8C
        (type INTEGER)
        (create-accessor read-write))
    (multislot RBypvi3ljAynVOtLEHiaEX6
        (type INTEGER)
        (create-accessor read-write))
    (multislot RCZ03zoqNVp23sEgKFiUtcH
        (type INTEGER)
        (create-accessor read-write))
    (multislot RPPNEfX6hM6UrM2UvBnO9k
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

(defclass Service "Transport, supermercat, escola, centre de salut, oci, etc."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot RDH5py9aOAunrA54HMTGzDM
        (type STRING)
        (create-accessor read-write))
    (multislot RWgtkrUcFXaRw5NYWMnl8I
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

(defclass Constraint "Tipus de restricció estricta que pot descartar ofertes (p. ex. no accepten mascotes)."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
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

(defclass Preference "Preferències i restriccions del client (preu màxim, distàncies, no mascotes...)."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass RecommendationLevel "Etiqueta que indica quina és la idoneïtat d'una oferta per a un client."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass RentalOffer "Instància que representa una oferta concreta (piso, dúplex, casa...)."
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
    ;;; Útil per explicar per què una oferta és parcialment adequada o no adequada.
    (multislot violatesConstraint
        (type INSTANCE)
        (create-accessor read-write))
    (multislot price
        (type FLOAT)
        (create-accessor read-write))
    (multislot R9SrozSgOLgl64XI1p05TML
        (type INTEGER)
        (create-accessor read-write))
    (multislot R9hchd1x0gTGhRpVs5TMxQH
        (type INTEGER)
        (create-accessor read-write))
    (multislot R9yc3P8FYkA6CJy07xeVBXr
        (type SYMBOL)
        (create-accessor read-write))
)

(defclass Room "Modela dormitoris (simple/doble) i altres estances si cal."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass R154PFFqJYFAEr8iYDocvg "Guarda les preferències/restriccions del client"
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; Relaciona un client amb el seu perfil (grup socioeconomic predeterminat)
    (multislot R8GC3Vc2gAI9zunWXNS1a06
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
    (multislot R7iUDD6v7D1A3QvfnM4cxAW
        (type SYMBOL)
        (create-accessor read-write))
    (multislot R8vo6JFtBbc0OiPHh98cSMe
        (type SYMBOL)
        (create-accessor read-write))
    (multislot R95QuLN9I1tqczHNkrkU6X
        (type SYMBOL)
        (create-accessor read-write))
    (multislot R9DFsnqEP13TgPLhirAB1ig
        (type SYMBOL)
        (create-accessor read-write))
    (multislot R9FEZeal3K764LtyjN8qaK7
        (type SYMBOL)
        (create-accessor read-write))
    (multislot R9qasDsciMvFuV9PXx1YyVg
        (type SYMBOL)
        (create-accessor read-write))
    (multislot RBg7kLV7CizPPpX6PSztHZy
        (type SYMBOL)
        (create-accessor read-write))
    (multislot RBmzu3L0a7ztxy1ryKPPRyn
        (type SYMBOL)
        (create-accessor read-write))
    (multislot RBqbmP02LngAqxpU21Tq9D5
        (type SYMBOL)
        (create-accessor read-write))
    (multislot RC6LV0sZHQJLFH82D6zcHrq
        (type SYMBOL)
        (create-accessor read-write))
    (multislot RC963HwFvkt6jLFDzbFLHh
        (type SYMBOL)
        (create-accessor read-write))
    (multislot RCForDBQVOumYshYwxZR5Mn
        (type SYMBOL)
        (create-accessor read-write))
    (multislot RDQY44OouocHsJDGvIdgnHL
        (type SYMBOL)
        (create-accessor read-write))
    (multislot RDrmU0N39Stbvq9rmm3Vpw6
        (type SYMBOL)
        (create-accessor read-write))
    (multislot RiTxNKLzSNDKbsh5bmofi8
        (type SYMBOL)
        (create-accessor read-write))
    (multislot RjwVL4JX3QUXblBKuwu32F
        (type SYMBOL)
        (create-accessor read-write))
)

(defclass RC91CrVmvTDZT8W6IfBONlP "Classe intermitja que diu la proximitat d'una propietat a un serveri"
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; Relació que s'utilitza quan un servei està dins d'una distància definida (p. ex. <=500 m).
    (multislot nearService
        (type INSTANCE)
        (create-accessor read-write))
    (multislot RDinkzM0Mob3iMujWO3SacC
        (type INSTANCE)
        (create-accessor read-write))
    ;;; Si una Property està a prop (0), a mitja distància (1)
    (multislot RBdHYuoZjfZ9Es7NSPA5L5D
        (type INTEGER)
        (create-accessor read-write))
)

(definstances instances
)
