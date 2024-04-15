// PSO de acuerdo a Talbi (p.247 ss)

PImage surf; // imagen que entrega el fitness

// ===============================================================
int puntos = 100;
Particle[] fl; // arreglo de partículas
float d = 5; // radio del círculo, solo para despliegue
float gbestx, gbesty, gbest; // posición y fitness del mejor global
float w = 1; // inercia: baja (~50): explotación, alta (~5000): exploración (2000 ok)
float C1 = 10, C2 =  30; // learning factors (C1: own, C2: social) (ok)
int evals = 0, evals_to_best = 0; //número de evaluaciones, sólo para despliegue
float maxv = 2; // max velocidad (modulo)


// Tiempo de inicio
int startTime;
// Arreglo para guardar datos
ArrayList<String> datos = new ArrayList<String>();



// dibuja punto azul en la mejor posición y despliega números
void despliegaBest(){
  fill(#0000ff);
  ellipse(gbestx,gbesty,d,d);
  PFont f = createFont("Arial",16,true);
  textFont(f,15);
  fill(#00ff00);
  text("Best fitness: " + nf(gbest, 1, 8) + "\nEvals to best: " + str(evals_to_best) + "\nEvals: " + str(evals), 10, 20);
}

// ===============================================================

void setup(){  
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  //size(1440,720); //setea width y height
  //surf = loadImage("marscyl2.jpg");
  
  size(741,691); //setea width y height (de acuerdo al tamaño de la imagen)
  surf = loadImage("restigin.png");
  gbest = Float.MAX_VALUE;
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  smooth();
  // crea arreglo de objetos partículas
  fl = new Particle[puntos];
  for(int i =0;i<puntos;i++)
    fl[i] = new Particle();
    
  startTime = millis();
}

void draw(){
  
  if (millis() - startTime > 20000) {
    // Guardar datos en un archivo CSV
    saveStrings("datos.csv", datos.toArray(new String[0]));
    // Detener el programa
    exit();
  }
   if (millis() - startTime >= datos.size() * 50) {
    guardarDatos();
  }
  
  
  //background(200);
  //despliega mapa, posiciones  y otros
  image(surf,0,0);
  for(int i = 0;i<puntos;i++){
    fl[i].display();
  }
  despliegaBest();
  delay(50);
  //mueve puntos
  for(int i = 0;i<puntos;i++){
    fl[i].move();
    fl[i].Eval();
  }
  
}

void guardarDatos() {
  // Encontrar el ajuste más bajo de todas las partículas en ese momento
  float minFit = Float.MAX_VALUE;
  for (int i = 0; i < puntos; i++) {
    if (fl[i].fit < minFit) {
      minFit = fl[i].fit;
    }
  }
  
  // Calcular promedio de fits de todas las partículas
  float sumFit = 0;
  for (int i = 0; i < puntos; i++) {
    sumFit += fl[i].fit;
  }
  float promedioFit = sumFit / puntos;
  
  // Agregar datos al arreglo
  datos.add(nf(minFit, 1, 8) + "," + nf(promedioFit, 1, 8));
}
