(define (domain hoteldomain3)

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
        (not (vacio ?h))
        (decrease (capacidad-hab ?h) (pers-reserva ?r))
        (when (= (capacidad-hab ?h) (pers-reserva ?r)) (lleno ?h))

        ;; ahora al asignar una habitación también modificamos el coste total para penalizar las asignaciones que dejan espacios libres en habitaciones
        (when (not (= (capacidad-hab ?h) (pers-reserva ?r))) (increase (coste-total) 1))
      )
  )

  ;; ahora para concluir una reserva también miramos como está de lleno la habitación
  ;; lo haremos en dos operaciones separadas para las reservas no asignadas y las asignadas
  (:action concluir-no-servidas
    :parameters (?r - reserva)
    :precondition 
      (and 
        (not (concluida ?r))
        (not (servida ?r))
      )
    :effect 
      (and 
        (concluida ?r)

        ;; Priorizamos servir reservas antes que dejar menos espacios libres en habitaciones  
        ;; El coste por no servir una reserva es 7, que será siempre mayor que el coste por dejar espacios libres en habitaciones,
        ;; (el coste por dejar espacios libres en habitaciones como mucho será 6, si se asignan 3 reservas de 1 persona a una habitación de 4)
        (increase (coste-total) 7)
      )
  )

  (:action concluir-servidas
    :parameters (?r - reserva ?h - habitacion)
    :precondition 
      (and 
        (not (concluida ?r))
        (not (vacio ?h))
        (servida ?r)
        (asignado ?r ?h)
      )
    :effect 
      (and 
        (concluida ?r)
        
        ;; necesitamos priorizar las asignaciones que nos interasan: primero, las reservas con un número de personas más cercano a la capacidad restante de la habitación
        ;; por ello, ahora el operador concluir-servidas también modificará el coste total en función de los espacios libres que queden en la habitación tras asignar la reserva

        ;; no podemos hacer directamente un increase porque metricff no permite incrementos ni decrementos no constantes
        ;; (when (and (asignado ?r ?h) (not (lleno ?h))) (increase (coste-total) (capacidad-hab ?h)))

        ;; hay que tener en cuente que este coste se suma hasta, como máximo, 3 veces si se asignan 3 reservas de 1 persona a una habitación de 4.
        ;; el valor que se incrementa es como mucho 3, ya sea una vez 3 (1 reserva de 1 persona asignada a 1 habitación de 4 plazas), o 3 veces 1 (3 reservas de 1 persona a una habitación de 4).
        ;; este coste no se aplica si la habitación queda llena aunque tenga más de 1 reserva asignada
        ;; por tanto, este coste penaliza solo las habitaciones que no quedan llenas al final de la planificación, a diferencia que el coste que hay en asignar-habitacion 
        (when (= (capacidad-hab ?h) 1) (increase (coste-total) 1))
        (when (= (capacidad-hab ?h) 2) (increase (coste-total) 2))
        (when (= (capacidad-hab ?h) 3) (increase (coste-total) 3))

        ;; no se puede hacer directamente esto:
        ;; (when (not (lleno ?h)) (increase (coste-total) (capacidad-hab ?h)))
      )
  )


;; goal = (:goal (forall (?r - reserva) (concluida ?r)))
;; metric minimize (coste-total)
)