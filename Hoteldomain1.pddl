(define (domain hoteldomain1)
  
  (:requirements :adl :typing :fluents)
  (:types habitacion reserva orientacion - object
          ;; N S E O - orientacion
  )

  (:predicates 
    (asignado ?r - reserva ?h - habitacion)
    ;;(orientacion-hab ?h - habitacion ?o - orientacion)
    ;;(orientacion-reserva ?r - reserva ?o - orientacion)

    ;; Predicados de filtro
    (lleno ?h - habitacion)
    (servida ?r - reserva)
    )

  (:functions
    (capacidad-hab ?h - habitacion)
    (pers-reserva ?r - reserva)
    (dia-inicio ?r - reserva)
    (dia-fin ?r - reserva)
    
    ;; criterios a optimizar
    (num-asignaciones)
    (num-habs)
    (coste-desperdicio)
    (coste-orien-incorrecta)
  )

  ;; Prioridades de la extensión 4:
  ;; 1. Asignar reservas (maximizar num-asignaciones)
  ;; 2. Minimizar numero de habitaciones usadas (num-habs)
  ;; 3. Minimizar desperdicio de capacidad (coste-desperdicio)

  ;; Las prioridades lo gestionaremos por el rango de valores que pueden tomar los incrementos y decrementos.
  
  (:action asignar-habitacion
    :parameters (?r - reserva ?h - habitacion)
    :precondition 
      (and 
        (not (servida ?r))
        (not (lleno ?h))
        ;; (not (asignado ?r ?h)) ;; con ver que la reserva no esté servida es suficiente.
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

  (:action desasignar-habitacion
    :parameters (?r - reserva ?h - habitacion)
    :precondition 
      (and 
        (asignado ?r ?h)
        (servida ?r)
      )
    :effect 
      (and 
        (not (asignado ?r ?h))
        (not (servida ?r))
        (increase (capacidad-hab ?h) (pers-reserva ?r))

        (when (> (capacidad-hab ?h) 0)
          (not (lleno ?h))
        )
      )
  )

)
  