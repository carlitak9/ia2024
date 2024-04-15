class Particle{
  float x, y, fit; // current position(x-vector)  and fitness (x-fitness)
  float px, py, pfit; // position (p-vector) and fitness (p-fitness) of best solution found by particle so far
  float vx, vy; //vector de avance (v-vector)
  float tx, ty;
  
  // ---------------------------- Constructor
  Particle(){
    x = random (-3.0, 7.0); 
  y = random(-3.0, 7.0);
  vx = random(-1,1); 
  vy = random(-1,1);
  
  float[] aux = {this.x, this.y};
  fit = rastrigin_func(aux);
  
  pfit = fit; // Inicializa pfit con el valor inicial de fit
  }
  
  // ---------------------------- Evalúa partícula
  float Eval(){ //recibe imagen que define función de fitness
    evals++;
    //color c=surf.get(int(x),int(y)); // obtiene color de la imagen en posición (x,y)
    float[] aux = {this.x, this.y};
    fit = rastrigin_func(aux); //evalúa por el valor de la componente roja de la imagen
    if(fit < pfit){ // actualiza local best si es mejor
      pfit = fit;
      px = x;
      py = y;
    }
    if (fit < gbest){ // actualiza global best
      gbest = fit;
      gbestx = x;
      gbesty = y;
      evals_to_best = evals;
      println(str(gbest));
    };
    
    return fit; //retorna la componente roja
  }
  
  // ------------------------------ mueve la partícula
  void move(){
    //actualiza velocidad (fórmula con factores de aprendizaje C1 y C2)
    //vx = vx + random(0,1)*C1*(px - x) + random(0,1)*C2*(gbestx - x);
    //vy = vy + random(0,1)*C1*(py - y) + random(0,1)*C2*(gbesty - y);
    //actualiza velocidad (fórmula con inercia, p.250)
    vx = w * vx + random(0,1)*(px - x) + random(0,1)*(gbestx - x);
    vy = w * vy + random(0,1)*(py - y) + random(0,1)*(gbesty - y);
    //actualiza velocidad (fórmula mezclada)
    //vx = w * vx + random(0,1)*C1*(px - x) + random(0,1)*C2*(gbestx - x);
    //vy = w * vy + random(0,1)*C1*(py - y) + random(0,1)*C2*(gbesty - y);
    // trunca velocidad a maxv
    float modu = sqrt(vx*vx + vy*vy);
    if (modu > maxv){
      vx = vx/modu*maxv;
      vy = vy/modu*maxv;
    }
    // update position
    //x = x + vx;
    //y = y + vy;
    
    float new_x = x + vx;
    float new_y = y + vy;
    
    // rebota en murallas
    //if (x > 7 || x < -3) vx = - vx;
    //if (y > 7 || ty < -3) vy = - vy;
     // Revisar los límites
    if (new_x > 7) {
      x = 7 - (new_x - 7); // Reflejar el movimiento fuera del límite
      vx = -vx; // Invertir la velocidad en x
    } else if (new_x < -3) {
      x = -3 + (-3 - new_x); // Reflejar el movimiento fuera del límite
      vx = -vx; // Invertir la velocidad en x
    } else {
      x = new_x; // Sin cambios si no se sale de los límites
    }
    
    if (new_y > 7) {
      y = 7 - (new_y - 7); // Reflejar el movimiento fuera del límite
      vy = -vy; // Invertir la velocidad en y
    } else if (new_y < -3) {
      y = -3 + (-3 - new_y); // Reflejar el movimiento fuera del límite
      vy = -vy; // Invertir la velocidad en y
    } else {
      y = new_y; // Sin cambios si no se sale de los límites
    }
    
  }
  
  // ------------------------------ despliega partícula
  void display(){
    float tx = map(y, -3, 7, 0, 741);
    float ty = map(x, 7, -3, 0, 691);
    fill(255,0,0);
    ellipse (tx, ty,d,d);
    // dibuja vector
    stroke(#ff0000);
    //line(tx, ty,tx-100*vx,ty-100*vy);
  }
} //fin de la definición de la clase Particle
