(deffacts casillas-rayuela
    (casilla dentro 1)
    (casilla dentro 2)
    (casilla dentro 3)
    (casilla dentro 4)
    (casilla dentro 5)
    (casilla dentro 6)
    (casilla dentro 7)
    (casilla dentro 8)
    
    (casilla fuera linea)
    (casilla fuera fuera)
)

(deffacts posibles-elecciones
    (bola rojo 1)
    (bola rojo 2)
    (bola rojo 3)

    (bola verde 1)
    (bola verde 2)
    (bola verde 3)

    (eleccion robot 1)
    (eleccion robot 2)
    (eleccion robot 3)

    (eleccion paciente 1)
    (eleccion paciente 2)
    (eleccion paciente 3)
)

(deffacts hechos
    (alternativa robot paciente)
    (alternativa paciente robot)
)

(definstances ini
    ([p] of PACIENTE (nombre paciente) (personalidad tramposo))
    ([r] of ROBOT (nombre robot))
    ([j] of JUEGO (puntuacion-maxima 3)(juego-actual rayuela))
)