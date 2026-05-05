;ERREGELAK

(defrule hasierakoTablerue
  (declare (salience 30)) ;beti lehena
=>
  (bind ?tablerue (create$))
  (loop-for-count (?i 1 (* ?*N* ?*N*))
     (if (or (= ?i (+ (* (- (/ ?*N* 2) 1) ?*N*) (/ ?*N* 2))) (= ?i (+ (* (/ ?*N* 2) ?*N*) (/ ?*N* 2) 1))) then
       (bind ?tablerue (create$ ?tablerue "⚪"))
     else 
       (if (or (= ?i (+(+ (* (- (/ ?*N* 2) 1) ?*N*) (/ ?*N* 2)) 1)) (= ?i (+ (* (/ ?*N* 2) ?*N*) (/ ?*N* 2)))) then
         (bind ?tablerue (create$ ?tablerue "⚫"))
       else (bind ?tablerue (create$ ?tablerue "  ·  ")))
     )
   )
  (assert (fitxakop 4))
  (assert (txanda beltza)) ; fitxa beltzak dituena hasten da
  (assert (tablerue ?tablerue))
  (assert (mugimendurikJok 1))
  (assert (mugimendurikAg 1))
  
  (bind ?jarraitu 1)
  (while (= ?jarraitu 1)
    (printout t "Aukeratu zer fitxa izan nahi duzun:" crlf)
    (printout t "1: Beltza" crlf)
    (printout t "2: Zuria" crlf)
    (bind ?aukera (read))
    (if (= ?aukera 1) then
      (assert (jokalariTxanda beltza))
      (bind ?jarraitu 0)
    else 
      (if (= ?aukera 2) then
       (assert (jokalariTxanda zuria))
       (bind ?jarraitu 0)
      else
       (printout t "1 edo 2 idatzi!" crlf)
      )
    )
  )
    
)

(defrule erakutsiTablerue
  (declare (salience 20))
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
  ?txanda <- (txanda ?unekoTxanda)
  ?fitxakop <- (fitxakop ?f)
  (jokalariTxanda ?jokTxanda)
  (test (eq ?unekoTxanda ?jokTxanda))
  ?mugimendurik <- (mugimendurikJok ?m)
=>
  (if (= (mugimenduLegalik ?unekoTxanda $?t) 1) then
    (printout t "Zure txanda da" crlf)
    (retract ?mugimendurik)
    (assert (mugimendurikJok 1))
    (bind ?jarraitu 1)
    (while (= ?jarraitu 1)
      (printout t "Sartu errenkada:" crlf)
      (bind ?erren (read))
      (printout t "Sartu zutabea:" crlf)
      (bind ?zut (read))

      (bind ?pos (+ (* (- ?erren 1) ?*N*) ?zut))  



      (if (and (<= ?pos ?*LENGTH*) (> ?pos 0) (> (length$ (mugimenduLegala ?pos ?unekoTxanda $?t)) 0))  then
        (printout t "Mugimendu legala" crlf)
        (assert (fitxakop (+ ?f 1)))
        (retract ?fitxakop)
        (if (eq ?unekoTxanda beltza) then
          (assert (txanda zuria))
          (bind ?fitxa "⚫")
        else
          (assert (txanda beltza))
          (bind ?fitxa "⚪")
        ) 
        (retract ?txanda)
        (assert (tablerue (fitxakAldatu ?pos ?unekoTxanda $?t))) ;fitxakAldatu-ri dei egin fitxak aldatzeko
        (retract ?table)
        (bind ?jarraitu 0)
      else 
        (printout t "Ez da mugimendu legala" crlf)
      )
    )
  else
    (printout t "Ez duzu mugimendu legalik" crlf)
    (retract ?mugimendurik)
    (assert (mugimendurikJok 0))
    (if (eq ?unekoTxanda beltza) then
      (assert (txanda zuria))
    else 
      (assert (txanda beltza))
    )
    (retract ?txanda)
  )
)

(defrule agentearenTxanda
  (declare (salience 5))
  ?table <- (tablerue $?t)
  ?txanda <- (txanda ?unekoTxanda)
  ?fitxakop <- (fitxakop ?f)
  (jokalariTxanda ?jTxanda)
  (test (neq ?unekoTxanda ?jTxanda))
  ?mugimendurik <- (mugimendurikAg ?m)
=>
  (if (= (mugimenduLegalik ?unekoTxanda $?t) 1) then
    (printout t "Agentearen txanda da" crlf)
    (assert (tablerue(fitxakAldatu (posOnena ?unekoTxanda $?t) ?unekoTxanda $?t)))
    (assert (fitxakop (+ ?f 1)))
    (retract ?table)
    (retract ?fitxakop)
    (retract ?mugimendurik)
    (assert (mugimendurikAg 1))
  else
    (printout t "Agenteak ez du mugimendu legalik" crlf)
    (retract ?mugimendurik)
    (assert (mugimendurikAg 0))
  )
  (if (eq ?unekoTxanda zuria) then
    (assert (txanda beltza))
  else
    (assert (txanda zuria))
  )
  (retract ?txanda)
)

(defrule amaitu
  (declare (salience 10))
  (fitxakop ?fitxakop)
  (mugimendurikAg ?mAg)
  (mugimendurikJok ?mJok)
  (test (or (= ?fitxakop ?*LENGTH*) (and (= ?mAg 0) (= ?mJok 0))))
  (tablerue $?t)
  (jokalariTxanda ?jTxanda)
=>
  (printout t "Jokoa amaitu da" crlf)
  (irabazle ?jTxanda $?t)
  (halt)
)




