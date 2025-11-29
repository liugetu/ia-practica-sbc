;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Recomanador d'Lloguers - CLIPS v2
;; Versió que utilitza ontologia.clp (defclass COOL)
;; - Genera recomanacions: Molt recomanable / Adequat / Parcialment adequat
;; - Indica criteris no complerts i aspectes que destaquen
;;
;; ÚS:
;;   clips
;;   (load "ontologia.clp")
;;   (load "prova2.clp")
;;   (reset)
;;   (run)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Templates auxiliars per al raonament
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate criteri-no-complert
   (slot clientId)
   (slot offerId)
   (slot criteri)
)

(deftemplate aspecte-destacable
   (slot offerId)
   (slot text)
)

(deftemplate preu-ok
   (slot clientId)
   (slot offerId)
)

(deftemplate area-ok
   (slot clientId)
   (slot offerId)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Regles per avaluar criteris bàsics
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Preu acceptable
(defrule comprovar-preu-ok
   ?c <- (object (is-a Client) 
           (clientMaxPrice $?maxlist&:(> (length$ $?maxlist) 0)) 
           (priceFlexibility $?pflist&:(> (length$ $?pflist) 0)))
   ?o <- (object (is-a RentalOffer) (price $?plist&:(> (length$ $?plist) 0)))
   (test (<= (nth$ 1 $?plist) 
             (* (nth$ 1 $?maxlist) (+ 1 (/ (nth$ 1 $?pflist) 100.0)))))
   =>
   (assert (preu-ok (clientId (instance-name ?c)) (offerId (instance-name ?o))))
)

(defrule comprovar-preu-no-ok
   ?c <- (object (is-a Client) 
           (clientMaxPrice $?maxlist&:(> (length$ $?maxlist) 0)) 
           (priceFlexibility $?pflist&:(> (length$ $?pflist) 0)))
   ?o <- (object (is-a RentalOffer) (price $?plist&:(> (length$ $?plist) 0)))
   (test (> (nth$ 1 $?plist) 
            (* (nth$ 1 $?maxlist) (+ 1 (/ (nth$ 1 $?pflist) 100.0)))))
   =>
   (assert (criteri-no-complert (clientId (instance-name ?c)) (offerId (instance-name ?o)) 
           (criteri "Preu per sobre del màxim (amb flexibilitat)")))
)

;; Comprovació d'àrea
(defrule comprovar-area-ok
   ?c <- (object (is-a Client) (minArea $?minAlist&:(> (length$ $?minAlist) 0)))
   ?o <- (object (is-a RentalOffer) (hasProperty $?proplist&:(> (length$ $?proplist) 0)))
   (object (name ?prop&:(eq ?prop (nth$ 1 $?proplist))) (is-a Property) 
           (area $?arealist&:(> (length$ $?arealist) 0)))
   (test (>= (nth$ 1 $?arealist) (nth$ 1 $?minAlist)))
   =>
   (assert (area-ok (clientId (instance-name ?c)) (offerId (instance-name ?o))))
)

(defrule comprovar-area-no-ok
   ?c <- (object (is-a Client) (minArea $?minAlist&:(> (length$ $?minAlist) 0)))
   ?o <- (object (is-a RentalOffer) (hasProperty $?proplist&:(> (length$ $?proplist) 0)))
   (object (name ?prop&:(eq ?prop (nth$ 1 $?proplist))) (is-a Property) 
           (area $?arealist&:(> (length$ $?arealist) 0)))
   (test (< (nth$ 1 $?arealist) (nth$ 1 $?minAlist)))
   =>
   (bind ?area (nth$ 1 $?arealist))
   (bind ?minA (nth$ 1 $?minAlist))
   (assert (criteri-no-complert (clientId (instance-name ?c)) (offerId (instance-name ?o)) 
           (criteri (str-cat "Superfície insuficient: " ?area " m2 < sol·licitat " ?minA " m2"))))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Aspectes destacables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule destacar-economic
   ?o <- (object (is-a RentalOffer) (price $?plist&:(> (length$ $?plist) 0)))
   ?c <- (object (is-a Client) (clientMaxPrice $?maxlist&:(> (length$ $?maxlist) 0)))
   (test (< (nth$ 1 $?plist) (* (nth$ 1 $?maxlist) 0.85)))
   =>
   (assert (aspecte-destacable (offerId (instance-name ?o)) 
           (text "Preu significativament inferior al màxim del client")))
)

(defrule destacar-balco-moblat-mascotes
   ?o <- (object (is-a RentalOffer) (hasFeature $?features))
   (test (and (member$ [FeatureBalcony] $?features)
              (member$ [FeatureFurniture] $?features)
              (member$ [petsAllowed] $?features)))
   =>
   (assert (aspecte-destacable (offerId (instance-name ?o)) 
           (text "Balcó, moblat i permet mascotes")))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Avaluació final
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule avaluar-oferta
   (declare (salience -10))
   ?c <- (object (is-a Client))
   ?o <- (object (is-a RentalOffer))
   =>
   (bind ?cname (instance-name ?c))
   (bind ?oname (instance-name ?o))
   
   (bind ?raons (create$))
   (do-for-all-facts ((?m criteri-no-complert)) 
       (and (eq ?m:clientId ?cname) (eq ?m:offerId ?oname))
       (bind ?raons (insert$ ?raons (+ (length$ ?raons) 1) ?m:criteri))
   )
   
   (bind ?destacats (create$))
   (do-for-all-facts ((?h aspecte-destacable)) (eq ?h:offerId ?oname)
       (bind ?destacats (insert$ ?destacats (+ (length$ ?destacats) 1) ?h:text))
   )
   
   (if (= (length$ ?raons) 0) then
       (if (> (length$ ?destacats) 0) then
           (make-instance of Recommendation 
               (aboutOffer ?oname) 
               (recommendedFor ?cname) 
               (recommendationLevel "Molt recomanable"))
         else
           (make-instance of Recommendation 
               (aboutOffer ?oname) 
               (recommendedFor ?cname) 
               (recommendationLevel "Adequat"))
       )
     else
       (make-instance of Recommendation 
           (aboutOffer ?oname) 
           (recommendedFor ?cname) 
           (recommendationLevel "Parcialment adequat"))
   )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Presentació
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule imprimir-recomanacions
   ?r <- (object (is-a Recommendation)
           (aboutOffer $?oidlist&:(> (length$ $?oidlist) 0))
           (recommendedFor $?cidlist&:(> (length$ $?cidlist) 0))
           (recommendationLevel $?levlist&:(> (length$ $?levlist) 0)))
   =>
   (bind ?oid (nth$ 1 $?oidlist))
   (bind ?cid (nth$ 1 $?cidlist))
   (bind ?lev (nth$ 1 $?levlist))
   
   (printout t crlf "=== Recomanació per al client " ?cid " sobre l'oferta " ?oid " ===" crlf)
   (printout t "Nivell: " ?lev crlf)
   
   (bind ?raons (create$))
   (do-for-all-facts ((?u criteri-no-complert)) 
       (and (eq ?u:clientId ?cid) (eq ?u:offerId ?oid))
       (bind ?raons (insert$ ?raons (+ (length$ ?raons) 1) ?u:criteri))
   )
   
   (if (> (length$ ?raons) 0) then
       (printout t "Criteris no complerts:" crlf)
       (foreach ?r ?raons (printout t " - " ?r crlf))
     else
       (printout t "Criteris no complerts: cap" crlf)
   )
   
   (bind ?destacats (create$))
   (do-for-all-facts ((?h aspecte-destacable)) (eq ?h:offerId ?oid)
       (bind ?destacats (insert$ ?destacats (+ (length$ ?destacats) 1) ?h:text))
   )
   
   (if (> (length$ ?destacats) 0) then
       (printout t "Aspectes destacables:" crlf)
       (foreach ?h ?destacats (printout t " * " ?h crlf))
     else
       (printout t "Aspectes destacables: cap en particular" crlf)
   )
   (printout t "-------------------------------------------" crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Dades d'exemple utilitzant definstances
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(definstances dades-exemple
    ;; Client
    ([Client1] of Client
        (clientAge 30)
        (clientMaxPrice 950.0)
        (priceFlexibility 10)
        (minArea 60)
        (minDorms 2)
        (needsDoubleBedroom yes)
        (wantsGreenArea yes)
        (wantsHealthCenter yes)
        (wantsNightLife no)
        (wantsSchool no)
        (wantsSupermarket yes)
        (wantsTransport yes)
    )
    
    ;; Propietats
    ([Property1] of Property
        (address "C/ Falsa 123")
        (area 75)
    )
    
    ([Property2] of Property
        (address "Av. Exemple 50")
        (area 55)
    )
    
    ([Property3] of Property
        (address "Plaça Central 2")
        (area 85)
    )
    
    ;; Ofertes
    ([Offer1] of RentalOffer
        (hasProperty [Property1])
        (price 900.0)
        (minMonths 12)
        (maxPeople 4)
        (hasFeature [FeatureBalcony] [FeatureFurniture] [petsAllowed])
    )
    
    ([Offer2] of RentalOffer
        (hasProperty [Property2])
        (price 700.0)
        (minMonths 6)
        (maxPeople 2)
    )
    
    ([Offer3] of RentalOffer
        (hasProperty [Property3])
        (price 1200.0)
        (minMonths 12)
        (maxPeople 6)
    )
)
