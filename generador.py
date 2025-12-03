import random
import os
import argparse

random.seed(42)
parser = argparse.ArgumentParser()
parser.add_argument("num_problemas", type=int)
parser.add_argument("dominio")
parser.add_argument("-m", type=int, default=10)
parser.add_argument("-r", type=int, default=10)
parser.add_argument("-c", type=int, default=4)
parser.add_argument("-p", type=int, default=4)
parser.add_argument("--out", type=str, default=".")
args = parser.parse_args()

def CrearProblema(n, dominio, m=10, r=10, c=4, p=4, out="."):   
    '''
    Método para crear un problema PDDL de asignación de habitaciones de hotel a reservas.

    ### Parámetros:
    - n - Número del problema (entero).
    - domain - Nombre del dominio PDDL (string).

    - m=10 - Número máximo de habitaciones (entero).
    - r=10 - Número máximo de reservas (entero).
    - c=5 - Capacidad máxima de una habitación (entero).
    - p=5 - Número máxima de personas en una reserva (entero).
    - out="." - Carpeta donde guardar el archivo (string).
    '''
     
    # Crear objetos
    habitaciones = [(f"h{i}", random.randint(1, c))
                    for i in range(1, random.randint(m, m))]
    reservas = [(f"r{j}", random.randint(1, p))
                for j in range(1, random.randint(r, r))]

    os.makedirs(out, exist_ok=True)

    # Escribir el archivo PDDL
    with open(f"{out}/problema_{n}.pddl", "w") as f:
        f.write(f"""(define (problem problema_{n})
            (:domain {dominio})

        (:objects 
            {' '.join([h[0] for h in habitaciones])} - habitacion
            {' '.join([r[0] for r in reservas])} - reserva
        )
        (:init 
            (coste-total 0)

            {''.join([f"(capacidad-hab {h[0]} {h[1]})\n\t\t\t" for h in habitaciones])}
            {''.join([f"(pers-reserva {r[0]} {r[1]})\n\t\t\t" for r in reservas])}
            {''.join([f"(vacio {h[0]})\n\t\t\t" for h in habitaciones])}
        )
        
        (:goal
            (forall (?h - habitacion ?r - reserva) (< (capacidad-hab ?h) (pers-reserva ?r)))
        )

        (:metric minimize (coste-total))
    )""")

def CrearNProblemas(num_problemas, dominio, m=10, r=10, c=4, p=4, out="."):
    '''
    Método para crear varios problemas PDDL de asignación de habitaciones de hotel a reservas.

    ### Parámetros:
    - num_problemas - Número de problemas a crear (entero).
    - domain - Nombre del dominio PDDL (string).

    - m=10 - Número máximo de habitaciones (entero).
    - r=10 - Número máximo de reservas (entero).
    - c=5 - Capacidad máxima de una habitación (entero).
    - p=5 - Número máxima de personas en una reserva (entero).
    - out="." - Carpeta donde guardar los archivos (string).
    '''
    for n in range(1, num_problemas + 1):
        CrearProblema(n, dominio, m, r, c, p, out)

if __name__ == "__main__":
    num_problemas = args.num_problemas  # Número de problemas a crear
    dominio = args.dominio  # Nombre del dominio PDDL
    carpeta = args.out  # Carpeta de salida
    CrearNProblemas(num_problemas, dominio, m=args.m, r=args.r, c=args.c, p=args.p, out=carpeta)
    print(f"{num_problemas} problemas creados en la carpeta '{carpeta}'")
