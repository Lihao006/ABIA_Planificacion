(define (problem Hotelproblema1)
        (:domain Hoteldomain1)

 (:objects h1 h2 h3 - habitacion
           r1 r2 r3 r4 - reserva
           )

 (:init

   (= (asignaciones) 0)
   (= (coste-habs) 0)
   (= (coste-desperdicio) 0)
   (= (hab-llenas) 0)

   (= (capacidad-hab h1) 2)
   (= (capacidad-hab h2) 4)
   (= (capacidad-hab h3) 3)


   (= (pers-reserva r1) 1)
   (= (pers-reserva r2) 2)
   (= (pers-reserva r3) 3)
   (= (pers-reserva r4) 4)

   (vacio h1)
   (vacio h2)
   (vacio h3)
 )


;;(:goal (forall (?r - reserva) (servida ?r)))
(:goal (or (forall (?h - habitacion) (lleno ?h))
          (forall (?r - reserva) (servida ?r))
     )
)

(:metric maximize 
      (- (+ (asignaciones) (hab-llenas)) (+ (coste-habs) (coste-desperdicio)))
)


)