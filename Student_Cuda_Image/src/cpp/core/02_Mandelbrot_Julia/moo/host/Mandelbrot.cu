#include "Mandelbrot.h"

#include <iostream>

using std::cout;
using std::endl;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/

extern __global__ void mandelbrot(uchar4* ptrDevPixels,uint w, uint h,float t);

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

Mandelbrot::Mandelbrot(const Grid& grid, uint w, uint h, float dt) :
	Animable_I<uchar4>(grid, w, h, "Mandelbrot_CUDA_rgba_uchar4")
    {
    // Input
    this->dt = dt;  // animation

    // Tools
    this->t = 0;					// protected dans super classe Animable
    }

Mandelbrot::~Mandelbrot(void)
    {
    // rien
    }

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

/**
 * Override
 */
void Mandelbrot::animationStep()
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
void Mandelbrot::process(uchar4* ptrDevPixels, uint w, uint h, const DomaineMath& domaineMath)
    {
    Device::lastCudaError("mandelbrot rgba uchar4 (before)"); // facultatif, for debug only, remove for release

    mandelbrot<<<dg,db>>>(ptrDevPixels,w,h,t);

    Device::lastCudaError("mandelbrot rgba uchar4 (after)"); // facultatif, for debug only, remove for release
    }

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

