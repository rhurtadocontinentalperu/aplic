&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedi.



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
&Scoped-define INTERNAL-TABLES ITEM Almmmatg

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  AftIgv AftIsc CanPed CodCia CodCli CodDiv CodDoc codmat Factor FchPed~
 FlgEst Hora ImpDto ImpDto2 ImpIgv ImpIsc ImpLin Libre_c05 MrgUti NroItm~
 NroPed PorDto PorDto2 Por_Dsctos1 Por_Dsctos2 Por_Dsctos3 PreBas PreUni~
 PreVta1 PreVta2 PreVta3 UndVta CanApr
&Scoped-define ENABLED-FIELDS-IN-ITEM AftIgv AftIsc CanPed CodCia CodCli ~
CodDiv CodDoc codmat Factor FchPed FlgEst Hora ImpDto ImpDto2 ImpIgv ImpIsc ~
ImpLin Libre_c05 MrgUti NroItm NroPed PorDto PorDto2 Por_Dsctos1 ~
Por_Dsctos2 Por_Dsctos3 PreBas PreUni PreVta1 PreVta2 PreVta3 UndVta CanApr 
&Scoped-Define DATA-FIELDS  AftIgv AftIsc CanPed CodCia CodCli CodDiv CodDoc codmat Factor FchPed~
 FlgEst Hora ImpDto ImpDto2 ImpIgv ImpIsc ImpLin Libre_c05 MrgUti NroItm~
 NroPed PorDto PorDto2 Por_Dsctos1 Por_Dsctos2 Por_Dsctos3 PreBas PreUni~
 PreVta1 PreVta2 PreVta3 UndVta CanApr DesMat DesMar
&Scoped-define DATA-FIELDS-IN-ITEM AftIgv AftIsc CanPed CodCia CodCli ~
CodDiv CodDoc codmat Factor FchPed FlgEst Hora ImpDto ImpDto2 ImpIgv ImpIsc ~
ImpLin Libre_c05 MrgUti NroItm NroPed PorDto PorDto2 Por_Dsctos1 ~
Por_Dsctos2 Por_Dsctos3 PreBas PreUni PreVta1 PreVta2 PreVta3 UndVta CanApr 
&Scoped-define DATA-FIELDS-IN-Almmmatg DesMat DesMar 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST   rowObject.Por_Dsctos1 = ITEM.Por_Dsctos[1]~
  rowObject.Por_Dsctos2 = ITEM.Por_Dsctos[2]~
  rowObject.Por_Dsctos3 = ITEM.Por_Dsctos[3]~
  rowObject.PreVta1 = ITEM.PreVta[1]  rowObject.PreVta2 = ITEM.PreVta[2]~
  rowObject.PreVta3 = ITEM.PreVta[3]
&Scoped-Define DATA-FIELD-DEFS "pruebas/dtcotcreditodet.i"
&Scoped-Define DATA-TABLE-NO-UNDO NO-UNDO
&Scoped-define QUERY-STRING-Query-Main FOR EACH ITEM NO-LOCK, ~
      EACH Almmmatg OF ITEM NO-LOCK INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH ITEM NO-LOCK, ~
      EACH Almmmatg OF ITEM NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main ITEM Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main ITEM
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
      ITEM, 
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
   Temp-Tables and Buffers:
      TABLE: ITEM T "SHARED" ? INTEGRAL FacDPedi
   END-TABLES.
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
     _TblList          = "Temp-Tables.ITEM,INTEGRAL.Almmmatg OF Temp-Tables.ITEM"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.ITEM.AftIgv
"AftIgv" "AftIgv" ? ? "logical" ? ? ? ? ? ? yes ? no 4.43 no ?
     _FldNameList[2]   > Temp-Tables.ITEM.AftIsc
"AftIsc" "AftIsc" ? ? "logical" ? ? ? ? ? ? yes ? no 4.29 no ?
     _FldNameList[3]   > Temp-Tables.ITEM.CanPed
"CanPed" "CanPed" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.29 no ?
     _FldNameList[4]   > Temp-Tables.ITEM.CodCia
"CodCia" "CodCia" ? ? "integer" ? ? ? ? ? ? yes ? no 3 no ?
     _FldNameList[5]   > Temp-Tables.ITEM.CodCli
"CodCli" "CodCli" ? ? "character" ? ? ? ? ? ? yes ? no 8 no ?
     _FldNameList[6]   > Temp-Tables.ITEM.CodDiv
"CodDiv" "CodDiv" ? ? "character" ? ? ? ? ? ? yes ? no 6.86 no ?
     _FldNameList[7]   > Temp-Tables.ITEM.CodDoc
"CodDoc" "CodDoc" ? ? "character" ? ? ? ? ? ? yes ? no 6.29 no ?
     _FldNameList[8]   > Temp-Tables.ITEM.codmat
"codmat" "codmat" ? "X(14)" "character" ? ? ? ? ? ? yes ? no 14 no ?
     _FldNameList[9]   > Temp-Tables.ITEM.Factor
"Factor" "Factor" ? ? "decimal" ? ? ? ? ? ? yes ? no 9.86 no ?
     _FldNameList[10]   > Temp-Tables.ITEM.FchPed
"FchPed" "FchPed" ? ? "date" ? ? ? ? ? ? yes ? no 9.14 no ?
     _FldNameList[11]   > Temp-Tables.ITEM.FlgEst
"FlgEst" "FlgEst" ? ? "character" ? ? ? ? ? ? yes ? no 5.43 no ?
     _FldNameList[12]   > Temp-Tables.ITEM.Hora
"Hora" "Hora" ? ? "character" ? ? ? ? ? ? yes ? no 5 no ?
     _FldNameList[13]   > Temp-Tables.ITEM.ImpDto
"ImpDto" "ImpDto" ? ? "decimal" ? ? ? ? ? ? yes ? no 16.14 no ?
     _FldNameList[14]   > Temp-Tables.ITEM.ImpDto2
"ImpDto2" "ImpDto2" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.86 no ?
     _FldNameList[15]   > Temp-Tables.ITEM.ImpIgv
"ImpIgv" "ImpIgv" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.29 no ?
     _FldNameList[16]   > Temp-Tables.ITEM.ImpIsc
"ImpIsc" "ImpIsc" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.29 no ?
     _FldNameList[17]   > Temp-Tables.ITEM.ImpLin
"ImpLin" "ImpLin" ? ? "decimal" ? ? ? ? ? ? yes ? no 11.86 no ?
     _FldNameList[18]   > Temp-Tables.ITEM.Libre_c05
"Libre_c05" "Libre_c05" ? ? "character" ? ? ? ? ? ? yes ? no 60 no ?
     _FldNameList[19]   > Temp-Tables.ITEM.MrgUti
"MrgUti" "MrgUti" ? ? "decimal" ? ? ? ? ? ? yes ? no 16.29 no ?
     _FldNameList[20]   > Temp-Tables.ITEM.NroItm
"NroItm" "NroItm" ? ? "integer" ? ? ? ? ? ? yes ? no 6.57 no ?
     _FldNameList[21]   > Temp-Tables.ITEM.NroPed
"NroPed" "NroPed" ? ? "character" ? ? ? ? ? ? yes ? no 12 no ?
     _FldNameList[22]   > Temp-Tables.ITEM.PorDto
"PorDto" "PorDto" ? ? "decimal" ? ? ? ? ? ? yes ? no 7.57 no ?
     _FldNameList[23]   > Temp-Tables.ITEM.PorDto2
"PorDto2" "PorDto2" ? ? "decimal" ? ? ? ? ? ? yes ? no 7.57 no ?
     _FldNameList[24]   > Temp-Tables.ITEM.Por_Dsctos[1]
"Por_Dsctos[1]" "Por_Dsctos1" ? ? "decimal" ? ? ? ? ? ? yes ? no 7.14 no ?
     _FldNameList[25]   > Temp-Tables.ITEM.Por_Dsctos[2]
"Por_Dsctos[2]" "Por_Dsctos2" ? ? "decimal" ? ? ? ? ? ? yes ? no 7.14 no ?
     _FldNameList[26]   > Temp-Tables.ITEM.Por_Dsctos[3]
"Por_Dsctos[3]" "Por_Dsctos3" ? ? "decimal" ? ? ? ? ? ? yes ? no 7.14 no ?
     _FldNameList[27]   > Temp-Tables.ITEM.PreBas
"PreBas" "PreBas" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.29 no ?
     _FldNameList[28]   > Temp-Tables.ITEM.PreUni
"PreUni" "PreUni" ? ? "decimal" ? ? ? ? ? ? yes ? no 13.29 no ?
     _FldNameList[29]   > Temp-Tables.ITEM.PreVta[1]
"PreVta[1]" "PreVta1" ? ? "decimal" ? ? ? ? ? ? yes ? no 11.29 no ?
     _FldNameList[30]   > Temp-Tables.ITEM.PreVta[2]
"PreVta[2]" "PreVta2" ? ? "decimal" ? ? ? ? ? ? yes ? no 11.29 no ?
     _FldNameList[31]   > Temp-Tables.ITEM.PreVta[3]
"PreVta[3]" "PreVta3" ? ? "decimal" ? ? ? ? ? ? yes ? no 11.29 no ?
     _FldNameList[32]   > Temp-Tables.ITEM.UndVta
"UndVta" "UndVta" ? ? "character" ? ? ? ? ? ? yes ? no 8 no ?
     _FldNameList[33]   > Temp-Tables.ITEM.CanApr
"CanApr" "CanApr" ? ? "decimal" ? ? ? ? ? ? yes ? no 16.86 no ?
     _FldNameList[34]   > INTEGRAL.Almmmatg.DesMat
"DesMat" "DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no 60 yes ?
     _FldNameList[35]   > INTEGRAL.Almmmatg.DesMar
"DesMar" "DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no 20 yes "Marca"
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

