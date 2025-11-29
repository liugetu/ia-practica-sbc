;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Recomendador de alquileres - CLIPS v2
;; Versión que utiliza ontologia.clp (defclass COOL)
;; - Genera recomendaciones: Muy recomendable / Adecuado / Parcialmente adecuado
;; - Indica criterios no cumplidos y aspectos que destacan
;;
;; USO:
;;   clips
;;   (load "ontologia.clp")
;;   (load "prova_v2.clp")
;;   (reset)
;;   (run)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Templates auxiliares para el razonamiento
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate unmet-criterion
   (slot clientId)
   (slot offerId)
   (slot criterion)
)

(deftemplate highlight
   (slot offerId)
   (slot text)
)

(deftemplate price-ok
   (slot clientId)
   (slot offerId)
)

(deftemplate area-ok
   (slot clientId)
   (slot offerId)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Reglas para evaluar criterios básicos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Precio aceptable
(defrule check-price-ok
   ?c <- (object (is-a Client) 
           (clientMaxPrice $?maxlist&:(> (length$ $?maxlist) 0)) 
           (priceFlexibility $?pflist&:(> (length$ $?pflist) 0)))
   ?o <- (object (is-a RentalOffer) (price $?plist&:(> (length$ $?plist) 0)))
   (test (<= (nth$ 1 $?plist) 
             (* (nth$ 1 $?maxlist) (+ 1 (/ (nth$ 1 $?pflist) 100.0)))))
   =>
   (assert (price-ok (clientId (instance-name ?c)) (offerId (instance-name ?o))))
)

(defrule check-price-not-ok
   ?c <- (object (is-a Client) 
           (clientMaxPrice $?maxlist&:(> (length$ $?maxlist) 0)) 
           (priceFlexibility $?pflist&:(> (length$ $?pflist) 0)))
   ?o <- (object (is-a RentalOffer) (price $?plist&:(> (length$ $?plist) 0)))
   (test (> (nth$ 1 $?plist) 
            (* (nth$ 1 $?maxlist) (+ 1 (/ (nth$ 1 $?pflist) 100.0)))))
   =>
   (assert (unmet-criterion (clientId (instance-name ?c)) (offerId (instance-name ?o)) 
           (criterion "Precio por encima del máximo (con flexibilidad)")))
)

;; Area check
(defrule check-area-ok
   ?c <- (object (is-a Client) (minArea $?minAlist&:(> (length$ $?minAlist) 0)))
   ?o <- (object (is-a RentalOffer) (hasProperty $?proplist&:(> (length$ $?proplist) 0)))
   (object (name ?prop&:(eq ?prop (nth$ 1 $?proplist))) (is-a Property) 
           (area $?arealist&:(> (length$ $?arealist) 0)))
   (test (>= (nth$ 1 $?arealist) (nth$ 1 $?minAlist)))
   =>
   (assert (area-ok (clientId (instance-name ?c)) (offerId (instance-name ?o))))
)

(defrule check-area-not-ok
   ?c <- (object (is-a Client) (minArea $?minAlist&:(> (length$ $?minAlist) 0)))
   ?o <- (object (is-a RentalOffer) (hasProperty $?proplist&:(> (length$ $?proplist) 0)))
   (object (name ?prop&:(eq ?prop (nth$ 1 $?proplist))) (is-a Property) 
           (area $?arealist&:(> (length$ $?arealist) 0)))
   (test (< (nth$ 1 $?arealist) (nth$ 1 $?minAlist)))
   =>
   (bind ?area (nth$ 1 $?arealist))
   (bind ?minA (nth$ 1 $?minAlist))
   (assert (unmet-criterion (clientId (instance-name ?c)) (offerId (instance-name ?o)) 
           (criterion (str-cat "Superficie insuficiente: " ?area " m2 < pedido " ?minA " m2"))))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Highlights
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule highlight-cheap
   ?o <- (object (is-a RentalOffer) (price $?plist&:(> (length$ $?plist) 0)))
   ?c <- (object (is-a Client) (clientMaxPrice $?maxlist&:(> (length$ $?maxlist) 0)))
   (test (< (nth$ 1 $?plist) (* (nth$ 1 $?maxlist) 0.85)))
   =>
   (assert (highlight (offerId (instance-name ?o)) 
           (text "Precio significativamente inferior al máximo del cliente")))
)

(defrule highlight-balcony-furnished-pets
   ?o <- (object (is-a RentalOffer) (hasFeature $?features))
   (test (and (member$ [FeatureBalcony] $?features)
              (member$ [FeatureFurniture] $?features)
              (member$ [petsAllowed] $?features)))
   =>
   (assert (highlight (offerId (instance-name ?o)) 
           (text "Balcón, amueblado y permite mascotas")))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Final evaluation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule evaluate-offer
   (declare (salience -10))
   ?c <- (object (is-a Client))
   ?o <- (object (is-a RentalOffer))
   =>
   (bind ?cname (instance-name ?c))
   (bind ?oname (instance-name ?o))
   
   (bind ?reasons (create$))
   (do-for-all-facts ((?m unmet-criterion)) 
       (and (eq ?m:clientId ?cname) (eq ?m:offerId ?oname))
       (bind ?reasons (insert$ ?reasons (+ (length$ ?reasons) 1) ?m:criterion))
   )
   
   (bind ?hlist (create$))
   (do-for-all-facts ((?h highlight)) (eq ?h:offerId ?oname)
       (bind ?hlist (insert$ ?hlist (+ (length$ ?hlist) 1) ?h:text))
   )
   
   (if (= (length$ ?reasons) 0) then
       (if (> (length$ ?hlist) 0) then
           (make-instance of Recommendation 
               (aboutOffer ?oname) 
               (recommendedFor ?cname) 
               (recommendationLevel "Muy recomendable"))
         else
           (make-instance of Recommendation 
               (aboutOffer ?oname) 
               (recommendedFor ?cname) 
               (recommendationLevel "Adecuado"))
       )
     else
       (make-instance of Recommendation 
           (aboutOffer ?oname) 
           (recommendedFor ?cname) 
           (recommendationLevel "Parcialmente adecuado"))
   )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Presentation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule print-recommendations
   ?r <- (object (is-a Recommendation)
           (aboutOffer $?oidlist&:(> (length$ $?oidlist) 0))
           (recommendedFor $?cidlist&:(> (length$ $?cidlist) 0))
           (recommendationLevel $?levlist&:(> (length$ $?levlist) 0)))
   =>
   (bind ?oid (nth$ 1 $?oidlist))
   (bind ?cid (nth$ 1 $?cidlist))
   (bind ?lev (nth$ 1 $?levlist))
   
   (printout t crlf "=== Recomendación para cliente " ?cid " sobre oferta " ?oid " ===" crlf)
   (printout t "Nivel: " ?lev crlf)
   
   (bind ?reasons (create$))
   (do-for-all-facts ((?u unmet-criterion)) 
       (and (eq ?u:clientId ?cid) (eq ?u:offerId ?oid))
       (bind ?reasons (insert$ ?reasons (+ (length$ ?reasons) 1) ?u:criterion))
   )
   
   (if (> (length$ ?reasons) 0) then
       (printout t "Criterios no cumplidos:" crlf)
       (foreach ?r ?reasons (printout t " - " ?r crlf))
     else
       (printout t "Criterios no cumplidos: ninguno" crlf)
   )
   
   (bind ?highlights (create$))
   (do-for-all-facts ((?h highlight)) (eq ?h:offerId ?oid)
       (bind ?highlights (insert$ ?highlights (+ (length$ ?highlights) 1) ?h:text))
   )
   
   (if (> (length$ ?highlights) 0) then
       (printout t "Aspectos destacables:" crlf)
       (foreach ?h ?highlights (printout t " * " ?h crlf))
     else
       (printout t "Aspectos destacables: ninguno particular" crlf)
   )
   (printout t "-------------------------------------------" crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Datos de ejemplo usando definstances
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(definstances example-data
    ;; Cliente
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
    
    ;; Propiedades
    ([Property1] of Property
        (address "C/ Falsa 123")
        (area 75)
    )
    
    ([Property2] of Property
        (address "Av. Ejemplo 50")
        (area 55)
    )
    
    ([Property3] of Property
        (address "Plaza Central 2")
        (area 85)
    )
    
    ;; Ofertas
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
