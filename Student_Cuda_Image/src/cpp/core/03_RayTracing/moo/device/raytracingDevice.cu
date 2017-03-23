#include "Indice2D.h"
#include "cudaTools.h"
#include "Device.h"

#include "IndiceTools_GPU.h"

#include "RayTracingMath.h"
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

__global__ void raytracing(uchar4* ptrDevPixels, uint w, uint h, float t, int nbSphere, Sphere* ptrDevTabSphere);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

__global__ void raytracing(uchar4* ptrDevPixels, uint w, uint h, float t, int nbSphere, Sphere* ptrDevTabSphere)
    {

    RayTracingMath rayTracingMath = RayTracingMath(nbSphere, ptrDevTabSphere);

    const int TID = Indice2D::tid();
    const int NB_THREAD = Indice2D::nbThread();
    const int WH = w * h;

    int s = TID;
    int i;
    int j;
    //Interlaced distribution pattern
    while (s < WH)
        {
        IndiceTools::toIJ(s, w, &i, &j);
        rayTracingMath.colorIJ(&ptrDevPixels[s], i, j, t);
        s += NB_THREAD;
        }
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

