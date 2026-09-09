&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-ADocu FOR CcbADocu.
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-DDOCU FOR CcbDDocu.
DEFINE BUFFER CREDITO FOR CcbCDocu.
DEFINE BUFFER EGRESOC FOR CcbCCaja.
DEFINE BUFFER FACTURA FOR CcbCDocu.
DEFINE BUFFER GUIAS FOR CcbCDocu.
DEFINE BUFFER INGRESOC FOR CcbCCaja.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
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

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-CodDoc AS CHAR.
DEF SHARED VAR s-Tipo   AS CHAR.
DEF SHARED VAR s-NroSer AS INT.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.

DEF VAR s-Comprobante-OK AS LOG NO-UNDO.

DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR cListItems AS CHAR NO-UNDO.

DEF VAR cFlgEst AS CHAR NO-UNDO.
DEF VAR fSdoAct AS DEC  NO-UNDO.
DEF VAR fImpTot AS DEC  NO-UNDO.

/* Origen de los nuevos comprobantes */
DEF VAR pCodDiv AS CHAR INIT '00000' NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME x-NomCli-1

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES FECanje
&Scoped-define FIRST-EXTERNAL-TABLE FECanje


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FECanje.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS FECanje.CodDoc1 FECanje.NroDoc1 ~
FECanje.RucCli1 FECanje.ImpTot1 FECanje.CodCli1 FECanje.CodDoc2 ~
FECanje.NroSer2 FECanje.CodCli2 FECanje.NomCli2 FECanje.DirCli2 ~
FECanje.RucCli2 FECanje.DniCli2 FECanje.ImpTot2 FECanje.NroSer3 
&Scoped-define ENABLED-TABLES FECanje
&Scoped-define FIRST-ENABLED-TABLE FECanje
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 RECT-4 
&Scoped-Define DISPLAYED-FIELDS FECanje.NroDoc FECanje.FchDoc ~
FECanje.Usuario FECanje.CodDoc1 FECanje.NroDoc1 FECanje.RucCli1 ~
FECanje.ImpTot1 FECanje.CodCli1 FECanje.CodDoc2 FECanje.NroSer2 ~
FECanje.NroDoc2 FECanje.CodCli2 FECanje.NomCli2 FECanje.DirCli2 ~
FECanje.RucCli2 FECanje.DniCli2 FECanje.ImpTot2 FECanje.NroSer3 ~
FECanje.NroDoc3 
&Scoped-define DISPLAYED-TABLES FECanje
&Scoped-define FIRST-DISPLAYED-TABLE FECanje
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\b-buscar.ico":U
     LABEL "Button 1" 
     SIZE 6 BY 1.35 TOOLTIP "Buscar Comprobante".

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 5.19.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 6.92.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 2.88.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 1.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME x-NomCli-1
     FECanje.NroDoc AT ROW 1.19 COL 13 COLON-ALIGNED WIDGET-ID 46
          LABEL "Correlativo"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 14 FGCOLOR 0 
     FECanje.FchDoc AT ROW 1.19 COL 33 COLON-ALIGNED WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 14 FGCOLOR 0 
     FECanje.Usuario AT ROW 1.19 COL 51 COLON-ALIGNED WIDGET-ID 56
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 14 FGCOLOR 0 
     FECanje.CodDoc1 AT ROW 2.92 COL 13 COLON-ALIGNED WIDGET-ID 66
          LABEL "Documento" FORMAT "x(3)"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "FACTURA","FAC",
                     "BOLETA","BOL"
          DROP-DOWN-LIST
          SIZE 12 BY 1
     FECanje.NroDoc1 AT ROW 3.88 COL 13 COLON-ALIGNED WIDGET-ID 48
          LABEL "Número" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 0 
     BUTTON-1 AT ROW 3.88 COL 29 WIDGET-ID 72
     FECanje.RucCli1 AT ROW 4.85 COL 13 COLON-ALIGNED WIDGET-ID 50
          LABEL "Ruc"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FECanje.ImpTot1 AT ROW 5.81 COL 13 COLON-ALIGNED WIDGET-ID 44
          LABEL "Importe" FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FECanje.CodCli1 AT ROW 6.77 COL 13 COLON-ALIGNED WIDGET-ID 68
          LABEL "Cliente"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FILL-IN-1 AT ROW 6.77 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 70
     FECanje.CodDoc2 AT ROW 8.31 COL 13 COLON-ALIGNED WIDGET-ID 80
          LABEL "Documento"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "FACTURA","FAC",
                     "BOLETA","BOL"
          DROP-DOWN-LIST
          SIZE 12 BY 1
          BGCOLOR 11 FGCOLOR 0 
     FECanje.NroSer2 AT ROW 9.08 COL 13 COLON-ALIGNED WIDGET-ID 98
          LABEL "Nro. de Serie"
          VIEW-AS FILL-IN 
          SIZE 4 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FECanje.NroDoc2 AT ROW 9.85 COL 13 COLON-ALIGNED WIDGET-ID 62
          LABEL "Número"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FECanje.CodCli2 AT ROW 10.62 COL 13 COLON-ALIGNED WIDGET-ID 28
          LABEL "Cliente"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FECanje.NomCli2 AT ROW 11.38 COL 8.86 WIDGET-ID 90
          LABEL "Nombre"
          VIEW-AS FILL-IN 
          SIZE 64 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FECanje.DirCli2 AT ROW 12.15 COL 13 COLON-ALIGNED WIDGET-ID 86
          LABEL "Dirección"
          VIEW-AS FILL-IN 
          SIZE 64 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FECanje.RucCli2 AT ROW 12.92 COL 13 COLON-ALIGNED WIDGET-ID 64
          LABEL "Ruc"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FECanje.DniCli2 AT ROW 12.92 COL 40 COLON-ALIGNED WIDGET-ID 88
          LABEL "DNI"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FECanje.ImpTot2 AT ROW 13.69 COL 13 COLON-ALIGNED WIDGET-ID 60
          LABEL "Importe"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME x-NomCli-1
     FECanje.NroSer3 AT ROW 15.42 COL 13 COLON-ALIGNED WIDGET-ID 100
          LABEL "Nro. de Serie"
          VIEW-AS FILL-IN 
          SIZE 4 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FECanje.NroDoc3 AT ROW 16.19 COL 13 COLON-ALIGNED WIDGET-ID 104
          LABEL "Número"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     "Datos del Comprobante Original" VIEW-AS TEXT
          SIZE 22 BY .5 AT ROW 2.35 COL 4 WIDGET-ID 74
          BGCOLOR 9 FGCOLOR 15 
     "Datos de la Nota de Crédito por Devolución" VIEW-AS TEXT
          SIZE 30 BY .5 AT ROW 14.85 COL 4 WIDGET-ID 96
          BGCOLOR 9 FGCOLOR 15 
     "Datos del Comprobante Destino" VIEW-AS TEXT
          SIZE 22 BY .5 AT ROW 7.73 COL 4 WIDGET-ID 78
          BGCOLOR 9 FGCOLOR 15 
     RECT-1 AT ROW 2.54 COL 2 WIDGET-ID 76
     RECT-2 AT ROW 7.92 COL 2 WIDGET-ID 84
     RECT-3 AT ROW 15.04 COL 2 WIDGET-ID 102
     RECT-4 AT ROW 1 COL 2 WIDGET-ID 106
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.FECanje
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-ADocu B "?" ? INTEGRAL CcbADocu
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: B-DDOCU B "?" ? INTEGRAL CcbDDocu
      TABLE: CREDITO B "?" ? INTEGRAL CcbCDocu
      TABLE: EGRESOC B "?" ? INTEGRAL CcbCCaja
      TABLE: FACTURA B "?" ? INTEGRAL CcbCDocu
      TABLE: GUIAS B "?" ? INTEGRAL CcbCDocu
      TABLE: INGRESOC B "?" ? INTEGRAL CcbCCaja
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 17.85
         WIDTH              = 83.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME x-NomCli-1
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME x-NomCli-1:SCROLLABLE       = FALSE
       FRAME x-NomCli-1:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-1 IN FRAME x-NomCli-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FECanje.CodCli1 IN FRAME x-NomCli-1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FECanje.CodCli2 IN FRAME x-NomCli-1
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX FECanje.CodDoc1 IN FRAME x-NomCli-1
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR COMBO-BOX FECanje.CodDoc2 IN FRAME x-NomCli-1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FECanje.DirCli2 IN FRAME x-NomCli-1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FECanje.DniCli2 IN FRAME x-NomCli-1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FECanje.FchDoc IN FRAME x-NomCli-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME x-NomCli-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FECanje.ImpTot1 IN FRAME x-NomCli-1
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FECanje.ImpTot2 IN FRAME x-NomCli-1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FECanje.NomCli2 IN FRAME x-NomCli-1
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN FECanje.NroDoc IN FRAME x-NomCli-1
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FECanje.NroDoc1 IN FRAME x-NomCli-1
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FECanje.NroDoc2 IN FRAME x-NomCli-1
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FECanje.NroDoc3 IN FRAME x-NomCli-1
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FECanje.NroSer2 IN FRAME x-NomCli-1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FECanje.NroSer3 IN FRAME x-NomCli-1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FECanje.RucCli1 IN FRAME x-NomCli-1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FECanje.RucCli2 IN FRAME x-NomCli-1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FECanje.Usuario IN FRAME x-NomCli-1
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME x-NomCli-1
/* Query rebuild information for FRAME x-NomCli-1
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME x-NomCli-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 V-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME x-NomCli-1 /* Button 1 */
DO:
  FIND Ccbcdocu WHERE CcbCDocu.CodCia = s-codcia
      AND CcbCDocu.CodDiv = s-CodDiv
      AND CcbCDocu.CodDoc = INPUT FECanje.CodDoc1
      AND CcbCDocu.NroDoc = INPUT FECanje.NroDoc1
      AND CcbCDocu.RucCli = INPUT FECanje.RucCli1
      AND CcbCDocu.ImpTot = INPUT FECanje.ImpTot1
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE CcbCDocu THEN DO:
      MESSAGE 'Comprobante NO encontrado' SKIP
          'Intente de nuevo' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF Ccbcdocu.FlgEst = "A" THEN DO:
      MESSAGE "Comprobante ANULADO" SKIP
          'Intente de nuevo' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF NOT (Ccbcdocu.fchdoc = TODAY 
          AND Ccbcdocu.flgest = "C"
          AND Ccbcdocu.tipo = "MOSTRADOR")
      THEN DO:
      MESSAGE "El comprobante debe ser del día de HOY y pertenecer a MOSTRADOR" SKIP
          'Intente de nuevo' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  s-Comprobante-Ok = YES.
  /* Datos del Origen */
  ASSIGN
      FECanje.CodCli1:SCREEN-VALUE = CcbCDocu.CodCli
      FILL-IN-1:SCREEN-VALUE = CcbCDocu.NomCli.
  /* Datos del Destino */
  ASSIGN
      FECanje.CodCli2:SCREEN-VALUE = CcbCDocu.CodCli
      FECanje.NomCli2:SCREEN-VALUE = CcbCDocu.NomCli
      FECanje.DirCli2:SCREEN-VALUE = CcbCDocu.DirCli
      FECanje.DniCli2:SCREEN-VALUE = CcbCDocu.CodAnt
      FECanje.ImpTot2:SCREEN-VALUE = STRING(CcbCDocu.ImpTot).
  APPLY 'LEAVE':U TO FECanje.CodCli2.

  APPLY 'VALUE-CHANGED':U TO FECanje.CodDoc2.
  APPLY 'LEAVE':U TO FECanje.NroSer3.

  DISABLE 
      BUTTON-1
      FECanje.CodCli1 
      FECanje.CodDoc1 
      FECanje.ImpTot1 
      FECanje.NroDoc1 
      FECanje.RucCli1
      WITH FRAME {&FRAME-NAME}.
  APPLY 'ENTRY':U TO FECanje.CodDoc2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FECanje.CodCli2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FECanje.CodCli2 V-table-Win
ON LEAVE OF FECanje.CodCli2 IN FRAME x-NomCli-1 /* Cliente */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    RUN vtagn/p-gn-clie-01 (SELF:SCREEN-VALUE, FECanje.CodDoc1:SCREEN-VALUE).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    FIND gn-clie  WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = SELF:SCREEN-VALUE NO-LOCK.
    ASSIGN
        FECanje.DirCli2:SCREEN-VALUE = gn-clie.dircli
        FECanje.NomCli2:SCREEN-VALUE = gn-clie.nomcli
        FECanje.RucCli2:SCREEN-VALUE = gn-clie.ruc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FECanje.CodDoc1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FECanje.CodDoc1 V-table-Win
ON VALUE-CHANGED OF FECanje.CodDoc1 IN FRAME x-NomCli-1 /* Documento */
DO:
  FECanje.CodDoc2:SCREEN-VALUE = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FECanje.CodDoc2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FECanje.CodDoc2 V-table-Win
ON VALUE-CHANGED OF FECanje.CodDoc2 IN FRAME x-NomCli-1 /* Documento */
DO:
    /* Veamos si la serie está activa */
    FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia
        AND FacCorre.CodDiv = pCodDiv
        AND FacCorre.CodDoc = SELF:SCREEN-VALUE
        AND FacCorre.FlgEst = YES
        AND FacCorre.ID_Pos = 'CONTABILIDAD'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN DO:
        MESSAGE 'NO está definida la serie para el comprobante' SELF:SCREEN-VALUE 
            'en la división' pCodDiv VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    
    DEF VAR pFormato AS CHAR NO-UNDO.

    RUN sunat\p-formato-doc ( SELF:SCREEN-VALUE, OUTPUT pFormato ).
    s-Comprobante-Ok = YES.
    ASSIGN
        FECanje.NroSer2:SCREEN-VALUE = STRING(FacCorre.NroSer, '999')
        FECanje.NroDoc2:SCREEN-VALUE = STRING(FacCorre.NroSer, ENTRY(1,pFormato,'-')) + 
                                          STRING(FacCorre.Correlativo, ENTRY(2,pFormato,'-') ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FECanje.NroSer2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FECanje.NroSer2 V-table-Win
ON LEAVE OF FECanje.NroSer2 IN FRAME x-NomCli-1 /* Nro. de Serie */
DO:
    /* Veamos si la serie está activa */
    FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia
        AND FacCorre.CodDiv = pCodDiv
        AND FacCorre.CodDoc = FECanje.CodDoc2:SCREEN-VALUE
        AND FacCorre.NroSer = INTEGER(SELF:SCREEN-VALUE)
        AND FacCorre.FlgEst = YES
        AND FacCorre.ID_Pos = 'CONTABILIDAD'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN DO:
        MESSAGE 'NO está definida la serie para el comprobante' FECanje.CodDoc2:SCREEN-VALUE
            'en la división' pCodDiv VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    
    DEF VAR pFormato AS CHAR NO-UNDO.

    RUN sunat\p-formato-doc ( FECanje.CodDoc2:SCREEN-VALUE, OUTPUT pFormato ).
    s-Comprobante-Ok = YES.
    ASSIGN
        FECanje.NroSer2:SCREEN-VALUE = STRING(FacCorre.NroSer, '999')
        FECanje.NroDoc2:SCREEN-VALUE = STRING(FacCorre.NroSer, ENTRY(1,pFormato,'-')) + 
                                          STRING(FacCorre.Correlativo, ENTRY(2,pFormato,'-') ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FECanje.NroSer3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FECanje.NroSer3 V-table-Win
ON LEAVE OF FECanje.NroSer3 IN FRAME x-NomCli-1 /* Nro. de Serie */
DO:
    /* Veamos si la serie está activa */
    FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia
        AND FacCorre.CodDiv = pCodDiv
        AND FacCorre.CodDoc = "N/C"
        AND FacCorre.NroSer = INTEGER(SELF:SCREEN-VALUE)
        AND FacCorre.FlgEst = YES
        AND FacCorre.ID_Pos = 'CONTABILIDAD'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN DO:
        MESSAGE 'NO está definida la serie para la Nota de Crédito'
            'en la división' pCodDiv VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    
    DEF VAR pFormato AS CHAR NO-UNDO.

    RUN sunat\p-formato-doc ( "N/C", OUTPUT pFormato ).
    s-Comprobante-Ok = YES.
    ASSIGN
        FECanje.NroSer3:SCREEN-VALUE = STRING(FacCorre.NroSer, '999')
        FECanje.NroDoc3:SCREEN-VALUE = STRING(FacCorre.NroSer, ENTRY(1,pFormato,'-')) + 
                                          STRING(FacCorre.Correlativo, ENTRY(2,pFormato,'-') ).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-ePos-FAC V-table-Win 
PROCEDURE Actualiza-ePos-FAC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* RHC SUNAT: FACTURA */
/*     RUN sunat\progress-to-ppll-v2 ( INPUT ROWID(FACTURA), OUTPUT pMensaje ). */
    RUN sunat\progress-to-ppll-v3( INPUT FACTURA.coddiv,
                                   INPUT FACTURA.coddoc,
                                   INPUT FACTURA.nrodoc,
                                   INPUT-OUTPUT TABLE T-FELogErrores,
                                   OUTPUT pMensaje ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "ERROR grabación de ePos".
        RETURN 'ADM-ERROR'.     /* ROLL-BACK */
    END.
    IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
        IF pMensaje = "" THEN pMensaje = "ERROR confirmación de ePos".
        RETURN 'ERROR-EPOS'.     /* EXTORNO */
    END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-ePos-NC V-table-Win 
PROCEDURE Actualiza-ePos-NC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* RHC SUNAT: NOTA DE CREDITO */
/*     RUN sunat\progress-to-ppll-v2 ( INPUT ROWID(CREDITO), OUTPUT pMensaje ). */
    RUN sunat\progress-to-ppll-v3( INPUT CREDITO.coddiv,
                                   INPUT CREDITO.coddoc,
                                   INPUT CREDITO.nrodoc,
                                   INPUT-OUTPUT TABLE T-FELogErrores,
                                   OUTPUT pMensaje ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "ERROR grabación de ePos".
        RETURN 'ADM-ERROR'.     /* ROLL-BACK */
    END.
    IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
        IF pMensaje = "" THEN pMensaje = "ERROR confirmación de ePos".
        RETURN 'ERROR-EPOS'.     /* EXTORNO */
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "FECanje"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FECanje"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME x-NomCli-1.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorna-Comprobantes V-table-Win 
PROCEDURE Extorna-Comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Extornamos N/C */
    /* Anulamos la nueva NOTA DE CREDITO */
    ASSIGN
        CREDITO.sdoact = 0
        CREDITO.fchcan = ?
        CREDITO.flgest = "A"
        CREDITO.FchAnu = TODAY
        CREDITO.UsuAnu = S-USER-ID.
    /* DESCARGA ALMACENES */
    RUN vta2/anula-ing-devo-utilex (ROWID(CREDITO)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    /* CONTROL DE PERCEPCIONES POR ABONOS */
    FOR EACH CcbCDocu WHERE CcbCDocu.codcia = CREDITO.codcia
        AND CcbCDocu.coddiv = CREDITO.coddiv
        AND CcbCDocu.coddoc = "PRC"
        AND CcbCDocu.codref = CREDITO.coddoc
        AND CcbCDocu.nroref = CREDITO.nrodoc:
        CcbCDocu.flgest = "A".
    END.
    /* Extorna E/C */
    ASSIGN
        EGRESOC.FlgEst = "A"
        EGRESOC.UsrAnu = s-user-id
        EGRESOC.HorAnu = STRING(TIME, 'HH:MM:SS').
    /* Extorno FAC */
    /* Anulamos la nueva FACTURA */
    ASSIGN
        FACTURA.sdoact = 0
        FACTURA.fchcan = ?
        FACTURA.flgest = "A"
        FACTURA.FchAnu = TODAY
        FACTURA.UsuAnu = S-USER-ID.
    /* Extorna Salida de Almacen */
    RUN vta2/des_alm (ROWID(FACTURA)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    /* CONTROL DE PERCEPCIONES POR CARGOS */
    FOR EACH CcbCDocu WHERE CcbCDocu.codcia = B-CDOCU.codcia
        AND CcbCDocu.coddiv = B-CDOCU.coddiv
        AND CcbCDocu.coddoc = "PRC"
        AND CcbCDocu.codref = B-CDOCU.coddoc
        AND CcbCDocu.nroref = B-CDOCU.nrodoc:
        CcbCDocu.flgest = "P".
    END.
    /* CONTROL DE PERCEPCIONES POR CARGOS */
    FOR EACH CcbCDocu WHERE CcbCDocu.codcia = FACTURA.codcia
        AND CcbCDocu.coddiv = FACTURA.coddiv
        AND CcbCDocu.coddoc = "PRC"
        AND CcbCDocu.codref = FACTURA.coddoc
        AND CcbCDocu.nroref = FACTURA.nrodoc:
        CcbCDocu.flgest = "A".
    END.
    /* Extorna I/C */
    ASSIGN
        INGRESOC.FlgEst = "A"
        INGRESOC.UsrAnu = s-user-id
        INGRESOC.HorAnu = STRING(TIME, 'HH:MM:SS').
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorna-CREDITO V-table-Win 
PROCEDURE Extorna-CREDITO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Anulamos la nueva NOTA DE CREDITO */
    ASSIGN
        CREDITO.sdoact = 0
        CREDITO.fchcan = ?
        CREDITO.flgest = "A"
        CREDITO.FchAnu = TODAY
        CREDITO.UsuAnu = S-USER-ID.
    /* DESCARGA ALMACENES */
    RUN vta2/anula-ing-devo-utilex (ROWID(CREDITO)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    /* CONTROL DE PERCEPCIONES POR ABONOS */
    FOR EACH CcbCDocu WHERE CcbCDocu.codcia = CREDITO.codcia
        AND CcbCDocu.coddiv = CREDITO.coddiv
        AND CcbCDocu.coddoc = "PRC"
        AND CcbCDocu.codref = CREDITO.coddoc
        AND CcbCDocu.nroref = CREDITO.nrodoc:
        CcbCDocu.flgest = "A".
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorna-FACTURA V-table-Win 
PROCEDURE Extorna-FACTURA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Anulamos la nueva FACTURA */
    ASSIGN
        FACTURA.sdoact = 0
        FACTURA.fchcan = ?
        FACTURA.flgest = "A"
        FACTURA.FchAnu = TODAY
        FACTURA.UsuAnu = S-USER-ID.
    /* Extorna Salida de Almacen */
    RUN vta2/des_alm (ROWID(FACTURA)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    /* CONTROL DE PERCEPCIONES POR CARGOS */
    FOR EACH CcbCDocu WHERE CcbCDocu.codcia = B-CDOCU.codcia
        AND CcbCDocu.coddiv = B-CDOCU.coddiv
        AND CcbCDocu.coddoc = "PRC"
        AND CcbCDocu.codref = B-CDOCU.coddoc
        AND CcbCDocu.nroref = B-CDOCU.nrodoc:
        CcbCDocu.flgest = "P".
    END.
    /* CONTROL DE PERCEPCIONES POR CARGOS */
    FOR EACH CcbCDocu WHERE CcbCDocu.codcia = FACTURA.codcia
        AND CcbCDocu.coddiv = FACTURA.coddiv
        AND CcbCDocu.coddoc = "PRC"
        AND CcbCDocu.codref = FACTURA.coddoc
        AND CcbCDocu.nroref = FACTURA.nrodoc:
        CcbCDocu.flgest = "A".
    END.
    /* ********************************************* */
    /* Anulamos G/R */
    FOR EACH GUIAS WHERE GUIAS.codcia = FACTURA.codcia
        AND GUIAS.CodDiv = FACTURA.CodDiv
        AND GUIAS.coddoc = "G/R"
        AND GUIAS.CodRef = FACTURA.CodDoc
        AND GUIAS.NroRef = FACTURA.NroDoc
        AND GUIAS.FlgEst = "F":
        GUIAS.FlgEst = "A".
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIRST-TRANSACTION V-table-Win 
PROCEDURE FIRST-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia
        AND B-CDOCU.coddoc = FECanje.CodDoc1
        AND B-CDOCU.nrodoc = FECanje.NroDoc1
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDOCU THEN DO:
        pMensaje = "NO se pudo ubicar el Comprobante:"  + FECanje.CodDoc1 + ' ' + FECanje.NroDoc1.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        cFlgEst = B-CDOCU.FlgEst
        fSdoAct = B-CDOCU.SdoAct
        fImpTot = B-CDOCU.ImpTot.
    /* 1ro NOTA DE CREDITO + DEVOLUCION DE MERCADERIA */
    RUN Genera-NC.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "NO se pudo generar la devolución de mercadería".
        UNDO, LEAVE.
    END.
    
    /* 2do E/C EFECTIVO */
    RUN Genera-EC.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "NO se pudo generar la devolución de efectivo".
        UNDO, LEAVE.
    END.
    
    /* 3ro NUEVA FACTURA + SALIDA DE ALMACEN */
    RUN Genera-FAC.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "NO se pudo generar el nuevo comprobante".
        UNDO, LEAVE.
    END.
    
    /* 4to I/C EFECTIVO */
    RUN Genera-IC.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "NO se pudo generar el ingreso a caja".
        UNDO, LEAVE.
    END.
    
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Comprobantes V-table-Win 
PROCEDURE Genera-Comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* NOTA: VAMOS A DIVIDIR LAS TRANSACCIONES EN SUB-TRANSACCIONES */
FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
RLOOP:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /* 1ra. TRANSACCION: GENERACION DE FACTURA */
    RUN FIRST-TRANSACTION.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "ERROR: No se pudo generar los comprobantes" .
        UNDO RLOOP,LEAVE RLOOP.
    END.
    /* ACTUALIZAMOS E-POS FAC */
    RUN Actualiza-ePos-FAC.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "ERROR: No se pudo generar el e-Pos FACTURA".
        UNDO, LEAVE.
    END.
    IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
        RUN Extorna-Comprobantes.    /* EXTORNO */
        IF pMensaje = "" THEN pMensaje = "ERROR: No se pudo confirmar el e-Pos FACTURA" .
        LEAVE RLOOP.
    END.
    /* ACTUALIZAMOS E-POS N/C */
    RUN Actualiza-ePos-NC.
    IF RETURN-VALUE = 'ADM-ERROR' OR RETURN-VALUE = 'ERROR-EPOS' THEN DO:
        RUN Extorna-FACTURA.    /* EXTORNO */
        IF pMensaje = "" THEN pMensaje = "ERROR: No se pudo genera o confirmar el e-Pos NOTA DE CREDITO" .
        LEAVE RLOOP.
    END.
END.
IF AVAILABLE(B-CDOCU)  THEN RELEASE B-CDOCU.
IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
IF AVAILABLE(FACTURA)  THEN RELEASE FACTURA.
IF AVAILABLE(B-DDOCU)  THEN RELEASE B-DDOCU.

IF pMensaje > "" THEN DO:
    MESSAGE pMensaje SKIP
        "Salir del sistema, volver a entrar y vuelva a intentarlo."
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-DEV V-table-Win 
PROCEDURE Genera-DEV :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN vta2/ing-devo-utilex (ROWID(B-CDOCU)).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        pMensaje = "NO se pudo generar la devolución de mercaderia".
        RETURN "ADM-ERROR".
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-EC V-table-Win 
PROCEDURE Genera-EC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR s-CodDoc AS CHAR INIT 'E/C' NO-UNDO.
DEF VAR s-Tipo   AS CHAR INIT 'DEVONC' NO-UNDO.
DEF VAR f-CodDoc AS CHAR INIT "N/C" NO-UNDO.
DEF VAR s-ptovta AS INT NO-UNDO.

FIND CcbDTerm WHERE  CcbDTerm.CodCia = s-codcia 
    AND CcbDTerm.CodDiv = s-coddiv 
    AND CcbDTerm.CodDoc = s-coddoc 
    AND CcbDTerm.CodTer = s-codter NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbdterm THEN DO:
    pMensaje = "Egreso de caja no esta configurado en este terminal".
    RETURN "ADM-ERROR".
END.
s-ptovta = CcbDTerm.NroSer.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR': 
    /* Correlativo */
    {lib\lock-genericov21.i &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = s-CodCia ~
        AND FacCorre.CodDoc = s-CodDoc ~
        AND FacCorre.NroSer = s-PtoVta" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }

    FIND LAST gn-tccja WHERE gn-tccja.Fecha <= CREDITO.FchDoc NO-LOCK NO-ERROR.
    CREATE EGRESOC.
    ASSIGN
        EGRESOC.CodCia  = s-codcia
        EGRESOC.CodDoc  = s-coddoc
        EGRESOC.NroDoc  = STRING(faccorre.nroser, "999") + STRING(faccorre.correlativo, "999999")
        EGRESOC.CodDiv  = S-CODDIV
        EGRESOC.Tipo    = s-tipo
        EGRESOC.usuario = s-user-id
        EGRESOC.CodCaja = S-CODTER
        EGRESOC.FchDoc  = CREDITO.FchDoc   
        EGRESOC.TpoCmb  = (IF AVAILABLE gn-tccja THEN gn-tccja.Compra ELSE 1)
        EGRESOC.ImpNac[1] = (IF CREDITO.CodMon = 1 THEN CREDITO.ImpTot ELSE 0)
        EGRESOC.ImpUsa[1] = (IF CREDITO.CodMon = 2 THEN CREDITO.ImpTot ELSE 0)
        EGRESOC.Flgest    = "C"
        EGRESOC.Voucher[1] = CREDITO.CodDoc + CREDITO.NroDoc
        EGRESOC.CodCli  = CREDITO.CodCli
        EGRESOC.NomCli  = CREDITO.NomCli
        EGRESOC.Voucher[10] = STRING(TIME,"HH:MM:SS")
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Correlativo del E/C mal registrado o duplicado".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    CREATE CcbDCaja.
    ASSIGN
        CcbDCaja.CodCia = EGRESOC.CodCia   
        CcbDCaja.CodDiv = EGRESOC.CodDiv
        CcbDCaja.CodDoc = EGRESOC.CodDoc
        CcbDCaja.NroDoc = EGRESOC.NroDoc
        CcbDCaja.CodMon = CREDITO.CodMon
        CcbDCaja.CodRef = EGRESOC.CodDoc
        CcbDCaja.NroRef = EGRESOC.NroDoc
        CcbDCaja.FchDoc = EGRESOC.FchDoc
        CcbDCaja.TpoCmb = EGRESOC.TpoCmb.
    IF CREDITO.CodMon = 1 THEN DO:
        CcbDCaja.ImpTot = EGRESOC.ImpNac[1].
    END.
    IF CREDITO.CodMon = 2 THEN DO:
        CcbDCaja.ImpTot = EGRESOC.ImpUsa[1].
    END.
    /* CANCELACION DE LA N/C */
    CREATE CCBDMOV.
    ASSIGN
        CCBDMOV.CodCia = EGRESOC.CodCia
        CCBDMOV.CodDiv = EGRESOC.CodDiv
        CCBDMOV.CodCli = CREDITO.CodCli
        CCBDMOV.CodDoc = CREDITO.CodDoc
        CCBDMOV.NroDoc = CREDITO.NroDoc
        CCBDMOV.CodMon = CREDITO.CodMon
        CCBDMOV.CodRef = EGRESOC.CodDoc
        CCBDMOV.NroRef = EGRESOC.NroDoc
        CCBDMOV.FchDoc = CREDITO.FchDoc
        CCBDMOV.TpoCmb = EGRESOC.TpoCmb
        CCBDMOV.FchMov = TODAY
        CCBDMOV.HraMov = STRING("HH:MM:SS")
        CCBDMOV.usuario = s-User-ID.
    IF CREDITO.CodMon = 1 THEN DO:
        IF EGRESOC.ImpNac[1] <> 0 THEN ASSIGN CCBDMOV.ImpTot = EGRESOC.ImpNac[1].
        ELSE ASSIGN CCBDMOV.ImpTot = EGRESOC.Impusa[1] * EGRESOC.TpoCmb.
    END.
    ELSE DO:
        IF EGRESOC.ImpUsa[1] <> 0 THEN ASSIGN CCBDMOV.ImpTot = EGRESOC.ImpUsa[1].
        ELSE ASSIGN CCBDMOV.ImpTot = EGRESOC.ImpNac[1] / EGRESOC.TpoCmb.
    END.
    ASSIGN 
        CCBDMOV.ImpTot = ROUND(CCBDMOV.ImpTot,2).
    /* CANCELAMOS LA N/C */
    ASSIGN 
        CREDITO.SdoAct = 0
        CREDITO.FlgEst = "C"
        CREDITO.FchCan = TODAY.

    IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
    IF AVAILABLE(CcbDCaja) THEN RELEASE CcbDCaja.
    IF AVAILABLE(CCBDMOV)  THEN RELEASE CCBDMOV.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-FAC V-table-Win 
PROCEDURE Genera-FAC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Correlativo */
    {lib\lock-genericov21.i &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = s-CodCia ~
        AND FacCorre.CodDoc = FECanje.CodDoc2 ~
        AND FacCorre.NroSer = FECanje.NroSer2" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
        
    DEF VAR pFormato AS CHAR NO-UNDO.
    RUN sunat\p-formato-doc (B-CDOCU.coddoc, OUTPUT pFormato).
    CREATE FACTURA.
    BUFFER-COPY B-CDOCU
        TO FACTURA
        ASSIGN
        FACTURA.CodCli = FECanje.CodCli2
        FACTURA.NomCli = FECanje.NomCli2 
        FACTURA.DirCli = FECanje.DirCli2
        FACTURA.RucCli = FECanje.RucCli2
        FACTURA.CodAnt = FECanje.DniCli2
        FACTURA.NroDoc = STRING(FacCorre.NroSer, ENTRY(1,pFormato,'-')) +
                                STRING(FacCorre.Correlativo, ENTRY(2,pFormato,'-'))
        FACTURA.Usuario= s-user-id
        FACTURA.FlgCie = "P"        /* OJO */
        FACTURA.CodCaja= s-CodTer
        FACTURA.NroSal = B-CDOCU.CodDoc + B-CDOCU.NroDoc    /* OJO: EL ORIGEN */
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Correlativo del comprobante mal registrado o duplicado".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
        CREATE Ccbddocu.
        BUFFER-COPY B-DDOCU
            TO Ccbddocu
            ASSIGN
            CcbDDocu.CodCli = FACTURA.CodCli
            CcbDDocu.FchDoc = FACTURA.FchDoc
            CcbDDocu.NroDoc = FACTURA.NroDoc
            CcbDDocu.CanDev = 0
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "Correlativo del comprobante mal registrado o duplicado".
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
    END.
    /* ACTUALIZAMOS ALMACENES */
    RUN vta2/act_almv2 ( INPUT ROWID(FACTURA), OUTPUT pMensaje ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = "ERROR: NO se pudo actualizar el Kardex".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* Actualizamo la referencia */
    ASSIGN
         FECanje.NroDoc2 = FACTURA.NroDoc.

    RELEASE FacCorre.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-GR V-table-Win 
PROCEDURE Genera-GR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST GUIAS WHERE GUIAS.codcia = B-CDOCU.codcia
    AND GUIAS.CodDiv = B-CDOCU.CodDiv
    AND GUIAS.coddoc = "G/R"
    AND GUIAS.CodRef = B-CDOCU.CodDoc
    AND GUIAS.NroRef = B-CDOCU.NroDoc
    AND GUIAS.FlgEst = "F"
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE GUIAS THEN RETURN.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Correlativo */
    {lib\lock-genericov21.i &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = s-CodCia ~
        AND FacCorre.CodDoc = 'G/R' ~
        AND FacCorre.NroSer = INTEGER(SUBSTRING(GUIAS.nrodoc,1,3))" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
        
    DEF VAR pFormato AS CHAR NO-UNDO.
    RUN sunat\p-formato-doc ("G/R", OUTPUT pFormato).

    FOR EACH GUIAS WHERE GUIAS.codcia = B-CDOCU.codcia
        AND GUIAS.CodDiv = B-CDOCU.CodDiv
        AND GUIAS.coddoc = "G/R"
        AND GUIAS.CodRef = B-CDOCU.CodDoc
        AND GUIAS.NroRef = B-CDOCU.NroDoc
        AND GUIAS.FlgEst = "F":
        CREATE Ccbcdocu.
        BUFFER-COPY GUIAS 
            TO Ccbcdocu
            ASSIGN
            Ccbcdocu.NroDoc = STRING(FacCorre.NroSer, ENTRY(1,pFormato,'-')) +
                                    STRING(FacCorre.Correlativo, ENTRY(2,pFormato,'-'))
            Ccbcdocu.CodRef = FACTURA.CodDoc
            Ccbcdocu.NroRef = FACTURA.NroDoc
            Ccbcdocu.CodCli = FACTURA.CodCli
            Ccbcdocu.DirCli = FACTURA.DirCli
            Ccbcdocu.NomCli = FACTURA.NomCli
            Ccbcdocu.RucCli = FACTURA.RucCli
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "ERROR al generar las G/R".
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
        /* Datos del Transportista */
        FIND Ccbadocu WHERE Ccbadocu.codcia = GUIAS.codcia
            AND Ccbadocu.coddiv = GUIAS.coddiv
            AND Ccbadocu.coddoc = GUIAS.coddoc
            AND Ccbadocu.nrodoc = GUIAS.nroped
            NO-LOCK NO-ERROR.
        IF AVAILABLE Ccbadocu THEN DO:
            CREATE B-ADOCU.
            BUFFER-COPY CcbADocu 
                TO B-ADOCU
                ASSIGN
                B-ADOCU.CodCia = Ccbcdocu.CodCia
                B-ADOCU.CodDiv = Ccbcdocu.CodDiv
                B-ADOCU.CodDoc = Ccbcdocu.CodDoc
                B-ADOCU.NroDoc = Ccbcdocu.NroDoc
                NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pMensaje = "NO se pudo generar el control del transportista".
                UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-IC V-table-Win 
PROCEDURE Genera-IC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEF VAR s-CodCja AS CHAR INIT 'I/C' NO-UNDO.
    DEF VAR s-SerCja AS INT INIT 000 NO-UNDO.
    DEF VAR s-Tipo   AS CHAR INIT 'MOSTRADOR' NO-UNDO.

    FIND FIRST ccbdterm WHERE CcbDTerm.CodCia = s-codcia 
        AND CcbDTerm.CodDiv = s-coddiv 
        AND CcbDTerm.CodDoc = s-codcja 
        AND CcbDTerm.CodTer = s-codter NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ccbdterm THEN DO:
        pMensaje = "EL DOCUMENTO INGRESO DE CAJA NO ESTA CONFIGURADO EN ESTE TERMINAL".
        RETURN "ADM-ERROR".
    END.
    s-SerCja = ccbdterm.nroser.

    FIND LAST Gn-tccja WHERE Gn-tccja.Fecha <= TODAY NO-LOCK NO-ERROR.
    
    trloop:
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        {lib\lock-genericov21.i &Tabla="FacCorre" ~
            &Condicion="FacCorre.CodCia = s-codcia ~
            AND FacCorre.CodDiv = s-coddiv ~
            AND FacCorre.CodDoc = s-codcja ~
            AND FacCorre.NroSer = s-sercja" ~
            &Bloqueo="EXCLUSIVE-LOCK" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &TipoError="UNDO, RETURN 'ADM-ERROR'" }
        /* Crea Cabecera de Caja */
        CREATE INGRESOC.
        ASSIGN
            INGRESOC.CodCia     = s-CodCia
            INGRESOC.CodDiv     = s-CodDiv 
            INGRESOC.CodDoc     = s-CodCja
            INGRESOC.NroDoc     = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            INGRESOC.CodCaja    = s-CodTer
            INGRESOC.usuario    = s-user-id
            INGRESOC.CodCli     = FACTURA.codcli
            INGRESOC.NomCli     = FACTURA.NomCli
            INGRESOC.CodMon     = FACTURA.CodMon
            INGRESOC.FchDoc     = FACTURA.FchDoc
            INGRESOC.ImpNac[1]  = (IF FACTURA.CodMon = 1 THEN FACTURA.ImpTot ELSE 0)
            INGRESOC.ImpUsa[1]  = (IF FACTURA.CodMon = 2 THEN FACTURA.ImpTot ELSE 0)
            INGRESOC.Tipo       = s-Tipo
            INGRESOC.TpoCmb     = (IF AVAILABLE Gn-TcCja THEN Gn-tccja.compra ELSE 1)
            INGRESOC.FLGEST     = "C".
        ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
        /* Crea Detalle de Caja */
        CREATE CcbDCaja.
        ASSIGN
            CcbDCaja.CodCia = INGRESOC.CodCia
            CcbdCaja.CodDiv = INGRESOC.CodDiv
            CcbDCaja.CodDoc = INGRESOC.CodDoc
            CcbDCaja.NroDoc = INGRESOC.NroDoc
            CcbDCaja.CodRef = FACTURA.CodDoc
            CcbDCaja.NroRef = FACTURA.NroDoc
            CcbDCaja.CodCli = FACTURA.CodCli
            CcbDCaja.CodMon = FACTURA.CodMon
            CcbDCaja.FchDoc = INGRESOC.FchDoc
            CcbDCaja.ImpTot = FACTURA.ImpTot
            CcbDCaja.TpoCmb = INGRESOC.TpoCmb.

        IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
        IF AVAILABLE(CcbDCaja) THEN RELEASE CcbDCaja.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-NC V-table-Win 
PROCEDURE Genera-NC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR s-CodDoc AS CHAR INIT 'N/C' NO-UNDO.
DEF VAR s-NroSer AS INT NO-UNDO.
DEF VAR x-Formato AS CHAR NO-UNDO.
DEF VAR i AS INT NO-UNDO.

s-NroSer = FECanje.NroSer3.
RUN sunat\p-formato-doc ( s-CodDoc, OUTPUT x-Formato ).

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Correlativo */
    {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}

    CREATE CREDITO.
    BUFFER-COPY B-CDOCU
        EXCEPT B-CDOCU.CodRef B-CDOCU.NroRef B-CDOCU.Glosa B-CDOCU.NroOrd
        TO CREDITO
        ASSIGN 
        CREDITO.CodCia = B-CDOCU.CodCia
        CREDITO.CodDiv = B-CDOCU.CodDiv
        CREDITO.CodDoc = "N/C"
        CREDITO.NroDoc = STRING(FacCorre.NroSer, ENTRY(1, x-Formato, '-')) +
                          STRING(FacCorre.Correlativo, ENTRY(2, x-Formato, '-'))
        CREDITO.FchVto = ADD-INTERVAL (CREDITO.FchDoc, 1, 'years')
        CREDITO.FlgEst = "P"
        CREDITO.TpoCmb = FacCfgGn.TpoCmb[1]
        CREDITO.CndCre = 'D'
        CREDITO.Tipo    = B-CDOCU.Tipo
        CREDITO.CodCaja = B-CDOCU.CodCaja
        CREDITO.usuario = S-USER-ID
        CREDITO.SdoAct  = B-CDOCU.ImpTot
        CREDITO.ImpTot2 = 0
        CREDITO.ImpDto2 = 0
        CREDITO.CodAlm  = B-CDOCU.CodAlm
        CREDITO.CodMov  = 09.     /* INGRESO POR DEVOLUCION DEL CLIENTE */
    ASSIGN
        CREDITO.CodRef = B-CDOCU.CodDoc
        CREDITO.NroRef = B-CDOCU.NroDoc
        CREDITO.CodAnt = FECanje.DniCli2.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
    FIND GN-VEN WHERE gn-ven.codcia = s-codcia
        AND gn-ven.codven = B-CDOCU.codven
        NO-LOCK NO-ERROR.
    IF AVAILABLE GN-VEN THEN CREDITO.cco = gn-ven.cco.
   
    i = 1.
    FOR EACH B-DDOCU OF B-CDOCU:
        CREATE CcbDDocu.
        ASSIGN 
            CcbDDocu.NroItm = i
            CcbDDocu.CodCia = CREDITO.CodCia 
            CcbDDocu.Coddiv = CREDITO.Coddiv 
            CcbDDocu.CodDoc = CREDITO.CodDoc 
            CcbDDocu.NroDoc = CREDITO.NroDoc
            CcbDDocu.CodMat = B-DDOCU.codmat 
            CcbDDocu.PreUni = B-DDOCU.PreUni 
            CcbDDocu.CanDes = B-DDOCU.CanDes 
            CcbDDocu.Factor = B-DDOCU.Factor 
            CcbDDocu.ImpIsc = B-DDOCU.ImpIsc
            CcbDDocu.ImpIgv = B-DDOCU.ImpIgv 
            CcbDDocu.ImpLin = B-DDOCU.ImpLin
            CcbDDocu.AftIgv = B-DDOCU.AftIgv
            CcbDDocu.AftIsc = B-DDOCU.AftIsc
            CcbDDocu.UndVta = B-DDOCU.UndVta
            CcbDDocu.ImpCto = B-DDOCU.ImpCto.
        ASSIGN
            B-DDOCU.candev = B-DDOCU.candes.
        i = i + 1.
    END.
    ASSIGN 
        CREDITO.FlgCon = "D".

    /* TOTALES */
    DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
    DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.

    ASSIGN
        CREDITO.ImpDto = 0
        CREDITO.ImpIgv = 0
        CREDITO.ImpIsc = 0
        CREDITO.ImpTot = 0
        CREDITO.ImpExo = 0.
    FOR EACH Ccbddocu OF CREDITO NO-LOCK:        
       F-Igv = F-Igv + Ccbddocu.ImpIgv.
       F-Isc = F-Isc + Ccbddocu.ImpIsc.
       CREDITO.ImpTot = CREDITO.ImpTot + Ccbddocu.ImpLin.
       IF NOT Ccbddocu.AftIgv THEN CREDITO.ImpExo = CREDITO.ImpExo + Ccbddocu.ImpLin.
       IF Ccbddocu.AftIgv = YES
       THEN CREDITO.ImpDto = CREDITO.ImpDto + ROUND(Ccbddocu.ImpDto / (1 + CREDITO.PorIgv / 100), 2).
       ELSE CREDITO.ImpDto = CREDITO.ImpDto + Ccbddocu.ImpDto.
    END.
    ASSIGN
        CREDITO.ImpIgv = ROUND(F-IGV,2)
        CREDITO.ImpIsc = ROUND(F-ISC,2)
        CREDITO.ImpVta = CREDITO.ImpTot - CREDITO.ImpExo - CREDITO.ImpIgv.
    /* RHC 22.12.06 */
    IF CREDITO.PorDto > 0 THEN DO:
        CREDITO.ImpDto = CREDITO.ImpDto + ROUND((CREDITO.ImpVta + CREDITO.ImpExo) * CREDITO.PorDto / 100, 2).
        CREDITO.ImpTot = ROUND(CREDITO.ImpTot * (1 - CREDITO.PorDto / 100),2).
        CREDITO.ImpVta = ROUND(CREDITO.ImpVta * (1 - CREDITO.PorDto / 100),2).
        CREDITO.ImpExo = ROUND(CREDITO.ImpExo * (1 - CREDITO.PorDto / 100),2).
        CREDITO.ImpIgv = CREDITO.ImpTot - CREDITO.ImpExo - CREDITO.ImpVta.
    END.
    ASSIGN
        CREDITO.ImpBrt = CREDITO.ImpVta + CREDITO.ImpDto
        CREDITO.SdoAct  = CREDITO.ImpTot.
  
  /* CALCULO DE PERCEPCIONES */
  RUN vta2/calcula-percepcion-abonos ( ROWID(CREDITO) ).
  FIND CURRENT CREDITO.

  /* Movimiento de Ingreso al Almacén */
  RUN vta2/ing-devo-utilex (ROWID(CREDITO)).
  IF RETURN-VALUE = "ADM-ERROR" THEN DO:
      pMensaje = 'NO se pudo hacer la devolución de la mercadería'.
      UNDO, RETURN "ADM-ERROR".
  END.

  /* Actualizamo la referencia */
  ASSIGN
      FECanje.NroDoc3 = CREDITO.NroDoc.

  
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND FacCorr WHERE FacCorre.CodCia = s-codcia 
      AND FacCorre.CodDiv = s-coddiv
      AND FacCorre.CodDoc = s-coddoc
      AND FacCorre.NroSer = s-nroser
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre OR FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Correlativo bloqueado' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN FECanje.CodDoc1:SCREEN-VALUE = 'FAC'.
      /* Datos del Comprobante Destino */
      IF CAN-FIND(FIRST FacCorre WHERE FacCorre.CodCia = s-codcia 
                  AND FacCorre.CodDiv = pCodDiv
                  AND FacCorre.CodDoc = "FAC"  
                  AND FacCorre.ID_Pos = 'CONTABILIDAD'
                  AND FacCorre.FlgEst = YES NO-LOCK)
          THEN ASSIGN FECanje.CodDoc2:SCREEN-VALUE = "FAC".
      ELSE ASSIGN FECanje.CodDoc2:SCREEN-VALUE = "BOL".
      APPLY 'VALUE-CHANGED':U TO FECanje.CodDoc2.
      /* Datos de la Nota de Crédito por Devolución */
      FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia
          AND FacCorre.CodDiv = pCodDiv
          AND FacCorre.CodDoc = "N/C"
          AND FacCorre.FlgEst = YES
          AND FacCorre.ID_Pos = 'CONTABILIDAD'
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN FECanje.NroSer3:SCREEN-VALUE = STRING(FacCorre.NroSer, '999').
      APPLY 'LEAVE':U TO FECanje.NroSer3.
  END.
  s-Comprobante-Ok = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       NO HAY MODIFICACION NI ANULACION
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* Correlativo */
  {lib\lock-genericov21.i &Tabla="FacCorre" ~
      &Condicion="FacCorre.CodCia = s-CodCia ~
      AND FacCorre.CodDoc = s-CodDoc ~
      AND FacCorre.NroSer = s-NroSer" ~
      &Bloqueo="EXCLUSIVE-LOCK" ~
      &Accion="RETRY" ~
      &Mensaje="NO" ~
      &TipoError="UNDO, RETURN 'ADM-ERROR'" }
      
  ASSIGN
      FECanje.CodCia = s-codcia
      FECanje.CodDiv = s-coddiv
      FECanje.CodDoc = s-coddoc
      FECanje.TpoDoc = s-Tipo
      FECanje.NroDoc = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999').
  ASSIGN
      FacCorre.Correlativo = FacCorre.Correlativo + 1.

   RUN Genera-Comprobantes.
   IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
  RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      BUTTON-1:SENSITIVE = NO.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF NOT AVAILABLE FECanje THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FIND CcbCDocu WHERE CcbCDocu.CodCia = FECanje.CodCia 
          AND CcbCDocu.CodDoc = FECanje.CodDoc1 
          AND CcbCDocu.NroDoc = FECanje.NroDoc1
          NO-LOCK NO-ERROR.
      IF AVAILABLE CcbCDocu THEN FILL-IN-1:SCREEN-VALUE = CcbCDocu.NomCli.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      BUTTON-1:SENSITIVE = YES.
      FECanje.CodCli1:SENSITIVE = NO.
      FECanje.RucCli2:SENSITIVE = NO.
      FECanje.ImpTot2:SENSITIVE = NO.
      FECanje.NroSer2:SENSITIVE = NO.
      FECanje.NroSer3:SENSITIVE = NO.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  MESSAGE 'Estamos listos para canejar el comprobante' SKIP
      'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  pMensaje = ''.
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF pMensaje <> '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

  /* Code placed here will execute AFTER standard behavior.    */
  MESSAGE 'Canje exitoso' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
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
        WHEN "" THEN .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SECOND-TRANSACTION V-table-Win 
PROCEDURE SECOND-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH Ccbdcaja NO-LOCK WHERE CcbDCaja.CodCia = B-CDOCU.codcia
        AND CcbDCaja.CodDoc = "I/C"
        AND CcbDCaja.CodRef = B-CDOCU.coddoc
        AND CcbDCaja.NroRef = B-CDOCU.nrodoc:
        ASSIGN
            CcbDCaja.CodRef = FACTURA.coddoc
            CcbDCaja.NroRef = FACTURA.nrodoc.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "FECanje"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.
  
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME} :
    /* De la división, del mismo día y de mostrador */
    FIND Ccbcdocu WHERE CcbCDocu.CodCia = s-codcia
        AND CcbCDocu.CodDiv = s-CodDiv
        AND CcbCDocu.CodDoc = INPUT FECanje.CodDoc1
        AND CcbCDocu.NroDoc = INPUT FECanje.NroDoc1
        AND CcbCDocu.RucCli = INPUT FECanje.RucCli1
        AND CcbCDocu.ImpTot = INPUT FECanje.ImpTot1
        AND Ccbcdocu.fchdoc = TODAY               
        AND Ccbcdocu.flgest = "C"
        AND Ccbcdocu.tipo = "MOSTRADOR"
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE CcbCDocu THEN DO:
        MESSAGE 'Comprobante NO válido' SKIP
            'Intente de nuevo' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FECanje.NroDoc1.
        RETURN 'ADM-ERROR'.
    END.
    /* Rechazado por SUNAT */
    FIND FELogComprobantes WHERE FELogComprobantes.CodCia = CcbCDocu.CodCia
        AND FELogComprobantes.CodDiv = CcbCDocu.CodDiv
        AND FELogComprobantes.CodDoc = CcbCDocu.CodDoc
        AND FELogComprobantes.NroDoc = CcbCDocu.NroDoc
        AND FELogComprobantes.FlagSunat = 2
        NO-LOCK NO-ERROR.
    IF AVAILABLE FELogComprobantes THEN DO:
        MESSAGE 'Documento está rechazado por SUNAT' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    /* Cliente destino */
    RUN vtagn/p-gn-clie-01 (FECanje.CodCli2:SCREEN-VALUE, FECanje.CodDoc2:SCREEN-VALUE).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        MESSAGE 'Cliente destino errado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FECanje.CodCli2.
        RETURN 'ADM-ERROR'.
    END.
    /* Comprobante Destino */
    FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia
        AND FacCorre.CodDiv = pCodDiv
        AND FacCorre.CodDoc = FECanje.CodDoc2:SCREEN-VALUE
        AND FacCorre.NroSer = INTEGER(FECanje.NroSer2:SCREEN-VALUE)
        AND FacCorre.FlgEst = YES
        AND FacCorre.ID_Pos = 'CONTABILIDAD'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN DO:
        MESSAGE 'NO está definida la serie para el comprobante' FECanje.CodDoc2:SCREEN-VALUE
            'en la división' pCodDiv VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FECanje.CodDoc2.
        RETURN 'ADM-ERROR'.
    END.
    /* Nota de Crédito */
    FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia
        AND FacCorre.CodDiv = pCodDiv
        AND FacCorre.CodDoc = "N/C"
        AND FacCorre.NroSer = INTEGER(FECanje.NroSer3:SCREEN-VALUE)
        AND FacCorre.FlgEst = YES
        AND FacCorre.ID_Pos = 'CONTABILIDAD'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN DO:
        MESSAGE 'NO está definida la serie para la Nota de Crédito'
            'en la división' pCodDiv VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FECanje.NroSer3.
        RETURN 'ADM-ERROR'.
    END.
    /* DNI */
    IF FECanje.CodDoc2:SCREEN-VALUE = "BOL"
        AND (FECanje.DniCli2:SCREEN-VALUE = "" OR LENGTH(FECanje.DniCli2:SCREEN-VALUE) <> 8)
        THEN DO: 
        MESSAGE 'Debe ingresar el DNI' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FECanje.DniCli2.
        RETURN 'ADM-ERROR'.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

