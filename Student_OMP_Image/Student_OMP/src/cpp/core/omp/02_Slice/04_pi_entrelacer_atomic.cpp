#include <omp.h>
#include <OmpTools.h>

#include "00_pi_tools.h"

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool isPiOMPEntrelacerAtomic_Ok(int n);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

static double piOMPEntrelacerAtomic(int n);

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool isPiOMPEntrelacerAtomic_Ok(int n)
    {
    return isAlgoPI_OK(piOMPEntrelacerAtomic, n, "Pi OMP Entrelacer atomic");
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/**
 * Bonne performance, si!
 */
double piOMPEntrelacerAtomic(int n)
    {
    const int NB_THREAD = OmpTools::setAndGetNaturalGranularity();
    const double DX = 1.0 / (double) n;
    double sum = 0;
    #pragma omp parallel
	{
	const int TID = OmpTools::getTid();
	int s = TID;
	double localSum = 0;

	while (s < n)
	    {
	    double xs = s * DX;
	    localSum += fpi(xs);
	    s += NB_THREAD;
	    }

	#pragma omp atomic
	sum += localSum;
	}

    return sum * DX;
    }

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

