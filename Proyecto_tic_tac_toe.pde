/**
 **
 ** 18/03/2017
 ** @author Ariel Arturo Ríos Sierra
 ** Contacto: arturi.marking@gmail.com
 *
 *************Codigo de Tic Tac Toe**********************
 * Programa para crear un tic tac toe con processing 
 *
 * Aqui se encuentra toda la logica del programa
 ******************************************************** 
 *
 * @version 1.1
 * Se agrego seleccion de fondo
 *
 * @see <a href = "https://github.com/Deltarios/Proyecto_tic_tac_toe" /> GitHub – Repositori del Tic Tac Toe </a>
 */

/**
 * ¡NOTA!
 * Es necesario descargar la libreria processing.sound.*; para este proyecto, buscar en
 * Herramientas -> Añadir Herramienta -> Libraries -> En filter buscar Sound Author: The Processing Foundation
 */

// Este importe trae todos los codigos necesarios para hacer uso de sonidos en el
// programa, sin esta importancion no podriamos hacer los sonidos de click, victoria y empate
import processing.sound.*;

// Estas CONSTANTES son para evitar alteraciones al mapa, por si decirlos, son puntos de referencias, donde todas coordenasas de imagenes y letras, estan en referencias a estas
// estas nos sirven para evitar completos cambios en todo el codigo, por que si quiero cambiar algo, solo es necesario cambiar los valores de estas unicas variables.
private static final int X_FIJA = 250;
private static final int Y_FIJA = 220;
private static final int X2_FIJA = X_FIJA;
private static final int Y2_FIJA = Y_FIJA + 260;

// Guardamos la cadena texto que se pondra en pantalla, para el boton de reinicio.
private final String textoReinicio = "Reiniciar Partida";
// Guardamos la cadena que se pondra en la pantalla cuando el usario este jugando.
private String textoDeJuego = "Turno Jugador: ";
// Guardamos la cadena que se pondra en la pantalla cuando un usuario gane.
private String textoVictoria = "Ha ganado el jugador: ";

// Reservamos un espacio de memoria para las fuentes de las letras, que se mostraran en pantalla.
private PFont fuente;
// Reservamos un espacio de memoria para las fuentes de los numeros del puntaje de los juegadores
private PFont fuentePuntaje;

// Creamos la variable para saber el estado actual de los jugadores, siendo true: Es su turno y siendo false: No es su turno
private boolean primerJugador = true;
private boolean segundoJugador = false;

// Creamos la variable para saber el estado si un jugador a ganado la partida inicialmente sera false, dando entender que aun nadie gana la partida al inicio.
private boolean victoria = false;

// Creamos las variables donde se guardaran los respectivos puntajes de cada uno de los jugadores, iniciando en 0 el valor.
private int puntajePrimerJugador = 0;
private int puntajeSegundoJugador = 0;

// Creamos la variable para saber el estado del juego, siendo true: Se esta jugando y false: Se termino la partida
private boolean jugando = true;

// Creamos la variable para saber que jugador esta acutalmente, siendo 1: el juedor 1 y siendo 2: el jugador 2
private int jugadorActual = 1;

// Creamos la variable para saber numero del turno actual, cuando pase un turno esta variable aumentara +1
private int numeroTurno = 0;

// Esta variable es un arreglo de datos, donde se van ha almacenar varios datos a la vez, en una sola referencia. 
// Esta es una matriz, de 3x9 o sea que va almacenar 3 datos en 9 posiciones diferentes o sea que: en una posicion habra 3 valores
// Ejemplo {[0, 0, 0]} asi se veria el index [0][0] de este arreglo.
// Uso: El uso de esta variable es para guardar los diferentes valores que son: Numero del cuadro, Si esta ocupado, Quien esta en ese cuadro.
// cada una de estos datos lo vamos a ir obteniendo durante el proceso del codigo, asi posteriormente llenaremos la matriz hasta haber acompletado
// las 9 lugares o casillas. Los valores seran: [0 al 8 -> Son numeros de casillas empezando desde el 0], [0 o 1] sera 0 si no esta ocupada la casilla, 1 si esta ocupada
// y por ultimo el tercer dato sera: [1 o 2] siendo esta 1 el primero jugador y 2 el segundo juegador. 
private int[][] casillas = new int[3][9]; 

// Reservamos un espacio de memoria donde se guardaran nuestras imagenes de Cruz o Circulo
private PImage simboloCruz;
private PImage simboloCirculo;

// Reservaremos un espacio de memoria para la variable que guarda la imagen del jugador en turno, esta serviara para cambiar la imagen durante el juego
private PImage imagenTurno;

// Reservaremos un espacio de memoria para la variable de la imagen en el tablero, esta sirve para llenar el tablero con imagenes cuando se hace clic en la casilla
private PImage imagenJugadorActual;

private PImage imagenMenu;
private boolean cuadroVisible = false;

private color fondoJuego  = #00BDAD;

private color colorTablero = #00A193;

// Reservamos un espacio para el color fondo de la pantalla
private color fondo;
// Reservamos un espacio para el color fondo del boton de reinicio
private color fondoReinicio;
// Reservamos un espacio para el color fondo de los marcadores donde iran cambiando segun el turno y si el mouse se encuentra en los marcodores de puntuacion
private color fondoBotonesCruz;
private color fondoBotonesCirculo;

// Estas  variables de coordenadas fijas nos serviran como una referencia para ir cambiando la posicion sin tantas complicaciones
private int coordenadaVariableImagen = 340;
private int coordenadaVariableTexto = 220;

// En cada uno de estas variables seran necesaria para reservar un espacio de memoria para el sonido, durante las partidas.
private SoundFile clickBoton;
private SoundFile sonidoEmpate;
private SoundFile sonidoVictoria;

/*
 * En este metodo ocurren todos las configuraciones iniciales, aqui le daremos su primer
 * valor a las variables, que se declaron arriba, este metodo es el primero en ser
 * ejecutado, siendo vital, por que aqui se configura por primera vez el juego.
 */
void setup() {   

  // Definimos la pantalla y su tamaño.
  size(600, 600);

  // Definimos el valor de la imagen del jugador uno, y cargamos la imagen.
  simboloCruz = loadImage("x.png");
  // Definimos el valor de la imagen del jugador dos, y cargamos la imagen.
  simboloCirculo = loadImage("o.png");

  // Definimos el valor de la fuente en los textos genericos.
  fuente = loadFont("Beirut-20.vlw");
  // Definimos el valor de la fuente del texto del puntaje en los marcadores.
  fuentePuntaje = loadFont("ArialRounded.vlw");
  // Definimos el color del fondo en el juego
  fondo = #F8F8F8;
  // Definimos el color de fondo del boton de reinicio
  fondoReinicio = #F8F8F8;
  // Definimos el color de fondo del boton del jugador cruz o jugador uno
  fondoBotonesCruz = #FFFFFF;
  // Definimos el color de fondo del boton del jugador ciruclo o jugaodr dos
  fondoBotonesCirculo = fondoBotonesCruz;

  // Definimos el valor de los sonidos que usaremos en el proyecto, en este caso reciben dos argumentos
  // la clase donde se va usar y el nombre del archivo que se usara.
  clickBoton = new SoundFile(this, "sonidoClick.mp3");
  sonidoEmpate = new SoundFile(this, "sonidoEmpate.mp3");
  sonidoVictoria = new SoundFile(this, "sonidoVictoria.mp3");
}

/**
 * Esta funcion es la encarcaga de dibujar todo en pantalla, con ayuda de esta funcion
 * todos los elementos se van ha actualizar para crear y hacer el juego. * Recordar que es un ciclo que se repite infinitas veces*
 */
void draw() {

  if (numeroTurno == 0) {
    // Defnimos el color del fondo al juego. 
    background(fondoJuego);
  }

  // Metodo encargado de hacer el tablero del juego con ella se dibujara, el Tic Tac Toe
  // Acepta los valores constantes que definimos en la cabecera del programa.
  tablero(X_FIJA, Y_FIJA, X2_FIJA, Y2_FIJA);

  // Definimos el nuevo color del fondo del boton de reinicio
  fondoReinicio = fondo;

  // Estas lineas de codigo dibujan lo que sera el cuadro blanco superior del juego donde posteriormente se dibujaran los marcadores 
  noStroke();
  fill(fondo);
  rect(0, 0, 600, 150);
  noFill();
  // Finaliza el dibujado del cuadro blanco superior 

  // Estas lineas de codigo se encargan de dibujar lo que sera el rectangulo del marcador del jugador 1
  fill(fondoBotonesCruz);
  rect(150, 50, 150, 40, 7);
  noFill();

  // Este metdo es el encargado de poner la imagen de cruz en pantalla, lugar especifico en el marcador del juego 1
  image(simboloCruz, 155, 60, 20, 20);

  // Definimos y creamos lo que sera el texto del marcador, aqui se actualizar el texto para que sea redibujado en la pantalla del juego
  fill(0);
  textFont(fuentePuntaje);
  textSize(22);
  text(String.valueOf(puntajePrimerJugador), 275, 77);
  // Finaliza el dibujado del marcador del jugador 1

  // Estas lineas de codigo se encargan de dibujar lo que sera el rectangulo del marcador del jugador 2
  fill(fondoBotonesCirculo);
  rect(310, 50, 150, 40, 7);
  noFill();

  // Este metdo es el encargado de poner la imagen de cruz en pantalla, lugar especifico en el marcador del juego 2
  image(simboloCirculo, 315, 60, 20, 20);

  // Definimos y creamos lo que sera el texto del marcador, aqui se actualizar el texto para que sea redibujado en la pantalla del juego
  fill(0);
  textFont(fuentePuntaje);
  textSize(22);
  text(String.valueOf(puntajeSegundoJugador), 435, 77);
  // Finaliza el dibujado del marcador del jugador 2

  // Estas lineas de codigo son las encargadas de dibujar el texto y las imagenes lo que sera el turno del juegador, si gana uno mostrara quien gano y si hay un empate igual.
  fill(0);
  textFont(fuente);
  textSize(15);
  // Aqui recibimos el texto del juego actual, ya que este puede variar segun el estado actual del juego
  // Ademas la coordenada al reducir o aumentar el texto cambia, y esto es para evitar ese error
  text(textoDeJuego, coordenadaVariableTexto, 125);
  // Finalizamos el dibujado del texto del estado del juego

  // Primero comprobamos si hay alguna imagen en nuestra variable, si hay una imagen sera: true, de lo contrario sera: false.
  // Esto para evitar error de objeto nulo.
  if (imagenJugadorActual != null) {
    // Segundo comprobamos si comprobamos que no hay ningun ganador para intercambiar la imagen en cada turno, si hay una victoria sera: true, si aun nadie gana sera false
    if (victoria == false) {
      // Le asignamos la imagen al turno para se visualize en pantalla debajo del texto del marcador
      // Para saber que imagen es de cada jugador nos auxiliamos del metodo de imagenJugadorActual 
      imagenTurno = imagenJugadorActual(primerJugador, segundoJugador);
    }

    // Una ultima comprobacion nos servira para no poner la imagen cuando sea el turno 9( hay un empate), pero igual si no hay una victoria en el turno 9
    // Dado que el usuario podria ganar el ultimo movimiento que gana. Esto previene esa falla
    if (numeroTurno != 9 || victoria == true) {
      // Una vez que vimos que hay victoria y no hay empate procedemos ha poner la imagen 
      image(imagenTurno, coordenadaVariableImagen, 110, 20, 20);
    }
  }
  // Finalizamos el dibujado del texto y la imagen del estado del juego

  // Estas lineas de codigo dibujan lo que sera el cuadro blanco inferior del juego donde esta el boton de reinicio
  fill(fondoReinicio);
  rect(0, 550, 600, 50);
  noFill();
  // Finaliza el dibujado del cuadro blanco inferior

  // Estas lineas de codigo dibujan lo que es el texto de reinicio del boton del texto
  fill(fondoJuego);
  textFont(fuente);
  text(textoReinicio, 215, 580);
  strokeWeight(10);
  // Finaliza dibujado del texto del boton de reinicio.

  // Este metodo nos servira que el usuario pueda elegir con que imagen quiere empezar.
  eleccionJugador();

  // El menu despegable solo se mostrara cuando el turno sea 0, cuando sea diferente desaparecera 
  if (numeroTurno == 0) {
    // metodo del menu despegable
    menuDespegable();
  }
}

/**
 * Esta es el metodo encargado de definir todo lo que es el tablero
 * con esta creamos cada una de las lineas que son utilizados para 
 * el tablero, para que posteriomente se dibuje.
 * @param x, y, x2, y2
 */
void tablero(final int x, final int y, final int x2, final int y2) {
  // Definimos que queremos a las lineas cuadradas
  strokeCap(SQUARE);
  // Definimos el color de las lineas
  stroke(colorTablero);

  // Creamos la primera linea y la segunda linea verticales del tablero, siendo la primera, nuestra referencia
  line(x, y, x2, y2); // 1 Linea, la x, y, x2 y y2 son sus coordenadas
  line(x + 90, y, x2 + 90, y2); // 2 Linea
  // Finalizamos con dibujar la primera y segunda linea vertical

  // Creamos la primera linea y la segunda linea horizontales del tablero, estan usan de referencia a la primera linea
  line(x - 85, y + 85, x2 + 175, y2 - 175); // 3 Linea
  line(x - 85, y + 175, x2 + 175, y2 - 85); // 4 Linea
  // Finalizamos con dibujar la primera y segunda linea horizontal

  // Dejamos de pintar los bordes de las lineas
  noStroke();
}

/**
 * Se encarga de asignarle a cada jugador su respectiva imagen, hace una comprobacion
 * del estado de cada uno de los jugadores, para asi detectar de quien es el turno, pero sera el inverso, al turno
 * @param primerJugador, segundoJugador
 * @return imagenJugadorActual: devuelve la imagen actual del jugador
 */
public PImage imagenJugadorActual(final boolean primerJugador, final boolean segundoJugador) {
  // Creamos una variable local donde se guardara, para loa imagen que enviaremos despues
  PImage imagenTurno;
  // Comprobamos si es el turno del segundo jugador
  if (primerJugador == false && segundoJugador == true) {
    // Si es el turno del segundo le asignamos la imagen de circulo
    imagenTurno = loadImage("o.png");
    // Si no se cumple esta condicion entonces es el turno del primer jugador
  } else {
    // pondremos la imagen del primer jugador que es la x
    imagenTurno = loadImage("x.png");
  }
  // Devolvemos la imagen despues que es asignada en la condicional
  return imagenTurno;
}

/**
 * Este metodo se encarga de seleccionar y configurar el juego cuando el usuario ya eligio con que simbolo quiere jugar
 * entonces esto se encargara de hacer un boton seleccionable con efecto de sombreado, y configuracion de variables
 * de cabezera, para que el juego inicie con el simbolo de preferencia del jugador
 */
private void eleccionJugador() {
  // Este if limita un area de efecto del mouse, entonces cuendo estamos en esta area y solo en esta area, ocurrira lo que esta dentro de este if, esta area corresponde al rectangulo de la cruz
  if (mouseX >= X_FIJA - 100  && mouseX <= X_FIJA + 50 && mouseY >= Y_FIJA - 170 && mouseY < Y2_FIJA - 390) {
    // Si el turno es igual a 0 entonces el usuario puede elegir quien va empezar, una vez que el turno sea diferente a 0 no podremos hacer nada. 
    if (numeroTurno == 0) {
      // Sombreamos al boton para tener un mejor efecto visual, que es realmente solo cambiar el fondo del rectangulo a uno más oscuro.
      fondoBotonesCruz = #DCDCDC;
      // Si presionamos el area en donde estamos y el turno es igual a 0 entonces, proceremos a configurar el juego a la eleccion del usuario
      if (mousePressed) {
        //Asignamos la variable del jugador Actual a 1
        jugadorActual = 1;
        // Asignamos la imagen del jugador de cruz
        imagenJugadorActual = loadImage("x.png");
        // cambiamos los estados de cada uno de los jugadores
        primerJugador = true;
        segundoJugador = false;
      }
    }
    // De lo contrario si estamos en la otra area del circulo este if limita un area de efecto del mouse, entonces cuendo estamos en esta area y solo en esta area, 
    //ocurrira lo que esta dentro de este else if, esta area corresponde al rectangulo del circulo
  } else if (mouseX >= X_FIJA + 60  && mouseX <= X_FIJA + 210 && mouseY >= Y_FIJA - 170 && mouseY < Y2_FIJA - 390) {
    // Si el turno es igual a 0 entonces el usuario puede elegir quien va empezar, una vez que el turno sea diferente a 0 no podremos hacer nada. 
    if (numeroTurno == 0) {
      // Sombreamos al boton para tener un mejor efecto visual, que es realmente solo cambiar el fondo del rectangulo a uno más oscuro.
      fondoBotonesCirculo = #DCDCDC;
      if (mousePressed) {
        //Asignamos la variable del jugador Actual a 2
        jugadorActual = 2;
        // Asignamos la imagen del jugador del circulo
        imagenJugadorActual = loadImage("o.png");
        // cambiamos los estados de cada uno de los jugadores
        primerJugador = false;
        segundoJugador = true;
      }
    }
  } else {
    // Para que los cambios de los fondos no sean permanentes y solo sean cuando estemos en esa area de efecto, entonces actualizamos la variable apenas nos salimos de esa area
    // regresando al color blanco de fondo de cada rectangulo
    fondoBotonesCruz = #FFFFFF;
    fondoBotonesCirculo = #FFFFFF;
  }
}

/**
 * Metodo encargado del dibujado del menu despegable en pantalla
 */
public void menuDespegable() {
  // Hacemos el cuadro seleccionable
  fill(#FFFFFF);
  rect(20, 0, 120, 40, 0, 0, 7, 7);
  noFill();

  // Hacemos el texto del cuadro 
  fill(0);
  textFont(fuentePuntaje);
  textSize(20);
  text("Fondo", 30, 30);
  noFill();

  // Antes de poner la imagenes revisamos si esta no esta vacia
  if (imagenMenu != null) {
    // Establecemos la imagen en pantalla si no esta vacio
    image(imagenMenu, 110, 10, 20, 20);
  }

  // Desplega el menu si nuestro mouse se encuentra en esta area
  if (mouseX >= 20 && mouseX <= 140 && mouseY >= 0 && mouseY <= 40) {
    // Declaramos al cuadro como visible
    cuadroVisible = true;
  } else {
    // Si no estamos en esa area, dibujamos la imagen del la fecha del menu 
    imagenMenu = loadImage("flecha_menu.png");
  }

  // Si el cuadro es visible, desplegamos los demas rectangulos que conforman el menu
  if (cuadroVisible) {
    // Vaciamos la imagen, para que no se dibuje
    imagenMenu = null;

    // Dibujamos los diferentes rectangulos, para hace una paleta de seleccion
    // Cuadro 1
    fill(#00BDAD);
    rect(20, 40, 120, 30);
    noFill();

    // Cuadro 2
    fill(#40EDFF);
    rect(20, 70, 120, 30);
    noFill();

    // Cuadro 3
    fill(#FCEEA5);
    rect(20, 100, 120, 30);
    noFill();
    // Terminamos de dibujar los rectangulos

    // Area de eventos del cuadrado 1, aqui cambiamos los colores del juego
    if (mouseX >= 20 && mouseX <= 140 && mouseY >= 40 && mouseY <= 70) {
      fondoJuego  = #00BDAD;
      colorTablero = #00A193;
    }

    // Area de eventos del cuadrado 2, aqui cambiamos los colores del juego
    if (mouseX >= 20 && mouseX <= 140 && mouseY >= 70 && mouseY <= 100) {
      fondoJuego = #40EDFF;
      colorTablero = #00C5FF;
    }

    // Area de eventos del cuadrado 3, aqui cambiamos los colores del juego
    if (mouseX >= 20 && mouseX <= 140 && mouseY >= 100 && mouseY <= 130) {
      fondoJuego = #FCEEA5;
      colorTablero = #D8C355;
    }
  }
}

/**
 * Aqui ocurren todos los eventos del mouse cuando este es presionado, aqui estan parte de la ensencia del juego
 * dado que solo se ejecuta este codigo, cuando el mouse es presionado
 */
void mousePressed() {
  // Reproducimos los sonidos del click cuando presionamos el mouse
  clickBoton.play();

  cuadroVisible = false;

  // Boton de reinicio
  // Creamos el area de efecto de mouse, donde solo se ejecutara este codigo, cuando se presione en esta area en especifico, esta es el area del boton de reinicio
  if (mouseX > 0 && mouseY >= 550) {
    // Cambia el fondo del boton cuando presionamos en esta area
    fondoReinicio = #DCDCDC;
    // Se reinicia el tablero del juego, para una siguiente ronda
    accionReinicio();
  }

  /**
   * Si estamos jugando, o sea hay una partida vigente esto ocurre, cuando aun no hay ganador, o los numeros de turnos son menores de 9
   * entonces estamos jugando, ejecutaremos y activaremos todas la funcionalidades del juego, por que despues de 9 turnos o hay un ganador
   * las funciones son bloqueadas y solo reinciando el tablero, podremos volver a jugar
   */
  if (jugando) {
    // Comprobamos si el turno es menor de 9, entonces ejecutaremos el codigo dentro del if, esto para posteriormente determinar si hay un empate
    if (numeroTurno < 9) {
      // Comprobamos que aun no hay una victoria, la victoria puede ser en cualquier turno, y por eso esta dentro del anterior if
      if (victoria == false) {
        // Activamos las funciones del tablero, si aun no hay un ganador
        funcionBotones();
        // Despues verificamos una vez más si hay un ganador, si los hay, ejecutaremos el if
        if (victoria == true) {
          // activaremos los efectos de la victoria, dando como argumentos, al jugador ganador, y si este a ganado
          efectosVictoria(jugadorActual, victoria);
          // sumaremos a su marcador +1 despues de los efectos de victoria
          sumarMarcador(jugadorActual);
          // de lo contrario si llegamos a el turno 9 entonces y no hay un ganador entonces hay un empate
        } else if (numeroTurno == 9) {
          // Cambiamos las coordenadas del texto variable, para que quede centrado, aqui ya no se coloca una imagen, debido a que no hay un ganador
          coordenadaVariableTexto += 50;
          // Se reproduce el sonido del empate
          sonidoEmpate.play();
          // Se establece un nuevo texto en el juego, donde nos muestra el empate de los jugadores
          textoDeJuego = "¡Empate!";
        }
      }
    }
  }
}

/**
 * Encargado de la creacion y el funcionamiento de cada uno de los botones en el tablero, esta es posible limitando un area de efecto, donde 
 * encada area tendremos diferentes acciones, haciendo posible la creacion del tablero interactivo del Tic Tac Toe
 */
private void funcionBotones() {
  //Cuadro 1
  // Hacemos un limite del area, tomando a la equis fija como referencia, para posibles cambios de la posicion del tabler, y esto no sea vean afectados
  // todo lo que ocurra en este if sera solo en este if *La idea es la misma en cada cuadro*
  if (mouseX > X_FIJA - 80 && mouseX <= X_FIJA - 5 && mouseY >= Y_FIJA && mouseY < Y2_FIJA - 180) {
    // Verificamos si la casilla en donde queremos presionar esta ocupada o no haciendo un llamado a nuestro metodo, casillaOcupada(i) siendo i 
    // el numero de la casilla, si no esta ocupada, ejecutamos el codigo
    if (!casillaOcupada(1)) {
      // verificamos el estado del jugador, para tener la imagen del jugador en ese momento
      estadoJugadorActual(primerJugador, segundoJugador);
      // colocamos la imagen del jugador actual, en las coordenadas del cuadro
      image(imagenJugadorActual, X_FIJA - 75, Y_FIJA + 10, 60, 60);
      // rellenamos nuestra matriz, dando los valores que fuimos recibiendo. en este caso 1 es la casilla, el otro uno es si esta ocupado osea 1, y la ultima el jugador
      asignarCasilla(1, 1, jugadorActual);
      // comprobamos, si el jugador ha gando en ese movimiento 
      victoria = comprobarVictoria(jugadorActual);
    }
  }

  // Cuadro 2
  if (mouseX >= X_FIJA + 10  && mouseX <= X_FIJA + 85 && mouseY >= Y_FIJA && mouseY < Y2_FIJA - 180) {
    if (!casillaOcupada(2)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, X_FIJA + 15, Y_FIJA + 10, 60, 60);
      asignarCasilla(2, 1, jugadorActual);
      victoria = comprobarVictoria(jugadorActual);
    }
  }

  // Cuadro 3
  if (mouseX >= X_FIJA + 90  && mouseX <= X_FIJA + 175 && mouseY >= Y_FIJA && mouseY < Y2_FIJA - 180) {
    if (!casillaOcupada(3)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, X_FIJA + 105, Y_FIJA + 10, 60, 60);
      asignarCasilla(3, 1, jugadorActual);
      victoria = comprobarVictoria(jugadorActual);
    }
  }

  // Cuadro 4
  if (mouseX >= X_FIJA - 80  && mouseX <= X_FIJA - 5 && mouseY >= Y_FIJA + 90 && mouseY < Y2_FIJA - 90) {
    if (!casillaOcupada(4)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, X_FIJA - 75, Y_FIJA + 100, 60, 60);
      asignarCasilla(4, 1, jugadorActual);
      victoria = comprobarVictoria(jugadorActual);
    }
  }

  // Cuadro 5
  if (mouseX >= X_FIJA + 5  && mouseX <= X_FIJA + 85 && mouseY >= Y_FIJA + 90 && mouseY < Y2_FIJA - 85) {
    if (!casillaOcupada(5)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, X_FIJA + 15, Y_FIJA + 100, 60, 60);
      asignarCasilla(5, 1, jugadorActual);
      victoria = comprobarVictoria(jugadorActual);
    }
  }

  // Cuadro 6
  if (mouseX >= X_FIJA + 90  && mouseX <= X_FIJA + 175 && mouseY >= Y_FIJA + 90 && mouseY < Y2_FIJA - 85) {
    if (!casillaOcupada(6)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, X_FIJA + 105, Y_FIJA + 100, 60, 60);
      asignarCasilla(6, 1, jugadorActual);
      victoria = comprobarVictoria(jugadorActual);
    }
  }

  // Cuadro 7
  if (mouseX >= X_FIJA - 80  && mouseX <= X_FIJA + 5 && mouseY >= Y_FIJA + 180 && mouseY < Y2_FIJA) {
    if (!casillaOcupada(7)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, X_FIJA - 75, Y_FIJA + 190, 60, 60);
      asignarCasilla(7, 1, jugadorActual);
      victoria = comprobarVictoria(jugadorActual);
    }
  }

  // Cuadro 8
  if (mouseX >= X_FIJA + 5  && mouseX <= X_FIJA + 85 && mouseY >= Y_FIJA + 180 && mouseY < Y2_FIJA) {
    if (!casillaOcupada(8)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, X_FIJA + 15, Y_FIJA + 190, 60, 60);
      asignarCasilla(8, 1, jugadorActual);
      victoria = comprobarVictoria(jugadorActual);
    }
  }

  // Cuadro 9
  if (mouseX >= X_FIJA + 90  && mouseX <= X_FIJA + 175 && mouseY >= Y_FIJA + 180 && mouseY < Y2_FIJA) {
    if (!casillaOcupada(9)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, X_FIJA + 105, Y_FIJA + 190, 60, 60);
      asignarCasilla(9, 1, jugadorActual);
      victoria = comprobarVictoria(jugadorActual);
    }
  }
}

/**
 * Este metodo seria el encargado de verificar si la casilla esta siendo ocupada o no, recordando que el index de casillas[1][i] 1 es donde vamos los datos de ocupado o desocupado
 * i es el numero del cuadro, podemos verificar si ese cuadro esta ocupado o no, partiendo como referencia un cuadro que le daremos para revisar siendo 1 ocupado y 0 desocupado
 * @param int cuadro
 * cuadro que queremos revisar si se encuentra ocupado o no.
 * @return boolean true or false dependiendo de la comprobacion interna del metodo.
 */
public boolean casillaOcupada(final int cuadro) {
  // Aqui verificamos si la casilla tiene guardado un 1, si lo tiene entonces devolvera true, significando que esa casilla esta ocupada
  if (casillas[1][cuadro - 1] == 1) {
    // devuelve true si el valor es 1, entonces esta ocupado
    return true;
  }
  // Si obtenemos otro valor, entonces esta desocupada, entonces nuestro metodo devuelve false
  return false;
}

/**
 * Se encarga de ver el estado del jugador y hacer que los turnos cambien, jugada tras jugada, entonce este sirve, los valores de los jugadores
 * y ve quien esta disponible y quien no, despues le asigna sus determinados valores a cada uno de ellos, cuando termina, aumenta el turno en 1
 * @param boolean primerJugador, boolean segundoJugador
 * estos son los estados de cada uno de los juegdores
 */
private void estadoJugadorActual(boolean primerJugador, boolean segundoJugador) {
  // Si el jugador 1 es verdadero, pero el jugador 2 es falso, entonces es turno del jugador 1, entonces ejecutamos el codigo dentro del if
  if (primerJugador == true && segundoJugador == false) {
    // Le asignamos la imagen que usara en el tablero
    imagenJugadorActual = loadImage("x.png");
    // cambiamos los estados para el siguiente turno del jugador uno, ahora este sera false
    primerJugador = false;
    // cambiamos los estados para el siguiente turno del jugador uno, ahora este sera true
    segundoJugador = true;
    // El jugador en turno sera el 1, para rellenar a la matriz sera usado
    jugadorActual = 1;
    // aumentamos el turno +1 al finalizar
    numeroTurno++;
    // De lo contrario debido a que solo tenemos dos posilidades debido a que solo hay dos jugadores entonces si es 1 entonces 2 y si es 2 es 1, 
    // entonces si no es el turno del primero sera del segundo
  } else {
    // ponemos la imagen del segundo jugador
    imagenJugadorActual = loadImage("o.png");
    // cambiamos los estados para el siguiente turno del jugador uno, ahora este sera true
    primerJugador = true;
    // cambiamos los estados para el siguiente turno del jugador uno, ahora este sera false
    segundoJugador = false;
    // El jugador en turno sera el 2, para rellenar a la matriz sera usado
    jugadorActual = 2;
    // aumentamos el turno +1 al finalizar
    numeroTurno++;
  }

  // Despues de las comprobaciones, lo ultimos que haremos es actualizar nuestras variables globales, dandole los valores obtenidos de nuestras variables locas, 
  // para que la transicion de turnos sea posible
  this.primerJugador = primerJugador;
  this.segundoJugador = segundoJugador;
}

/**
 * Este metodo, es el encargado de rellenar a las casillas del tablero,
 * este mismo recibe los valores, y los asigna a sus respectivos index,
 * de esta manera sabremos el estado de cada uno de los 9 cuadros del juego
 * @param int cuadro, int ocupado, int jugadorAcual 
 * estos son los 3 respectivos valores que pueden tener los cuadros 
 */
public void asignarCasilla(final int cuadro, final int ocupado, final int jugadorActual) {
  // Le asignamos el numero de cuadro [0 a 8], pero lo que recibimos le tenemos que restar 1 para no salir del index: por ejemplo si recibmos 1 le restamos 1 seria realmente
  // la posicion 0 del arreglo por ejemplo estamos en cuadro 3  y el jugador 2 pone en la casilla, esa matriz quedaria aqui llenariamos que cuandro es: {[3,0,0]}   
  casillas[0][cuadro - 1] = cuadro;
  // Le asignamos el estado de ocupado o desocupado, siendo 0 desocupado y 1 ocupado, los unicos valores posibles que puede tomar siguien el ejemplo aqui si lo marcariamos como ocupado: {[3,1,0]} 
  casillas[1][cuadro - 1] = ocupado;
  // Le asignamos que jugador esta en esa casilla, es una manera de saber quien esta en la casilla, marcando con 1 si es el jugador 1 y un 2 si es el jugador 2
  // siguien con el mismo ejemplo aqui llenariamos que jugador fue quien lo lleno entonces quedaria finalmente: {[3,1,2]}
  casillas[2][cuadro - 1] = jugadorActual;
}

/**
 * Teniendo en cuenta nuestra matriz 9x3 un ejemplo para ilustrar es: {[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]}
 * Este metodo hace la comprobacion de la victoria, tomando como punto de referencia al jugador actual, revisa si este ha ganado al finalizar su turno
 * verificamos de forma vertical, horizotal, y diagonal cada uno de las posiciones, y si encuentra que el jugador al momento de terminar su turno
 * si hay una combiacion en la matriz en index(posicion) [2][i] siendo 2 las posiciones de los jugadores y i el numero del cuadro que se revisa
 * de [{1, 1, 1}] (Siendo el caso del jugador 1), si hay una combinacion asi al finalizar su turno significa que ha ganado, y devolvemos
 * true, de lo contrario si el jugador aun no completa una linea de tres, devolvera false, dando entender que aun no ha ganado el jugador en ese turno
 * @param int jugador
 * jugador al que quieres comprobar si gano o no.
 * @return boolean true or false 
 * Devuelve true si gano y false si aun no gana
 */
private boolean comprobarVictoria(final int jugador) {
  // Variable local de tipo booleano que nos servira para ver donde ya revisamos, en este caso los horizontales
  boolean horizontales = false;
  // Variable local de tipo booleano que nos servira para ver donde ya revisamos, en este caso los verticales
  boolean verticales = false;

  // En esta parte vamos a verificar si hay una combinacion de forma horizontal, se va escaner de 3 en 3, bajando, y si encontramos la combiacion en alguna de las
  // casillas horizontales entonces hacemos dos revisiones, mandamos true en horizontales y true en victoria. Esto sirve para indenpendizar parte del codigo
  for (int i=0; i < 9; i+=3) {
    // Verificamos cada una de las casillas recorridas por el for viendo si hay combiacion de 3
    if (casillas[2][i] == jugador && casillas[2][i+1] == jugador 
      && casillas[2][i+2] == jugador) {
      // Si encontramos combinacion horizontal, a nuestra variable local le cambiamos el valor, nos servira posteriormente en el codigo  
      horizontales = true;
      // Si encontramos combinacion horizontal de 3, entonces el jugador habra gando, y podemos salir del bucle for.
      return true;
    }
  }
  // En esta parte vamos a verificar si hay una combinacion de forma vertical, se va escaner de 3 en 3, yendo de lado, y si encontramos la combiacion en alguna de las
  // casillas verticales entonces hacemos dos revisiones, mandamos true en verticales y true en victoria. Esto sirve para indenpendizar parte del codigo
  for (int i=0; i < 3; i+=1) {
    // Verificamos cada una de las casillas recorridas por el for viendo si hay combiacion de 3 o sea que el jugador se encuentre en las 1, que el valor en ese index(posición)
    // sea el mismo para los tres
    if (casillas[2][i] == jugador && casillas[2][i+3] == jugador 
      && casillas[2][i+6] == jugador) {
      // Si encontramos combinacion vertical, a nuestra variable local le cambiamos el valor, nos servira posteriormente en el codigo  
      verticales = true;
      // Si encontramos combinacion horizontal de 3, entonces el jugador habra gando, y podemos salir del bucle for.
      return true;
    }
  }
  // Ahora si no encontramos ninguna combinacion horizontal o vertical, entonces podra haber una de las dos combiaciones diagonales
  // entonces con ayuda de nuestras variables locales, si estas siguen siendo falsas, procederemos a analizar si hay una combinacion diagonal en las
  // casillas para esto sea posible, tenemos la condificion tiene que ser false && false, si alguna de las dos es true, entonces este codigo no se ejecuta
  // tambien nos sirve ha agilizar las cosas, por que no tenemos que analizar una y otra vez la misma cosa.
  if (!horizontales && !verticales) {
    // Verificamos cada una de las casillas diagonal en este caso las casillas {0, 4, 8} -> [1, 5, 9] si estas tienen al mismo jugador entonces ese jugador a ganado
    if (casillas[2][0] == jugador && casillas[2][4] == jugador 
      && casillas[2][8] == jugador) {
      // Devolvemos verdadero si hay una combinacion de 3 digonal o sea {[1,0,0], [0,1,0], [0, 0, 1]} siendo las matrices 1, 5, 9 
      return true;
      // De lo contrario verificamos cada una de las casillas diagonal en este caso las casillas {2, 4, 6} -> [3, 5, 7] si estas tienen al mismo jugador entonces ese jugador a ganado
    } else if (casillas[2][2] == jugador && casillas[2][4] == jugador 
      && casillas[2][6] == jugador) {
      // Devolvemos verdadero si hay una combinacion de 3 digonal o sea {[0,0,1], [0,1,0], [1, 0, 0]} siendo las matrices 3, 5, 7 
      return true;
    }
  }
  // Si posteiormente todo se eso falla, entonces significa que aun no hay un ganador en la partida, y se devuelve un false, para pasar al siguiente turno
  return false;
}

/**
 * Esto se encargara de regresar a los valores originales a todo el juego exceptuando al marcador, para que asi, se pueda generar una nueva partida
 * sin perder los datos de quien va ganando, y quien va perdiendo,
 * basicamente, regresa a todos las variables que se enlistas a sus valores originales.
 */
private void accionReinicio() {
  // Limpia la pantalla y despues se van ha redibujar (Recuerda que el void Draw se repite indefinidamente)
  clear();
  // Se regresan los valores originales al iniciar el juego
  background(fondoJuego);
  // Esto crea una nueva matriz de 9x3 o sea {[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]} la nuevas matrices siempre se rellena por defecto con ceros
  casillas = new int[3][9];
  numeroTurno = 0;
  jugadorActual = 1;
  jugando = true;
  primerJugador = true;
  segundoJugador = false;
  victoria = false;
  coordenadaVariableImagen = 340;
  coordenadaVariableTexto = 220;
  textoDeJuego = "Turno Jugador: ";
  // Se termina el listado de variables
}

/**
 * Se encarga de realizar los efectos de victoria en pantalla, comprobando quien es el jugador y si es victorioso
 * pone el nuevo texto de victoria, reproduce el sonido y pone la imagen del ganador
 * @param int jugador, boolean victoria  
 * "los parametros son finales por que el valor no cambiare en el metodo, ayuda a Java agilizar procesos"
 */
private void efectosVictoria(final int jugador, final boolean victoria) {
  // Comprobamos si hay victoria, si no hay no hacemos nada
  if (victoria == true) {
    // Cambiamos la coordenada de la imagen para que se ajuste al texto, la declarion es igual a: coordenadaVariableImagen =  coordenadaVariableImagen + 55;
    coordenadaVariableImagen += 55;
    // Definimos el nuevo texto de victoria
    textoDeJuego = textoVictoria;
    // Reproducimos el sonido de victoria
    sonidoVictoria.play();
    // Si el jugador que gano es el 1, ponemos su imagen
    if (jugador == 1) {
      // Se carga la nueva imagen
      imagenTurno = loadImage("x.png");
      // De lo contrio si gano el jugador 2, ponemos su imagen
    } else {
      // Cargamos su nueva imagen
      imagenTurno = loadImage("o.png");
    }
  }
}

/**
 * Este metodo se encarga de hacer la suma de puntuacion en el juego
 * tomando como argumento el jugador.
 * @param int jugador: jugador actual
 */
public void sumarMarcador(final int jugador) {
  // Comprobamos quien es el jugador
  if (jugador == 1) {
    // Si el 1, sumamos 1 al jugador 1
    puntajePrimerJugador++;
  } else {
    // Si es el 2, sumamos 1 al jugador 2
    puntajeSegundoJugador++;
  }
}