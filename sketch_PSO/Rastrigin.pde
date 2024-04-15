float rastrigin_func(float[] x)
{
  float suma = 0;
  float n = x.length;
  for(int i = 0; i < n; i++)
  {
    suma += pow(x[i],2) - 10*cos(2*PI*x[i]);
  }
  return 10*n + suma;
}
