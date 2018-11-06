
	/*
	** Generate state data for a bead between magnets.
	*/


#include <stdio.h>
#include <math.h>
#include <time.h>

#define SQR(x)	((x)*(x))

#define TOTAL_DATA	10000

	/* used to generate random data for tracking */
unsigned long urand0 (void);
unsigned long urand (void);
void init_generator(unsigned seed);
double normal_rand (void);
static unsigned long rand_x[56], rand_y[256], rand_z;
static long rand_j, rand_k;


main()

{
double	Noise;
int	t;
double	x,x1,x2;
		/* initialize random number generator */
init_generator(0);
x=0.0;
x1=0.0;
x2=0.0;

for (t=0; t<TOTAL_DATA; t++)
  {
  Noise=normal_rand()/100.0;	/* units are standard deviations */
  if (x < 0.0)
    x2=fabs(Noise);
  else
    x2=0.0-fabs(Noise);
  x1=x1+x2*1.0;
  x=x+x1*1.0;
  printf("%lf\n",x);
  }

}



	/* code taken off web for normal distribution random # generator */

void init_generator(unsigned seed)
{
int i;

rand_x[1] = 1;
if(seed)
  rand_x[2] = seed;
else
  rand_x[2] = time (NULL);
for (i=3; i<56; ++i) rand_x[i] = rand_x[i-1] + rand_x[i-2];
rand_j = 24;
rand_k = 55;
for (i=255; i>=0; --i)
  urand0 (); //run loop for a while
for (i=255; i>=0; --i)
  rand_y[i] = urand0 ();
rand_z = urand0 ();
}

unsigned long urand0 (void)
{
if (--rand_j == 0) rand_j = 55;
if (--rand_k == 0) rand_k = 55;
return rand_x[rand_k] += rand_x[rand_j];
}

unsigned long urand (void)
{
int i;

i = rand_z % 256;
rand_z = rand_y[i];
if (--rand_j == 0) rand_j = 55;
if (--rand_k == 0) rand_k = 55;
rand_y[i] = rand_x[rand_k] += rand_x[rand_j];
return rand_z;
}



double normal_rand (void)
{
static int flag = 0;
static double z, a = 2147483648.0;
double v1, v2, s;

if (flag) {
  flag = 0;
  return z;
  }
flag = 1;
do {
  v1 = urand()/a - 1;
  v2 = urand()/a - 1;
  }
while ((s = v1*v1 + v2*v2) > 1.0);
s = sqrt (-2.0 * log(s) / s);
z = v1 * s;
return v2 * s;
}



