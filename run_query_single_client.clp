;;; clips -f run_query_single_client.clp
;;; ---------------------------------------------------------
;;; run_query_single_client.clp
;;; Script to find the BEST recommendation for ONE specific client
;;; Usage: Modify the client name in the last line before running
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

;;; Function to show detailed best recommendation for a client
(deffunction show-best-for-client (?client-name)
   (bind ?best-rec nil)
   (bind ?best-level "")
   (bind ?best-score -1)
   
   ;; Find the best recommendation based on level priority
   (do-for-all-instances
      ((?r Recommendation))
      (eq ?r:recommendedFor ?client-name)
      (bind ?current-level ?r:recommendationLevel)
      (bind ?score 0)
      
      ;; Assign scores to levels
      (if (eq ?current-level "molt recomenat") then (bind ?score 4)
      else (if (eq ?current-level "recomenat") then (bind ?score 3)
      else (if (eq ?current-level "poc recomenat") then (bind ?score 2)
      else (if (eq ?current-level "no recomenat") then (bind ?score 1)))))
      
      (if (> ?score ?best-score) then
         (bind ?best-rec ?r)
         (bind ?best-level ?current-level)
         (bind ?best-score ?score)
      )
   )
   
   (if (neq ?best-rec nil) then
      (printout t "╔════════════════════════════════════════════════╗" crlf)
      (printout t "║        MILLOR RECOMANACIÓ PER CLIENT          ║" crlf)
      (printout t "╠════════════════════════════════════════════════╣" crlf)
      (printout t "║ Client: " ?client-name crlf)
      (printout t "║ Nivell: " ?best-level crlf)
      (printout t "╠════════════════════════════════════════════════╣" crlf)
      
      ;; Get property and offer details
      (bind ?oferta ?best-rec:aboutOffer)
      (bind ?propietat (send ?oferta get-hasProperty))
      
      (printout t "║ PROPIETAT:" crlf)
      (printout t "║   Adreça: " (send ?propietat get-address) crlf)
      (printout t "║   Tipus: " (class (send ?propietat get-class)) crlf)
      (printout t "║   Superfície: " (send ?propietat get-area) " m²" crlf)
      (printout t "║   Llum natural: " (send ?propietat get-naturalLight) "/10" crlf)
      (printout t "║   Estat: " (send ?propietat get-state) "/10" crlf)
      
      ;; Check if it's an apartment or duplex with floor info
      (if (or (eq (class (send ?propietat get-class)) Apartment)
              (eq (class (send ?propietat get-class)) Duplex)) then
         (printout t "║   Planta: " (send ?propietat get-floor) crlf)
      )
      
      (printout t "║" crlf)
      (printout t "║ OFERTA:" crlf)
      (printout t "║   Preu: " (send ?oferta get-price) " €/mes" crlf)
      (printout t "║   Màxim persones: " (send ?oferta get-maxPeople) crlf)
      (printout t "║   Mínims mesos: " (send ?oferta get-minMonths) crlf)
      
      (printout t "║" crlf)
      (printout t "║ CARACTERÍSTIQUES:" crlf)
      (bind ?features (send ?oferta get-hasFeature))
      (if (> (length$ ?features) 0) then
         (foreach ?feat ?features
            (printout t "║   ✓ " ?feat crlf)
         )
      else
         (printout t "║   (sense característiques especials)" crlf)
      )
      
      (printout t "╚════════════════════════════════════════════════╝" crlf)
   else
      (printout t "❌ No s'han trobat recomanacions per al client: " ?client-name crlf)
   )
)

;;; Show available clients first
(printout t "CLIENTS DISPONIBLES:" crlf)
(printout t "- [client-parella-centre]     → Parella jove que vol centre i oci" crlf)
(printout t "- [client-familia-verda]      → Família amb criatures" crlf) 
(printout t "- [client-estudiants-campus]  → Estudiants universitaris" crlf)
(printout t "- [client-gent-gran-tranquil] → Persona gran que cerca tranquil·litat" crlf)
(printout t "- [client-jove-centre-lowcost]→ Jove solter amb pressupost limitat" crlf)
(printout t crlf)

;;; 🔹 MODIFICA AQUESTA LÍNIA PER CANVIAR EL CLIENT A CONSULTAR 🔹
(show-best-for-client [client-parella-centre])

;;; Uncomment any of these lines to see other clients:
;; (show-best-for-client [client-familia-verda])
;; (show-best-for-client [client-estudiants-campus])
;; (show-best-for-client [client-gent-gran-tranquil])
;; (show-best-for-client [client-jove-centre-lowcost])