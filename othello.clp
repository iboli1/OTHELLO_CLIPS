(defrule hasierakoTablerue
=>
(bind ?tablerue (create$))
(loop-for-count (?i 1 (* ?*N* ?*N*))
    (bind ?tablerue (create$ ?tablerue "-"))
    )
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