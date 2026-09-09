&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-DDOCU FOR CcbDDocu.
DEFINE TEMP-TABLE DETA NO-UNDO LIKE CcbDDocu.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.
DEFINE BUFFER x-FacTabla FOR FacTabla.
DEFINE BUFFER x-VtaTabla FOR VtaTabla.



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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-nroser AS INTE.
DEF SHARED VAR s-CndCre AS CHAR.
DEF SHARED VAR s-TpoFac AS CHAR.
DEF SHARED VAR s-Tipo   AS CHAR.

DEFINE VAR x-tabla AS CHAR INIT "CONFIG-VTAS".
DEFINE VAR x-codigo AS CHAR INIT "PI.NO.VALIDAR.N/C".
DEFINE VAR pMensaje AS CHAR NO-UNDO.

DEFINE SHARED VARIABLE S-PORIGV AS DEC. 
DEFINE SHARED VARIABLE S-PORDTO AS DEC.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VARIABLE R-NRODEV       AS ROWID     NO-UNDO.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.

DEF VAR s-ClienteGenerico AS CHAR INIT '11111111111' NO-UNDO.

FIND FIRST FacCfgGn  WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
IF AVAILABLE FacCfgGn THEN s-ClienteGenerico = FacCfgGn.CliVar.


DEFINE VAR x-impte-old AS DEC.
DEFINE VAR x-impte-new AS DEC.

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
&Scoped-Define ENABLED-FIELDS CcbCDocu.FchDoc CcbCDocu.usuario ~
CcbCDocu.CodCli CcbCDocu.RucCli CcbCDocu.CodAnt CcbCDocu.FchVto ~
CcbCDocu.NomCli CcbCDocu.FchAnu CcbCDocu.UsuAnu CcbCDocu.DirCli ~
CcbCDocu.CodRef CcbCDocu.NroRef CcbCDocu.FmaPgo CcbCDocu.CodCta ~
CcbCDocu.Glosa CcbCDocu.ImpTot CcbCDocu.CodMon CcbCDocu.PorIgv 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.usuario CcbCDocu.CodCli CcbCDocu.RucCli CcbCDocu.CodAnt ~
CcbCDocu.FchVto CcbCDocu.NomCli CcbCDocu.FchAnu CcbCDocu.UsuAnu ~
CcbCDocu.DirCli CcbCDocu.CodRef CcbCDocu.NroRef CcbCDocu.FmaPgo ~
CcbCDocu.CodCta CcbCDocu.Glosa CcbCDocu.ImpTot CcbCDocu.CodMon ~
CcbCDocu.PorIgv 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-EStado FILL-IN-emision-cmpte ~
FILL-IN-ImpTot FILL-IN-Saldo FILL-IN-FmaPgo FILL-IN_CodCta 

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
DEFINE VARIABLE FILL-IN-emision-cmpte AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitido el" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-EStado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FmaPgo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpTot AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Importe" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Saldo AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Saldo" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_CodCta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1 COL 19 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN-EStado AT ROW 1 COL 39 COLON-ALIGNED WIDGET-ID 172
     CcbCDocu.FchDoc AT ROW 1 COL 97 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.usuario AT ROW 1 COL 107 COLON-ALIGNED NO-LABEL WIDGET-ID 24 FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.CodCli AT ROW 1.81 COL 19 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 0 
     CcbCDocu.RucCli AT ROW 1.81 COL 39 COLON-ALIGNED WIDGET-ID 22
          LABEL "RUC"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.CodAnt AT ROW 1.81 COL 59 COLON-ALIGNED WIDGET-ID 2
          LABEL "DNI" FORMAT "X(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.FchVto AT ROW 1.81 COL 97 COLON-ALIGNED WIDGET-ID 10
          LABEL "Vencimiento"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.NomCli AT ROW 2.62 COL 19 COLON-ALIGNED WIDGET-ID 16 FORMAT "x(100)"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
     CcbCDocu.FchAnu AT ROW 2.62 COL 97 COLON-ALIGNED WIDGET-ID 6
          LABEL "Fecha Anulación" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.UsuAnu AT ROW 2.62 COL 107 COLON-ALIGNED NO-LABEL WIDGET-ID 176 FORMAT "X(15)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.DirCli AT ROW 3.42 COL 19 COLON-ALIGNED WIDGET-ID 28
          LABEL "Dirección" FORMAT "x(100)"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
     CcbCDocu.CodRef AT ROW 4.23 COL 19 COLON-ALIGNED WIDGET-ID 26
          LABEL "Referencia" FORMAT "x(3)"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "FACTURA","FAC",
                     "BOLETA","BOL",
                     "FAI","FAI"
          DROP-DOWN-LIST
          SIZE 12 BY 1
          BGCOLOR 11 FGCOLOR 0 
     CcbCDocu.NroRef AT ROW 4.23 COL 39 COLON-ALIGNED WIDGET-ID 20
          LABEL "Número" FORMAT "X(15)"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FILL-IN-emision-cmpte AT ROW 4.23 COL 64 COLON-ALIGNED WIDGET-ID 190
     FILL-IN-ImpTot AT ROW 4.23 COL 85 COLON-ALIGNED WIDGET-ID 192
     FILL-IN-Saldo AT ROW 4.23 COL 103 COLON-ALIGNED WIDGET-ID 194
     CcbCDocu.FmaPgo AT ROW 5.04 COL 19 COLON-ALIGNED WIDGET-ID 12
          LABEL "Forma de Pago" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN-FmaPgo AT ROW 5.04 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 174
     CcbCDocu.CodCta AT ROW 5.85 COL 19 COLON-ALIGNED WIDGET-ID 182
          LABEL "Concepto"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FILL-IN_CodCta AT ROW 5.85 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 184
     CcbCDocu.Glosa AT ROW 6.65 COL 19 COLON-ALIGNED WIDGET-ID 14 FORMAT "x(80)"
          VIEW-AS FILL-IN 
          SIZE 100 BY .81
     CcbCDocu.ImpTot AT ROW 7.46 COL 19 COLON-ALIGNED WIDGET-ID 186
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
          BGCOLOR 11 FGCOLOR 0 
     CcbCDocu.CodMon AT ROW 7.46 COL 33 NO-LABEL WIDGET-ID 178
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 18 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     CcbCDocu.PorIgv AT ROW 8.27 COL 19 COLON-ALIGNED WIDGET-ID 188
          VIEW-AS FILL-IN 
          SIZE 6.43 BY .81
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
      TABLE: DETA T "?" NO-UNDO INTEGRAL CcbDDocu
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
      TABLE: x-FacTabla B "?" ? INTEGRAL FacTabla
      TABLE: x-VtaTabla B "?" ? INTEGRAL VtaTabla
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
         HEIGHT             = 9.15
         WIDTH              = 128.14.
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
/* SETTINGS FOR FILL-IN CcbCDocu.DirCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.FchAnu IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.FchVto IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-emision-cmpte IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-EStado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FmaPgo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Saldo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodCta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FmaPgo IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.Glosa IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.NomCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.RucCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.UsuAnu IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.usuario IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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
      SELF:SCREEN-VALUE = "".
      MESSAGE 'Cliente NO registrado' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  DISPLAY
      gn-clie.nomcli @ CcbCDocu.NomCli
      gn-clie.dircli @ CcbCDocu.DirCli
      gn-clie.ruc    @ CcbCDocu.RucCli
      gn-clie.DNI    @ CcbCDocu.CodAnt
      WITH FRAME {&FRAME-NAME}.
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
    FIND Ccbtabla WHERE CcbTabla.CodCia = s-codcia AND
        CcbTabla.Tabla = "N/C" AND
        CcbTabla.Codigo = CcbCDocu.CodCta:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbtabla THEN FILL-IN_CodCta:SCREEN-VALUE = CcbTabla.Nombre.
    ELSE FILL-IN_CodCta:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCta V-table-Win
ON LEFT-MOUSE-DBLCLICK OF CcbCDocu.CodCta IN FRAME F-Main /* Concepto */
OR F8 OF CcbCDocu.CodCta DO:
    ASSIGN
        input-var-1 = s-TpoFac
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.
    RUN lkup/c-cfg-tipos-nc-tipo.w ('Seleccione').
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
ON LEAVE OF CcbCDocu.NroRef IN FRAME F-Main /* Número */
DO:
  IF INPUT {&self-name} = '' THEN RETURN.
  FIND FIRST B-CDOCU WHERE B-CDOCU.codcia = s-codcia
      AND B-CDOCU.coddoc = INPUT CcbCDocu.CodRef
      AND B-CDOCU.nrodoc = INPUT CcbCDocu.NroRef
      AND B-CDOCU.flgest <> "A" NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-CDOCU THEN DO:
      MESSAGE 'Documento de referencia NO registrado' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = "".
      RETURN NO-APPLY.
  END.
  IF TRUE <> (CcbCDocu.CodCli:SCREEN-VALUE > '') THEN CcbCDocu.CodCli:SCREEN-VALUE = B-CDOCU.codcli.
  IF B-CDOCU.codcli <> CcbCDocu.CodCli:SCREEN-VALUE THEN DO:
      MESSAGE 'Documento de referencia NO pertenece al cliente' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = "".
      APPLY "ENTRY":U TO CcbCDocu.CodCli.
      RETURN NO-APPLY.
  END.

  DISABLE CcbCDocu.CodCli WITH FRAME {&FRAME-NAME}.

  ASSIGN
      CcbCDocu.CodMon:SCREEN-VALUE = STRING(B-CDOCU.codmon).
  DISPLAY 
      B-CDOCU.fmapgo @ CcbCDocu.FmaPgo
      B-CDOCU.PorIgv @ CcbCDocu.PorIgv
      B-CDOCU.nomcli @ Ccbcdocu.nomcli
      B-CDOCU.dircli @ Ccbcdocu.dircli
      B-CDOCU.ruccli @ Ccbcdocu.ruccli
      B-CDOCU.CodAnt @ CcbCDocu.CodAnt
      B-CDOCU.fchdoc @ fill-in-emision-cmpte
      B-CDOCU.imptot @ FILL-IN-ImpTot
      B-CDOCU.sdoact @ fill-in-saldo
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

DEFINE VAR x-concepto AS CHAR.

x-concepto = CcbCDocu.CodCta:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

FIND FIRST CcbTabla WHERE CcbTabla.CodCia = s-codcia 
    AND CcbTabla.Tabla  = "N/C"
    AND CcbTabla.Codigo = x-concepto NO-LOCK NO-ERROR.
FOR EACH Ccbddocu OF Ccbcdocu EXCLUSIVE-LOCK:
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

IF CcbTabla.Afecto THEN DO:
    ASSIGN
        CcbDDocu.AftIgv = Yes
        CcbDDocu.ImpIgv = (CcbDDocu.CanDes * CcbDDocu.PreUni) * ((FacCfgGn.PorIgv / 100) / (1 + (FacCfgGn.PorIgv / 100))).
END.
ELSE DO:
    ASSIGN
        CcbDDocu.AftIgv = No
        CcbDDocu.ImpIgv = 0.
END.

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

    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    {vtagn/i-total-factura-sunat.i &Cabecera="Ccbcdocu" &Detalle="Ccbddocu"}

    DEF VAR hxProc AS HANDLE NO-UNDO.
    RUN sunat/sunat-calculo-importes.r PERSISTENT SET hxProc.
    RUN tabla-ccbcdocu IN hxProc (INPUT Ccbcdocu.CodDiv,
                                  INPUT Ccbcdocu.CodDoc,
                                  INPUT Ccbcdocu.NroDoc,
                                  OUTPUT pMensaje).
    DELETE PROCEDURE hxProc.
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
    
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import-Temp-Table V-table-Win 
PROCEDURE Import-Temp-Table :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER TABLE FOR DETA.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDiv = s-coddiv
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      DISPLAY
          STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) + STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')) @ CcbCDocu.NroDoc
          TODAY @ CcbCDocu.FchDoc 
          ADD-INTERVAL(TODAY, 1, 'years') @ CcbCDocu.FchVto
          s-user-id @ CcbCDocu.usuario.
      CcbCDocu.CodRef:SCREEN-VALUE = 'FAC'.
      CASE s-CodDoc:
          WHEN "N/D" THEN DISPLAY ADD-INTERVAL(TODAY, 10, 'days') @ CcbCDocu.FchVto.
          WHEN "N/C" THEN DISPLAY ADD-INTERVAL(TODAY, 1, 'year') @ CcbCDocu.FchVto.
      END CASE.
  END.

  RUN Procesa-Handle IN lh_handle ('Disable-Head').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       Siempre es CREATE
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR pCuenta AS INTE NO-UNDO.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
  FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia
      AND B-CDOCU.coddoc = ccbcdocu.codref
      AND B-CDOCU.nrodoc = ccbcdocu.nroref 
      NO-LOCK NO-ERROR.
  IF AVAILABLE B-CDOCU THEN DO:
      FIND GN-VEN WHERE gn-ven.codcia = s-codcia
          AND gn-ven.codven = B-CDOCU.codven
          NO-LOCK NO-ERROR.
      IF AVAILABLE GN-VEN THEN Ccbcdocu.cco = gn-ven.cco.
  END.

  RUN Genera-Detalle.   

  RUN Graba-Totales (OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

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
  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_handle ("Enable-Head").

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
  DEF VAR pCuenta AS INTE NO-UNDO.

  /* RHC 22/11/2016  Bloqueamos de todas maneras el movimiento de almacén */
  /* Bloqueamos Correlativo */
  {lib/lock-genericov3.i ~
      &Tabla="FacCorre" ~
      &Condicion="FacCorre.CodCia = s-codcia ~
      AND FacCorre.CodDiv = s-coddiv ~
      AND FacCorre.CodDoc = s-coddoc ~
      AND FacCorre.NroSer = s-nroser" ~
      &Bloqueo="EXCLUSIVE-LOCK" ~
      &Accion="RETRY" ~
      &Mensaje="YES" ~
      &txtMensaje="pMensaje" ~
      &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
      }

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN 
      CcbCDocu.CodCia = S-CODCIA
      CcbCDocu.CodDiv = S-CODDIV
      CcbCDocu.CodDoc = S-CODDOC
      CcbCDocu.NroDoc = STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) + STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')) 
      CcbCDocu.FlgEst = "E"
      CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
      CcbCDocu.CndCre = s-CndCre     /* POR DEVOLUCION */
      CcbCDocu.TpoFac = s-TpoFac
      CcbCDocu.Tipo   = s-Tipo
      CcbCDocu.usuario = S-USER-ID
      NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
      {lib/mensaje-de-error.i &MensajeError="pMensaje"}
      UNDO, RETURN 'ADM-ERROR'.
  END.
  ASSIGN 
      FacCorre.Correlativo = FacCorre.Correlativo + 1.
  RELEASE FacCorre.

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
  IF (Ccbcdocu.flgest <> 'E' AND Ccbcdocu.flgest <> 'P') THEN DO:
      MESSAGE 'Para poder ANULAR una PNC, debe tener estado, POR APROBAR o APROBADO' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
  /* Pide el motivo de la anulacion */
  DEF VAR cReturnValue AS CHAR NO-UNDO.

  RUN ccb/d-motanu (ccbcdocu.codcia, ccbcdocu.coddoc, ccbcdocu.nrodoc, s-user-id, OUTPUT cReturnValue).
  IF cReturnValue = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
      FIND CURRENT Ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO, RETURN "ADM-ERROR".
      ASSIGN 
          Ccbcdocu.FlgEst = "A"
          Ccbcdocu.SdoAct = 0 
          Ccbcdocu.UsuAnu = S-USER-ID
          Ccbcdocu.FchAnu = TODAY.
      /* ************************************************************ */
      FIND CURRENT Ccbcdocu NO-LOCK NO-ERROR.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Ccbcdocu THEN DO WITH FRAME {&FRAME-NAME}:
      RUN gn/fFlgEstCCB (Ccbcdocu.flgest, OUTPUT FILL-IN-Estado).
      IF s-CodDoc = "PNC" AND Ccbcdocu.FlgEst = "P" THEN ASSIGN FILL-IN-Estado = "APROBADO" .
      DISPLAY FILL-IN-Estado.

      FIND gn-ConVt WHERE gn-ConVt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
      IF AVAILABLE gn-ConVt THEN DISPLAY gn-ConVt.Nombr @ FILL-IN-FmaPgo.
      
      FIND Ccbtabla WHERE CcbTabla.CodCia = s-codcia AND
          CcbTabla.Tabla = "N/C" AND
          CcbTabla.Codigo = CcbCDocu.CodCta
          NO-LOCK NO-ERROR.
      IF AVAILABLE Ccbtabla THEN DISPLAY CcbTabla.Nombre @ FILL-IN_CodCta.
      ELSE DISPLAY "" @ FILL-IN_CodCta.

      FIND FIRST B-CDOCU WHERE B-CDOCU.codcia = s-codcia
          AND B-CDOCU.coddoc = INPUT CcbCDocu.CodRef
          AND B-CDOCU.nrodoc = INPUT CcbCDocu.NroRef NO-LOCK NO-ERROR.
      IF AVAILABLE B-CDOCU THEN DO:
        DISPLAY 
            B-CDOCU.fchdoc @ fill-in-emision-cmpte
            B-CDOCU.imptot @ FILL-IN-ImpTot
            B-CDOCU.sdoact @ fill-in-saldo.
      END.

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
      DISABLE 
          CcbCDocu.CodAnt 
          CcbCDocu.CodCli 
          CcbCDocu.CodMon 
          CcbCDocu.CodRef 
          CcbCDocu.DirCli 
          CcbCDocu.FchAnu 
          CcbCDocu.FchDoc 
          CcbCDocu.FchVto 
          CcbCDocu.FmaPgo 
          CcbCDocu.NomCli 
          CcbCDocu.NroDoc 
          CcbCDocu.NroRef 
          CcbCDocu.RucCli 
          CcbCDocu.UsuAnu 
          CcbCDocu.usuario
          CcbCDocu.PorIgv
          .

      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = "YES" THEN ENABLE CcbCDocu.CodCli CcbCDocu.CodRef CcbCDocu.NroRef.
      ELSE DO:
          /* Importe antes de la modificacion */
          x-impte-old = CcbCDocu.imptot.
      END.
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

  IF pMensaje > "" THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-Handle IN lh_handle ("Enable-Head").

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
    /* REFERENCIA */
    FIND FIRST B-CDOCU WHERE B-CDOCU.codcia = s-codcia
        AND B-CDOCU.coddoc = INPUT CcbCDocu.CodRef
        AND B-CDOCU.nrodoc = INPUT CcbCDocu.NroRef 
        AND B-CDOCU.flgest <> "A" NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDOCU THEN DO:
        MESSAGE 'Documento de Referencia MAL registrado' VIEW-AS ALERT-BOX WARNING.
        APPLY "ENTRY" TO Ccbcdocu.nroref.
        RETURN 'ADM-ERROR'.
    END.
    IF B-CDOCU.codcli <> INPUT CcbCDocu.CodCli THEN DO:
        MESSAGE 'Documento de referencia NO pertenece al cliente' VIEW-AS ALERT-BOX WARNING.
        APPLY "ENTRY" TO Ccbcdocu.nroref.
        RETURN 'ADM-ERROR'.
    END.
    IF Ccbcdocu.CodRef:SCREEN-VALUE = "FAC" AND ( TRUE <> (Ccbcdocu.RucCli:SCREEN-VALUE > '')) THEN DO:
       MESSAGE "El Cliente NO tiene R.U.C." VIEW-AS ALERT-BOX WARNING.
       APPLY "ENTRY" TO Ccbcdocu.nroref.
       RETURN "ADM-ERROR".   
    END.     

    /* Concepto */
    IF TRUE <> (CcbCDocu.CodCta:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'Ingreso el concepto' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO CcbCDocu.CodCta.
        RETURN 'ADM-ERROR'.
    END.
    /* Debe estar en el maestro y activo */
    FIND Ccbtabla WHERE CcbTabla.CodCia = s-codcia AND
        CcbTabla.Tabla = "N/C" AND
        CcbTabla.Codigo = CcbCDocu.CodCta:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbtabla OR Ccbtabla.Libre_L02 = NO THEN DO:
        MESSAGE 'Concepto no válido' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO CcbCDocu.CodCta.
        RETURN 'ADM-ERROR'.
    END.
    /* Debe estar en la configuración */
    FIND Vtactabla WHERE VtaCTabla.CodCia = s-codcia AND
        VtaCTabla.Tabla = 'CFG_TIPO_NC' AND 
        VtaCTabla.Llave = s-TpoFac
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtactabla THEN DO:
        MESSAGE 'Concepto no configurado para este movimiento' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO CcbCDocu.CodCta.
        RETURN 'ADM-ERROR'.
    END.
    FIND Vtadtabla WHERE VtaDTabla.CodCia = s-codcia AND
        VtaDTabla.Tabla = 'CFG_TIPO_NC' AND
        VtaDTabla.Llave = s-TpoFac AND
        VtaDTabla.Tipo = "CONCEPTO" AND
        VtaDTabla.LlaveDetalle = CcbCDocu.CodCta:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtadtabla THEN DO:
        MESSAGE 'Concepto no configurado para este movimiento' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO CcbCDocu.CodCta.
        RETURN 'ADM-ERROR'.
    END.

    /* Validar si la condicion de venta del documento de referencia permite generar N/C */
    IF LOOKUP(s-coddoc,'N/C,PNC,NCI') > 0 THEN DO:
        FIND FIRST gn-convt WHERE gn-convt.codig = B-CDOCU.fmapgo NO-LOCK NO-ERROR.
        IF gn-convt.libre_c01 <> 'SI' THEN DO:
            MESSAGE "La condición de venta del documento" SKIP
                    "que va servir de referencia para la N/C" SKIP
                    "no esta habilitado para generar Notas de Credito"
                    VIEW-AS ALERT-BOX INFORMATION.
            APPLY "ENTRY" TO Ccbcdocu.nroref.
            RETURN 'ADM-ERROR'.        
        END.
    END.


    RUN valida-referencia (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
        APPLY "ENTRY" TO CcbCDocu.ImpTot.
        RETURN 'ADM-ERROR'.
    END.


END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-referencia V-table-Win 
PROCEDURE valida-referencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEFINE VAR x-retval AS LOG.
DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.
DEFINE VAR x-antiguedad-del-cmpte AS INT.
DEFINE VAR x-tolerancia-antiguedad-del-cmpte AS INT.

DEFINE VAR x-tolerancia-nc-pnc-articulo AS INT.
DEFINE VAR x-cmpte-con-notas-de-credito AS INT.
DEFINE VAR x-concepto AS CHAR.
DEFINE VAR x-amortizacion-nc AS DEC.

DEFINE VAR x-impte-cmpte-referenciado AS DEC.
DEFINE VAR x-impte-documento AS DEC.

DO WITH FRAME {&FRAME-NAME}:
    /* Verificamos que el documento referenciado no tenga aplicaciones de nota de credito */
    x-coddoc = INPUT CcbCDocu.CodRef.
    x-nrodoc = INPUT CcbCDocu.nroRef.

    x-tolerancia-nc-pnc-articulo = 0.
    x-cmpte-con-notas-de-credito = 0.

    x-concepto = CcbCDocu.CodCta:SCREEN-VALUE.
    x-impte-documento = DEC(CcbCDocu.imptot:SCREEN-VALUE).

    x-impte-cmpte-referenciado = B-CDOCU.TotalPrecioVenta.
    IF x-impte-cmpte-referenciado <= 0 THEN x-impte-cmpte-referenciado = B-CDOCU.imptot.

    /* IMPORTE */
    IF INPUT CcbCDocu.ImpTot > x-impte-cmpte-referenciado THEN DO:
        pMensaje = 'El importe de la N/C NO puede ser mayor a ' + STRING(x-impte-cmpte-referenciado).
        RETURN 'ADM-ERROR'.
    END.

    DEFINE VAR hProc AS HANDLE NO-UNDO.         /* Handle Libreria */

    RUN ccb\libreria-ccb.r PERSISTENT SET hProc.

    /* Cuantas N/C o PNC se deben emitir */
    RUN maximo-nc-pnc-x-articulo IN hProc (INPUT x-concepto, OUTPUT x-tolerancia-nc-pnc-articulo).   

    /* Cuantas PNC y N/C tiene en documento referenciado */
    RUN comprobante-con-notas-de-credito IN hProc (INPUT x-concepto, 
                                                   INPUT CcbCDocu.CodRef:SCREEN-VALUE,
                                                   INPUT CcbCDocu.NroRef:SCREEN-VALUE,
                                                   OUTPUT x-cmpte-con-notas-de-credito).        

    /* Antiguedad del cmpte de referencia */
    RUN antiguedad-cmpte-referenciado IN hProc (INPUT x-concepto, OUTPUT x-tolerancia-antiguedad-del-cmpte).

    /* Importe de todas las N/C que hayan amortizado(cancelacion/aplicado) al comprobante referenciado */
    RUN amortizaciones-con-nc IN hProc (INPUT x-coddoc, INPUT x-nrodoc, OUTPUT x-amortizacion-nc).

    DELETE PROCEDURE hProc.                     /* Release Libreria */
    
    IF LOOKUP(s-coddoc,'N/C,PNC,NCI') > 0 THEN DO:
        /* CONCEPTOS NO validos para este proceso */
        FIND FIRST x-factabla WHERE x-factabla.codcia = s-codcia AND
                                      x-factabla.tabla = 'OTROS-CONC-NO-USAR' AND
                                      x-factabla.codigo = INPUT CcbCDocu.CodCta NO-LOCK NO-ERROR.
        IF AVAILABLE x-factabla THEN DO:
            pMensaje = "El concepto (" + INPUT CcbCDocu.CodCta + ") no puede ser utilizado " + CHR(10) +
                "en esta opcion del Sistema.".
            RETURN 'ADM-ERROR'.
        END.

        x-antiguedad-del-cmpte = TODAY - B-CDOCU.fchdoc.   

        IF x-antiguedad-del-cmpte > x-tolerancia-antiguedad-del-cmpte  THEN DO:
            pMensaje = "El comprobante al que se esta usando como referencia" + CHR(10) +
                    "es demasiado antiguo, tiene " + STRING(x-antiguedad-del-cmpte) + " dias de emitido" + CHR(10) +
                    "como maximo de antigueda debe ser " + STRING(x-tolerancia-antiguedad-del-cmpte) + " dias" + CHR(10) +
                    "Imposible generar la PRE-NOTA".
            RETURN 'ADM-ERROR'.

        END.
        /* Ic - 16Oct2020, validacion pedido por Susana Leon */
        FIND FIRST x-factabla WHERE x-factabla.codcia = s-codcia AND
                                      x-factabla.tabla = 'OTROS-CONC-VALIDAR' AND
                                      x-factabla.codigo = x-concepto NO-LOCK NO-ERROR.
        IF AVAILABLE x-factabla THEN DO:
            IF x-factabla.campo-L[1] = YES THEN DO:
                /* No debe tener PNCs,N/Cs emitidas */
                IF x-cmpte-con-notas-de-credito > 0 THEN DO:
                    pMensaje = "El concepto (" + x-concepto + ") indica que el documento " + CHR(10) +
                        "al cual se esta referenciando, no debe tener NOTAS DE CREDITO o PRE-NOTAS DE CREDITO" + CHR(10) +
                        "Imposible generar la PRE-NOTA".
                    RETURN 'ADM-ERROR'.
                END.
            END.
            IF x-factabla.campo-L[2] = YES THEN DO:
                /* El importe debe ser al 100% del comprobante referenciado*/
                IF x-impte-cmpte-referenciado <> x-impte-documento THEN DO:
                    pMensaje = "El concepto (" + x-concepto + ") indica que el documento " + CHR(10) +
                        "debe generarse por el mismo importe que el documento referenciado" + CHR(10) +
                        "Imposible generar la PRE-NOTA".
                    RETURN 'ADM-ERROR'.
                END.
            END.
        END.
    
        /* Esta Validacion parece que esta fuera de de linea (B-CDOCU.imptot <= 0) */
        IF B-CDOCU.imptot <= 0 THEN DO:                
            /*IF ccbcdocu.codmon = 2 THEN x-impte-cmpte-referenciado = x-impte-cmpte-referenciado * B-CDOCU.tpocmb.*/
    
            IF x-amortizacion-nc >= x-impte-cmpte-referenciado THEN DO:
                pMensaje = "El comprobante al que se esta usando como referencia" + CHR(10) +
                        "a sido amortizado con notas de credito" + CHR(10) +
                        "Imposible generar la PRE-NOTA" .
                RETURN "ADM-ERROR".
            END.
        END.

    END.
    /* NO REPETIDO - DEL MISMO CONCEPTO */
    RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
    IF RETURN-VALUE = 'YES' AND LOOKUP(s-coddoc,'N/C,PNC,NCI') > 0 THEN DO:

        IF NOT (x-cmpte-con-notas-de-credito < x-tolerancia-nc-pnc-articulo) THEN DO:
            pMensaje = "El documento de referencia YA tiene " + CHR(10) +
                    STRING(x-cmpte-con-notas-de-credito) + " PNC y/o NC referenciadas" + CHR(10) +
                    "el maximo es " + STRING(x-tolerancia-nc-pnc-articulo).
            RETURN "ADM-ERROR".
        END.
        x-impte-old = 0.
    END.
    ELSE DO:
        /* 08Abr2021, COnsulte con Susana Leon y comento que para N/D no debe validar */
        IF LOOKUP(s-coddoc,'N/C,PNC,NCI') > 0 THEN DO:
            x-cmpte-con-notas-de-credito = x-cmpte-con-notas-de-credito - 1.    /* NO tomarse en cuenta a sí mismo */
            IF NOT (x-cmpte-con-notas-de-credito < x-tolerancia-nc-pnc-articulo) THEN DO:
                pMensaje = "El documento de referencia YA tiene " + CHR(10) +
                        STRING(x-cmpte-con-notas-de-credito) + " PNC y/o NC referenciadas" + CHR(10) +
                        "el máximo es " + STRING(x-tolerancia-nc-pnc-articulo).
                RETURN "ADM-ERROR".
            END.
        END.
    END.

    IF LOOKUP(s-coddoc,'N/C,PNC,NCI') > 0 THEN DO:
        /* Ic - 03Jun2021 : Suma total cd N/Cs no supere al comprobante referenciado */
        x-impte-new = DEC(CcbCDocu.imptot:SCREEN-VALUE).

        DEFINE VAR hxProc AS HANDLE NO-UNDO.                /* Handle Libreria */

        DEFINE VAR x-impte AS DEC.
        DEFINE VAR x-total2 AS DEC.

        RUN ccb\libreria-ccb.r PERSISTENT SET hxProc.                                                     

        RUN sumar-imptes-nc_ref-cmpte IN hxProc (INPUT "*", /* Algun concepto o todos */
                                                INPUT B-CDOCU.CodDoc, 
                                                INPUT B-CDOCU.NroDoc,
                                                OUTPUT x-impte).

        DELETE PROCEDURE hxProc.                    /* Release Libreria */

        x-impte = x-impte - x-impte-old + x-impte-new.
        IF x-impte > x-impte-cmpte-referenciado /*B-CDOCU.imptot*/ THEN DO:
            pMensaje = "La suma de las N/Cs emitidas, referenciando " + CHR(10) +
                    "al comprobante " + B-CDOCU.CodDoc + " " + B-CDOCU.NroDoc + CHR(10) +
                    "superan al importe del referenciado".
            RETURN "ADM-ERROR".
        END.
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

