#pragma once

#include <math.h>
#include "MathTools.h"

#include "ColorTools_GPU.h"
using namespace gpu;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

class RayTracingMath
    {

	/*--------------------------------------*\
	|*		Constructor		*|
	 \*-------------------------------------*/

    public:

	__device__ RayTracingMath(int nb_Spheres, Sphere* ptrDevTabSpheres)
	    {
	    this->nb_Spheres = nb_Spheres;
	    this->ptrDevTabSphere = ptrDevTabSphere;
	    }

	// constructeur copie automatique car pas pointeur dans RayTracingMath

	__device__
	   virtual ~RayTracingMath()
	    {
	    // rien
	    }

	/*--------------------------------------*\
	|*		Methodes		*|
	 \*-------------------------------------*/

    public:

	__device__
	void colorIJ(uchar4* ptrColor, int i, int j, float t)
	    {
	    float2 xySol;
	    xySol.x = j;
	    xySol.y = i;
	    float minDist = 1000;
	    for (int k = 0; k < nb_Spheres; k++)
		{
		Sphere spherek = this->ptrDevTabSphere[k];
		float hcarre = spherek.hCarre(xySol);
		if (spherek.isEnDessous(hcarre))
		    {
		    float currentDist = spherek.distance(spherek.dz(hcarre));
		    if(currentDist < minDist)
			{
			minDist = currentDist;
			}
		    else
			{

			}
		    }
		else
		    {
		    ptrColor->x = 0;
		    ptrColor->y = 0;
		    ptrColor->z = 0;
		    }
		}

	    ptrColor->w = 255; // opaque
	    }

    private:

	/*--------------------------------------*\
	|*		Attributs		*|
	 \*-------------------------------------*/

    private:
	//Input
	int nb_Spheres;
	Sphere* ptrDevTabSphere;

    };

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
