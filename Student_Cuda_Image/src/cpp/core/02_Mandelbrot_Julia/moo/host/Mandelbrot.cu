#include "Mandelbrot.h"
#include "DomaineMath_CPU.h"
#include <iostream>

using std::cout;
using std::endl;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/

extern __global__ void mandelbrot(uchar4* ptrDevPixels,uint w, uint h,float t, DomaineMath domaineMath);

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

Mandelbrot::Mandelbrot(const Grid& grid, uint w, uint h, float t, uint n, const DomaineMath &domaineMath) :
	Animable_I<uchar4>(grid, w, h, "Mandelbrot_CUDA_Luy", domaineMath),
	variateurAnimation(Interval<uint>(5, 250), t)
    {
    // Inputs
    this->n = n;

    // Tools
    this->t = 0;
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
    this->t = variateurAnimation.varierAndGet();
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

    mandelbrot<<<dg,db>>>(ptrDevPixels,w,h,this->t,domaineMath);

    Device::lastCudaError("mandelbrot rgba uchar4 (after)"); // facultatif, for debug only, remove for release
    }

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

