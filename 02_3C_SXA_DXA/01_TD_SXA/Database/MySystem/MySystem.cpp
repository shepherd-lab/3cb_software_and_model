#include "Matlab.h"
#include <windows.h>

#pragma comment(lib, "libmx.lib")
#pragma comment(lib, "libmat.lib")
#pragma comment(lib, "libmex.lib")
#pragma comment(lib, "libmatlb.lib")

//return TRUE if n is a prime number


void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[])
{
    if (nrhs != 1) 
    {
        mexErrMsgTxt("One input required.");
    } 
    else if (nlhs > 1) 
    {
        mexErrMsgTxt("Too many output arguments");
    }    

    /* The input must be a string*/
    if (!mxIsChar(prhs[0])) 
    {
        mexErrMsgTxt("Input must be a string");
    }


	char *tempString;
	int buflen= mxGetM(prhs[0]) * mxGetN(prhs[0]) + 1;
	tempString=(char*)malloc(buflen*sizeof(char));
	mxGetString(prhs[0],tempString,buflen);
	system(tempString);
	free(tempString);

}