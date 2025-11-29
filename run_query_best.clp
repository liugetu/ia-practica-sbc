;;; clips -f run_query_best.clp
;;; ---------------------------------------------------------
;;; run_query_best.clp
;;; Script to find the BEST recommendation for a specific client
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

;;; Function to find the best recommendation for a specific client
(deffunction find-best-recommendation (?client-name)
   (bind ?best-rec nil)
   (bind ?best-score -999)
   (bind ?best-level "")
   
   ;; Convert recommendation levels to numeric scores for comparison
   (deffunction level-to-score (?level)
      (if (eq ?level "molt recomenat") then 4
      else (if (eq ?level "recomenat") then 3
      else (if (eq ?level "poc recomenat") then 2
      else (if (eq ?level "no recomenat") then 1
      else 0))))
   )
   
   (do-for-all-instances
      ((?r Recommendation))
      (eq ?r:recommendedFor (symbol-to-instance-name ?client-name))
      (bind ?current-score (level-to-score ?r:recommendationLevel))
      (if (> ?current-score ?best-score) then
         (bind ?best-rec ?r)
         (bind ?best-score ?current-score)
         (bind ?best-level ?r:recommendationLevel)
      )
   )
   
   (if (neq ?best-rec nil) then
      (printout t "=== MILLOR RECOMANACIÓ PER " ?client-name " ===" crlf crlf)
      (printout t "Oferta: " ?best-rec:aboutOffer crlf)
      (printout t "Nivell: " ?best-level crlf)
      
      ;; Show property details
      (bind ?oferta-inst (symbol-to-instance-name ?best-rec:aboutOffer))
      (bind ?prop-inst (symbol-to-instance-name (send ?oferta-inst get-hasProperty)))
      
      (printout t crlf "--- DETALLS DE LA PROPIETAT ---" crlf)
      (printout t "Adreça: " (send ?prop-inst get-address) crlf)
      (printout t "Superfície: " (send ?prop-inst get-area) " m²" crlf)
      (printout t "Llum natural: " (send ?prop-inst get-naturalLight) "/10" crlf)
      (printout t "Estat: " (send ?prop-inst get-state) "/10" crlf)
      
      (printout t crlf "--- DETALLS DE L'OFERTA ---" crlf)
      (printout t "Preu: " (send ?oferta-inst get-price) " €/mes" crlf)
      (printout t "Màxim persones: " (send ?oferta-inst get-maxPeople) crlf)
      (printout t "Mínims mesos: " (send ?oferta-inst get-minMonths) crlf)
      
      (printout t crlf "--- CARACTERÍSTIQUES ---" crlf)
      (bind ?features (send ?oferta-inst get-hasFeature))
      (if (> (length$ ?features) 0) then
         (foreach ?feat ?features
            (printout t "- " ?feat crlf)
         )
      else
         (printout t "No té característiques especials." crlf)
      )
      
   else
      (printout t "No s'han trobat recomanacions per al client " ?client-name crlf)
   )
   (printout t crlf "================================" crlf crlf)
)

;;; Display available clients
(printout t "=== CLIENTS DISPONIBLES ===" crlf)
(do-for-all-instances
   ((?c Client))
   TRUE
   (printout t "- " (instance-name ?c) crlf)
)
(printout t crlf)

;;; Find best recommendations for each client
(printout t "=== MILLORS RECOMANACIONS ===" crlf crlf)

;; Example: Best recommendation for the young couple
(find-best-recommendation [client-parella-centre])

;; Example: Best recommendation for the family
(find-best-recommendation [client-familia-verda])

;; Example: Best recommendation for students
(find-best-recommendation [client-estudiants-campus])

;; Example: Best recommendation for elderly client
(find-best-recommendation [client-gent-gran-tranquil])

;; Example: Best recommendation for young adult
(find-best-recommendation [client-jove-centre-lowcost])

(printout t "=== FI ANÀLISI ===" crlf)