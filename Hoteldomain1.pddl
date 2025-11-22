(define (domain hoteldomain1)
  
  (:requirements :adl :typing :fluents)
  (:types habitacion reserva persona - object
  )

  (:predicates 
    (peticion ?h - habitacion)
    ()

    ;; Predicado de filtro
    (asignado ?p - persona)
    (lleno ?h - habitacion)
    
    )

  (:functions
    (capacidad_hab ?h - habitacion)
    (pers_reserva ?r - reserva)
    (dia_inicio ?r - reserva)
    (dia_fin ?r - reserva)
