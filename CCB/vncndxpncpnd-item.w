&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-DDOCU FOR CcbDDocu.
DEFINE BUFFER B-TABLA FOR logtabla.
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

&SCOPED-DEFINE ARITMETICA-SUNAT YES

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-CodDoc AS CHAR.
DEF SHARED VAR s-CodRef AS CHAR.
DEF SHARED VAR s-CndCre AS CHAR.
DEF SHARED VAR s-TpoFac AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-nroser AS INT.
DEF SHARED VAR lh_handle AS HANDLE.

DEFINE SHARED VARIABLE s-Sunat-Activo AS LOG.

DEF VAR s-ClienteGenerico AS CHAR INIT '11111111111' NO-UNDO.

FIND FIRST FacCfgGn  WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
IF AVAILABLE FacCfgGn THEN s-ClienteGenerico = FacCfgGn.CliVar.

DEF VAR s-Tabla AS CHAR INIT 'N/C' NO-UNDO.

CASE s-CodDoc:
    WHEN 'N/C' OR WHEN 'PNC' THEN s-Tabla = 'N/C'.
    WHEN 'N/D' THEN s-Tabla = 'N/D'.
END CASE.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

DEF VAR pMensaje AS CHAR NO-UNDO.


DEF SHARED VAR s-Tipo   AS CHAR.
DEF SHARED VAR s-CodTer AS CHAR.

/* DEFINE VAR x-nueva-arimetica-sunat-2021 AS LOG. */
/*                                                 */
/* x-nueva-arimetica-sunat-2021 = YES.             */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES CcbCDocu
&Scoped-define FIRST-EXTERNAL-TABLE CcbCDocu


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCDocu.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCDocu.CodAnt CcbCDocu.Glosa 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define ENABLED-OBJECTS RECT-32 RECT-33 BUTTON-1 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.FchDoc CcbCDocu.CodCli ~
CcbCDocu.RucCli CcbCDocu.CodAnt CcbCDocu.FchVto CcbCDocu.NomCli ~
CcbCDocu.usuario CcbCDocu.DirCli CcbCDocu.FchAnu CcbCDocu.CodRef ~
CcbCDocu.NroRef CcbCDocu.UsuAnu CcbCDocu.FmaPgo CcbCDocu.CodMon ~
CcbCDocu.CodCta CcbCDocu.Glosa CcbCDocu.ImpBrt CcbCDocu.PorIgv ~
CcbCDocu.ImpVta CcbCDocu.ImpExo CcbCDocu.ImpIgv CcbCDocu.ImpTot 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NroSer FILL-IN-Correlativo ~
FILL-IN-EStado FILL-IN-FmaPgo FILL-IN-Concepto 

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
     LABEL "Imprimir" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-Concepto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Correlativo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-EStado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FmaPgo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroSer AS CHARACTER FORMAT "X(256)":U 
     LABEL "Correlativo" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81
     FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 115 BY 1.92
     BGCOLOR 15 FGCOLOR 0 .

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 115 BY 6.73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.15 COL 73.86 WIDGET-ID 126
     FILL-IN-NroSer AT ROW 1.19 COL 14.72 COLON-ALIGNED WIDGET-ID 120
     FILL-IN-Correlativo AT ROW 1.19 COL 18.72 COLON-ALIGNED NO-LABEL WIDGET-ID 122
     FILL-IN-EStado AT ROW 1.19 COL 34.72 COLON-ALIGNED WIDGET-ID 114
     CcbCDocu.FchDoc AT ROW 1.19 COL 98 COLON-ALIGNED WIDGET-ID 60
          LABEL "Emisión"
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .81
     CcbCDocu.CodCli AT ROW 1.96 COL 14.72 COLON-ALIGNED WIDGET-ID 48
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .81
     CcbCDocu.RucCli AT ROW 1.96 COL 34.72 COLON-ALIGNED WIDGET-ID 88
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
     CcbCDocu.CodAnt AT ROW 1.96 COL 56.72 COLON-ALIGNED WIDGET-ID 110
          LABEL "DNI" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
          BGCOLOR 11 FGCOLOR 0 
     CcbCDocu.FchVto AT ROW 1.96 COL 98 COLON-ALIGNED WIDGET-ID 62
          LABEL "Vencimiento"
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .81
     CcbCDocu.NomCli AT ROW 2.73 COL 14.72 COLON-ALIGNED WIDGET-ID 80
          VIEW-AS FILL-IN 
          SIZE 51.43 BY .81
     CcbCDocu.usuario AT ROW 2.73 COL 98 COLON-ALIGNED WIDGET-ID 92
          LABEL "Creado por"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     CcbCDocu.DirCli AT ROW 3.5 COL 14.72 COLON-ALIGNED WIDGET-ID 56
          VIEW-AS FILL-IN 
          SIZE 61.43 BY .81
     CcbCDocu.FchAnu AT ROW 3.5 COL 98 COLON-ALIGNED WIDGET-ID 58
          LABEL "Fecha Anulación" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .81
     CcbCDocu.CodRef AT ROW 4.27 COL 14.72 COLON-ALIGNED WIDGET-ID 96
          LABEL "Referencia" FORMAT "x(3)"
          VIEW-AS COMBO-BOX INNER-LINES 3
          LIST-ITEM-PAIRS "FACTURA","FAC",
                     "BOLETA","BOL",
                     "NOTA DE DEBITO","N/D"
          DROP-DOWN-LIST
          SIZE 19 BY 1
     CcbCDocu.NroRef AT ROW 4.27 COL 40.72 COLON-ALIGNED WIDGET-ID 84
          LABEL "Número"
          VIEW-AS FILL-IN 
          SIZE 13.43 BY .81
     CcbCDocu.UsuAnu AT ROW 4.27 COL 98 COLON-ALIGNED WIDGET-ID 90
          LABEL "Anulado por"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     CcbCDocu.FmaPgo AT ROW 5.04 COL 14.72 COLON-ALIGNED WIDGET-ID 66
          LABEL "Forma de Pago"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FILL-IN-FmaPgo AT ROW 5.04 COL 26.72 COLON-ALIGNED NO-LABEL WIDGET-ID 108
     CcbCDocu.CodMon AT ROW 5.04 COL 100 NO-LABEL WIDGET-ID 102
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 12 BY 1.54
     CcbCDocu.CodCta AT ROW 5.81 COL 14.72 COLON-ALIGNED WIDGET-ID 50
          LABEL "Concepto"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FILL-IN-Concepto AT ROW 5.81 COL 26.72 COLON-ALIGNED NO-LABEL WIDGET-ID 112
     CcbCDocu.Glosa AT ROW 6.58 COL 14.72 COLON-ALIGNED WIDGET-ID 68
          VIEW-AS FILL-IN 
          SIZE 61 BY .81
     CcbCDocu.ImpBrt AT ROW 7.92 COL 18 COLON-ALIGNED WIDGET-ID 70
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .81
          BGCOLOR 15 FGCOLOR 0 
     CcbCDocu.PorIgv AT ROW 7.92 COL 44 COLON-ALIGNED WIDGET-ID 86
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .81
          BGCOLOR 15 FGCOLOR 0 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     CcbCDocu.ImpVta AT ROW 7.92 COL 65 COLON-ALIGNED WIDGET-ID 78
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .81
          BGCOLOR 15 FGCOLOR 0 
     CcbCDocu.ImpExo AT ROW 8.69 COL 18 COLON-ALIGNED WIDGET-ID 72
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .81
          BGCOLOR 15 FGCOLOR 0 
     CcbCDocu.ImpIgv AT ROW 8.69 COL 65 COLON-ALIGNED WIDGET-ID 74
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .81
          BGCOLOR 15 FGCOLOR 0 
     CcbCDocu.ImpTot AT ROW 8.69 COL 94 COLON-ALIGNED WIDGET-ID 76
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .81
          BGCOLOR 15 FGCOLOR 0 
     "..." VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 6.38 COL 96 WIDGET-ID 124
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 5.23 COL 93 WIDGET-ID 106
     RECT-32 AT ROW 7.73 COL 1 WIDGET-ID 98
     RECT-33 AT ROW 1 COL 1 WIDGET-ID 100
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.CcbCDocu
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: B-DDOCU B "?" ? INTEGRAL CcbDDocu
      TABLE: B-TABLA B "?" ? INTEGRAL logtabla
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
         HEIGHT             = 9.12
         WIDTH              = 115.43.
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
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbCDocu.CodAnt IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.CodCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.CodCta IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR RADIO-SET CcbCDocu.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX CcbCDocu.CodRef IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.DirCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchAnu IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.FchVto IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FILL-IN-Concepto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Correlativo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-EStado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FmaPgo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroSer IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FmaPgo IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpBrt IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpExo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpIgv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.PorIgv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.RucCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.UsuAnu IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 V-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Imprimir */
DO:
  RUN local-imprime.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCli V-table-Win
ON LEAVE OF CcbCDocu.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF INPUT {&self-name} = '' THEN RETURN.
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = INPUT {&self-name}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:
      MESSAGE 'Cliente NO registrado' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  DISPLAY
      gn-clie.nomcli @ CcbCDocu.NomCli
      gn-clie.dircli @ CcbCDocu.DirCli
      gn-clie.ruc    @ CcbCDocu.RucCli
      WITH FRAME {&FRAME-NAME}.
  IF INPUT {&self-name} = s-ClienteGenerico THEN
      ASSIGN
      CcbCDocu.CodAnt:SENSITIVE = YES
      CcbCDocu.DirCli:SENSITIVE = YES
      CcbCDocu.NomCli:SENSITIVE = YES.
  ELSE 
      ASSIGN
      CcbCDocu.CodAnt:SENSITIVE = NO
      CcbCDocu.DirCli:SENSITIVE = NO
      CcbCDocu.NomCli:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCli V-table-Win
ON LEFT-MOUSE-DBLCLICK OF CcbCDocu.CodCli IN FRAME F-Main /* Cliente */
OR F8 OF CcbCDocu.CodCli
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''.
    RUN vtagn/c-gn-clie-01 ('Clientes').
    IF output-var-1 <> ? THEN CcbCDocu.CodCli:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.CodCta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCta V-table-Win
ON LEAVE OF CcbCDocu.CodCta IN FRAME F-Main /* Concepto */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia 
        AND CcbTabla.Tabla  = s-Tabla
        AND CcbTabla.Codigo = INPUT {&self-name}
        NO-LOCK NO-ERROR.
    IF AVAILABLE CcbTabla THEN FILL-IN-Concepto:SCREEN-VALUE = CcbTabla.Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCta V-table-Win
ON LEFT-MOUSE-DBLCLICK OF CcbCDocu.CodCta IN FRAME F-Main /* Concepto */
DO:
  ASSIGN
      input-var-1 = s-Tabla
      input-var-2 = ''
      input-var-3 = ''
      output-var-1 = ?.
  RUN LKUP\C-ABOCAR-3 ("Conceptos").
  IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FmaPgo V-table-Win
ON LEAVE OF CcbCDocu.FmaPgo IN FRAME F-Main /* Forma de Pago */
DO:
  FIND gn-ConVt WHERE gn-ConVt.Codig = INPUT {&self-name} NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ConVt THEN
      DISPLAY gn-ConVt.Nombr @ FILL-IN-FmaPgo WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.NroRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.NroRef V-table-Win
ON LEFT-MOUSE-DBLCLICK OF CcbCDocu.NroRef IN FRAME F-Main /* Número */
OR F8 OF CcbCDocu.NroRef
DO:
  ASSIGN
      input-var-1 = INPUT CcbCDocu.CodRef
      input-var-2 = INPUT CcbCDocu.CodCli
      input-var-3 = "A"     /* <> "A" */
      output-var-1 = ?.
  RUN lkup/c-docflg-1 ("Documentos").
  IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
  
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
  {src/adm/template/row-list.i "CcbCDocu"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCDocu"}

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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle V-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia 
    AND CcbTabla.Tabla  = s-Tabla
    AND CcbTabla.Codigo = CcbCDocu.CodCta
    NO-LOCK NO-ERROR.
FOR EACH Ccbddocu OF Ccbcdocu:
    DELETE Ccbddocu.
END.
CREATE Ccbddocu.
BUFFER-COPY Ccbcdocu
    TO Ccbddocu
    ASSIGN
    CcbDDocu.CanDes = 1
    CcbDDocu.codmat = CcbCDocu.CodCta
    CcbDDocu.Factor = 1
    CcbDDocu.ImpLin = CcbCDocu.ImpTot
    CcbDDocu.NroItm = 1
    CcbDDocu.PreUni = CcbCDocu.ImpTot.
IF CcbTabla.Afecto THEN
    ASSIGN
        CcbDDocu.AftIgv = Yes
        CcbDDocu.ImpIgv = (CcbDDocu.CanDes * CcbDDocu.PreUni) * ((FacCfgGn.PorIgv / 100) / (1 + (FacCfgGn.PorIgv / 100))).
ELSE
    ASSIGN
        CcbDDocu.AftIgv = No
        CcbDDocu.ImpIgv = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Temp-FeLogErrores V-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales V-table-Win 
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  ASSIGN
    ccbcdocu.impbrt = 0
    ccbcdocu.impexo = 0
    ccbcdocu.impdto = 0
    CcbCDocu.ImpIsc = 0
    ccbcdocu.impigv = 0
    ccbcdocu.imptot = 0.
  FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
      ASSIGN
          Ccbcdocu.ImpIgv = Ccbcdocu.ImpIgv + Ccbddocu.ImpIgv
          Ccbcdocu.ImpTot = Ccbcdocu.ImpTot + Ccbddocu.ImpLin.
      IF NOT Ccbddocu.AftIgv THEN CcbCDocu.ImpExo = CcbCDocu.ImpExo + Ccbddocu.ImpLin.
  END.
  ASSIGN
      CcbCDocu.ImpVta = CcbCDocu.ImpTot - CcbCDocu.ImpExo - CcbCDocu.ImpIgv
      CcbCDocu.ImpBrt = CcbCDocu.ImpVta + CcbCDocu.ImpIsc + CcbCDocu.ImpDto + CcbCDocu.ImpExo
      CcbCDocu.SdoAct = CcbCDocu.ImpTot.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE "Opcion NO DISPONIBLE" VIEW-AS ALERT-BOX INFORMATION.

RETURN "ADM-ERROR".


/* Code placed here will execute PRIOR to standard behavior. */
  FIND FacCorre WHERE  FacCorre.CodCia = s-codcia
      AND FacCorre.CodDiv = s-coddiv
      AND FacCorre.CodDoc = s-coddoc
      AND FacCorre.NroSer = s-nroser
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre THEN DO:
      MESSAGE 'Correlativo NO registrado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Serie INACTIVA' SKIP 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  ASSIGN
      input-var-1 = s-CodRef
      input-var-2 = s-CodDiv
      input-var-3 = 'P'
      output-var-1 = ?
      output-var-2 = ''
      output-var-3 = ''.
  RUN lkup/c-pncndxotros ('PRE-NOTAS APROBADAS').
  IF output-var-1 = ? THEN RETURN 'ADM-ERROR'.
  FIND B-CDOCU WHERE ROWID(B-CDOCU) = output-var-1 NO-LOCK.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      DISPLAY
          B-CDOCU.codcli @ Ccbcdocu.codcli
          B-CDOCU.nomcli @ Ccbcdocu.nomcli
          B-CDOCU.dircli @ Ccbcdocu.dircli
          B-CDOCU.codant @ Ccbcdocu.codant
          B-CDOCU.nroref @ Ccbcdocu.nroref
          B-CDOCU.fmapgo @ Ccbcdocu.fmapgo
          B-CDOCU.codcta @ Ccbcdocu.codcta
          B-CDOCU.glosa  @ Ccbcdocu.glosa
          B-CDOCU.impbrt @ Ccbcdocu.impbrt
          B-CDOCU.impexo @ Ccbcdocu.impexo
          B-CDOCU.porigv @ Ccbcdocu.porigv
          B-CDOCU.impigv @ Ccbcdocu.impigv
          B-CDOCU.impvta @ Ccbcdocu.impvta
          B-CDOCU.imptot @ Ccbcdocu.imptot
/*           STRING(FacCorre.nroSer, '999') + STRING(FacCorre.Correlativo, '999999') @  CcbCDocu.NroDoc */
          STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) @ FILL-IN-NroSer
          STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')) @ FILL-IN-Correlativo
          TODAY @ CcbCDocu.FchDoc 
          TODAY @ CcbCDocu.FchVto
          s-user-id @ CcbCDocu.usuario.
      ASSIGN
          Ccbcdocu.codref:SCREEN-VALUE = B-CDOCU.codref
          CcbCDocu.CodMon:SCREEN-VALUE = STRING(B-CDOCU.codmon).
      APPLY 'LEAVE':U TO CcbCDocu.FmaPgo.
      APPLY 'LEAVE':U TO CcbCDocu.CodCta.
  END.
  RUN Procesa-Handle IN lh_handle ('Disable-Head').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {lib/lock-genericov3.i ~
      &Tabla="FacCorre" ~
      &Condicion="FacCorre.CodCia = s-codcia ~
      AND FacCorre.CodDiv = s-coddiv ~
      AND FacCorre.CodDoc = s-coddoc ~
      AND FacCorre.NroSer = s-nroser" ~
      &Bloqueo="EXCLUSIVE-LOCK" ~
      &Accion="RETRY" ~
      &Mensaje="YES" ~
      &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
      }
  
  FIND CURRENT B-CDOCU EXCLUSIVE-LOCK NO-ERROR.
  IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
  /* RHC 14/08/2017 Reverificamos información */
  IF B-CDOCU.flgest <> 'P' THEN DO:
      MESSAGE 'ERROR: ya fue procesada la PRENOTA' VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  BUFFER-COPY B-CDOCU 
      EXCEPT B-CDOCU.CodAnt
      TO Ccbcdocu
      ASSIGN
      CcbCDocu.CodDoc = S-CODDOC
      CcbCDocu.NroDoc = STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) + STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')) 
      CcbCDocu.FchDoc = TODAY
      CcbCDocu.FchVto = ADD-INTERVAL (TODAY, 1, 'years')
      CcbCDocu.TpoFac = s-Tpofac
      CcbCDocu.CndCre = s-CndCre
      CcbCDocu.usuario = S-USER-ID
      CcbCDocu.FlgEst = "P"     /* Pendiente */
      CcbCDocu.CodPed = B-CDOCU.coddoc
      CcbCDocu.NroPed = B-CDOCU.nrodoc
      CcbCDocu.Tipo   = s-Tipo
      CcbCDocu.CodCaja= s-CodTer
      CcbCDocu.acubon[10] = 0      /* Impuesto Bolsas Plasticas */
      CcbCDocu.dcto_otros_mot = ""
      CcbCDocu.dcto_otros_factor = 0
      CcbCDocu.dcto_otros_vv = 0
      CcbCDocu.dcto_otros_pv = 0
      .
  ASSIGN
      FacCorre.Correlativo = FacCorre.Correlativo + 1.
  /* Control de Aprobación de N/C */
  RUN lib/LogTabla ("ccbcdocu",
                    ccbcdocu.coddoc + ',' + ccbcdocu.nrodoc,
                    "APROBADO").
  /* Buscamos quien aprobó la PNC */
  FIND B-TABLA WHERE B-TABLA.codcia = s-codcia AND
      B-TABLA.Tabla = "ccbcdocu" AND
      B-TABLA.Evento = "APROBADO" AND
      B-TABLA.ValorLlave = B-CDOCU.coddoc + ',' + B-CDOCU.nrodoc
      NO-LOCK NO-ERROR.
  IF AVAILABLE B-TABLA THEN DO:
      FIND LogTabla WHERE LogTabla.codcia = s-codcia AND
          LogTabla.Tabla = "ccbcdocu" AND
          LogTabla.Evento = "APROBADO" AND
          LogTabla.ValorLlave = ccbcdocu.coddoc + ',' + ccbcdocu.nrodoc
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE LogTabla THEN DO:
          UNDO, RETURN 'ADM-ERROR'.
      END.
      ASSIGN
          LogTabla.Usuario = B-Tabla.Usuario
          LogTabla.Dia     = B-Tabla.Dia
          LogTabla.Hora    = B-Tabla.Hora.
      RELEASE LogTabla.
  END.
  /* ****************************** */
  FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
    CREATE Ccbddocu.
    BUFFER-COPY B-DDOCU TO Ccbddocu
        ASSIGN
        CcbDDocu.CodDoc = CcbCDocu.CodDoc
        CcbDDocu.NroDoc = CcbCDocu.NroDoc
        CcbDDocu.FchDoc = CcbCDocu.FchDoc.
  END.
  ASSIGN
      B-CDOCU.FlgEst = "X"      /* CERRADO */
      B-CDOCU.Libre_c03 = s-user-id
      B-CDOCU.Libre_f03 = TODAY.

  /* ****************************** */
  /* Ic - 16Nov2021 - Importes Arimetica de SUNAT */
  /* ****************************** */
  &IF {&ARITMETICA-SUNAT} &THEN
      DEF VAR hProc AS HANDLE NO-UNDO.
      RUN sunat/sunat-calculo-importes.r PERSISTENT SET hProc.
      RUN tabla-ccbcdocu IN hProc (INPUT Ccbcdocu.CodDiv,
                                   INPUT Ccbcdocu.CodDoc,
                                   INPUT Ccbcdocu.NroDoc,
                                   OUTPUT pMensaje).
      DELETE PROCEDURE hProc.
    
      IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
  &ENDIF

  /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
  RUN sunat\progress-to-ppll-v3 ( INPUT Ccbcdocu.coddiv,
                                  INPUT Ccbcdocu.coddoc,
                                  INPUT Ccbcdocu.nrodoc,
                                  INPUT-OUTPUT TABLE T-FELogErrores,
                                  OUTPUT pMensaje ).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
      /* NO se pudo confirmar el comprobante en el e-pos */
      /* Se procede a ANULAR el comprobante              */
      pMensaje = pMensaje + CHR(10) +
          "Se procede a anular el comprobante: " + Ccbcdocu.coddoc + " " + Ccbcdocu.nrodoc + CHR(10) +
          "Salga del sistema, vuelva a entra y vuelva a intentarlo".
      ASSIGN
          CcbCDocu.FchAnu = TODAY
          CcbCDocu.FlgEst = "A"
          CcbCDocu.SdoAct = 0
          CcbCDocu.UsuAnu = s-user-id.
      ASSIGN
          B-CDOCU.FlgEst = "P".     /* PENDIENTE */
      RETURN.
  END.
  /* *********************************************************** */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Enable-Head').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE "Opcion NO DISPONIBLE" VIEW-AS ALERT-BOX INFORMATION.

RETURN "ADM-ERROR".


  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* ********************************************* */
  /* Inicio de actividades facturación electrónica */
  /* ********************************************* */
/*   DEF VAR pStatus AS LOG.                                                 */
/*   RUN sunat\p-inicio-actividades (INPUT Ccbcdocu.fchdoc, OUTPUT pStatus). */
/*   IF pStatus = YES THEN DO:     /* Ya iniciaron las actividades */        */
  IF s-Sunat-Activo = YES AND s-user-id <> 'ADMIN' THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  /* ********************************************* */
  
  IF NOT AVAILABLE Ccbcdocu OR LOOKUP(Ccbcdocu.flgest, 'A,C,F,J,R,S,X') > 0 THEN DO:
      MESSAGE 'El comprobante no se encuentra pendiente' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
/*   RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) . */

  /* Code placed here will execute AFTER standard behavior.    */
  DEF VAR cReturnValue AS CHAR NO-UNDO.

  IF CcbCDocu.SdoAct < CcbCDocu.ImpTot THEN DO:
      MESSAGE 'El documento registra amortizaciones...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
  END.
  /* consistencia de la fecha del cierre del sistema */
  IF s-user-id <> 'ADMIN' THEN DO:
      DEF VAR dFchCie AS DATE.
      RUN gn/fecha-de-cierre (OUTPUT dFchCie).
      IF ccbcdocu.fchdoc <= dFchCie THEN DO:
          MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
      /* fin de consistencia */
      {adm/i-DocPssw.i ccbcdocu.CodCia ccbcdocu.CodDoc ""DEL""}

      /* RHC CONSISTENCIA SOLO PARA TIENDAS UTILEX */
      FIND gn-divi WHERE gn-divi.codcia = s-codcia 
          AND gn-divi.coddiv = s-coddiv
          NO-LOCK.
      IF GN-DIVI.CanalVenta = "MIN" AND Ccbcdocu.fchdoc < TODAY THEN DO:
           MESSAGE 'Solo se pueden anular documentos del día'
               VIEW-AS ALERT-BOX ERROR.
           RETURN 'ADM-ERROR'.
      END.
  END.

   DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
       FIND CURRENT Ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
       IF ERROR-STATUS:ERROR THEN UNDO, RETURN "ADM-ERROR".
       FIND B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
           AND B-CDOCU.coddoc = Ccbcdocu.codped
           AND B-CDOCU.nrodoc = Ccbcdocu.nroped
           EXCLUSIVE-LOCK NO-ERROR.
       IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
       RUN ccb/d-motanu (ccbcdocu.codcia, ccbcdocu.coddoc, ccbcdocu.nrodoc, s-user-id, OUTPUT cReturnValue).
       IF cReturnValue = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
       ASSIGN 
           Ccbcdocu.FlgEst = "A"
           Ccbcdocu.SdoAct = 0 
           /*Ccbcdocu.Glosa  = '**** Documento Anulado ****' */
           Ccbcdocu.UsuAnu = S-USER-ID
           Ccbcdocu.FchAnu = TODAY.
       ASSIGN
           B-CDOCU.FlgEst = "P".
       /* ************************************************************ */
       FIND CURRENT Ccbcdocu NO-LOCK.
       FIND CURRENT B-CDOCU  NO-LOCK.
   END.
   RUN dispatch IN THIS-PROCEDURE ('display-fields':U).


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
  IF NOT AVAILABLE Ccbcdocu THEN RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      DISPLAY
          SUBSTRING(Ccbcdocu.nrodoc,1,3) @ FILL-IN-NroSer
          SUBSTRING(Ccbcdocu.nrodoc,4)   @ FILL-IN-Correlativo.

      RUN gn/fFlgEstCCB (Ccbcdocu.flgest, OUTPUT FILL-IN-EStado).
      IF s-CodDoc = "PNC" AND Ccbcdocu.FlgEst = "P" THEN FILL-IN-Estado = "APROBADO".
      DISPLAY FILL-IN-Estado.

      FIND gn-ConVt WHERE gn-ConVt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
      IF AVAILABLE gn-ConVt THEN DISPLAY gn-ConVt.Nombr @ FILL-IN-FmaPgo.

      FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia 
        AND CcbTabla.Tabla  = s-Tabla
        AND CcbTabla.Codigo = CcbCDocu.CodCta
        NO-LOCK NO-ERROR.
      IF AVAILABLE CcbTabla THEN DISPLAY CcbTabla.Nombre @ FILL-IN-Concepto.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF NOT AVAILABLE Ccbcdocu OR LOOKUP(CcbCDocu.FlgEst, "A,X") > 0 THEN RETURN.

  DEFINE VAR x-version AS CHAR.
  DEFINE VAR x-formato-tck AS LOG.
  DEFINE VAR x-Imprime-directo AS LOG.
  DEFINE VAR x-nombre-impresora AS CHAR.

  x-formato-tck = NO.        /* YES : Formato Ticket,  NO : Formato A4 */
  x-imprime-directo = NO.
  x-nombre-impresora = "".

  DEF VAR pMensaje AS CHAR NO-UNDO.
  DEF VAR hPrinter AS HANDLE NO-UNDO.

  RUN sunat\r-print-electronic-doc-sunat PERSISTENT SET hPrinter.

  /* 1-8-23 Reimpresión: Límite de reimpresiones */
  DEF VAR iImpresionesExistentes AS INTE INIT 0 NO-UNDO.

  CASE TRUE:
      WHEN CAN-FIND(FIRST Invoices_Printed WHERE Invoices_Printed.CodCia = s-codcia AND
                    Invoices_Printed.CodDoc = Ccbcdocu.coddoc AND
                    Invoices_Printed.NroDoc = Ccbcdocu.nrodoc AND 
                    LOOKUP(Invoices_Printed.Version_Printed,"L,A") > 0 NO-LOCK) 
          THEN DO:
          iImpresionesExistentes = DYNAMIC-FUNCTION('PRINT_fget-count-invoice-printed' IN hPrinter, 
                                                    Ccbcdocu.coddoc, 
                                                    Ccbcdocu.nrodoc).
          IF iImpresionesExistentes > 0 THEN DO:
              FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia AND
                  VtaTabla.Tabla = 'CFG_PRINT_INVOICE' AND
                  VtaTabla.Llave_c1 = 'PARAMETER' AND
                  VtaTabla.Llave_c2 = 'RE-IMPRESION'
                  NO-LOCK NO-ERROR.
              IF AVAILABLE VtaTabla AND iImpresionesExistentes >= VtaTabla.Valor[1] THEN DO:
                  MESSAGE 'No se pueden hacer más reimpresiones' SKIP(1)
                      'El límite de reimpresiones es:' STRING(VtaTabla.Valor[1], '>9')
                      VIEW-AS ALERT-BOX WARNING.
                  DELETE PROCEDURE hPrinter.
                  RETURN.
              END.
          END.
          x-version = 'R'.
          {gn/i-print-electronic-doc-sunat.i}
      END.
      OTHERWISE DO:
          x-version = 'L'.
          {gn/i-print-electronic-doc-sunat.i}

          x-version = 'A'.
          {gn/i-print-electronic-doc-sunat.i}
      END.
  END CASE.

  DELETE PROCEDURE hPrinter.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          FILL-IN-NroSer:FORMAT = TRIM(ENTRY(1,x-Formato,'-'))
          FILL-IN-Correlativo:FORMAT = TRIM(ENTRY(2,x-Formato,'-')).
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

  /* Dispatch standard ADM method.                             */
  EMPTY TEMP-TABLE T-FELogErrores.    /* CONTROL DE ERRORES DE FACTURACION ELECTRONICA */
  pMensaje = "".
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF pMensaje <> '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */
  IF AVAILABLE(B-CDOCU)  THEN RELEASE B-CDOCU.   
  IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
  RUN Procesa-Handle IN lh_handle ('Enable-Head').

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
  {src/adm/template/snd-list.i "CcbCDocu"}

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

DO WITH FRAME {&FRAME-NAME}:

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

    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

