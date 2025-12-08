(define (problem problemaExp3b)
            (:domain Hoteldomain4)

        (:objects 
            h1 h2 h3 h4 h5 - habitacion
            r1 r2 r3 r4 r5 - reserva
        )
        (:init 
            (= (coste-total) 0)

			(vacio h1)
			(vacio h2)
			(vacio h3)
			(vacio h4)
			(vacio h5)		
            
            (= (capacidad-hab h1) 4)
			(= (capacidad-hab h2) 4)
			(= (capacidad-hab h3) 4)
			(= (capacidad-hab h4) 4)
			(= (capacidad-hab h5) 2)

			
			(= (pers-reserva r1) 2)
			(= (pers-reserva r2) 1)
			(= (pers-reserva r3) 1)
			(= (pers-reserva r4) 1)
			(= (pers-reserva r5) 2)
        
			
        )
        
        (:goal
            (forall (?r - reserva) (concluida ?r))
        )

        (:metric minimize (coste-total))
    )