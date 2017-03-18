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
 * @version 1.0
 *
 * @see <a href = "https://github.com/Deltarios/Proyecto_tic_tac_toe" /> GitHub – Repositori del Tic Tac Toe </a>
 *
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
private String textoJugador = "Turno Jugador: ";
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

// Reservamos un espacio para el color fondo de la pantalla
private color fondo;
// Reservamos un espacio para el color fondo del boton de reinicio
private color fondoReinicio;
// Reservamos un espacio para el color fondo de los marcadores donde iran cambiando segun el turno y si el mouse se encuentra en los marcodores de puntuacion
private color fondoBotonesCruz;
private color fondoBotonesCirculo;

// Estas  variables de coordenadas fijas nos serviran como una referencia para ir cambiando la posicion sin tantas complicaciones
private int coordenadaFijaImagen = 340;
private int coordenadaFijaTexto = 220;

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
  // Defnimos el color del fondo al juego. 
  background(0, 189, 173);

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

  // Estas lineas de codigo dibujan lo que sera el cuadro blanco inferior del juego donde esta el boton de reinicio
  fill(fondoReinicio);
  rect(0, 550, 600, 50);
  noFill();
  // Finaliza el dibujado del cuadro blanco inferior

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
  // Finaliza el dibujado del marcador del jugador 1

  fill(0);
  textFont(fuente);
  textSize(15);
  text(textoJugador, coordenadaFijaTexto, 125);

  if (imagenJugadorActual != null) {
    if (victoria == false) {
      imagenTurno = imagenJugadorActual(primerJugador, segundoJugador);
    }

    if (numeroTurno != 9 || victoria == true) {
      image(imagenTurno, coordenadaFijaImagen, 110, 20, 20);
    }
  }

  fill(0, 189, 173);
  textFont(fuente);
  text(textoReinicio, 215, 580);
  strokeWeight(10);

  eleccionJugador();
}

void tablero(final int x, final int y, final int x2, final int y2) {
  strokeCap(SQUARE);
  stroke(0, 161, 147);
  line(x, y, x2, y2);
  line(x + 90, y, x2 + 90, y2);

  line(x - 85, y + 85, x2 + 175, y2 - 175);
  line(x - 85, y + 175, x2 + 175, y2 - 85);

  noStroke();
}

void mousePressed() {
  clickBoton.play();

  if (mouseX > 0 && mouseY >= 550) {
    fondoReinicio = #DCDCDC;
    accionReinicio();
  }

  if (jugando) {
    if (numeroTurno < 9) {
      if (victoria == false) {
        funcionBotones();
        println("El turno es: " + numeroTurno);
        if (victoria == true) {
          efectosVictoria(jugadorActual, victoria);
          sumarMarcador(jugadorActual);
        } else if (numeroTurno == 9) {
          coordenadaFijaTexto += 50;
          sonidoEmpate.play();
          textoJugador = "¡Empate!";
        }
      } else {
        jugando = false;
      }
    }
  }
}

private void estadoJugadorActual(boolean primerJugador, boolean segundoJugador) {
  if (primerJugador == true && segundoJugador == false) {
    imagenJugadorActual = loadImage("x.png");
    primerJugador = false;
    segundoJugador = true;
    jugadorActual = 1;
    numeroTurno++;
  } else {
    imagenJugadorActual = loadImage("o.png");
    primerJugador = true;
    segundoJugador = false;
    jugadorActual = 2;
    numeroTurno++;
  }
  this.primerJugador = primerJugador;
  this.segundoJugador = segundoJugador;
}

private PImage imagenJugadorActual(final boolean primerJugador, final boolean segundoJugador) {
  PImage imagenTurno;
  if (primerJugador == false && segundoJugador == true) {
    imagenTurno = loadImage("o.png");
  } else {
    imagenTurno = loadImage("x.png");
  }
  return imagenTurno;
}

private boolean comprobarVictoria(final int jugador) {
  boolean horizontales = false;
  boolean verticales = false;

  for (int i=0; i < 9; i+=3) {
    if (casillas[2][i] == jugador && casillas[2][i+1] == jugador 
      && casillas[2][i+2] == jugador) {
      horizontales = true;
      return true;
    }
  }

  for (int i=0; i < 3; i+=1) {
    if (casillas[2][i] == jugador && casillas[2][i+3] == jugador 
      && casillas[2][i+6] == jugador) {
      verticales = true;
      return true;
    }
  }

  if (!horizontales && !verticales) {
    if (casillas[2][0] == jugador && casillas[2][4] == jugador 
      && casillas[2][8] == jugador) {
      return true;
    } else if (casillas[2][2] == jugador && casillas[2][4] == jugador 
      && casillas[2][6] == jugador) {
      return true;
    }
  }
  return false;
}

private void funcionBotones() {
  //Cuadro 1
  if (mouseX > X_FIJA - 80 && mouseX <= X_FIJA - 5 && mouseY >= Y_FIJA && mouseY < Y2_FIJA - 180) {
    if (!casillaOcupada(1)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, X_FIJA - 75, Y_FIJA + 10, 60, 60);
      asignarCasilla(1, 1, jugadorActual);
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

public void asignarCasilla(final int cuadro, final int ocupado, final int jugadorActual) {
  casillas[0][cuadro - 1] = cuadro;
  casillas[1][cuadro - 1] = ocupado;
  casillas[2][cuadro - 1] = jugadorActual;
}

public boolean casillaOcupada(final int cuadro) {
  if (casillas[1][cuadro - 1] == 1) {
    return true;
  }
  return false;
}

public void sumarMarcador(final int jugador) {
  if (jugador == 1) {
    puntajePrimerJugador++;
  } else {
    puntajeSegundoJugador++;
  }
}

private void efectosVictoria(final int jugador, final boolean victoria) {
  if (victoria == true) {
    coordenadaFijaImagen += 55;
    textoJugador = textoVictoria;
    sonidoVictoria.play();
    if (jugador == 1) {
      imagenTurno = loadImage("x.png");
    } else {
      imagenTurno = loadImage("o.png");
    }
  }
}

private void accionReinicio() {
  clear();
  background(0, 189, 173);
  casillas = new int[3][9];
  numeroTurno = 0;
  jugadorActual = 1;
  jugando = true;
  primerJugador = true;
  segundoJugador = false;
  victoria = false;
  coordenadaFijaImagen = 340;
  coordenadaFijaTexto = 220;
  textoJugador = "Turno Jugador: ";
}

private void eleccionJugador() {
  if (mouseX >= X_FIJA - 100  && mouseX <= X_FIJA + 50 && mouseY >= Y_FIJA - 170 && mouseY < Y2_FIJA - 390) {
    if (numeroTurno == 0) {
      fondoBotonesCruz = #DCDCDC;
      if (mousePressed) {
        jugadorActual = 1;
        imagenJugadorActual = loadImage("x.png");
        primerJugador = true;
        segundoJugador = false;
      }
    }
  } else if (mouseX >= X_FIJA + 60  && mouseX <= X_FIJA + 210 && mouseY >= Y_FIJA - 170 && mouseY < Y2_FIJA - 390) {
    if (numeroTurno == 0) {
      fondoBotonesCirculo = #DCDCDC;
      if (mousePressed) {
        jugadorActual = 2;
        imagenJugadorActual = loadImage("o.png");
        primerJugador = false;
        segundoJugador = true;
      }
    }
  } else {
    fondoBotonesCruz = #FFFFFF;
    fondoBotonesCirculo = #FFFFFF;
  }
}