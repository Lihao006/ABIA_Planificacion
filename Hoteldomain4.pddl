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
  ;; Ahora el coste por dejar espacios libres en una sola habitación es entre 1 y 6 (1-2 por cada reserva asignada a una habitación)
  ;; - Es 1 por cada reserva asignada si se asignan n (1 o 3) reservas que llenan la habitación.
  ;; - Es 2 por cada reserva asignada si se asignan k (1 o 3) reservas que no llenan la habitación.
  ;; - Una habitación llenada por 1 sola reserva no incrementa el coste de desperdicio.
  
  ;; Respecto al coste por abrir una nueva habitación, es suficiente aumentar en 13 el coste para priorizarlo.
  ;; Al final de la planificación, la función coste-total se incrementará en un valor de:
  ;; - en 13 (desperdicio + abierto, 0 + 13), si la habitación nueva queda llena con 1 reserva asignada.
  ;; - en 15 a 17 (desperdicio + abierto, n + 13), donde n es entre 1 y 3 y indica las reservas asignadas que no han podido llenar la habitación, y al final la habitación queda llena.
      ;; por ejemplo, si una habitación de capacidad 4 se abre y se asignan 4 reservas de 1 persona, el coste de esta habitación será 13 (abierto) + 3 (desperdicio, 1 por cada reserva asignada que no llena la habitación) = 16.
  ;; - en 18, 22 o 26 (desperdicio + abierto, 3*k + n + 13), donde k es 1 o 3 y indica las reservas asignadas que no han podido llenar la habitación, y al final la habitación no queda llena, y que n=k.
      ;; por ejemplo, si una habitación de capacidad 4 se abre y se asignan 3 reservas de 1 persona, el coste de esta habitación será 13 (abierto) + 12 (desperdicio, 2 por cada reserva asignada que no llena la habitación) = 25.
  
  ;; De esta manera, si el programa tiene que elegir entre abrir una nueva habitación o asignar una reserva a una habitación ya abierta que tenga , siempre priorizará asignar a una habitación ya abierta porque el coste total aumentará 1 menos.

  ;; Por otro lado, el coste por no asignar una reserva debe ser mayor que el coste por abrir una nueva habitación y el coste de desperdicio juntos para priorizarlo siempre.
  ;; Entonces seria 12 + 13 = 25 < 26, por tanto, el coste por no asignar una reserva será 26. De esta manera, se minimizará las reservas no asignadas aunque tenga que abrir nuevas habitaciones y desperdiciar capacidad,
  ;; porque el coste-total siempre aumentará si no se asigna una reserva.

  ;; En resumen, al final de la planificación, cada habitación contribuirá al coste-total de la siguiente manera:
  ;; - Dada una habitación de capacidad arbitraria C,
  ;;   - Tiene asignada 1 reserva y llenarla:      coste-total += 0 por desperdicio + 13 por abrirla = 13
  ;;   - Tiene asignada 1 reserva sin llenarla:    coste-total += 4 por desperdicio + 13 por abrirla = 17
  ;;   - Tiene asignadas 2 reservas sin llenarla:  coste-total += 8 por desperdicio + 13 por abrirla = 21
  ;;   - Tiene asignadas 3 reservas sin llenarla:  coste-total += 12 por desperdicio + 13 por abrirla = 25
  ;;   - Tiene asignadas 4 reservas y queda llena: coste-total += 3 por desperdicio + 13 por abrirla = 16
  ;;   - Tiene asignadas 3 reservas y queda llena: coste-total += 2 por desperdicio + 13 por abrirla = 15
  ;;   - Tiene asignadas 2 reservas y queda llena: coste-total += 1 por desperdicio + 13 por abrirla = 14
  ;; - Si no se sirve una reserva:                 coste-total += 26

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
        ;; si abrimos una nueva habitacion, incrementamos el coste en 13
        (when (vacio ?h) (increase (coste-total) 13))

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
        (increase (coste-total) 26)
      )
  )

  (:action concluir-servidas
    :parameters (?r - reserva ?h - habitacion)
    :precondition 
      (and 
        (not (concluida ?r))
        (not (vacio ?h))
        (asignado ?r ?h)
      )
    :effect 
      (and 
        (concluida ?r)
        (when (not (lleno ?h)) (increase (coste-total) 4))
      )
  )
    
  
;; goal = (forall (?h - habitacion ?r - reserva) (< (capacidad-hab ?h) (pers-reserva ?r)))
;; metric minimize (coste-total)
)
  