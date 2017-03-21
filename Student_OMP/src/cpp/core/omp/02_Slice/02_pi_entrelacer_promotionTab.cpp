#include <omp.h>
#include "OmpTools.h"
#include "../02_Slice/00_pi_tools.h"

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/


/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool isPiOMPEntrelacerPromotionTab_Ok(int n);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

static double piOMPEntrelacerPromotionTab(int n);

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool isPiOMPEntrelacerPromotionTab_Ok(int n)
    {
    return isAlgoPI_OK(piOMPEntrelacerPromotionTab,  n, "Pi OMP Entrelacer promotionTab");
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/**
 * pattern cuda : excellent!
 */
double piOMPEntrelacerPromotionTab(int n)
    {
    const int NB_THREAD = OmpTools::setAndGetNaturalGranularity();
    const double DX=1.0/(double)n;
    double tabSum[NB_THREAD];
    #pragma omp parallel
	{
	const int TID = OmpTools::getTid();
	int s = TID;
	tabSum[TID]=0;
	while(s<n)
	    {
	    double xs = s*DX;
	    tabSum[TID]+=fpi(xs);
	    s+=NB_THREAD;
	    }

	}
     //sequential redux
	double sum = 0;
	for(int i=0;i<NB_THREAD;i++)
	    {
		sum += tabSum[i];
	    }

    return sum*DX;
    }

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

