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

class MandelbrotMath
    {
	/*--------------------------------------*\
	|*		Constructeur		*|
	 \*-------------------------------------*/

    public:

	__device__ MandelbrotMath(uint N)
	    {
	    this->N = N;
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
	void colorIJ(uchar4* ptrColorIJ, int i, int j, float t)
	    {
	    uchar levelGris;

	    f(j, i, t, &levelGris);

	    ptrColorIJ->x = levelGris;
	    ptrColorIJ->y = levelGris;
	    ptrColorIJ->z = levelGris;

	    ptrColorIJ->w = 255; //opaque
	    }

    private:
	__device__
	void f(int i, int j, float t, uchar* ptrlevelGris)
	    {
	    float valDIJ = 0.0;
	    dij(i, j, &valDIJ);
	    *ptrlevelGris=128+127*(cosf(valDIJ/10 - t/7))/(valDIJ/10 + 1);

	    for(int k = 0; k < this->N; k++)
		{
		//implement unreal suite
		}
	    }
	__device__
	bool isDivergente(float r, float i)
	    {
	    //If ||z(k)||² > 2² for k -> [0,N] then its diverging
	    return (r*r + i*i)*(r*r + i*i) > 4;
	    }

	/*--------------------------------------*\
	|*		Attribut			*|
	 \*-------------------------------------*/

    private:

	// Tools
	int N;

    };

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
