#pragma once

#include <math.h>
#include "MathTools.h"
#include "Calibreur_GPU.h"

#include "ColorTools_GPU.h"
using namespace gpu;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

class MandelbrotMath
    {
	/*--------------------------------------*\
	|*		Constructeur		*|
	 \*-------------------------------------*/

    public:

	__device__ MandelbrotMath(uint N):
	    calibreur(Interval<float>(0, n), Interval<float>(0, 1))
	    {
	    this->n = n;
	    }

	// constructeur copie: pas besoin car pas attribut ptr
	__device__
	virtual ~MandelbrotMath(void)
	    {
	    // rien
	    }

	/*--------------------------------------*\
	|*		Methode			*|
	 \*-------------------------------------*/

    public:
	__device__
	void colorXY(uchar4 *ptrColor, float x, float y, float t)
	    {
	    float k = getK(x, y);
	    if(k > this->n)
	    {
		ptrColor->x = 0;
		ptrColor->y = 0;
		ptrColor->z = 0;
	    }else
		{
		float hue = k;
		calibreur.calibrer(hue);
		ColorTools::HSB_TO_RVB(hue, ptrColor);
		}
		ptrColor->w = 255;
	    }

    private:
	__device__
	bool isDivergente(float z)
	    {
	    //If ||z(k)||² > 2² for k -> [0,N] then its diverging
	    return z > 2.f ? true : false;
	    }

	__device__
	int getK(float x, float y)
	    {
	    float zr = 0.f;
	    float zi = 0.f;
	    float old_zr;
	    int k = 0;
	    while(k <= this->n)
		{
		if (isDivergente(norm(zr, zi)))
			return k;

		old_zr = zr;
		zr = pow(zr, 2) - pow(zi, 2) + x;
		zi = 2 * old_zr * zi + y;

		k++;
		}
	    return k;
	    }

	__device__
	float norm(float a, float b)
	    {
	    return sqrt(pow(a, 2) + pow(b, 2));
	    }

	/*--------------------------------------*\
	|*		Attribut			*|
	 \*-------------------------------------*/

    private:

	// Input
	uint n;

	//Tools
	Calibreur<float> calibreur;

    };

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
