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
    ;; Capacidad maxima de cada habitación
    (capacidad-hab ?h - habitacion)

    ;; Personas actualmente asignadas a cada habitación
    (pers-hab ?h - habitacion)

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
  ;; Dado 1 reserva con 1 persona, 1 habitación que le queda 3 espacios y 1 habitación que le queda 1 espacio,
  ;; es mejor asignar la reserva a la habitación que le queda 1 espacio (heurística + 10) que a la que le quedan 3 espacios (heurística + 9).
  ;; Por tanto, la heurística siempre aumenta en 1 más cuando la habitación queda llena que si no queda llena.

  (:action asignar-habitacion
    :parameters (?r - reserva ?h - habitacion)
    :precondition 
      (and 
        (not (servida ?r))
        (not (lleno ?h))
        ;; (not (asignado ?r ?h)) ;; con ver que la reserva no esté servida es suficiente.
        (>= (pers-hab ?h) (pers-reserva ?r))
      )
    :effect 
      (and 
        (asignado ?r ?h)
        (servida ?r)
        (increase (pers-hab ?h) (pers-reserva ?r))
        (increase (asignaciones) 8)
        (increase (coste-habs) 4)
        (increase (coste-desperdicio)
                  (- (capacidad-hab ?h) (pers-hab ?h))
        )

        (when (= (pers-hab ?h) (capacidad-hab ?h))
          (lleno ?h)
        )
      )
  )


)
  