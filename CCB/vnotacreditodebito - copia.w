&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
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

&SCOPED-DEFINE ARITMETICA-SUNAT YES

/* Parameters Definitions ---                                           */
DEF SHARED VAR s-permiso-anulacion AS LOG.
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
DEFINE SHARED VARIABLE s-Sunat-Activo AS LOG.

/* 13Dic2019 - Guardar la referencia, caso de modificacion */
DEFINE VAR x-codref AS CHAR.
DEFINE VAR x-nroref AS CHAR.

DEF VAR s-ClienteGenerico AS CHAR INIT '11111111111' NO-UNDO.

FIND FIRST FacCfgGn  WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
IF AVAILABLE FacCfgGn THEN s-ClienteGenerico = FacCfgGn.CliVar.

DEF SHARED VAR s-Tabla AS CHAR.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

DEF VAR pMensaje AS CHAR NO-UNDO.

DEFINE VAR x-tabla-concepto AS CHAR INIT "N/C".

DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER x-factabla FOR factabla.

DEFINE SHARED VAR x-es-find AS LOG.

/**/
DEFINE VAR x-impte-old AS DEC.
DEFINE VAR x-impte-new AS DEC.

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
&Scoped-Define ENABLED-FIELDS CcbCDocu.FchDoc CcbCDocu.CodCli ~
CcbCDocu.RucCli CcbCDocu.CodAnt CcbCDocu.FchVto CcbCDocu.NomCli ~
CcbCDocu.DirCli CcbCDocu.CodRef CcbCDocu.NroRef CcbCDocu.FmaPgo ~
CcbCDocu.CodCta CcbCDocu.CodMon CcbCDocu.Glosa CcbCDocu.ImpBrt ~
CcbCDocu.PorIgv CcbCDocu.ImpVta CcbCDocu.ImpExo CcbCDocu.ImpIgv ~
CcbCDocu.ImpTot 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define ENABLED-OBJECTS RECT-32 RECT-33 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.CodCli CcbCDocu.RucCli CcbCDocu.CodAnt CcbCDocu.FchVto ~
CcbCDocu.NomCli CcbCDocu.usuario CcbCDocu.DirCli CcbCDocu.UsuAnu ~
CcbCDocu.CodRef CcbCDocu.FchAnu CcbCDocu.NroRef CcbCDocu.Libre_c01 ~
CcbCDocu.FmaPgo CcbCDocu.Libre_f01 CcbCDocu.CodCta CcbCDocu.CodMon ~
CcbCDocu.Glosa CcbCDocu.ImpBrt CcbCDocu.PorIgv CcbCDocu.ImpVta ~
CcbCDocu.ImpExo CcbCDocu.ImpIgv CcbCDocu.ImpTot 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-EStado FILL-IN-emision-cmpte ~
FILL-IN-saldo FILL-IN-FmaPgo FILL-IN-Concepto 

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

DEFINE VARIABLE FILL-IN-emision-cmpte AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitido" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-EStado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 28 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FmaPgo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-saldo AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Saldo" 
     VIEW-AS FILL-IN 
     SIZE 13.86 BY .81
     FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 115 BY 1.92
     BGCOLOR 15 FGCOLOR 0 .

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 115 BY 7.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1.27 COL 11 COLON-ALIGNED WIDGET-ID 124
          LABEL "Numero" FORMAT "XXX-XXXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
     FILL-IN-EStado AT ROW 1.27 COL 38 COLON-ALIGNED WIDGET-ID 114
     CcbCDocu.FchDoc AT ROW 1.27 COL 98 COLON-ALIGNED WIDGET-ID 60
          LABEL "Emisión"
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .81
     CcbCDocu.CodCli AT ROW 2.08 COL 11 COLON-ALIGNED WIDGET-ID 48
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
          BGCOLOR 11 FGCOLOR 0 
     CcbCDocu.RucCli AT ROW 2.08 COL 38 COLON-ALIGNED WIDGET-ID 88
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
     CcbCDocu.CodAnt AT ROW 2.08 COL 60 COLON-ALIGNED WIDGET-ID 110
          LABEL "DNI" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
          BGCOLOR 11 FGCOLOR 0 
     CcbCDocu.FchVto AT ROW 2.08 COL 98 COLON-ALIGNED WIDGET-ID 62
          LABEL "Vencimiento"
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .81
     CcbCDocu.NomCli AT ROW 2.88 COL 11 COLON-ALIGNED WIDGET-ID 80
          VIEW-AS FILL-IN 
          SIZE 51.43 BY .81
     CcbCDocu.usuario AT ROW 2.88 COL 98 COLON-ALIGNED WIDGET-ID 92
          LABEL "Creado por"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     CcbCDocu.DirCli AT ROW 3.69 COL 11 COLON-ALIGNED WIDGET-ID 56
          VIEW-AS FILL-IN 
          SIZE 61.43 BY .81
     CcbCDocu.UsuAnu AT ROW 3.69 COL 98 COLON-ALIGNED WIDGET-ID 90
          LABEL "Anulado por"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     CcbCDocu.CodRef AT ROW 4.5 COL 11 COLON-ALIGNED WIDGET-ID 96
          LABEL "Referencia" FORMAT "x(3)"
          VIEW-AS COMBO-BOX INNER-LINES 10
          LIST-ITEM-PAIRS "FACTURA","FAC",
                     "BOLETA","BOL",
                     "NOTA DEBITO","N/D"
          DROP-DOWN-LIST
          SIZE 16 BY 1
     CcbCDocu.FchAnu AT ROW 4.5 COL 98 COLON-ALIGNED WIDGET-ID 58
          LABEL "Fecha Anulación" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .81
     CcbCDocu.NroRef AT ROW 4.54 COL 33.43 COLON-ALIGNED WIDGET-ID 84
          LABEL "Número" FORMAT "X(12)"
          VIEW-AS FILL-IN 
          SIZE 13.43 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FILL-IN-emision-cmpte AT ROW 4.54 COL 53 COLON-ALIGNED WIDGET-ID 128
     FILL-IN-saldo AT ROW 4.54 COL 70.14 COLON-ALIGNED WIDGET-ID 130
     CcbCDocu.Libre_c01 AT ROW 5.31 COL 98 COLON-ALIGNED WIDGET-ID 116
          LABEL "Aprobado por"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
     CcbCDocu.FmaPgo AT ROW 5.38 COL 11 COLON-ALIGNED WIDGET-ID 66
          LABEL "Forma de Pago"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FILL-IN-FmaPgo AT ROW 5.38 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 108
     CcbCDocu.Libre_f01 AT ROW 6.12 COL 98 COLON-ALIGNED WIDGET-ID 118
          LABEL "Fecha Aprobación" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCDocu.CodCta AT ROW 6.19 COL 11 COLON-ALIGNED WIDGET-ID 50
          LABEL "Concepto"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FILL-IN-Concepto AT ROW 6.19 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 112
     CcbCDocu.CodMon AT ROW 6.92 COL 100 NO-LABEL WIDGET-ID 102
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
     CcbCDocu.Glosa AT ROW 7 COL 11 COLON-ALIGNED WIDGET-ID 68
          VIEW-AS FILL-IN 
          SIZE 61 BY .81
     CcbCDocu.ImpBrt AT ROW 8.19 COL 18 COLON-ALIGNED WIDGET-ID 70
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .81
          BGCOLOR 15 FGCOLOR 0 
     CcbCDocu.PorIgv AT ROW 8.19 COL 44 COLON-ALIGNED WIDGET-ID 86
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .81
          BGCOLOR 15 FGCOLOR 0 
     CcbCDocu.ImpVta AT ROW 8.19 COL 65 COLON-ALIGNED WIDGET-ID 78
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .81
          BGCOLOR 15 FGCOLOR 0 
     CcbCDocu.ImpExo AT ROW 8.96 COL 18 COLON-ALIGNED WIDGET-ID 72
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .81
          BGCOLOR 15 FGCOLOR 0 
     CcbCDocu.ImpIgv AT ROW 8.96 COL 65 COLON-ALIGNED WIDGET-ID 74
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .81
          BGCOLOR 15 FGCOLOR 0 
     CcbCDocu.ImpTot AT ROW 8.96 COL 94 COLON-ALIGNED WIDGET-ID 76
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .81
          BGCOLOR 11 FGCOLOR 0 
     "v2" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.31 COL 79 WIDGET-ID 126
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 7.12 COL 93 WIDGET-ID 106
     RECT-32 AT ROW 8 COL 1 WIDGET-ID 98
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
         HEIGHT             = 9.08
         WIDTH              = 117.29.
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
/* SETTINGS FOR FILL-IN FILL-IN-emision-cmpte IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-EStado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FmaPgo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-saldo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FmaPgo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.Libre_c01 IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.Libre_f01 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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
    FIND FIRST CcbTabla WHERE CcbTabla.CodCia = s-codcia 
        AND CcbTabla.Tabla  = s-Tabla
        AND CcbTabla.Codigo = INPUT {&self-name}
        AND ccbtabla.libre_l02 = YES NO-LOCK NO-ERROR.
    IF AVAILABLE CcbTabla THEN DO:            

        IF x-tabla-concepto = 'N/C' THEN DO:
            FIND FIRST x-factabla WHERE x-factabla.codcia = s-codcia AND
                                          x-factabla.tabla = 'OTROS-CONC-NO-USAR' AND
                                          x-factabla.codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF AVAILABLE x-factabla THEN DO:
                MESSAGE "El concepto (" + SELF:SCREEN-VALUE + ") no puede ser utilizado " SKIP
                      "en esta opcion del Sistema."
                    VIEW-AS ALERT-BOX INFORMATION.
                FILL-IN-Concepto:SCREEN-VALUE = ''.
                RETURN NO-APPLY.

            END.
            FILL-IN-Concepto:SCREEN-VALUE = CcbTabla.Nombre.
        END.
    END.
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
  IF output-var-1 <> ? THEN DO:
      IF x-tabla-concepto = 'N/C' THEN DO:
          FIND FIRST x-factabla WHERE x-factabla.codcia = s-codcia AND
                                        x-factabla.tabla = 'OTROS-CONC-NO-USAR' AND
                                        x-factabla.codigo = output-var-2 NO-LOCK NO-ERROR.
          IF AVAILABLE x-factabla THEN DO:
              MESSAGE "El concepto (" + output-var-2 + ") no puede ser utilizado " SKIP
                    "en esta opcion del Sistema."
                  VIEW-AS ALERT-BOX INFORMATION.
          END.
          ELSE DO:
              SELF:SCREEN-VALUE = output-var-2.
          END.
      END.
  END.

  /*IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.*/
END.

/*
OTROS-CONC-NO-USAR
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.CodRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodRef V-table-Win
ON VALUE-CHANGED OF CcbCDocu.CodRef IN FRAME F-Main /* Referencia */
DO:
  IF SELF:SCREEN-VALUE = 'TCK' THEN
      ASSIGN
      CcbCDocu.DirCli:SENSITIVE = YES
      CcbCDocu.NomCli:SENSITIVE = YES
      CcbCDocu.CodAnt:SENSITIVE = YES.
  ELSE ASSIGN
      CcbCDocu.DirCli:SENSITIVE = NO
      CcbCDocu.NomCli:SENSITIVE = NO
      CcbCDocu.CodAnt:SENSITIVE = NO.
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
  FIND FIRST gn-ConVt WHERE gn-ConVt.Codig = INPUT {&self-name} NO-LOCK NO-ERROR.
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
  FIND FIRST B-CDOCU WHERE B-CDOCU.codcia = s-codcia
      AND B-CDOCU.coddoc = INPUT CcbCDocu.CodRef
      AND B-CDOCU.nrodoc = INPUT CcbCDocu.NroRef
      AND B-CDOCU.flgest <> "A" NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-CDOCU THEN DO:
      MESSAGE 'Documento de referencia NO registrado' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF CcbCDocu.CodCli:SCREEN-VALUE = '' THEN CcbCDocu.CodCli:SCREEN-VALUE = B-CDOCU.codcli.
  IF B-CDOCU.codcli <> CcbCDocu.CodCli:SCREEN-VALUE THEN DO:
      MESSAGE 'Documento de referencia NO pertenece al cliente' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
    /*
  DEFINE VAR x-retval AS LOG.
  DEFINE VAR x-coddoc AS CHAR.
  DEFINE VAR x-nrodoc AS CHAR.
  DEFINE VAR x-antiguedad-cmpte AS INT.

  x-coddoc = INPUT CcbCDocu.CodRef.
  x-nrodoc = INPUT CcbCDocu.nroRef.

  DEFINE VAR hProc AS HANDLE NO-UNDO.           /* Handle Libreria */

  RUN ccb\libreria-ccb.r PERSISTENT SET hProc.

  /* Procedimientos */
  RUN comprobante-liquidado-con-nc IN hProc (INPUT x-coddoc, INPUT x-nrodoc, OUTPUT x-retval).  

  DELETE PROCEDURE hProc.                       /* Release Libreria */

  IF x-retval = YES THEN DO:

      MESSAGE "El comprobante al que se esta usando como referencia" SKIP
              "tiene aplicaciones de notas de credito" SKIP
              "Imposible generar la PRE-NOTA" 
              VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.
  */

  ASSIGN
      CcbCDocu.CodMon:SCREEN-VALUE = STRING(B-CDOCU.codmon).
  DISPLAY 
      B-CDOCU.fmapgo @ CcbCDocu.FmaPgo
      FacCfgGn.PorIgv @ CcbCDocu.PorIgv
      /*B-CDOCU.PorIgv @ CcbCDocu.PorIgv*/
      /*B-CDOCU.ImpTot @ CcbCDocu.ImpTot*/
      B-CDOCU.nomcli @ Ccbcdocu.nomcli
      B-CDOCU.dircli @ Ccbcdocu.dircli
      B-CDOCU.ruccli @ Ccbcdocu.ruccli
      B-CDOCU.CodAnt @ CcbCDocu.CodAnt
      B-CDOCU.fchdoc @ fill-in-emision-cmpte
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
    AND CcbTabla.Tabla  = s-Tabla
    AND CcbTabla.Codigo = x-concepto NO-LOCK NO-ERROR.
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
          STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) + STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')) @ CcbCDocu.NroDoc
          TODAY @ CcbCDocu.FchDoc 
          ADD-INTERVAL(TODAY, 1, 'years') @ CcbCDocu.FchVto
          s-user-id @ CcbCDocu.usuario.
      CcbCDocu.CodRef:SCREEN-VALUE = 'FAC'.
      CASE s-CodDoc:
          WHEN "N/D" THEN DISPLAY ADD-INTERVAL(TODAY, 10, 'days') @ CcbCDocu.FchVto.
          WHEN "N/C" THEN DISPLAY ADD-INTERVAL(TODAY, 1, 'year') @ CcbCDocu.FchVto.
      END CASE.
      APPLY 'VALUE-CHANGED':U TO CcbCDocu.CodRef.
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
      AND B-CDOCU.NroDoc = CcbCDocu.NroRef 
      AND B-CDOCU.flgest <> "A" NO-LOCK NO-ERROR.   
  IF ERROR-STATUS:ERROR THEN DO:
      MESSAGE "No se encontro el documento" ccbcdocu.codref ccbcdocu.nroref
          VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  ASSIGN 
      CcbCDocu.CodVen = B-CDOCU.CodVen
      CcbCDocu.Tipo   = "CREDITO"   /* SUNAT */
      CcbCDocu.CodCaja= "".
  
  RUN Genera-Detalle.

  RUN Graba-Totales.

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
  /* ****************************** */
  /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
  EMPTY TEMP-TABLE T-FELogErrores.    /* CONTROL DE ERRORES DE FACTURACION ELECTRONICA */
  RUN sunat\progress-to-ppll-v3 ( INPUT Ccbcdocu.coddiv,
                                  INPUT Ccbcdocu.coddoc,
                                  INPUT Ccbcdocu.nrodoc,
                                  INPUT-OUTPUT TABLE T-FELogErrores,
                                  OUTPUT pMensaje ).
  IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
  IF RETURN-VALUE = "ERROR-EPOS" THEN DO:
      ASSIGN
          Ccbcdocu.FlgEst = "A"
          CcbCDocu.UsuAnu = s-user-id
          CcbCDocu.FchAnu = TODAY.
  END.
  /* *********************************************************** */
  RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-Handle IN lh_handle ('Enable-Head').

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      CcbCDocu.CodCia = S-CODCIA
      CcbCDocu.CodDiv = S-CODDIV
      CcbCDocu.CodDoc = S-CODDOC
      CcbCDocu.NroDoc = STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) + STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')) 
      CcbCDocu.FchDoc = TODAY
      CcbCDocu.FchVto = TODAY
      CcbCDocu.PorIgv = FacCfgGn.PorIgv
      CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
      CcbCDocu.TpoFac = s-Tpofac
      CcbCDocu.CndCre = s-CndCre
      CcbCDocu.usuario = S-USER-ID
      CcbCDocu.FlgEst = "E".    /* Por Aprobar */
  ASSIGN
      FacCorre.Correlativo = FacCorre.Correlativo + 1.
  IF LOOKUP(Ccbcdocu.coddoc, 'PNC') = 0 THEN CcbCDocu.FlgEst = "P". /* Pendiente */

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
  IF NOT AVAILABLE Ccbcdocu OR LOOKUP(Ccbcdocu.flgest, 'A,C,F,J,R,S,X') > 0 THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  IF s-permiso-anulacion = NO THEN DO:
      MESSAGE 'No tiene el permiso para la anulacion' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  IF ccbcdocu.coddoc = 'PNC' THEN DO:
    IF (Ccbcdocu.flgest <> 'E' AND Ccbcdocu.flgest <> 'P') THEN DO:
        MESSAGE 'Para poder ANULAR una PNC, debe tener estado, POR APROBAR o APROBADO' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
  END.

  /* ********************************************* */
  /* Inicio de actividades facturación electrónica */
  /* ********************************************* */
  IF LOOKUP(ccbcdocu.coddoc,"N/C,N/D") > 0 AND s-Sunat-Activo = YES THEN DO:
      /* Verificamos si fue rechazada por SUNAT */
      IF NOT CAN-FIND(FeLogComprobantes WHERE FELogComprobantes.CodCia = Ccbcdocu.codcia
                      AND FELogComprobantes.CodDiv = Ccbcdocu.coddiv
                      AND FELogComprobantes.CodDoc = Ccbcdocu.coddoc
                      AND FELogComprobantes.NroDoc = Ccbcdocu.nrodoc
                      AND FELogComprobantes.FlagSunat = 2
                      NO-LOCK)
          THEN DO:
          MESSAGE 'No está rechazado por SUNAT' SKIP
              'Verificar el Log de Comprobantes (FeLogComprobantes)' SKIP
              'Continuamos con la anulación?' VIEW-AS ALERT-BOX ERROR
              BUTTONS YES-NO UPDATE rpta4 AS LOG.
          IF rpta4 = NO THEN RETURN 'ADM-ERROR'.
      END.
      MESSAGE 'Se va a proceder a anular un comprobante SUNAT' SKIP
          'Continuamos?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
          UPDATE rpta AS LOG.
      IF rpta = NO THEN RETURN 'ADM-ERROR'.
  END.
  /* ********************************************* */

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
/*   IF LOOKUP(Ccbcdocu.coddoc, 'N/C,N/D') > 0 THEN DO:                                      */
/*       DEF VAR dFchCie AS DATE.                                                            */
/*       RUN gn/fecha-de-cierre (OUTPUT dFchCie).                                            */
/*       IF ccbcdocu.fchdoc <= dFchCie THEN DO:                                              */
/*           MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1) */
/*               VIEW-AS ALERT-BOX WARNING.                                                  */
/*           RETURN 'ADM-ERROR'.                                                             */
/*       END.                                                                                */
/*       /* fin de consistencia */                                                           */
/*       {adm/i-DocPssw.i ccbcdocu.CodCia ccbcdocu.CodDoc ""DEL""}                           */
/*       /* RHC CONSISTENCIA SOLO PARA TIENDAS UTILEX */                                     */
/*       FIND gn-divi WHERE gn-divi.codcia = s-codcia                                        */
/*           AND gn-divi.coddiv = s-coddiv                                                   */
/*           NO-LOCK.                                                                        */
/*       IF GN-DIVI.CanalVenta = "MIN" AND Ccbcdocu.fchdoc < TODAY THEN DO:                  */
/*            MESSAGE 'Solo se pueden anular documentos del día'                             */
/*                VIEW-AS ALERT-BOX ERROR.                                                   */
/*            RETURN 'ADM-ERROR'.                                                            */
/*       END.                                                                                */
/*   END.                                                                                    */

  /* Pide el motivo de la anulacion */
  RUN ccb/d-motanu (ccbcdocu.codcia, ccbcdocu.coddoc, ccbcdocu.nrodoc, s-user-id, OUTPUT cReturnValue).
  IF cReturnValue = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
      FIND CURRENT Ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO, RETURN "ADM-ERROR".
      /*
      RUN ccb/d-motanu (ccbcdocu.codcia, ccbcdocu.coddoc, ccbcdocu.nrodoc, s-user-id, OUTPUT cReturnValue).
      IF cReturnValue = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      */
      ASSIGN 
          Ccbcdocu.FlgEst = "A"
          Ccbcdocu.SdoAct = 0 
          /*Ccbcdocu.Glosa  = '**** Documento Anulado ****'*/
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
  IF NOT AVAILABLE Ccbcdocu THEN RETURN 'ADM-ERROR'.
  DO WITH FRAME {&FRAME-NAME}:
/*       ASSIGN                                                               */
/*           FILL-IN-NroSer:SCREEN-VALUE = SUBSTRING(Ccbcdocu.nrodoc,1,3)     */
/*           FILL-IN-Correlativo:SCREEN-VALUE = SUBSTRING(Ccbcdocu.nrodoc,4). */

      RUN gn/fFlgEstCCB (Ccbcdocu.flgest, OUTPUT FILL-IN-EStado).
      IF s-CodDoc = "PNC" AND Ccbcdocu.FlgEst = "P" 
          THEN ASSIGN FILL-IN-Estado = "APROBADO" .
      DISPLAY FILL-IN-Estado.

      FIND gn-ConVt WHERE gn-ConVt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
      IF AVAILABLE gn-ConVt THEN DISPLAY gn-ConVt.Nombr @ FILL-IN-FmaPgo.

      FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia 
        AND CcbTabla.Tabla  = x-tabla-concepto
        AND CcbTabla.Codigo = CcbCDocu.CodCta
        NO-LOCK NO-ERROR.
      IF AVAILABLE CcbTabla THEN DISPLAY CcbTabla.Nombre @ FILL-IN-Concepto.

      x-es-find = YES.

      FIND FIRST B-CDOCU WHERE B-CDOCU.codcia = s-codcia
          AND B-CDOCU.coddoc = INPUT CcbCDocu.CodRef
          AND B-CDOCU.nrodoc = INPUT CcbCDocu.NroRef NO-LOCK NO-ERROR.
      IF AVAILABLE B-CDOCU THEN DO:
        DISPLAY B-CDOCU.fchdoc @ fill-in-emision-cmpte
                B-CDOCU.sdoact @ fill-in-saldo.
      END.

      x-es-find = NO.
  END.

  /* Refrescar los anticipos */
  RUN refrescar-notas-creditos IN lh_Handle (INPUT ccbcdocu.codref, INPUT ccbcdocu.nroref).

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
          CcbCDocu.PorIgv:SENSITIVE = NO
          CcbCDocu.RucCli:SENSITIVE = NO
          CcbCDocu.NomCli:SENSITIVE = NO
          CcbCDocu.DirCli:SENSITIVE = NO
          CcbCDocu.CodAnt:SENSITIVE = NO
          CcbCDocu.UsuAnu:SENSITIVE = NO
          CcbCDocu.usuario:SENSITIVE = NO.
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = "NO" THEN DISABLE CcbCDocu.CodCli CcbCDocu.CodRef CcbCDocu.NroRef.

      /* Importe antes de la modificacion */
      x-impte-old = CcbCDocu.imptot.

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
  IF s-Sunat-Activo = YES THEN DO:
          DEFINE BUFFER x-gn-divi FOR gn-divi.

          FIND FIRST x-gn-divi OF ccbcdocu NO-LOCK NO-ERROR.

              /* Division apta para impresion QR */
          IF AVAILABLE x-gn-divi AND x-gn-divi.campo-log[7] = YES THEN DO:

            DEFINE VAR x-version AS CHAR.
            DEFINE VAR x-formato-tck AS LOG.
            DEFINE VAR x-Imprime-directo AS LOG.
            DEFINE VAR x-nombre-impresora AS CHAR.

            x-version = 'L'.
            x-formato-tck = NO.        /* YES : Formato Ticket,  NO : Formato A4 */
            x-imprime-directo = YES.
            x-nombre-impresora = "".

            DEF VAR answer AS LOGICAL NO-UNDO.
                SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
                IF NOT answer THEN RETURN.
            
            x-nombre-impresora = SESSION:PRINTER-NAME.

            &IF {&ARITMETICA-SUNAT}  &THEN
                RUN sunat\r-impresion-doc-electronico-sunat.r(INPUT ccbcdocu.coddiv, 
                                                      INPUT ccbcdocu.coddoc, 
                                                      INPUT ccbcdocu.nrodoc,
                                                      INPUT x-version,
                                                      INPUT x-formato-tck,
                                                      INPUT x-imprime-directo,
                                                      INPUT x-nombre-impresora).
    
                x-version = 'A'.
                RUN sunat\r-impresion-doc-electronico-sunat.r(INPUT ccbcdocu.coddiv, 
                                                      INPUT ccbcdocu.coddoc, 
                                                      INPUT ccbcdocu.nrodoc,
                                                      INPUT x-version,
                                                      INPUT x-formato-tck,
                                                      INPUT x-imprime-directo,
                                                      INPUT x-nombre-impresora).
            &ELSE
                RUN sunat\r-impresion-doc-electronico.r(INPUT ccbcdocu.coddiv, 
                                                      INPUT ccbcdocu.coddoc, 
                                                      INPUT ccbcdocu.nrodoc,
                                                      INPUT x-version,
                                                      INPUT x-formato-tck,
                                                      INPUT x-imprime-directo,
                                                      INPUT x-nombre-impresora).
    
                x-version = 'A'.
                RUN sunat\r-impresion-doc-electronico.r(INPUT ccbcdocu.coddiv, 
                                                      INPUT ccbcdocu.coddoc, 
                                                      INPUT ccbcdocu.nrodoc,
                                                      INPUT x-version,
                                                      INPUT x-formato-tck,
                                                      INPUT x-imprime-directo,
                                                      INPUT x-nombre-impresora).
            &ENDIF

          END.
          ELSE DO:
              /* Matricial sin QR */
              RUN sunat\r-impresion-documentos-sunat ( ROWID(Ccbcdocu), "O", NO ).
          END.

          RELEASE x-gn-divi.                
  END.
  ELSE DO:
      CASE Ccbcdocu.coddoc:
          WHEN "N/C" THEN RUN CCB/R-IMPNOT2-1 (ROWID(CCBCDOCU)).
          WHEN "N/D" THEN RUN ccb/R-IMPNOT3-2 (ROWID(CCBCDOCU)).
      END CASE.
  END.

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
/*   DO WITH FRAME {&FRAME-NAME}:                                       */
/*       ASSIGN                                                         */
/*           FILL-IN-NroSer:FORMAT = TRIM(ENTRY(1,x-Formato,'-'))       */
/*           FILL-IN-Correlativo:FORMAT = TRIM(ENTRY(2,x-Formato,'-')). */
/*   END.                                                               */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query V-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  pMensaje = "".
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF pMensaje <> "" THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.

  /* Code placed here will execute AFTER standard behavior.    */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refrescar V-table-Win 
PROCEDURE refrescar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pNroDoc AS CHAR NO-UNDO.

FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                            ccbcdocu.coddoc = pCodDoc AND
                            ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.

RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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

define var x-impte-tot-comprobante as dec.

DO WITH FRAME {&FRAME-NAME}:
    /* CLIENTE */
    RUN vtagn/p-gn-clie-01 (Ccbcdocu.CodCli:SCREEN-VALUE , s-coddoc).
    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = Ccbcdocu.codcli:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE 'Cliente No registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.codcli.
        RETURN 'ADM-ERROR'.
    END.

    /* REFERENCIA */
    FIND FIRST B-CDOCU WHERE B-CDOCU.codcia = s-codcia
        AND B-CDOCU.coddoc = INPUT CcbCDocu.CodRef
        AND B-CDOCU.nrodoc = INPUT CcbCDocu.NroRef 
        AND B-CDOCU.flgest <> "A" NO-LOCK NO-ERROR.
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
    IF Ccbcdocu.CodRef:SCREEN-VALUE = "FAC" AND Ccbcdocu.RucCli:SCREEN-VALUE = '' THEN DO:
       MESSAGE "El Cliente NO tiene R.U.C." VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO Ccbcdocu.CodCli.
       RETURN "ADM-ERROR".   
    END.     
    IF Ccbcdocu.CodRef:SCREEN-VALUE = "FAC" THEN DO:
        /* dígito verificador */
        DEF VAR pResultado AS CHAR NO-UNDO.
        RUN lib/_ValRuc (Ccbcdocu.RucCli:SCREEN-VALUE, OUTPUT pResultado).
        IF pResultado = 'ERROR' THEN DO:
            MESSAGE 'Código RUC MAL registrado' VIEW-AS ALERT-BOX WARNING.
            APPLY 'ENTRY':U TO Ccbcdocu.CodCli.
            RETURN 'ADM-ERROR'.
        END.
    END.

    /* Validar si la condicion de venta del documento de referencia permite generar N/C */
    IF LOOKUP(s-coddoc,'N/C,PNC,NCI') > 0 THEN DO:
        FIND FIRST gn-convt WHERE gn-convt.codig = B-CDOCU.fmapgo NO-LOCK NO-ERROR.
        IF gn-convt.libre_c01 <> 'SI' THEN DO:
            MESSAGE "La condicion de venta del documento" SKIP
                    "que va servir de referencia para la N/C" SKIP
                    "no esta habilitado para generar Notas de Credito"
                    VIEW-AS ALERT-BOX INFORMATION.
            APPLY "ENTRY" TO Ccbcdocu.nroref.
            RETURN 'ADM-ERROR'.        
        END.
    END.

    /* *********************************************************** */
    /* VALIDACION DE MONTO MINIMO POR BOLETA */
    /* *********************************************************** */
    DEF VAR cNroDni AS CHAR NO-UNDO.
    DEF VAR iLargo  AS INT NO-UNDO.
    DEF VAR cError  AS CHAR NO-UNDO.
    cNroDni = CcbCDocu.CodAnt:SCREEN-VALUE.
    IF CcbCDocu.CodAnt:SENSITIVE = YES  THEN DO:
        RUN lib/_valid_number (INPUT-OUTPUT cNroDni, OUTPUT iLargo, OUTPUT cError).
        IF cError > '' OR iLargo <> 8 THEN DO:
            cError = cError + (IF cError > '' THEN CHR(10) ELSE '') +
                    "El DNI debe tener 8 números".
            MESSAGE cError VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO CcbCDocu.CodAnt.
            RETURN "ADM-ERROR".   
        END.
        IF TRUE <> (Ccbcdocu.NomCli:SCREEN-VALUE > '') THEN DO:
            MESSAGE "Debe ingresar el Nombre del Cliente"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO Ccbcdocu.NomCli.
            RETURN "ADM-ERROR".   
        END.
        IF TRUE <> (Ccbcdocu.DirCli:SCREEN-VALUE > '') THEN DO:
            MESSAGE "Debe ingresar la Dirección del Cliente"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO Ccbcdocu.DirCli.
            RETURN "ADM-ERROR".   
        END.
    END.

    /* *********************************************************** */
    /* CONCEPTO */
    FIND FIRST CcbTabla WHERE CcbTabla.CodCia = s-codcia 
        AND CcbTabla.Tabla  = s-Tabla
        AND CcbTabla.Codigo = INPUT CcbCDocu.CodCta
        AND CcbTabla.Reservado = NO
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE CcbTabla THEN DO:
        MESSAGE 'El concepto es regiastrado como RESERVADO' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.codcta.
        RETURN 'ADM-ERROR'.
    END.
    IF CcbTabla.Libre_L02 = NO THEN DO:
        MESSAGE 'Concepto INACTIVO' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Ccbcdocu.codcta.
        RETURN 'ADM-ERROR'.
    END.

    /* Verificamos que el documento referenciado no tenga aplicaciones de nota de credito */
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

    x-coddoc = INPUT CcbCDocu.CodRef.
    x-nrodoc = INPUT CcbCDocu.nroRef.

    x-tolerancia-nc-pnc-articulo = 0.
    x-cmpte-con-notas-de-credito = 0.

    x-concepto = CcbCDocu.CodCta:SCREEN-VALUE.
    x-impte-documento = DEC(CcbCDocu.imptot:SCREEN-VALUE).

    x-impte-cmpte-referenciado = B-CDOCU.TotalPrecioVenta.
    IF x-impte-cmpte-referenciado <= 0 THEN x-impte-cmpte-referenciado = B-CDOCU.imptot.

    /*
        Con la aritmetica de sunat que se puso en marcha en Oct2022 ya pierde vigencia y se 
        reemplaza por x-impte-cmpte-referenciado = B-CDOCU.TotalPrecioVenta.
        
    /* Ic - 15Dic2021 - Verificamos si tiene A/C para sacar le importe real del comprobante */
    IF B-CDocu.imptot2 > 0 THEN DO:
        FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = s-codcia AND
                                        FELogComprobantes.coddoc = B-CDOCU.coddoc AND
                                        FELogComprobantes.nrodoc = B-CDOCU.nrodoc NO-LOCK NO-ERROR.
        IF AVAILABLE FELogComprobantes THEN DO:
            IF NUM-ENTRIES(FELogComprobantes.dataQR,"|") > 5 THEN DO:
                x-impte-cmpte-referenciado = DEC(TRIM(ENTRY(6,FELogComprobantes.dataQR,"|"))).
            END.
        END.
    END.
    */

    /* IMPORTE */
    IF INPUT CcbCDocu.ImpTot > x-impte-cmpte-referenciado /* B-CDOCU.ImpTot*/ THEN DO:
        MESSAGE 'El importe de la N/C NO puede ser mayor a ' x-impte-cmpte-referenciado 
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO CcbCDocu.ImpTot.
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
            MESSAGE "El concepto (" + INPUT CcbCDocu.CodCta + ") no puede ser utilizado " SKIP
                "en esta opcion del Sistema."
                VIEW-AS ALERT-BOX INFORMATION.
            APPLY "ENTRY" TO Ccbcdocu.codcta.
            RETURN 'ADM-ERROR'.
        END.

        x-antiguedad-del-cmpte = TODAY - B-CDOCU.fchdoc.   

        IF x-antiguedad-del-cmpte > x-tolerancia-antiguedad-del-cmpte  THEN DO:
            MESSAGE "El comprobante al que se esta usando como referencia" SKIP
                    "es demasiado antiguo, tiene " + STRING(x-antiguedad-del-cmpte) + " dias de emitido" SKIP
                    "como maximo de antigueda debe ser " + STRING(x-tolerancia-antiguedad-del-cmpte) + " dias" SKIP
                    "Imposible generar la PRE-NOTA" 
                    VIEW-AS ALERT-BOX INFORMATION.
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
                    MESSAGE "El concepto (" + x-concepto + ") indica que el documento " SKIP
                        "al cual se esta referenciando, no debe tener NOTAS DE CREDITO o PRE-NOTAS DE CREDITO" SKIP
                        "Imposible generar la PRE-NOTA" VIEW-AS ALERT-BOX INFORMATION.
                    APPLY "ENTRY" TO Ccbcdocu.codcta.
                    RETURN 'ADM-ERROR'.
                END.
            END.
            IF x-factabla.campo-L[2] = YES THEN DO:
                /* El importe debe ser al 100% del comprobante referenciado*/
                IF x-impte-cmpte-referenciado <> x-impte-documento THEN DO:
                    MESSAGE "El concepto (" + x-concepto + ") indica que el documento " SKIP
                        "debe generarse por el mismo importe que el documento referenciado" SKIP
                        "Imposible generar la PRE-NOTA" VIEW-AS ALERT-BOX INFORMATION.
                    APPLY "ENTRY" TO Ccbcdocu.codcta.
                    RETURN 'ADM-ERROR'.
                END.
            END.
        END.
    
        /* Esta Validacion parece que esta fuera de de linea (B-CDOCU.imptot <= 0) */
        IF B-CDOCU.imptot <= 0 THEN DO:                
            /*IF ccbcdocu.codmon = 2 THEN x-impte-cmpte-referenciado = x-impte-cmpte-referenciado * B-CDOCU.tpocmb.*/
    
            IF x-amortizacion-nc >= x-impte-cmpte-referenciado THEN DO:
                MESSAGE "El comprobante al que se esta usando como referencia" SKIP
                        "a sido amortizado con notas de credito" SKIP
                        "Imposible generar la PRE-NOTA" 
                        VIEW-AS ALERT-BOX INFORMATION.
                RETURN "ADM-ERROR".
            END.
        END.

    END.
    /* NO REPETIDO - DEL MISMO CONCEPTO */
    /*
    x-codigo-estados = "P,E,T,D,AP".
    x-descripcion-estados = "APROBADO,POR APROBAR,PNC GENERADA,PROCESO,APROBACION PARCIAL".
    */

    RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
    IF RETURN-VALUE = 'YES' AND LOOKUP(s-coddoc,'N/C,PNC,NCI') > 0 THEN DO:

        IF NOT (x-cmpte-con-notas-de-credito < x-tolerancia-nc-pnc-articulo) THEN DO:
            MESSAGE "El documento de referencia YA tiene " SKIP
                    STRING(x-cmpte-con-notas-de-credito) + " PNC y/o NC referenciadas" SKIP
                    "el maximo es " + STRING(x-tolerancia-nc-pnc-articulo)
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO CcbCDocu.CodRef.
            RETURN "ADM-ERROR".
        END.
        x-impte-old = 0.
    END.
    ELSE DO:
        /* 08Abr2021, COnsulte con Susana Leon y comento que para N/D no debe validar */
        IF LOOKUP(s-coddoc,'N/C,PNC,NCI') > 0 THEN DO:
            IF NOT (x-cmpte-con-notas-de-credito < x-tolerancia-nc-pnc-articulo) THEN DO:
                MESSAGE "El documento de referencia YA tiene " SKIP
                        STRING(x-cmpte-con-notas-de-credito) + " PNC y/o NC referenciadas" SKIP
                        "el maximo es " + STRING(x-tolerancia-nc-pnc-articulo)
                    VIEW-AS ALERT-BOX ERROR.
                APPLY "ENTRY" TO CcbCDocu.CodRef.
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
            MESSAGE "La suma de las N/Cs emitidas, referenciando " SKIP
                    "al comprobante " + B-CDOCU.CodDoc + " " + B-CDOCU.NroDoc SKIP
                    "superan al importe del referencado"
                VIEW-AS ALERT-BOX INFORMATION.
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

x-codref = Ccbcdocu.codref.
x-nroref = Ccbcdocu.nroref.

RUN Procesa-Handle IN lh_handle ('Disable-Head').

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

