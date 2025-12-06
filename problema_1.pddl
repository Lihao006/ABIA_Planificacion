(define (problem problema_1)
            (:domain Hoteldomain4)

        (:objects 
            h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 - habitacion
            r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 - reserva
        )
        (:init 
            (= (coste-total) 0)

            (= (capacidad-hab h1) 1)
			(= (capacidad-hab h2) 3)
			(= (capacidad-hab h3) 2)
			(= (capacidad-hab h4) 2)
			(= (capacidad-hab h5) 2)
			(= (capacidad-hab h6) 1)
			(= (capacidad-hab h7) 1)
			(= (capacidad-hab h8) 4)
			(= (capacidad-hab h9) 1)
			(= (capacidad-hab h10) 1)
			
            (= (pers-reserva r1) 2)
			(= (pers-reserva r2) 2)
			(= (pers-reserva r3) 1)
			(= (pers-reserva r4) 2)
			(= (pers-reserva r5) 4)
			(= (pers-reserva r6) 2)
			(= (pers-reserva r7) 4)
			(= (pers-reserva r8) 3)
			(= (pers-reserva r9) 1)
			(= (pers-reserva r10) 2)
			
            (vacio h1)
			(vacio h2)
			(vacio h3)
			(vacio h4)
			(vacio h5)
			(vacio h6)
			(vacio h7)
			(vacio h8)
			(vacio h9)
			(vacio h10)
			
        )
        
		(:goal
			(forall (?r - reserva) (concluida ?r))
		)

        (:metric minimize (coste-total))
    )