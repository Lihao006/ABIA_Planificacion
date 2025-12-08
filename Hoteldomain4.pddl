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
  ;; Ahora el coste por dejar espacios libres en una sola habitación es entre 0 y 6 (n*c + n)
  ;; Una habitación llenada por 1 sola reserva no incrementa el coste de desperdicio.
  
  ;; Respecto al coste por abrir una nueva habitación, es suficiente aumentar en 7 el coste para priorizarlo.
  ;; Al final de la planificación, la función coste-total se incrementará en un valor de:
  ;; - en 7 (desperdicio + abierto, 0 + 7), si la habitación nueva queda llena con 1 reserva asignada.
  ;; - en 8 a 13 (desperdicio + abierto, ((n*c + n) + 7)
      ;; por ejemplo, si una habitación de capacidad 4 se abre y se asignan 4 reservas de 1 persona, el coste de esta habitación será 7 (abierto) + 3 (desperdicio, 1 por cada reserva asignada que no llena la habitación) = 10.
      ;; por ejemplo, si una habitación de capacidad 4 se abre y se asignan 3 reservas de 1 persona, el coste de esta habitación será 7 (abierto) + 3 (desperdicio, 1 por cada reserva asignada que no llena la habitación) * 1 (capacidad restante de la habitación) + 3 = 13.
  
  ;; De esta manera, si el programa tiene que elegir entre abrir una nueva habitación o asignar una reserva a una habitación ya abierta que tenga , siempre priorizará asignar a una habitación ya abierta porque el coste total aumentará 1 menos.

  ;; Por otro lado, el coste por no asignar una reserva debe ser mayor que el coste por abrir una nueva habitación y el coste de desperdicio juntos para priorizarlo siempre.
  ;; Entonces seria 6 + 7 = 13 < 14, por tanto, el coste por no asignar una reserva será 14. De esta manera, se minimizará las reservas no asignadas aunque tenga que abrir nuevas habitaciones y desperdiciar capacidad,
  ;; porque el coste-total siempre aumentará si no se asigna una reserva.

  ;; En resumen, al final de la planificación, cada habitación contribuirá al coste-total de la siguiente manera:
  ;; - Dada una habitación de capacidad arbitraria,
  ;;   - Tiene asignada 1 reserva y llenarla:                  coste-total += 0 por desperdicio + 7 por abrirla = 7
  ;;   - Tiene asignadas 2 reservas y llenarla:                coste-total += 1 por desperdicio + 7 por abrirla = 8
  ;;   - Tiene asignadas 3 reservas y llenarla:                coste-total += 2 por desperdicio + 7 por abrirla = 9
  ;;   - Tiene asignadas 4 reservas y llenarla:                coste-total += 3 por desperdicio + 7 por abrirla = 10
  
  ;;   - Tiene asignadas 1 reservas y le queda {3,2,1} plazas: coste-total += 1 + {3,2,1} por desperdicio + 7 por abrirla = 8 + {1,2,3} => [9, 12]
  ;;   - Tiene asignadas 2 reservas y le queda {2,1} plazas:   coste-total += 2 + 2*{2,1} por desperdicio + 7 por abrirla = 9 + 2*{1,2}  => [11, 13]
  ;;   - Tiene asignadas 3 reservas y le queda 1 plaza:        coste-total += 3 + 3*1 por desperdicio + 7 por abrirla = 13
  ;; - Si no se sirve una reserva:                             coste-total += 14

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
        ;; si abrimos una nueva habitacion, incrementamos el coste en 7
        (when (vacio ?h) (increase (coste-total) 7))

        (asignado ?r ?h)
        (servida ?r)
        (not (vacio ?h))
        (decrease (capacidad-hab ?h) (pers-reserva ?r))
        (when (= (capacidad-hab ?h) (pers-reserva ?r)) (lleno ?h))
        (when (not (= (capacidad-hab ?h) (pers-reserva ?r))) (increase (coste-total) 1))
      )
  )

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
        (increase (coste-total) 14)
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
        (when (= (capacidad-hab ?h) 1) (increase (coste-total) 1))
        (when (= (capacidad-hab ?h) 2) (increase (coste-total) 2))
        (when (= (capacidad-hab ?h) 3) (increase (coste-total) 3))
      )
  )
    
  
;; goal = (forall (?h - habitacion ?r - reserva) (< (capacidad-hab ?h) (pers-reserva ?r)))
;; metric minimize (coste-total)
)
  