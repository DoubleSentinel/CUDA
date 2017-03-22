#include "RayTracing.h"

#include <iostream>
#include <assert.h>

#include "Device.h"
#include "SphereCreator.h"

using std::cout;
using std::endl;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/

extern __global__ void rayTracing(uchar4* ptrDevPixels,int nbspheres, Sphere* ptrDevTabSphere,uint w, uint h,float t);

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

/*-------------------------*\
 |*	Constructeur	    *|
 \*-------------------------*/

RayTracing::RayTracing(const Grid& grid, uint w, uint h, float dt) :
	Animable_I<uchar4>(grid, w, h, "RayTracing_Cuda_Luy")
    {
    // Time
    this->dt = dt;

    // Inputs
    this->t = 0; // protected dans Animable
    this->nbSphere = 2;
    this->sizeOctet = sizeof(Sphere)*nbSphere;
    SphereCreator sphereCreator(nbSphere, w, h);
    Sphere* ptrTabSphere = sphereCreator.getTabSphere();
    // MM
	{
	Device::malloc(&ptrDevTabSphere, sizeOctet);
	Device::memclear(ptrDevTabSphere, sizeOctet);
	Device::memcpyHToD(ptrDevTabSphere, ptrTabSphere, sizeOctet);
	}
    }

RayTracing::~RayTracing()
    {
    Device::free(ptrDevTabSphere);
    }

/*-------------------------*\
 |*	Methode		    *|
 \*-------------------------*/

/**
 * Override
 * Call periodicly by the API
 *
 * Note : domaineMath pas use car pas zoomable
 */
void RayTracing::process(uchar4* ptrDevPixels, uint w, uint h, const DomaineMath& domaineMath)
    {
    Device::lastCudaError("rayTracing rgba uchar4 (before)"); // facultatif, for debug only, remove for release

    rayTracing<<<dg,db>>>(ptrDevPixels, this->nbSphere, this->ptrDevTabSphere,w,h,t);

    Device::lastCudaError("rayTracing rgba uchar4 (after)"); // facultatif, for debug only, remove for release
    }

/**
 * Override
 * Call periodicly by the API
 */
void RayTracing::animationStep()
    {
    t += dt;
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

