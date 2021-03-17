#include "mex.h"
#include "Math.h"
#include <string.h>

int dims[2],mrows,ncols,IntegerPart,DecimalPart,factor,NumberSize=11,i;
double value,Remaining,toto;
char TempString[200],EmptyString[200],OutputString[200];

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

    if (!mxIsCell(prhs[0]))
    {
        mexErrMsgTxt("Input must be a cell matrix.");
    }

    
	mrows = mxGetM(prhs[0]);
    ncols = mxGetN(prhs[0]);

	dims[0]=mrows;
	dims[1]=ncols;
	plhs[0]=mxCreateCellArray(2, dims);

	sprintf(EmptyString,"");
	while ((int) strlen(EmptyString)<NumberSize) strcat(EmptyString,"-");
	
	for (int indexColumn=0;indexColumn<ncols;indexColumn++)
	{
		int indexRow0=0;
		while ((!mxGetCell(prhs[0],indexColumn*mrows+indexRow0))&&(indexRow0<mrows)) //case where some fields are empty
		{
			mxSetCell(plhs[0],indexColumn*mrows+indexRow0,mxCreateString(EmptyString));
			indexRow0++;
		}
        if (indexRow0<mrows) //to handle the case where the column is full by NULL values
        {
            if (mxIsNumeric(mxGetCell(prhs[0],indexColumn*mrows+indexRow0)))
            {
    			for (int indexRow=indexRow0;indexRow<mrows;indexRow++)
    			{
                    if (mxGetCell(prhs[0],indexColumn*mrows+indexRow))
                    {
                        value=mxGetScalar(mxGetCell(prhs[0],indexColumn*mrows+indexRow));
                        //convert value to decimal notation
                        sprintf(TempString,"%f",value);
                       //Remove 0 and . at the end of the string
                        unsigned int i=1;
                        while ((TempString[strlen(TempString)-i]=='0')&&(i<strlen(TempString))) TempString[strlen(TempString)-i++]=' ';
                        if (TempString[strlen(TempString)-i]=='.') TempString[strlen(TempString)-i]=' ';
    
            			//Arrange itself to have the string with the good size
                        if (strlen(TempString)<NumberSize)
                            while ((int) strlen(TempString)<NumberSize) strcat(TempString," ");
    
                    strncpy(OutputString,TempString,NumberSize);
    
                    	mxSetCell(plhs[0],indexColumn*mrows+indexRow,mxCreateString(OutputString));
                    }
                else
                    {
                        mxSetCell(plhs[0],indexColumn*mrows+indexRow,mxCreateString(EmptyString));
                    }
                }
            }
            else
            {
    			for (int indexRow=indexRow0;indexRow<mrows;indexRow++)
    			{
    				mxArray* tempCell=mxGetCell(prhs[0],indexColumn*mrows+indexRow);
    				int buflen = (mxGetM(tempCell) * mxGetN(tempCell) * sizeof(mxChar)) + 1;
    				mxGetString(tempCell, TempString, buflen);
    				mxSetCell(plhs[0],indexColumn*mrows+indexRow,mxCreateString(TempString));
    			};
    		}
        }
	}
		
}