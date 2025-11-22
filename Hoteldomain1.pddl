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
    ;; Espacios sin ocupar de cada habitación
    (capacidad-hab ?h - habitacion)

    (pers-reserva ?r - reserva)
    
    (dia-inicio ?r - reserva)
    (dia-fin ?r - reserva)
    
    ;; criterios a optimizar
    (asignaciones)
    (coste-habs)
    (coste-desperdicio)
    (hab-llenas)
    ;; (coste-orien-incorrecta)
    
  
    (heuristica)
    ;; heuristica = asignaciones - coste-habs - coste-desperdicio + hab-llenas
    ;; Queremos maximizar asignaciones y hab-llenas, después minimizar coste-habs y coste-desperdicio = maximizar heuristica
  )

  ;; Prioridades de la extensión 4:
  ;; 1. Asignar reservas (maximizar asignaciones)
  ;; 2. Minimizar numero de habitaciones usadas (num-habs)
  ;; 3. Minimizar desperdicio de capacidad (coste-desperdicio)

  ;; Las prioridades lo gestionaremos por el rango de valores que pueden tomar los incrementos y decrementos.
  ;; Ponemos por ejemplo 8 para asignaciones, 4 para coste-habs y el desperdicio tendrá un valor entre 0 y 3.
  ;; Los valores de los costes puede ser entre 4 y 7 (coste-habs + coste-desperdicio).
  
  ;; De esta forma, asignar una reserva siempre saldrá ganando (gana almenos 1 en la heuristica) frente a no asignarla,
  ;; por consecuencia, eliminar una reserva asignada siempre será peor que asignarla (pierde almenos 1 en la heuristica).

  ;; Por otro lado, minimizar el número de habitaciones usadas siempre saldrá ganando más que minimizar el desperdicio (hay una diferencia de 1 en la heurística).

  ;; Si asignamos una reserva a una habitación ya ocupada parcialmente, no incrementamos el coste-habs, reducimos el desperdicio y aumentamos asignaciones,
  ;; de manera que la heurística aumenta almenos en 9 (8 por asignaciones y almenos 1 por reducción del desperdicio), hasta un máximo de 11.
  ;; De esta manera le damos mucha prioridad a asignar reservas a habitaciones ya usadas, si es posible.

  ;; Para mejorar las asignaciones a habitaciones ya usadas, debemos considerar como mejor opción cuando se asignan reservas y la habitación
  ;; queda llena, así priorizamos en llenar habitaciones ya usadas frente a dejar espacio libre.
  ;; Para hacerlo, cuando una habitación queda llena, incrementamos el valor de hab-llenas en 1,
  ;; de manera que la heurística aumenta almenos en 10 (8 por asignaciones, 0 por coste-habs, almenos 1 por reducción del desperdicio y 1 por hab-llenas) 
  ;; cuando se llena la habitación, hasta un máximo de 12.
  
  ;; Con esto, estamos definiendo lo siguiente:
  ;; Dado 1 reserva A con 1 persona, 1 reserva B con 3 personas, 1 habitación X que le queda 3 espacios y 1 habitación Y que le queda 1 espacio,
  ;; y el programa está evaluando la reserva A y luego pasará a evaluar la reserva B.
  ;; La mejor manera es asignar la reserva A a la habitación Y y luego asignar la reserva B a la habitación X (heurística + 10 + 12 = 22) 
  ;; que si hubiera asignado la reserva A a la habitación X y luego asignar la reserva B a una nueva habitación (heurística + 9 + 4 = 13).
  ;; Para obtener el mejor resultado, el programa debe asignar primero la reserva A a la habitación Y, y esto lo logramos con la función hab-llenas,
  ;; ya que la heurística mejora en 1 más si la asigna a la habitación Y que si la asigna a la habitación X.

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
        (increase (asignaciones) 8)
        (increase (coste-habs) 4)
        (increase (coste-desperdicio)
                  (- (capacidad-hab ?h) (pers-reserva ?r))
        )

        (when (= (capacidad-hab ?h) 0)
          (lleno ?h)
          (increase (hab-llenas) 1)
        )
      )
  )

)
  