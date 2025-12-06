(define (domain h3)

  ;; Dominio Extensión 3
  
  (:requirements :adl :typing :fluents)
  (:types habitacion reserva - object
  )

  (:predicates 
    (asignado ?r - reserva ?h - habitacion)
    (lleno ?h - habitacion)
    (vacio ?h - habitacion)
    ;; una habitació que no esté llena ni vacía està parcialmente ocupada

    (servida ?r - reserva)

    ;; una reserva se concluye y aumenta el coste si no se ha servido
    (concluida ?r - reserva)
    )

  (:functions
    ;; Espacios sin ocupar de cada habitación
    (capacidad-hab ?h - habitacion)

    (pers-reserva ?r - reserva) 
    
    ;; coste total
    (coste-total)
  )

  (:action asignar-habitacion
    :parameters (?r - reserva ?h - habitacion)
    :precondition 
      (and 
        (not (concluida ?r))
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
        (when (= (capacidad-hab ?h) 0) (lleno ?h))
      )
  )

  ;; ahora para concluir una reserva también miramos como está de lleno la habitación
  ;; si la reserva no se ha servido, la habitación con la que se unifica es irrelevante
  (:action concluir-no-asignadas
    :parameters (?r - reserva)
    :precondition 
      (and 
        (not (concluida ?r))
        (not (servida ?r))
      )
    :effect 
      (and 
        (concluida ?r)
        (increase (coste-total) 2)
     )
  )

   (:action concluir-asignadas
    :parameters (?r - reserva ?h - habitacion)
    :precondition 
      (and 
        (not (concluida ?r))
        (asignado ?r ?h)
      )
    :effect 
      (and 
        (concluida ?r)
        (when (and (not (lleno ?h))) (increase (coste-total) 1))

     )
  )
  
;; goal = (:goal (forall (?r - reserva) (concluida ?r)))
;; metric minimize (coste-total)
)