;;; ---------------------------------------------------------
;;; expert.clp
;;; Sistema expert de recomanació de lloguers
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
  "Determina la categoria de distància: 0=prop(<0.005), 1=mig(0.005-0.009), 2=lluny(>=0.010)"
  (if (< ?distance 0.005) then 0
   else (if (< ?distance 0.010) then 1
    else 2))
)

;;; ---------------------------------------------------------
;;; REGLES PER GENERAR PROXIMITATS AUTOMÀTIQUES
;;; ---------------------------------------------------------

(defrule calcular-proximitats
  "Calcula automàticament les proximitats entre propietats i serveis"
  (declare (salience 30))
  (object (is-a Property) 
          (OBJECT ?prop-name)
          (locatedAt ?prop-location))
  (object (is-a Service)
          (OBJECT ?service-name)  
          (ServiceLocatedAt ?service-location))
  (object (is-a Location)
          (OBJECT ?prop-location)
          (latitude ?prop-lat)
          (longitude ?prop-lon))
  (object (is-a Location)
          (OBJECT ?service-location)
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

;;; Llindars globals per transformar punts -> nivell de recomanació

(defglobal
  ?*PUNTS-NO*      = 0
  ?*PUNTS-POC*     = 25
  ?*PUNTS-RECOM*   = 60
)

;;; ---------------------------------------------------------
;;; Plantilla auxiliar: avaluació de (Client, RentalOffer)
;;; No forma part de l'ontologia, és només de treball intern
;;; ---------------------------------------------------------

(deftemplate avaluacio
   (slot client)                    ; nom d'instància de Client
   (slot oferta)                    ; nom d'instància de RentalOffer
   (slot punts (type NUMBER) (default 0))

   ;; coincidència de característiques de la vivenda
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
                      ( soroll-avaluat FALSE)))
)

;;; ---------------------------------------------------------
;;; CRITERIS DE PREU
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

   ;; Si el preu és per sota o igual del màxim assumible, sumem punts
   (if (<= ?preu ?max) then
      (bind ?nova (+ ?nova 20))
   else
      ;; Si supera el màxim però dins de la flexibilitat, penalització moderada
      (if (<= ?preu (* ?max (+ 1 (/ ?flex 100.0))))
          then (bind ?nova (- ?nova 10))
          else (bind ?nova (- ?nova 30))   ; Massa car
      )
   )

   ;; Si el preu és especialment raonable (per sota del mínim "raonable")
   (if (<= ?preu ?minR) then
      (bind ?nova (+ ?nova 10))
   )

   (modify ?a (punts ?nova)
            (preu-avaluat TRUE))
)

;;; ---------------------------------------------------------
;;; CRITERIS D'ÀREA I NOMBRE D'HABITACIONS
;;; ---------------------------------------------------------

(defrule criteri-mida-i-dormitoris
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (mida-avaluada FALSE)
                    (dorms-avaluats FALSE))
   (object (is-a Client)
           (name ?c)
           (minArea ?minA)
           (minDorms ?minD))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Property)
           (name ?prop)
           (area ?area)
           (hasRoom $?habitacions))
   =>
   (bind ?nova ?p)

   ;; Comparació d'àrea
   (if (>= ?area ?minA)
       then (bind ?nova (+ ?nova 15))
       else (bind ?nova (- ?nova 15)))

   ;; Nombre d'habitacions
   (bind ?ndorms (length$ ?habitacions))
   (if (>= ?ndorms ?minD)
       then (bind ?nova (+ ?nova 30))
       else (bind ?nova (- ?nova 30)))

   (modify ?a (punts ?nova)
            (mida-avaluada TRUE)
            (dorms-avaluats TRUE))
)

;;; ---------------------------------------------------------
;;; CRITERI DE QUALITAT DE L'HABITATGE (estat + llum natural)
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

   ;; Estat general de l'immoble
   (if (>= ?estat 8) then
      (bind ?nova (+ ?nova 10))
   else
      (if (<= ?estat 5) then
          (bind ?nova (- ?nova 10))
      )
   )

   ;; Llum natural
   (if (== ?llum 0) then
      (bind ?nova (+ ?nova 0))
   )
   (if (== ?llum 1) then
      (bind ?nova (+ ?nova 5))
   )
   (if (== ?llum 2) then
      (bind ?nova (+ ?nova 5))
   )
   (if (== ?llum 3) then
      (bind ?nova (+ ?nova 10))
   )

   (modify ?a (punts ?nova)
            (qualitat-avaluada TRUE))
)

;;; ---------------------------------------------------------
;;; COINCIDÈNCIA DE CARACTERÍSTIQUES (FEATURES)
;;;   - Per cada característica preferida pel client i present
;;;     a l'oferta, sumem punts.
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
   (test (not (member$ ?f ?mf)))   ; Evitem comptar la mateixa característica diverses vegades
   =>
   (modify ?a
           (punts (+ ?p 5))
           (match-features (create$ ?mf ?f)))
)

;;; ---------------------------------------------------------
;;; CRITERIS DE SERVEIS I PROXIMITAT - SISTEMA GENÈRIC
;;;   - Es premien (si) o penalitzen (no) segons la preferència del client i la proximitat
;;;   - Categoria 0 = prop (punts complets), 1 = mitja (meitat punts), 2 = lluny (quart punts)
;;;   - Sistema genèric que mapeja automàticament tipus de serveis amb preferències
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

;;; Regla genèrica per serveis desitjats (si) - proximitat categoria 0 (prop)
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
   
   ;; Verificar que no s'ha avaluat ja aquest tipus de servei
   (test (neq (eval (str-cat "(slot-get ?a " (get-evaluation-flag ?service-type) ")")) TRUE))
   
   ;; Verificar que el client vol aquest tipus de servei
   (test (eq (get-service-preference ?c ?service-type) si))
   =>
   (bind ?base-points (get-service-points ?service-type))
   (bind ?flag (get-evaluation-flag ?service-type))
   
   (modify ?a 
           (punts (+ ?p ?base-points))
           (?flag TRUE))
)

;;; Regla genèrica per serveis desitjats (si) - proximitat categoria 1 (mitja)
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
   
   ;; Verificar que no s'ha avaluat ja aquest tipus de servei
   (test (neq (eval (str-cat "(slot-get ?a " (get-evaluation-flag ?service-type) ")")) TRUE))
   
   ;; Verificar que el client vol aquest tipus de servei
   (test (eq (get-service-preference ?c ?service-type) si))
   =>
   (bind ?base-points (get-service-points ?service-type))
   (bind ?half-points (div ?base-points 2))
   (bind ?flag (get-evaluation-flag ?service-type))
   
   (modify ?a 
           (punts (+ ?p ?half-points))
           (?flag TRUE))
)

;;; Regla genèrica per serveis desitjats (si) - proximitat categoria 2 (lluny)
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
   
   ;; Verificar que no s'ha avaluat ja aquest tipus de servei
   (test (neq (eval (str-cat "(slot-get ?a " (get-evaluation-flag ?service-type) ")")) TRUE))
   
   ;; Verificar que el client vol aquest tipus de servei
   (test (eq (get-service-preference ?c ?service-type) si))
   =>
   (bind ?base-points (get-service-points ?service-type))
   (bind ?quarter-points (div ?base-points 4))
   (bind ?flag (get-evaluation-flag ?service-type))
   
   (modify ?a 
           (punts (+ ?p ?quarter-points))
           (?flag TRUE))
)

;;; Regla genèrica per serveis NO desitjats (no) - proximitat categoria 0 (prop)
(defrule criteri-servei-negatiu-prop
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
   
   ;; Verificar que no s'ha avaluat ja aquest tipus de servei
   (test (neq (eval (str-cat "(slot-get ?a " (get-evaluation-flag ?service-type) ")")) TRUE))
   
   ;; Verificar que el client NO vol aquest tipus de servei
   (test (eq (get-service-preference ?c ?service-type) no))
   =>
   (bind ?base-points (get-service-points ?service-type))
   (bind ?flag (get-evaluation-flag ?service-type))
   
   (modify ?a 
           (punts (- ?p ?base-points))
           (?flag TRUE))
)

;;; Regla genèrica per serveis NO desitjats (no) - proximitat categoria 1 (mitja)
(defrule criteri-servei-negatiu-mitja
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
   
   ;; Verificar que no s'ha avaluat ja aquest tipus de servei
   (test (neq (eval (str-cat "(slot-get ?a " (get-evaluation-flag ?service-type) ")")) TRUE))
   
   ;; Verificar que el client NO vol aquest tipus de servei
   (test (eq (get-service-preference ?c ?service-type) no))
   =>
   (bind ?base-points (get-service-points ?service-type))
   (bind ?half-points (div ?base-points 2))
   (bind ?flag (get-evaluation-flag ?service-type))
   
   (modify ?a 
           (punts (- ?p ?half-points))
           (?flag TRUE))
)

;;; Regla genèrica per serveis NO desitjats (no) - proximitat categoria 2 (lluny)
(defrule criteri-servei-negatiu-lluny
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
   
   ;; Verificar que no s'ha avaluat ja aquest tipus de servei
   (test (neq (eval (str-cat "(slot-get ?a " (get-evaluation-flag ?service-type) ")")) TRUE))
   
   ;; Verificar que el client NO vol aquest tipus de servei
   (test (eq (get-service-preference ?c ?service-type) no))
   =>
   (bind ?base-points (get-service-points ?service-type))
   (bind ?quarter-points (div ?base-points 4))
   (bind ?flag (get-evaluation-flag ?service-type))
   
   (modify ?a 
           (punts (- ?p ?quarter-points))
           (?flag TRUE))
)

;;; ---------------------------------------------------------
;;; CRITERI GENERIC DE SOROLL PER GENT GRAN
;;;  - Si el client és gent gran i hi ha serveis molt sorollosos
;;;    a prop, penalitzem.
;;; ---------------------------------------------------------

(defrule criteri-soroll-gent-gran
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (soroll-avaluat FALSE))
   (object (is-a Client)
           (name ?c)
           (hasProfile ?perfil))
   (object (is-a Elderly)
           (name ?perfil))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 0))
   (object (is-a Service)
           (name ?srv)
           (serviceNoiseLevel ?nivell&:(>= ?nivell 2)))
   =>
   (modify ?a (punts (- ?p 15))
            (soroll-avaluat TRUE))
)

;;; ---------------------------------------------------------
;;; CONVERSIÓ DE PUNTS -> RECOMANACIÓ
;;;   Es creen instàncies de Recommendation
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
   (bind ?nivell
      (if (<= ?p ?*PUNTS-NO*)
          then "no recomenat"
      else
         (if (<= ?p ?*PUNTS-POC*)
             then "poc recomenat"
         else
            (if (<= ?p ?*PUNTS-RECOM*)
                then "recomenat"
                else "molt recomenat"))))

   (make-instance (gensym*)
      of Recommendation
      (aboutOffer ?o)
      (recommendedFor ?c)
      (recommendationLevel ?nivell))
)

;;; ---------------------------------------------------------
;;; Fi de expert.clp
;;; ---------------------------------------------------------