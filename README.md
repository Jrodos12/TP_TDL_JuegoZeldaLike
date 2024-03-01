# TP_TDL
Videojuego como proyecto aplicativo de los conceptos y contenidos de la materia TDL. Se utiliza de base: [Intro to Game Development from Harvard University](https://docs.cs50.net/ocw/games/assignments/5/assignment5.html)

## Contiene dos versiones ejecutables:
- Una con el jefe en segunda sala (CarpetaJefeRoom2.zip) 
- Versión original (JuegoCompleto.zip).

 Estos ejecutables son para windows, para ver en linux se sugiere instalar [Love](https://love2d.org/) y [Lua](https://www.lua.org/) y correr el main. Para ejecturar en Windows se necesita únicamente tener alguno de los dos .zip indicados descargados, extraer la carpeta y clickear "JuegoCompleto.exe"/"CarpetaJefeRoom2".


## Modificaciones hechas:

  - Cambiamos forma de graficar corazones para que utilice el parametro health en vez de utilizar una cte.
  - Personalizacion de pantalla de inicio y de fin.
  - Las puertas se abren solo cuando se derrotan a todos los enemigos.
  - El botón de abrir puerta solo se activa si se mataron a todos los enemigos (y al pisarlo se explica esto al jugador).
  - Los entes titilan cuando estan en estado invulnerable, es decir, cuando no se les puede hacer daño.
  - El juego titila rojo y se agrega sonido de corazon latiendo cuando el jugador cuenta con poca vida.
  - Pociones de vida aparecen en lugares random, recuperan toda la vida del jugador y se usan solo 1 vez.
  - Pociones de invulnerabilidad aparecen a veces, otorgan invulnerabilidad por 10 segundos, tambien se usan 1 vez.
  - Se agrega sistema de armadura, el jugador arranca con cuatro "Escudos", que son mas debiles que los corazones (Cada escudo aguanta un golpe, a diferencia de cada corazon que aguanta 2). Cada punto de armadura ahora se puede obtener a partir de cofres.
  - Se puede obtener armadura de cofres normales (1 punto) y cofres plateados (2 puntos). Estos ultimos requieren llaves para ser abiertos.
  - Se agrega un Jefe que tiene mas vida que los demas enemigos y tiene mas tiempo de invulnerabilidad luego de ser golpeado. Al entrar en su sala ocurre un cambio de musica.  Para cada etapa del jefe se cambia la musica.
  - Decoraciones en el piso y paredes en forma de libros para darle temática biblioteca.
  - Mapa, objetos y enemigos preseteados por cuarto. El mapa cuenta con un recorrido fijo, contrario a la generacion aleatoria del proyecto inicial. Los objetos y enemigos en cada cuarto tambien son fijos.
  - Se agrega pantalla de juego ganado.
  - Enemigos solo tienen spawn en las esquinas del juego en el cuarto del jefe. Se le agrega sonido a su aparicion.

  ### Antes
![antes_z](https://github.com/ppazb/TP_TDL_JuegoZeldaLike/assets/72047847/509477fa-e5ab-45fd-8709-7212ccb2e58c)

### Despues
![z_despues](https://github.com/ppazb/TP_TDL_JuegoZeldaLike/assets/72047847/ecf3d044-4312-4421-b453-6c4bbdffac8e)
![jefe](https://github.com/ppazb/TP_TDL_JuegoZeldaLike/assets/72047847/639eed10-0518-4f19-b37d-d96405f132e7)
![image](https://github.com/ppazb/TP_TDL_JuegoZeldaLike/assets/72047847/a3d60dac-179a-4940-b29d-77086a30bde1)
![image](https://github.com/ppazb/TP_TDL_JuegoZeldaLike/assets/72047847/a51666f7-9c28-4e67-9c4d-1a32797fefdb)

