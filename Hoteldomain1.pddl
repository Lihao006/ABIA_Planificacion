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
    (hay-personas ?h - habitacion)
    ;; cuando una habitacion no está llena ni hay personas, está vacía
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
    (num-asignaciones)
    (coste-habs)
    (coste-desperdicio)
    ;; (coste-orien-incorrecta)
    
  
    (heuristica)
    ;; heuristica = num-asignaciones - coste-habs - coste-desperdicio
    ;; Queremos maximizar num-asignaciones y minimizar coste-habs y coste-desperdicio = maximizar heuristica
  )

  ;; Prioridades de la extensión 4:
  ;; 1. Asignar reservas (maximizar num-asignaciones)
  ;; 2. Minimizar numero de habitaciones usadas (num-habs)
  ;; 3. Minimizar desperdicio de capacidad (coste-desperdicio)

  ;; Las prioridades lo gestionaremos por el rango de valores que pueden tomar los incrementos y decrementos.
  ;; Ponemos por ejemplo 8 para num-asignaciones, 4 para coste-habs y el desperdicio tendrá un valor entre 0 y 3.
  ;; Los valores de los costes puede ser entre 4 y 7 (coste-habs - coste-desperdicio).
  
  ;; De esta forma, asignar una reserva siempre saldrá ganando (gana almenos 1 en la heuristica) frente a no asignarla,
  ;; por consecuencia, eliminar una reserva asignada siempre será peor que asignarla (pierde almenos 1 en la heuristica).

  ;; Por otro lado, minimizar el número de habitaciones usadas siempre saldrá ganando más que minimizar el desperdicio (hay una diferencia de 1 en la heurística),
  ;; pero 

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
        (hay-personas ?h)
        (increase (pers-hab ?h) (pers-reserva ?r))
        (increase (num-asignaciones) 8)
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
  