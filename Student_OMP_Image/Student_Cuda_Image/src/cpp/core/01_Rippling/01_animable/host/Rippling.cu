#include "Rippling.h"

#include <iostream>

using std::cout;
using std::endl;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/

extern __global__ void rippling(uchar4* ptrDevPixels,uint w, uint h,float t);

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

Rippling::Rippling(const Grid& grid, uint w, uint h, float dt) :
	Animable_I<uchar4>(grid, w, h, "Rippling_CUDA_rgba_uchar4")
    {
    // Input
    this->dt = dt;  // animation

    // Tools
    this->t = 0;					// protected dans super classe Animable
    }

Rippling::~Rippling(void)
    {
    // rien
    }

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

/**
 * Override
 */
void Rippling::animationStep()
    {
    t += dt;
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/**
 * Override (code naturel omp)
 * Image non zoomable : domaineMath pas use ici
 */
void Rippling::process(uchar4* ptrDevPixels, uint w, uint h, const DomaineMath& domaineMath)
    {
    Device::lastCudaError("rippling rgba uchar4 (before)"); // facultatif, for debug only, remove for release

    rippling<<<dg,db>>>(ptrDevPixels,w,h,t);

    Device::lastCudaError("rippling rgba uchar4 (after)"); // facultatif, for debug only, remove for release
    }

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

