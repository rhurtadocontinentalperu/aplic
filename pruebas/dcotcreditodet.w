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
&Scoped-define INTERNAL-TABLES FacDPedi Almmmatg

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  AftIgv AftIsc CanPed CodCia CodCli CodDiv CodDoc codmat Factor FchPed~
 FlgEst ImpDto ImpDto2 ImpIgv ImpIsc ImpLin MrgUti NroItm NroPed Pesmat~
 PorDto PorDto2 PreBas PreUni UndVta TipVta canate Por_Dsctos1 Por_Dsctos2~
 Por_Dsctos3 Libre_c05
&Scoped-define ENABLED-FIELDS-IN-FacDPedi AftIgv AftIsc CanPed CodCia ~
CodCli CodDiv CodDoc codmat Factor FchPed FlgEst ImpDto ImpDto2 ImpIgv ~
ImpIsc ImpLin MrgUti NroItm NroPed Pesmat PorDto PorDto2 PreBas PreUni ~
UndVta TipVta canate Por_Dsctos1 Por_Dsctos2 Por_Dsctos3 Libre_c05 
&Scoped-Define DATA-FIELDS  AftIgv AftIsc CanPed CodCia CodCli CodDiv CodDoc codmat Factor FchPed~
 FlgEst ImpDto ImpDto2 ImpIgv ImpIsc ImpLin MrgUti NroItm NroPed Pesmat~
 PorDto PorDto2 PreBas PreUni UndVta DesMat DesMar TipVta canate Por_Dsctos1~
 Por_Dsctos2 Por_Dsctos3 Libre_c05
&Scoped-define DATA-FIELDS-IN-FacDPedi AftIgv AftIsc CanPed CodCia CodCli ~
CodDiv CodDoc codmat Factor FchPed FlgEst ImpDto ImpDto2 ImpIgv ImpIsc ~
ImpLin MrgUti NroItm NroPed Pesmat PorDto PorDto2 PreBas PreUni UndVta ~
TipVta canate Por_Dsctos1 Por_Dsctos2 Por_Dsctos3 Libre_c05 
&Scoped-define DATA-FIELDS-IN-Almmmatg DesMat DesMar 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST   rowObject.Por_Dsctos1 = FacDPedi.Por_Dsctos[1]~
  rowObject.Por_Dsctos2 = FacDPedi.Por_Dsctos[2]~
  rowObject.Por_Dsctos3 = FacDPedi.Por_Dsctos[3]
&Scoped-Define DATA-FIELD-DEFS "pruebas/dcotcreditodet.i"
&Scoped-Define DATA-TABLE-NO-UNDO NO-UNDO
&Scoped-define QUERY-STRING-Query-Main FOR EACH FacDPedi NO-LOCK, ~
      EACH Almmmatg OF FacDPedi NO-LOCK INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH FacDPedi NO-LOCK, ~
      EACH Almmmatg OF FacDPedi NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main FacDPedi Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main FacDPedi
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main Almmmatg


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      FacDPedi, 
      Almmmatg SCROLLING.
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
     _TblList          = "INTEGRAL.FacDPedi,INTEGRAL.Almmmatg OF INTEGRAL.FacDPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > INTEGRAL.FacDPedi.AftIgv
"AftIgv" "AftIgv" ? ? "logical" ? ? ? ? ? ? yes ? no 4.43 yes ?
     _FldNameList[2]   > INTEGRAL.FacDPedi.AftIsc
"AftIsc" "AftIsc" ? ? "logical" ? ? ? ? ? ? yes ? no 4.29 yes ?
     _FldNameList[3]   > INTEGRAL.FacDPedi.CanPed
"CanPed" "CanPed" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.29 yes ?
     _FldNameList[4]   > INTEGRAL.FacDPedi.CodCia
"CodCia" "CodCia" ? ? "integer" ? ? ? ? ? ? yes ? no 3 yes ?
     _FldNameList[5]   > INTEGRAL.FacDPedi.CodCli
"CodCli" "CodCli" ? ? "character" ? ? ? ? ? ? yes ? no 8 yes ?
     _FldNameList[6]   > INTEGRAL.FacDPedi.CodDiv
"CodDiv" "CodDiv" ? ? "character" ? ? ? ? ? ? yes ? no 6.86 yes ?
     _FldNameList[7]   > INTEGRAL.FacDPedi.CodDoc
"CodDoc" "CodDoc" ? ? "character" ? ? ? ? ? ? yes ? no 6.29 yes ?
     _FldNameList[8]   > INTEGRAL.FacDPedi.codmat
"codmat" "codmat" ? ? "character" ? ? ? ? ? ? yes ? no 13 yes ?
     _FldNameList[9]   > INTEGRAL.FacDPedi.Factor
"Factor" "Factor" ? ? "decimal" ? ? ? ? ? ? yes ? no 9.86 yes ?
     _FldNameList[10]   > INTEGRAL.FacDPedi.FchPed
"FchPed" "FchPed" ? ? "date" ? ? ? ? ? ? yes ? no 9.14 yes ?
     _FldNameList[11]   > INTEGRAL.FacDPedi.FlgEst
"FlgEst" "FlgEst" ? ? "character" ? ? ? ? ? ? yes ? no 5.43 yes ?
     _FldNameList[12]   > INTEGRAL.FacDPedi.ImpDto
"ImpDto" "ImpDto" ? ? "decimal" ? ? ? ? ? ? yes ? no 16.14 yes ?
     _FldNameList[13]   > INTEGRAL.FacDPedi.ImpDto2
"ImpDto2" "ImpDto2" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.86 yes ?
     _FldNameList[14]   > INTEGRAL.FacDPedi.ImpIgv
"ImpIgv" "ImpIgv" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.29 yes ?
     _FldNameList[15]   > INTEGRAL.FacDPedi.ImpIsc
"ImpIsc" "ImpIsc" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.29 yes ?
     _FldNameList[16]   > INTEGRAL.FacDPedi.ImpLin
"ImpLin" "ImpLin" ? ? "decimal" ? ? ? ? ? ? yes ? no 11.86 yes ?
     _FldNameList[17]   > INTEGRAL.FacDPedi.MrgUti
"MrgUti" "MrgUti" ? ? "decimal" ? ? ? ? ? ? yes ? no 16.29 yes ?
     _FldNameList[18]   > INTEGRAL.FacDPedi.NroItm
"NroItm" "NroItm" ? ? "integer" ? ? ? ? ? ? yes ? no 6.57 yes ?
     _FldNameList[19]   > INTEGRAL.FacDPedi.NroPed
"NroPed" "NroPed" ? ? "character" ? ? ? ? ? ? yes ? no 12 yes ?
     _FldNameList[20]   > INTEGRAL.FacDPedi.Pesmat
"Pesmat" "Pesmat" ? ? "decimal" ? ? ? ? ? ? yes ? no 10.43 yes ?
     _FldNameList[21]   > INTEGRAL.FacDPedi.PorDto
"PorDto" "PorDto" ? ? "decimal" ? ? ? ? ? ? yes ? no 7.57 yes ?
     _FldNameList[22]   > INTEGRAL.FacDPedi.PorDto2
"PorDto2" "PorDto2" ? ? "decimal" ? ? ? ? ? ? yes ? no 7.57 yes ?
     _FldNameList[23]   > INTEGRAL.FacDPedi.PreBas
"PreBas" "PreBas" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.29 yes ?
     _FldNameList[24]   > INTEGRAL.FacDPedi.PreUni
"PreUni" "PreUni" ? ? "decimal" ? ? ? ? ? ? yes ? no 13.29 yes ?
     _FldNameList[25]   > INTEGRAL.FacDPedi.UndVta
"UndVta" "UndVta" ? ? "character" ? ? ? ? ? ? yes ? no 8 yes ?
     _FldNameList[26]   > INTEGRAL.Almmmatg.DesMat
"DesMat" "DesMat" ? ? "character" ? ? ? ? ? ? no ? no 45 yes ?
     _FldNameList[27]   > INTEGRAL.Almmmatg.DesMar
"DesMar" "DesMar" ? ? "character" ? ? ? ? ? ? no ? no 30 yes ?
     _FldNameList[28]   > INTEGRAL.FacDPedi.TipVta
"TipVta" "TipVta" ? ? "character" ? ? ? ? ? ? yes ? no 9.43 yes ?
     _FldNameList[29]   > INTEGRAL.FacDPedi.canate
"canate" "canate" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.29 yes ?
     _FldNameList[30]   > INTEGRAL.FacDPedi.Por_Dsctos[1]
"Por_Dsctos[1]" "Por_Dsctos1" ? ? "decimal" ? ? ? ? ? ? yes ? no 7.14 yes ?
     _FldNameList[31]   > INTEGRAL.FacDPedi.Por_Dsctos[2]
"Por_Dsctos[2]" "Por_Dsctos2" ? ? "decimal" ? ? ? ? ? ? yes ? no 7.14 yes ?
     _FldNameList[32]   > INTEGRAL.FacDPedi.Por_Dsctos[3]
"Por_Dsctos[3]" "Por_Dsctos3" ? ? "decimal" ? ? ? ? ? ? yes ? no 7.14 yes ?
     _FldNameList[33]   > INTEGRAL.FacDPedi.Libre_c05
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

