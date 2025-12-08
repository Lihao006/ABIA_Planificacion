(define (problem problemaExp3Basic)
            (:domain HoteldomainBasic)

        (:objects 
            h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 - habitacion
            r1 r2 r3 r4 r5 - reserva
        )
        (:init 

            (= (capacidad-hab h1) 1)
			(= (capacidad-hab h2) 3)
			(= (capacidad-hab h3) 2)
			(= (capacidad-hab h4) 2)
			(= (capacidad-hab h5) 2)
			(= (capacidad-hab h6) 1)
			(= (capacidad-hab h7) 3)
			(= (capacidad-hab h8) 4)
			(= (capacidad-hab h9) 1)
			(= (capacidad-hab h10) 4)
			
            (= (pers-reserva r1) 2)
			(= (pers-reserva r2) 3)
			(= (pers-reserva r3) 1)
			(= (pers-reserva r4) 2)
			(= (pers-reserva r5) 4)
			
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
            (forall (?r - reserva) (servida ?r))
        )
    )