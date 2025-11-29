;;; clips -f run_query_all.clp
;;; ---------------------------------------------------------
;;; run_query_all.clp
;;; Script to load the ontology, initialization data, expert system
;;; and run the recommendation query
;;; ---------------------------------------------------------

;;; Load the ontology (class definitions)
(load "ontologia.clp")

;;; Load the initialization data (instances)
(load "inicialitzacio.clp")

;;; Load the expert system rules
(load "expert.clp")

;;; Reset and run the expert system
(reset)
(run)

;;; Function to display recommendations for a specific client  
(deffunction mostrar-recomanacions-client (?nom-client)
   (bind ?trobat FALSE)
   (bind ?client-instance (instance-address ?nom-client))
   
   (if (eq ?client-instance FALSE) then
      (printout t crlf "ERROR: El client " ?nom-client " no existeix." crlf crlf)
      (return FALSE)
   )
   
   (printout t crlf "=== RECOMANACIONS PER AL CLIENT " ?nom-client " ===" crlf crlf)
   
   (do-for-all-instances
      ((?r Recommendation))
      (eq (nth$ 1 ?r:recommendedFor) ?nom-client)
      (bind ?trobat TRUE)
      (bind ?oferta (nth$ 1 ?r:aboutOffer))
      (bind ?nivell (nth$ 1 ?r:recommendationLevel))
      
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
               (printout t "  Oferta: " ?oferta crlf)
               (printout t "    Adreça: " ?adreca crlf)
               (printout t "    Preu: " ?preu " €/mes" crlf)
               (printout t "    Superfície: " ?area " m2" crlf)
               (printout t "    Nivell: " ?nivell crlf)
               (printout t "  ----------------------------------------" crlf)
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
            (printout t "Introdueix el nom del client (inclou claudàtors, exemple: [client-parella-centre]): ")
            (bind ?nom (read))
            (mostrar-recomanacions-client ?nom))
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