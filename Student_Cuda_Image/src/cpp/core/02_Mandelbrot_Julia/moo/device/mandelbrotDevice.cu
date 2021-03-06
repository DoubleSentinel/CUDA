#include "Indice2D.h"
#include "cudaTools.h"
#include "Device.h"
#include "MandelbrotMath.h"
#include "DomaineMath_GPU.h"

#include "IndiceTools_GPU.h"
using namespace gpu;

// Attention : 	Choix du nom est impotant!
//		VagueDevice.cu et non Vague.cu
// 		Dans ce dernier cas, probl�me de linkage, car le nom du .cu est le meme que le nom d'un .cpp (host)
//		On a donc ajouter Device (ou n'importequoi) pour que les noms soient diff�rents!

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

__global__ void mandelbrot(uchar4* ptrDevPixels,uint w, uint h,float t, DomaineMath d);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/
__global__ void mandelbrot(uchar4* ptrDevPixels, uint w, uint h, float t,
		DomaineMath domaineMath)
    {
    MandelbrotMath mandelbrotMath = MandelbrotMath(t);

    const int TID = Indice2D::tid();
    const int NB_THREAD = Indice2D::nbThread();
    const int WH = w * h;

    uchar4 color;
    double x, y;
    int i, j = 0;

    int s = TID;
    while (s < WH)
	{
	IndiceTools::toIJ(s, w, &i, &j);
	domaineMath.toXY(i, j, &x, &y);
	mandelbrotMath.colorXY(&color, x, y);
	ptrDevPixels[s] = color;
	s += NB_THREAD;
	}
    }
/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

