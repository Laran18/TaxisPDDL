
(define (domain auto-taxis)

(:requirements :durative-actions :typing :fluents) 

(:types taxi lugar persona -object) 


;Predicados------------------------------------------------------------------------------------
(:predicates 
(at ?x -(either persona taxi) ?l -lugar) ;Una persona o un taxi estan en un lugar
(in ?p -persona ?t -taxi) ;Una persona está subida a un taxi
(rrapida ?l -lugar) ;Hay un punto de recarga rapida en el lugar
(rlenta ?l -lugar) ;Hau un punto de recarga lenta en el lugar
(taller ?l -lugar) ;Hay un taller en el lugar
(disponible ?t -taxi) ;El taxi no tiene ninguna persona subida
(taller-disponible ?lugar) ;No hay ningun taxi ocupando el taller
(carga-r-disponible ?lugar) ;No hay ningun taxi ocupando el punto de carga rapida
(carga-l-disponible ?lugar) ;No hay ningun taxi en el punto de recarga lenta
(libre ?t -taxi)	;El taxi no está en ningún punto (de carga o taller)
) 



;Funciones------------------------------------------------------------------------------------
(:functions 
(distancia ?l1 -lugar ?l2 -lugar) ;La distancia en km entre dos puntos
(tiempo-rrapida) ;Tiempo que tarda un taxi en recargar rápidamente
(tiempo-rlenta) ;Tiempo que tarda un taxi en recargar lentamente
(tiempo-subir) ;Tiempo que tarda una persona en subir a un taxi
(tiempo-bajar) ;Tiempo que tarda una persona en bajar de un taxi
(tiempo-revisar) ;Tiempo que se tarda en revisar en un taller
(coste-rrapida) ;Coste de una recarga rápida
(coste-rlenta) ;Coste de una recarga lenta
(nivel-carga-rrapida) ;Nivel de batería que se añade al recargar rápidamente
(nivel-carga-rlenta) ;Nivel de bateria que se añade al recargar lentamente
(contador-revisar ?t -taxi) ;Numero de viajes con pasajeros restantes que tiene un taxi hasta tener que pasar por un taller
(bateria ?t -taxi) ;Batería de un taxi
(coste-recarga-total) ;Acumulado de todos los costes
)






;Acción de mover--------------------------------------------------------------------------------


(:durative-action mover
:parameters (?t -taxi ?lorig -lugar ?ldest -lugar) 
:duration (= ?duration (/ (distancia ?lorig ?ldest) 4))
:condition (and (at start (at ?t ?lorig)) ;El taxi tiene que estar en el lugar de origen
(at start (>= (bateria ?t) (distancia ?lorig ?ldest))) ;Debe haber suficiente batería como para cubrir la distancia entre los dos lugares
(at start (libre ?t)) ;El taxi no puede estar en ningun punto (carga o taller) en el momento de empezar a moverse
)
:effect (and (at start (not (at ?t ?lorig))) ;El taxi deja de estar en el lugar de origen
(at start (not (libre ?t))) ;El taxi deja de estar libre, no puede entrar en ningun punto
(at end (at ?t ?ldest)) ;El taxi pasa a estar en el lugar de destino
(at end (decrease (bateria ?t) (distancia ?lorig ?ldest))) ;El nivel de la bateria se decrementa una cantidad igual a la distancia recorrida
(at end (libre ?t)) ;El taxi vuelve a estar libre
))




;Acción de carga rápida-----------------------------------------------------------------------------

(:durative-action carga-rapida
:parameters (?t -taxi ?l -lugar) 
:duration (= ?duration (tiempo-rrapida))
:condition (and (at start (rrapida ?l)) ;Hay un punto de carga rápida en el lugar
(at start  (carga-r-disponible ?l)) ;El punto de carga no tiene ya ningun taxi en él
(over all (at ?t ?l)) ;El taxi está en el lugar
(over all (disponible ?t)) ;El taxi no lleva ninguna persona encima
(at start (libre ?t)) ;El taxi está libre, es decir, no está ya en ningun otro punto (carga o taller)
) 
:effect (and (at start (not (carga-r-disponible ?l))) ;El punto de carga queda ocupado
(at end (carga-r-disponible ?l)) ;El punto de carga vuelve a estar disponible
(at end (increase (bateria ?t) (nivel-carga-rrapida))) ;El nivel de la bateria aumenta
(at end (increase (coste-recarga-total) (coste-rrapida))) ;Se acumula el coste en el coste total
(at start (not (libre ?t))) ;El taxi pasa a estar ocupado
(at end (libre ?t)) ;El taxi vuelve a estar libre
))



;Acción de carga lenta-----------------------------------------------------------------------------------

(:durative-action carga-lenta
:parameters (?t -taxi ?l -lugar) 
:duration (= ?duration (tiempo-rlenta))
:condition (and (at start (rlenta ?l)) ;Hay un punto de carga lenta en el lugar
(at start (carga-l-disponible ?l)) ;No hay ningun taxi ocupando el punto de carga lenta
(at start (at ?t ?l)) ;El taxi esta en el lugar
(over all (disponible ?t)) ;El taxi no lleva a ninguna persona
(at start (libre ?t)) ;El taxi no está en ningun otro punto
) 
:effect (and (at start (not (carga-l-disponible ?l))) ;El punto de carga queda ocupado
(at end (carga-l-disponible ?l)) ;El punto de carga vuelve a estar libre
(at end (increase (bateria ?t) (nivel-carga-rlenta))) ;Aumenta el nivel de la bateria del taxi
(at end (increase (coste-recarga-total) (coste-rlenta))) ;Se suma el coste de recarga lenta al coste total
(at start (not (libre ?t))) ;El taxi queda en estado ocupado
(at end (libre ?t)) ;El taxi vuelve a estar libre
))



;Acción de revisar en el taller------------------------------------------------------------------------------

(:durative-action revisar
:parameters (?t -taxi ?l -lugar) 
:duration (= ?duration (tiempo-revisar))
:condition (and (at start (taller ?l))  ;Hay un taller en el lugar
(at start (taller-disponible ?l)) ;No hay ningun otro taxi en el taller (el taller esta disponible)
(over all (at ?t ?l)) ;El taxi está en el lugar
(over all (disponible ?t)) ;No va a haber ninguna persona que se suba al taxi mientras dure la accion
(at start (< (contador-revisar ?t) 2)) ;El taxi solo entra si tiene menos de 2 viajes por hacer con personas
(at start (libre ?t)) ;El taxi no está en ningún otro punto (de carga o taller) cuando quiere entrar
) 
:effect (and (at start (not (taller-disponible ?l))) ;El taller deja de estar disponible
(at end (taller-disponible ?l)) ;El taller vuelve a estar disponible
(at end (assign (contador-revisar ?t) 2)) ;Reiniciamos el contador a 2
(at start (not (libre ?t))) ;El taxi queda ocupado y no puede entrar en ningun otro punto mientras tanto
(at end (libre ?t)) ;El taxi vuelve a estar libre
))



;Acción de subir------------------------------------------------------------------------------------

(:durative-action subir 
:parameters (?p -persona ?t -taxi ?l -lugar) 
:duration (= ?duration (tiempo-subir))
:condition (and (at start (at ?p ?l)) ;La persona tiene que estar en el lugar
(at start (> (contador-revisar ?t) 0)) ;El contador del taxi tiene que tener viajes restantes
(over all (at ?t ?l)) ;El taxi tiene que estar en el lugar
(at start (disponible ?t)) ;El taxi no puede tener ya una persona encima
) 
:effect (and (at start (not (at ?p ?l))) ;La persona deja de estar en el lugar
(at end (in ?p ?t)) ;La persona pasa a estar dentro del taxi
(at start (not (disponible ?t))) ;El taxi deja de estar disponible para cualquier otra persona
))




;Acción de bajar------------------------------------------------------------------------------------
(:durative-action bajar 
:parameters (?t -taxi ?p -persona ?l -lugar) 
:duration (= ?duration (tiempo-bajar))
:condition (and (at start (in ?p ?t)) ;La persona tiene que estar dentro del taxi
(over all (at ?t ?l)) ;El taxi no se puede ir a ningun otro sitio mientras la persona se baja
) 
:effect (and (at end (not (in ?p ?t))) ;La persona deja de estar dentro del taxi
(at end (at ?p ?l)) ;La persona pasa a estar en el lugar destino
(at end (decrease (contador-revisar ?t) 1)) ;Se decrementa en 1 unidad el contador del taxi 
(at end (disponible ?t)) ;El taxi pasa a estar disponible
))

)