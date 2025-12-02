(define (domain hoteldomain1)

  ;; Dominio que asigna de la mejor manera des del principio.
  
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
    (vacio ?h - habitacion)
    ;; una habitació que no esté llena ni vacía està parcialmente ocupada

    (servida ?r - reserva)
    )

  (:functions
    ;; Espacios sin ocupar de cada habitación
    (capacidad-hab ?h - habitacion)

    (pers-reserva ?r - reserva)
    
    (dia-inicio ?r - reserva)
    (dia-fin ?r - reserva)
    
    ;; criterios a optimizar
    ;;(asignaciones)
    ;;(coste-habs)
    ;;(coste-desperdicio)
    ;;(hab-llenas)
    ;; (coste-orien-incorrecta)

    (coste)
    
  )

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
        (increase (coste) 4) ;; coste-habs incrementa en 4 por cada asignación
        )
      )
  )
  