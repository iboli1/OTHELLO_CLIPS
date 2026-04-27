(defrule hasierakoTablerue
  (declare (salience 30)) ;beti lehena
=>
  (bind ?tablerue (create$))
    (loop-for-count (?i 1 (* ?*N* ?*N*))
      (if (or (= ?i (+ (* (- (/ ?*N* 2) 1) ?*N*) (/ ?*N* 2))) (= ?i (+ (* (/ ?*N* 2) ?*N*) (/ ?*N* 2) 1))) then
        (bind ?tablerue (create$ ?tablerue "z"))
      else 
        (if (or (= ?i (+(+ (* (- (/ ?*N* 2) 1) ?*N*) (/ ?*N* 2)) 1)) (= ?i (+ (* (/ ?*N* 2) ?*N*) (/ ?*N* 2)))) then
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

(deffunction mugimenduLegala ($?tableroa ?pos)
  (bind ?badago 0)
  (bind ?hasierakoP)
  ;gorantz
  (bind ?i ?pos)

  (bind ?norantzak (create$ (* ?*N* -1) (- 1 ?*N*) 1 (+ ?*N* 1) ?*N* (- ?*N* 1) -1 (- -1 ?*N*)))

  (loop-for-count (?i 1 (length$ ?norantzak)))

  (while (or (> ?i 1)  (< ?i ?*N*))
    
  )
  (return ?badago)
)

(defrule amaitu
  (declare (salience 20))
  (fitxakop ?fitxakop)
  (test (= ?fitxakop ?*LENGTH*))
=>
  (printout t "Jokoa amaitu da" crlf)
  (halt)
)



;mugen barruan badago 1 itzuli, kanpoan badago 0
(deffunction mugenBarruan (?pos)
  (if (and (>= ?pos 1) (<= ?pos ?*LENGTH*)) then
    (return 1)
  else
    (return 0)
  )
)

;okupatuta badago, 0 itzuli, libre badago 1
(deffunction libreDago (?tablerue ?pos)
  (if (eq (nth$ ?pos $?tablerue) "-") then
    (return 1)
  else
    (return 0)
  )
)

;norantza ona bada, 1 itzuli, norantza matrizearen ertzetatik ateratzen bada, 0
(deffunction norantzaOna (?tablerue ?norantza ?pos)
  (bind ?berria (+ ?pos ?norantza))

  ;ertza goian edo behean
  (if (eq (mugenBarruan ?berria) 0) then
    (return 0)
  )

  ;ertza ezkerrean edo eskuinean
  (if (and (not (eq (- (mod ?berria ?*N*) 1) (- (mod ?pos ?*N*) 1)) and (or (eq (- ?berria 1) ?pos) (eq (+ ?berria 1) ?pos)) (or (eq (+ ?pos 1) ?berria) (eq (- ?pos 1) ?berria)))) then
    (return 0)
  )
)