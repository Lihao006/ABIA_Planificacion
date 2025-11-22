(define (domain hoteldomain1)
  
  (:requirements :adl :typing :fluents)
  (:types habitacion reserva orientacion - object
          ;; N S E O - orientacion
  )

  (:predicates 
    (asignado ?r - reserva ?h - habitacion)

    ;; Predicado de filtro
    (lleno ?h - habitacion)
    (servida ?r - reserva)
    
    )

  (:functions
    (capacidad-hab ?h - habitacion)
    (pers-reserva ?r - reserva)
    (dia-inicio ?r - reserva)
    (dia-fin ?r - reserva)
    ;;(orientacion-hab ?h - habitacion)
    ;;(orientacion-reserva ?r - reserva)
    
    ;; criterios a optimizar
    (num-asignaciones)
    (coste-desperdicio)
    (coste-orien-incorrecta)
  )
  
  (:action asignar-habitacion
    :parameters (?r - reserva ?h - habitacion)
    :precondition 
      (and 
        (not (servida ?r))
        (not (lleno ?h))
        ;; (not (asignado ?r ?h)) ;; con ver que la reserva no esté servida es suficiente
        (>= (capacidad-hab ?h) (pers-reserva ?r))
      )
    :effect 
      (and 
        (asignado ?r ?h)
        (servida ?r)
        (decrease (capacidad-hab ?h) (pers-reserva ?r))
        (when (<= (capacidad-hab ?h) 0)
          (lleno ?h)
        )
      )
  )

)
  