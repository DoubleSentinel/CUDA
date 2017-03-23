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

	__device__ RayTracingMath(int nbSphere, Sphere* ptrDevTabSphere)
	    {
	    this->nbSphere = nbSphere;
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
	    float min = 10000;
	    float hueMin = -1000;
	    float brightnessMin = -100;
	    //set current floor pixel position
	    float2 xyFloor;
	    xyFloor.x = i;
	    xyFloor.y = j;
	    //set current floor pixel to black
	    ptrColor ->x = 0;
	    ptrColor ->y = 0;
	    ptrColor ->z = 0;
	    ptrColor->w = 255; // opaque
	    // iterate through spheres
	    for (int i = 0; i < nbSphere; i++)
		{
		Sphere currentSphere = ptrDevTabSphere[i];
		float hcarre = currentSphere.hCarre(xyFloor);

		//if the currentSphere is above the current pixel at xyFloor
		if(currentSphere.isEnDessous(hcarre))
		    {
		    float dz = currentSphere.dz(hcarre);
		    float dist = currentSphere.distance(dz);
		    //if it's the closest sphere to the pixel, set the color
		    if (dist < min)
			{
			min = dist;
			hueMin = currentSphere.hue(t);
			brightnessMin = currentSphere.brightness(dz);
			}
		    }
		}
	    //apply new color to pixel if the pixel is underneath a sphere
	    if ( hueMin > 0)
		{
		ColorTools::HSB_TO_RVB(hueMin,1.f,brightnessMin, ptrColor); // update color
		}
	    }

    private:

	/*--------------------------------------*\
	|*		Attributs		*|
	 \*-------------------------------------*/

    private:

	// Tools
	//input
	Sphere* ptrDevTabSphere;
	int nbSphere;

    };

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
