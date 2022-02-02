(defrule ini
    (declare (salience 200))
    =>
    (set-strategy random)
)

(defrule controlar-impaciente
    (declare (salience 50))
    ?paciente <- (object (is-a PACIENTE) (personalidad impaciente)(personalidad-controlada no))
    ?juego <- (object (is-a JUEGO) (puntuacion-maxima ?p))
    =>
    (bind ?p ( - ?p 1))
    (modify-instance ?paciente (personalidad-controlada si))
    (modify-instance ?juego (puntuacion-maxima ?p))
    (printout t "Debido a que el niño es impaciente el robot ha decidido reducir la puntuación máxima a " ?p crlf)
)

(defrule controlar-tramposo
    (declare (salience 50))
    ?paciente <- (object (is-a PACIENTE)(puntuacion ?ppaciente) (personalidad tramposo)(personalidad-controlada no))
    ?robot <- (object (is-a ROBOT) (puntuacion ?probot))
    (test (= ?ppaciente (+ ?probot 1)))  
    =>
    (printout t "El paciente ha hecho trampas" crlf)
    (printout t "El robot le resta un punto a su puntuacion consecuentemente" crlf)
    
    (bind ?ppaciente ( - ?ppaciente 1))
    (modify-instance ?paciente (puntuacion ?ppaciente))
    (printout t "Ahora la puntuacion del paciente ha disminuido a " ?ppaciente crlf)

    (modify-instance ?paciente (personalidad-controlada si))
)

(defrule controlar-agresivo
    (declare (salience 50))
    ?paciente <- (object (is-a PACIENTE)(puntuacion ?ppaciente) (personalidad agresivo)(personalidad-controlada no))
    ?robot <- (object (is-a ROBOT) (puntuacion ?probot))
    (test (= ?ppaciente (- ?probot 1)))  
    =>
    (printout t "El paciente agrede al robot porque pierde por diferencia de 2 puntos" crlf)
    (printout t "El robot escarmienta al niño, le pide respetuosamente que no lo repita y le resta un punto" crlf)
    
    (bind ?ppaciente ( - ?ppaciente 1))
    (modify-instance ?paciente (puntuacion ?ppaciente))
    (printout t "Ahora la puntuacion del paciente ha disminuido a " ?ppaciente crlf)

    (modify-instance ?paciente (personalidad-controlada si))
)

(defrule jugador-lanza-piedra-dentro
    (casilla dentro ?c)
    ?jugador <- (object (is-a JUGADOR) (nombre ?t) (puntuacion ?p)(posicion ?pos))
    ?v <- (object (is-a JUEGO) (turno ?t) (juego-actual rayuela))
    (test(= ?pos 0))
    =>
    (assert (movimiento ?t ida))
    (assert (posicion-piedra ?c))
    (printout t "El " ?t " ha lanzado la piedra en la posicion " ?c crlf)
)

(defrule jugador-lanza-piedra-fuera
    (casilla fuera ?c)
    ?jugador <- (object (is-a JUGADOR) (nombre ?t) (puntuacion ?p)(posicion ?pos))
    ?v <- (object (is-a JUEGO) (turno ?t) (juego-actual rayuela))
    (alternativa ?t ?alternativa)
    (test(= ?pos 0))
    =>
    (modify-instance ?v (turno ?alternativa))
    (printout t "El " ?t " ha lanzado la piedra incorrectamente: " ?c crlf)
)

(defrule jugador-va (declare (salience 5))
    (posicion-piedra ?c)
    (movimiento ?t ida)
    ?jugador <- (object (is-a JUGADOR) (nombre ?t) (puntuacion ?p)(posicion ?pos))
    (test(< ?pos 9))
    (not(test(= (+ 1 ?pos) ?c)))
    =>
    (bind ?pos (+ ?pos 1))
    (modify-instance ?jugador (posicion ?pos))
    (printout t "(ida) El " ?t " se ha movido a la posicion " ?pos crlf)
)

(defrule jugador-esquiva-piedra (declare (salience 5))
    (posicion-piedra ?c)
    (movimiento ?t ida)
    ?jugador <- (object (is-a JUGADOR)(nombre ?t)(puntuacion ?p)(posicion ?pos))
    (test(< ?pos 9))
    (test(= (+ 1 ?pos) ?c))
    =>
    (bind ?pos (+ ?pos 2))
    (modify-instance ?jugador (posicion ?pos))
    (printout t "(ida) El " ?t " esquivó la piedra y se ha movido a la posicion " ?pos crlf)
)

(defrule jugador-pisa-piedra (declare (salience 5))
    (alternativa ?t ?alternativa)
    ?pospiedra <- (posicion-piedra ?c)
    ?f <- (movimiento ?t ida)
	?v <- (object (is-a JUEGO) (turno ?t) (juego-actual rayuela))
    ?jugador <- (object (is-a JUGADOR) (nombre ?t) (puntuacion ?p)(posicion ?pos))
    (test(< ?pos 9))
    (test(= (+ 1 ?pos) ?c))
    =>
    (bind ?pos 0)
    (modify-instance ?jugador (posicion ?pos))
	(modify-instance ?v (turno ?alternativa))
	(retract ?f)
    (retract ?pospiedra)
    (printout t "(ida) El " ?t " pisó la piedra y ha perdido el turno" crlf)
)

(defrule jugador-debe-volver (declare (salience 10))
    (movimiento ?t ida)
    ?f <- (movimiento ?t ida)
    ?jugador <- (object (is-a JUGADOR) (nombre ?t) (puntuacion ?p)(posicion ?pos))
    (test(>= ?pos 9))
    =>
    (bind ?pos (- ?pos 1))
    (retract ?f)
    (assert(movimiento ?t vuelta))
    (modify-instance ?jugador (posicion ?pos))
    (printout t "(vuelta) El "?t" comienza la vuelta y se ha movido a la posicion " ?pos crlf)
)

(defrule jugador-vuelve (declare (salience 5))
    (movimiento ?t vuelta)
    ?jugador <- (object (is-a JUGADOR) (nombre ?t) (puntuacion ?p)(posicion ?pos))
    (test(> ?pos 0))
    =>
    (bind ?pos (- ?pos 1))
    (modify-instance ?jugador (posicion ?pos))
    (printout t "(vuelta) El "?t" se ha movido a la posicion " ?pos crlf)
)

(defrule jugador-rocoge-piedra (declare (salience 8))
    (movimiento ?t vuelta)
    (posicion-piedra ?c)
    ?f <- (posicion-piedra ?c)
    ?jugador <- (object (is-a JUGADOR) (nombre ?t) (puntuacion ?p)(posicion ?pos))
    (test (= ?pos ?c))
    =>
    (printout t "(vuelta) El "?t" recoge la piedra en la posicion " ?pos crlf)
    (bind ?pos (- ?pos 1))
    (retract ?f)
)

(defrule jugador-completa-ronda (declare (salience 15))
    (alternativa ?t ?alternativa)
    ?f <- (movimiento ?t vuelta)
    ?jugador <- (object (is-a JUGADOR) (nombre ?t) (puntuacion ?p)(posicion ?pos))
    ?juego <- (object (is-a JUEGO) (ronda ?r))
    (test(= ?pos 0))
    =>
    (bind ?p (+ ?p 1))
    (printout t "El " ?t " ha ganado la ronda " ?r crlf)
    (bind ?r (+ ?r 1))
    (retract ?f)
    (modify-instance ?jugador (puntuacion ?p))
    (modify-instance ?juego (ronda ?r) (turno ?alternativa))
)

(defrule eleccion-rojo-jugador
    (alternativa ?t ?alternativa)
    (bola rojo ?pr)
    ?jugador <- (object (is-a JUGADOR) (nombre ?t) (puntuacion ?p))
    ?v <- (object (is-a JUEGO) (turno ?t) (ronda ?rnd) (juego-actual trilleros))
    (eleccion ?t ?e)
    (test (= ?pr ?e))
    =>
    (bind ?p (- ?p 1))
    (modify-instance ?v (turno ?alternativa) (ronda (+ ?rnd 1)))
    (modify-instance ?jugador (puntuacion ?p))
    (printout t "El " ?t " ha encontrado un bola roja la posicion " ?e crlf)
    (printout t "La puntuacion del " ?t " es ahora " ?p crlf)
)

(defrule eleccion-verde-jugador
    (alternativa ?t ?alternativa)
    (bola verde ?pr)
    ?jugador <- (object (is-a JUGADOR) (nombre ?t) (puntuacion ?p))
    ?v <- (object (is-a JUEGO) (turno ?t) (ronda ?rnd) (juego-actual trilleros))
    (eleccion ?t ?e)
    (test (= ?pr ?e))
    =>
    (bind ?p (+ ?p 1))
    (modify-instance ?v (turno ?alternativa) (ronda (+ ?rnd 1)))
    (modify-instance ?jugador (puntuacion ?p))
    (printout t "El " ?t " ha encontrado un bola verde la posicion " ?e crlf)
    (printout t "La puntuacion del " ?t " es ahora " ?p crlf)
)

(defrule eleccion-vacia-jugador
    (bola rojo ?pr)
    (bola verde ?pv)
    ?jugador <- (object (is-a JUGADOR) (nombre ?t) (puntuacion ?p))
    ?v <- (object (is-a JUEGO) (turno ?t) (ronda ?rnd) (juego-actual trilleros))
    (eleccion ?t ?e)
    (not (test (= ?pr ?e)))
    (not (test (= ?pv ?e)))
    =>
    (modify-instance ?v (ronda (+ ?rnd 1)))
    (printout t "El " ?t " no ha encontrado ninguna bola en la posicion " ?e crlf)
)

(defrule jugador-gana (declare (salience 100))
    (object (is-a JUGADOR) (nombre ?t) (puntuacion ?p))
    ?j <- (object (is-a JUEGO) (puntuacion-maxima ?pm))
    (test (= ?p ?pm))
    =>
    (modify-instance ?j (juego-actual ninguno))
    (printout t "El " ?t " ha ganado!!!!!!!!!!" crlf)
)
