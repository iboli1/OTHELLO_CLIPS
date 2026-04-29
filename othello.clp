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
  (assert (txanda beltza)) ; fitxa beltzak dituena hasten da
  (assert (tablerue ?tablerue))
  
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
       (bind ?jarraitu 1)
      else
       (printout t "1 edo 2 idatzi!" crlf)
      )
    )
  )
    
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
  ?txanda <- (txanda ?unekoTxanda)
  ?fitxakop <- (fitxakop ?f)
  (jokalariTxanda ?jokTxanda)
  (test (eq ?unekoTxanda ?jokTxanda))
=>
  (bind ?jarraitu 1)
  (printout t "Zure txanda da" crlf)
  (while (= ?jarraitu 1)
    (bind ?pos (read))
    (if (= (mugimenduLegala ?pos ?unekoTxanda $?t) 1)  then
      (printout t "Mugimendu legala" crlf)
      (assert (fitxakop (+ ?f 1)))
      (retract ?fitxakop)
      (if (eq ?unekoTxanda beltza) then
        (assert (txanda zuria))
        (bind ?fitxa "b")
      else
        (assert (txanda beltza))
        (bind ?fitxa "z")
      ) 
      (retract ?txanda)
      (assert (tablerue (replace$ $?t ?pos ?pos ?fitxa)))
      (retract ?table)
      (bind ?jarraitu 0)
    else 
      (printout t "Ez da mugimendu legala" crlf)
    )
  )
)

(defrule agentearenTxanda
  (declare (salience 5))
  ?table <- (tablerue $?t)
  ?txanda <- (txanda ?unekoTxanda)
  ?fitxakop <- (fitxakop ?f)
  (jokalariTxanda ?jTxanda)
  (test (neq ?unekoTxanda ?jTxanda))
=>
  (printout t "Agentearen txanda da" crlf)
)

;mugimendu legala bada 1, ez bada legala 0
(deffunction mugimenduLegala (?pos ?unekoTxanda $?tableroa)
  (bind ?bada 0)

  (bind ?norantzak (create$ (* ?*N* -1) (- 1 ?*N*) 1 (+ ?*N* 1) ?*N* (- ?*N* 1) -1 (- -1 ?*N*)))
  (if (and (= (libreDago ?pos ?tableroa) 1) (= (mugenBarruan ?pos) 1)) then
    (loop-for-count (?i 1 (length$ ?norantzak))
        (bind ?norantza (nth$ ?i ?norantzak))
        (if (= (norantzaOna ?norantza ?pos ?unekoTxanda ?tableroa) 1) then
          (bind ?bada 1)
        )
    )
  )
  
  (return ?bada)  
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
(deffunction libreDago (?pos $?tablerue)
  (if (eq (nth$ ?pos $?tablerue) "-") then
    (return 1)
  else
    (return 0)
  )
)

;norantza ona bada, 1 itzuli, norantza matrizearen ertzetatik ateratzen bada, 0
(deffunction norantzaOna (?norantza ?pos ?unekoTxanda $?tablerue)
  (bind ?berria (+ ?pos ?norantza))
  (if (eq ?unekoTxanda zuria) then
    (bind ?fitxa "z")
    (bind ?aurkariFitxa "b")
  else 
    (bind ?fitxa "b")
    (bind ?aurkariFitxa "z")
  )

  ;ertza goian edo behean (berria bektoretik kanpo egotea)
  (if (eq (mugenBarruan ?berria) 0) then
    (return 0)
  )

  ;ertza ezkerrean edo eskuinean (aurrekoa mod N = 0 eta berria mod N = 1 edo aurrekoa mod N = 1 eta berria mod N = 0)
  (if (or (and (eq (mod ?pos ?*N*) 0) (eq (mod ?berria ?*N*) 1)) (and (eq (mod ?pos ?*N*) 1) (eq (mod ?berria ?*N*) 0))) then
    (return 0)
  )

  ;hurrengo posizioa hutsa bada ez da legala
  (if (eq (nth$ ?berria ?tablerue) "-") then
    (return 0)
  
  else 
  
    ;hurrengo posizioa fitxa berdina du
    (if (eq (nth$ ?berria ?tablerue) ?fitxa) then
      (return 0)
    else 
      ;fitxa aurkariarena da
      (if (eq (nth$ ?berria ?tablerue) ?aurkariFitxa) then
      
        (bind ?jarraitu 1)
        (while (= ?jarraitu 1)
          (bind ?berria (+ ?berria ?norantza))
          (if (eq (mugenBarruan ?berria) 0) then
            (return 0)
          )
          (if (eq (nth$ ?berria ?tablerue) "-") then
            (return 0)
          )
          (if (or (and (eq (mod ?pos ?*N*) 0) (eq (mod ?berria ?*N*) 1)) (and (eq (mod ?pos ?*N*) 1) (eq (mod ?berria ?*N*) 0))) then
              (return 0)
          )
          (if (eq (nth$ ?berria ?tablerue) ?fitxa) then
            (bind ?jarraitu 0)
          )
        
        )
      
      )
      
    ) 

  )
  (return 1)
)