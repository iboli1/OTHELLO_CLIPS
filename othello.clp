(defrule hasierakoTablerue
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
  (assert (tablerue ?tablerue))
)

(defrule erakutsiTablerue
  (tablerue $?t)   
=>
  (loop-for-count (?i 1 (* ?*N* ?*N*))
    (printout t (nth$ ?i ?t) " ")
    (if (= (mod ?i ?*N*) 0) then
      (printout t crlf)
    )
  )
) 



(defrule amaitu
  (declare (salience 20))
  (fitxakop ?fitxakop)
  (test (= ?fitxakop ?*LENGTH*))
=>
  (printout t "Jokoa amaitu da" crlf)
  (halt)
)