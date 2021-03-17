//Lionel HERVE
//3-5-04 add skipped analysis

#define _AFXDLL

#include "mex.h"
#include <string.h>
#include <afx.h>

void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[])
{
	int s1,Index, buflen;
	char buf[100];
    
	/* Check for proper number of arguments. */
	if (nrhs != 1)
	    mexErrMsgTxt("One input expected.");
	plhs[0]=mxDuplicateArray(prhs[0]);  //content matrix

    s1=mxGetM(prhs[0]);  //size content
    buflen = (mxGetM(mxGetCell(prhs[0], 0)) * mxGetN(mxGetCell(prhs[0], 0)) * sizeof(mxChar)) + 1;
	for (Index=0;Index<s1;Index++)
	{
       	 mxGetString(mxGetCell(prhs[0], Index),buf,buflen);
         _strupr(buf);
         mxSetCell(plhs[0], Index, mxCreateString(buf));
	}
}
