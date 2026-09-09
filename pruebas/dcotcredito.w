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

DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE SHARED VARIABLE s-TpoPed  AS CHAR. 
DEFINE SHARED VARIABLE pCodDiv   AS CHAR.
DEFINE SHARED VARIABLE cl-codcia AS INTEGER.

/*
&SCOPED-DEFINE CONDICION ( FacCPedi.CodCia = S-CODCIA AND ~
                           FacCPedi.CodDiv = S-CODDIV AND ~
                           FacCPedi.CodDoc = S-CODDOC AND ~
                           FacCPedi.TpoPed = s-TpoPed AND ~
                           FacCPedi.Usuario = S-USER-ID AND ~
                           FacCPedi.Libre_C01 = pCodDiv AND ~
                           FacCPedi.NroPed BEGINS STRING(S-NROSER,"999") )

*/

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
&Scoped-define INTERNAL-TABLES FacCPedi

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  Atencion Cmpbnte CodCia CodCli CodDiv CodDoc CodMon CodPos CodVen DirCli~
 FchEnt FchPed fchven FlgEst FlgIgv FmaPgo Glosa LugEnt NomCli NroPed ordcmp~
 RucCli Sede TpoCmb usuario LugEnt2 NroCard Libre_c04 Libre_d01 CodRef~
 NroRef Libre_c01 FaxCli Libre_c02 PorIgv Libre_c05
&Scoped-define ENABLED-FIELDS-IN-FacCPedi Atencion Cmpbnte CodCia CodCli ~
CodDiv CodDoc CodMon CodPos CodVen DirCli FchEnt FchPed fchven FlgEst ~
FlgIgv FmaPgo Glosa LugEnt NomCli NroPed ordcmp RucCli Sede TpoCmb usuario ~
LugEnt2 NroCard Libre_c04 Libre_d01 CodRef NroRef Libre_c01 FaxCli ~
Libre_c02 PorIgv Libre_c05 
&Scoped-Define DATA-FIELDS  Atencion Cmpbnte CodCia CodCli CodDiv CodDoc CodMon CodPos CodVen DirCli~
 FchEnt FchPed fchven FlgEst FlgIgv FmaPgo Glosa LugEnt NomCli NroPed ordcmp~
 RucCli Sede TpoCmb usuario LugEnt2 NroCard Libre_c04 Libre_d01 CodRef~
 NroRef Libre_c01 FaxCli Libre_c02 PorIgv Libre_c05
&Scoped-define DATA-FIELDS-IN-FacCPedi Atencion Cmpbnte CodCia CodCli ~
CodDiv CodDoc CodMon CodPos CodVen DirCli FchEnt FchPed fchven FlgEst ~
FlgIgv FmaPgo Glosa LugEnt NomCli NroPed ordcmp RucCli Sede TpoCmb usuario ~
LugEnt2 NroCard Libre_c04 Libre_d01 CodRef NroRef Libre_c01 FaxCli ~
Libre_c02 PorIgv Libre_c05 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "pruebas/dcotcredito.i"
&Scoped-Define DATA-TABLE-NO-UNDO NO-UNDO
&Scoped-define QUERY-STRING-Query-Main FOR EACH FacCPedi ~
      WHERE FacCPedi.CodCia = 1 ~
 AND FacCPedi.CodDoc = "COT" ~
 AND FacCPedi.CodDiv = "00001" NO-LOCK INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH FacCPedi ~
      WHERE FacCPedi.CodCia = 1 ~
 AND FacCPedi.CodDoc = "COT" ~
 AND FacCPedi.CodDiv = "00001" NO-LOCK INDEXED-REPOSITION.
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
     _Where[1]         = "FacCPedi.CodCia = 1
 AND FacCPedi.CodDoc = ""COT""
 AND FacCPedi.CodDiv = ""00001"""
     _FldNameList[1]   > INTEGRAL.FacCPedi.Atencion
"Atencion" "Atencion" ? ? "character" ? ? ? ? ? ? yes ? no 30 yes ?
     _FldNameList[2]   > INTEGRAL.FacCPedi.Cmpbnte
"Cmpbnte" "Cmpbnte" ? ? "character" ? ? ? ? ? ? yes ? no 16.14 yes ?
     _FldNameList[3]   > INTEGRAL.FacCPedi.CodCia
"CodCia" "CodCia" ? ? "integer" ? ? ? ? ? ? yes ? no 3 yes ?
     _FldNameList[4]   > INTEGRAL.FacCPedi.CodCli
"CodCli" "CodCli" ? ? "character" ? ? ? ? ? ? yes ? no 11 yes ?
     _FldNameList[5]   > INTEGRAL.FacCPedi.CodDiv
"CodDiv" "CodDiv" ? ? "character" ? ? ? ? ? ? yes ? no 6.86 yes ?
     _FldNameList[6]   > INTEGRAL.FacCPedi.CodDoc
"CodDoc" "CodDoc" ? ? "character" ? ? ? ? ? ? yes ? no 6.29 yes ?
     _FldNameList[7]   > INTEGRAL.FacCPedi.CodMon
"CodMon" "CodMon" ? ? "integer" ? ? ? ? ? ? yes ? no 7.14 yes ?
     _FldNameList[8]   > INTEGRAL.FacCPedi.CodPos
"CodPos" "CodPos" ? ? "character" ? ? ? ? ? ? yes ? no 5.43 yes ?
     _FldNameList[9]   > INTEGRAL.FacCPedi.CodVen
"CodVen" "CodVen" ? ? "character" ? ? ? ? ? ? yes ? no 10 yes ?
     _FldNameList[10]   > INTEGRAL.FacCPedi.DirCli
"DirCli" "DirCli" ? ? "character" ? ? ? ? ? ? yes ? no 60 yes ?
     _FldNameList[11]   > INTEGRAL.FacCPedi.FchEnt
"FchEnt" "FchEnt" ? ? "date" ? ? ? ? ? ? yes ? no 12.57 yes ?
     _FldNameList[12]   > INTEGRAL.FacCPedi.FchPed
"FchPed" "FchPed" ? ? "date" ? ? ? ? ? ? yes ? no 9.14 yes ?
     _FldNameList[13]   > INTEGRAL.FacCPedi.fchven
"fchven" "fchven" ? ? "date" ? ? ? ? ? ? yes ? no 16.43 yes ?
     _FldNameList[14]   > INTEGRAL.FacCPedi.FlgEst
"FlgEst" "FlgEst" ? ? "character" ? ? ? ? ? ? yes ? no 6.14 yes ?
     _FldNameList[15]   > INTEGRAL.FacCPedi.FlgIgv
"FlgIgv" "FlgIgv" ? ? "logical" ? ? ? ? ? ? yes ? no 7 yes ?
     _FldNameList[16]   > INTEGRAL.FacCPedi.FmaPgo
"FmaPgo" "FmaPgo" ? ? "character" ? ? ? ? ? ? yes ? no 17.43 yes ?
     _FldNameList[17]   > INTEGRAL.FacCPedi.Glosa
"Glosa" "Glosa" ? ? "character" ? ? ? ? ? ? yes ? no 50 yes ?
     _FldNameList[18]   > INTEGRAL.FacCPedi.LugEnt
"LugEnt" "LugEnt" ? ? "character" ? ? ? ? ? ? yes ? no 60 yes ?
     _FldNameList[19]   > INTEGRAL.FacCPedi.NomCli
"NomCli" "NomCli" ? ? "character" ? ? ? ? ? ? yes ? no 50 yes ?
     _FldNameList[20]   > INTEGRAL.FacCPedi.NroPed
"NroPed" "NroPed" ? ? "character" ? ? ? ? ? ? yes ? no 12 yes ?
     _FldNameList[21]   > INTEGRAL.FacCPedi.ordcmp
"ordcmp" "ordcmp" ? ? "character" ? ? ? ? ? ? yes ? no 15.29 yes ?
     _FldNameList[22]   > INTEGRAL.FacCPedi.RucCli
"RucCli" "RucCli" ? ? "character" ? ? ? ? ? ? yes ? no 11 yes ?
     _FldNameList[23]   > INTEGRAL.FacCPedi.Sede
"Sede" "Sede" ? ? "character" ? ? ? ? ? ? yes ? no 5 yes ?
     _FldNameList[24]   > INTEGRAL.FacCPedi.TpoCmb
"TpoCmb" "TpoCmb" ? ? "decimal" ? ? ? ? ? ? yes ? no 13.57 yes ?
     _FldNameList[25]   > INTEGRAL.FacCPedi.usuario
"usuario" "usuario" ? ? "character" ? ? ? ? ? ? yes ? no 10 yes ?
     _FldNameList[26]   > INTEGRAL.FacCPedi.LugEnt2
"LugEnt2" "LugEnt2" ? ? "character" ? ? ? ? ? ? yes ? no 60 yes ?
     _FldNameList[27]   > INTEGRAL.FacCPedi.NroCard
"NroCard" "NroCard" ? ? "character" ? ? ? ? ? ? yes ? no 8 yes ?
     _FldNameList[28]   > INTEGRAL.FacCPedi.Libre_c04
"Libre_c04" "Libre_c04" ? ? "character" ? ? ? ? ? ? yes ? no 60 yes ?
     _FldNameList[29]   > INTEGRAL.FacCPedi.Libre_d01
"Libre_d01" "Libre_d01" ? ? "decimal" ? ? ? ? ? ? yes ? no 15.86 yes ?
     _FldNameList[30]   > INTEGRAL.FacCPedi.CodRef
"CodRef" "CodRef" ? ? "character" ? ? ? ? ? ? yes ? no 9.43 yes ?
     _FldNameList[31]   > INTEGRAL.FacCPedi.NroRef
"NroRef" "NroRef" ? ? "character" ? ? ? ? ? ? yes ? no 12.86 yes ?
     _FldNameList[32]   > INTEGRAL.FacCPedi.Libre_c01
"Libre_c01" "Libre_c01" ? ? "character" ? ? ? ? ? ? yes ? no 60 yes ?
     _FldNameList[33]   > INTEGRAL.FacCPedi.FaxCli
"FaxCli" "FaxCli" ? ? "character" ? ? ? ? ? ? yes ? no 13 yes ?
     _FldNameList[34]   > INTEGRAL.FacCPedi.Libre_c02
"Libre_c02" "Libre_c02" ? ? "character" ? ? ? ? ? ? yes ? no 60 yes ?
     _FldNameList[35]   > INTEGRAL.FacCPedi.PorIgv
"PorIgv" "PorIgv" ? ? "decimal" ? ? ? ? ? ? yes ? no 6.57 yes ?
     _FldNameList[36]   > INTEGRAL.FacCPedi.Libre_c05
"Libre_c05" "Libre_c05" ? ? "character" ? ? ? ? ? ? yes ? no 60 yes ?
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

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beginTransactionValidate dTables  _DB-REQUIRED
PROCEDURE beginTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Faccpedi THEN MESSAGE 'beginTransactionValidate:' faccpedi.coddoc faccpedi.nroped.
  ELSE MESSAGE 'beginTransactionValidate'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endTransactionValidate dTables  _DB-REQUIRED
PROCEDURE endTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Faccpedi THEN MESSAGE 'endTransactionValidate:' faccpedi.coddoc faccpedi.nroped.
  ELSE MESSAGE 'endTransactionValidate'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject dTables  _DB-REQUIRED
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  DYNAMIC-FUNCTION('setQueryWhere':U IN THIS-PROCEDURE, ~
                   'FOR EACH FacCPedi ~
                   WHERE FacCPedi.CodCia = ' + STRING(s-codcia) + ~
                   ' AND FacCPedi.CodDoc = "' + s-coddoc + '"' + ~
                   ' AND FacCPedi.CodDiv = "' + STRING(s-coddiv, '99999') + '"').
                                            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

