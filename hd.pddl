(define (domain hd)
  (:requirements :adl :typing :fluents)
  (:types habitacion reserva - object
  )

  (:predicates 
    (asignado ?r - reserva ?h - habitacion)

    (lleno ?h - habitacion)
    (vacio ?h - habitacion)

    (servida ?r - reserva)

    (concluida ?r - reserva)
    )

  (:functions
    (capacidad-hab ?h - habitacion)

    (pers-reserva ?r - reserva)
    
    (coste-total)
    
  )

  (:action asignar-habitacion
    :parameters (?r - reserva ?h - habitacion)
    :precondition 
      (and 
        (not (concluida ?r))
        (not (servida ?r))
        (not (lleno ?h))
        (>= (capacidad-hab ?h) (pers-reserva ?r))
      )
    :effect 
      (and 
        (asignado ?r ?h)
        (servida ?r)
        (decrease (capacidad-hab ?h) (pers-reserva ?r))
        (when (= (capacidad-hab ?h) 0) (lleno ?h))
        (when (vacio ?h) (increase (coste-total) 2))
      )
  )


  (:action concluir
    :parameters (?r - reserva ?h - habitacion)
    :precondition 
      (and 
        (not (concluida ?r))
      )
    :effect 
      (and 
        (concluida ?r)

        (when (not (servida ?r)) (increase (coste-total) 4))

        (when (and (not (lleno ?h)) (not (vacio ?h)) (asignado ?r ?h)) (increase (coste-total) 1))
      )
  )
)
  