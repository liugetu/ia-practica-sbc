;;; ---------------------------------------------------------
;;; expert2.clp
;;; Sistema expert de recomanació de lloguers
;;; Versió millorada que compleix amb els requisits de l'enunciat:
;;;   - Parcialmente adecuado: No se cumplen 1-2 criterios (indicando cuáles)
;;;   - Adecuado: Cumple todos los requerimientos
;;;   - Muy recomendable: Cumple todos + características destacables
;;;
;;; Es pressuposa:
;;;   - Carregada l'ontologia (ontologia.clp)
;;;   - Carregades les instàncies d'exemple (inicialització.clp)
;;; ---------------------------------------------------------

;;; ---------------------------------------------------------
;;; FUNCIONS PER CÁLCUL AUTOMÀTIC DE PROXIMITATS
;;; ---------------------------------------------------------

(deffunction manhattan-distance (?lat1 ?lon1 ?lat2 ?lon2)
  "Calcula la distancia Manhattan entre dues coordenades"
  (+ (abs (- ?lat1 ?lat2)) (abs (- ?lon1 ?lon2)))
)

(deffunction get-distance-category (?distance)
  "Determina la categoria de distància: 0=prop(<0.010), 1=mig(0.010-0.050), 2=lluny(>=0.050)"
  (if (< ?distance 0.010) then 0
   else (if (< ?distance 0.050) then 1
    else 2))
)

;;; ---------------------------------------------------------
;;; REGLES PER GENERAR PROXIMITATS AUTOMÀTIQUES
;;; ---------------------------------------------------------

(defrule calcular-proximitats
  "Calcula automàticament les proximitats entre propietats i serveis"
  (declare (salience 30))
  (object (is-a Property) 
          (name ?prop-name)
          (locatedAt ?prop-location))
  (object (is-a Service)
          (name ?service-name)  
          (ServiceLocatedAt ?service-location))
  (object (is-a Location)
          (name ?prop-location)
          (latitude ?prop-lat)
          (longitude ?prop-lon))
  (object (is-a Location)
          (name ?service-location)
          (latitude ?serv-lat)
          (longitude ?serv-lon))
  
  ;; Verificar que no existeix ja una proximitat per aquesta combinació
  (not (object (is-a Proximity) 
               (nearProperty ?prop-name)
               (nearService ?service-name)))
  =>
  
  ;; Calcular distància Manhattan
  (bind ?distance (manhattan-distance ?prop-lat ?prop-lon ?serv-lat ?serv-lon))
  
  ;; Determinar categoria
  (bind ?category (get-distance-category ?distance))
  
  ;; Crear instància de proximitat amb nom generat automàticament
  (make-instance (gensym*)
    of Proximity
    (nearProperty ?prop-name)
    (nearService ?service-name)
    (distanceCategory ?category))
)

;;; ---------------------------------------------------------
;;; PLANTILLES AUXILIARS
;;; ---------------------------------------------------------

(deftemplate avaluacio
   (slot client)                    ; nom d'instància de Client
   (slot oferta)                    ; nom d'instància de RentalOffer
   (slot punts (type NUMBER) (default 0))
   (multislot match-features)

   ;; Flags per assegurar que cada criteri es processa una sola vegada
   (slot preu-avaluat        (type SYMBOL) (default FALSE))
   (slot mida-avaluada       (type SYMBOL) (default FALSE))
   (slot dorms-avaluats      (type SYMBOL) (default FALSE))
   (slot qualitat-avaluada   (type SYMBOL) (default FALSE))
   (slot verd-avaluat        (type SYMBOL) (default FALSE))
   (slot salut-avaluada      (type SYMBOL) (default FALSE))
   (slot nit-avaluada        (type SYMBOL) (default FALSE))
   (slot escola-avaluada     (type SYMBOL) (default FALSE))
   (slot estadi-avaluat      (type SYMBOL) (default FALSE))
   (slot super-avaluat       (type SYMBOL) (default FALSE))
   (slot transport-avaluat   (type SYMBOL) (default FALSE))
   (slot soroll-avaluat      (type SYMBOL) (default FALSE))
   (slot habitacio-doble-avaluada (type SYMBOL) (default FALSE))
   (slot mesos-avaluats      (type SYMBOL) (default FALSE))
)

;;; Plantilles per rastrejar criteris no complerts i característiques destacades
(deftemplate criteri-no-complert
   (slot client)
   (slot oferta)
   (slot descripcio (type STRING))
)

(deftemplate caracteristica-destacada
   (slot client)
   (slot oferta)
   (slot descripcio (type STRING))
)

;;; ---------------------------------------------------------
;;; Generació automàtica d'avaluacions per a totes les parelles
;;; (Client, RentalOffer) existents
;;; ---------------------------------------------------------

(defrule crear-avaluacio-client-oferta
   (declare (salience 20))
   (object (is-a Client) (name ?c))
   (object (is-a RentalOffer) (name ?o))
   (not (avaluacio (client ?c) (oferta ?o)))
   =>
   (assert (avaluacio (client ?c)
                      (oferta ?o)
                      (punts 0)
                      (match-features)
                      (preu-avaluat FALSE)
                      (mida-avaluada FALSE)
                      (dorms-avaluats FALSE)
                      (qualitat-avaluada FALSE)
                      (verd-avaluat FALSE)
                      (salut-avaluada FALSE)
                      (nit-avaluada FALSE)
                      (escola-avaluada FALSE)
                      (estadi-avaluat FALSE)
                      (super-avaluat FALSE)
                      (transport-avaluat FALSE)
                      (soroll-avaluat FALSE)
                      (habitacio-doble-avaluada FALSE)
                      (mesos-avaluats FALSE)))
)

;;; ---------------------------------------------------------
;;; CRITERIS DE PREU (RESTRICTIUS)
;;; ---------------------------------------------------------

(defrule criteri-preu
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (preu-avaluat FALSE))
   (object (is-a Client)
           (name ?c)
           (clientMaxPrice ?max)
           (minReasonablePrice ?minR)
           (priceFlexibility ?flex))
   (object (is-a RentalOffer)
           (name ?o)
           (price ?preu))
   =>
   (bind ?nova ?p)
   (bind ?maxFlexible (* ?max (+ 1 (/ ?flex 100.0))))

   ;; CRITERIO RESTRICTIVO: Preu per sobre del màxim amb flexibilitat
   (if (> ?preu ?maxFlexible) then
      ;; NO COMPLEIX: Massa car
      (assert (criteri-no-complert 
               (client ?c) 
               (oferta ?o) 
               (descripcio (str-cat "Preu massa alt: " ?preu "€ > " ?maxFlexible 
                                   "€ (màxim amb flexibilitat)"))))
      (bind ?nova (- ?nova 100))
   else
      ;; COMPLEIX el criteri de preu màxim
      (if (<= ?preu ?max) then
         (bind ?nova (+ ?nova 50))
         
         ;; CARACTERÍSTICA DESTACADA: Preu molt per sota del màxim
         (if (< ?preu (* ?max 0.80)) then
            (bind ?percentatge (integer (* 100 (- 1 (/ ?preu ?max)))))
            (assert (caracteristica-destacada
                     (client ?c)
                     (oferta ?o)
                     (descripcio (str-cat "Preu excel·lent: " ?preu 
                                         "€, un " ?percentatge
                                         "% per sota del màxim"))))
         )
      else
         ;; Dins de la flexibilitat però per sobre del màxim estricte
         (bind ?nova (+ ?nova 25))
      )
   )

   ;; CRITERIO RESTRICTIVO: Preu sospitosament baix
   (if (< ?preu ?minR) then
      (assert (criteri-no-complert 
               (client ?c) 
               (oferta ?o) 
               (descripcio (str-cat "Preu sospitosament baix: " ?preu 
                                   "€ < " ?minR "€ (mínim raonable)"))))
      (bind ?nova (- ?nova 10))
   )

   (modify ?a (punts ?nova)
            (preu-avaluat TRUE))
)

;;; ---------------------------------------------------------
;;; CRITERIS D'ÀREA (RESTRICTIU)
;;; ---------------------------------------------------------

(defrule criteri-mida
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (mida-avaluada FALSE))
   (object (is-a Client)
           (name ?c)
           (minArea ?minA))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Property)
           (name ?prop)
           (area ?area))
   =>
   (bind ?nova ?p)
   (bind ?area-ratio (/ ?area ?minA))
   
   ;; CRITERIO RESTRICTIVO: Àrea insuficient
   (if (< ?area ?minA) then
      (assert (criteri-no-complert 
               (client ?c) 
               (oferta ?o) 
               (descripcio (str-cat "Superfície insuficient: " ?area 
                                   " m² < " ?minA " m² sol·licitats"))))
      (bind ?calc-penalty (* 10 (- 1 ?area-ratio)))
      (bind ?extra-penalty (if (< ?calc-penalty 10) then ?calc-penalty else 10))
      (bind ?area-penalty (+ -20 (- ?extra-penalty)))
      (bind ?nova (+ ?nova ?area-penalty))
   else
      ;; COMPLEIX el criteri d'àrea
      (bind ?calc-bonus (* 10 (- ?area-ratio 1)))
      (bind ?extra-bonus (if (< ?calc-bonus 10) then ?calc-bonus else 10))
      (bind ?area-bonus (+ 20 ?extra-bonus))
      (bind ?nova (+ ?nova ?area-bonus))
      
      ;; CARACTERÍSTICA DESTACADA: Àrea significativament superior
      (if (> ?area (* ?minA 1.25)) then
         (bind ?percentatge-area (integer (* 100 (- ?area-ratio 1))))
         (assert (caracteristica-destacada
                  (client ?c)
                  (oferta ?o)
                  (descripcio (str-cat "Superfície generosa: " ?area 
                                      " m², un " ?percentatge-area
                                      "% més gran del sol·licitat"))))
      )
   )

   (modify ?a (punts ?nova)
            (mida-avaluada TRUE))
)

;;; ---------------------------------------------------------
;;; CRITERIS DE DORMITORIS (RESTRICTIU)
;;; ---------------------------------------------------------

(defrule criteri-dormitoris
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (dorms-avaluats FALSE))
   (object (is-a Client)
           (name ?c)
           (minDorms ?minD))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Property)
           (name ?prop)
           (hasRoom $?habitacions))
   =>
   (bind ?nova ?p)
   (bind ?ndorms (length$ ?habitacions))
   
   ;; CRITERIO RESTRICTIVO: Dormitoris insuficients
   (if (< ?ndorms ?minD) then
      (assert (criteri-no-complert 
               (client ?c) 
               (oferta ?o) 
               (descripcio (str-cat "Dormitoris insuficients: " ?ndorms 
                                   " < " ?minD " sol·licitats"))))
      (bind ?nova (- ?nova 30))
   else
      ;; COMPLEIX el criteri de dormitoris
      (bind ?nova (+ ?nova 30))
      
      ;; CARACTERÍSTICA DESTACADA: Més dormitoris dels necessaris
      (if (> ?ndorms ?minD) then
         (assert (caracteristica-destacada
                  (client ?c)
                  (oferta ?o)
                  (descripcio (str-cat "Dormitoris extra: " ?ndorms 
                                      " (sol·licitats: " ?minD ")"))))
      )
   )

   (modify ?a (punts ?nova)
            (dorms-avaluats TRUE))
)

;;; ---------------------------------------------------------
;;; CRITERI DE QUALITAT DE L'HABITATGE (NO RESTRICTIU)
;;; ---------------------------------------------------------

(defrule criteri-qualitat-habitatge
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (qualitat-avaluada FALSE))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Property)
           (name ?prop)
           (state ?estat)
           (naturalLight ?llum))
   =>
   (bind ?nova ?p)

   ;; Estat general de l'immoble (millora la puntuació però no és restrictiu)
   (if (>= ?estat 4) then
      (bind ?nova (+ ?nova 10))
      (assert (caracteristica-destacada
               (client ?c)
               (oferta ?o)
               (descripcio "Estat excel·lent de l'habitatge")))
   else
      (if (<= ?estat 2) then
          (bind ?nova (- ?nova 10))
      )
   )

   ;; Llum natural (millora la puntuació però no és restrictiu)
   (if (= ?llum 3) then
      (bind ?nova (+ ?nova 10))
      (assert (caracteristica-destacada
               (client ?c)
               (oferta ?o)
               (descripcio "Excel·lent llum natural tot el dia")))
   else
      (if (or (= ?llum 1) (= ?llum 2)) then
         (bind ?nova (+ ?nova 5))
      )
   )

   (modify ?a (punts ?nova)
            (qualitat-avaluada TRUE))
)

;;; ---------------------------------------------------------
;;; COINCIDÈNCIA DE CARACTERÍSTIQUES (NO RESTRICTIU)
;;; ---------------------------------------------------------

(defrule coincidencia-caracteristica
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (match-features $?mf))
   (object (is-a Client)
           (name ?c)
           (prefersFeature $?pf1 ?f $?pf2))
   (object (is-a RentalOffer)
           (name ?o)
           (hasFeature $?hf1 ?f $?hf2))
   (test (not (member$ ?f ?mf)))
   =>
   (modify ?a
           (punts (+ ?p 5))
           (match-features (create$ ?mf ?f)))
   
   ;; Si coincideixen moltes característiques, és destacable
   (if (> (+ (length$ ?mf) 1) 3) then
      (assert (caracteristica-destacada
               (client ?c)
               (oferta ?o)
               (descripcio (str-cat "Múltiples característiques desitjades ("
                                   (+ (length$ ?mf) 1) " coincidències)"))))
   )
)

;;; ---------------------------------------------------------
;;; CRITERIS DE SERVEIS I PROXIMITAT (RESTRICTIUS/NO RESTRICTIUS segons el servei)
;;; ---------------------------------------------------------

;;; Funció per obtenir la preferència del client per un tipus de servei
(deffunction get-service-preference (?client ?service-type)
  "Retorna la preferència del client pel tipus de servei donat"
  (bind ?client-obj (instance-address * ?client))
  (switch ?service-type
    (case GreenArea then (send ?client-obj get-wantsGreenArea))
    (case HealthCenter then (send ?client-obj get-wantsHealthCenter))
    (case Nightlife then (send ?client-obj get-wantsNightLife))
    (case School then (send ?client-obj get-wantsSchool))
    (case Stadium then (send ?client-obj get-wantsStadium))
    (case Supermarket then (send ?client-obj get-wantsSupermarket))
    (case Transport then (send ?client-obj get-wantsTransport))
    (default indiferent))
)

;;; Funció per obtenir els punts base segons el tipus de servei
(deffunction get-service-points (?service-type)
  "Retorna els punts base per al tipus de servei"
  (switch ?service-type
    (case GreenArea then 10)
    (case HealthCenter then 12)
    (case Nightlife then 8)
    (case School then 10)
    (case Stadium then 8)
    (case Supermarket then 11)
    (case Transport then 11)
    (default 10))
)

;;; Funció per determinar si un servei és restrictiu (obligatori)
(deffunction is-restrictive-service (?service-type)
  "Determina si un servei és restrictiu quan el client el sol·licita"
  (switch ?service-type
    (case Transport then TRUE)      ; Transport és restrictiu si es sol·licita
    (case School then TRUE)         ; Escola és restrictiu per famílies
    (default FALSE))                ; La resta són preferències
)

;;; Funció per obtenir el nom llegible del servei
(deffunction get-service-name (?service-type)
  "Retorna el nom llegible del tipus de servei"
  (switch ?service-type
    (case GreenArea then "zona verda")
    (case HealthCenter then "centre de salut")
    (case Nightlife then "vida nocturna")
    (case School then "escola")
    (case Stadium then "estadi")
    (case Supermarket then "supermercat")
    (case Transport then "transport públic")
    (default "servei"))
)

;;; Funció per obtenir el flag d'avaluació corresponent
(deffunction get-evaluation-flag (?service-type)
  "Retorna el nom del flag d'avaluació per al tipus de servei"
  (switch ?service-type
    (case GreenArea then verd-avaluat)
    (case HealthCenter then salut-avaluada)
    (case Nightlife then nit-avaluada)
    (case School then escola-avaluada)
    (case Stadium then estadi-avaluat)
    (case Supermarket then super-avaluat)
    (case Transport then transport-avaluat)
    (default servei-avaluat))
)

;;; Regla genèrica per serveis desitjats - proximitat categoria 0 (prop)
(defrule criteri-servei-positiu-prop
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 0))
   (object (is-a ?service-type&:(subclassp ?service-type Service))
           (name ?srv))
   
   (test (neq (fact-slot-value ?a (get-evaluation-flag ?service-type)) TRUE))
   (test (eq (get-service-preference ?c ?service-type) si))
   =>
   (bind ?base-points (get-service-points ?service-type))
   (bind ?flag (get-evaluation-flag ?service-type))
   
   ;; Usar eval para modificar dinámicamente el slot
   (eval (str-cat "(modify ?a (punts (+ ?p ?base-points)) (" ?flag " TRUE))"))
   
   ;; CARACTERÍSTICA DESTACADA: Servei desitjat molt a prop
   (assert (caracteristica-destacada
            (client ?c)
            (oferta ?o)
            (descripcio (str-cat (upcase (sub-string 1 1 (get-service-name ?service-type)))
                                (sub-string 2 (str-length (get-service-name ?service-type)) 
                                            (get-service-name ?service-type))
                                " molt a prop"))))
)

;;; Regla genèrica per serveis desitjats - proximitat categoria 1 (mitja)
(defrule criteri-servei-positiu-mitja
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 1))
   (object (is-a ?service-type&:(subclassp ?service-type Service))
           (name ?srv))
   
   (test (neq (fact-slot-value ?a (get-evaluation-flag ?service-type)) TRUE))
   (test (eq (get-service-preference ?c ?service-type) si))
   =>
   (bind ?base-points (get-service-points ?service-type))
   (bind ?half-points (div ?base-points 2))
   (bind ?flag (get-evaluation-flag ?service-type))
   
   ;; Usar eval para modificar dinámicamente el slot
   (eval (str-cat "(modify ?a (punts (+ ?p ?half-points)) (" ?flag " TRUE))"))
   
   ;; CRITERIO RESTRICTIVO per serveis crítics a distància mitja
   (if (is-restrictive-service ?service-type) then
      (assert (criteri-no-complert
               (client ?c)
               (oferta ?o)
               (descripcio (str-cat (upcase (sub-string 1 1 (get-service-name ?service-type)))
                                   (sub-string 2 (str-length (get-service-name ?service-type)) 
                                               (get-service-name ?service-type))
                                   " a distància mitja (no prou proper)"))))
   )
)

;;; Regla genèrica per serveis desitjats - proximitat categoria 2 (lluny)
(defrule criteri-servei-positiu-lluny
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 2))
   (object (is-a ?service-type&:(subclassp ?service-type Service))
           (name ?srv))
   
   (test (neq (fact-slot-value ?a (get-evaluation-flag ?service-type)) TRUE))
   (test (eq (get-service-preference ?c ?service-type) si))
   =>
   (bind ?base-points (get-service-points ?service-type))
   (bind ?quarter-points (div ?base-points 4))
   (bind ?flag (get-evaluation-flag ?service-type))
   
   ;; Usar eval para modificar dinámicamente el slot
   (eval (str-cat "(modify ?a (punts (+ ?p ?quarter-points)) (" ?flag " TRUE))"))
   
   ;; CRITERIO RESTRICTIVO per serveis crítics lluny
   (if (is-restrictive-service ?service-type) then
      (assert (criteri-no-complert
               (client ?c)
               (oferta ?o)
               (descripcio (str-cat (upcase (sub-string 1 1 (get-service-name ?service-type)))
                                   (sub-string 2 (str-length (get-service-name ?service-type)) 
                                               (get-service-name ?service-type))
                                   " massa lluny"))))
   )
)

;;; ---------------------------------------------------------
;;; CRITERI DE SOROLL (NO RESTRICTIU però penalitzador)
;;; ---------------------------------------------------------

(defrule criteri-soroll-general
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (soroll-avaluat FALSE))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 0))
   (object (is-a Service)
           (name ?srv)
           (serviceNoiseLevel ?nivell&:(> ?nivell 0)))
   =>
   (bind ?penalitzacio (* ?nivell 5))
   (modify ?a (punts (- ?p ?penalitzacio))
            (soroll-avaluat TRUE))
)

;;; ---------------------------------------------------------
;;; CRITERI DE HABITACIÓ DOBLE (RESTRICTIU)
;;; ---------------------------------------------------------

(defrule criteri-habitacio-doble
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (habitacio-doble-avaluada FALSE))
   (object (is-a Client)
           (name ?c)
           (needsDoubleBedroom ?vol-doble))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Property)
           (name ?prop)
           (hasRoom $?habitacions))
   =>
   (bind ?nova ?p)
   
   ;; Verificar si té habitació doble
   (bind ?te-doble FALSE)
   (progn$ (?room ?habitacions)
      (bind ?room-inst (instance-address * ?room))
      (if (neq ?room-inst FALSE) then
         (if (eq (send ?room-inst get-isDouble) TRUE) then
            (bind ?te-doble TRUE))))
   
   ;; CRITERIO RESTRICTIVO: Necessita habitació doble però no la té
   (if (eq ?vol-doble si) then
      (if (eq ?te-doble TRUE) then
         (bind ?nova (+ ?nova 10))
      else
         (assert (criteri-no-complert 
                  (client ?c) 
                  (oferta ?o) 
                  (descripcio "No té habitació doble (requerida)")))
         (bind ?nova (- ?nova 10))
      )
   )
   
   (modify ?a (punts ?nova)
            (habitacio-doble-avaluada TRUE))
)

;;; ---------------------------------------------------------
;;; CRITERI DE DURADA MÍNIMA DE CONTRACTE (RESTRICTIU)
;;; ---------------------------------------------------------

(defrule criteri-duracio-minima
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (mesos-avaluats FALSE))
   (object (is-a Client)
           (name ?c)
           (minMonthsClient ?minMesesClient))
   (object (is-a RentalOffer)
           (name ?o)
           (minMonths ?minMesesOferta))
   =>
   (bind ?nova ?p)
   
   ;; CRITERIO RESTRICTIVO: L'oferta requereix més mesos dels que el client vol
   (if (> ?minMesesOferta ?minMesesClient) then
      (assert (criteri-no-complert 
               (client ?c) 
               (oferta ?o) 
               (descripcio (str-cat "Requereix " ?minMesesOferta 
                                   " mesos mínim (client vol " 
                                   ?minMesesClient " mesos)"))))
      (bind ?nova (- ?nova 20))
   else
      ;; COMPLEIX el criteri de durada
      (bind ?nova (+ ?nova 15))
      
      ;; CARACTERÍSTICA DESTACADA: Durada molt flexible
      (if (<= ?minMesesOferta (* ?minMesesClient 0.5)) then
         (assert (caracteristica-destacada
                  (client ?c)
                  (oferta ?o)
                  (descripcio (str-cat "Contracte molt flexible (" ?minMesesOferta 
                                      " mesos mínim)"))))
      )
   )
   
   (modify ?a (punts ?nova)
            (mesos-avaluats TRUE))
)

;;; ---------------------------------------------------------
;;; CONVERSIÓ DE PUNTS -> RECOMANACIÓ
;;; Segons els requisits de l'enunciat:
;;;   - Parcialmente adecuado: 1-2 criteris no complerts
;;;   - Adecuado: 0 criteris no complerts, poques característiques destacades
;;;   - Muy recomendable: 0 criteris no complerts + característiques destacades
;;; ---------------------------------------------------------

(defrule generar-recomanacio
   (declare (salience 0))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p))
   (not (object (is-a Recommendation)
                (aboutOffer ?o)
                (recommendedFor ?c)))
   =>
   ;; Comptar criteris no complerts
   (bind ?num-no-complerts 0)
   (do-for-all-facts ((?cnc criteri-no-complert))
      (and (eq ?cnc:client ?c) (eq ?cnc:oferta ?o))
      (bind ?num-no-complerts (+ ?num-no-complerts 1)))
   
   ;; Comptar característiques destacades
   (bind ?num-destacades 0)
   (do-for-all-facts ((?cd caracteristica-destacada))
      (and (eq ?cd:client ?c) (eq ?cd:oferta ?o))
      (bind ?num-destacades (+ ?num-destacades 1)))
   
   ;; Determinar nivell de recomanació segons l'enunciat
   (bind ?nivell
      (if (> ?num-no-complerts 2) then
         "No recomanable"
      else
         (if (> ?num-no-complerts 0) then
            "Parcialment adequat"
         else
            (if (>= ?num-destacades 3) then
               "Molt recomanable"
            else
               "Adequat"))))

   (make-instance (gensym*)
      of Recommendation
      (aboutOffer ?o)
      (recommendedFor ?c)
      (recommendationLevel ?nivell))
)

;;; ---------------------------------------------------------
;;; PRESENTACIÓ DE RESULTATS
;;; ---------------------------------------------------------

(defrule imprimir-recomanacio
   (declare (salience -10))
   ?r <- (object (is-a Recommendation)
                 (aboutOffer ?o)
                 (recommendedFor ?c)
                 (recommendationLevel ?nivell))
   =>
   (printout t crlf "========================================" crlf)
   (printout t "RECOMANACIÓ" crlf)
   (printout t "========================================" crlf)
   (printout t "Client: " ?c crlf)
   (printout t "Oferta: " ?o crlf)
   (printout t "Nivell: " ?nivell crlf)
   (printout t "----------------------------------------" crlf)
   
   ;; Mostrar criteris no complerts (si n'hi ha)
   (bind ?num-no-complerts 0)
   (do-for-all-facts ((?cnc criteri-no-complert))
      (and (eq ?cnc:client ?c) (eq ?cnc:oferta ?o))
      (if (= ?num-no-complerts 0) then
         (printout t "Criteris NO complerts:" crlf))
      (bind ?num-no-complerts (+ ?num-no-complerts 1))
      (printout t "  " ?num-no-complerts ". " ?cnc:descripcio crlf))
   
   (if (= ?num-no-complerts 0) then
      (printout t "✓ Compleix tots els criteris restrictius" crlf))
   
   ;; Mostrar característiques destacades (si n'hi ha)
   (bind ?num-destacades 0)
   (do-for-all-facts ((?cd caracteristica-destacada))
      (and (eq ?cd:client ?c) (eq ?cd:oferta ?o))
      (if (= ?num-destacades 0) then
         (printout t crlf "Característiques destacables:" crlf))
      (bind ?num-destacades (+ ?num-destacades 1))
      (printout t "  ★ " ?cd:descripcio crlf))
   
   (if (= ?num-destacades 0) then
      (printout t crlf "No té característiques especialment destacables" crlf))
   
   (printout t "========================================" crlf)
)

;;; ---------------------------------------------------------
;;; Fi de expert_mejorado.clp
;;; ---------------------------------------------------------
