#include <iostream>
#include "Device.h"
#include "RayTracing.h"
#include <assert.h>

using std::cout;
using std::endl;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/

extern __global__ void raytracing(uchar4* ptrDevPixels,uint w, uint h,float t, int nbSphere, Sphere* ptrDevTabSphere);


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

    // Inputs
    this->dt = dt;

    // Tools
    this->t = 0; // protected dans Animable

    // Tools
    this->nbSphere = 10;
    this->sizeOctet = sizeof(Sphere)*nbSphere;
    SphereCreator sphereCreator = SphereCreator(nbSphere, w, h);
    Sphere* ptrTabSphere = sphereCreator.getTabSphere();

    this->toGM(ptrTabSphere);
    }

RayTracing::~RayTracing()
    {
    //MM free memory
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
    Device::lastCudaError("RayTracing rgba uchar4 (before kernel)"); // facultatif, for debug only, remove for release

    raytracing<<<dg,db>>>(ptrDevPixels,w,h,t,this->nbSphere, this->ptrDevTabSphere);

    Device::lastCudaError("RayTracing rgba uchar4 (after kernel)"); // facultatif, for debug only, remove for release
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
void RayTracing::toGM(Sphere* ptrTabSphere)
    {
    // MM (malloc/memclear Device)
    	{
    	Device::malloc(&ptrDevTabSphere, sizeOctet);
    	Device::memclear(ptrDevTabSphere, sizeOctet);
    	}

    // MM (copy Host->Device)
    	{
    	Device::memcpyHToD(ptrDevTabSphere, ptrTabSphere, sizeOctet);
    	}
    }
void RayTracing::toCM(Sphere* ptrTabSphere)
    {
    return;
    }
void RayTracing::toSM(Sphere* ptrTabSphere)
    {
    return;
    }
/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

