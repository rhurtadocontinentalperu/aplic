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

DEF VAR x-FactorDescuento AS DECI NO-UNDO.

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
&Scoped-define INTERNAL-TABLES CcbDDocu Almmmatg

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS 
&Scoped-Define DATA-FIELDS  AftIgv AftIsc AlmDes CanDes CanDev CantidadBolsaPlastico~
 cImporteTotalConImpuesto cImporteVentaExonerado cImporteVentaGratuito~
 cMontoBaseIGV CodCia CodCli CodDiv CodDoc codmat cOtrosTributosOpGratuito~
 cPreUniSinImpuesto cSumaIGV cSumaImpteTotalSinImpuesto cTipoAfectacion~
 Dcto_Otros_Factor Dcto_Otros_Mot Dcto_Otros_PV Dcto_Otros_VV Factor~
 FactorDescuento FactorDescuentoNoAfecto FchDoc Flg_Factor ImpCto~
 ImpDcto_Adelanto1 ImpDcto_Adelanto2 ImpDcto_Adelanto3 ImpDcto_Adelanto4~
 ImpDcto_Adelanto5 ImpDto ImpDto2 ImpIgv ImpIsc ImpLin ImporteBaseDescuento~
 ImporteBaseDescuentoNoAfecto ImporteDescuento ImporteDescuentoNoAfecto~
 ImporteIGV ImporteReferencial ImporteTotalImpuestos ImporteTotalSinImpuesto~
 ImporteUnitarioConImpuesto ImporteUnitarioSinImpuesto ImpPro~
 ImpuestoBolsaPlastico MontoBaseIGV MontoTributoBolsaPlastico~
 MontoUnitarioBolsaPlastico mrguti NroDoc NroItm Pesmat PorDcto_Adelanto1~
 PorDcto_Adelanto2 PorDcto_Adelanto3 PorDcto_Adelanto4 PorDcto_Adelanto5~
 PorDto PorDto2 Por_Dsctos1 Por_Dsctos2 Por_Dsctos3 PreBas PreUni PreVta1~
 PreVta2 PreVta3 puntos TasaIGV UndVta x-FactorDescuento DesMat DesMar
&Scoped-define DATA-FIELDS-IN-CcbDDocu AftIgv AftIsc AlmDes CanDes CanDev ~
CantidadBolsaPlastico cImporteTotalConImpuesto cImporteVentaExonerado ~
cImporteVentaGratuito cMontoBaseIGV CodCia CodCli CodDiv CodDoc codmat ~
cOtrosTributosOpGratuito cPreUniSinImpuesto cSumaIGV ~
cSumaImpteTotalSinImpuesto cTipoAfectacion Dcto_Otros_Factor Dcto_Otros_Mot ~
Dcto_Otros_PV Dcto_Otros_VV Factor FactorDescuento FactorDescuentoNoAfecto ~
FchDoc Flg_Factor ImpCto ImpDcto_Adelanto1 ImpDcto_Adelanto2 ~
ImpDcto_Adelanto3 ImpDcto_Adelanto4 ImpDcto_Adelanto5 ImpDto ImpDto2 ImpIgv ~
ImpIsc ImpLin ImporteBaseDescuento ImporteBaseDescuentoNoAfecto ~
ImporteDescuento ImporteDescuentoNoAfecto ImporteIGV ImporteReferencial ~
ImporteTotalImpuestos ImporteTotalSinImpuesto ImporteUnitarioConImpuesto ~
ImporteUnitarioSinImpuesto ImpPro ImpuestoBolsaPlastico MontoBaseIGV ~
MontoTributoBolsaPlastico MontoUnitarioBolsaPlastico mrguti NroDoc NroItm ~
Pesmat PorDcto_Adelanto1 PorDcto_Adelanto2 PorDcto_Adelanto3 ~
PorDcto_Adelanto4 PorDcto_Adelanto5 PorDto PorDto2 Por_Dsctos1 Por_Dsctos2 ~
Por_Dsctos3 PreBas PreUni PreVta1 PreVta2 PreVta3 puntos TasaIGV UndVta 
&Scoped-define DATA-FIELDS-IN-Almmmatg DesMat DesMar 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST   rowObject.ImpDcto_Adelanto1 = CcbDDocu.ImpDcto_Adelanto[1]~
  rowObject.ImpDcto_Adelanto2 = CcbDDocu.ImpDcto_Adelanto[2]~
  rowObject.ImpDcto_Adelanto3 = CcbDDocu.ImpDcto_Adelanto[3]~
  rowObject.ImpDcto_Adelanto4 = CcbDDocu.ImpDcto_Adelanto[4]~
  rowObject.ImpDcto_Adelanto5 = CcbDDocu.ImpDcto_Adelanto[5]~
  rowObject.PorDcto_Adelanto1 = CcbDDocu.PorDcto_Adelanto[1]~
  rowObject.PorDcto_Adelanto2 = CcbDDocu.PorDcto_Adelanto[2]~
  rowObject.PorDcto_Adelanto3 = CcbDDocu.PorDcto_Adelanto[3]~
  rowObject.PorDcto_Adelanto4 = CcbDDocu.PorDcto_Adelanto[4]~
  rowObject.PorDcto_Adelanto5 = CcbDDocu.PorDcto_Adelanto[5]~
  rowObject.Por_Dsctos1 = CcbDDocu.Por_Dsctos[1]~
  rowObject.Por_Dsctos2 = CcbDDocu.Por_Dsctos[2]~
  rowObject.Por_Dsctos3 = CcbDDocu.Por_Dsctos[3]~
  rowObject.PreVta1 = CcbDDocu.PreVta[1]~
  rowObject.PreVta2 = CcbDDocu.PreVta[2]~
  rowObject.PreVta3 = CcbDDocu.PreVta[3]
&Scoped-Define DATA-FIELD-DEFS "ccb/dccbddocu.i"
&Scoped-Define DATA-TABLE-NO-UNDO NO-UNDO
&Scoped-define QUERY-STRING-Query-Main FOR EACH CcbDDocu NO-LOCK, ~
      EACH Almmmatg OF CcbDDocu NO-LOCK INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH CcbDDocu NO-LOCK, ~
      EACH Almmmatg OF CcbDDocu NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main CcbDDocu Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main CcbDDocu
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
      CcbDDocu, 
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
         WIDTH              = 59.43.
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
     _TblList          = "INTEGRAL.CcbDDocu,INTEGRAL.Almmmatg OF INTEGRAL.CcbDDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > INTEGRAL.CcbDDocu.AftIgv
"AftIgv" "AftIgv" ? ? "logical" ? ? ? ? ? ? no ? no 4.43 yes ?
     _FldNameList[2]   > INTEGRAL.CcbDDocu.AftIsc
"AftIsc" "AftIsc" ? ? "logical" ? ? ? ? ? ? no ? no 4.29 yes ?
     _FldNameList[3]   > INTEGRAL.CcbDDocu.AlmDes
"AlmDes" "AlmDes" ? ? "character" ? ? ? ? ? ? no ? no 17 yes ?
     _FldNameList[4]   > INTEGRAL.CcbDDocu.CanDes
"CanDes" "CanDes" ? ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no 8.86 yes ?
     _FldNameList[5]   > INTEGRAL.CcbDDocu.CanDev
"CanDev" "CanDev" ? ? "decimal" ? ? ? ? ? ? no ? no 12.29 yes ?
     _FldNameList[6]   > INTEGRAL.CcbDDocu.CantidadBolsaPlastico
"CantidadBolsaPlastico" "CantidadBolsaPlastico" ? ? "integer" ? ? ? ? ? ? no ? no 19.57 yes ?
     _FldNameList[7]   > INTEGRAL.CcbDDocu.cImporteTotalConImpuesto
"cImporteTotalConImpuesto" "cImporteTotalConImpuesto" "Importe!con IGV" ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no 10.29 yes "Importe!con IGV"
     _FldNameList[8]   > INTEGRAL.CcbDDocu.cImporteVentaExonerado
"cImporteVentaExonerado" "cImporteVentaExonerado" ? ? "decimal" ? ? ? ? ? ? no ? no 21.86 yes ?
     _FldNameList[9]   > INTEGRAL.CcbDDocu.cImporteVentaGratuito
"cImporteVentaGratuito" "cImporteVentaGratuito" ? ? "decimal" ? ? ? ? ? ? no ? no 19 yes ?
     _FldNameList[10]   > INTEGRAL.CcbDDocu.cMontoBaseIGV
"cMontoBaseIGV" "cMontoBaseIGV" ? ? "decimal" ? ? ? ? ? ? no ? no 14 yes ?
     _FldNameList[11]   > INTEGRAL.CcbDDocu.CodCia
"CodCia" "CodCia" ? ? "integer" ? ? ? ? ? ? no ? no 3 yes ?
     _FldNameList[12]   > INTEGRAL.CcbDDocu.CodCli
"CodCli" "CodCli" ? ? "character" ? ? ? ? ? ? no ? no 11 yes ?
     _FldNameList[13]   > INTEGRAL.CcbDDocu.CodDiv
"CodDiv" "CodDiv" ? ? "character" ? ? ? ? ? ? no ? no 6 yes ?
     _FldNameList[14]   > INTEGRAL.CcbDDocu.CodDoc
"CodDoc" "CodDoc" ? ? "character" ? ? ? ? ? ? no ? no 6.29 yes ?
     _FldNameList[15]   > INTEGRAL.CcbDDocu.codmat
"codmat" "codmat" "Articulo" "X(8)" "character" ? ? ? ? ? ? no ? no 8 yes "Articulo"
     _FldNameList[16]   > INTEGRAL.CcbDDocu.cOtrosTributosOpGratuito
"cOtrosTributosOpGratuito" "cOtrosTributosOpGratuito" ? ? "decimal" ? ? ? ? ? ? no ? no 21.72 yes ?
     _FldNameList[17]   > INTEGRAL.CcbDDocu.cPreUniSinImpuesto
"cPreUniSinImpuesto" "cPreUniSinImpuesto" ? ? "decimal" ? ? ? ? ? ? no ? no 22.43 yes ?
     _FldNameList[18]   > INTEGRAL.CcbDDocu.cSumaIGV
"cSumaIGV" "cSumaIGV" ? ? "decimal" ? ? ? ? ? ? no ? no 12.29 yes ?
     _FldNameList[19]   > INTEGRAL.CcbDDocu.cSumaImpteTotalSinImpuesto
"cSumaImpteTotalSinImpuesto" "cSumaImpteTotalSinImpuesto" ? ? "decimal" ? ? ? ? ? ? no ? no 25.72 yes ?
     _FldNameList[20]   > INTEGRAL.CcbDDocu.cTipoAfectacion
"cTipoAfectacion" "cTipoAfectacion" ? ? "character" ? ? ? ? ? ? no ? no 25 yes ?
     _FldNameList[21]   > INTEGRAL.CcbDDocu.Dcto_Otros_Factor
"Dcto_Otros_Factor" "Dcto_Otros_Factor" ? ? "decimal" ? ? ? ? ? ? no ? no 16 yes ?
     _FldNameList[22]   > INTEGRAL.CcbDDocu.Dcto_Otros_Mot
"Dcto_Otros_Mot" "Dcto_Otros_Mot" ? ? "character" ? ? ? ? ? ? no ? no 20 yes ?
     _FldNameList[23]   > INTEGRAL.CcbDDocu.Dcto_Otros_PV
"Dcto_Otros_PV" "Dcto_Otros_PV" ? ? "decimal" ? ? ? ? ? ? no ? no 16.86 yes ?
     _FldNameList[24]   > INTEGRAL.CcbDDocu.Dcto_Otros_VV
"Dcto_Otros_VV" "Dcto_Otros_VV" ? ? "decimal" ? ? ? ? ? ? no ? no 16.86 yes ?
     _FldNameList[25]   > INTEGRAL.CcbDDocu.Factor
"Factor" "Factor" ? ? "decimal" ? ? ? ? ? ? no ? no 9.86 yes ?
     _FldNameList[26]   > INTEGRAL.CcbDDocu.FactorDescuento
"FactorDescuento" "FactorDescuento" ? ? "decimal" ? ? ? ? ? ? no ? no 14.72 yes ?
     _FldNameList[27]   > INTEGRAL.CcbDDocu.FactorDescuentoNoAfecto
"FactorDescuentoNoAfecto" "FactorDescuentoNoAfecto" ? ? "decimal" ? ? ? ? ? ? no ? no 22.72 yes ?
     _FldNameList[28]   > INTEGRAL.CcbDDocu.FchDoc
"FchDoc" "FchDoc" ? ? "date" ? ? ? ? ? ? no ? no 9.14 yes ?
     _FldNameList[29]   > INTEGRAL.CcbDDocu.Flg_Factor
"Flg_Factor" "Flg_Factor" ? ? "character" ? ? ? ? ? ? no ? no 9.14 yes ?
     _FldNameList[30]   > INTEGRAL.CcbDDocu.ImpCto
"ImpCto" "ImpCto" ? ? "decimal" ? ? ? ? ? ? no ? no 11.86 yes ?
     _FldNameList[31]   > INTEGRAL.CcbDDocu.ImpDcto_Adelanto[1]
"ImpDcto_Adelanto[1]" "ImpDcto_Adelanto1" ? ? "decimal" ? ? ? ? ? ? no ? no 15.86 yes ?
     _FldNameList[32]   > INTEGRAL.CcbDDocu.ImpDcto_Adelanto[2]
"ImpDcto_Adelanto[2]" "ImpDcto_Adelanto2" ? ? "decimal" ? ? ? ? ? ? no ? no 15.86 yes ?
     _FldNameList[33]   > INTEGRAL.CcbDDocu.ImpDcto_Adelanto[3]
"ImpDcto_Adelanto[3]" "ImpDcto_Adelanto3" ? ? "decimal" ? ? ? ? ? ? no ? no 15.86 yes ?
     _FldNameList[34]   > INTEGRAL.CcbDDocu.ImpDcto_Adelanto[4]
"ImpDcto_Adelanto[4]" "ImpDcto_Adelanto4" ? ? "decimal" ? ? ? ? ? ? no ? no 15.86 yes ?
     _FldNameList[35]   > INTEGRAL.CcbDDocu.ImpDcto_Adelanto[5]
"ImpDcto_Adelanto[5]" "ImpDcto_Adelanto5" ? ? "decimal" ? ? ? ? ? ? no ? no 15.86 yes ?
     _FldNameList[36]   > INTEGRAL.CcbDDocu.ImpDto
"ImpDto" "ImpDto" ? ? "decimal" ? ? ? ? ? ? no ? no 16.14 yes ?
     _FldNameList[37]   > INTEGRAL.CcbDDocu.ImpDto2
"ImpDto2" "ImpDto2" ? ? "decimal" ? ? ? ? ? ? no ? no 12.86 yes ?
     _FldNameList[38]   > INTEGRAL.CcbDDocu.ImpIgv
"ImpIgv" "ImpIgv" ? ? "decimal" ? ? ? ? ? ? no ? no 12.29 yes ?
     _FldNameList[39]   > INTEGRAL.CcbDDocu.ImpIsc
"ImpIsc" "ImpIsc" ? ? "decimal" ? ? ? ? ? ? no ? no 12.29 yes ?
     _FldNameList[40]   > INTEGRAL.CcbDDocu.ImpLin
"ImpLin" "ImpLin" ? ? "decimal" ? ? ? ? ? ? no ? no 11.86 yes ?
     _FldNameList[41]   > INTEGRAL.CcbDDocu.ImporteBaseDescuento
"ImporteBaseDescuento" "ImporteBaseDescuento" ? ? "decimal" ? ? ? ? ? ? no ? no 20.29 yes ?
     _FldNameList[42]   > INTEGRAL.CcbDDocu.ImporteBaseDescuentoNoAfecto
"ImporteBaseDescuentoNoAfecto" "ImporteBaseDescuentoNoAfecto" ? ? "decimal" ? ? ? ? ? ? no ? no 28.29 yes ?
     _FldNameList[43]   > INTEGRAL.CcbDDocu.ImporteDescuento
"ImporteDescuento" "ImporteDescuento" ? ? "decimal" ? ? ? ? ? ? no ? no 15.72 yes ?
     _FldNameList[44]   > INTEGRAL.CcbDDocu.ImporteDescuentoNoAfecto
"ImporteDescuentoNoAfecto" "ImporteDescuentoNoAfecto" ? ? "decimal" ? ? ? ? ? ? no ? no 23.72 yes ?
     _FldNameList[45]   > INTEGRAL.CcbDDocu.ImporteIGV
"ImporteIGV" "ImporteIGV" ? ? "decimal" ? ? ? ? ? ? no ? no 14.43 yes ?
     _FldNameList[46]   > INTEGRAL.CcbDDocu.ImporteReferencial
"ImporteReferencial" "ImporteReferencial" ? ? "decimal" ? ? ? ? ? ? no ? no 22.43 yes ?
     _FldNameList[47]   > INTEGRAL.CcbDDocu.ImporteTotalImpuestos
"ImporteTotalImpuestos" "ImporteTotalImpuestos" ? ? "decimal" ? ? ? ? ? ? no ? no 19.72 yes ?
     _FldNameList[48]   > INTEGRAL.CcbDDocu.ImporteTotalSinImpuesto
"ImporteTotalSinImpuesto" "ImporteTotalSinImpuesto" ? ? "decimal" ? ? ? ? ? ? no ? no 21.43 yes ?
     _FldNameList[49]   > INTEGRAL.CcbDDocu.ImporteUnitarioConImpuesto
"ImporteUnitarioConImpuesto" "ImporteUnitarioConImpuesto" ? ? "decimal" ? ? ? ? ? ? no ? no 24.29 yes ?
     _FldNameList[50]   > INTEGRAL.CcbDDocu.ImporteUnitarioSinImpuesto
"ImporteUnitarioSinImpuesto" "ImporteUnitarioSinImpuesto" ? ? "decimal" ? ? ? ? ? ? no ? no 23.57 yes ?
     _FldNameList[51]   > INTEGRAL.CcbDDocu.ImpPro
"ImpPro" "ImpPro" ? ? "decimal" ? ? ? ? ? ? no ? no 12.86 yes ?
     _FldNameList[52]   > INTEGRAL.CcbDDocu.ImpuestoBolsaPlastico
"ImpuestoBolsaPlastico" "ImpuestoBolsaPlastico" ? ? "decimal" ? ? ? ? ? ? no ? no 19.72 yes ?
     _FldNameList[53]   > INTEGRAL.CcbDDocu.MontoBaseIGV
"MontoBaseIGV" "MontoBaseIGV" ? ? "decimal" ? ? ? ? ? ? no ? no 14.43 yes ?
     _FldNameList[54]   > INTEGRAL.CcbDDocu.MontoTributoBolsaPlastico
"MontoTributoBolsaPlastico" "MontoTributoBolsaPlastico" ? ? "decimal" ? ? ? ? ? ? no ? no 23.14 yes ?
     _FldNameList[55]   > INTEGRAL.CcbDDocu.MontoUnitarioBolsaPlastico
"MontoUnitarioBolsaPlastico" "MontoUnitarioBolsaPlastico" ? ? "decimal" ? ? ? ? ? ? no ? no 23.72 yes ?
     _FldNameList[56]   > INTEGRAL.CcbDDocu.mrguti
"mrguti" "mrguti" ? ? "decimal" ? ? ? ? ? ? no ? no 8.43 yes ?
     _FldNameList[57]   > INTEGRAL.CcbDDocu.NroDoc
"NroDoc" "NroDoc" ? ? "character" ? ? ? ? ? ? no ? no 12 yes ?
     _FldNameList[58]   > INTEGRAL.CcbDDocu.NroItm
"NroItm" "NroItm" "No" ">>>9" "integer" ? ? ? ? ? ? no ? no 4 yes "No"
     _FldNameList[59]   > INTEGRAL.CcbDDocu.Pesmat
"Pesmat" "Pesmat" ? ? "decimal" ? ? ? ? ? ? no ? no 10.43 yes ?
     _FldNameList[60]   > INTEGRAL.CcbDDocu.PorDcto_Adelanto[1]
"PorDcto_Adelanto[1]" "PorDcto_Adelanto1" ? ? "decimal" ? ? ? ? ? ? no ? no 15.72 yes ?
     _FldNameList[61]   > INTEGRAL.CcbDDocu.PorDcto_Adelanto[2]
"PorDcto_Adelanto[2]" "PorDcto_Adelanto2" ? ? "decimal" ? ? ? ? ? ? no ? no 15.72 yes ?
     _FldNameList[62]   > INTEGRAL.CcbDDocu.PorDcto_Adelanto[3]
"PorDcto_Adelanto[3]" "PorDcto_Adelanto3" ? ? "decimal" ? ? ? ? ? ? no ? no 15.72 yes ?
     _FldNameList[63]   > INTEGRAL.CcbDDocu.PorDcto_Adelanto[4]
"PorDcto_Adelanto[4]" "PorDcto_Adelanto4" ? ? "decimal" ? ? ? ? ? ? no ? no 15.72 yes ?
     _FldNameList[64]   > INTEGRAL.CcbDDocu.PorDcto_Adelanto[5]
"PorDcto_Adelanto[5]" "PorDcto_Adelanto5" ? ? "decimal" ? ? ? ? ? ? no ? no 15.72 yes ?
     _FldNameList[65]   > INTEGRAL.CcbDDocu.PorDto
"PorDto" "PorDto" ? ? "decimal" ? ? ? ? ? ? no ? no 7.57 yes ?
     _FldNameList[66]   > INTEGRAL.CcbDDocu.PorDto2
"PorDto2" "PorDto2" ? ? "decimal" ? ? ? ? ? ? no ? no 7.57 yes ?
     _FldNameList[67]   > INTEGRAL.CcbDDocu.Por_Dsctos[1]
"Por_Dsctos[1]" "Por_Dsctos1" ? ? "decimal" ? ? ? ? ? ? no ? no 11.43 yes ?
     _FldNameList[68]   > INTEGRAL.CcbDDocu.Por_Dsctos[2]
"Por_Dsctos[2]" "Por_Dsctos2" ? ? "decimal" ? ? ? ? ? ? no ? no 11.43 yes ?
     _FldNameList[69]   > INTEGRAL.CcbDDocu.Por_Dsctos[3]
"Por_Dsctos[3]" "Por_Dsctos3" ? ? "decimal" ? ? ? ? ? ? no ? no 11.43 yes ?
     _FldNameList[70]   > INTEGRAL.CcbDDocu.PreBas
"PreBas" "PreBas" ? ? "decimal" ? ? ? ? ? ? no ? no 12.29 yes ?
     _FldNameList[71]   > INTEGRAL.CcbDDocu.PreUni
"PreUni" "PreUni" "Precio Unitario!con IGV" ">>>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no 12.57 yes "Precio Unitario!con IGV"
     _FldNameList[72]   > INTEGRAL.CcbDDocu.PreVta[1]
"PreVta[1]" "PreVta1" ? ? "decimal" ? ? ? ? ? ? no ? no 11.29 yes ?
     _FldNameList[73]   > INTEGRAL.CcbDDocu.PreVta[2]
"PreVta[2]" "PreVta2" ? ? "decimal" ? ? ? ? ? ? no ? no 11.29 yes ?
     _FldNameList[74]   > INTEGRAL.CcbDDocu.PreVta[3]
"PreVta[3]" "PreVta3" ? ? "decimal" ? ? ? ? ? ? no ? no 11.29 yes ?
     _FldNameList[75]   > INTEGRAL.CcbDDocu.puntos
"puntos" "puntos" ? ? "decimal" ? ? ? ? ? ? no ? no 8.43 yes ?
     _FldNameList[76]   > INTEGRAL.CcbDDocu.TasaIGV
"TasaIGV" "TasaIGV" ? ? "decimal" ? ? ? ? ? ? no ? no 8.43 yes ?
     _FldNameList[77]   > INTEGRAL.CcbDDocu.UndVta
"UndVta" "UndVta" ? "x(10)" "character" ? ? ? ? ? ? no ? no 10 yes "Unidad"
     _FldNameList[78]   > "_<CALC>"
"RowObject.FactorDescuento * 100" "x-FactorDescuento" "% Descuento" ">>9.99999" "Decimal" ? ? ? ? ? ? no ? no 11.43 no ?
     _FldNameList[79]   > INTEGRAL.Almmmatg.DesMat
"DesMat" "DesMat" ? "X(70)" "character" ? ? ? ? ? ? no ? no 70 yes ?
     _FldNameList[80]   > INTEGRAL.Almmmatg.DesMar
"DesMar" "DesMar" "Marca" "X(12)" "character" ? ? ? ? ? ? no ? no 12 yes "Marca"
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DATA.CALCULATE dTables  DATA.CALCULATE _DB-REQUIRED
PROCEDURE DATA.CALCULATE :
/*------------------------------------------------------------------------------
  Purpose:     Calculate all the Calculated Expressions found in the
               SmartDataObject.
  Parameters:  <none>
------------------------------------------------------------------------------*/
      ASSIGN 
         rowObject.x-FactorDescuento = (RowObject.FactorDescuento * 100)
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

