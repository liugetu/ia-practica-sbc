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
       then (bind ?nova (+ ?nova 15))
       else (bind ?nova (- ?nova 10)))

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
   (if (>= ?llum 8) then
      (bind ?nova (+ ?nova 5))
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
;;; CRITERIS DE SERVEIS I PROXIMITAT
;;;   - Es premien o penalitzen segons la preferència del client
;;;   - Es considera distància categoria 0 com "a prop"
;;; ---------------------------------------------------------

;;; ---- Zones verdes ----

(defrule criteri-zona-verda-positiu
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (verd-avaluat FALSE))
   (object (is-a Client)
           (name ?c)
           (wantsGreenArea si))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 0))
   (object (is-a GreenArea)
           (name ?srv))
   =>
   (modify ?a (punts (+ ?p 10))
            (verd-avaluat TRUE))
)

(defrule criteri-zona-verda-negatiu
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (verd-avaluat FALSE))
   (object (is-a Client)
           (name ?c)
           (wantsGreenArea no))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 0))
   (object (is-a GreenArea)
           (name ?srv))
   =>
   (modify ?a (punts (- ?p 5))
            (verd-avaluat TRUE))
)

;;; ---- Centres de salut ----

(defrule criteri-salut-positiu
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (salut-avaluada FALSE))
   (object (is-a Client)
           (name ?c)
           (wantsHealthCenter si))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 0))
   (object (is-a HealthCenter)
           (name ?srv))
   =>
   (modify ?a (punts (+ ?p 8))
            (salut-avaluada TRUE))
)

;;; ---- Oci nocturn ----

(defrule criteri-oci-nocturn-positiu
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (nit-avaluada FALSE))
   (object (is-a Client)
           (name ?c)
           (wantsNightLife si))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 0))
   (object (is-a Nightlife)
           (name ?srv)
           (serviceNoiseLevel ?nivell))
   =>
   (modify ?a (punts (+ ?p 12))
            (nit-avaluada TRUE))
)

(defrule criteri-oci-nocturn-negatiu
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (nit-avaluada FALSE))
   (object (is-a Client)
           (name ?c)
           (wantsNightLife no))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 0))
   (object (is-a Nightlife)
           (name ?srv)
           (serviceNoiseLevel ?nivell))
   =>
   (modify ?a (punts (- ?p 15))
            (nit-avaluada TRUE))
)

;;; ---- Escoles ----

(defrule criteri-escola-positiu
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (escola-avaluada FALSE))
   (object (is-a Client)
           (name ?c)
           (wantsSchool si))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 0))
   (object (is-a School)
           (name ?srv))
   =>
   (modify ?a (punts (+ ?p 8))
            (escola-avaluada TRUE))
)

;;; ---- Estadis ----

(defrule criteri-estadi-positiu
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (estadi-avaluat FALSE))
   (object (is-a Client)
           (name ?c)
           (wantsStadium si))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 0))
   (object (is-a Stadium)
           (name ?srv))
   =>
   (modify ?a (punts (+ ?p 6))
            (estadi-avaluat TRUE))
)

;;; ---- Supermercats ----

(defrule criteri-supermercat-positiu
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (super-avaluat FALSE))
   (object (is-a Client)
           (name ?c)
           (wantsSupermarket si))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 0))
   (object (is-a Supermarket)
           (name ?srv))
   =>
   (modify ?a (punts (+ ?p 6))
            (super-avaluat TRUE))
)

;;; ---- Transport públic ----

(defrule criteri-transport-positiu
   (declare (salience 10))
   ?a <- (avaluacio (client ?c)
                    (oferta ?o)
                    (punts ?p)
                    (transport-avaluat FALSE))
   (object (is-a Client)
           (name ?c)
           (wantsTransport si))
   (object (is-a RentalOffer)
           (name ?o)
           (hasProperty ?prop))
   (object (is-a Proximity)
           (nearProperty ?prop)
           (nearService ?srv)
           (distanceCategory 0))
   (object (is-a Transport)
           (name ?srv))
   =>
   (modify ?a (punts (+ ?p 10))
            (transport-avaluat TRUE))
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
           (serviceNoiseLevel ?nivell&:(> ?nivell 6)))
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
