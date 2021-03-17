//Lionel HERVE
//3-5-04 add skipped analysis

#define _AFXDLL

#include "mex.h"
#include <string.h>
#include <afx.h>

char* Month[12]={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
char* tempString="  ";

long convertStringDate2DAteID(char* Date)
{
	int year, month=0,day,dash1=0,dash2=0;
	long DateID;
	char DayString[20]="           ",MonthString[20]="            ",YearString[20]="          ";
	
	//find first '-'
	while (Date[dash1]!='-') dash1++;
	dash2=dash1+1;
	while (Date[dash2]!='-') dash2++;

	strncpy( DayString, Date, dash1 );day=atoi(DayString); 
	strncpy( MonthString, Date+dash1+1, 3 ); 
	while ((strncmp(MonthString,Month[month],3))&&(month!=11)) month++; 
	strncpy( YearString, Date+dash2+1 ,4 );year=atoi(YearString); 

		DateID=year*372+month*31+day;
	return DateID;
}

void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[])
{
	int s1,s2,so1,SearchIndex,i,year,month,day,buflen,Index;
	long DateID,*DateNum;
	char StringDay[10]="         ",StringYear[10]="        ",StringMonth[10]="         ";
	CString StringDate;
	char* Date;
	mxArray* temp;
	Date=(char*)malloc(50*sizeof(char));

	/* Check for proper number of arguments. */
	if ((nrhs != 3)&&(nrhs != 4))
	    mexErrMsgTxt("three or four inputs required.");
	plhs[0]=mxDuplicateArray(prhs[0]);  //content matrix
		
	s1=mxGetM(prhs[1]);s2=mxGetN(prhs[1]);  //content2
	so1=mxGetM(prhs[0]);  //size content
	

	DateNum=(long*) malloc(so1*sizeof(long));
	for (i=0;i<so1;i++)
		DateNum[i]=-1;
	int indexColumn=(int) mxGetScalar(prhs[2]);


	//put -2 for skipped analysis
	if (nrhs==4)
	{
		int s3=mxGetM(prhs[3]);
		for (i=0;i<s3;i++)
		{
			Index=(int) mxGetScalar(mxGetCell(prhs[3], i)); 
	
			// find the right index in content
			SearchIndex=0;
			while (((int) mxGetScalar(mxGetCell(prhs[0], SearchIndex))!=Index)&&(SearchIndex<so1)) 
			{
				SearchIndex++;
			}
				
			if (SearchIndex!=so1)
				{
					DateNum[SearchIndex]=-2;
				}
		}
	}
	
	
	// compute the biggest date for each acquisition
	for (i=0;i<s1;i++)
	{
		temp=mxGetCell(prhs[1], i+s1);
		buflen = mxGetN(temp) + 1;
		mxGetString(temp,Date ,buflen); //mexPrintf("%s ",Date);
		DateID=convertStringDate2DAteID(Date);

		Index=(int) mxGetScalar(mxGetCell(prhs[1], i)); 

		// find the right index in content
		SearchIndex=0;

		while (((int) mxGetScalar(mxGetCell(prhs[0], SearchIndex))!=Index)&&(SearchIndex<so1)) 
		{
			SearchIndex++;
		}
			
		if (SearchIndex!=so1)
			if ((DateNum[SearchIndex]<DateID)&&(DateNum[SearchIndex]!=-2))
			{
				DateNum[SearchIndex]=DateID;
			}
	}
	
    // write the date in the output tabular
    for (i=0;i<so1;i++)
	{
     	// covert datevec to dateID=year*372+Month*31+day
		if (DateNum[i]==-1)
		{                       
            StringDate=CString("NULL       ");
		}
		else if (DateNum[i]==-2)
		{
			StringDate=CString("SKIPPED    ");
		}
		
		else
		{
			year=(DateNum[i]-1)/372; 
			month=(DateNum[i]-1-year*372)/31; 
			day=(DateNum[i]-1)-year*372-month*31+1;
			itoa(day,StringDay,10);
            if ((int) strlen(StringDay)==1)
            {
                strcpy(tempString,"0");
                strcat(tempString,StringDay);
                strcpy(StringDay,tempString);
            }   
			strcpy(StringMonth,Month[month]); 
			itoa(year,StringYear,10);
			StringDate=CString(StringDay)+CString("-")+CString(StringMonth)+CString("-")+CString(StringYear);
		}
		mxSetCell(plhs[0],so1*(indexColumn-1)+i,mxCreateString((LPCTSTR) StringDate));
	}
	free(DateNum);
	free(Date);

	
}
