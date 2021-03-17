#define _AFXDLL

#include "mex.h"
#include <afxdb.h>
#include <string.h>
#include <math.h>

#pragma comment(lib, "libmx.lib")
#pragma comment(lib, "libmat.lib")
#pragma comment(lib, "libmex.lib")
//#pragma comment(lib, "libmatlb.lib")
//#pragma comment(lib, "libmmfile.lib")


char *DatabaseName,DatabaseOutput[80],*SQLCommand,Command[500],Msg[80],*SQLbeginning;
DWORD DwError;
int dims[2];

//entry point
void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[])
{
	int buflen1,buflen2;
	CDatabase db;
	
		/* Check for proper number of arguments. */
	if ((nrhs != 2)&&(nrhs != 3))
	    mexErrMsgTxt("Two or three input required.");
	  
	/* 2 first Input must be a string. */
	if ((mxIsChar(prhs[0]) != 1)&&(mxIsChar(prhs[1]) != 1))
	    mexErrMsgTxt("Inputs must be strings.");
	
	/* Input must be a row vector. */
	if ((mxGetM(prhs[0]) != 1)&&(mxGetM(prhs[1]) != 1))
	    mexErrMsgTxt("Inputs must be a row vector.");
	    
	/* Get the length of the input string. */
	buflen1 = (mxGetM(prhs[0]) * mxGetN(prhs[0])) + 1;
	buflen2 = (mxGetM(prhs[1]) * mxGetN(prhs[1])) + 1;
	
	/* Allocate memory for input and output strings. */
	DatabaseName = (char *) mxCalloc(buflen1, sizeof(char));
	SQLCommand= (char *) mxCalloc(buflen2, sizeof(char));
	  
	
	/* Copy the string data from prhs[0] into a C string 
	* input_buf. If the string array contains several rows, 
	* they are copied, one column at a time, into one long 
	* string array. */
	mxGetString(prhs[0], DatabaseName, buflen1);
	mxGetString(prhs[1], SQLCommand, buflen2);
	
	strcpy( Command, "DSN=" );
	strcat( Command, DatabaseName );


    try
	{
		db.OpenEx(Command,CDatabase::noOdbcDialog );
	}
	catch (CDBException* e)
	{
		mexErrMsgTxt(e->m_strError );
		db.Close( );
		return;
	}

	
	if (strcmp(SQLCommand,""))
	{

		//test if the SQL command is select type
		char buf[10];
		SQLbeginning=buf;
		strcpy( SQLbeginning, "       " );
		strncpy(SQLbeginning,SQLCommand,6);
		SQLbeginning=_strupr(SQLbeginning);

		if (!strcmp(SQLbeginning,"SELECT "))
		{

			int NRequestedLine=-1;
		if (nrhs==3)
			if (mxIsNumeric(prhs[2]) != 1)
				mexErrMsgTxt("third Inputs must be am integer.");
			else
				NRequestedLine=(int) mxGetScalar(prhs[2]);
	
		
		    // Create and open a recordset object
			// directly from CRecordset. Note that a
			// table must exist in a connected database.
			// Use forwardOnly type recordset for best
			// performance, since only MoveNext is required
			CRecordset rs( &db );
			short nFields;
			int NRecords=0;

			try
			{
#ifdef __MYDEBUG
				time( &ltime );  //////////////////////////////////////////////////////////////////////////////////////
				_ftime( &tstruct );  //////////////////////////////////////////////////////////////////////////////////
				mexPrintf( "milliseconds:%ld %u\n", ltime,tstruct.millitm );  /////////////////////////////////////////
#endif

				rs.Open( CRecordset::forwardOnly,SQLCommand);
				
				nFields = rs.GetODBCFieldCount( );
				if  (!rs.IsEOF( )) 
				{
					while(1)
					{
						NRecords++;
						rs.MoveNext( );
						if  ((rs.IsEOF( )||NRecords==NRequestedLine))     ///////// Remove NRecords==1
							break;
					}
				}
				rs.Close( );				


#ifdef __MYDEBUG
				mexPrintf( "%d ", NRecords);
#endif

			}
			catch( CDBException* e )
			{

				mexErrMsgTxt(e->m_strError );
				rs.Close( );
				db.Close( );
				return;
			}
				
			try
			{
				rs.Open( CRecordset::forwardOnly,SQLCommand);
				nFields = rs.GetODBCFieldCount( );
		
				// Create a CDBVariant object to
				// store field data
				CDBVariant varValue;
				
				// Loop through the recordset,
				// using GetFieldValue and
				// GetODBCFieldCount to retrieve
				// data in all columns
				

				/// Retrieve Names of the columns
				dims[0]=1;
				dims[1]=nFields;
				plhs[1]=mxCreateCellArray(2, dims);
				
				CODBCFieldInfo fieldinfo;
		
				for( short index = 0; index < nFields; index++ )
				{
					rs.GetODBCFieldInfo(index,fieldinfo);
					mxSetCell(plhs[1], index, mxCreateString(fieldinfo.m_strName));
				}	

				// Retrive values
				dims[0]=NRecords;
				dims[1]=nFields;
				plhs[0]=mxCreateCellArray(2, dims);
	
				for( short indexRecord = 0; indexRecord < NRecords; indexRecord++ )
				{
					for( short indexField = 0; indexField < nFields; indexField++ )
					{
						rs.GetFieldValue( indexField, varValue );
						// do something with varValue
						switch (varValue.m_dwType)
							{
							case 4: //integer
								mxSetCell(plhs[0],indexField*NRecords+indexRecord,mxCreateScalarDouble(varValue.m_lVal));
#ifdef __MYDEBUG
								mexPrintf("%d ", varValue.m_lVal);
#endif
								break;
							case 6:   //float
									mxSetCell(plhs[0],indexField*NRecords+indexRecord,mxCreateScalarDouble(varValue.m_dblVal));
#ifdef __MYDEBUG
								mexPrintf("%f ", varValue.m_dblVal);
#endif

									break;
							case 8: //string
								mxSetCell(plhs[0],indexField*NRecords+indexRecord,mxCreateString((LPCTSTR) *varValue.m_pstring));
#ifdef __MYDEBUG
								mexPrintf("%s ", *varValue.m_pstring);
#endif

								break;
							}
					}
#ifdef __MYDEBUG
					mexPrintf("\n");
#endif
					rs.MoveNext( );
				}
				rs.Close( );
			}
			catch( CDBException* e )
			{

				mexErrMsgTxt(e->m_strError );
				rs.Close( );
				db.Close( );
				return;
			}
		}
		else if (!strcmp(SQLbeginning,"BULKIN "))
		{
			if (mxIsCell(prhs[2]) != 1)
				mexErrMsgTxt("third Inputs must be a cell array.");
			char TableName[100],NewSQLCommand[1000],TempString[50];
			strcpy( TableName, SQLCommand+7);
			int RecordNumber=mxGetM(prhs[2]);
			int FieldNumber=mxGetN(prhs[2]);

			for (int indexRecord=0;indexRecord<RecordNumber;indexRecord++)
				{
					sprintf(NewSQLCommand,"insert into %s values(",TableName);
					for (int indexField=0;indexField<FieldNumber;indexField++)
					{
						if (mxIsChar(mxGetCell(prhs[2],indexField*RecordNumber+indexRecord)))
						{
							char *tempString;
							int buflen=(mxGetM(mxGetCell(prhs[2],indexField*RecordNumber+indexRecord)) * mxGetN(mxGetCell(prhs[2],indexField*RecordNumber+indexRecord))) + 1;
							tempString=(char*)malloc(buflen*sizeof(char));
							mxGetString(mxGetCell(prhs[2],indexField*RecordNumber+indexRecord),tempString,buflen);
							sprintf(TempString,"%s",tempString);
							free(tempString);
						}
						else
						{
							if (fabs(((float) ((int) mxGetScalar(mxGetCell(prhs[2],indexField*RecordNumber+indexRecord))))-mxGetScalar(mxGetCell(prhs[2],indexField*RecordNumber+indexRecord)))<0.0001)
								sprintf(TempString,"%d",(int) mxGetScalar(mxGetCell(prhs[2],indexField*RecordNumber+indexRecord)));
							else 
								sprintf(TempString,"%f",(float) mxGetScalar(mxGetCell(prhs[2],indexField*RecordNumber+indexRecord)));
						}
						if (indexField)
							strcat(NewSQLCommand,",");
						strcat(NewSQLCommand,"'");
						strcat(NewSQLCommand,TempString);
						strcat(NewSQLCommand,"'");
					}
					strcat(NewSQLCommand,");");
#ifdef __MYDEBUG
		mexPrintf("%s\n",NewSQLCommand);
#endif
					
					TRY
					{
						db.ExecuteSQL(NewSQLCommand);
					}
					CATCH(CDBException, e)
					{
						mexErrMsgTxt(e->m_strError);
						db.Close( );
						return;
					}
					END_CATCH

				}	
		}
		else  //statement without output;
		{
			TRY
			{
				db.ExecuteSQL(SQLCommand);
			}
			CATCH(CDBException, e)
			{
				mexErrMsgTxt(e->m_strError);
				db.Close( );
				return;
			}
			END_CATCH
		}
	}
	else
#ifdef __MYDEBUG
		mexPrintf("Nothing to do!!! \n");
#endif

	db.Close();
};



