&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}

/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF



/* Temp-Table and Buffer definitions                                    */
{&DB-REQUIRED-START}
 DEFINE BUFFER B-CDOCU FOR CcbCDocu.
{&DB-REQUIRED-END}
DEFINE TEMP-TABLE DETA NO-UNDO LIKE CcbDDocu.
DEFINE TEMP-TABLE t-FELogErrores NO-UNDO LIKE FELogErrores.



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
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-CndCre AS CHAR.
DEF SHARED VAR s-TpoFac AS CHAR.
DEF SHARED VAR s-Tipo   AS CHAR.
DEF SHARED VAR s-NroSer AS INTE.
DEF SHARED VAR lh_handle AS HANDLE.

DEFINE SHARED VARIABLE S-PORIGV AS DEC. 
DEFINE SHARED VARIABLE S-PORDTO AS DEC.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE s-NRODEV       AS ROWID.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).
  
DEFINE VARIABLE pMensaje AS CHAR NO-UNDO.

DEF VAR s-ClienteGenerico AS CHAR INIT '11111111111' NO-UNDO.

FIND FIRST FacCfgGn  WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
IF AVAILABLE FacCfgGn THEN s-ClienteGenerico = FacCfgGn.CliVar.

DEF VAR x-Estado AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Global-define DATA-LOGIC-PROCEDURE .p

&Scoped-define PROCEDURE-TYPE SmartDataObject
&Scoped-define DB-AWARE yes

&Scoped-define ADM-SUPPORTED-LINKS Data-Source,Data-Target,Navigation-Target,Update-Target,Commit-Target,Filter-Target


/* Note that Db-Required is defined before the buffer definitions for this object. */

&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCDocu

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  CodAnt CodCli CodCta CodMon CodRef DirCli FchAnu FchDoc FchVto FmaPgo Glosa~
 NomCli NroDoc NroOrd NroPed NroRef RucCli UsuAnu usuario CodCia CodDiv~
 CodDoc FlgEst PorIgv PorDto TpoCmb Cndcre TpoFac Tipo SdoAct CodAlm CodMov~
 CodVen ImpTot CCo ImpIgv ImpIsc ImpBrt ImpDto ImpDto2 ImpExo ImpVta imptot2~
 Libre_d02 Dcto_Otros_VV AcuBon1 AcuBon2 AcuBon3 AcuBon4 AcuBon5 AcuBon6~
 AcuBon7 AcuBon8 AcuBon9 AcuBon10 TotalVenta TotalIGV TotalMontoICBPER~
 TotalValorVentaNetoOpGravadas
&Scoped-define ENABLED-FIELDS-IN-CcbCDocu CodAnt CodCli CodCta CodMon ~
CodRef DirCli FchAnu FchDoc FchVto FmaPgo Glosa NomCli NroDoc NroOrd NroPed ~
NroRef RucCli UsuAnu usuario CodCia CodDiv CodDoc FlgEst PorIgv PorDto ~
TpoCmb Cndcre TpoFac Tipo SdoAct CodAlm CodMov CodVen ImpTot CCo ImpIgv ~
ImpIsc ImpBrt ImpDto ImpDto2 ImpExo ImpVta imptot2 Libre_d02 Dcto_Otros_VV ~
AcuBon1 AcuBon2 AcuBon3 AcuBon4 AcuBon5 AcuBon6 AcuBon7 AcuBon8 AcuBon9 ~
AcuBon10 TotalVenta TotalIGV TotalMontoICBPER TotalValorVentaNetoOpGravadas 
&Scoped-Define DATA-FIELDS  CodAnt CodCli CodCta CodMon CodRef DirCli FchAnu FchDoc FchVto FmaPgo Glosa~
 NomCli NroDoc NroOrd NroPed NroRef RucCli UsuAnu usuario CodCia CodDiv~
 CodDoc FlgEst PorIgv PorDto TpoCmb Cndcre TpoFac Tipo SdoAct CodAlm CodMov~
 CodVen ImpTot CCo ImpIgv ImpIsc ImpBrt ImpDto ImpDto2 ImpExo ImpVta imptot2~
 Libre_d02 Dcto_Otros_VV AcuBon1 AcuBon2 AcuBon3 AcuBon4 AcuBon5 AcuBon6~
 AcuBon7 AcuBon8 AcuBon9 AcuBon10 TotalVenta TotalIGV TotalMontoICBPER~
 TotalValorVentaNetoOpGravadas cEstado
&Scoped-define DATA-FIELDS-IN-CcbCDocu CodAnt CodCli CodCta CodMon CodRef ~
DirCli FchAnu FchDoc FchVto FmaPgo Glosa NomCli NroDoc NroOrd NroPed NroRef ~
RucCli UsuAnu usuario CodCia CodDiv CodDoc FlgEst PorIgv PorDto TpoCmb ~
Cndcre TpoFac Tipo SdoAct CodAlm CodMov CodVen ImpTot CCo ImpIgv ImpIsc ~
ImpBrt ImpDto ImpDto2 ImpExo ImpVta imptot2 Libre_d02 Dcto_Otros_VV AcuBon1 ~
AcuBon2 AcuBon3 AcuBon4 AcuBon5 AcuBon6 AcuBon7 AcuBon8 AcuBon9 AcuBon10 ~
TotalVenta TotalIGV TotalMontoICBPER TotalValorVentaNetoOpGravadas 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST   rowObject.AcuBon1 = CcbCDocu.AcuBon[1]~
  rowObject.AcuBon2 = CcbCDocu.AcuBon[2]~
  rowObject.AcuBon3 = CcbCDocu.AcuBon[3]~
  rowObject.AcuBon4 = CcbCDocu.AcuBon[4]~
  rowObject.AcuBon5 = CcbCDocu.AcuBon[5]~
  rowObject.AcuBon6 = CcbCDocu.AcuBon[6]~
  rowObject.AcuBon7 = CcbCDocu.AcuBon[7]~
  rowObject.AcuBon8 = CcbCDocu.AcuBon[8]~
  rowObject.AcuBon9 = CcbCDocu.AcuBon[9]~
  rowObject.AcuBon10 = CcbCDocu.AcuBon[10]
&Scoped-Define DATA-FIELD-DEFS "ccb/dccbcdocu.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH CcbCDocu NO-LOCK INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH CcbCDocu NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main CcbCDocu


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado dTables  _DB-REQUIRED
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pEstado AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}


/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      CcbCDocu SCROLLING.
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
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: DETA T "?" NO-UNDO INTEGRAL CcbDDocu
      TABLE: t-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
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
     _TblList          = "INTEGRAL.CcbCDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > INTEGRAL.CcbCDocu.CodAnt
"CodAnt" "CodAnt" "DNI" "X(15)" "character" ? ? ? ? ? ? yes ? no 15 yes "DNI"
     _FldNameList[2]   > INTEGRAL.CcbCDocu.CodCli
"CodCli" "CodCli" ? ? "character" ? ? ? ? ? ? yes ? no 11 yes ?
     _FldNameList[3]   > INTEGRAL.CcbCDocu.CodCta
"CodCta" "CodCta" "Concepto" ? "character" ? ? ? ? ? ? yes ? no 14.14 yes ""
     _FldNameList[4]   > INTEGRAL.CcbCDocu.CodMon
"CodMon" "CodMon" ? ? "integer" ? ? ? ? ? ? yes ? no 7.14 yes ?
     _FldNameList[5]   > INTEGRAL.CcbCDocu.CodRef
"CodRef" "CodRef" ? ? "character" ? ? ? ? ? ? yes ? no 6.29 yes ?
     _FldNameList[6]   > INTEGRAL.CcbCDocu.DirCli
"DirCli" "DirCli" ? "x(100)" "character" ? ? ? ? ? ? yes ? no 100 yes ?
     _FldNameList[7]   > INTEGRAL.CcbCDocu.FchAnu
"FchAnu" "FchAnu" ? ? "date" ? ? ? ? ? ? yes ? no 7.14 yes ?
     _FldNameList[8]   > INTEGRAL.CcbCDocu.FchDoc
"FchDoc" "FchDoc" ? ? "date" ? ? ? ? ? ? yes ? no 9.14 yes ?
     _FldNameList[9]   > INTEGRAL.CcbCDocu.FchVto
"FchVto" "FchVto" ? ? "date" ? ? ? ? ? ? yes ? no 18.86 yes ?
     _FldNameList[10]   > INTEGRAL.CcbCDocu.FmaPgo
"FmaPgo" "FmaPgo" ? ? "character" ? ? ? ? ? ? yes ? no 17.43 yes ?
     _FldNameList[11]   > INTEGRAL.CcbCDocu.Glosa
"Glosa" "Glosa" ? "x(80)" "character" ? ? ? ? ? ? yes ? no 80 yes ?
     _FldNameList[12]   > INTEGRAL.CcbCDocu.NomCli
"NomCli" "NomCli" ? "x(100)" "character" ? ? ? ? ? ? yes ? no 100 yes ?
     _FldNameList[13]   > INTEGRAL.CcbCDocu.NroDoc
"NroDoc" "NroDoc" ? "X(15)" "character" ? ? ? ? ? ? yes ? no 15 yes ?
     _FldNameList[14]   > INTEGRAL.CcbCDocu.NroOrd
"NroOrd" "NroOrd" ? "x(15)" "character" ? ? ? ? ? ? yes ? no 15.29 yes ?
     _FldNameList[15]   > INTEGRAL.CcbCDocu.NroPed
"NroPed" "NroPed" ? "X(15)" "character" ? ? ? ? ? ? yes ? no 15 yes ?
     _FldNameList[16]   > INTEGRAL.CcbCDocu.NroRef
"NroRef" "NroRef" ? ? "character" ? ? ? ? ? ? yes ? no 12 yes ?
     _FldNameList[17]   > INTEGRAL.CcbCDocu.RucCli
"RucCli" "RucCli" ? ? "character" ? ? ? ? ? ? yes ? no 11 yes ?
     _FldNameList[18]   > INTEGRAL.CcbCDocu.UsuAnu
"UsuAnu" "UsuAnu" ? ? "character" ? ? ? ? ? ? yes ? no 10 yes ?
     _FldNameList[19]   > INTEGRAL.CcbCDocu.usuario
"usuario" "usuario" ? ? "character" ? ? ? ? ? ? yes ? no 10 yes ?
     _FldNameList[20]   > INTEGRAL.CcbCDocu.CodCia
"CodCia" "CodCia" ? ? "integer" ? ? ? ? ? ? yes ? no 3 yes ?
     _FldNameList[21]   > INTEGRAL.CcbCDocu.CodDiv
"CodDiv" "CodDiv" ? ? "character" ? ? ? ? ? ? yes ? no 5 yes ?
     _FldNameList[22]   > INTEGRAL.CcbCDocu.CodDoc
"CodDoc" "CodDoc" ? ? "character" ? ? ? ? ? ? yes ? no 6.29 yes ?
     _FldNameList[23]   > INTEGRAL.CcbCDocu.FlgEst
"FlgEst" "FlgEst" ? ? "character" ? ? ? ? ? ? yes ? no 6.14 yes ?
     _FldNameList[24]   > INTEGRAL.CcbCDocu.PorIgv
"PorIgv" "PorIgv" ? ? "decimal" ? ? ? ? ? ? yes ? no 6.57 yes ?
     _FldNameList[25]   > INTEGRAL.CcbCDocu.PorDto
"PorDto" "PorDto" ? ? "decimal" ? ? ? ? ? ? yes ? no 7.57 yes ?
     _FldNameList[26]   > INTEGRAL.CcbCDocu.TpoCmb
"TpoCmb" "TpoCmb" ? ? "decimal" ? ? ? ? ? ? yes ? no 13.57 yes ?
     _FldNameList[27]   > INTEGRAL.CcbCDocu.Cndcre
"Cndcre" "Cndcre" ? ? "character" ? ? ? ? ? ? yes ? no 17.86 yes ?
     _FldNameList[28]   > INTEGRAL.CcbCDocu.TpoFac
"TpoFac" "TpoFac" ? ? "character" ? ? ? ? ? ? yes ? no 4 yes ?
     _FldNameList[29]   > INTEGRAL.CcbCDocu.Tipo
"Tipo" "Tipo" ? ? "character" ? ? ? ? ? ? yes ? no 20 yes ?
     _FldNameList[30]   > INTEGRAL.CcbCDocu.SdoAct
"SdoAct" "SdoAct" ? ? "decimal" ? ? ? ? ? ? yes ? no 11.86 yes ?
     _FldNameList[31]   > INTEGRAL.CcbCDocu.CodAlm
"CodAlm" "CodAlm" ? ? "character" ? ? ? ? ? ? yes ? no 7.57 yes ?
     _FldNameList[32]   > INTEGRAL.CcbCDocu.CodMov
"CodMov" "CodMov" ? ? "integer" ? ? ? ? ? ? yes ? no 19.29 yes ?
     _FldNameList[33]   > INTEGRAL.CcbCDocu.CodVen
"CodVen" "CodVen" ? ? "character" ? ? ? ? ? ? yes ? no 10 yes ?
     _FldNameList[34]   > INTEGRAL.CcbCDocu.ImpTot
"ImpTot" "ImpTot" ? ? "decimal" ? ? ? ? ? ? yes ? no 11.86 yes ?
     _FldNameList[35]   > INTEGRAL.CcbCDocu.CCo
"CCo" "CCo" ? ? "character" ? ? ? ? ? ? yes ? no 13.72 yes ?
     _FldNameList[36]   > INTEGRAL.CcbCDocu.ImpIgv
"ImpIgv" "ImpIgv" ? ? "decimal" ? ? ? ? ? ? yes ? no 11.86 yes ?
     _FldNameList[37]   > INTEGRAL.CcbCDocu.ImpIsc
"ImpIsc" "ImpIsc" ? ? "decimal" ? ? ? ? ? ? yes ? no 11.86 yes ?
     _FldNameList[38]   > INTEGRAL.CcbCDocu.ImpBrt
"ImpBrt" "ImpBrt" ? ? "decimal" ? ? ? ? ? ? yes ? no 11.86 yes ?
     _FldNameList[39]   > INTEGRAL.CcbCDocu.ImpDto
"ImpDto" "ImpDto" ? ? "decimal" ? ? ? ? ? ? yes ? no 16.14 yes ?
     _FldNameList[40]   > INTEGRAL.CcbCDocu.ImpDto2
"ImpDto2" "ImpDto2" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.86 yes ?
     _FldNameList[41]   > INTEGRAL.CcbCDocu.ImpExo
"ImpExo" "ImpExo" ? ? "decimal" ? ? ? ? ? ? yes ? no 16.29 yes ?
     _FldNameList[42]   > INTEGRAL.CcbCDocu.ImpVta
"ImpVta" "ImpVta" ? ? "decimal" ? ? ? ? ? ? yes ? no 11.86 yes ?
     _FldNameList[43]   > INTEGRAL.CcbCDocu.imptot2
"imptot2" "imptot2" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.86 yes ?
     _FldNameList[44]   > INTEGRAL.CcbCDocu.Libre_d02
"Libre_d02" "Libre_d02" ? ? "decimal" ? ? ? ? ? ? yes ? no 15.86 yes ?
     _FldNameList[45]   > INTEGRAL.CcbCDocu.Dcto_Otros_VV
"Dcto_Otros_VV" "Dcto_Otros_VV" ? ? "decimal" ? ? ? ? ? ? yes ? no 16.86 yes ?
     _FldNameList[46]   > INTEGRAL.CcbCDocu.AcuBon[1]
"AcuBon[1]" "AcuBon1" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.86 yes ?
     _FldNameList[47]   > INTEGRAL.CcbCDocu.AcuBon[2]
"AcuBon[2]" "AcuBon2" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.86 yes ?
     _FldNameList[48]   > INTEGRAL.CcbCDocu.AcuBon[3]
"AcuBon[3]" "AcuBon3" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.86 yes ?
     _FldNameList[49]   > INTEGRAL.CcbCDocu.AcuBon[4]
"AcuBon[4]" "AcuBon4" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.86 yes ?
     _FldNameList[50]   > INTEGRAL.CcbCDocu.AcuBon[5]
"AcuBon[5]" "AcuBon5" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.86 yes ?
     _FldNameList[51]   > INTEGRAL.CcbCDocu.AcuBon[6]
"AcuBon[6]" "AcuBon6" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.86 yes ?
     _FldNameList[52]   > INTEGRAL.CcbCDocu.AcuBon[7]
"AcuBon[7]" "AcuBon7" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.86 yes ?
     _FldNameList[53]   > INTEGRAL.CcbCDocu.AcuBon[8]
"AcuBon[8]" "AcuBon8" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.86 yes ?
     _FldNameList[54]   > INTEGRAL.CcbCDocu.AcuBon[9]
"AcuBon[9]" "AcuBon9" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.86 yes ?
     _FldNameList[55]   > INTEGRAL.CcbCDocu.AcuBon[10]
"AcuBon[10]" "AcuBon10" ? ? "decimal" ? ? ? ? ? ? yes ? no 12.86 yes ?
     _FldNameList[56]   > INTEGRAL.CcbCDocu.TotalVenta
"TotalVenta" "TotalVenta" ? ? "decimal" ? ? ? ? ? ? yes ? no 14.43 yes ?
     _FldNameList[57]   > INTEGRAL.CcbCDocu.TotalIGV
"TotalIGV" "TotalIGV" ? ? "decimal" ? ? ? ? ? ? yes ? no 14.43 yes ?
     _FldNameList[58]   > INTEGRAL.CcbCDocu.TotalMontoICBPER
"TotalMontoICBPER" "TotalMontoICBPER" ? ? "decimal" ? ? ? ? ? ? yes ? no 16.72 yes ?
     _FldNameList[59]   > INTEGRAL.CcbCDocu.TotalValorVentaNetoOpGravadas
"TotalValorVentaNetoOpGravadas" "TotalValorVentaNetoOpGravadas" ? ? "decimal" ? ? ? ? ? ? yes ? no 29.29 yes ?
     _FldNameList[60]   > "_<CALC>"
"fEstado(RowObject.FlgEst)" "cEstado" ? "x(8)" "character" ? ? ? ? ? ? no ? no 8 no ?
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

  /* ********************************************************* */
  /* Code placed here will execute PRIOR to standard behavior. */
  /* ********************************************************* */
  DEF VAR pCuenta AS INTE NO-UNDO.

  /* RHC 22/11/2016  Bloqueamos de todas maneras el movimiento de almacén */
  FIND Almcmov WHERE ROWID(Almcmov) = s-NRODEV  EXCLUSIVE-LOCK NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN 'Movimiento de Ingreso al Almacén en uso por otro usuario'.
  IF Almcmov.FlgEst <> "P" 
      THEN RETURN 'Movimiento de Ingreso al Almacén ha sido modificado por otro usuario' + CHR(10) + 'Proceso Abortado'.
  
  /* Bloqueamos Correlativo */
  {lib/lock-genericov3.i ~
      &Tabla="FacCorre" ~
      &Condicion="FacCorre.CodCia = s-codcia ~
      AND FacCorre.CodDiv = s-coddiv ~
      AND FacCorre.CodDoc = s-coddoc ~
      AND FacCorre.NroSer = s-nroser" ~
      &Bloqueo="EXCLUSIVE-LOCK" ~
      &Accion="RETRY" ~
      &Mensaje="NO" ~
      &txtMensaje="pMensaje" ~
      &TipoError="RETURN pMensaje" ~
      }
      /* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */

  ASSIGN 
      RowObjUpd.NroDoc = STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) + STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')) 
      RowObjUpd.FchDoc = TODAY
      RowObjUpd.FchVto = ADD-INTERVAL (TODAY, 1, 'years')
      RowObjUpd.FlgEst = "P"
      RowObjUpd.PorIgv = s-PorIgv
      RowObjUpd.PorDto = S-PORDTO
      RowObjUpd.TpoCmb = FacCfgGn.TpoCmb[1]
      RowObjUpd.CndCre = s-CndCre     /* POR DEVOLUCION */
      RowObjUpd.TpoFac = s-TpoFac
      RowObjUpd.Tipo   = s-Tipo
      /*RowObjUpd.CodCaja= s-CodTer*/
      RowObjUpd.usuario = S-USER-ID
      RowObjUpd.SdoAct = RowObjUpd.Imptot
      NO-ERROR.
  IF ERROR-STATUS:ERROR = YES THEN DO:
      {lib/mensaje-de-error.i &MensajeError="pMensaje"}
      RETURN pMensaje.
  END.
  ASSIGN 
      FacCorre.Correlativo = FacCorre.Correlativo + 1.
  RELEASE FacCorre.

  ASSIGN 
      RowObjUpd.CodAlm = Almcmov.CodAlm
      RowObjUpd.CodMov = Almcmov.CodMov
      RowObjUpd.CodVen = Almcmov.CodVen
      .
  /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
  FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia
      AND B-CDOCU.coddoc = RowObjUpd.codref
      AND B-CDOCU.nrodoc = RowObjUpd.nroref 
      NO-LOCK NO-ERROR.
  IF AVAILABLE B-CDOCU THEN DO:
      FIND GN-VEN WHERE gn-ven.codcia = s-codcia
          AND gn-ven.codven = B-CDOCU.codven
          NO-LOCK NO-ERROR.
      IF AVAILABLE GN-VEN THEN RowObjUpd.cco = gn-ven.cco.
  END.
  

  /* ********************************************************* */
  RUN SUPER.
  /* ********************************************************* */

  /* ********************************************************* */
  /* Code placed here will execute AFTER standard behavior.    */
  /* ********************************************************* */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE commitTransaction dTables  _DB-REQUIRED
PROCEDURE commitTransaction :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  /*
  /* if any error occurred, pass this back down the procedure chain */  
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN ERROR RETURN-VALUE.        
  /* Otherwise send notification to refresh data */                    
  PUBLISH "dataAvailable" ("DIFFERENT").  
  */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DATA.CALCULATE dTables  DATA.CALCULATE _DB-REQUIRED
PROCEDURE DATA.CALCULATE :
/*------------------------------------------------------------------------------
  Purpose:     Calculate all the Calculated Expressions found in the
               SmartDataObject.
  Parameters:  <none>
------------------------------------------------------------------------------*/
      ASSIGN 
         rowObject.cEstado = (fEstado(RowObject.FlgEst))
      .

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

  DEF VAR pCuenta AS INTE NO-UNDO.

  /* Control de Aprobación de N/C */
  RUN lib/LogTabla ("Ccbcdocu", Ccbcdocu.coddoc + ',' + Ccbcdocu.nrodoc, "APROBADO").
  /* **************************** */

  RUN Genera-Detalle.   

  RUN Graba-Totales (OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      pMensaje = "ERROR GRABACION TOTALES: " + CHR(10) + pMensaje.
      RETURN pMensaje.
  END.

  RUN sunat/sunat-calculo-importes-ccbcdocu.r (INPUT Ccbcdocu.CodDiv,
                                               INPUT Ccbcdocu.CodDoc,
                                               INPUT Ccbcdocu.NroDoc,
                                               OUTPUT pMensaje).
  IF pMensaje <> "OK" THEN DO:
      pMensaje = "ERROR CALCULO SUNAT: " + pMensaje.
      RETURN pMensaje.
  END.

  RUN vta2/actualiza-cot-por-devolucion (ROWID(Ccbcdocu), -1).
  IF RETURN-VALUE = "ADM-ERROR" THEN DO:
      pMensaje = "NO se pudo actualizar la cotización" + CHR(10) +
                "Proceso Abortado".
      RETURN pMensaje.
  END.
  /* *******************************************************************************
    Ic - 24Ago2020, Correo de Julissa del 21 de Agosto del 2020
        Al momento que el area de credito genere la NCI, y referencie el FAI, EN AUTOMÁTICO quedarán liquidados ambos documentos,
        Con esta nueva operativa minimizamos el tiempo en las liquidaciones        
  ****************************************************************************** */
   DEFINE VAR hProc AS HANDLE NO-UNDO.          /* Handle Libreria */
   DEFINE VAR cRetVal AS CHAR.

   RUN ccb\libreria-ccb.r PERSISTENT SET hProc.

   /* Procedimientos */
   RUN CCB_Aplica-NCI IN hProc (INPUT CcbCDocu.coddoc, INPUT CcbCDocu.nrodoc, OUTPUT cRetVal).   
   
   DELETE PROCEDURE hProc.                      /* Release Libreria */

   IF cRetVal > "" THEN RETURN "Hubo problemas en la grabación " + CHR(10) + cRetval.
  /* ********************************************************************** */
  /* RHC 17/07/17 OJO: Hay una condición de error en el trigger w-almcmov.p */
  /* ********************************************************************** */
  ASSIGN 
      Almcmov.FlgEst = "C" NO-ERROR.
  
  RELEASE Almcmov.  /* Forzamos la ejecución del Trigger WRITE */
  IF ERROR-STATUS:ERROR THEN DO:
      {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
      RETURN pMensaje.
  END.
  /* ********************************************************************** */

  /* ************************************************** */
  /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
  RUN sunat\progress-to-ppll-v3  ( INPUT Ccbcdocu.coddiv,
                                   INPUT Ccbcdocu.coddoc,
                                   INPUT Ccbcdocu.nrodoc,
                                   INPUT-OUTPUT TABLE T-FELogErrores,
                                   OUTPUT pMensaje ).
  IF RETURN-VALUE = "ADM-ERROR" THEN DO:
      pMensaje = "ERROR SUNAT:" + CHR(10) + pMensaje.
      RETURN pMensaje.
  END.
  IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
      /* NO se pudo confirmar el comprobante en el e-pos */
      /* Se procede a ANULAR el comprobante              */
      pMensaje = "ERROR SUNAT:" + CHR(10) + pMensaje.
      pMensaje = pMensaje + CHR(10) +
          "Se procede a anular el comprobante: " + Ccbcdocu.coddoc + " " + Ccbcdocu.nrodoc + CHR(10) +
          "Salga del sistema, vuelva a entra y vuelva a intentarlo".
      ASSIGN
          CcbCDocu.FchAnu = TODAY
          CcbCDocu.FlgEst = "A"
          CcbCDocu.SdoAct = 0
          CcbCDocu.UsuAnu = s-user-id.
      FIND Almcmov WHERE ROWID(Almcmov) = s-NRODEV  EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF AVAILABLE Almcmov THEN Almcmov.FlgEst = "P".
      RUN vta2/actualiza-cot-por-devolucion (ROWID(Ccbcdocu), +1).
      /* EXTORNA CONTROL DE PERCEPCIONES POR ABONOS */
      FOR EACH B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
          AND B-CDOCU.coddiv = Ccbcdocu.coddiv
          AND B-CDOCU.coddoc = "PRA"
          AND B-CDOCU.codref = Ccbcdocu.coddoc
          AND B-CDOCU.nroref = Ccbcdocu.nrodoc:
          DELETE B-CDOCU.
      END.
  END.
  /* *********************************************************** */

  /* Code placed here will execute PRIOR to standard behavior. */
  
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle dTables  _DB-REQUIRED
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR x-nuevo-preuni AS DEC.
  DEF VAR x-nuevo-implin AS DEC.
  DEF VAR x-nuevo-igv AS DEC.
  DEF VAR x-Items AS INT NO-UNDO.

  /* Importamos el temporal */
  RUN Import-Temp-Table IN lh_handle (OUTPUT TABLE DETA).

  FOR EACH DETA BY DETA.NroItm:
      x-Items = x-Items + 1.
      CREATE CcbDDocu.
      ASSIGN 
          CcbDDocu.NroItm = x-Items
          CcbDDocu.CodCia = CcbCDocu.CodCia 
          CcbDDocu.Coddiv = CcbCDocu.Coddiv 
          CcbDDocu.CodDoc = CcbCDocu.CodDoc 
          CcbDDocu.NroDoc = CcbCDocu.NroDoc
          CcbDDocu.FchDoc = CcbCDocu.FchDoc
          CcbDDocu.codmat = DETA.codmat 
          CcbDDocu.PreUni = DETA.PreUni 
          CcbDDocu.CanDes = DETA.CanDes 
          CcbDDocu.Factor = DETA.Factor 
          CcbDDocu.ImpIsc = DETA.ImpIsc
          CcbDDocu.ImpIgv = DETA.ImpIgv 
          CcbDDocu.ImpLin = DETA.ImpLin
          CcbDDocu.PorDto = 0  /*DETA.PorDto */
          CcbDDocu.PreBas = DETA.PreBas 
          CcbDDocu.ImpDto = 0  /*DETA.ImpDto*/
          CcbDDocu.AftIgv = DETA.AftIgv
          CcbDDocu.AftIsc = DETA.AftIsc
          CcbDDocu.UndVta = DETA.UndVta
          CcbDDocu.Por_Dsctos[1] = 0 /*DETA.Por_Dsctos[1]*/
          CcbDDocu.Por_Dsctos[2] = 0 /*DETA.Por_Dsctos[2]*/
          CcbDDocu.Por_Dsctos[3] = 0 /*DETA.Por_Dsctos[3]*/
          CcbDDocu.Flg_factor = DETA.Flg_factor
          CcbDDocu.ImpCto     = DETA.ImpCto.
  END.
  IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales dTables  _DB-REQUIRED
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    {vtagn/i-total-factura-sunat.i &Cabecera="Ccbcdocu" &Detalle="Ccbddocu"}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preTransactionValidate dTables  _DB-REQUIRED
PROCEDURE preTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN 
      RowObjUpd.CodCia = S-CODCIA
      RowObjUpd.CodDiv = S-CODDIV
      RowObjUpd.CodDoc = S-CODDOC
      RowObjUpd.CndCre = s-CndCre     /* POR DEVOLUCION */
      RowObjUpd.TpoFac = s-TpoFac
      RowObjUpd.Tipo   = s-Tipo
      .

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RowObjectValidate dTables  _DB-REQUIRED
PROCEDURE RowObjectValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Concepto */
    IF TRUE <> (RowObject.CodCta > '') THEN RETURN 'Ingreso el concepto'.
    /* Debe estar en el maestro y activo */
    FIND Ccbtabla WHERE CcbTabla.CodCia = s-codcia AND
        CcbTabla.Tabla = "N/C" AND
        CcbTabla.Codigo = RowObject.CodCta
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbtabla OR Ccbtabla.Libre_L02 = NO THEN RETURN 'Concepto no válido'.
    /* Debe estar en la configuración */
    FIND Vtactabla WHERE VtaCTabla.CodCia = s-codcia AND
        VtaCTabla.Tabla = 'CFG_TIPO_NC' AND 
        VtaCTabla.Llave = s-TpoFac
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtactabla THEN RETURN 'Concepto no configurado para este movimiento'.
    FIND Vtadtabla WHERE VtaDTabla.CodCia = s-codcia AND
        VtaDTabla.Tabla = 'CFG_TIPO_NC' AND
        VtaDTabla.Llave = s-TpoFac AND
        VtaDTabla.Tipo = "CONCEPTO" AND
        VtaDTabla.LlaveDetalle = RowObject.CodCta
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtadtabla THEN RETURN 'Concepto no configurado para este movimiento'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

/* ************************  Function Implementations ***************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado dTables  _DB-REQUIRED
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pEstado AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  

  DEF VAR FILL-IN-Estado AS CHAR NO-UNDO.

  RUN gn/fFlgEstCCB (pEstado, OUTPUT FILL-IN-Estado).

  RETURN FILL-IN-Estado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

