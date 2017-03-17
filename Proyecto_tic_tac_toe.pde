import java.util.Arrays;

private final String textoReinicio = "Reiniciar Partida";
private final String textoJugador = "Turno Jugador: ";
private PFont fuente;

private boolean primerJugador = true;
private boolean segundoJugador = false;

private int puntajePrimerJugador = 0;
private int puntajeSegundoJugador = 0;

private boolean jugando = true;

private int jugadorActual = 1;

private int numeroTurno = 0;

private int[][] casillas = new int[3][9]; 

private PImage simboloX;
private PImage simboloO;

private PImage imagenJugadorActual;

private color fondo;
private color fondoReinicio;

private int x = 250;
private int y = 220;
private int x2 = 250;
private int y2 = 480;

void setup() {   

  size(600, 600);
  background(0, 189, 173);

  simboloX = loadImage("x.png");
  simboloO = loadImage("o.png");

  fuente = loadFont("Beirut-20.vlw");
  fondo = #F8F8F8;
  fondoReinicio = #F8F8F8;
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
  text(String.valueOf(puntajePrimerJugador), 280, 77);

  fill(255, 255, 255);
  rect(310, 50, 150, 40, 7);
  noFill();

  image(simboloO, 315, 60, 20, 20);
  fill(0);
  textFont(fuente);
  textSize(30);
  text(String.valueOf(puntajeSegundoJugador), 440, 77);

  fondoReinicio = fondo;

  fill(0);
  textFont(fuente);
  textSize(15);
  text(textoJugador, 220, 125);

  if (imagenJugadorActual != null) {
    PImage imagenTurno = imagenJugadorActual(primerJugador, segundoJugador);
    image(imagenTurno, 340, 110, 20, 20);
  }

  fill(0, 189, 173);
  textFont(fuente);
  text(textoReinicio, 215, 580);
  strokeWeight(10);
}

void mousePressed() {
  println("Las coordenadas: X: " + mouseX + " Y: " + mouseY);
  if (mouseX > 0 && mouseY >= 550) {
    fondoReinicio = #DCDCDC;
  }

  println("El primero es: " + primerJugador);
  println("El segundo es: " + segundoJugador);

  do {
    if (numeroTurno < 9) {
      funcionBotones();
      println("El turno es: " + numeroTurno);
      jugando = false;
    } else {
      println(Arrays.deepToString(casillas));
    }
  } while (jugando);
}

void tablero(int x, int y, int x2, int y2) {
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
  } else {
    imagenJugadorActual = loadImage("o.png");
    primerJugador = true;
    segundoJugador = false;
    jugadorActual = 2;
  }
  this.primerJugador = primerJugador;
  this.segundoJugador = segundoJugador;
  numeroTurno++;
}

private PImage imagenJugadorActual(boolean primerJugador, boolean segundoJugador) {
  PImage imagenTurno;
  if (primerJugador == false && segundoJugador == true) {
    imagenTurno = loadImage("o.png");
  } else {
    imagenTurno = loadImage("x.png");
  }
  return imagenTurno;
}

private boolean comprobarVictoria(int jugador) {
  boolean lineales = false;

  println("Es el jugador: " + jugador);
  for (int i=0; i < 9; i+=3) {
    println("EL valor de i: " + i);
    if (casillas[2][i] == jugador && casillas[2][i+1] == jugador 
      && casillas[2][i+2] == jugador) {
      println("Victoria!");
      lineales = true;
      return true;
    }
  }
  if (!lineales) {
    if (casillas[2][0] == jugador && casillas[2][4] == jugador 
      && casillas[2][8] == jugador) {
      println("Victoria!");
      return true;
    } else if (casillas[2][2] == jugador && casillas[2][4] == jugador 
      && casillas[2][6] == jugador) {
      println("Victoria!");
      return true;
    }
  }
  println("Nada");
  return false;
}

private void funcionBotones() {
  //Cuadro 1
  if (mouseX > x - 80 && mouseX <= x - 5 && mouseY >= y && mouseY < y2 - 180) {
    println("Las coordenadas: X: " + mouseX + " Y: " + mouseY + " Cuadro 1");
    if (!casillaOcupada(1)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, x - 75, y + 10, 60, 60);
      asignarCasilla(1, 1, jugadorActual);
      comprobarVictoria(jugadorActual);
    }
  }

  // Cuadro 2
  if (mouseX >= x + 10  && mouseX <= x + 85 && mouseY >= y && mouseY < y2 - 180) {
    println("Las coordenadas: X: " + mouseX + " Y: " + mouseY + " Cuadro 2");
    if (!casillaOcupada(2)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, x + 15, y + 10, 60, 60);
      asignarCasilla(2, 1, jugadorActual);
    }
  }

  // Cuadro 3
  if (mouseX >= x + 90  && mouseX <= x + 175 && mouseY >= y && mouseY < y2 - 180) {
    println("Las coordenadas: X: " + mouseX + " Y: " + mouseY + " Cuadro 3");
    if (!casillaOcupada(3)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, x + 105, y + 10, 60, 60);
      asignarCasilla(3, 1, jugadorActual);
    }
  }

  // Cuadro 4
  if (mouseX >= x - 80  && mouseX <= x - 5 && mouseY >= y + 90 && mouseY < y2 - 90) {
    println("Las coordenadas: X: " + mouseX + " Y: " + mouseY + " Cuadro 4");
    if (!casillaOcupada(4)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, x - 75, y + 100, 60, 60);
      asignarCasilla(4, 1, jugadorActual);
    }
  }

  // Cuadro 5
  if (mouseX >= x + 5  && mouseX <= x + 85 && mouseY >= y + 90 && mouseY < y2 - 85) {
    println("Las coordenadas: X: " + mouseX + " Y: " + mouseY + " Cuadro 5");
    if (!casillaOcupada(5)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, x + 15, y + 100, 60, 60);
      asignarCasilla(5, 1, jugadorActual);
    }
  }

  // Cuadro 6
  if (mouseX >= x + 90  && mouseX <= x + 175 && mouseY >= y + 90 && mouseY < y2 - 85) {
    println("Las coordenadas: X: " + mouseX + " Y: " + mouseY + " Cuadro 6");
    if (!casillaOcupada(6)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, x + 105, y + 100, 60, 60);
      asignarCasilla(6, 1, jugadorActual);
    }
  }

  // Cuadro 7
  if (mouseX >= x - 80  && mouseX <= x + 5 && mouseY >= y + 180 && mouseY < y2) {
    println("Las coordenadas: X: " + mouseX + " Y: " + mouseY + " Cuadro 7");
    println("Jugador actual: " + jugadorActual);
    if (!casillaOcupada(7)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, x - 75, y + 190, 60, 60);
      asignarCasilla(7, 1, jugadorActual);
    }
    println("Estado: " + !casillaOcupada(7));
    println("Jugador actual: " + jugadorActual);
  }

  // Cuadro 8
  if (mouseX >= x + 5  && mouseX <= x + 85 && mouseY >= y + 180 && mouseY < y2) {
    println("Las coordenadas: X: " + mouseX + " Y: " + mouseY + " Cuadro 5");
    if (!casillaOcupada(8)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, x + 15, y + 190, 60, 60);
    }
    asignarCasilla(8, 1, jugadorActual);
  }

  // Cuadro 9
  if (mouseX >= x + 90  && mouseX <= x + 175 && mouseY >= y + 180 && mouseY < y2) {
    println("Las coordenadas: X: " + mouseX + " Y: " + mouseY + " Cuadro 9");
    if (!casillaOcupada(9)) {
      estadoJugadorActual(primerJugador, segundoJugador);
      image(imagenJugadorActual, x + 105, y + 190, 60, 60);
    }
    asignarCasilla(9, 1, jugadorActual);
  }
}

public void asignarCasilla(int cuadro, int ocupado, int jugadorActual) {
  casillas[0][cuadro - 1] = cuadro;
  casillas[1][cuadro - 1] = ocupado;
  casillas[2][cuadro - 1] = jugadorActual;
}

public boolean casillaOcupada(int cuadro) {
  if (casillas[1][cuadro - 1] == 1) {
    return true;
  }
  return false;
}