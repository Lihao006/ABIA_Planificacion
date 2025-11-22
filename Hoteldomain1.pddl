(define (domain hoteldomain1)
  
  (:requirements :adl :typing :fluents)
  (:types habitacion reserva persona - object
  )

  (:predicates 
    (reservada ?h - habitacion)

    ;; Predicado de filtro
    (asignado ?p - persona)
    (lleno ?h - habitacion)
    )