;;; ---------------------------------------------------------
;;; exe3.clp
;;; Script per afegir nous clients amb tots els camps necessaris
;;; Utilitza la base de vivendes.clp com a referència de propietats
;;; ---------------------------------------------------------

;;; Carrega l'ontologia (definicions de classes)
(load "ontologia.clp")

;;; Carrega la base de dades de vivendes i clients de Barcelona
;;; POTS COMENTAR I DESCOMENTAR LINIES PER PROVAR DIFERENTS ENTRADES
;;;(load "vivendes-barcelona.clp")
;;;(load "clients-barcelona.clp")
;;;(load "inicialitzacio-basica.clp")
;;;(load "prova-no-recomenat.clp")
;;;(load "prova-poc-recomenat.clp")
;;;(load "prova-recomenat.clp")
;;;(load "prova-molt-recomenat.clp")
;;;(load "prova-hardvssoft.clp")
(load "prova-red-flags.clp")

;;; Carrega les regles del sistema expert
(load "expert.clp")

;;; Reinicia i prepara el sistema
(reset)
(run)

;;; ---------------------------------------------------------
;;; FUNCIONS PER A L'ENTRADA DE CLIENTS
;;; ---------------------------------------------------------

;;; Declaracions anticipades
(deffunction crear-localitzacio ())
(deffunction seleccionar-o-crear-barri ())
(deffunction seleccionar-location-treball ())
(deffunction afegir-client-nou ())
(deffunction mostrar-tots-clients ())
(deffunction afegir-oferta-nova ())
(deffunction mostrar-totes-ofertes ())
(deffunction mostrar-ofertes-client ())
(deffunction menu-interactiu ())

;;; Funció per llegir i validar un enter
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

;;; Funció per llegir un enter sense restricció de rang
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

;;; Funció per llegir i validar un número (float)
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

;;; Funció per llegir un número (float) sense restricció de rang
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

;;; Funció per llegir una resposta SI/NO
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

;;; Funció per obtenir el perfil del client
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

;;; Funció per seleccionar característiques d'una llista
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

;;; Funció per mostrar tots els clients
(deffunction mostrar-tots-clients ()
   (printout t crlf crlf)
   (printout t "========================================" crlf)
   (printout t "   LLISTA DE TOTS ELS CLIENTS          " crlf)
   (printout t "========================================" crlf crlf)
   
   (bind ?count 0)
   (do-for-all-instances ((?c Client)) TRUE
      (bind ?count (+ ?count 1))
      (bind ?nom-inst (instance-name ?c))
      (bind ?edat (nth$ 1 (send ?c get-clientAge)))
      (bind ?preu-max (nth$ 1 (send ?c get-clientMaxPrice)))
      (bind ?flex (nth$ 1 (send ?c get-priceFlexibility)))
      (bind ?min-area (nth$ 1 (send ?c get-minArea)))
      (bind ?min-dorms (nth$ 1 (send ?c get-minDorms)))
      (bind ?min-months (nth$ 1 (send ?c get-minMonthsClient)))
      (bind ?num-tenants (nth$ 1 (send ?c get-numTenants)))
      
      ;; Obtenir el perfil per comprovar si és una família
      (bind ?profile-list (send ?c get-hasProfile))
      (bind ?num-elderly 0)
      (bind ?num-children 0)
      (if (> (length$ ?profile-list) 0) then
         (bind ?profile-inst (instance-address (nth$ 1 ?profile-list)))
         (if (and (neq ?profile-inst FALSE) (eq (class ?profile-inst) Family)) then
            (bind ?num-elderly (nth$ 1 (send ?profile-inst get-numElderly)))
            (bind ?num-children (nth$ 1 (send ?profile-inst get-numChildren)))
         )
      )
      
      (printout t "========================================" crlf)
      (printout t "CLIENT #" ?count ": " ?nom-inst crlf)
      (printout t "========================================" crlf)
      (printout t "· Edat: " ?edat " anys" crlf)
      (printout t "· Nombre d'inquilins: " ?num-tenants)
      (if (> ?num-elderly 0) then
         (printout t " (ancians: " ?num-elderly ")"))
      (if (> ?num-children 0) then
         (printout t " (nens: " ?num-children ")"))
      (printout t crlf)
      (printout t "· Pressupost màxim: " ?preu-max "€/mes (flexibilitat: " ?flex "%)" crlf)
      (printout t "· Superfície mínima: " ?min-area " m²" crlf)
      (printout t "· Dormitoris mínims: " ?min-dorms crlf)
      (printout t "· Durada desitjada: " ?min-months " mesos" crlf)
      
      ;; Mostrar lloc de treball o estudi si existeix
      (bind ?works-studies-slot (send ?c get-worksOrStudies))
      (if (and (neq ?works-studies-slot nil) 
               (neq ?works-studies-slot FALSE)
               (symbolp ?works-studies-slot)) then
         (bind ?loc-work (instance-address ?works-studies-slot))
         (if (neq ?loc-work FALSE) then
            (bind ?barri-work-list (send ?loc-work get-isSituated))
            (if (> (length$ ?barri-work-list) 0) then
               (bind ?barri-work-obj (instance-address (nth$ 1 ?barri-work-list)))
               (if (neq ?barri-work-obj FALSE) then
                  (bind ?barri-work-nom (nth$ 1 (send ?barri-work-obj get-NeighbourhoodName)))
                  (printout t "· Treballa/estudia a: " ?barri-work-nom crlf)
               )
            )
         )
      )
      
      ;; Mostrar si necessita habitació doble
      (bind ?needs-double (nth$ 1 (send ?c get-needsDoubleBedroom)))
      (if (eq ?needs-double si) then
         (printout t "· Necessita habitació doble: Sí" crlf))
      
      ;; Mostrar preferències de serveis
      (bind ?has-preferences FALSE)
      (bind ?wants-green (nth$ 1 (send ?c get-wantsGreenArea)))
      (bind ?wants-health (nth$ 1 (send ?c get-wantsHealthCenter)))
      (bind ?wants-transport (nth$ 1 (send ?c get-wantsTransport)))
      (bind ?wants-super (nth$ 1 (send ?c get-wantsSupermarket)))
      (bind ?wants-school (nth$ 1 (send ?c get-wantsSchool)))
      (bind ?wants-night (nth$ 1 (send ?c get-wantsNightLife)))
      (bind ?wants-stadium (nth$ 1 (send ?c get-wantsStadium)))
      
      (if (or (eq ?wants-green si) (eq ?wants-health si) (eq ?wants-transport si)
              (eq ?wants-super si) (eq ?wants-school si) (eq ?wants-night si) (eq ?wants-stadium si)) then
         (printout t crlf "Preferències de serveis propers:" crlf)
         (if (eq ?wants-green si) then (printout t " · Zones verdes" crlf))
         (if (eq ?wants-health si) then (printout t " · Centres de salut" crlf))
         (if (eq ?wants-transport si) then (printout t " · Transport públic" crlf))
         (if (eq ?wants-super si) then (printout t " · Supermercats" crlf))
         (if (eq ?wants-school si) then (printout t " · Escoles" crlf))
         (if (eq ?wants-night si) then (printout t " · Vida nocturna" crlf))
         (if (eq ?wants-stadium si) then (printout t " · Estadis esportius" crlf))
      )
      
      ;; Mostrar característiques preferides
      (bind ?pref-features (send ?c get-prefersFeature))
      (if (and (multifieldp ?pref-features) (> (length$ ?pref-features) 0)) then
         (printout t crlf "Característiques desitjades de l'habitatge:" crlf)
         (foreach ?feat ?pref-features
            (printout t " · " ?feat crlf)))
      
      (printout t crlf)
   )
   
   (if (= ?count 0) then
      (printout t "No hi ha clients al sistema." crlf)
   else
      (printout t "========================================" crlf)
      (printout t "Total: " ?count " clients" crlf)
   )
   
   (printout t "========================================" crlf crlf)
)

;;; Funció per mostrar totes les ofertes de lloguer
(deffunction mostrar-totes-ofertes ()
   (printout t crlf crlf)
   (printout t "========================================" crlf)
   (printout t "   LLISTA DE TOTES LES OFERTES         " crlf)
   (printout t "========================================" crlf crlf)
   
   (bind ?count 0)
   (do-for-all-instances ((?o RentalOffer)) TRUE
      (bind ?count (+ ?count 1))
      (bind ?nom-oferta (instance-name ?o))
      (bind ?preu (nth$ 1 (send ?o get-price)))
      (bind ?max-persones (nth$ 1 (send ?o get-maxPeople)))
      (bind ?min-mesos (nth$ 1 (send ?o get-minMonths)))
      (bind ?features (send ?o get-hasFeature))
      
      (printout t "========================================" crlf)
      (printout t "OFERTA #" ?count ": " ?nom-oferta crlf)
      (printout t "========================================" crlf)
      (printout t "· Preu: " ?preu " €/mes" crlf)
      (printout t "· Persones màximes: " ?max-persones crlf)
      (printout t "· Durada mínima: " ?min-mesos " mesos" crlf)
      
      (bind ?prop-list (send ?o get-hasProperty))
      (if (> (length$ ?prop-list) 0) then
         (bind ?prop-obj (instance-address (nth$ 1 ?prop-list)))
         (if (neq ?prop-obj FALSE) then
            (bind ?adreca (nth$ 1 (send ?prop-obj get-address)))
            (bind ?area (nth$ 1 (send ?prop-obj get-area)))
            (printout t "· Adreça: " ?adreca crlf)
            (printout t "· Superfície: " ?area " m²" crlf)
            
            ;; Obtenir informació del barri
            (bind ?barri-nom "Desconegut")
            (bind ?barri-seguretat "N/A")
            (bind ?barri-preu-mitja "N/A")
            (bind ?loc-list (send ?prop-obj get-locatedAt))
            (if (> (length$ ?loc-list) 0) then
               (bind ?loc-obj (instance-address (nth$ 1 ?loc-list)))
               (if (neq ?loc-obj FALSE) then
                  (bind ?barri-list (send ?loc-obj get-isSituated))
                  (if (> (length$ ?barri-list) 0) then
                     (bind ?barri-obj (instance-address (nth$ 1 ?barri-list)))
                     (if (neq ?barri-obj FALSE) then
                        (bind ?barri-nom (nth$ 1 (send ?barri-obj get-NeighbourhoodName)))
                        (bind ?barri-seguretat (nth$ 1 (send ?barri-obj get-safety)))
                        (bind ?barri-preu-mitja (nth$ 1 (send ?barri-obj get-averagePrice)))
                     )
                  )
               )
            )
            
            (printout t "· Barri: " ?barri-nom crlf)
            (printout t "  - Seguretat: " ?barri-seguretat "/5" crlf)
            (printout t "  - Preu mitjà zona: " ?barri-preu-mitja " €/mes" crlf)
         )
      )
      
      ;; Mostrar característiques
      (if (and (multifieldp ?features) (> (length$ ?features) 0)) then
         (printout t crlf "Característiques:" crlf)
         (foreach ?feat ?features
            (printout t " · " ?feat crlf))
      )
      
      (printout t crlf)
   )
   
   (if (= ?count 0) then
      (printout t "No hi ha ofertes al sistema." crlf)
   else
      (printout t "========================================" crlf)
      (printout t "Total: " ?count " ofertes" crlf)
   )
   
   (printout t "========================================" crlf crlf)
)

;;; Funció per afegir un client nou amb tots els camps
(deffunction afegir-client-nou ()
   (printout t crlf crlf)
   (printout t "========================================" crlf)
   (printout t "   FORMULARI D'ALTA DE NOU CLIENT       " crlf)
   (printout t "========================================" crlf crlf)
   (printout t "Pots cancelar en qualsevol moment escrivint 'cancelar'" crlf crlf)
   
   ;; Llegir el nom del client
   (printout t "Nom del client (o 'cancelar' per avortar): ")
   (bind ?nom (read))
   (if (eq ?nom cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   ;; Fer servir el nom del client com a nom d'instància (afegeix un prefix per assegurar un símbol vàlid)
   (bind ?nom-instance (sym-cat client- ?nom))
   
   ;; Llegir l'edat
   (bind ?edat (read-integer-free "Edat del client"))
   (if (eq ?edat cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Llegir la mida de la família
   (bind ?tamany-familia (read-integer-free "Nombre de membres de la família"))
   (if (eq ?tamany-familia cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Llegir el preu màxim
   (bind ?preu-max (read-float-free "Preu màxim mensual en €"))
   (if (eq ?preu-max cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Llegir la flexibilitat de preu
   (bind ?flexibilitat (read-integer-free "Flexibilitat de preu en %"))
   (if (eq ?flexibilitat cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Llegir la superfície mínima
   (bind ?min-area (read-integer-free "Superfície mínima en m²"))
   (if (eq ?min-area cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Llegir els dormitoris mínims
   (bind ?min-dorms (read-integer-free "Dormitoris mínims"))
   (if (eq ?min-dorms cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Llegir el preu raonable mínim
   (bind ?preu-reasonable (read-integer-free "Preu raonable mínim en €"))
   (if (eq ?preu-reasonable cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Llegir si necessita dormitori doble
   (bind ?necessita-doble (read-si-no "Necessita dormitori doble"))
   (if (eq ?necessita-doble cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Llegir el perfil
   (bind ?perfil-type (get-client-profile))
   (if (eq ?perfil-type cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   (bind ?perfil-instance (gensym*))
   
   ;; Crear la instància del perfil
   (make-instance ?perfil-instance of ?perfil-type)
   
   ;; Si el perfil és Family, demanar el nombre d'ancians i nens
   (if (eq ?perfil-type Family) then
      (bind ?num-ancians (read-integer 0 ?tamany-familia "Quants d'ells són ancians (>=65 anys)"))
      (if (eq ?num-ancians cancelar) then
         (printout t crlf "Operació cancel·lada." crlf crlf)
         (return FALSE))
      
      (bind ?num-nens (read-integer 0 ?tamany-familia "Quants d'ells són nens (<18 anys)"))
      (if (eq ?num-nens cancelar) then
         (printout t crlf "Operació cancel·lada." crlf crlf)
         (return FALSE))
      
      ;; Assignar valors a la instància Family amb modify-instance
      (modify-instance ?perfil-instance
         (numElderly ?num-ancians)
         (numChildren ?num-nens))
   )
   
   ;; Llegir preferències de serveis
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
   
   ;; Llegir preferències de característiques
   (bind ?features-preferides (select-features))
   (if (eq ?features-preferides cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Llegir la durada mínima (mesos)
   (bind ?min-mesos (read-integer-free "Durada mínima de lloguer en mesos"))
   (if (eq ?min-mesos cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Llegir la ubicació de treball/estudi (opcional)
   (bind ?location-treball (seleccionar-location-treball))
   (if (eq ?location-treball cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Crear la instància del client
   (if (neq ?location-treball FALSE) then
      (make-instance ?nom-instance of Client
         (clientAge ?edat)
         (clientMaxPrice ?preu-max)
         (numTenants ?tamany-familia)
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
         (worksOrStudies ?location-treball)
      )
   else
      (make-instance ?nom-instance of Client
         (clientAge ?edat)
         (clientMaxPrice ?preu-max)
         (numTenants ?tamany-familia)
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
   )
   
   ;; Mostrar confirmació
   (printout t crlf crlf)
   (printout t "========================================" crlf)
   (printout t "CLIENT AFEGIT CORRECTAMENT" crlf)
   (printout t "========================================" crlf)
   (printout t "Nom: " ?nom crlf)
   (printout t "Instància: " ?nom-instance crlf)
   (printout t "Edat: " ?edat " anys" crlf)
   (printout t "Nombre d'inquilins: " ?tamany-familia)
   (if (eq ?perfil-type Family) then
      (bind ?prof-inst (instance-address ?perfil-instance))
      (if (neq ?prof-inst FALSE) then
         (bind ?anc (nth$ 1 (send ?prof-inst get-numElderly)))
         (bind ?nens (nth$ 1 (send ?prof-inst get-numChildren)))
         (if (> ?anc 0) then
            (printout t " (ancians: " ?anc ")"))
         (if (> ?nens 0) then
            (printout t " (nens: " ?nens ")"))
      )
   )
   (printout t crlf)
   (printout t "Pressupost: " ?preu-max "€/mes (+/-" ?flexibilitat "%)" crlf)
   (printout t "Superfície mínima: " ?min-area " m²" crlf)
   (printout t "Dormitoris mínims: " ?min-dorms crlf)
   (printout t "Durada: " ?min-mesos " mesos mín." crlf)
   (if (> (length$ ?features-preferides) 0) then
      (printout t "Característiques preferides: " ?features-preferides crlf)
   )
   (printout t "========================================" crlf crlf)
   
   ;; Generar recomanacions per al nou client
   (printout t "Generant recomanacions per al nou client..." crlf crlf)
   
   ;; Executar el sistema expert per generar recomanacions (sense reset per preservar les dades existents)
   (run)
   
   (printout t "Recomanacions generades!" crlf)
   (printout t "Utilitza l'opció 5 del menú per veure les ofertes recomanades." crlf crlf)
   
   (return ?nom-instance)
)

;;; Funció per seleccionar una ubicació de treball/estudi (opcional)
(deffunction seleccionar-location-treball ()
   ;; Preguntar si el client treballa o estudia en algun lloc
   (bind ?te-lloc (read-si-no "El client treballa o estudia en algun lloc específic"))
   (if (eq ?te-lloc cancelar) then
      (return cancelar))
   
   (if (eq ?te-lloc no) then
      (return FALSE))
   
   ;; Recollir totes les ubicacions
   (bind ?locations (create$))
   (do-for-all-instances ((?l Location)) TRUE
      (bind ?locations (create$ ?locations (instance-name ?l))))
   
   (printout t crlf "=== UBICACIÓ DE TREBALL/ESTUDI ===" crlf)
   (if (> (length$ ?locations) 0) then
      (printout t "Ubicacions existents:" crlf)
      (bind ?i 1)
      (foreach ?loc ?locations
         (bind ?loc-obj (instance-address ?loc))
         (if (neq ?loc-obj FALSE) then
            ;; Obtenir el nom del barri si està disponible
            (bind ?barri-nom "Desconegut")
            (bind ?barri-list (send ?loc-obj get-isSituated))
            (if (> (length$ ?barri-list) 0) then
               (bind ?barri-obj (instance-address (nth$ 1 ?barri-list)))
               (if (neq ?barri-obj FALSE) then
                  (bind ?barri-nom (nth$ 1 (send ?barri-obj get-NeighbourhoodName)))
               )
            )
            (bind ?lat (nth$ 1 (send ?loc-obj get-latitude)))
            (bind ?lon (nth$ 1 (send ?loc-obj get-longitude)))
            (printout t ?i ". " ?loc " - Barri: " ?barri-nom " (" ?lat ", " ?lon ")" crlf)
         )
         (bind ?i (+ ?i 1)))
      (printout t ?i ". Crear nova ubicació" crlf)
      
      (bind ?seleccio (read-integer 1 ?i "Selecciona opció"))
      (if (eq ?seleccio cancelar) then
         (return cancelar))
      
      (if (< ?seleccio ?i) then
         ;; Seleccionar una ubicació existent
         (return (nth$ ?seleccio ?locations))
      )
   else
      ;; No hi ha ubicacions existents; demanar crear-ne una
      (printout t "No hi ha ubicacions existents al sistema." crlf)
   )
   
   ;; Crear una ubicació nova
   (bind ?nova-loc (crear-localitzacio))
   (if (eq ?nova-loc FALSE) then
      (return FALSE))
   
   (return ?nova-loc)
)

;;; Funció per seleccionar una propietat d'una llista
(deffunction seleccionar-propietat ()
   ;; Recollir totes les propietats
   (bind ?properties (create$))
   (do-for-all-instances ((?p Property)) TRUE
      (bind ?properties (create$ ?properties (instance-name ?p))))
   
   (if (= (length$ ?properties) 0) then
      (printout t "ERROR: No hi ha propietats al sistema." crlf)
      (return FALSE))
   
   ;; Mostrar el menú
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
   
   ;; Llegir la selecció
   (bind ?seleccio (read))
   
   (if (eq ?seleccio cancelar) then
      (return FALSE))
   
   ;; Validar la selecció
   (if (or (not (integerp ?seleccio))
           (< ?seleccio 1)
           (> ?seleccio (length$ ?properties))) then
      (printout t "ERROR: Selecció no vàlida." crlf)
      (return FALSE))
   
   ;; Retornar la propietat seleccionada
   (return (nth$ ?seleccio ?properties))
)

;;; Funció per seleccionar o crear un barri
(deffunction seleccionar-o-crear-barri ()
   ;; Recollir tots els barris
   (bind ?barris (create$))
   (do-for-all-instances ((?b Neighbourhood)) TRUE
      (bind ?barris (create$ ?barris (instance-name ?b))))
   
   (printout t crlf "=== BARRI ===" crlf)
   (if (> (length$ ?barris) 0) then
      (printout t "Barris existents:" crlf)
      (bind ?i 1)
      (foreach ?barri ?barris
         (bind ?barri-obj (instance-address ?barri))
         (bind ?nom (nth$ 1 (send ?barri-obj get-NeighbourhoodName)))
         (bind ?seg (nth$ 1 (send ?barri-obj get-safety)))
         (printout t ?i ". " ?nom " (seguretat: " ?seg "/5)" crlf)
         (bind ?i (+ ?i 1)))
      (printout t ?i ". Crear nou barri" crlf)
      
      (bind ?seleccio (read-integer 1 ?i "Selecciona opció"))
      (if (eq ?seleccio cancelar) then
         (return FALSE))
      
      (if (< ?seleccio ?i) then
         ;; Seleccionar un barri existent
         (return (nth$ ?seleccio ?barris))
      )
   )
   
   ;; Crear un barri nou
   (printout t crlf "=== CREAR NOU BARRI ===" crlf)
   (printout t "Nom del barri (o 'cancelar'): ")
   (bind ?nom-barri (read))
   (if (eq ?nom-barri cancelar) then
      (return FALSE))
   
   (bind ?seguretat (read-integer 0 5 "Nivell de seguretat (0=molt poca, 5=suprema)"))
   (if (eq ?seguretat cancelar) then
      (return FALSE))
   
   (bind ?preu-mitja (read-float-free "Preu mitjà del barri en €/mes"))
   (if (eq ?preu-mitja cancelar) then
      (return FALSE))
   
   (bind ?barri-instance (gensym*))
   (make-instance ?barri-instance of Neighbourhood
      (NeighbourhoodName ?nom-barri)
      (safety ?seguretat)
      (averagePrice ?preu-mitja))
   
   (printout t "Barri creat: " ?barri-instance crlf)
   (return ?barri-instance)
)

;;; Funció per crear una localització nova
(deffunction crear-localitzacio ()
   (printout t crlf "=== CREAR NOVA LOCALITZACIÓ ===" crlf)
   
   ;; Llegir la latitud
   (bind ?lat (read-float 41.0 42.0 "Latitud (41.0-42.0)"))
   (if (eq ?lat cancelar) then
      (return FALSE))
   
   ;; Llegir la longitud
   (bind ?lon (read-float 2.0 3.0 "Longitud (2.0-3.0)"))
   (if (eq ?lon cancelar) then
      (return FALSE))
   
   ;; Seleccionar o crear un barri
   (bind ?barri (seleccionar-o-crear-barri))
   (if (eq ?barri FALSE) then
      (return FALSE))
   
   ;; Crear la instància de la localització
   (bind ?loc-instance (gensym*))
   (make-instance ?loc-instance of Location
      (latitude ?lat)
      (longitude ?lon)
      (isSituated ?barri))
   
   (printout t "Localització creada: " ?loc-instance crlf)
   (return ?loc-instance)
)

;;; Funció per crear habitacions per a una propietat
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

;;; Funció per crear una propietat nova
(deffunction crear-propietat ()
   (printout t crlf "=== CREAR NOVA PROPIETAT ===" crlf)
   
   ;; Llegir el nom de la propietat
   (printout t "Nom de la propietat (o 'cancelar'): ")
   (bind ?nom-prop (read))
   (if (eq ?nom-prop cancelar) then
      (return FALSE))
   (bind ?prop-instance (sym-cat viv- ?nom-prop))
   
   ;; Seleccionar el tipus de propietat
   (printout t crlf "=== TIPUS DE PROPIETAT ===" crlf)
   (printout t "1. Pis (Apartment)" crlf)
   (printout t "2. Casa (House)" crlf)
   (printout t "3. Duplex" crlf)
   (bind ?tipus (read-integer 1 3 "Selecciona el tipus (1-3)"))
   (if (eq ?tipus cancelar) then
      (return FALSE))
   
   ;; Llegir l'adreça
   (printout t "Adreça de la propietat (o 'cancelar'): ")
   (bind ?adreca (read))
   (if (eq ?adreca cancelar) then
      (return FALSE))
   
   ;; Llegir la superfície
   (bind ?area (read-integer-free "Superfície en m²"))
   (if (eq ?area cancelar) then
      (return FALSE))
   
   ;; Crear la localització
   (bind ?localitzacio (crear-localitzacio))
   (if (eq ?localitzacio FALSE) then
      (return FALSE))
   
   ;; Crear les habitacions
   (bind ?habitacions (crear-habitacions))
   (if (eq ?habitacions FALSE) then
      (return FALSE))
   
   ;; Llegir atributs addicionals
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

   ;; Insonorització
   (bind ?insonoritzat (read-si-no "És insonoritzada (soundproof)"))
   (if (eq ?insonoritzat cancelar) then
      (return FALSE))
   
   ;; Crear la propietat segons el tipus
   (switch ?tipus
      (case 1 then
         ;; Pis
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
            (isSoundproof (if (eq ?insonoritzat si) then TRUE else FALSE))
            (floor ?planta)))
      (case 2 then
         ;; Casa
         (make-instance ?prop-instance of House
            (address ?adreca)
            (area ?area)
            (locatedAt ?localitzacio)
            (hasRoom ?habitacions)
            (naturalLight ?llum-natural)
            (state ?estat)
            (hasSquatters (if (eq ?ocupes si) then TRUE else FALSE))
            (hasDampness (if (eq ?humitats si) then TRUE else FALSE))
            (hasLeaks (if (eq ?fugues si) then TRUE else FALSE))
            (isSoundproof (if (eq ?insonoritzat si) then TRUE else FALSE))))
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
            (isSoundproof (if (eq ?insonoritzat si) then TRUE else FALSE))
            (floor ?planta)))
   )
   
   (printout t crlf "Propietat creada correctament: " ?prop-instance crlf)
   (return ?prop-instance)
)

;;; Funció per afegir una oferta de lloguer nova
(deffunction afegir-oferta-nova ()
   (printout t crlf crlf)
   (printout t "========================================" crlf)
   (printout t "   FORMULARI D'ALTA DE NOVA OFERTA      " crlf)
   (printout t "========================================" crlf crlf)
   (printout t "Pots cancelar en qualsevol moment escrivint 'cancelar'" crlf crlf)
   
   ;; Llegir el nom de l'oferta
   (printout t "Nom de l'oferta (o 'cancelar' per avortar): ")
   (bind ?nom (read))
   (if (eq ?nom cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   (bind ?nom-instance (sym-cat oferta- ?nom))
   
   ;; Preguntar si es crea una propietat nova o se'n selecciona una d'existent
   (printout t crlf "Vols crear una nova propietat o seleccionar-ne una existent?" crlf)
   (printout t "1. Crear nova propietat" crlf)
   (printout t "2. Seleccionar propietat existent" crlf)
   (bind ?opcio-prop (read-integer 1 2 "Selecciona opció (1-2)"))
   (if (eq ?opcio-prop cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Obtenir o crear la propietat
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
   
   ;; Llegir el preu
   (bind ?preu (read-float-free "Preu mensual en €"))
   (if (eq ?preu cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Llegir el màxim de persones
   (bind ?max-persones (read-integer-free "Número màxim de persones"))
   (if (eq ?max-persones cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Llegir la durada mínima (mesos)
   (bind ?min-mesos (read-integer-free "Durada mínima del contracte en mesos"))
   (if (eq ?min-mesos cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Seleccionar característiques
   (printout t crlf "Selecciona les característiques de l'oferta:" crlf)
   (bind ?features (select-features))
   (if (eq ?features cancelar) then
      (printout t crlf "Operació cancel·lada." crlf crlf)
      (return FALSE))
   
   ;; Crear la instància de l'oferta de lloguer
   (make-instance ?nom-instance of RentalOffer
      (hasProperty ?propietat)
      (price ?preu)
      (maxPeople ?max-persones)
      (minMonths ?min-mesos)
      (hasFeature ?features)
   )
   
   ;; Mostrar confirmació
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
   
   ;; Generar recomanacions amb la nova oferta
   (printout t "Generant recomanacions amb la nova oferta..." crlf crlf)
   (run)
   (printout t "Recomanacions actualitzades!" crlf crlf)
   
   (return ?nom-instance)
)

;;; Funció per seleccionar un client d'una llista
(deffunction seleccionar-client ()
   ;; Recollir tots els clients
   (bind ?clients (create$))
   (do-for-all-instances ((?c Client)) TRUE
      (bind ?clients (create$ ?clients (instance-name ?c))))
   
   (if (= (length$ ?clients) 0) then
      (printout t "ERROR: No hi ha clients al sistema." crlf)
      (return FALSE))
   
   ;; Mostrar el menú
   (printout t crlf "=== SELECCIONA UN CLIENT ===" crlf)
   (bind ?i 1)
   (foreach ?client ?clients
      (printout t ?i ". " ?client crlf)
      (bind ?i (+ ?i 1)))
   (printout t crlf "Selecciona el número del client (1-" (length$ ?clients) ") o 'cancelar': ")
   
   ;; Llegir la selecció
   (bind ?seleccio (read))
   
   (if (eq ?seleccio cancelar) then
      (return FALSE))
   
   ;; Validar la selecció
   (if (or (not (integerp ?seleccio))
           (< ?seleccio 1)
           (> ?seleccio (length$ ?clients))) then
      (printout t "ERROR: Selecció no vàlida." crlf)
      (return FALSE))
   
   ;; Retornar el client seleccionat
   (return (nth$ ?seleccio ?clients))
)

;;; Funció per mostrar totes les ofertes d'un client filtrades per nivell de recomanació
(deffunction mostrar-ofertes-client ()
   (bind ?client-seleccionat (seleccionar-client))
   
   (if (eq ?client-seleccionat FALSE) then
      (return FALSE))
   
   (printout t crlf "========================================" crlf)
   (printout t "OFERTES PER AL CLIENT: " ?client-seleccionat crlf)
   (printout t "========================================" crlf crlf)
   
   ;; Demanar el nivell de filtre
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
   
   ;; Recollir i mostrar totes les ofertes d'aquest client
   (bind ?count 0)
   (do-for-all-instances ((?o RentalOffer)) TRUE
      (bind ?mostrar FALSE)
      
      ;; Comprovar si hi ha una recomanació per a aquesta oferta i client
      (do-for-all-instances ((?r Recommendation))
         (and (eq (nth$ 1 ?r:recommendedFor) ?client-seleccionat)
              (eq (nth$ 1 ?r:aboutOffer) (instance-name ?o)))
         
         (bind ?nivell (nth$ 1 ?r:recommendationLevel))
         
         ;; Aplicar el filtre
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
                  
                  ;; Obtenir informació del barri
                  (bind ?barri-nom "Desconegut")
                  (bind ?barri-seguretat "N/A")
                  (bind ?barri-preu-mitja "N/A")
                  (bind ?loc-list (send ?prop-obj get-locatedAt))
                  (if (> (length$ ?loc-list) 0) then
                     (bind ?loc-obj (instance-address (nth$ 1 ?loc-list)))
                     (if (neq ?loc-obj FALSE) then
                        (bind ?barri-list (send ?loc-obj get-isSituated))
                        (if (> (length$ ?barri-list) 0) then
                           (bind ?barri-obj (instance-address (nth$ 1 ?barri-list)))
                           (if (neq ?barri-obj FALSE) then
                              (bind ?barri-nom (nth$ 1 (send ?barri-obj get-NeighbourhoodName)))
                              (bind ?barri-seguretat (nth$ 1 (send ?barri-obj get-safety)))
                              (bind ?barri-preu-mitja (nth$ 1 (send ?barri-obj get-averagePrice)))
                           )
                        )
                     )
                  )
                  
                  (printout t crlf "========================================" crlf)
                  (printout t "Oferta: " (instance-name ?o) crlf)
                  (printout t "Adreça: " ?adreca crlf)
                  (printout t "Barri: " ?barri-nom crlf)
                  (printout t "  Seguretat: " ?barri-seguretat "/5" crlf)
                  (printout t "  Preu mitjà zona: " ?barri-preu-mitja " €/mes" crlf)
                  (printout t "Preu: " ?preu " €/mes" crlf)
                  (printout t "Superfície: " ?area " m2" crlf)
                  (printout t "Nivell: " ?nivell crlf)
                  (printout t "----------------------------------------" crlf)
                  
                  ;; Comprovar si compleix tots els criteris restrictius
                  (bind ?num-no-complerts 0)
                  (do-for-all-facts ((?cnc criteri-no-complert))
                     (and (eq ?cnc:client ?client-seleccionat) (eq ?cnc:oferta (instance-name ?o)))
                     (bind ?num-no-complerts (+ ?num-no-complerts 1))
                  )
                  
                  (if (= ?num-no-complerts 0) then
                     (printout t "Compleix tots els criteris restrictius" crlf)
                  else
                     (printout t "Criteris NO complerts:" crlf)
                     (bind ?idx 0)
                     (do-for-all-facts ((?cnc criteri-no-complert))
                        (and (eq ?cnc:client ?client-seleccionat) (eq ?cnc:oferta (instance-name ?o)))
                        (bind ?idx (+ ?idx 1))
                        (printout t "  " ?idx ". " ?cnc:descripcio crlf))
                  )
                  
                  ;; Mostrar característiques destacades
                  (bind ?num-destacades 0)
                  (do-for-all-facts ((?cd caracteristica-destacada))
                     (and (eq ?cd:client ?client-seleccionat) (eq ?cd:oferta (instance-name ?o)))
                     (if (= ?num-destacades 0) then
                        (printout t crlf "Característiques destacables:" crlf))
                     (bind ?num-destacades (+ ?num-destacades 1))
                     (printout t "  - " ?cd:descripcio crlf)
                  )
                  
                  (if (= ?num-destacades 0) then
                     (printout t crlf "No té característiques especialment destacables" crlf))
                  
                  (printout t "========================================" crlf)
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

;;; Menú interactiu
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

;;; Inicia el menú interactiu
(menu-interactiu)