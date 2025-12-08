(define (problem problemaExp2_10)
            (:domain Hoteldomain1)

        (:objects 
            h1 h2 h3 h4 h5 - habitacion
            r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 - reserva
        )
        (:init 
            (= (coste-total) 0)

            (= (capacidad-hab h1) 1)
			(= (capacidad-hab h2) 3)
			(= (capacidad-hab h3) 2)
			(= (capacidad-hab h4) 2)
			(= (capacidad-hab h5) 4)
			
            (= (pers-reserva r1) 1)
			(= (pers-reserva r2) 4)
			(= (pers-reserva r3) 3)
			(= (pers-reserva r4) 1)
			(= (pers-reserva r5) 3)
			(= (pers-reserva r6) 2)
			(= (pers-reserva r7) 2)
			(= (pers-reserva r8) 1)
			(= (pers-reserva r9) 2)
			(= (pers-reserva r10) 4)
			
            (vacio h1)
			(vacio h2)
			(vacio h3)
			(vacio h4)
			(vacio h5)
			
        )
        
        (:goal
            (forall (?r - reserva) (concluida ?r))
        )

        (:metric minimize (coste-total))
    )