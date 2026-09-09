&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-ADocu FOR CcbADocu.
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-DDOCU FOR CcbDDocu.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE TEMP-TABLE ITEM NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE TEMP-TABLE T-CcbADocu NO-UNDO LIKE CcbADocu.
DEFINE TEMP-TABLE T-CDOCU NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE T-DDOCU NO-UNDO LIKE CcbDDocu.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
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

DEFINE PARAMETER BUFFER Faccpedi FOR Faccpedi.
DEFINE INPUT PARAMETER pTipoGuia   AS CHAR.
/* pTipoGuia
    A: automática
    M: manual
    FA: FAI automático
    FM: FAI manual 
*/
DEFINE INPUT PARAMETER pOrigen AS CHAR. 
/* pOrigen
    MOSTRADOR: Solo emisión de Factura
      CREDITO: Factura y Guias de Remisión
    */

DEFINE INPUT PARAMETER pTipMov AS CHAR.
/* pTipMov
    ELECTRONICA
    MANUAL
    */

DEFINE VAR pCodTer AS CHAR NO-UNDO.


DEFINE SHARED VARIABLE s-CodCia AS INTEGER.
DEFINE SHARED VARIABLE s-NomCia AS CHARACTER.
DEFINE SHARED VARIABLE s-CodDiv AS CHARACTER.
DEFINE SHARED VARIABLE s-User-Id AS CHARACTER.
DEFINE SHARED VARIABLE cl-codcia AS INTEGER.
DEFINE SHARED VARIABLE pv-codcia AS INTEGER.

DEFINE VARIABLE cCodDoc AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodAlm AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodMov AS INTEGER NO-UNDO.
DEFINE VARIABLE iCountGuide AS INTEGER NO-UNDO.
DEFINE VARIABLE cObser  AS CHARACTER   NO-UNDO.

IF NOT (FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = 'C') THEN DO:
    MESSAGE
        "Registro de O/D ya no está 'PENDIENTE'"
        VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.
ASSIGN
    cCodAlm = FacCPedi.Codalm       /* <<< OJO <<< */
    cObser  = FacCPedi.Glosa
    cCodDoc = FacCPedi.Cmpbnte.     /* <<< OJO <<< */

/* Consistencia del tipo de guia */
CASE TRUE:
    WHEN pTipoGuia = "FM" THEN ASSIGN cCodDoc = "FAI" pTipoGuia = "M".
    WHEN pTipoGuia = "FA" THEN ASSIGN cCodDoc = "FAI" pTipoGuia = "A".
END CASE.
IF LOOKUP(cCodDoc, 'FAC,BOL,FAI') = 0 THEN RETURN.  /* 14Set2016 incluir FAI */

FIND FacDocum WHERE FacDocum.CodCia = s-CodCia 
    AND FacDocum.CodDoc = cCodDoc 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum OR FacDocum.CodMov = 0 THEN DO:
    MESSAGE
        "Codigo de Documento " cCodDoc " no existe en la maestra FACDOCUM" SKIP
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
cCodMov = FacDocum.CodMov.

DEF VAR cOk AS LOG NO-UNDO.
cOk = NO.
FOR EACH FacCorre NO-LOCK WHERE 
    FacCorre.CodCia = s-CodCia AND
    FacCorre.CodDiv = s-CodDiv AND 
    FacCorre.CodDoc = cCodDoc AND
    FacCorre.ID_Pos = pOrigen AND
    FacCorre.FlgEst = YES:
    IF pOrigen = "CREDITO" THEN DO:
        /* SOLO ACEPTA LOS QUE NO ESTEN ASIGNADOS A UNA CAJA COBRANZA */
        FIND CcbDTerm WHERE CcbDTerm.CodCia = s-codcia
            AND CcbDTerm.CodDiv = s-coddiv
            AND CcbDTerm.CodDoc = cCodDoc
            AND CcbDTerm.NroSer = FacCorre.NroSer
            NO-LOCK NO-ERROR.
        IF AVAILABLE CcbDTerm THEN DO:
            /* Verificamos la cabecera */
            FIND FIRST CcbCTerm OF CcbDTerm NO-LOCK NO-ERROR.
            IF AVAILABLE CcbCTerm THEN NEXT.
        END.
        cOk = YES.
    END.
    ELSE cOk = YES.
END.
IF cOk = NO THEN DO:
    MESSAGE
        "Código de Documento " cCodDoc " no configurado " SKIP
        "División:" s-CodDiv SKIP 
        "Origen(MOSTRADOR/CREDITO):" pOrigen
        VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.



/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-FormatoFAC  AS CHAR INIT '999-99999999' NO-UNDO.
DEF VAR x-FormatoGUIA AS CHAR INIT '999-999999' NO-UNDO.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
RUN sunat\p-formato-doc (INPUT cCodDoc, OUTPUT x-FormatoFAC).
RUN sunat\p-formato-doc (INPUT "G/R", OUTPUT x-FormatoGUIA).

DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR pMensaje-2 AS CHAR NO-UNDO.


/* Ic - 01Feb2017, es serie comprobante DIFERIDO */
DEFINE VAR pEsSerieDiferido AS LOG INIT NO.
DEFINE VAR pEsValesUtilex AS LOG INIT NO.
DEFINE VARIABLE COMBO-BOX-Guias AS CHARACTER INITIAL "NO" .
DEFINE VARIABLE COMBO-NroSer-Guia AS CHARACTER.

DEFINE TEMP-TABLE Reporte NO-UNDO
    FIELD CodCia LIKE CcbCDocu.CodCia
    FIELD CodDiv LIKE CcbCDOcu.CodDiv 
    FIELD CodDoc LIKE CcbCDocu.CodDoc
    FIELD NroDoc LIKE CcbCDocu.Nrodoc
    INDEX Llave01 codcia coddiv coddoc nrodoc.

DEF VAR s-FechaI AS DATETIME NO-UNDO.
DEF VAR s-FechaT AS DATETIME NO-UNDO.

s-FechaI = DATETIME(TODAY, MTIME).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES PEDI Almmmatg

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 PEDI.codmat Almmmatg.DesMat ~
PEDI.CanPed PEDI.UndVta PEDI.AlmDes 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH PEDI NO-LOCK, ~
      FIRST Almmmatg OF PEDI NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH PEDI NO-LOCK, ~
      FIRST Almmmatg OF PEDI NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 PEDI Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 PEDI
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-4 Almmmatg


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 Btn_OK Btn_Cancel COMBO-NroSer ~
BROWSE-4 FILL-IN-tipo 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NroPed FILL-IN-Cliente ~
FILL-IN-DirClie COMBO-NroSer FILL-IN-NroDoc FILL-IN-items FILL-IN-LugEnt ~
FILL-IN-Glosa FILL-IN-tipo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-NroSer AS CHARACTER FORMAT "X(3)":U 
     LABEL "Serie FAC" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Cliente AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 4 NO-UNDO.

DEFINE VARIABLE FILL-IN-DirClie AS CHARACTER FORMAT "X(256)":U 
     LABEL "Dirección" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 4 NO-UNDO.

DEFINE VARIABLE FILL-IN-Glosa AS CHARACTER FORMAT "X(60)":U 
     LABEL "Glosa" 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-items AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "Items por Guía" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-LugEnt AS CHARACTER FORMAT "X(60)":U 
     LABEL "Entregar en" 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "XXX-XXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroPed AS CHARACTER FORMAT "X(9)":U 
     LABEL "O/D" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-tipo AS CHARACTER FORMAT "X(25)":U 
      VIEW-AS TEXT 
     SIZE 28.43 BY .88
     FGCOLOR 12 FONT 9 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 114 BY 6.46
     BGCOLOR 15 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      PEDI, 
      Almmmatg
    FIELDS(Almmmatg.DesMat) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 D-Dialog _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      PEDI.codmat COLUMN-LABEL "Artículo" FORMAT "X(8)":U
      Almmmatg.DesMat FORMAT "X(100)":U WIDTH 67.86
      PEDI.CanPed FORMAT ">,>>>,>>9.9999":U
      PEDI.UndVta FORMAT "x(8)":U
      PEDI.AlmDes COLUMN-LABEL "Almacén" FORMAT "x(8)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 113 BY 15.08
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Btn_OK AT ROW 1.54 COL 100
     FILL-IN-NroPed AT ROW 1.58 COL 10 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-Cliente AT ROW 1.58 COL 27 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-DirClie AT ROW 2.35 COL 27 COLON-ALIGNED WIDGET-ID 24
     Btn_Cancel AT ROW 3.15 COL 100
     COMBO-NroSer AT ROW 3.46 COL 4.43 WIDGET-ID 2
     FILL-IN-NroDoc AT ROW 3.46 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     FILL-IN-items AT ROW 3.46 COL 42.29 COLON-ALIGNED WIDGET-ID 18
     FILL-IN-LugEnt AT ROW 5.31 COL 11 COLON-ALIGNED WIDGET-ID 30
     FILL-IN-Glosa AT ROW 6.12 COL 11 COLON-ALIGNED WIDGET-ID 28
     BROWSE-4 AT ROW 7.73 COL 2 WIDGET-ID 200
     FILL-IN-tipo AT ROW 3.27 COL 50.86 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     RECT-1 AT ROW 1.27 COL 2 WIDGET-ID 4
     SPACE(1.28) SKIP(15.38)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "GENERACION DE COMPROBANTES VENTAS AL CREDITO"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-ADocu B "?" ? INTEGRAL CcbADocu
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: B-DDOCU B "?" ? INTEGRAL CcbDDocu
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: ITEM T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: PEDI T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: T-CcbADocu T "?" NO-UNDO INTEGRAL CcbADocu
      TABLE: T-CDOCU T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: T-DDOCU T "?" NO-UNDO INTEGRAL CcbDDocu
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-4 FILL-IN-Glosa D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX COMBO-NroSer IN FRAME D-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-Cliente IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DirClie IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Glosa IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-items IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-LugEnt IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroPed IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.PEDI,INTEGRAL.Almmmatg OF Temp-Tables.PEDI"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED"
     _FldNameList[1]   > Temp-Tables.PEDI.codmat
"PEDI.codmat" "Artículo" "X(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(100)" "character" ? ? ? ? ? ? no ? no no "67.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.PEDI.CanPed
     _FldNameList[4]   = Temp-Tables.PEDI.UndVta
     _FldNameList[5]   > Temp-Tables.PEDI.AlmDes
"PEDI.AlmDes" "Almacén" "x(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* GENERACION DE COMPROBANTES VENTAS AL CREDITO */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
    DEFINE VARIABLE iCount AS INTEGER NO-UNDO.

    FOR EACH FacDPedi OF FacCPedi NO-LOCK:
        iCount = iCount + 1.
    END. 
    IF iCount = 0 THEN DO:
        MESSAGE "No hay items por despachar"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.   
    END. 

    /* Empresas NO requiere G/R */
    IF pOrigen = "CREDITO" THEN DO:
        IF FacCPedi.CodCli = "20100047218" THEN DO:
            IF cCodDoc <> "FAI" THEN DO:
                MESSAGE "Para el BCP solo se emiten FAI, consulte con COMERCIAL"
                    VIEW-AS ALERT-BOX ERROR.
                RETURN NO-APPLY.
            END.
        END.
        MESSAGE "¿Todos los datos son correctos?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE rpta AS LOGICAL.
        IF rpta <> TRUE THEN RETURN NO-APPLY.

        ASSIGN
            COMBO-NroSer
            FILL-IN-items
            FILL-IN-LugEnt
            FILL-IN-Glosa
            .

        /* UN SOLO PROCESO */
        RUN MASTER-TRANSACTION.
        IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer D-Dialog
ON RETURN OF COMBO-NroSer IN FRAME D-Dialog /* Serie FAC */
DO:
    APPLY 'Tab':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer D-Dialog
ON VALUE-CHANGED OF COMBO-NroSer IN FRAME D-Dialog /* Serie FAC */
DO:
    /* Correlativo */
    FIND FacCorre WHERE
        FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDoc = cCodDoc AND
        FacCorre.CodDiv = s-CodDiv AND
        FacCorre.NroSer = INTEGER(SELF:SCREEN-VALUE)
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCorre THEN
        FILL-IN-NroDoc = STRING(FacCorre.NroSer,ENTRY(1,x-FormatoFAC,'-')) + 
        STRING(FacCorre.Correlativo,ENTRY(2,x-FormatoFAC,'-')).
    ELSE FILL-IN-NroDoc = "".
    RUN sunat\p-nro-items (cCodDoc, INTEGER(SELF:SCREEN-VALUE), OUTPUT FILL-IN-items).
    
    DISPLAY FILL-IN-NroDoc FILL-IN-items WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

{logis/d-genera-comprobantes-sunat-gre.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Inicial D-Dialog 
PROCEDURE Carga-Inicial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE ITEM.

  FOR EACH facdpedi OF faccpedi NO-LOCK BY Facdpedi.NroItm:
      CREATE ITEM.
      BUFFER-COPY facdpedi TO ITEM
          ASSIGN
            ITEM.canped = facdpedi.canped
            ITEM.canate = facdpedi.canped.
  END.
  /* Solo para el pintado inicial de la pantalla */
  EMPTY TEMP-TABLE PEDI.
  FOR EACH ITEM:
      CREATE PEDI.
      BUFFER-COPY ITEM TO PEDI.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY FILL-IN-NroPed FILL-IN-Cliente FILL-IN-DirClie COMBO-NroSer 
          FILL-IN-NroDoc FILL-IN-items FILL-IN-LugEnt FILL-IN-Glosa FILL-IN-tipo 
      WITH FRAME D-Dialog.
  ENABLE RECT-1 Btn_OK Btn_Cancel COMBO-NroSer BROWSE-4 FILL-IN-tipo 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIRST-TRANSACTION D-Dialog 
PROCEDURE FIRST-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* 1ro. Generamos las TEMPORALES PARA FAC/BOL */
    RUN Crea-Comprobantes.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "NO se pudo crear el Comprobante Temporal".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* 07/10/2025: TpoFac = "MANUAL" */
    IF pTipMov = "MANUAL" THEN DO:
        FOR EACH T-CDOCU:
            T-CDOCU.TpoFac = pTipMov.
        END.
    END.
    
    /* 2do. GRABACION DE LOS COMPROBANTES: ACTUALIZA ALMACENES */
    RUN Graba-Comprobantes.

    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear el Comprobante".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Temp-FeLogErrores D-Dialog 
PROCEDURE Graba-Temp-FeLogErrores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH T-FeLogErrores:
    CREATE FeLogErrores.
    BUFFER-COPY T-FeLogErrores TO FeLogErrores NO-ERROR.
    DELETE T-FeLogErrores.
END.
IF AVAILABLE(FeLogErrores) THEN RELEASE FeLogErrores.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.
  DEFINE VAR lxCotizacion AS CHAR.

  RUN Carga-Inicial.   /* Carga la tabla ITEM */
  FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
  DO WITH FRAME {&FRAME-NAME}:
      /* CORRELATIVO DE FAC y BOL */
      /* Por defecto supone que es un Centro de Distribución */
      {sunat\i-lista-series.i &CodCia=s-CodCia ~
          &CodDiv=s-CodDiv ~
          &CodDoc=cCodDoc ~
          &FlgEst='' ~
          &Tipo='CREDITO' ~
          &ListaSeries=cListItems }
      ASSIGN
          COMBO-NroSer:LIST-ITEMS = cListItems
          COMBO-NroSer = ENTRY(1,COMBO-NroSer:LIST-ITEMS)
          FILL-IN-items = FacCfgGn.Items_Guias
          FILL-IN-NroPed = FacCPedi.NroPed
          FILL-IN-Glosa = FacCPedi.Glosa
          FILL-IN-LugEnt = FacCPedi.LugEnt
          FILL-IN-Cliente = FacCPedi.CodCli + " - " + FacCPedi.NomCli
          FILL-IN-DirClie = FacCPedi.DirCli.
      /* Rutina Lugar de Entrega */
      RUN logis/p-lugar-de-entrega (INPUT Faccpedi.CodDoc,
                                    INPUT Faccpedi.NroPed,
                                    OUTPUT FILL-IN-LugEnt).
      IF NUM-ENTRIES(FILL-IN-LugEnt, '|') > 1 THEN FILL-IN-LugEnt = ENTRY(2, FILL-IN-LugEnt, '|').
      /* *********************** */
      CASE cCodDoc:
          WHEN "FAC" THEN ASSIGN FILL-IN-items = FacCfgGn.Items_Factura COMBO-NroSer:LABEL = 'SERIE DE FACTURA'.
          WHEN "BOL" THEN ASSIGN FILL-IN-items = FacCfgGn.Items_Boleta  COMBO-NroSer:LABEL = 'SERIE DE BOLETAS'.
          WHEN "FAI" THEN ASSIGN FILL-IN-items = FacCfgGn.Items_Boleta  COMBO-NroSer:LABEL = 'SERIE DE FAIs'.
      END CASE.
      RUN sunat\p-nro-items (cCodDoc, INTEGER(COMBO-NroSer), OUTPUT FILL-IN-items).
      RUN sunat\p-formato-doc (INPUT cCodDoc, OUTPUT x-FormatoFAC).
      ASSIGN
          COMBO-NroSer:FORMAT = TRIM(ENTRY(1,x-FormatoFAC,'-'))
          FILL-IN-NroDoc:FORMAT = x-FormatoFAC.
      FIND FacCorre WHERE
          FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDoc = cCodDoc AND
          FacCorre.CodDiv = s-CodDiv AND
          FacCorre.NroSer = INTEGER(COMBO-NroSer)
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN
          FILL-IN-NroDoc =
              STRING(FacCorre.NroSer,ENTRY(1,x-FormatoFAC,'-')) +
              STRING(FacCorre.Correlativo,ENTRY(2,x-FormatoFAC,'-')).


      /* RHC Cargamos TRANSPORTISTA por defecto */
      EMPTY TEMP-TABLE T-CcbADocu.
      FIND Ccbadocu WHERE Ccbadocu.codcia = Faccpedi.codcia
              AND Ccbadocu.coddiv = Faccpedi.coddiv
              AND Ccbadocu.coddoc = Faccpedi.coddoc
              AND Ccbadocu.nrodoc = Faccpedi.nroped
              NO-LOCK NO-ERROR.
      IF AVAILABLE CcbADocu THEN DO:
          CREATE T-CcbADocu.
          BUFFER-COPY CcbADocu TO T-CcbADocu
              ASSIGN
              T-CcbADocu.CodDiv = CcbADocu.CodDiv
              T-CcbADocu.CodDoc = CcbADocu.CodDoc
              T-CcbADocu.NroDoc = CcbADocu.NroDoc.
          RELEASE T-CcbADocu.
      END.      
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION D-Dialog 
PROCEDURE MASTER-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Ic - 01Feb2017, Macchiu, verifica si la serie es comprobantes DIFERIDOS */
    pEsSerieDiferido = NO.
    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia 
        AND vtatabla.tabla = 'NSERIE_DIFERIDO' 
        AND vtatabla.llave_c1 = COMBO-NroSer NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN DO:
        /* Maximo 7 dias */
        IF MONTH(TODAY - 7) = MONTH(TODAY)  THEN DO:
            MESSAGE "Imposible generar Comprobante con la serie seleccionada " SKIP
                    "esta fuera de fecha" VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        /* Buscamos la O/D diferida a generar */
        FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                vtatabla.tabla = 'ORDEN_DIFERIDO' AND
                                vtatabla.llave_c1 = faccpedi.coddoc AND
                                vtatabla.llave_c2 = faccpedi.nroped NO-LOCK NO-ERROR.
        IF NOT AVAILABLE vtatabla THEN DO:
            MESSAGE "La serie del comprobante es DIFERIDA" SKIP
                    "Pero la " + faccpedi.coddoc + "  no esta como DIFERIDA...ERROR" VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        pEsSerieDiferido = YES.
    END.  
    ELSE DO:
        /* Buscamos la O/D diferida a generar */
        FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                vtatabla.tabla = 'ORDEN_DIFERIDO' AND
                                vtatabla.llave_c1 = faccpedi.coddoc AND
                                vtatabla.llave_c2 = faccpedi.nroped NO-LOCK NO-ERROR.
        IF AVAILABLE vtatabla THEN DO:
            MESSAGE "La " + faccpedi.coddoc + " esta inscrita como DIFERIDA no le corresponde esta serie de Comprobante"
                     VIEW-AS ALERT-BOX ERROR.

                MESSAGE 'Desea Continuar con el proceso?' VIEW-AS ALERT-BOX QUESTION
                        BUTTONS YES-NO UPDATE rpta AS LOG.
                IF rpta = NO THEN DO:
                RETURN 'ADM-ERROR'.
            END.            
        END.
    END.
    /* Ic - 01Feb2017, FIN */
    SESSION:SET-WAIT-STATE('GENERAL').
    EMPTY TEMP-TABLE T-FELogErrores.    /* CONTROL DE ERRORES DE FACTURACION ELECTRONICA */
    pMensaje-2 = "DOCUMENTOS GENERADOS:" + CHR(10).

    DEFINE VAR x-veces AS INT.

    x-veces = 0.

    DEF VAR rwParaRowID AS ROWID NO-UNDO.
    rwParaRowID = ROWID(Faccpedi).
    RLOOP:
    REPEAT ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        EMPTY TEMP-TABLE Reporte.           /* Documentos Creados en la transacción */
        pMensaje = "".
        /* FIJAMOS EL PUNTERO DEL BUFFER EN LA O/D */
        {lib\lock-genericov3.i ~
            &Tabla="FacCPedi" ~
            &Condicion="ROWID(FacCPedi) = rwParaRowID" ~
            &Bloqueo="EXCLUSIVE-LOCK" ~
            &Accion="LEAVE" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje"
            &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'" ~
            }
        /* ******************************************************************************************** */
        /* TABLAS RELACIONADAS */
        /* ******************************************************************************************** */
        FIND FIRST PEDIDO WHERE PEDIDO.codcia = Faccpedi.codcia
            AND PEDIDO.coddoc = Faccpedi.codref
            AND PEDIDO.nroped = Faccpedi.nroref
            NO-LOCK.
        FIND FIRST COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
            AND COTIZACION.coddoc = PEDIDO.codref
            AND COTIZACION.nroped = PEDIDO.nroref
            NO-LOCK.
        /* ******************************************************************************************** */
        /* CARGAMOS SALDOS DE LA  O/D */
        /* ******************************************************************************************** */
        RUN Carga-Temporal.
        FIND FIRST PEDI NO-LOCK NO-ERROR.

        IF NOT AVAILABLE PEDI THEN LEAVE.   /* Ya no hay nada que facturar */
        
        /* ZONAS Y UBICACIONES, DESCUENTOS LISTA EXPRESS */
        RUN Resumen-Temporal.
        
        /* ******************************************************************************************** */
        /* FILTRO DE CONTROL */
        /* ******************************************************************************************** */
        IF NOT (FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "C") THEN DO:
            pMensaje = "Registro de O/D ya no está 'PENDIENTE'".
            UNDO RLOOP, LEAVE.
        END.

        /* ******************************************************************************************** */
        /* 1ra. TRANSACCION: COMPROBANTES */
        /* ******************************************************************************************** */
        RUN FIRST-TRANSACTION.
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: No se pudo generar el comprobante" .
            UNDO RLOOP, LEAVE.
        END.
        /* ******************************************************************************************** */
        /* 2da. TRANSACCION: E-POS */
        /* ******************************************************************************************** */
        RUN SECOND-TRANSACTION.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, LEAVE.
        /* ******************************************************************************************** */
        /* 3ro. GRABACIONES FINALES:  Cierra la O/D */
        /* ******************************************************************************************** */
        FIND FIRST Facdpedi OF Faccpedi WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0 NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Facdpedi THEN FacCPedi.FlgEst = "C".
        /* RHC 07/02/2017 Lista Express */
        IF COTIZACION.TpoPed = "LF" THEN FacCPedi.FlgEst = "C".
        FOR EACH Reporte NO-LOCK, FIRST Ccbcdocu OF Reporte NO-LOCK:
            pMensaje-2 = pMensaje-2 + Ccbcdocu.coddoc + ' ' + Ccbcdocu.nrodoc + CHR(10).
        END.

        x-veces = x-veces + 1.

    END.
    SESSION:SET-WAIT-STATE('').

    /* liberamos tablas */
    RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */
    FIND CURRENT FacCPedi NO-LOCK.

    IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
    IF AVAILABLE(Ccbcdocu) THEN FIND CURRENT Ccbcdocu NO-LOCK.  /* Para no peder el puntero */
    IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.
    IF AVAILABLE(Ccbadocu) THEN RELEASE Ccbadocu.
    IF AVAILABLE(B-ADOCU)  THEN RELEASE B-ADOCU.
    IF AVAILABLE(w-repor)  THEN RELEASE w-report.
    IF AVAILABLE(Gn-clie)  THEN RELEASE Gn-clie.
    IF AVAILABLE(Ccbccaja) THEN RELEASE Ccbccaja.
    IF pMensaje <> "" THEN DO:
        MESSAGE "Hubo Problemas para generar comprobante" SKIP
            pMensaje VIEW-AS ALERT-BOX ERROR.
        pMensaje = "".
        RETURN 'ADM-ERROR'.
    END.
    pMensaje = pMensaje-2.

    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros D-Dialog 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN ASSIGN input-var-1 = "".
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SECOND-TRANSACTION D-Dialog 
PROCEDURE SECOND-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR iNumOrden AS INT INIT 0 NO-UNDO.   /* COntrola la cantidad de comprobantes procesados */
pMensaje = "".
FOR EACH Reporte NO-LOCK, FIRST Ccbcdocu OF Reporte NO-LOCK:
    iNumOrden = iNumOrden + 1.
    /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
    RUN sunat\progress-to-ppll-v3.r  ( INPUT Ccbcdocu.coddiv,
                                     INPUT Ccbcdocu.coddoc,
                                     INPUT Ccbcdocu.nrodoc,
                                     INPUT-OUTPUT TABLE T-FELogErrores,
                                     OUTPUT pMensaje ).
    IF RETURN-VALUE <> "OK" THEN DO:
        IF RETURN-VALUE = 'ADM-ERROR' THEN IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR conexión de ePos".
        IF RETURN-VALUE = 'ERROR-EPOS' THEN IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR grabación de ePos".
        IF RETURN-VALUE = 'PLAN-B' THEN DO:
            pMensaje = ''.
            RETURN "PLAN-B".
        END.
        RETURN 'ADM-ERROR'.
    END.

    /* GRE - Grabar los comprobantes para la generacion de la GRE  */
    IF RETURN-VALUE = "OK" OR RETURN-VALUE = "PLAN-B" THEN DO:
        IF pTipMov = "ELECTRONICA" THEN DO:
            CREATE Gre_Cmpte.
            ASSIGN 
                Gre_Cmpte.coddoc = Ccbcdocu.coddoc
                Gre_Cmpte.nrodoc = Ccbcdocu.nrodoc
                Gre_Cmpte.coddivvta = Ccbcdocu.divori
                Gre_Cmpte.coddivdesp = Ccbcdocu.coddiv
                Gre_Cmpte.fechaemision = Ccbcdocu.fchdoc.
            IF Ccbcdocu.coddoc = 'FAI' THEN DO:
                ASSIGN Gre_Cmpte.estado_sunat = "ACEPTADO POR SUNAT".
            END.
            RELEASE Gre_Cmpte NO-ERROR.
        END.
    END.
END.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "PEDI"}
  {src/adm/template/snd-list.i "Almmmatg"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

