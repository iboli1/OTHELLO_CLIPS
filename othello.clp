(defrule hasierakoTablerue
  (declare (salience 30)) ;beti lehena
=>
  (bind ?tablerue (create$))
    (loop-for-count (?i 1 (* ?*N* ?*N*))
      (if (or (= ?i 6) (= ?i 11)) then
        (bind ?tablerue (create$ ?tablerue "z"))
      else 
        (if (or (= ?i 7) (= ?i 10)) then
          (bind ?tablerue (create$ ?tablerue "b"))
        else (bind ?tablerue (create$ ?tablerue "-")))
      )
    )
    (assert (fitxakop 4))
    (assert (txanda beltza)) ; fitxa beltzak dituena hasten da, gure kasuan jokalaria izango da
    (assert (tablerue ?tablerue))
)

(defrule erakutsiTablerue
  (declare (salience 10))
  (tablerue $?t)   
=>
  (loop-for-count (?i 1 (* ?*N* ?*N*))
    (printout t (nth$ ?i ?t) " ")
    (if (= (mod ?i ?*N*) 0) then
      (printout t crlf)
    )
  )
) 

(defrule jokalariarenTxanda
  (declare (salience 5))
  ?table <- (tablerue $?t)
  ?txanda <- (txanda beltza)
  ?fitxakop <- (fitxakop ?f)
=>
  (printout t "Zure txanda da" crlf)
  (bind ?pos (read))
  (if (and (and (eq (nth$ ?pos $?t) "-") (>= ?pos 1)) (<= ?pos ?*LENGTH*)) then
    (printout t "Mugimendu legala" crlf)
    (assert (fitxakop (+ ?f 1)))
    (retract ?fitxakop)
    (assert (txanda zuria))
    (retract ?txanda)
    (assert (tablerue (replace$ $?t ?pos ?pos "b")))
    (retract ?table)
  else 
    (printout t "Ez da mugimendu legala" crlf)
  )

)

(defrule agentearenTxanda
(declare (salience 5))
  ?table <- (tablerue $?t)
  ?txanda <- (txanda zuria)
  ?fitxakop <- (fitxakop ?f)
=>
  (printout t "Agentearen txanda da" crlf)
)

(defrule amaitu
  (declare (salience 20))
  (fitxakop ?fitxakop)
  (test (= ?fitxakop ?*LENGTH*))
=>
  (printout t "Jokoa amaitu da" crlf)
  (halt)
)