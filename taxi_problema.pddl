
(define (problem Pruebas)

(:domain auto-taxis)

(:objects
taxi1 -taxi
taxi2 -taxi
taxi3 -taxi
taxi4 -taxi
taxi5 -taxi
persona1 -persona
persona2 -persona
persona3 -persona
persona4 -persona
persona5 -persona
lugarA -lugar
lugarB -lugar
lugarC -lugar
lugarD -lugar
lugarE -lugar
lugarF -lugar
)

(:init
;Posiciones iniciales de taxis y personas------
(at taxi1 lugarA)
(at taxi2 lugarA)
(at taxi3 lugarC)
(at taxi4 lugarB)
(at taxi5 lugarD)
(at persona1 lugarA)
(at persona2 lugarB)
(at persona3 lugarF)
(at persona4 lugarD)
(at persona5 lugarE)


;Puntos de carga y talleres------------------
(rrapida lugarA)
(rrapida lugarB)
(rrapida lugarC)
(rlenta lugarA)
(rlenta lugarD)
(rlenta lugarF)
(taller lugarA)
(taller lugarC)
(taller lugarE)

;Disponibilidades----------------------------
(disponible taxi1)
(disponible taxi2)
(disponible taxi3)
(disponible taxi4)
(disponible taxi5)
(libre taxi1)
(libre taxi2)
(libre taxi3)
(libre taxi4)
(libre taxi5)
(carga-r-disponible lugarA)
(carga-r-disponible lugarB)
(carga-r-disponible lugarC)
(carga-l-disponible lugarA)
(carga-l-disponible lugarD)
(carga-l-disponible lugarF)
(taller-disponible lugarA)
(taller-disponible lugarC)
(taller-disponible lugarE)


;Contadores de revisar-----------------------
(= (contador-revisar taxi1) 0)
(= (contador-revisar taxi2) 0)
(= (contador-revisar taxi3) 1)
(= (contador-revisar taxi4) 1)
(= (contador-revisar taxi5) 1)

;Distancias----------------------------------
(= (distancia lugarA lugarA) 0)
(= (distancia lugarA lugarB) 8)
(= (distancia lugarA lugarC) 12)
(= (distancia lugarA lugarD) 20)
(= (distancia lugarA lugarE) 60)
(= (distancia lugarA lugarF) 80)

(= (distancia lugarB lugarA) 8)
(= (distancia lugarB lugarB) 0)
(= (distancia lugarB lugarC) 4)
(= (distancia lugarB lugarD) 16)
(= (distancia lugarB lugarE) 24)
(= (distancia lugarB lugarF) 48)

(= (distancia lugarC lugarA) 12)
(= (distancia lugarC lugarB) 4)
(= (distancia lugarC lugarC) 0)
(= (distancia lugarC lugarD) 28)
(= (distancia lugarC lugarE) 56)
(= (distancia lugarC lugarF) 32)

(= (distancia lugarD lugarA) 20)
(= (distancia lugarD lugarB) 16)
(= (distancia lugarD lugarC) 28)
(= (distancia lugarD lugarD) 0)
(= (distancia lugarD lugarE) 32)
(= (distancia lugarD lugarF) 20)

(= (distancia lugarE lugarA) 60)
(= (distancia lugarE lugarB) 24)
(= (distancia lugarE lugarC) 56)
(= (distancia lugarE lugarD) 32)
(= (distancia lugarE lugarE) 0)
(= (distancia lugarE lugarF) 100)

(= (distancia lugarF lugarA) 80)
(= (distancia lugarF lugarB) 48)
(= (distancia lugarF lugarC) 32)
(= (distancia lugarF lugarD) 20)
(= (distancia lugarF lugarE) 100)
(= (distancia lugarF lugarF) 0)



;Baterias----------------------------------
(= (bateria taxi1) 5)
(= (bateria taxi2) 10)
(= (bateria taxi3) 20)
(= (bateria taxi4) 40)
(= (bateria taxi5) 2)


;Carga rapida----------------------------------
(= (nivel-carga-rrapida) 50)
(= (coste-rrapida) 5)
(= (tiempo-rrapida) 4)


;Carga lenta----------------------------------
(= (nivel-carga-rlenta) 100)
(= (coste-rlenta) 8)
(= (tiempo-rlenta) 8)

;Taller----------------------------------------
(= (tiempo-revisar) 2)

;Subir-Bajar-----------------------------------
(= (tiempo-subir) 1)
(= (tiempo-bajar) 1)

;Coste acumulado-------------------------------
(= (coste-recarga-total) 0)

)

(:goal 
(and (at persona1 lugarF)
(at persona2 lugarE)
(at persona3 lugarD)
(at persona4 lugarE)
(at persona5 lugarA)
)
)

(:metric minimize (+ (* 0.8 (total-time))(* 0.2 (coste-recarga-total))))

)