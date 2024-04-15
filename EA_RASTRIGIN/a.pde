// Definición de datos para el gráfico
//float[] datos = {1, 3, 2, 5, 4, 7, 6, 9};



void dibujarGrafico(ArrayList<Float> datos) {
  // Dibuja el sistema de coordenadas
  stroke(0);
  line(50, height - 50, width - 50, height - 50); // Eje X
  line(50, height - 50, 50, 50); // Eje Y

  // Dibuja las etiquetas de los ejes
  textSize(12);
  textAlign(RIGHT);
  for (int i = 0; i <= 10; i++) {
    float x = map(i, 0, 10, 50, width - 50);
    line(x, height - 55, x, height - 45); // Marcas en el eje X
    text(str(i), x, height - 30); // Etiquetas en el eje X
  }
  textAlign(CENTER);
  for (int i = 0; i <= 8; i++) {
    float y = map(i, 0, 8, height - 50, 50);
    line(45, y, 55, y); // Marcas en el eje Y
    text(str(i), 30, y + 5); // Etiquetas en el eje Y
  }

  // Dibuja el gráfico de líneas
  stroke(0, 0, 255); // Color azul
  float xInc = (width - 100) / (datos.size() - 1); // Incremento en el eje X
  for (int i = 0; i < datos.size() - 1; i++) {
    float x1 = 50 + i * xInc;
    float y1 = height - 50 - map(datos.get(i), 0, 10, 0, height - 100);
    float x2 = 50 + (i + 1) * xInc;
    float y2 = height - 50 - map(datos.get(i + 1), 0, 10, 0, height - 100);
    line(x1, y1, x2, y2); // Dibuja una línea entre los puntos
    ellipse(x1, y1, 5, 5); // Marca los puntos con círculos
  }
  ellipse(50 + (datos.size() - 1) * xInc, height - 50 - map(datos.get(datos.size() - 1), 0, 10, 0, height - 100), 5, 5); // Marca el último punto
}
