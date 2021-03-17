/* ------------------------------------------------------------
   File Name:   test1.c
   Author:      John M. Boone, Ph.D.
   Date:        Sep-3-1997
   Description: Test output for GENSPEC1.C, the TASMIP spectrum code
------------------------------------------------------------ */

#include "stdio.h"
#include "math.h"
#include "stdlib.h"
#include "dos.h"

main()
{
	FILE *pt;
	float kv,almm,ripple,spec[200];
	int i,ikv;
/* ---------------------------------------------------
	Query for input values
--------------------------------------------------- */
	printf("Enter kV           :   ");
	scanf("%f",&kv );
	printf("Enter added Al (mm): ");
	scanf("%f",&almm );
	printf("Enter ripple (%%)   : ");
	scanf("%f",&ripple );

/* ---------------------------------------------------
	Generate spectrum
--------------------------------------------------- */
	genspec1( kv,almm,ripple,spec );
/* ---------------------------------------------------
	Output spectrum to file
--------------------------------------------------- */
	pt = fopen( "spectrum.dat","w");
	ikv = kv + 3.0;
	for( i=0; i<=(ikv); ++i ) {
		fprintf(pt,"%3d  %e\n",i,spec[i] );
		}
	fclose(pt);
/* ---------------------------------------------------
	Say Goodbye
--------------------------------------------------- */
	printf("\n\nProgram TEST1 End\n\n");
	exit(0);
}
