&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.



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
DEF SHARED VAR s-CodDoc AS CHAR.
DEF SHARED VAR s-CndCre AS CHAR.
DEF SHARED VAR s-TpoFac AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-nroser AS INT.
DEF SHARED VAR lh_handle AS HANDLE.

DEF VAR s-ClienteGenerico AS CHAR INIT '11111111111' NO-UNDO.

FIND FIRST FacCfgGn  WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
IF AVAILABLE FacCfgGn THEN s-ClienteGenerico = FacCfgGn.CliVar.

DEF VAR s-Tabla AS CHAR INIT 'N/C' NO-UNDO.

CASE s-CodDoc:
    WHEN 'N/C' OR WHEN 'PNC' THEN s-Tabla = 'N/C'.
    WHEN 'N/D' THEN s-Tabla = 'N/D'.
END CASE.

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
&Scoped-Define ENABLED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.CodCli CcbCDocu.RucCli CcbCDocu.CodAnt CcbCDocu.FchVto ~
CcbCDocu.NomCli CcbCDocu.DirCli CcbCDocu.CodRef CcbCDocu.NroRef ~
CcbCDocu.FmaPgo CcbCDocu.CodCta CcbCDocu.Glosa CcbCDocu.CodMon ~
CcbCDocu.ImpBrt CcbCDocu.PorIgv CcbCDocu.ImpVta CcbCDocu.ImpExo ~
CcbCDocu.ImpIgv CcbCDocu.ImpTot 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define ENABLED-OBJECTS RECT-32 RECT-33 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.CodCli CcbCDocu.RucCli CcbCDocu.CodAnt CcbCDocu.FchVto ~
CcbCDocu.NomCli CcbCDocu.usuario CcbCDocu.DirCli CcbCDocu.UsuAnu ~
CcbCDocu.CodRef CcbCDocu.NroRef CcbCDocu.FchAnu CcbCDocu.FmaPgo ~
CcbCDocu.Libre_c01 CcbCDocu.CodCta CcbCDocu.Libre_f01 CcbCDocu.Glosa ~
CcbCDocu.CodMon CcbCDocu.ImpBrt CcbCDocu.PorIgv CcbCDocu.ImpVta ~
CcbCDocu.ImpExo CcbCDocu.ImpIgv CcbCDocu.ImpTot 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-EStado FILL-IN-FmaPgo ~
FILL-IN-Concepto 

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
DEFINE VARIABLE FILL-IN-Concepto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-EStado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FmaPgo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 115 BY 1.92
     BGCOLOR 15 FGCOLOR 0 .

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 115 BY 6.73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1.19 COL 18 COLON-ALIGNED WIDGET-ID 82
          LABEL "Correlativo"
          VIEW-AS FILL-IN 
          SIZE 13.43 BY .81
     FILL-IN-EStado AT ROW 1.19 COL 38 COLON-ALIGNED WIDGET-ID 114
     CcbCDocu.FchDoc AT ROW 1.19 COL 98 COLON-ALIGNED WIDGET-ID 60
          LABEL "Emisión"
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .81
     CcbCDocu.CodCli AT ROW 1.96 COL 18 COLON-ALIGNED WIDGET-ID 48
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .81
     CcbCDocu.RucCli AT ROW 1.96 COL 38 COLON-ALIGNED WIDGET-ID 88
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
     CcbCDocu.CodAnt AT ROW 1.96 COL 60 COLON-ALIGNED WIDGET-ID 110
          LABEL "DNI" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
     CcbCDocu.FchVto AT ROW 1.96 COL 98 COLON-ALIGNED WIDGET-ID 62
          LABEL "Vencimiento"
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .81
     CcbCDocu.NomCli AT ROW 2.73 COL 18 COLON-ALIGNED WIDGET-ID 80
          VIEW-AS FILL-IN 
          SIZE 51.43 BY .81
     CcbCDocu.usuario AT ROW 2.73 COL 98 COLON-ALIGNED WIDGET-ID 92
          LABEL "Creado por"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     CcbCDocu.DirCli AT ROW 3.5 COL 18 COLON-ALIGNED WIDGET-ID 56
          VIEW-AS FILL-IN 
          SIZE 61.43 BY .81
     CcbCDocu.UsuAnu AT ROW 3.5 COL 98 COLON-ALIGNED WIDGET-ID 90
          LABEL "Anulado por"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     CcbCDocu.CodRef AT ROW 4.27 COL 18 COLON-ALIGNED WIDGET-ID 96
          LABEL "Referencia" FORMAT "x(3)"
          VIEW-AS COMBO-BOX INNER-LINES 3
          LIST-ITEM-PAIRS "FACTURA","FAC",
                     "NOTA DEBITO","N/D",
                     "TICKET","TCK"
          DROP-DOWN-LIST
          SIZE 16 BY 1
     CcbCDocu.NroRef AT ROW 4.27 COL 42 COLON-ALIGNED WIDGET-ID 84
          LABEL "Número"
          VIEW-AS FILL-IN 
          SIZE 13.43 BY .81
     CcbCDocu.FchAnu AT ROW 4.27 COL 98 COLON-ALIGNED WIDGET-ID 58
          LABEL "Fecha Anulación" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .81
     CcbCDocu.FmaPgo AT ROW 5.04 COL 18 COLON-ALIGNED WIDGET-ID 66
          LABEL "Forma de Pago"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FILL-IN-FmaPgo AT ROW 5.04 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 108
     CcbCDocu.Libre_c01 AT ROW 5.04 COL 98 COLON-ALIGNED WIDGET-ID 116
          LABEL "Aprobado por"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
     CcbCDocu.CodCta AT ROW 5.81 COL 18 COLON-ALIGNED WIDGET-ID 50
          LABEL "Concepto"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FILL-IN-Concepto AT ROW 5.81 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 112
     CcbCDocu.Libre_f01 AT ROW 5.81 COL 98 COLON-ALIGNED WIDGET-ID 118
          LABEL "Fecha Aprobación" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCDocu.Glosa AT ROW 6.58 COL 18 COLON-ALIGNED WIDGET-ID 68
          VIEW-AS FILL-IN 
          SIZE 61 BY .81
     CcbCDocu.CodMon AT ROW 6.58 COL 100 NO-LABEL WIDGET-ID 102
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 14 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     CcbCDocu.ImpBrt AT ROW 7.92 COL 18 COLON-ALIGNED WIDGET-ID 70
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .81
          BGCOLOR 15 FGCOLOR 0 
     CcbCDocu.PorIgv AT ROW 7.92 COL 44 COLON-ALIGNED WIDGET-ID 86
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .81
          BGCOLOR 15 FGCOLOR 0 
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
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 6.77 COL 93 WIDGET-ID 106
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
         WIDTH              = 115.57.
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
/* SETTINGS FOR FILL-IN CcbCDocu.CodCta IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX CcbCDocu.CodRef IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.FchAnu IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchVto IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Concepto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-EStado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FmaPgo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FmaPgo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.Libre_c01 IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.Libre_f01 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   EXP-LABEL                                                            */
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
    ELSE DO:
        MESSAGE 'Concepto NO registrado' VIEW-AS ALERT-BOX ERROR.
        FILL-IN-Concepto:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.

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


&Scoped-define SELF-NAME CcbCDocu.DirCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.DirCli V-table-Win
ON LEAVE OF CcbCDocu.DirCli IN FRAME F-Main /* Direccion */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
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


&Scoped-define SELF-NAME CcbCDocu.NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.NomCli V-table-Win
ON LEAVE OF CcbCDocu.NomCli IN FRAME F-Main /* Nombre */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.NroRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.NroRef V-table-Win
ON LEAVE OF CcbCDocu.NroRef IN FRAME F-Main /* Número */
DO:
  IF INPUT {&self-name} = '' THEN RETURN.
  FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia
      AND B-CDOCU.coddoc = INPUT CcbCDocu.CodRef
      AND B-CDOCU.nrodoc = INPUT CcbCDocu.NroRef
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-CDOCU THEN DO:
      MESSAGE 'Documento de referencia NO registrado' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF B-CDOCU.codcli <> INPUT CcbCDocu.CodCli THEN DO:
      MESSAGE 'Documento de referencia NO pertenece al cliente' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  ASSIGN
      CcbCDocu.CodMon:SCREEN-VALUE = STRING(B-CDOCU.codmon).
  DISPLAY 
      B-CDOCU.fmapgo @ CcbCDocu.FmaPgo
      B-CDOCU.PorIgv @ CcbCDocu.PorIgv
      B-CDOCU.ImpTot @ CcbCDocu.ImpTot
      WITH FRAME {&FRAME-NAME}.
  APPLY 'LEAVE':U TO CcbCDocu.FmaPgo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      DISPLAY
          STRING(FacCorre.nroSer, '999') + STRING(FacCorre.Correlativo, '999999') @  CcbCDocu.NroDoc
          TODAY @ CcbCDocu.FchDoc 
          ADD-INTERVAL(TODAY, 1, 'years') @ CcbCDocu.FchVto
          s-user-id @ CcbCDocu.usuario.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND FIRST B-CDOCU WHERE B-CDOCU.CodCia = s-codcia 
      AND B-CDOCU.CodDoc = CcbCDocu.CodRef 
      AND B-CDOCU.NroDoc = CcbCDocu.NroRef NO-LOCK NO-ERROR.   
  IF ERROR-STATUS:ERROR THEN DO:
      MESSAGE "No se encontro el documento" ccbcdocu.codref ccbcdocu.nroref
          VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  ASSIGN CcbCDocu.CodVen = B-CDOCU.CodVen.
  IF Ccbcdocu.ruccli = '' THEN Ccbcdocu.ruccli = Ccbcdocu.codcli.

  RUN Genera-Detalle.

  RUN Graba-Totales.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
/*
  Tabla: "Almacen"
  Condicion: "Almacen.codcia = s-codcia AND Almacen.codalm = s-codalm"
  Bloqueo: "EXCLUSIVE-LOCK (NO-WAIT)"
  Accion: "RETRY" | "LEAVE"
  Mensaje: "YES" | "NO"
  TipoError: "RETURN 'ADM-ERROR'" | "RETURN ERROR" |  "NEXT"
*/

  {lib/lock-genericov2.i ~
      &Tabla="FacCorre" ~
      &Condicion="FacCorre.CodCia = s-codcia ~
      AND FacCorre.CodDiv = s-coddiv ~
      AND FacCorre.CodDoc = s-coddoc ~
      AND FacCorre.NroSer = s-nroser" ~
      &Bloqueo="EXCLUSIVE-LOCK" ~
      &Accion="RETRY" ~
      &Mensaje="YES" ~
      &TipoError="RETURN 'ADM-ERROR'" ~
      }


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      CcbCDocu.CodCia = S-CODCIA
      CcbCDocu.CodDiv = S-CODDIV
      CcbCDocu.CodDoc = S-CODDOC
      CcbCDocu.NroDoc = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
      CcbCDocu.FchDoc = TODAY
      CcbCDocu.FchVto = ADD-INTERVAL(TODAY, 1, 'years')
      CcbCDocu.PorIgv = FacCfgGn.PorIgv
      CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
      CcbCDocu.TpoFac = s-Tpofac
      CcbCDocu.CndCre = s-CndCre
      CcbCDocu.usuario = S-USER-ID
      CcbCDocu.FlgEst = "E".    /* Por Aprobar */
  ASSIGN
      FacCorre.Correlativo = FacCorre.Correlativo + 1.
  IF LOOKUP(Ccbcdocu.coddoc, 'N/C,N/D') > 0 THEN CcbCDocu.FlgEst = "P". /* Pendiente */


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
  IF NOT AVAILABLE Ccbcdocu OR LOOKUP(Ccbcdocu.flgest, 'A,C,F,J,R,S,X') > 0 THEN RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
/*   RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) . */

  /* Code placed here will execute AFTER standard behavior.    */
  DEF VAR cReturnValue AS CHAR NO-UNDO.

  IF CcbCDocu.SdoAct < CcbCDocu.ImpTot THEN DO:
      MESSAGE 'El documento registra amortizaciones...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
  END.
  /* consistencia de la fecha del cierre del sistema */
  /* Solo para Comprobantes SUNAT */
  IF LOOKUP(Ccbcdocu.coddoc, 'N/C,N/D') > 0 THEN DO:
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
      END.
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
      RUN ccb/d-motanu (ccbcdocu.codcia, ccbcdocu.coddoc, ccbcdocu.nrodoc, s-user-id, OUTPUT cReturnValue).
      IF cReturnValue = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
/*       FOR EACH Ccbddocu OF Ccbcdocu: */
/*           DELETE Ccbddocu.           */
/*       END.                           */
      ASSIGN 
          Ccbcdocu.FlgEst = "A"
          Ccbcdocu.SdoAct = 0 
          Ccbcdocu.Glosa  = '**** Documento Anulado ****'
          Ccbcdocu.UsuAnu = S-USER-ID
          Ccbcdocu.FchAnu = TODAY.
      /* ************************************************************ */
      FIND CURRENT Ccbcdocu NO-LOCK.
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
      RUN gn/fFlgEstCCB (Ccbcdocu.flgest, OUTPUT FILL-IN-EStado).
      IF s-CodDoc = "PNC" AND Ccbcdocu.FlgEst = "P" 
          THEN ASSIGN FILL-IN-Estado = "APROBADO" .
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
      ASSIGN
          CcbCDocu.CodMon:SENSITIVE = NO
          CcbCDocu.FchAnu:SENSITIVE = NO
          CcbCDocu.FchDoc:SENSITIVE = NO
          CcbCDocu.FchVto:SENSITIVE = NO
          CcbCDocu.FmaPgo:SENSITIVE = NO
          CcbCDocu.ImpBrt:SENSITIVE = NO
          CcbCDocu.ImpExo:SENSITIVE = NO
          CcbCDocu.ImpIgv:SENSITIVE = NO
          CcbCDocu.ImpVta:SENSITIVE = NO
          CcbCDocu.NroDoc:SENSITIVE = NO
          CcbCDocu.PorIgv:SENSITIVE = NO
          CcbCDocu.RucCli:SENSITIVE = NO
          CcbCDocu.NomCli:SENSITIVE = NO
          CcbCDocu.DirCli:SENSITIVE = NO
          CcbCDocu.CodAnt:SENSITIVE = NO
          CcbCDocu.UsuAnu:SENSITIVE = NO
          CcbCDocu.usuario:SENSITIVE = NO.
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
  CASE Ccbcdocu.coddoc:
      WHEN "N/C" THEN RUN CCB/R-IMPNOT2-1 (ROWID(CCBCDOCU)).
  END CASE.

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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
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
    RUN vtagn/p-gn-clie-01 (Ccbcdocu.CodCli:SCREEN-VALUE , s-coddoc).
    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = Ccbcdocu.codcli:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE 'Cliente No registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.codcli.
        RETURN 'ADM-ERROR'.
    END.

    FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia
        AND B-CDOCU.coddoc = INPUT CcbCDocu.CodRef
        AND B-CDOCU.nrodoc = INPUT CcbCDocu.NroRef
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDOCU THEN DO:
        MESSAGE 'Documento de Referencia NO registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.nroref.
        RETURN 'ADM-ERROR'.
    END.
    IF B-CDOCU.codcli <> INPUT CcbCDocu.CodCli THEN DO:
        MESSAGE 'Documento de referencia NO pertenece al cliente' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.nroref.
        RETURN 'ADM-ERROR'.
    END.

    IF INPUT CcbCDocu.CodCli = s-ClienteGenerico AND LENGTH(INPUT CcbCDocu.CodAnt) <> 8 
        THEN DO:
        MESSAGE 'Debe ingresar el DNI' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO CcbCDocu.CodAnt.
        RETURN 'ADM-ERROR'.
    END.

    IF B-CDOCU.TpoFac = 'A' THEN DO:
        MESSAGE 'Acceso Denegado' SKIP 'Factura por Anticipo de Campaña'
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.nroref.
        RETURN 'ADM-ERROR'.
    END.

    FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia 
        AND CcbTabla.Tabla  = s-Tabla
        AND CcbTabla.Codigo = INPUT CcbCDocu.CodCta
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDOCU THEN DO:
        MESSAGE 'Concepto NO registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.codcta.
        RETURN 'ADM-ERROR'.
    END.
    IF CcbTabla.Libre_L02 = NO THEN DO:
        MESSAGE 'Concepto INACTIVO' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.codcta.
        RETURN 'ADM-ERROR'.
    END.

    IF INPUT CcbCDocu.ImpTot > B-CDOCU.ImpTot THEN DO:
        MESSAGE 'El importe NO puede ser mayor a' B-CDOCU.ImpTot
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO CcbCDocu.ImpTot.
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

IF NOT AVAILABLE Ccbcdocu OR CcbCDocu.FlgEst <> "E" THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
RUN Procesa-Handle IN lh_handle ('Disable-Head').

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

