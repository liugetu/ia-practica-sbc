;;; ---------------------------------------------------------
;;; expert.clp
;;; Sistema expert de recomanació de lloguers
;;;
;;; Es pressuposa:
;;;   - Carregada l'ontologia (ontologia.clp)
;;;   - Carregades les instàncies d'exemple (inicialització.clp)
;;; ---------------------------------------------------------

;;; Llindars globals per transformar punts -> nivell de recomanació

(defglobal
  ?*PUNTS-NO*      = 0
  ?*PUNTS-POC*     = 50
  ?*PUNTS-RECOM*   = 150
)

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
   (slot habitacio-doble-avaluada (type SYMBOL) (default FALSE))
   (slot mesos-avaluats      (type SYMBOL) (default FALSE))
   
   ;; Flags per criteris específics de perfils
   (slot elderly-avaluat     (type SYMBOL) (default FALSE))
   (slot family-avaluat      (type SYMBOL) (default FALSE))
   (slot student-avaluat     (type SYMBOL) (default FALSE))
   (slot individual-avaluat  (type SYMBOL) (default FALSE))
   (slot couple-avaluat      (type SYMBOL) (default FALSE))
   
   ;; Flags per problemes de la propietat
   (slot squatters-avaluat   (type SYMBOL) (default FALSE))
   (slot leaks-avaluat       (type SYMBOL) (default FALSE))
   (slot dampness-avaluat    (type SYMBOL) (default FALSE))
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
                      (mesos-avaluats FALSE)
                      (elderly-avaluat FALSE)
                      (family-avaluat FALSE)
                      (student-avaluat FALSE)
                      (individual-avaluat FALSE)
                      (couple-avaluat FALSE)))
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

   (bind ?maxFlexible (* ?max (+ 1 (/ ?flex 100.0))))

   ;; Si el preu és per sota o igual del màxim assumible, sumem punts
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
                                      "% per sota del màxim")))))
   else
      ;; Si supera el màxim però dins de la flexibilitat, penalització moderada
      (if (<= ?preu ?maxFlexible)
          then (bind ?nova (+ ?nova 25))
          else 
             ;; NO COMPLEIX: Massa car
             (assert (criteri-no-complert 
                      (client ?c) 
                      (oferta ?o) 
                      (descripcio (str-cat "Preu massa alt: " ?preu "€ > " 
                                          ?maxFlexible "€ (màxim amb flexibilitat)"))))
             (bind ?nova (- ?nova 100))
      )
   )

   ;; Si el preu és especialment raonable (per sota del mínim "raonable")
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

   ;; Comparació d'àrea proporcional
   (bind ?area-ratio (/ ?area ?minA))
   (if (>= ?area ?minA)
       then 
         ;; Área suficient o més gran - mínim 20 punts + fins a 10 més segons ratio
         (bind ?extra-bonus (min 10 (* 10 (- ?area-ratio 1))))
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
                                         "% més gran del sol·licitat")))))
       else 
         ;; Área insuficient - mínim -20 punts - fins a 10 més segons ratio
         (assert (criteri-no-complert 
                  (client ?c) 
                  (oferta ?o) 
                  (descripcio (str-cat "Superfície insuficient: " ?area 
                                      " m² < " ?minA " m² sol·licitats"))))
         (bind ?extra-penalty (min 10 (* 10 (- 1 ?area-ratio))))
         (bind ?area-penalty (+ -20 (- 0 ?extra-penalty)))
         (bind ?nova (+ ?nova ?area-penalty)))

   ;; Nombre d'habitacions
   (bind ?ndorms (length$ ?habitacions))
   (if (>= ?ndorms ?minD)
       then 
         (bind ?nova (+ ?nova 30))
         ;; CARACTERÍSTICA DESTACADA: Més dormitoris dels necessaris
         (if (> ?ndorms ?minD) then
            (assert (caracteristica-destacada
                     (client ?c)
                     (oferta ?o)
                     (descripcio (str-cat "Dormitoris extra: " ?ndorms 
                                         " (sol·licitats: " ?minD ")")))))
       else 
         (assert (criteri-no-complert 
                  (client ?c) 
                  (oferta ?o) 
                  (descripcio (str-cat "Dormitoris insuficients: " ?ndorms 
                                      " < " ?minD " sol·licitats"))))
         (bind ?nova (- ?nova 30)))

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

   ;; Llum natural
   (if (= ?llum 0) then
      (bind ?nova (+ ?nova 0))
   )
   (if (= ?llum 1) then
      (bind ?nova (+ ?nova 5))
   )
   (if (= ?llum 2) then
      (bind ?nova (+ ?nova 5))
   )
   (if (= ?llum 3) then
      (bind ?nova (+ ?nova 10))
      (assert (caracteristica-destacada
               (client ?c)
               (oferta ?o)
               (descripcio "Excel·lent llum natural tot el dia")))
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
   
   ;; Si coincideixen moltes característiques, és destacable
   (if (> (+ (length$ ?mf) 1) 3) then
      (assert (caracteristica-destacada
               (client ?c)
               (oferta ?o)
               (descripcio (str-cat "Múltiples característiques desitjades ("
                                   (+ (length$ ?mf) 1) " coincidències)")))))
)

;;; ---------------------------------------------------------
;;; CRITERIS DE SERVEIS I PROXIMITAT
;;;   - Es premien (si) o penalitzen (no) segons la preferència del client i la proximitat
;;;   - Categoria 0 = prop (punts complets), 1 = mitja (meitat punts), 2 = lluny (quart punts)
;;; ---------------------------------------------------------

;;; Regles específiques per GreenArea - proximitat categoria 0 (prop)
(defrule criteri-verd-positiu-prop
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (verd-avaluat FALSE))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 0))
   (object (is-a GreenArea)
           (name ?srv))
   (object (is-a Client)
           (name ?c)
           (wantsGreenArea si))
   =>
   (modify ?a 
           (punts (+ ?p 10))
           (verd-avaluat TRUE))
)

;;; Regles específiques per GreenArea - proximitat categoria 1 (mitja)
(defrule criteri-verd-positiu-mitja
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (verd-avaluat FALSE))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 1))
   (object (is-a GreenArea)
           (name ?srv))
   (object (is-a Client)
           (name ?c)
           (wantsGreenArea si))
   =>
   (modify ?a 
           (punts (+ ?p 5))
           (verd-avaluat TRUE))
)

;;; Regles específiques per HealthCenter - proximitat categoria 0 (prop)
(defrule criteri-salut-positiu-prop
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (salut-avaluada FALSE))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 0))
   (object (is-a HealthCenter)
           (name ?srv))
   (object (is-a Client)
           (name ?c)
           (wantsHealthCenter si))
   =>
   (modify ?a 
           (punts (+ ?p 12))
           (salut-avaluada TRUE))
)

;;; Regles específiques per HealthCenter - proximitat categoria 1 (mitja)
(defrule criteri-salut-positiu-mitja
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (salut-avaluada FALSE))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 1))
   (object (is-a HealthCenter)
           (name ?srv))
   (object (is-a Client)
           (name ?c)
           (wantsHealthCenter si))
   =>
   (modify ?a 
           (punts (+ ?p 6))
           (salut-avaluada TRUE))
)

;;; Regles específiques per Supermarket - proximitat categoria 0 (prop)
(defrule criteri-super-positiu-prop
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (super-avaluat FALSE))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 0))
   (object (is-a Supermarket)
           (name ?srv))
   (object (is-a Client)
           (name ?c)
           (wantsSupermarket si))
   =>
   (modify ?a 
           (punts (+ ?p 11))
           (super-avaluat TRUE))
)

;;; Regles específiques per Supermarket - proximitat categoria 1 (mitja)
(defrule criteri-super-positiu-mitja
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (super-avaluat FALSE))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 1))
   (object (is-a Supermarket)
           (name ?srv))
   (object (is-a Client)
           (name ?c)
           (wantsSupermarket si))
   =>
   (modify ?a 
           (punts (+ ?p 6))
           (super-avaluat TRUE))
)

;;; Regles específiques per Transport - proximitat categoria 0 (prop)
(defrule criteri-transport-positiu-prop
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (transport-avaluat FALSE))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 0))
   (object (is-a Transport)
           (name ?srv))
   (object (is-a Client)
           (name ?c)
           (wantsTransport si))
   =>
   (modify ?a 
           (punts (+ ?p 11))
           (transport-avaluat TRUE))
)

;;; Regles específiques per Transport - proximitat categoria 1 (mitja)
(defrule criteri-transport-positiu-mitja
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (transport-avaluat FALSE))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 1))
   (object (is-a Transport)
           (name ?srv))
   (object (is-a Client)
           (name ?c)
           (wantsTransport si))
   =>
   (modify ?a 
           (punts (+ ?p 6))
           (transport-avaluat TRUE))
)

;;; Regles específiques per Nightlife - proximitat categoria 0 (prop)
(defrule criteri-nit-positiu-prop
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (nit-avaluada FALSE))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 0))
   (object (is-a Nightlife)
           (name ?srv))
   (object (is-a Client)
           (name ?c)
           (wantsNightLife si))
   =>
   (modify ?a 
           (punts (+ ?p 8))
           (nit-avaluada TRUE))
)

;;; Regles específiques per Nightlife - proximitat categoria 1 (mitja)
(defrule criteri-nit-positiu-mitja
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (nit-avaluada FALSE))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 1))
   (object (is-a Nightlife)
           (name ?srv))
   (object (is-a Client)
           (name ?c)
           (wantsNightLife si))
   =>
   (modify ?a 
           (punts (+ ?p 4))
           (nit-avaluada TRUE))
)

;;; Regles específiques per School - proximitat categoria 0 (prop)
(defrule criteri-escola-positiu-prop
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (escola-avaluada FALSE))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 0))
   (object (is-a School)
           (name ?srv))
   (object (is-a Client)
           (name ?c)
           (wantsSchool si))
   =>
   (modify ?a 
           (punts (+ ?p 10))
           (escola-avaluada TRUE))
)

;;; Regles específiques per School - proximitat categoria 1 (mitja)
(defrule criteri-escola-positiu-mitja
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (escola-avaluada FALSE))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 1))
   (object (is-a School)
           (name ?srv))
   (object (is-a Client)
           (name ?c)
           (wantsSchool si))
   =>
   (modify ?a 
           (punts (+ ?p 5))
           (escola-avaluada TRUE))
)

;;; Regles específiques per Stadium - proximitat categoria 0 (prop)
(defrule criteri-estadi-positiu-prop
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (estadi-avaluat FALSE))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 0))
   (object (is-a Stadium)
           (name ?srv))
   (object (is-a Client)
           (name ?c)
           (wantsStadium si))
   =>
   (modify ?a 
           (punts (+ ?p 8))
           (estadi-avaluat TRUE))
)

;;; Regles específiques per Stadium - proximitat categoria 1 (mitja)
(defrule criteri-estadi-positiu-mitja
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (estadi-avaluat FALSE))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 1))
   (object (is-a Stadium)
           (name ?srv))
   (object (is-a Client)
           (name ?c)
           (wantsStadium si))
   =>
   (modify ?a 
           (punts (+ ?p 4))
           (estadi-avaluat TRUE))
)

;;; ---------------------------------------------------------
;;; CRITERI GENERIC DE SOROLL
;;;  - Si hi ha serveis sorollosos a prop (categoria 0), es penalitza
;;;    proporcionalment al nivell de soroll (0-3): de -0 a -15 punts
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
   ;; Calcular penalització proporcional: nivell 1=-5, nivell 2=-10, nivell 3=-15
   (bind ?penalitzacio (* ?nivell 5))
   (modify ?a (punts (- ?p ?penalitzacio))
            (soroll-avaluat TRUE))
)

;;; ---------------------------------------------------------
;;; CRITERI DE HABITACIÓ DOBLE
;;;   - Si el client vol habitació doble i la té: +10 punts
;;;   - Si el client vol habitació doble però no la té: -10 punts
;;;   - Altrament: 0 punts
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
      (if (and (instance-existp ?room)
               (eq (send (instance-address ?room) get-isDouble) TRUE))
          then (bind ?te-doble TRUE)))
   
   ;; Aplicar puntuació segons les regles
   (if (eq ?vol-doble si)
       then 
         (if (eq ?te-doble TRUE)
             then (bind ?nova (+ ?nova 10))    ; Vol i té: +10
             else 
                (assert (criteri-no-complert 
                         (client ?c) 
                         (oferta ?o) 
                         (descripcio "No té habitació doble (requerida)")))
                (bind ?nova (- ?nova 10)))   ; Vol però no té: -10
       ; else -> No vol habitació doble: 0 punts (no fem res)
   )
   
   (modify ?a (punts ?nova)
            (habitacio-doble-avaluada TRUE))
)

;;; ---------------------------------------------------------
;;; CRITERI DE DURADA MÍNIMA DE CONTRACTE
;;;   - Si minMonthsClient <= minMonths de l'oferta: +15 punts
;;;   - Si minMonthsClient > minMonths de l'oferta: -20 punts
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
   
   ;; Si el client pot complir el mínim de mesos requerit per l'oferta
   (if (>= ?minMesesClient ?minMesesOferta)
       then 
         (bind ?nova (+ ?nova 15))   ; Compatible: +15
         ;; CARACTERÍSTICA DESTACADA: Durada molt flexible
         (if (<= ?minMesesOferta (* ?minMesesClient 0.5)) then
            (assert (caracteristica-destacada
                     (client ?c)
                     (oferta ?o)
                     (descripcio (str-cat "Contracte molt flexible (" ?minMesesOferta 
                                         " mesos mínim)")))))
       else 
         (assert (criteri-no-complert 
                  (client ?c) 
                  (oferta ?o) 
                  (descripcio (str-cat "Requereix " ?minMesesOferta 
                                      " mesos mínim (client vol " 
                                      ?minMesesClient " mesos)"))))
         (bind ?nova (- ?nova 20)))  ; Incompatible: -20
   
   (modify ?a (punts ?nova)
            (mesos-avaluats TRUE))
)

;;; ---------------------------------------------------------
;;; CRITERIS ESPECÍFICS PER PERFIL DE CLIENT: ELDERLY
;;;   - Si el client és Elderly, la propietat és piso/duplex,
;;;     sense ascensor i la planta >= 1: penalització de punts
;;; ---------------------------------------------------------

(defrule criteri-elderly-sense-ascensor
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (elderly-avaluat FALSE))
   (object (is-a Client)
           (name ?c)
           (hasProfile ?profile))
   (or
      (object (is-a Elderly)
              (name ?profile))
      (object (is-a Family)
              (name ?profile)
              (numElderly ?anc&:(>= ?anc 1))))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop)
           (hasFeature $?features))
   (object (is-a Apartment|Duplex)
           (name ?prop)
           (floor ?pis))
   ;; Verificar que el pis és >= 1
   (test (>= ?pis 1))
   ;; Verificar que NO té ascensor (usa variables locales dentro del test)
   (test (not (member$ [FeatureElevator] ?features)))
   =>
   (bind ?nova (- ?p 30))  ; Resta 30 punts per falta d'ascensor
   
   (assert (criteri-no-complert 
            (client ?c) 
            (oferta ?o) 
            (descripcio (str-cat "Persona gran en una planta " ?pis 
                                " sense ascensor (dificultós per a mobilitat)"))))
   
   (modify ?a (punts ?nova)
            (elderly-avaluat TRUE))
)

;;; ---------------------------------------------------------
;;; CRITERIS ESPECÍFICS PER PERFIL DE CLIENT: FAMILY
;;;   - Si el client és Family i la propietat té balcó/terrassa:
;;;     penalització per perill de caiguda per a nens petits
;;; ---------------------------------------------------------

(defrule criteri-family-balco-terrassa-perill
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (family-avaluat FALSE))
   (object (is-a Client)
           (name ?c)
           (hasProfile ?profile))
   (object (is-a Family)
           (name ?profile)
           (numChildren ?nens&:(>= ?nens 1)))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop)
           (hasFeature $?features))
   (object (is-a Apartment|Duplex)
           (name ?prop))
   ;; Verificar que TÉ balcó o terrassa
   (test (or (member$ [FeatureBalcony] ?features)
             (member$ [FeatureTerrace] ?features)))
   =>
   (bind ?nova (- ?p 10))  ; Resta punts per perill de caiguda
   
   (assert (criteri-no-complert 
            (client ?c) 
            (oferta ?o) 
            (descripcio "Família amb balcó/terrassa (perill de caiguda per a nens petits)")))
   
   (modify ?a (punts ?nova)
            (family-avaluat TRUE))
)

;;; ---------------------------------------------------------
;;; CRITERIS ESPECÍFICS PER PERFIL DE CLIENT: STUDENT
;;;   - Si el client és Student, la propietat té balcó/terrassa
;;;     i no hi ha serveis sorollosos a distància 0: bonificació
;;;     perquè es pot estudiar a l'exterior tranquil·lament
;;; ---------------------------------------------------------

(defrule criteri-student-balco-tranquil
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (student-avaluat FALSE))
   (object (is-a Client)
           (name ?c)
           (hasProfile ?profile))
   (object (is-a Student)
           (name ?profile))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop)
           (hasFeature $?features))
   (object (is-a Apartment|Duplex)
           (name ?prop))
   ;; Cal que tingui balcó o terrassa
   (test (or (member$ [FeatureBalcony] ?features)
             (member$ [FeatureTerrace] ?features)))
   ;; No hi ha serveis sorollosos (nivell>0) a distància 0
   (not (and (object (is-a Proximity)
                     (nearProperty ?prop)
                     (nearService ?srv-noisy)
                     (distanceCategory 0))
             (object (is-a Service)
                     (name ?srv-noisy)
                     (serviceNoiseLevel ?nivell&:(> ?nivell 0)))))
   =>
   (bind ?nova (+ ?p 20))  ; Bonus per espai exterior tranquil per estudiar

   (assert (caracteristica-destacada
            (client ?c)
            (oferta ?o)
            (descripcio "Balcó/terrassa sense soroll: ideal per estudiar a l'exterior")))

   (modify ?a (punts ?nova)
            (student-avaluat TRUE))
)

;;; ---------------------------------------------------------
;;; CRITERIS ESPECÍFICS PER PERFIL DE CLIENT: INDIVIDUAL
;;;   - Pis eficient per pressupost ajustat: màxima llum natural
;;;     o calefacció/aire (FeatureAirOrHeating), mida ajustada
;;;     (<= 20% sobre el mínim) i just els dormitoris demanats.
;;;     Bonus perquè és més barat d'escalfar i mantenir.
;;; ---------------------------------------------------------

(defrule criteri-individual-eficient
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (individual-avaluat FALSE))
   (object (is-a Client)
           (name ?c)
           (hasProfile ?profile)
           (minArea ?minA)
           (minDorms ?minD))
   (object (is-a Individual)
           (name ?profile))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop)
           (hasFeature $?features))
   (object (is-a Property)
           (name ?prop)
           (area ?area)
           (naturalLight ?llum)
           (hasRoom $?habitacions))
   ;; Llum natural màxima o bé disposa de calefacció/aire
   (test (or (= ?llum 3)
             (member$ [FeatureAirOrHeating] ?features)))
   ;; Mida eficient: fins a un 20% per sobre del mínim demanat
   (test (<= ?area (* ?minA 1.2)))
   ;; Just els dormitoris demanats
   (test (= (length$ ?habitacions) ?minD))
   =>
   (bind ?nova (+ ?p 20))  ; Bonus per pis eficient de calefactar

   (assert (caracteristica-destacada
            (client ?c)
            (oferta ?o)
            (descripcio "Pis eficient: llum màxima o calefacció, mida ajustada i sense espai sobrant")))

   (modify ?a (punts ?nova)
            (individual-avaluat TRUE))
)

;;; ---------------------------------------------------------
;;; CRITERIS ESPECÍFICS PER PERFIL DE CLIENT: COUPLE
;;;   - Si no hi ha zona verda ni transport a prop, la caminada
;;;     és poc romàntica.
;;; ---------------------------------------------------------

(defrule criteri-couple-cami-feo
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (couple-avaluat FALSE))
   (object (is-a Client)
           (name ?c)
           (hasProfile ?profile))
   (object (is-a Couple)
           (name ?profile))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   ;; No hi ha cap zona verda propera (cat. 0)
   (not (and (object (is-a Proximity)
                     (nearProperty ?prop)
                     (nearService ?g)
                     (distanceCategory 0))
             (object (is-a GreenArea)
                     (name ?g))))
   ;; Ni transport proper (cat. 0)
   (not (and (object (is-a Proximity)
                     (nearProperty ?prop)
                     (nearService ?t)
                     (distanceCategory 0))
             (object (is-a Transport)
                     (name ?t))))
   =>
   (bind ?nova (- ?p 10))  ; Caminada poc romàntica: resta punts

   (assert (criteri-no-complert
            (client ?c)
            (oferta ?o)
            (descripcio "Sense zona verda ni transport a prop: caminada poc romàntica")))

   (modify ?a (punts ?nova)
            (couple-avaluat TRUE))
)

;;; ---------------------------------------------------------
;;; CRITERI DE PROBLEMES DE LA PROPIETAT: OCUPES IL·LEGALS
;;;   - Si la propietat té ocupes (hasSquatters): -100 punts
;;; ---------------------------------------------------------

(defrule criteri-ocupes-illegals
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (squatters-avaluat FALSE))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Property)
           (name ?prop)
           (hasSquatters $?ocupes&:(> (length$ ?ocupes) 0)))
   =>
   (bind ?nova (- ?p 100))
   (assert (criteri-no-complert
            (client ?c)
            (oferta ?o)
            (descripcio "La propietat té ocupes il·legals")))
   (modify ?a (punts ?nova)
            (squatters-avaluat TRUE))
)

;;; ---------------------------------------------------------
;;; CRITERI DE PROBLEMES DE LA PROPIETAT: FUGUES
;;;   - Si la propietat té fugues (hasLeaks): -100 punts
;;; ---------------------------------------------------------

(defrule criteri-fugues
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (leaks-avaluat FALSE))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Property)
           (name ?prop)
           (hasLeaks $?fugues&:(> (length$ ?fugues) 0)))
   =>
   (bind ?nova (- ?p 100))
   (assert (criteri-no-complert
            (client ?c)
            (oferta ?o)
            (descripcio "La propietat té problemes de fugues")))
   (modify ?a (punts ?nova)
            (leaks-avaluat TRUE))
)

;;; ---------------------------------------------------------
;;; CRITERI DE PROBLEMES DE LA PROPIETAT: HUMITATS
;;;   - Si la propietat té humitats (hasDampness): -100 punts
;;; ---------------------------------------------------------

(defrule criteri-humitats
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (dampness-avaluat FALSE))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Property)
           (name ?prop)
           (hasDampness $?humitats&:(> (length$ ?humitats) 0)))
   =>
   (bind ?nova (- ?p 100))
   (assert (criteri-no-complert
            (client ?c)
            (oferta ?o)
            (descripcio "La propietat té problemes d'humitat")))
   (modify ?a (punts ?nova)
            (dampness-avaluat TRUE))
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
   
   ;; Determinar nivell considerant punts i criteris no complerts
   (bind ?nivell
      (if (> ?num-no-complerts 2)
          then "no recomenat"
      else
         (if (> ?num-no-complerts 0)
             then "poc recomenat"   ; Parcialment adequat
         else
            ;; Tots els criteris complerts
            (if (<= ?p ?*PUNTS-RECOM*)
                then "recomenat"     ; Adequat
                else 
                   ;; Molt recomanable si té punts alts i característiques destacades
                   (if (>= ?num-destacades 3)
                       then "molt recomenat"
                       else "recomenat")))))

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
;;; Fi de expert.clp
;;; ---------------------------------------------------------