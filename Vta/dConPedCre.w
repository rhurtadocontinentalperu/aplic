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

/* Local Variable Definitions ---                                       */

&glob DATA-LOGIC-PROCEDURE .p

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

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
&Scoped-define INTERNAL-TABLES FacCPedi

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS 
&Scoped-Define DATA-FIELDS  CodCia CodDiv CodDoc NroPed CodCli NomCli FchPed fchven FchEnt~
 FchAprobacion FlgEst FlgSit ImpTot CodMon CodVen FmaPgo usuario
&Scoped-define DATA-FIELDS-IN-FacCPedi CodCia CodDiv CodDoc NroPed CodCli ~
NomCli FchPed fchven FchEnt FchAprobacion FlgEst FlgSit ImpTot CodMon ~
CodVen FmaPgo usuario 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "dConPedCre.i"
&Scoped-Define DATA-TABLE-NO-UNDO NO-UNDO
&Scoped-define QUERY-STRING-Query-Main FOR EACH FacCPedi NO-LOCK INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH FacCPedi NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main FacCPedi


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      FacCPedi SCROLLING.
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
     _TblList          = "INTEGRAL.FacCPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > INTEGRAL.FacCPedi.CodCia
"CodCia" "CodCia" ? ? "integer" ? ? ? ? ? ? no ? no 3 yes ?
     _FldNameList[2]   > INTEGRAL.FacCPedi.CodDiv
"CodDiv" "CodDiv" ? ? "character" ? ? ? ? ? ? no ? no 6.86 yes ?
     _FldNameList[3]   > INTEGRAL.FacCPedi.CodDoc
"CodDoc" "CodDoc" ? ? "character" ? ? ? ? ? ? no ? no 6.29 yes ?
     _FldNameList[4]   > INTEGRAL.FacCPedi.NroPed
"NroPed" "NroPed" ? ? "character" ? ? ? ? ? ? no ? no 9.72 yes ?
     _FldNameList[5]   > INTEGRAL.FacCPedi.CodCli
"CodCli" "CodCli" ? ? "character" ? ? ? ? ? ? no ? no 11 yes ?
     _FldNameList[6]   > INTEGRAL.FacCPedi.NomCli
"NomCli" "NomCli" ? ? "character" ? ? ? ? ? ? no ? no 50 yes ?
     _FldNameList[7]   > INTEGRAL.FacCPedi.FchPed
"FchPed" "FchPed" ? ? "date" ? ? ? ? ? ? no ? no 9.14 yes ?
     _FldNameList[8]   > INTEGRAL.FacCPedi.fchven
"fchven" "fchven" ? ? "date" ? ? ? ? ? ? no ? no 16.43 yes ?
     _FldNameList[9]   > INTEGRAL.FacCPedi.FchEnt
"FchEnt" "FchEnt" ? ? "date" ? ? ? ? ? ? no ? no 12.57 yes ?
     _FldNameList[10]   > INTEGRAL.FacCPedi.FchAprobacion
"FchAprobacion" "FchAprobacion" ? ? "date" ? ? ? ? ? ? no ? no 13.14 yes ?
     _FldNameList[11]   > INTEGRAL.FacCPedi.FlgEst
"FlgEst" "FlgEst" ? ? "character" ? ? ? ? ? ? no ? no 6.14 yes ?
     _FldNameList[12]   > INTEGRAL.FacCPedi.FlgSit
"FlgSit" "FlgSit" ? ? "character" ? ? ? ? ? ? no ? no 8 yes ?
     _FldNameList[13]   > INTEGRAL.FacCPedi.ImpTot
"ImpTot" "ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no 11.86 yes ?
     _FldNameList[14]   > INTEGRAL.FacCPedi.CodMon
"CodMon" "CodMon" ? ? "integer" ? ? ? ? ? ? no ? no 7.14 yes ?
     _FldNameList[15]   > INTEGRAL.FacCPedi.CodVen
"CodVen" "CodVen" ? ? "character" ? ? ? ? ? ? no ? no 10 yes ?
     _FldNameList[16]   > INTEGRAL.FacCPedi.FmaPgo
"FmaPgo" "FmaPgo" ? ? "character" ? ? ? ? ? ? no ? no 17.43 yes ?
     _FldNameList[17]   > INTEGRAL.FacCPedi.usuario
"usuario" "usuario" ? ? "character" ? ? ? ? ? ? no ? no 10 yes ?
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

