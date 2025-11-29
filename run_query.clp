;;; ---------------------------------------------------------
;;; run_query.clp
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

;;; Display all recommendations
(printout t "=== RECOMANACIONS GENERADES ===" crlf crlf)

(do-for-all-instances
  ((?r Recommendation))
  TRUE
  (printout t
    "Client: " ?r:recommendedFor
    "  Oferta: " ?r:aboutOffer
    "  Nivell: " ?r:recommendationLevel
    crlf))

(printout t crlf "=== FI RECOMANACIONS ===" crlf)