(defclass JUGADOR (is-a USER)
    (slot nombre
        (type SYMBOL)
        (allowed-values robot paciente)
    )
    (slot puntuacion
        (type INTEGER)
        (default 0)
    )
    (slot turno
        (type SYMBOL)
        (allowed-values paciente robot)
    )
    (slot posicion
        (type INTEGER)
        (default 0)
    )
)

(defclass ROBOT (is-a JUGADOR))

(defclass PACIENTE (is-a JUGADOR)
    (slot personalidad
        (type SYMBOL)
        (allowed-values normal tramposo agresivo impaciente)
        (default normal)
    )
    (slot personalidad-controlada
        (type SYMBOL)
        (allowed-values si no)
        (default no)
    )
)

(defclass JUEGO (is-a USER)
    (slot puntuacion-maxima (type INTEGER))
    (slot turno (type SYMBOL) (allowed-values paciente robot) (default robot))
    (slot ronda (type INTEGER) (default 0))
    (slot juego-actual (type SYMBOL) (allowed-values trilleros rayuela ninguno))
)
