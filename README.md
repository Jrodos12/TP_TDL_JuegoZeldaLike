# TP_TDL
Videojuego como proyecto aplicativo de los conceptos y contenidos de la materia TDL

Actual:
  - Discusion de agregados: improvements
      Lo que se les ocurra comenten y/o agreguen en el archivo


Modificaciones hechas:

  - Cambiamos forma de graficar corazones para que utilice el parametro health en vez de utilizar una cte (3 corazones). Asi si damos la posibilidad de aumentar la cantidad de corazones o la vida, grafica en base a eso.
  - Place holder de titulo para ir personalizando de a poco
  - Cambio de los codigos de colores (en la version actual para el color usa de 0 a 1 y no de 0 a 255 como estaba
  - Las puertas se abren solo cndo derrotas a todos los enemigos
  - Los switch dan mensaje de que hay que hacer si no los podes abrir
  - Entes titilan cndo invulnerables
  - Room titila rojo + sonido de corazon cndo queda poca vida
  - Pociones de vida aparecen en lugares random, recuperan toda la vida del jugador y se usan solo 1 vez
  - Pociones de invulnerabilidad aparecen a veces, otorgan invulnerabilidad por 10 segundos, tambien se usan 1 vez
  - Se agrega sistema de armadura, el jugador arranca con cuatro "Escudos", que son mas debiles que los corazones (Cada escudo aguanta un golpe, a diferencia de cada corazon que aguanta 2)
  - Cada punto de armadura ahora se puede obtener a partir de cofres.
  - Se puede obtener armadura de cofres normales (1 punto) y cofres plateados (2 puntos). Estos ultimos requieren llaves para ser abiertos.
 
Haciendose:
  - PlayerSecondAction y chests con llaves o contenedores de corazon
  - Implementar forma interesante de conseguir armadura (mediante llaves o algo parecido)
