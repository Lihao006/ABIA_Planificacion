(define (domain hoteldomain1)

  ;; Dominio Extensión 1
  
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
     
    ;; coste por reservas no servidas
    (coste-total)
  )

  ;; necesitamos una acción para hacer lo básico para poder resolver el problema, que es asignar una habitación a una reserva
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
      )
  )

  ;; sabemos que MetricFF no permite el uso de operaciones de incremento/decremento si la métrica es maximizar/minimizar una función, respectivamente,
  ;; por tanto, la función a optimizar debe ser siempre algo parecido a un "coste total", ya que sólo lo podemos modificar en la dirección contraria a la métrica.
  ;; Siendo así, las acciones que tiene efectos que modifican la métrica deben tener algun tipo de coste, pero nunca ganancias.
  ;; Esto es el caso para la extensión 1 con la acción "asignar-habitacion", ya que queremos asignar el máximo número de reservas posibles, y esta acción no tiene coste alguna (de momento), o almenos, no nos interesa que tenga coste.
  ;; Por tanto, necesitamos otra acción que modifique la función "coste total".

  ;; Definimos la acción "concluir" que modifica la función "coste total" si una reserva no ha sido servida.
  ;; Por tanto, nos interesa que se modifique lo menos posible, es decir, que se sirvan el máximo número de reservas posibles.
  ;; Además, el hecho de concluir una reserva lo marcará como "resuelta" y no podrá volver a ser asignada a una habitación.

  ;; crearemos 2 acciones de concluir para reservas servidas y no servidas, asi diferenciaremos cuáles han quedado servidas.
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
        (increase (coste-total) 1)
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
      )
  )
;; goal = (:goal (forall (?r - reserva) (concluida ?r)))
;; metric minimize (coste-total)
)