(define (domain hoteldomain1)
  
  (:requirements :adl :typing :fluents)
  (:types habitacion reserva - object
  )

  (:predicates 
    (asignado ?r - reserva ?h - habitacion)

    ;; Predicado de filtro
    (lleno ?h - habitacion)
    (servida ?r - reserva)
    
    )

  (:functions
    (capacidad_hab ?h - habitacion)
    (pers_reserva ?r - reserva)
    (dia_inicio ?r - reserva)
    (dia_fin ?r - reserva)
  )
  
  (:)
  