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

        ;; necesitamos priorizar las asignaciones que nos interasan: primero, las reservas con un número de personas más cercano a la capacidad restante de la habitación
        ;; por ello, ahora el operador asignar-habitacion modifica el coste total para penalizar las asignaciones que dejan más espacios libres en la habitación

        ;; no podemos hacer directamente un increase porque metricff no permite incrementos ni decrementos no constantes
        ;; (when (and (asignado ?r ?h) (not (lleno ?h))) (increase (coste-total) (capacidad-hab ?h)))

        ;; hay que tener en cuente que este coste se suma hasta, como máximo, 3 veces si se asignan 3 reservas de 1 persona a una habitación de 4.
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
        ;; El coste por no servir una reserva es 2, que será siempre mayor que el coste por dejar espacios libres en habitaciones, por lo que se minimizará primero
        (increase (coste-total) 2)
      )
  )

  (:action concluir-servidas
    :parameters (?r - reserva ?h - habitacion)
    :precondition 
      (and 
        (not (concluida ?r))
        (asignado ?r ?h)
      )
    :effect 
      (and 
        (concluida ?r)
      )
  )

;; con esto definiremos lo siguiente:
        ;; Dado 4 reserva Ai con 1 persona, 1 reserva B con 4 personas, 2 habitaciones Xi de 4 espacios y 4 habitaciones Yi de 1 espacio,
        ;; el programa priorizará asignar las reservas Ai a las habitaciones Yi, y la reserva B a una habitación Xi, minimizando el coste total.

        ;; Si se asignan las reservas de 1 persona a una habitación de 4, el coste aumentará en 3 (1 por cada reserva asignada, excepto la última que llenará la habitación).
        ;; Si se asignan las reservas de 1 personas a 4 habitaciones de 1, el coste no aumentará (todas las habitaciones quedan llenas).
        ;; Asin dejamos libre las habitaciones de mayor capacidad para reservas más grandes, ya que las habitaciones pequeñas solo sirven para reservas pequeñas y no malgastaremos capacidad.


;; goal = (:goal (forall (?r - reserva) (concluida ?r)))
;; metric minimize (coste-total)
)