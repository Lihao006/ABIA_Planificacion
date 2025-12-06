(define (domain hoteldomainBasic)

  ;; Dominio basico
  
  (:requirements :adl :typing :fluents)
  (:types habitacion reserva - object
  )

  (:predicates 
    (asignado ?r - reserva ?h - habitacion)
    (lleno ?h - habitacion)
    (vacio ?h - habitacion)
    ;; una habitació que no esté llena ni vacía està parcialmente ocupada

    (servida ?r - reserva)
    )

  (:functions
    ;; Espacios sin ocupar de cada habitación
    (capacidad-hab ?h - habitacion)

    (pers-reserva ?r - reserva) 
  )

  (:action asignar-habitacion
    :parameters (?r - reserva ?h - habitacion)
    :precondition 
      (and 
        (not (servida ?r))
        (not (lleno ?h))
        (not (vacio ?h))
        ;; (not (asignado ?r ?h)) ;; con ver que la reserva no esté servida es suficiente.
        (>= (capacidad-hab ?h) (pers-reserva ?r))
      )
    :effect 
      (and 
        (asignado ?r ?h)
        (servida ?r)
        (not (vacio ?h))
        (decrease (capacidad-hab ?h) (pers-reserva ?r))
        ;; los efectos de las modificaciones de un mismo effect de un operador no se verán realizados hasta que se complete el operador entero
        ;; por tanto, aquí capacidad-hab ?h aún no se ha modificado
        ;; (when (= (capacidad-hab ?h) 0) (lleno ?h))
        (when (= (capacidad-hab ?h) (pers-reserva ?r)) (lleno ?h))
      )
  )

;; goal = (forall (?r - reserva) (servida ?r))
)