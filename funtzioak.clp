; FUNTZIOAK

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

;norantzaOna originala ertzak bilatzeko: norantza ona bada, 1 itzuli, norantza matrizearen ertzetatik ateratzen bada, 0
(deffunction ertzikEz (?pos ?berria)

  ;ertza goian edo behean (berria bektoretik kanpo egotea)
  (if (eq (mugenBarruan ?berria) 0) then
    (return 0)
  )

  ;ertza ezkerrean edo eskuinean (aurrekoa mod N = 0 eta berria mod N = 1 edo aurrekoa mod N = 1 eta berria mod N = 0)
  (if (or (and (eq (mod ?pos ?*N*) 0) (eq (mod ?berria ?*N*) 1)) (and (eq (mod ?pos ?*N*) 1) (eq (mod ?berria ?*N*) 0))) then
    (return 0)
  )

  (return 1)

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

  ;ertzatik kanpo ateratzen bada 0 itzuli (ertzikEz deiarekin)
  (if (eq (ertzikEz ?pos ?berria) 0) then
    (return 0)
  )

  ;hurrengo posizioa hutsa bada ez da legala
  (if (eq (nth$ ?berria ?tablerue) "-") then
    (return 0)
  
  else 
  
    ;hurrengo posizioa nire fitxa berdina du
    (if (eq (nth$ ?berria ?tablerue) ?fitxa) then
      (return 0)
    
    else
    
      ;badaezpada aurkaria dela egiaztatu
      (if (eq (nth$ ?berria ?tablerue) ?aurkariFitxa) then
      
        (bind ?jarraitu 1)

        (while (= ?jarraitu 1)
          (bind ?unekoa ?berria)
          (bind ?berria (+ ?berria ?norantza))

          ;ertzatik kanpo ateratzen bada 0 itzuli (ertzikEz deiarekin)
          (if (eq (ertzikEz ?unekoa ?berria) 0) then
            (return 0)
          )

          ;hurrengo posizioa hutsa bada ez da legala
          (if (eq (nth$ ?berria ?tablerue) "-") then
            (return 0)
          )

          ;hurrengo posizioa nire fitxa berdina du
          (if (eq (nth$ ?berria ?tablerue) ?fitxa) then
            (bind ?jarraitu 0)
          )
      
        )
      
      )
      
    )

  )

  (return 1)

)

;mugimendu legala bada listan sartu, azkenean lista itzuli (hutsa edo beteta)
(deffunction mugimenduLegala (?pos ?unekoTxanda $?tableroa)

  (bind ?norantzaOnakLista (create$))

  (bind ?norantzak (create$ (* ?*N* -1) (- 1 ?*N*) 1 (+ ?*N* 1) ?*N* (- ?*N* 1) -1 (- -1 ?*N*)))
  (if (and (= (libreDago ?pos ?tableroa) 1) (= (mugenBarruan ?pos) 1)) then
    (loop-for-count (?i 1 (length$ ?norantzak))
        (bind ?norantza (nth$ ?i ?norantzak))
        (if (= (norantzaOna ?norantza ?pos ?unekoTxanda $?tableroa) 1) then
          (bind ?norantzaOnakLista (create$ ?norantzaOnakLista ?norantza))
        )
    )
  )
  
  (return ?norantzaOnakLista)  
)


;fitxak aldatzeko
(deffunction fitxakAldatu (?pos ?unekoTxanda $?tablerue)

  ;igual hay jarri daiteke funtzio batean zeren asko errepikatzen da
  ; ze euskera da hori lol
  (if (eq ?unekoTxanda zuria) then
    (bind ?fitxa "z")
    (bind ?aurkariFitxa "b")
  else 
    (bind ?fitxa "b")
    (bind ?aurkariFitxa "z")
  )

  (bind ?norantzak (mugimenduLegala ?pos ?unekoTxanda $?tablerue))

  (bind ?tablerue (replace$ $?tablerue ?pos ?pos ?fitxa))

  (loop-for-count (?i 1 (length$ ?norantzak))
    (bind ?norantza (nth$ ?i ?norantzak))
    (bind ?berria (+ ?pos ?norantza))
    (while (not (eq (nth$ ?berria $?tablerue) ?fitxa))
      (bind ?tablerue (replace$ $?tablerue ?berria ?berria ?fitxa))
      (bind ?berria (+ ?berria ?norantza))
    )
  )
  (return ?tablerue)
)


;mugimendu legalik dagoen begiratu
;1 gutxienez bat badago, 0 ez badago mugimendu posiblerik
(deffunction mugimenduLegalik (?unekoTxanda $?tablerue)

  (loop-for-count (?i 1 ?*LENGTH*)
    (if (> (length$ (mugimenduLegala ?i ?unekoTxanda $?tablerue)) 0) then 
      (return 1)
    )
  )
  (return 0) ; ez dago mugimendu posiblerik
)
