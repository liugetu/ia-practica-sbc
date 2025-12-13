;;; clips -f run_query_all.clp
;;; ---------------------------------------------------------
;;; run_query_all.clp
;;; Script to load the ontology, initialization data, expert system
;;; and run the recommendation query
;;; ---------------------------------------------------------

;;; Load the ontology (class definitions)
(load "ontologia.clp")

;;; Carrega la base de dades de vivendes i clients de Barcelona
;;; POTS COMENTAR I DESCOMENTAR LINIES PER PROVAR DIFERENTS ENTRADES
(load "vivendes-barcelona.clp")
(load "clients-barcelona.clp")
;;;(load "inicialitzacio-basica.clp")
;;;(load "prova-molt-recomenat.clp")

;;; Load the expert system rules
(load "expert.clp")

;;; Reset and run the expert system
(reset)
(run)

;;; Function to get numeric value for recommendation level ordering
(deffunction nivell-to-numeric (?nivell)
   (switch ?nivell
      (case "molt recomenat" then 4)
      (case "recomenat" then 3)
      (case "poc recomenat" then 2)
      (case "no recomenat" then 1)
      (default 0)
   )
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
   (printout t crlf "Selecciona el número del client (1-" (length$ ?clients) "): ")
   
   ;; Read selection
   (bind ?seleccio (read))
   
   ;; Validate selection
   (if (or (not (integerp ?seleccio))
           (< ?seleccio 1)
           (> ?seleccio (length$ ?clients))) then
      (printout t "ERROR: Selecció no vàlida." crlf)
      (return FALSE))
   
   ;; Return selected client
   (return (nth$ ?seleccio ?clients))
)

;;; Function to display recommendations for a specific client  
(deffunction mostrar-recomanacions-client (?nom-client)
   (bind ?trobat FALSE)
   (bind ?client-instance (instance-address ?nom-client))
   
   (if (eq ?client-instance FALSE) then
      (printout t crlf "ERROR: El client " ?nom-client " no existeix." crlf crlf)
      (return FALSE)
   )
   
   (printout t crlf "========================================" crlf)
   (printout t "CLIENT: " ?nom-client crlf)
   (printout t "========================================" crlf)
   
   ;; Mostrar característiques del client
   (printout t crlf "CARACTERÍSTIQUES I PREFERÈNCIES:" crlf)
   (printout t "----------------------------------------" crlf)
   
   ;; Obtenir i mostrar les dades del client
   (bind ?edat (nth$ 1 (send ?client-instance get-clientAge)))
   (bind ?preu-max (nth$ 1 (send ?client-instance get-clientMaxPrice)))
   (bind ?flex (nth$ 1 (send ?client-instance get-priceFlexibility)))
   (bind ?min-area (nth$ 1 (send ?client-instance get-minArea)))
   (bind ?min-dorms (nth$ 1 (send ?client-instance get-minDorms)))
   (bind ?min-months (nth$ 1 (send ?client-instance get-minMonthsClient)))
   (bind ?num-tenants (nth$ 1 (send ?client-instance get-numTenants)))
   
   ;; Get profile to check if it's a family
   (bind ?profile-list (send ?client-instance get-hasProfile))
   (bind ?num-elderly 0)
   (bind ?num-children 0)
   (if (> (length$ ?profile-list) 0) then
      (bind ?profile-inst (instance-address (nth$ 1 ?profile-list)))
      (if (and (neq ?profile-inst FALSE) (eq (class ?profile-inst) Family)) then
         (bind ?num-elderly (nth$ 1 (send ?profile-inst get-numElderly)))
         (bind ?num-children (nth$ 1 (send ?profile-inst get-numChildren)))
      )
   )
   
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
   (bind ?works-studies-slot (send ?client-instance get-worksOrStudies))
   ;; Only process if the slot has a valid instance name (not nil)
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
   (bind ?needs-double (nth$ 1 (send ?client-instance get-needsDoubleBedroom)))
   (if (eq ?needs-double si) then
      (printout t "· Necessita habitació doble: Sí" crlf))
   
   ;; Mostrar preferències de serveis
   (printout t crlf "Preferències de serveis propers:" crlf)
   (bind ?wants-green (nth$ 1 (send ?client-instance get-wantsGreenArea)))
   (if (eq ?wants-green si) then (printout t " Zones verdes" crlf))
   
   (bind ?wants-health (nth$ 1 (send ?client-instance get-wantsHealthCenter)))
   (if (eq ?wants-health si) then (printout t " Centres de salut" crlf))
   
   (bind ?wants-transport (nth$ 1 (send ?client-instance get-wantsTransport)))
   (if (eq ?wants-transport si) then (printout t " Transport públic" crlf))
   
   (bind ?wants-super (nth$ 1 (send ?client-instance get-wantsSupermarket)))
   (if (eq ?wants-super si) then (printout t " Supermercats" crlf))
   
   (bind ?wants-school (nth$ 1 (send ?client-instance get-wantsSchool)))
   (if (eq ?wants-school si) then (printout t " Escoles" crlf))
   
   (bind ?wants-night (nth$ 1 (send ?client-instance get-wantsNightLife)))
   (if (eq ?wants-night si) then (printout t " Vida nocturna" crlf))
   
   (bind ?wants-stadium (nth$ 1 (send ?client-instance get-wantsStadium)))
   (if (eq ?wants-stadium si) then (printout t " Estadis esportius" crlf))
   
   ;; Mostrar característiques preferides
   (bind ?pref-features (send ?client-instance get-prefersFeature))
   (if (and (multifieldp ?pref-features) (> (length$ ?pref-features) 0)) then
      (printout t crlf "Característiques desitjades de l'habitatge:" crlf)
      (foreach ?feat ?pref-features
         (printout t " " ?feat crlf)))
   
   (printout t "========================================" crlf)
   (printout t crlf "RECOMANACIONS D'OFERTES:" crlf)
   
   ;; Collect all recommendations for this client
   (bind ?recomanacions (create$))
   
   (do-for-all-instances
      ((?r Recommendation))
      (eq (nth$ 1 ?r:recommendedFor) ?nom-client)
      (bind ?trobat TRUE)
      (bind ?oferta (nth$ 1 ?r:aboutOffer))
      (bind ?nivell (nth$ 1 ?r:recommendationLevel))
      (bind ?nivell-numeric (nivell-to-numeric ?nivell))
      
      ;; Store recommendation data as a list: [numeric-level, offer-name, level-string, instance]
      (bind ?rec-data (create$ ?nivell-numeric ?oferta ?nivell ?r))
      (bind ?recomanacions (create$ ?recomanacions ?rec-data))
   )
   
   ;; Sort recommendations by level (highest first)
   (if ?trobat then
      ;; Simple bubble sort for recommendations
      (bind ?n (/ (length$ ?recomanacions) 4))
      (loop-for-count (?i 1 ?n)
         (loop-for-count (?j 1 (- ?n ?i))
            (bind ?pos-j (* (- ?j 1) 4))
            (bind ?pos-j+1 (* ?j 4))
            (bind ?nivell-j (nth$ (+ ?pos-j 1) ?recomanacions))
            (bind ?nivell-j+1 (nth$ (+ ?pos-j+1 1) ?recomanacions))
            
            (if (< ?nivell-j ?nivell-j+1) then
               ;; Swap elements
               (bind ?temp1 (nth$ (+ ?pos-j 1) ?recomanacions))
               (bind ?temp2 (nth$ (+ ?pos-j 2) ?recomanacions))
               (bind ?temp3 (nth$ (+ ?pos-j 3) ?recomanacions))
               (bind ?temp4 (nth$ (+ ?pos-j 4) ?recomanacions))
               
               (bind ?recomanacions (replace$ ?recomanacions (+ ?pos-j 1) (+ ?pos-j 4)
                  (nth$ (+ ?pos-j+1 1) ?recomanacions)
                  (nth$ (+ ?pos-j+1 2) ?recomanacions)
                  (nth$ (+ ?pos-j+1 3) ?recomanacions)
                  (nth$ (+ ?pos-j+1 4) ?recomanacions)))
               
               (bind ?recomanacions (replace$ ?recomanacions (+ ?pos-j+1 1) (+ ?pos-j+1 4)
                  ?temp1 ?temp2 ?temp3 ?temp4))
            )
         )
      )
      
      ;; Display sorted recommendations
      (loop-for-count (?i 1 ?n)
         (bind ?pos (* (- ?i 1) 4))
         (bind ?oferta (nth$ (+ ?pos 2) ?recomanacions))
         (bind ?nivell (nth$ (+ ?pos 3) ?recomanacions))
         (bind ?r (nth$ (+ ?pos 4) ?recomanacions))
         
         ;; Get offer details
         (bind ?offer-obj (instance-address ?oferta))
         (if (neq ?offer-obj FALSE) then
            (bind ?preu (nth$ 1 (send ?offer-obj get-price)))
            (bind ?prop-list (send ?offer-obj get-hasProperty))
            (if (> (length$ ?prop-list) 0) then
               (bind ?prop-obj (instance-address (nth$ 1 ?prop-list)))
               (if (neq ?prop-obj FALSE) then
                  (bind ?adreca (nth$ 1 (send ?prop-obj get-address)))
                  (bind ?area (nth$ 1 (send ?prop-obj get-area)))
                  
                  ;; Get neighbourhood information
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
                  (printout t "Oferta: " ?oferta crlf)
                  (printout t "Adreça: " ?adreca crlf)
                  (printout t "Barri: " ?barri-nom crlf)
                  (printout t "  Seguretat: " ?barri-seguretat "/5" crlf)
                  (printout t "  Preu mitjà zona: " ?barri-preu-mitja " €/mes" crlf)
                  (printout t "Preu: " ?preu " €/mes" crlf)
                  (printout t "Superfície: " ?area " m2" crlf)
                  (printout t "Nivell: " ?nivell crlf)
                  (printout t "----------------------------------------" crlf)
                  
                  ;; Mostrar criteris no complerts
                  (bind ?num-no-complerts 0)
                  (do-for-all-facts ((?cnc criteri-no-complert))
                     (and (eq ?cnc:client ?nom-client) (eq ?cnc:oferta ?oferta))
                     (if (= ?num-no-complerts 0) then
                        (printout t "Criteris NO complerts:" crlf))
                     (bind ?num-no-complerts (+ ?num-no-complerts 1))
                     (printout t "  " ?num-no-complerts ". " ?cnc:descripcio crlf))
                  
                  (if (= ?num-no-complerts 0) then
                     (printout t "Compleix tots els criteris restrictius" crlf))
                  
                  ;; Mostrar característiques destacades
                  (bind ?num-destacades 0)
                  (do-for-all-facts ((?cd caracteristica-destacada))
                     (and (eq ?cd:client ?nom-client) (eq ?cd:oferta ?oferta))
                     (if (= ?num-destacades 0) then
                        (printout t crlf "Característiques destacables:" crlf))
                     (bind ?num-destacades (+ ?num-destacades 1))
                     (printout t "  - " ?cd:descripcio crlf))
                  
                  (if (= ?num-destacades 0) then
                     (printout t crlf "No té característiques especialment destacables" crlf))
                  
                  (printout t "========================================" crlf)
               )
            )
         )
      )
   )
   
   (if (not ?trobat) then
      (printout t "  No s'han trobat recomanacions per aquest client." crlf)
   )
   (printout t crlf)
)

;;; Function to display all recommendations
(deffunction mostrar-totes-recomanacions ()
   (printout t crlf "=== TOTES LES RECOMANACIONS GENERADES ===" crlf crlf)
   
   (do-for-all-instances
      ((?r Recommendation))
      TRUE
      (printout t
         "Client: " ?r:recommendedFor
         "  Oferta: " ?r:aboutOffer
         "  Nivell: " ?r:recommendationLevel
         crlf))
   
   (printout t crlf "=== FI RECOMANACIONS ===" crlf crlf)
)

;;; Interactive menu
(deffunction menu-interactiu ()
   (bind ?sortir FALSE)
   (while (not ?sortir)
      (printout t crlf "=== MENÚ DE CONSULTA ===" crlf)
      (printout t "1. Mostrar totes les recomanacions" crlf)
      (printout t "2. Mostrar recomanacions d'un client específic" crlf)
      (printout t "3. Sortir" crlf)
      (printout t "Selecciona una opció (1-3): ")
      
      (bind ?opcio (read))
      
      (switch ?opcio
         (case 1 then
            (mostrar-totes-recomanacions))
         (case 2 then
            (bind ?client-seleccionat (seleccionar-client))
            (if (neq ?client-seleccionat FALSE) then
               (mostrar-recomanacions-client ?client-seleccionat)))
         (case 3 then
            (bind ?sortir TRUE)
            (printout t crlf "Sortint del sistema..." crlf))
         (default
            (printout t "Opció no vàlida. Tria 1, 2 o 3." crlf))
      )
   )
)

;;; Start interactive menu
(menu-interactiu)