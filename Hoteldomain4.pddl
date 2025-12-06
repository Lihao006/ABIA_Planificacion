(define (domain hoteldomain4)

  ;; Dominio Extensión 4
  
  (:requirements :adl :typing :fluents)
  (:types habitacion reserva - object
  )

  (:predicates 
    (asignado ?r - reserva ?h - habitacion)

    ;; Predicados de filtro
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

  ;; Prioridades de la extensión 4:
  ;; 1. Minimizar coste reservas no asignadas
  ;; 2. Minimizar numero de habitaciones usadas
  ;; 3. Minimizar desperdicio de capacidad

  ;; Las prioridades lo gestionaremos por el rango de valores que pueden tomar los incrementos.
  ;; Ahora el coste por dejar espacios libres es entre 1 y 3 (1 por cada reserva asignada a una habitación sin llenarla)
  ;; Respecto al coste por abrir una nueva habitación, es suficiente aumentar en 2 el coste para priorizarlo, porque si abrimos una nueva habitación, se incrementará también el coste por desperdicio
  ;; y la función coste-total se incrementará en un valor en 3 (desperdicio + abierto, 1 + 2), y esto es siempre mayor que asignar una reserva a una habitación ya abierta (que solo incrementa el coste en 1 por desperdicio).
  ;; El único caso en que no se incrementa el coste por desperdicio cuando abrimos habitacion es cuando la habitación queda llena, 
  ;; entonces el coste solo aumentará en 2 por abrir la habitación, pero sigue siendo mayor que el desperdicio.
  ;; Por tanto, se minimizará primero el número de habitaciones usadas y luego el desperdicio de capacidad.

  ;; Por otro lado, el coste por no asignar una reserva debe ser mayor que el coste por abrir una nueva habitación y el coste de desperdicio juntos para priorizarlo siempre.
  ;; Entonces seria 1 + 2 < 4, por tanto, el coste por no asignar una reserva será 4. De esta manera, se minimizará las reservas no asignadas aunque tenga que abrir nuevas habitaciones y desperdiciar capacidad,
  ;; porque el coste-total siempre aumentará si no se asigna una reserva.

  ;; En resumen:
  ;; - En mejores casos, el coste-total no aumenta después de una iteración porque se ha asignado 1 reserva a una habitación ya abierta y la ha llenado. 
  ;; - Asignar 1 reserva a una habitación ya abierta y no llenarla: coste-total += 1
  ;; - Asignar 1 reserva a una habitación nueva y llenarla: coste-total += 2
  ;; - Asignar 1 reserva a una habitación nueva y no llenarla: coste-total += 3
  ;; - No asignar 1 reserva: coste-total += 4

  ;; Con esto, estamos definiendo lo siguiente:
  ;; Dado 1 reserva A con 1 persona, 1 reserva B con 3 personas, 1 habitación X que le queda 3 espacios y 1 habitación Y que le queda 1 espacio,
  ;; y el programa está evaluando la reserva A y luego pasará a evaluar la reserva B.
  ;; La mejor manera es asignar la reserva A a la habitación Y y luego asignar la reserva B a la habitación X (coste-total += 0) 
  ;; que si hubiera asignado la reserva A a la habitación X y luego asignar la reserva B a una nueva habitación (coste-total += 1 + 3)
  ;; o que si hubiera asignado la reserva A a una nueva habitación de capacidad 1 y luego asignar la reserva B a una nueva habitación de capacidad 3 (coste-total += 2 + 2).


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
        (not (vacio ?h))
        (decrease (capacidad-hab ?h) (pers-reserva ?r))
        (when (= (capacidad-hab ?h) (pers-reserva ?r)) (lleno ?h))
        (when (not (= (capacidad-hab ?h) (pers-reserva ?r))) (increase (coste-total) 1))

        ;; si abrimos una nueva habitacion, incrementamos el coste en 2
        (when (vacio ?h) (increase (coste-total) 2))
        
      )
  )

  (:action concluir
    :parameters (?r - reserva)
    :precondition 
      (and 
        (not (concluida ?r))
      )
    :effect 
      (and 
        (concluida ?r)
        (when (not (servida ?r)) (increase (coste-total) 4))
      )
  )
    

 ;; con esto definiremos lo siguiente:
        ;; Dado 3 reservas Ai con 1 persona, 1 reserva B con 3 personas, 1 habitación X ya abierta que le quedan 3 espacios,

        ;; Si se asignan las reservas de 1 persona a la habitación de 3 y no se asigna la reserva de 3 personas, el coste aumentará en 2 + 4 (1 por cada reserva asignada, excepto la última que llenará la habitación + 4 por no asignar una reserva).
        ;; Si se asignan las reservas de 1 persona a la habitación de 3 y se asigna la reserva de 3 personas a una nueva habitación de 3, el coste aumentará en 2 + 2 (1 por cada reserva asignada, excepto la última que llenará la habitación + 2 por abrir una nueva habitación).
        ;; Si se asignan las reservas de 1 persona a 3 habitaciones nuevas de 1 espacio y se asigna la reserva B a la habitación X, el coste aumentará en 6 (2 por cada habitación abierta).
        ;; Si se asignan las reservas de 1 persona a 1 habitación nueva de 3 espacios y se asigna la reserva B a la habitación X, el coste aumentará en 2 + 2 (2 por abrir una nueva habitación + 2 por desperdicio).

        ;; Podemos ver que la segunda opción y la cuarta opción son los mejores y tienen el mismo coste, por lo que el planificador puede elegir cualquiera de las dos.
        ;; Pero en los casos reales, las habitaciones de 1 espacio estarán siempre asignadas a reservas de 1 persona, ya que solo pueden servir para eso, y así se dejarán libres 
        ;; las habitaciones de mayor capacidad para reservas más grandes, minimizando el número de reservas no asignadas.

  
  
;; goal = (forall (?h - habitacion ?r - reserva) (< (capacidad-hab ?h) (pers-reserva ?r)))
;; metric minimize (coste-total)
)
  