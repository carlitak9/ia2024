import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

float[] fitnessPromedioPorGeneracion;
float[] mejorFitnessPorGeneracion;

PImage surf; // imagen que entrega el fitness

// ===============================================================
int puntos = 100;
Particle[] poblacion; // arreglo de individuos
float gbest; // fitness del mejor global
int dimension = 2;
int d = 10;
float[] gbest_pos = new float[dimension]; // posición del mejor global
int evals = 0, evals_to_best = 0; //número de evaluaciones, sólo para despliegue
int generaciones = 50;
ArrayList<Float> mejores_fitness = new ArrayList<Float>();

class Particle {
  float[] genes = new float[2];
  float fitness;


  Particle() {
    for (int i = 0; i < 2; i++) {
      genes[i] = random(-3, 7); // Inicializa los genes aleatoriamente
    }
    fitness = rastrigin_func(genes);
  }
  
  void display(){
    float x = map(genes[0], -3, 7, 0, 741);
    float y = map(genes[1], 7, -3, 0, 691);
    ellipse (x,y,d,d);
    // dibuja vector
    stroke(#ff0000);
    //line(x,y,x-10*vx,y-10*vy);
  }
}

// Inicializa la población
void inicializarPoblacion() {
  poblacion = new Particle[puntos];
  for (int i = 0; i < puntos; i++) {
    poblacion[i] = new Particle();
  }
}

// Función de evaluación de Rastrigin
float rastrigin_func(float[] x)
{
  evals++;
  float suma = 0;
  float n = x.length;
  for(int i = 0; i < n; i++)
  {
    suma += pow(x[i],2) - 10*cos(2*PI*x[i]);
  }
  return 10*n + suma;
}


// Selección de padres por torneo binario
Particle seleccionTorneo(Particle[] poblacion) {
  int idx = int(random(poblacion.length));
  int idy = int(random(poblacion.length));
  if (poblacion[idx].fitness < poblacion[idy].fitness) {
    return poblacion[idx];
  } else {
    return poblacion[idy];
  }
}

// Cruce de dos padres
Particle cruzar(Particle padre1, Particle padre2) {
  float margen = 0.3;
  float max, min;
  Particle hijo = new Particle();
  for (int i = 0; i < dimension; i++) {
    if (padre1.genes[i] > padre2.genes[i]) 
    {
      max = padre1.genes[i];
      min = padre2.genes[i];   
    }
    else
    {
      max = padre2.genes[i];
      min = padre1.genes[i];  
    }
    hijo.genes[i] = random(min - margen, max + margen);
  }
  return hijo;
}

// Mutación de un individuo
void mutar(Particle individuo, float tasaMutacion) {
   if (random(1) < tasaMutacion) {
    for (int i = 0; i < dimension; i++){
      individuo.genes[i] += randomGaussian() * 0.5; // Mutación gaussiana
      // Limita los genes al rango [-3, 7]
      individuo.genes[i] = constrain(individuo.genes[i], -3, 7);
    }
  }
}



// Encuentra el mejor individuo en la población
void encontrarMejor() {
  gbest = poblacion[0].fitness;
  for (int i = 0; i < puntos; i++) {
    if (poblacion[i].fitness < gbest) {
      gbest = poblacion[i].fitness;
      gbest_pos = poblacion[i].genes;
      evals_to_best = evals;
      println("Best fitness: " + gbest);
    }
  }
}

// Despliega el mejor individuo
void despliegaBest() {
  float x = map(gbest_pos[0], -3, 7, 0, 741);
  float y = map(gbest_pos[1], 7, -3, 0, 691);
  PFont f = createFont("Arial", 16, true);
  textFont(f, 15);
  ellipse(x,y,d,d);
  fill(#00ff00);
  text("Best fitness: " + str(gbest) + "\nEvals to best: " + str(evals_to_best) + "\nEvals: " + str(evals), 10, 20);
}

void grafico(){
  stroke(0);
  line(50,height-50,width-50,height-50);
  line(50,50,50,height-50);
  
  fill(0);
  text("Fitness",40,25);
  text("Generacion",width-50,height-30);
  text("0",40,height-40);
  
  noStroke();
  fill(0, 0, 255);
  circle(width-130,95,6);
  text("Fitness Promedio",width-120,100);
  fill(0, 150, 0);
  circle(width-130,115,6);
  text("Mejor Fitness",width-120,120);
}

// Variables para control de tiempo
int startTime;
float elapsedTime;

// Datos para guardar en CSV
ArrayList<Float> promedioFitness = new ArrayList<Float>();
ArrayList<Float> mejoresFitness = new ArrayList<Float>();

void setup() {  
  size(741, 691);
  surf = loadImage("rastrigin2.jpeg");
  smooth();
  inicializarPoblacion();
  startTime = millis(); // Inicia el tiempo
}

void draw() {
  elapsedTime = (millis() - startTime) / 1000.0; // Calcula el tiempo transcurrido en segundos
  
  if (elapsedTime >= 20) {
    // Guardar los datos en un archivo CSV al finalizar la ejecución
    guardarDatosCSV();
    exit(); // Termina la ejecución
  }
  
  if (elapsedTime % 0.05 <= 0.02) {
    // Calcula el promedio de fitness y el mejor fitness cada 0.05 segundos
    calcularFitness();
  }

  image(surf, 0, 0);

  for (int i = 0; i < puntos; i++) {
    // Actualiza el fitness de cada individuo
    poblacion[i].fitness = rastrigin_func(poblacion[i].genes);
    poblacion[i].display();
  }
  encontrarMejor();
  despliegaBest();
  
  // Algoritmo evolutivo
  Particle[] nuevaPoblacion = new Particle[puntos];
  for (int i = 0; i < puntos; i++) {
    // Selección de padres
    Particle padre1 = seleccionTorneo(poblacion);
    Particle padre2 = seleccionTorneo(poblacion);
    // Cruce
    Particle hijo = cruzar(padre1, padre2);
    // Mutación
    mutar(hijo, 0.2);
    nuevaPoblacion[i] = hijo;
  }
  // Reemplaza la población anterior con la nueva generación
  poblacion = nuevaPoblacion;
  //mejores_fitness.add(gbest);
  delay(200);
}

void calcularFitness() {
  // Calcula el promedio de fitness
  float sumaFitness = 0;
  for (int i = 0; i < puntos; i++) {
    sumaFitness += poblacion[i].fitness;
  }
  float promedio = sumaFitness / puntos;
  promedioFitness.add(promedio);
  
  // Guarda el mejor fitness
  float mejorFitness = gbest;
  mejoresFitness.add(mejorFitness);
}

void guardarDatosCSV() {
  // Guarda los datos en un archivo CSV
  String[] lines = new String[promedioFitness.size()];

  for (int i = 0; i < promedioFitness.size(); i++) {
    lines[i] = str(promedioFitness.get(i)) + "," + str(mejoresFitness.get(i));
  }
  
  String[] headers = { "Fitness Promedio", "Mejor Fitness" };
  String filename = "datos_fitness.csv";
  
  saveStrings(filename, concat(headers, lines));
}
