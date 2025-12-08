;;; ---------------------------------------------------------
;;; exe3.clp
;;; Script per afegir nous clients amb tots els camps necessaris
;;; Utilitza la base de vivendes.clp com a reference de propietats
;;; ---------------------------------------------------------

;;; Load the ontology (class definitions)
(load "ontologia.clp")

;;; Load the vivendes database
(load "vivendes.clp")

;;; Load the expert system rules
(load "expert.clp")

;;; Reset and prepare the system
(reset)
(run)

;;; ---------------------------------------------------------
;;; FUNCTIONS FOR CLIENT INPUT
;;; ---------------------------------------------------------

;;; Function to read and validate integer input
(deffunction read-integer (?min ?max ?prompt)
   (bind ?value FALSE)
   (while (not (and (integerp ?value) (>= ?value ?min) (<= ?value ?max)))
      (printout t ?prompt " (o 'cancelar' per avortar): ")
      (bind ?value (read))
      (if (eq ?value cancelar) then
         (return cancelar))
      (if (or (not (integerp ?value)) (< ?value ?min) (> ?value ?max)) then
         (printout t "ERROR: Valor no vàlid. Entra un número entre " ?min " i " ?max "." crlf))
   )
   (return ?value)
)

;;; Function to read integer without range restrictions
(deffunction read-integer-free (?prompt)
   (bind ?value FALSE)
   (while (not (integerp ?value))
      (printout t ?prompt " (o 'cancelar' per avortar): ")
      (bind ?value (read))
      (if (eq ?value cancelar) then
         (return cancelar))
      (if (not (integerp ?value)) then
         (printout t "ERROR: Has d'entrar un número enter." crlf))
   )
   (return ?value)
)

;;; Function to read and validate float input
(deffunction read-float (?min ?max ?prompt)
   (bind ?value FALSE)
   (while (not (and (numberp ?value) (>= ?value ?min) (<= ?value ?max)))
      (printout t ?prompt " (o 'cancelar' per avortar): ")
      (bind ?value (read))
      (if (eq ?value cancelar) then
         (return cancelar))
      (if (or (not (numberp ?value)) (< ?value ?min) (> ?value ?max)) then
         (printout t "ERROR: Valor no vàlid. Entra un número entre " ?min " i " ?max "." crlf))
   )
   (return (float ?value))
)

;;; Function to read float without range restrictions
(deffunction read-float-free (?prompt)
   (bind ?value FALSE)
   (while (not (numberp ?value))
      (printout t ?prompt " (o 'cancelar' per avortar): ")
      (bind ?value (read))
      (if (eq ?value cancelar) then
         (return cancelar))
      (if (not (numberp ?value)) then
         (printout t "ERROR: Has d'entrar un número." crlf))
   )
   (return (float ?value))
)

;;; Function to read SI/NO answer
(deffunction read-si-no (?prompt)
   (bind ?value FALSE)
   (while (not (or (eq ?value si) (eq ?value no)))
      (printout t ?prompt " (si/no o 'cancelar'): ")
      (bind ?value (read))
      (if (eq ?value cancelar) then
         (return cancelar))
      (if (not (or (eq ?value si) (eq ?value no))) then
         (printout t "ERROR: Respon amb 'si' o 'no'." crlf))
   )
   (return ?value)
)

;;; Function to get client profile
(deffunction get-client-profile ()
   (printout t crlf "=== SELECCIONA EL PERFIL DEL CLIENT ===" crlf)
   (printout t "1. Parella jove" crlf)
   (printout t "2. Família" crlf)
   (printout t "3. Estudiant" crlf)
   (printout t "4. Persona gran" crlf)
   (printout t "5. Jove adult solter" crlf)
   (bind ?opcio (read-integer 1 5 "Selecciona el perfil (1-5)"))
   
   (if (eq ?opcio cancelar) then
      (return cancelar))
   
   (switch ?opcio
      (case 1 then (return Couple))
      (case 2 then (return Family))
      (case 3 then (return Student))
      (case 4 then (return Elderly))
      (case 5 then (return Individual))
   )
)

;;; Function to select features from a list
(deffunction select-features ()
   (bind ?features (create$))
   (bind ?continue TRUE)
   
   (while ?continue
      (printout t crlf "=== CARACTERISTIQUES PREFERIDES ===" crlf)
      (printout t "1. Ascensor" crlf)
      (printout t "2. Balcó" crlf)
      (printout t "3. Terrassa" crlf)
      (printout t "4. Aire/Calefacció" crlf)
      (printout t "5. Mobles" crlf)
      (printout t "6. Electrodomèstics" crlf)
      (printout t "7. Garatge" crlf)
      (printout t "8. Pati/Jardí" crlf)
      (printout t "9. Vistes" crlf)
      (printout t "10. Piscina" crlf)
      (printout t "11. Mascotes permeses" crlf)
      (printout t "0. Finalitzar selecció" crlf)
      (bind ?opcio (read-integer 0 11 "Selecciona una característica (0 per acabar)"))
      
      (if (eq ?opcio cancelar) then
         (return cancelar))
      
      (switch ?opcio
         (case 1 then (bind ?features (create$ ?features [FeatureElevator])))
         (case 2 then (bind ?features (create$ ?features [FeatureBalcony])))
         (case 3 then (bind ?features (create$ ?features [FeatureTerrace])))
         (case 4 then (bind ?features (create$ ?features [FeatureAirOrHeating])))
         (case 5 then (bind ?features (create$ ?features [FeatureFurniture])))
         (case 6 then (bind ?features (create$ ?features [FeatureAppliances])))
         (case 7 then (bind ?features (create$ ?features [FeatureGarage])))
         (case 8 then (bind ?features (create$ ?features [FeatureYard])))
         (case 9 then (bind ?features (create$ ?features [FeatureViews])))
         (case 10 then (bind ?features (create$ ?features [FeaturePool])))
         (case 11 then (bind ?features (create$ ?features [FeaturePetsAllowed])))
         (case 0 then (bind ?continue FALSE))
      )
   )
   
   (return ?features)
)

;;; Function to display all clients
(deffunction mostrar-tots-clients ()
   (printout t crlf crlf)
   (printout t "========================================" crlf)
   (printout t "   LLISTA DE TOTS ELS CLIENTS          " crlf)
   (printout t "========================================" crlf crlf)
   
   (bind ?count 0)
   (do-for-all-instances ((?c Client)) TRUE
      (bind ?count (+ ?count 1))
      (bind ?edat (nth$ 1 (send ?c get-clientAge)))
      (bind ?preu (nth$ 1 (send ?c get-clientMaxPrice)))
      (bind ?nom-inst (instance-name ?c))
      (printout t ?count ". " ?nom-inst crlf)
      (printout t "   Edat: " ?edat ", Pressupost: " ?preu "€/mes" crlf)
   )
   
   (if (= ?count 0) then
      (printout t "No hi ha clients al sistema." crlf)
   else
      (printout t crlf "Total: " ?count " clients" crlf)
   )
   
   (printout t "========================================" crlf crlf)
)

;;; Function to display all rental offers
(deffunction mostrar-totes-ofertes ()
   (printout t crlf crlf)
   (printout t "========================================" crlf)
   (printout t "   LLISTA DE TOTES LES OFERTES         " crlf)
   (printout t "========================================" crlf crlf)
   
   (bind ?count 0)
   (do-for-all-instances ((?o RentalOffer)) TRUE
      (bind ?count (+ ?count 1))
      (bind ?prop-list (send ?o get-hasProperty))
      (if (> (length$ ?prop-list) 0) then
         (bind ?prop-obj (instance-address (nth$ 1 ?prop-list)))
         (if (neq ?prop-obj FALSE) then
            (bind ?adreca (nth$ 1 (send ?prop-obj get-address)))
            (bind ?preu (nth$ 1 (send ?o get-price)))
            (printout t ?count ". " (instance-name ?o) crlf)
            (printout t "   Adreça: " ?adreca crlf)
            (printout t "   Preu: " ?preu "€/mes" crlf)
         )
      )
   )
   
   (if (= ?count 0) then
      (printout t "No hi ha ofertes al sistema." crlf)
   else
      (printout t crlf "Total: " ?count " ofertes" crlf)
   )
   
   (printout t "========================================" crlf crlf)
)

;;; Function to add a new client with all fields
(deffunction afegir-client-nou ()
   (printout t crlf crlf)
   (printout t "========================================" crlf)
   (printout t "   FORMULARI D'ALTA DE NOU CLIENT       " crlf)
   (printout t "========================================" crlf crlf)
   (printout t "Pots cancelar en qualsevol moment escrivint 'cancelar'" crlf crlf)
   
   ;; Read client name
   (printout t "Nom del client (o 'cancelar' per avortar): ")
   (bind ?nom (read))
   (if (eq ?nom cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   ;; Use the client name as instance name (add prefix to ensure valid symbol)
   (bind ?nom-instance (sym-cat client- ?nom))
   
   ;; Read age
   (bind ?edat (read-integer-free "Edat del client"))
   (if (eq ?edat cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Read family size
   (bind ?tamany-familia (read-integer-free "Nombre de membres de la família"))
   (if (eq ?tamany-familia cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Read maximum price
   (bind ?preu-max (read-float-free "Preu màxim mensual en €"))
   (if (eq ?preu-max cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Read price flexibility
   (bind ?flexibilitat (read-integer-free "Flexibilitat de preu en %"))
   (if (eq ?flexibilitat cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Read minimum area
   (bind ?min-area (read-integer-free "Superfície mínima en m²"))
   (if (eq ?min-area cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Read minimum dormitories
   (bind ?min-dorms (read-integer-free "Dormitoris mínims"))
   (if (eq ?min-dorms cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Read minimum reasonable price
   (bind ?preu-reasonable (read-integer-free "Preu raonable mínim en €"))
   (if (eq ?preu-reasonable cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Read if needs double bedroom
   (bind ?necessita-doble (read-si-no "Necessita dormitori doble"))
   (if (eq ?necessita-doble cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Read profile
   (bind ?perfil-type (get-client-profile))
   (if (eq ?perfil-type cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   (bind ?perfil-instance (gensym*))
   
   ;; Create profile instance
   (make-instance ?perfil-instance of ?perfil-type)
   
   ;; Read service preferences
   (bind ?vol-verdes (read-si-no "Vol zones verdes properes"))
   (if (eq ?vol-verdes cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   (bind ?vol-salut (read-si-no "Vol centre de salut proper"))
   (if (eq ?vol-salut cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   (bind ?vol-transport (read-si-no "Vol transport públic proper"))
   (if (eq ?vol-transport cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   (bind ?vol-super (read-si-no "Vol supermercat proper"))
   (if (eq ?vol-super cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   (bind ?vol-escola (read-si-no "Vol escola propera"))
   (if (eq ?vol-escola cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   (bind ?vol-nit (read-si-no "Vol vida nocturna propera"))
   (if (eq ?vol-nit cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   (bind ?vol-estadi (read-si-no "Vol estadi esportiu proper"))
   (if (eq ?vol-estadi cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Read feature preferences
   (bind ?features-preferides (select-features))
   (if (eq ?features-preferides cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Read minimum months
   (bind ?min-mesos (read-integer-free "Durada mínima de lloguer en mesos"))
   (if (eq ?min-mesos cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Create the client instance
   (make-instance ?nom-instance of Client
      (clientAge ?edat)
      (clientMaxPrice ?preu-max)
      (familySize ?tamany-familia)
      (minArea ?min-area)
      (minDorms ?min-dorms)
      (minReasonablePrice ?preu-reasonable)
      (needsDoubleBedroom ?necessita-doble)
      (priceFlexibility ?flexibilitat)
      (wantsGreenArea ?vol-verdes)
      (wantsHealthCenter ?vol-salut)
      (wantsTransport ?vol-transport)
      (wantsSupermarket ?vol-super)
      (wantsSchool ?vol-escola)
      (wantsNightLife ?vol-nit)
      (wantsStadium ?vol-estadi)
      (minMonthsClient ?min-mesos)
      (hasProfile ?perfil-instance)
      (prefersFeature ?features-preferides)
   )
   
   ;; Display confirmation
   (printout t crlf crlf)
   (printout t "========================================" crlf)
   (printout t "CLIENT AFEGIT CORRECTAMENT" crlf)
   (printout t "========================================" crlf)
   (printout t "Nom: " ?nom crlf)
   (printout t "Instància: " ?nom-instance crlf)
   (printout t "Edat: " ?edat " anys" crlf)
   (printout t "Pressupost: " ?preu-max "€/mes (+/-" ?flexibilitat "%)" crlf)
   (printout t "Superfície mínima: " ?min-area " m²" crlf)
   (printout t "Dormitoris mínims: " ?min-dorms crlf)
   (printout t "Durada: " ?min-mesos " mesos mín." crlf)
   (if (> (length$ ?features-preferides) 0) then
      (printout t "Característiques preferides: " ?features-preferides crlf)
   )
   (printout t "========================================" crlf crlf)
   
   ;; Generate recommendations for the new client
   (printout t "Generant recomanacions per al nou client..." crlf crlf)
   
   ;; Run the expert system to generate recommendations (without reset to preserve existing data)
   (run)
   
   (printout t "Recomanacions generades!" crlf)
   (printout t "Utilitza l'opció 5 del menú per veure les ofertes recomanades." crlf crlf)
   
   (return ?nom-instance)
)

;;; Function to select a property from a list
(deffunction seleccionar-propietat ()
   ;; Collect all properties
   (bind ?properties (create$))
   (do-for-all-instances ((?p Property)) TRUE
      (bind ?properties (create$ ?properties (instance-name ?p))))
   
   (if (= (length$ ?properties) 0) then
      (printout t "ERROR: No hi ha propietats al sistema." crlf)
      (return FALSE))
   
   ;; Display menu
   (printout t crlf "=== SELECCIONA UNA PROPIETAT ===" crlf)
   (bind ?i 1)
   (foreach ?prop ?properties
      (bind ?prop-obj (instance-address ?prop))
      (if (neq ?prop-obj FALSE) then
         (bind ?adreca (nth$ 1 (send ?prop-obj get-address)))
         (printout t ?i ". " ?prop " - " ?adreca crlf)
      )
      (bind ?i (+ ?i 1)))
   (printout t crlf "Selecciona el número de la propietat (1-" (length$ ?properties) ") o 'cancelar': ")
   
   ;; Read selection
   (bind ?seleccio (read))
   
   (if (eq ?seleccio cancelar) then
      (return FALSE))
   
   ;; Validate selection
   (if (or (not (integerp ?seleccio))
           (< ?seleccio 1)
           (> ?seleccio (length$ ?properties))) then
      (printout t "ERROR: Selecció no vàlida." crlf)
      (return FALSE))
   
   ;; Return selected property
   (return (nth$ ?seleccio ?properties))
)

;;; Function to create a new location
(deffunction crear-localitzacio ()
   (printout t crlf "=== CREAR NOVA LOCALITZACIÓ ===" crlf)
   
   ;; Read latitude
   (bind ?lat (read-float 41.0 42.0 "Latitud (41.0-42.0)"))
   (if (eq ?lat cancelar) then
      (return FALSE))
   
   ;; Read longitude
   (bind ?lon (read-float 2.0 3.0 "Longitud (2.0-3.0)"))
   (if (eq ?lon cancelar) then
      (return FALSE))
   
   ;; Create location instance
   (bind ?loc-instance (gensym*))
   (make-instance ?loc-instance of Location
      (latitude ?lat)
      (longitude ?lon))
   
   (printout t "Localització creada: " ?loc-instance crlf)
   (return ?loc-instance)
)

;;; Function to create rooms for a property
(deffunction crear-habitacions ()
   (bind ?habitacions (create$))
   
   (bind ?num-dorms (read-integer-free "Nombre de dormitoris"))
   (if (eq ?num-dorms cancelar) then
      (return FALSE))
   
   (loop-for-count (?i 1 ?num-dorms) do
      (bind ?es-doble (read-si-no (str-cat "La habitació " ?i " és doble")))
      (if (eq ?es-doble cancelar) then
         (return FALSE))
      
      (bind ?room-instance (gensym*))
      (make-instance ?room-instance of Room
         (isDouble (if (eq ?es-doble si) then TRUE else FALSE)))
      
      (bind ?habitacions (create$ ?habitacions ?room-instance))
   )
   
   (printout t "Habitacions creades: " ?habitacions crlf)
   (return ?habitacions)
)

;;; Function to create a new property
(deffunction crear-propietat ()
   (printout t crlf "=== CREAR NOVA PROPIETAT ===" crlf)
   
   ;; Read property name
   (printout t "Nom de la propietat (o 'cancelar'): ")
   (bind ?nom-prop (read))
   (if (eq ?nom-prop cancelar) then
      (return FALSE))
   (bind ?prop-instance (sym-cat viv- ?nom-prop))
   
   ;; Select property type
   (printout t crlf "=== TIPUS DE PROPIETAT ===" crlf)
   (printout t "1. Pis (Apartment)" crlf)
   (printout t "2. Casa (House)" crlf)
   (printout t "3. Duplex" crlf)
   (bind ?tipus (read-integer 1 3 "Selecciona el tipus (1-3)"))
   (if (eq ?tipus cancelar) then
      (return FALSE))
   
   ;; Read address
   (printout t "Adreça de la propietat (o 'cancelar'): ")
   (bind ?adreca (read))
   (if (eq ?adreca cancelar) then
      (return FALSE))
   
   ;; Read area
   (bind ?area (read-integer-free "Superfície en m²"))
   (if (eq ?area cancelar) then
      (return FALSE))
   
   ;; Create location
   (bind ?localitzacio (crear-localitzacio))
   (if (eq ?localitzacio FALSE) then
      (return FALSE))
   
   ;; Create rooms
   (bind ?habitacions (crear-habitacions))
   (if (eq ?habitacions FALSE) then
      (return FALSE))
   
   ;; Read additional attributes
   (bind ?llum-natural (read-integer 0 3 "Llum natural (0-3)"))
   (if (eq ?llum-natural cancelar) then
      (return FALSE))
   
   (bind ?estat (read-integer 1 5 "Estat de conservació (1-5)"))
   (if (eq ?estat cancelar) then
      (return FALSE))
   
   (bind ?ocupes (read-si-no "Té ocupes"))
   (if (eq ?ocupes cancelar) then
      (return FALSE))
   
   (bind ?humitats (read-si-no "Té humitats"))
   (if (eq ?humitats cancelar) then
      (return FALSE))
   
   (bind ?fugues (read-si-no "Té fugues"))
   (if (eq ?fugues cancelar) then
      (return FALSE))
   
   ;; Create property based on type
   (switch ?tipus
      (case 1 then
         ;; Apartment
         (bind ?planta (read-integer-free "Planta"))
         (if (eq ?planta cancelar) then
            (return FALSE))
         (make-instance ?prop-instance of Apartment
            (address ?adreca)
            (area ?area)
            (locatedAt ?localitzacio)
            (hasRoom ?habitacions)
            (naturalLight ?llum-natural)
            (state ?estat)
            (hasSquatters (if (eq ?ocupes si) then TRUE else FALSE))
            (hasDampness (if (eq ?humitats si) then TRUE else FALSE))
            (hasLeaks (if (eq ?fugues si) then TRUE else FALSE))
            (floor ?planta)))
      (case 2 then
         ;; House
         (make-instance ?prop-instance of House
            (address ?adreca)
            (area ?area)
            (locatedAt ?localitzacio)
            (hasRoom ?habitacions)
            (naturalLight ?llum-natural)
            (state ?estat)
            (hasSquatters (if (eq ?ocupes si) then TRUE else FALSE))
            (hasDampness (if (eq ?humitats si) then TRUE else FALSE))
            (hasLeaks (if (eq ?fugues si) then TRUE else FALSE))))
      (case 3 then
         ;; Duplex
         (bind ?planta (read-integer-free "Planta inicial"))
         (if (eq ?planta cancelar) then
            (return FALSE))
         (make-instance ?prop-instance of Duplex
            (address ?adreca)
            (area ?area)
            (locatedAt ?localitzacio)
            (hasRoom ?habitacions)
            (naturalLight ?llum-natural)
            (state ?estat)
            (hasSquatters (if (eq ?ocupes si) then TRUE else FALSE))
            (hasDampness (if (eq ?humitats si) then TRUE else FALSE))
            (hasLeaks (if (eq ?fugues si) then TRUE else FALSE))
            (floor ?planta)))
   )
   
   (printout t crlf "Propietat creada correctament: " ?prop-instance crlf)
   (return ?prop-instance)
)

;;; Function to add a new rental offer
(deffunction afegir-oferta-nova ()
   (printout t crlf crlf)
   (printout t "========================================" crlf)
   (printout t "   FORMULARI D'ALTA DE NOVA OFERTA      " crlf)
   (printout t "========================================" crlf crlf)
   (printout t "Pots cancelar en qualsevol moment escrivint 'cancelar'" crlf crlf)
   
   ;; Read offer name
   (printout t "Nom de l'oferta (o 'cancelar' per avortar): ")
   (bind ?nom (read))
   (if (eq ?nom cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   (bind ?nom-instance (sym-cat oferta- ?nom))
   
   ;; Ask if creating new property or selecting existing
   (printout t crlf "Vols crear una nova propietat o seleccionar-ne una existent?" crlf)
   (printout t "1. Crear nova propietat" crlf)
   (printout t "2. Seleccionar propietat existent" crlf)
   (bind ?opcio-prop (read-integer 1 2 "Selecciona opció (1-2)"))
   (if (eq ?opcio-prop cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Get or create property
   (if (= ?opcio-prop 1) then
      (bind ?propietat (crear-propietat))
      (if (eq ?propietat FALSE) then
         (printout t crlf "Operació cancel·lada." crlf crlf)
         (return FALSE))
   else
      (bind ?propietat (seleccionar-propietat))
      (if (eq ?propietat FALSE) then
         (printout t crlf "Operació cancel·lada." crlf crlf)
         (return FALSE))
   )
   
   ;; Read price
   (bind ?preu (read-float-free "Preu mensual en €"))
   (if (eq ?preu cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Read max people
   (bind ?max-persones (read-integer-free "Número màxim de persones"))
   (if (eq ?max-persones cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Read minimum months
   (bind ?min-mesos (read-integer-free "Durada mínima del contracte en mesos"))
   (if (eq ?min-mesos cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Select features
   (printout t crlf "Selecciona les característiques de l'oferta:" crlf)
   (bind ?features (select-features))
   (if (eq ?features cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Create the rental offer instance
   (make-instance ?nom-instance of RentalOffer
      (hasProperty ?propietat)
      (price ?preu)
      (maxPeople ?max-persones)
      (minMonths ?min-mesos)
      (hasFeature ?features)
   )
   
   ;; Display confirmation
   (printout t crlf crlf)
   (printout t "========================================" crlf)
   (printout t "OFERTA AFEGIDA CORRECTAMENT" crlf)
   (printout t "========================================" crlf)
   (printout t "Nom: " ?nom crlf)
   (printout t "Instància: " ?nom-instance crlf)
   (printout t "Propietat: " ?propietat crlf)
   (printout t "Preu: " ?preu "€/mes" crlf)
   (printout t "Persones màximes: " ?max-persones crlf)
   (printout t "Durada mínima: " ?min-mesos " mesos" crlf)
   (if (> (length$ ?features) 0) then
      (printout t "Característiques: " ?features crlf)
   )
   (printout t "========================================" crlf crlf)
   
   ;; Generate recommendations with the new offer
   (printout t "Generant recomanacions amb la nova oferta..." crlf crlf)
   (run)
   (printout t "Recomanacions actualitzades!" crlf crlf)
   
   (return ?nom-instance)
)

;;; Function to select a client from a list
(deffunction seleccionar-client ()
   ;; Collect all clients
   (bind ?clients (create$))
   (do-for-all-instances ((?c Client)) TRUE
      (bind ?clients (create$ ?clients (instance-name ?c))))
   
   (if (= (length$ ?clients) 0) then
      (printout t "ERROR: No hi ha clients al sistema." crlf)
      (return FALSE))
   
   ;; Display menu
   (printout t crlf "=== SELECCIONA UN CLIENT ===" crlf)
   (bind ?i 1)
   (foreach ?client ?clients
      (printout t ?i ". " ?client crlf)
      (bind ?i (+ ?i 1)))
   (printout t crlf "Selecciona el número del client (1-" (length$ ?clients) ") o 'cancelar': ")
   
   ;; Read selection
   (bind ?seleccio (read))
   
   (if (eq ?seleccio cancelar) then
      (return FALSE))
   
   ;; Validate selection
   (if (or (not (integerp ?seleccio))
           (< ?seleccio 1)
           (> ?seleccio (length$ ?clients))) then
      (printout t "ERROR: Selecció no vàlida." crlf)
      (return FALSE))
   
   ;; Return selected client
   (return (nth$ ?seleccio ?clients))
)

;;; Function to display all offers for a client filtered by recommendation level
(deffunction mostrar-ofertes-client ()
   (bind ?client-seleccionat (seleccionar-client))
   
   (if (eq ?client-seleccionat FALSE) then
      (return FALSE))
   
   (printout t crlf "========================================" crlf)
   (printout t "OFERTES PER AL CLIENT: " ?client-seleccionat crlf)
   (printout t "========================================" crlf crlf)
   
   ;; Ask for filter level
   (printout t "Filtrar per nivell de recomanació:" crlf)
   (printout t "1. Totes les ofertes" crlf)
   (printout t "2. Molt recomenat" crlf)
   (printout t "3. Recomenat" crlf)
   (printout t "4. Poc recomenat" crlf)
   (printout t "5. No recomenat" crlf)
   (bind ?filtre (read-integer 1 5 "Selecciona el filtre (1-5)"))
   
   (if (eq ?filtre cancelar) then
      (return FALSE))
   
   (bind ?nivell-filtre "")
   (switch ?filtre
      (case 1 then (bind ?nivell-filtre "tots"))
      (case 2 then (bind ?nivell-filtre "molt recomenat"))
      (case 3 then (bind ?nivell-filtre "recomenat"))
      (case 4 then (bind ?nivell-filtre "poc recomenat"))
      (case 5 then (bind ?nivell-filtre "no recomenat"))
   )
   
   ;; Collect and display all offers for this client
   (bind ?count 0)
   (do-for-all-instances ((?o RentalOffer)) TRUE
      (bind ?mostrar FALSE)
      
      ;; Check if there's a recommendation for this offer and client
      (do-for-all-instances ((?r Recommendation))
         (and (eq (nth$ 1 ?r:recommendedFor) ?client-seleccionat)
              (eq (nth$ 1 ?r:aboutOffer) (instance-name ?o)))
         
         (bind ?nivell (nth$ 1 ?r:recommendationLevel))
         
         ;; Apply filter
         (if (or (eq ?nivell-filtre "tots")
                 (eq ?nivell ?nivell-filtre)) then
            (bind ?mostrar TRUE)
            (bind ?count (+ ?count 1))
            
            (bind ?prop-list (send ?o get-hasProperty))
            (if (> (length$ ?prop-list) 0) then
               (bind ?prop-obj (instance-address (nth$ 1 ?prop-list)))
               (if (neq ?prop-obj FALSE) then
                  (bind ?adreca (nth$ 1 (send ?prop-obj get-address)))
                  (bind ?area (nth$ 1 (send ?prop-obj get-area)))
                  (bind ?preu (nth$ 1 (send ?o get-price)))
                  
                  (printout t "========================================" crlf)
                  (printout t "RECOMANACIÓ" crlf)
                  (printout t "========================================" crlf)
                  (printout t "Client: [" ?client-seleccionat "]" crlf)
                  (printout t "Oferta: [" (instance-name ?o) "]" crlf)
                  (printout t "Nivell: " ?nivell crlf)
                  (printout t "----------------------------------------" crlf)
                  
                  ;; Check if meets all restrictive criteria
                  (bind ?num-no-complerts 0)
                  (do-for-all-facts ((?cnc criteri-no-complert))
                     (and (eq ?cnc:client ?client-seleccionat) (eq ?cnc:oferta (instance-name ?o)))
                     (bind ?num-no-complerts (+ ?num-no-complerts 1))
                  )
                  
                  (if (= ?num-no-complerts 0) then
                     (printout t "✓ Compleix tots els criteris restrictius" crlf)
                  else
                     (printout t "Criteris NO complerts:" crlf)
                     (bind ?idx 0)
                     (do-for-all-facts ((?cnc criteri-no-complert))
                        (and (eq ?cnc:client ?client-seleccionat) (eq ?cnc:oferta (instance-name ?o)))
                        (bind ?idx (+ ?idx 1))
                        (printout t "  " ?idx ". " ?cnc:descripcio crlf))
                  )
                  
                  ;; Show highlighted characteristics
                  (bind ?num-destacades 0)
                  (do-for-all-facts ((?cd caracteristica-destacada))
                     (and (eq ?cd:client ?client-seleccionat) (eq ?cd:oferta (instance-name ?o)))
                     (if (= ?num-destacades 0) then
                        (printout t crlf "Característiques destacables:" crlf))
                     (bind ?num-destacades (+ ?num-destacades 1))
                     (printout t "  ★ " ?cd:descripcio crlf)
                  )
                  
                  (if (= ?num-destacades 0) then
                     (printout t crlf "No té característiques especialment destacables" crlf))
                  
                  (printout t "========================================" crlf crlf)
               )
            )
         )
      )
   )
   
   (if (= ?count 0) then
      (if (eq ?nivell-filtre "tots") then
         (printout t "No s'han trobat ofertes amb recomanacions per aquest client." crlf)
      else
         (printout t "No s'han trobat ofertes amb el nivell '" ?nivell-filtre "' per aquest client." crlf))
   else
      (printout t "Total: " ?count " ofertes mostrades" crlf))
   
   (printout t crlf)
)

;;; Interactive menu
(deffunction menu-interactiu ()
   (bind ?sortir FALSE)
   (while (not ?sortir)
      (printout t crlf "=== MENÚ PRINCIPAL ===" crlf)
      (printout t "1. Afegir un nou client" crlf)
      (printout t "2. Mostrar tots els clients" crlf)
      (printout t "3. Afegir una nova oferta de lloguer" crlf)
      (printout t "4. Mostrar totes les ofertes" crlf)
      (printout t "5. Mostrar ofertes per a un client (filtrat)" crlf)
      (printout t "6. Sortir" crlf)
      (printout t "Selecciona una opció (1-6): ")
      
      (bind ?opcio (read))
      
      (switch ?opcio
         (case 1 then
            (afegir-client-nou))
         (case 2 then
            (mostrar-tots-clients))
         (case 3 then
            (afegir-oferta-nova))
         (case 4 then
            (mostrar-totes-ofertes))
         (case 5 then
            (mostrar-ofertes-client))
         (case 6 then
            (bind ?sortir TRUE)
            (printout t crlf "Sortint del sistema..." crlf))
         (default
            (printout t "Opció no vàlida. Tria 1, 2, 3, 4, 5 o 6." crlf))
      )
   )
)

;;; ---------------------------------------------------------
;;; Per iniciar el menú interactiu, executa:
;;; (menu-interactiu)
;;; ---------------------------------------------------------

(printout t crlf)
(printout t "========================================" crlf)
(printout t "  Sistema carregat correctament!" crlf)
(printout t "========================================" crlf)
(printout t "Per iniciar el menú interactiu, escriu:" crlf)
(printout t "  (menu-interactiu)" crlf)
(printout t "========================================" crlf)
(printout t crlf)