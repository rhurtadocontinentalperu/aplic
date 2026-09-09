&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*------------------------------------------------------------------------

  File:  

  Description: from DATA.W - Template For SmartData objects in the ADM

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Modified:     February 24, 1999
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-codalm AS CHAR.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Global-define DATA-LOGIC-PROCEDURE .p

&Scoped-define PROCEDURE-TYPE SmartDataObject
&Scoped-define DB-AWARE yes

&Scoped-define ADM-SUPPORTED-LINKS Data-Source,Data-Target,Navigation-Target,Update-Target,Commit-Target,Filter-Target


/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF


&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almmmatg Almmmate

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS 
&Scoped-Define DATA-FIELDS  AlmDes CodAlm CodCia codmat CodUbi StkAct CodCia-2 codfam CodMar codmat-2~
 CodPr1 DesMar DesMat TpoArt UndStk subfam FchIng Pesmat
&Scoped-define DATA-FIELDS-IN-Almmmatg CodCia-2 codfam CodMar codmat-2 ~
CodPr1 DesMar DesMat TpoArt UndStk subfam FchIng Pesmat 
&Scoped-define DATA-FIELDS-IN-Almmmate AlmDes CodAlm CodCia codmat CodUbi ~
StkAct 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST   rowObject.CodCia-2 = Almmmatg.CodCia  rowObject.codmat-2 = Almmmatg.codmat
&Scoped-Define DATA-FIELD-DEFS "alm/dmate-matg-p2.i"
&Scoped-Define DATA-TABLE-NO-UNDO NO-UNDO
&Scoped-define QUERY-STRING-Query-Main FOR EACH Almmmatg NO-LOCK, ~
      FIRST Almmmate OF Almmmatg NO-LOCK
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH Almmmatg NO-LOCK, ~
      FIRST Almmmate OF Almmmatg NO-LOCK.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main Almmmatg Almmmate
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main Almmmatg
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main Almmmate


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      Almmmatg, 
      Almmmate SCROLLING.
&ANALYZE-RESUME
{&DB-REQUIRED-END}


/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataObject
   Allow: Query
   Frames: 0
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE APPSERVER DB-AWARE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW dTables ASSIGN
         HEIGHT             = 1.62
         WIDTH              = 46.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB dTables 
/* ************************* Included-Libraries *********************** */

{src/adm2/data.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW dTables
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main
/* Query rebuild information for SmartDataObject Query-Main
     _TblList          = "INTEGRAL.Almmmatg,INTEGRAL.Almmmate OF INTEGRAL.Almmmatg"
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST"
     _FldNameList[1]   > INTEGRAL.Almmmate.AlmDes
"AlmDes" "AlmDes" ? ? "character" ? ? ? ? ? ? no ? no 70 yes ?
     _FldNameList[2]   > INTEGRAL.Almmmate.CodAlm
"CodAlm" "CodAlm" ? ? "character" ? ? ? ? ? ? no ? no 7.57 yes ?
     _FldNameList[3]   > INTEGRAL.Almmmate.CodCia
"CodCia" "CodCia" ? ? "integer" ? ? ? ? ? ? no ? no 3 yes ?
     _FldNameList[4]   > INTEGRAL.Almmmate.codmat
"codmat" "codmat" ? ? "character" ? ? ? ? ? ? no ? no 13 yes ?
     _FldNameList[5]   > INTEGRAL.Almmmate.CodUbi
"CodUbi" "CodUbi" ? ? "character" ? ? ? ? ? ? no ? no 8.72 yes ?
     _FldNameList[6]   > INTEGRAL.Almmmate.StkAct
"StkAct" "StkAct" ? ? "decimal" ? ? ? ? ? ? no ? no 14.57 yes ?
     _FldNameList[7]   > INTEGRAL.Almmmatg.CodCia
"CodCia" "CodCia-2" ? ? "integer" ? ? ? ? ? ? no ? no 3 yes ?
     _FldNameList[8]   > INTEGRAL.Almmmatg.codfam
"codfam" "codfam" ? ? "character" ? ? ? ? ? ? no ? no 6.29 yes ?
     _FldNameList[9]   > INTEGRAL.Almmmatg.CodMar
"CodMar" "CodMar" ? ? "character" ? ? ? ? ? ? no ? no 5.43 yes ?
     _FldNameList[10]   > INTEGRAL.Almmmatg.codmat
"codmat" "codmat-2" ? ? "character" ? ? ? ? ? ? no ? no 13 yes ?
     _FldNameList[11]   > INTEGRAL.Almmmatg.CodPr1
"CodPr1" "CodPr1" ? ? "character" ? ? ? ? ? ? no ? no 16.86 yes ?
     _FldNameList[12]   > INTEGRAL.Almmmatg.DesMar
"DesMar" "DesMar" ? ? "character" ? ? ? ? ? ? no ? no 30 yes ?
     _FldNameList[13]   > INTEGRAL.Almmmatg.DesMat
"DesMat" "DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no 60 yes ?
     _FldNameList[14]   > INTEGRAL.Almmmatg.TpoArt
"TpoArt" "TpoArt" ? ? "character" ? ? ? ? ? ? no ? no 6.14 yes ?
     _FldNameList[15]   > INTEGRAL.Almmmatg.UndStk
"UndStk" "UndStk" ? ? "character" ? ? ? ? ? ? no ? no 14 yes ?
     _FldNameList[16]   > INTEGRAL.Almmmatg.subfam
"subfam" "subfam" ? ? "character" ? ? ? ? ? ? no ? no 10.29 yes ?
     _FldNameList[17]   > INTEGRAL.Almmmatg.FchIng
"FchIng" "FchIng" ? ? "date" ? ? ? ? ? ? no ? no 9.14 yes ?
     _FldNameList[18]   > INTEGRAL.Almmmatg.Pesmat
"Pesmat" "Pesmat" ? ? "decimal" ? ? ? ? ? ? no ? no 10.43 yes ?
     _Design-Parent    is WINDOW dTables @ ( 1.15 , 2.57 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK dTables 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI dTables  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject dTables  _DB-REQUIRED
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

/*   DYNAMIC-FUNCTION('addQueryWhere',                                    */
/*                    "Almmmate.codcia = " + string(s-codcia) + " AND " + */
/*                    "Almmmate.codalm = '" + s-codalm + "'",             */
/*                    "Almmmate",                                         */
/*                    "").                                                */

/*   DYNAMIC-FUNCTION('addQueryWhere',                                    */
/*                    "Almmmatg.codcia = " + STRING(s-codcia) + " AND " + */
/*                    "Almmmatg.codmat = Almmmate.codmat AND " +          */
/*                    "Almmmatg.tpoart = 'A'",                            */
/*                    "Almmmatg",                                         */
/*                    ""                                                  */
/*                    ).                                                  */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

