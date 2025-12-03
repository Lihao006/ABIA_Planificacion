(define (problem Hotelproblema40)
        (:domain Hoteldomain4)

 (:objects h1 h2 h3 h4 - habitacion
           r1 r2 r3 r4 - reserva
           )

 (:init

   (= (coste-total) 0)

   (= (capacidad-hab h1) 1)
   (= (capacidad-hab h4) 4)
   (= (capacidad-hab h3) 3)
   (= (capacidad-hab h2) 2)
   
   
   (= (pers-reserva r1) 1)
   (= (pers-reserva r2) 2)
   (= (pers-reserva r3) 3)
   (= (pers-reserva r4) 4)

   (vacio h2)
   (vacio h3)
   (vacio h4)

 )

;;(:goal (forall (?r - reserva) (servida ?r)))
;;(:goal (or (forall (?h - habitacion) (lleno ?h))
;;          (forall (?r - reserva) (servida ?r)))

(:goal
  (forall (?h - habitacion ?r - reserva) (< (capacidad-hab ?h) (pers-reserva ?r)))
)


 (:metric minimize (coste-total))
)
