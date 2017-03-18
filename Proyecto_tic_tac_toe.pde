import processing.sound.*;

private final String textoReinicio = "Reiniciar Partida";
private String textoJugador = "Turno Jugador: ";
private String textoVictoria = "Ha ganado el jugador: ";

private PFont fuente;

private boolean primerJugador = true;
private boolean segundoJugador = false;

private boolean victoria = false;

private int puntajePrimerJugador = 0;
private int puntajeSegundoJugador = 0;

private boolean jugando = true;

private int jugadorActual = 1;

private int numeroTurno = 0;

private int[][] casillas = new int[3][9]; 

private PImage simboloX;
private PImage simboloO;

private PImage imagenTurno;

private PImage imagenJugadorActual;

private color fondo;
private color fondoReinicio;

private int coordenadaFijaImagen = 340;
private int coordenadaFijaTexto = 220;

private int x = 250;
private int y = 220;
private int x2 = 250;
private int y2 = 480;

private SoundFile clickBoton;
private SoundFile sonidoEmpate;
private SoundFile sonidoVictoria;

void setup() {   

  size(600, 600);
  background(0, 189, 173);

  simboloX = loadImage("x.png");
  simboloO = loadImage("o.png");

  fuente = loadFont("Beirut-20.vlw");
  fondo = #F8F8F8;
  fondoReinicio = #F8F8F8;

  clickBoton = new SoundFile(this, "sonidoClick.mp3");
  sonidoEmpate = new SoundFile(this, "sonidoEmpate.mp3");
  sonidoVictoria = new SoundFile(this, "sonidoVictoria.mp3");
}

void draw() {
  tablero(x, y, x2, y2);

  noStroke();
  fill(fondo);
  rect(0, 0, 600, 150);
  noFill();

  fill(fondoReinicio);
  rect(0, 550, 600, 50);
  noFill();

  fill(255, 255, 255);
  rect(150, 50, 150, 40, 7);
  noFill();

  image(simboloX, 155, 60, 20, 20);

  fill(0);
  textFont(fuente);
  textSize(30);
  text(String.valueOf(puntajePrimerJugador), 275, 77);

  fill(255, 255, 255);
  rect(310, 50, 150, 40, 7);
  noFill();

  image(simboloO, 315, 60, 20, 20);
  fill(0);
  textFont(fuente);
  textSize(30);
  text(String.valueOf(puntajeSegundoJugador), 435, 77);

  fondoReinicio = fondo;

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

void tablero(final int x, final int y, final int x2, final int y2) {
  strokeCap(SQUARE);
  stroke(0, 161, 147);
  line(x, y, x2, y2);
  line(x + 90, y, x2 + 90, y2);

  line(x - 85, y + 85, x2 + 175, y2 - 175);
  line(x - 85, y + 175, x2 + 175, y2 - 85);

  noStroke();
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
  if (mouseX > x - 80 && mouseX <= x - 5 && mouseY >= y && mouseY < y2 - 180) {
    if (!casillaOcupada(1)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, x - 75, y + 10, 60, 60);
      asignarCasilla(1, 1, jugadorActual);
      victoria = comprobarVictoria(jugadorActual);
    }
  }

  // Cuadro 2
  if (mouseX >= x + 10  && mouseX <= x + 85 && mouseY >= y && mouseY < y2 - 180) {
    if (!casillaOcupada(2)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, x + 15, y + 10, 60, 60);
      asignarCasilla(2, 1, jugadorActual);
      victoria = comprobarVictoria(jugadorActual);
    }
  }

  // Cuadro 3
  if (mouseX >= x + 90  && mouseX <= x + 175 && mouseY >= y && mouseY < y2 - 180) {
    if (!casillaOcupada(3)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, x + 105, y + 10, 60, 60);
      asignarCasilla(3, 1, jugadorActual);
      victoria = comprobarVictoria(jugadorActual);
    }
  }

  // Cuadro 4
  if (mouseX >= x - 80  && mouseX <= x - 5 && mouseY >= y + 90 && mouseY < y2 - 90) {
    if (!casillaOcupada(4)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, x - 75, y + 100, 60, 60);
      asignarCasilla(4, 1, jugadorActual);
      victoria = comprobarVictoria(jugadorActual);
    }
  }

  // Cuadro 5
  if (mouseX >= x + 5  && mouseX <= x + 85 && mouseY >= y + 90 && mouseY < y2 - 85) {
    if (!casillaOcupada(5)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, x + 15, y + 100, 60, 60);
      asignarCasilla(5, 1, jugadorActual);
      victoria = comprobarVictoria(jugadorActual);
    }
  }

  // Cuadro 6
  if (mouseX >= x + 90  && mouseX <= x + 175 && mouseY >= y + 90 && mouseY < y2 - 85) {
    if (!casillaOcupada(6)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, x + 105, y + 100, 60, 60);
      asignarCasilla(6, 1, jugadorActual);
      victoria = comprobarVictoria(jugadorActual);
    }
  }

  // Cuadro 7
  if (mouseX >= x - 80  && mouseX <= x + 5 && mouseY >= y + 180 && mouseY < y2) {
    if (!casillaOcupada(7)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, x - 75, y + 190, 60, 60);
      asignarCasilla(7, 1, jugadorActual);
      victoria = comprobarVictoria(jugadorActual);
    }
  }

  // Cuadro 8
  if (mouseX >= x + 5  && mouseX <= x + 85 && mouseY >= y + 180 && mouseY < y2) {
    if (!casillaOcupada(8)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, x + 15, y + 190, 60, 60);
      asignarCasilla(8, 1, jugadorActual);
      victoria = comprobarVictoria(jugadorActual);
    }
  }

  // Cuadro 9
  if (mouseX >= x + 90  && mouseX <= x + 175 && mouseY >= y + 180 && mouseY < y2) {
    if (!casillaOcupada(9)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, x + 105, y + 190, 60, 60);
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