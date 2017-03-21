#pragma once

#include <math.h>
#include "MathTools.h"
#include "Sphere.h"
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
	    ptrColor->x = 0;
	    ptrColor->y = 0;
	    ptrColor->z = 0;
	    ptrColor->w = 255; // opaque
	    float min = 100000.f;
	    float hueMin = -10000.f;
	    float brightnessMin = -100000.f;
	    for (int k = 0; k < nb_Spheres; k++)
		{
		Sphere spherek = this->ptrDevTabSphere[k];
		float hcarre = spherek.hCarre(xySol);
		if (spherek.isEnDessous(hcarre))
		    {
		    float dz = spherek.dz(hcarre);
		    float dist = spherek.distance(dz);

		    if(dist < min)
			{
			min = dist;
			hueMin = spherek.hue(t);
			brightnessMin = spherek.brightness(dz);
			}
		    }
		}

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
