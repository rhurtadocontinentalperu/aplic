&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CLIE FOR gn-clie.



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
DEF SHARED VAR cl-codcia AS INT.

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
&Scoped-define EXTERNAL-TABLES gn-clie
&Scoped-define FIRST-EXTERNAL-TABLE gn-clie


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gn-clie.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gn-clie.Telfnos[1] gn-clie.Telfnos[2] ~
gn-clie.FaxCli gn-clie.E-Mail 
&Scoped-define ENABLED-TABLES gn-clie
&Scoped-define FIRST-ENABLED-TABLE gn-clie
&Scoped-Define ENABLED-OBJECTS SELECT-Relacionados RECT-26 
&Scoped-Define DISPLAYED-FIELDS gn-clie.Telfnos[1] gn-clie.FlagAut ~
gn-clie.Telfnos[2] gn-clie.FaxCli gn-clie.E-Mail 
&Scoped-define DISPLAYED-TABLES gn-clie
&Scoped-define FIRST-DISPLAYED-TABLE gn-clie
&Scoped-Define DISPLAYED-OBJECTS SELECT-Relacionados F-LinCre f-MonLC ~
txtStkLetras F-CreUsa F-Credis FILL-IN_LinCre FILL-IN_CodCli FILL-IN_NomCli 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSdoAct V-table-Win 
FUNCTION fSdoAct RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE F-Credis AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Credito Dispon." 
     VIEW-AS FILL-IN 
     SIZE 11.57 BY .81
     BGCOLOR 15 FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE F-CreUsa AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Credito Usado" 
     VIEW-AS FILL-IN 
     SIZE 11.57 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE F-LinCre AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Linea  Credito" 
     VIEW-AS FILL-IN 
     SIZE 11.57 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-MonLC AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "RUC Principal" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_LinCre AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Linea Crédito GRUPAL" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE txtStkLetras AS INTEGER FORMAT "->>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81
     BGCOLOR 15 FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 7.72 BY 1.58.

DEFINE VARIABLE SELECT-Relacionados AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 62 BY 4.04
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     gn-clie.Telfnos[1] AT ROW 1 COL 56 COLON-ALIGNED WIDGET-ID 92
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
     SELECT-Relacionados AT ROW 1 COL 94 NO-LABEL WIDGET-ID 144
     F-LinCre AT ROW 1.81 COL 16 COLON-ALIGNED WIDGET-ID 76
     f-MonLC AT ROW 1.81 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 78
     gn-clie.FlagAut AT ROW 1.81 COL 35 NO-LABEL WIDGET-ID 80
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Sin Autorizar", " ":U,
"Autorizado", "A":U,
"Rechazado", "R":U
          SIZE 13 BY 1.54
     gn-clie.Telfnos[2] AT ROW 1.81 COL 56 COLON-ALIGNED WIDGET-ID 94
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
     txtStkLetras AT ROW 2.38 COL 74.43 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     F-CreUsa AT ROW 2.62 COL 16 COLON-ALIGNED WIDGET-ID 74
     gn-clie.FaxCli AT ROW 2.62 COL 56 COLON-ALIGNED WIDGET-ID 90
          VIEW-AS FILL-IN 
          SIZE 16.86 BY .81
     F-Credis AT ROW 3.42 COL 16 COLON-ALIGNED WIDGET-ID 72
     gn-clie.E-Mail AT ROW 3.42 COL 39 COLON-ALIGNED WIDGET-ID 88
          VIEW-AS FILL-IN 
          SIZE 43 BY .81
     FILL-IN_LinCre AT ROW 4.23 COL 16 COLON-ALIGNED WIDGET-ID 96
     FILL-IN_CodCli AT ROW 4.23 COL 39 COLON-ALIGNED WIDGET-ID 98
     FILL-IN_NomCli AT ROW 4.23 COL 51 COLON-ALIGNED NO-LABEL WIDGET-ID 100
     "CLIENTES AGRUPADOS:" VIEW-AS TEXT
          SIZE 18 BY .5 AT ROW 1 COL 76 WIDGET-ID 146
     "Letras" VIEW-AS TEXT
          SIZE 6.14 BY .5 AT ROW 1.81 COL 76.43 WIDGET-ID 56
          FGCOLOR 9 FONT 6
     RECT-26 AT ROW 1.77 COL 76 WIDGET-ID 54
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.gn-clie
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CLIE B "?" ? INTEGRAL gn-clie
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
         HEIGHT             = 6.35
         WIDTH              = 155.86.
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

ASSIGN 
       gn-clie.E-Mail:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN F-Credis IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-CreUsa IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-LinCre IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-MonLC IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       gn-clie.FaxCli:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_CodCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_LinCre IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET gn-clie.FlagAut IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       gn-clie.Telfnos[1]:READ-ONLY IN FRAME F-Main        = TRUE.

ASSIGN 
       gn-clie.Telfnos[2]:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN txtStkLetras IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


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
  {src/adm/template/row-list.i "gn-clie"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "gn-clie"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-Linea-Credito V-table-Win 
PROCEDURE Calcula-Linea-Credito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR f-ImpLC AS DEC NO-UNDO.     
DEF VAR f-CodMon AS INT INIT 1 NO-UNDO.
DEF VAR x-CodCli AS CHAR NO-UNDO.
DEF VAR x-Agrupado AS LOG NO-UNDO.
DEF VAR pMaster AS CHAR.
DEF VAR pRelacionados AS CHAR.
DEF VAR pMonLC AS INT.

SESSION:SET-WAIT-STATE('GENERAL').

DO WITH FRAME {&FRAME-NAME}:

  txtStkLetras:SCREEN-VALUE = "0".
  
  /* Stock de Letras */
  FIND FIRST ccbstklet WHERE ccbstklet.codcia = s-codcia AND 
                                ccbstklet.codclie = gn-clie.CodCli NO-LOCK NO-ERROR.
  IF AVAILABLE ccbstklet THEN txtStkLetras:SCREEN-VALUE = STRING(ccbstklet.qstklet,"->>,>>99").

    x-Agrupado = NO.
    RUN ccb/p-cliente-master (gn-clie.CodCli,
                              OUTPUT pMaster,
                              OUTPUT pRelacionados,
                              OUTPUT x-Agrupado).
    RUN ccb/p-implc (cl-codcia,
                     gn-clie.CodCli,
                     s-coddiv,
                     OUTPUT pMonLC,
                     OUTPUT F-LinCre).
    RUN ccb/p-saldo-actual-cliente (gn-clie.CodCli,
                                    s-CodDiv,
                                    pMonLC,
                                    OUTPUT F-CreUsa).
    f-MonLC = ENTRY(pMonLC, 'S/,US$').
    F-CreDis = F-LinCre - F-CreUsa.
    FILL-IN_LinCre = F-LinCre.
    FILL-IN_CodCli = pMaster.
    FIND B-CLIE WHERE B-CLIE.codcia = cl-codcia AND B-CLIE.codcli = pMaster NO-LOCK NO-ERROR.
    IF AVAILABLE B-CLIE THEN FILL-IN_NomCli = B-CLIE.nomcli.
    DISPLAY
        F-Credis F-CreUsa FILL-IN_LinCre FILL-IN_CodCli FILL-IN_NomCli F-LinCre f-MonLC.
    /* Clientes Relacionados */
    SELECT-Relacionados:DELETE(SELECT-Relacionados:LIST-ITEMS).
    DEF VAR k AS INT NO-UNDO.
    DO k = 1 TO NUM-ENTRIES(pRelacionados):
        FIND B-CLIE WHERE B-CLIE.codcia = cl-codcia 
            AND B-CLIE.codcli = ENTRY(k,pRelacionados) 
            NO-LOCK NO-ERROR.
        IF AVAILABLE B-CLIE THEN SELECT-Relacionados:ADD-LAST(B-CLIE.codcli + ' ' + B-CLIE.nomcli).
    END.
    DISPLAY SELECT-Relacionados.
END.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/*

DEF VAR f-ImpLC AS DEC NO-UNDO.     
DEF VAR f-CodMon AS INT INIT 1 NO-UNDO.
DEF VAR x-CodCli AS CHAR NO-UNDO.
DEF VAR x-Agrupado AS LOG NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').

DO WITH FRAME {&FRAME-NAME}:
    x-CodCli = gn-clie.CodCli.
    /* ************************************* */
    /* Verificamos si es un cliente agrupado */
    /* ¿es el Master? */
    /* ************************************* */
    x-Agrupado = NO.
    FIND Vtactabla WHERE VtaCTabla.CodCia = s-CodCia AND
        VtaCTabla.Tabla = 'CLGRP' AND 
        VtaCTabla.Llave = gn-clie.CodCli
        NO-LOCK NO-ERROR.
    IF AVAILABLE Vtactabla THEN x-Agrupado = YES.
    ELSE DO:
        /* ¿es el relacionado? */
        FIND FIRST Vtadtabla WHERE VtaDTabla.CodCia = s-CodCia
            AND VtaDTabla.Tabla = 'CLGRP'
            AND VtaDTabla.Tipo  = gn-clie.CodCli
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaDTabla THEN DO:
            FIND VtaCTabla OF VtaDTabla NO-LOCK NO-ERROR.
            IF AVAILABLE VtaCTabla THEN DO:
                x-Agrupado = YES.
                x-CodCli = VtaCTabla.Llave.      /* OJO */
            END.
        END.
    END.
    
    FOR EACH Gn-ClieL WHERE Gn-ClieL.CodCia = gn-clie.CodCia
        AND Gn-ClieL.CodCli = x-CodCli
        AND Gn-ClieL.FchIni <> ?
        AND Gn-ClieL.FchFin <> ?
        AND TODAY >= Gn-ClieL.FchIni
        AND TODAY <= Gn-ClieL.FchFin NO-LOCK
        BY gn-cliel.fchini BY gn-cliel.fchfin:
        F-LinCre = Gn-ClieL.ImpLC.     /* LINEA DE CREDITO TOTAL */
        /* LINEA DE CREDITO ATLAS */
        FILL-IN-LinAtlas = Gn-ClieL.LCImpDiv[1].
        /* LINEA DE CREDITO PERU COMPRAS */
        FILL-IN-LinPeru = Gn-ClieL.LCImpDiv[2].
        /* LINEA DE CREDITO OTROS */
        FILL-IN-LinOtros = Gn-ClieL.LCSdoDiv.
    END.
    /* Linea de Credito usado por el cliente en la consutla */
    RUN ccb/p-saldo-actual-cliente (gn-clie.codcli,'00150',f-CodMon,OUTPUT FILL-IN-UsoAtlas).
    RUN ccb/p-saldo-actual-cliente (gn-clie.codcli,'00070',f-CodMon,OUTPUT FILL-IN-UsoPeru).
    RUN ccb/p-saldo-actual-cliente (gn-clie.codcli,'',f-CodMon,OUTPUT FILL-IN-UsoOtros).
    FILL-IN-UsoOtros = FILL-IN-UsoOtros - FILL-IN-UsoAtlas - FILL-IN-UsoPeru.

    /* Ic - 01Jun2018, Linea de credito usado por el resto del grupo */
    IF x-Agrupado = YES THEN DO:

        DEFINE VAR x-uso-atlas AS DEC INIT 0.
        DEFINE VAR x-uso-pc AS DEC INIT 0.
        DEFINE VAR x-uso-otros AS DEC INIT 0.

        DEFINE VAR x-uso-atlas2 AS DEC.
        DEFINE VAR x-uso-pc2 AS DEC.
        DEFINE VAR x-uso-otros2 AS DEC.

        FOR EACH Vtadtabla WHERE VtaDTabla.CodCia = s-CodCia AND 
                                    VtaDTabla.Tabla = 'CLGRP' AND
                                    VtaDTabla.Llave = x-CodCli NO-LOCK:
            x-uso-atlas2 = 0.
            x-uso-pc2 = 0.
            x-uso-otros2 = 0.

            IF VtaDTabla.Tipo <> gn-clie.codcli THEN DO:
                RUN ccb/p-saldo-actual-cliente (VtaDTabla.Tipo,'00150',f-CodMon,OUTPUT x-uso-atlas2).
                RUN ccb/p-saldo-actual-cliente (VtaDTabla.Tipo,'00070',f-CodMon,OUTPUT x-uso-pc2).
                RUN ccb/p-saldo-actual-cliente (VtaDTabla.Tipo,'',f-CodMon,OUTPUT x-uso-otros2).

                x-uso-otros2 = x-uso-otros2 -  x-uso-atlas2 - x-uso-pc2.
            END.
            x-uso-atlas = x-uso-atlas + x-uso-atlas2.
            x-uso-pc = x-uso-pc + x-uso-pc2.
            x-uso-otros = x-uso-otros + x-uso-otros2.
        END.
        FILL-IN-UsoAtlas2  = x-uso-atlas.
        FILL-IN-UsoPeru2 = x-uso-pc.
        FILL-IN-UsoOtros2 = x-uso-otros2.
    END.
    /* Ic - 01Jun2018 */

    FILL-IN-SdoAtlas = FILL-IN-LinAtlas - FILL-IN-UsoAtlas - FILL-IN-UsoAtlas2.
    FILL-IN-SdoPeru  = FILL-IN-LinPeru  - FILL-IN-UsoPeru - FILL-IN-UsoPeru2.
    FILL-IN-SdoOtros = FILL-IN-LinOtros - FILL-IN-UsoOtros - FILL-IN-UsoOtros2.
    DISPLAY  
        FILL-IN-LinAtlas FILL-IN-LinOtros FILL-IN-LinPeru 
        FILL-IN-SdoAtlas FILL-IN-SdoOtros FILL-IN-SdoPeru FILL-IN-UsoAtlas 
        FILL-IN-UsoOtros FILL-IN-UsoPeru
        FILL-IN-UsoAtlas2 FILL-IN-UsoPeru2 FILL-IN-UsoOtros2.

    F-CreUsa = FILL-IN-UsoAtlas + FILL-IN-UsoPeru + FILL-IN-UsoOtros.
    F-CreUsa = F-CreUsa + FILL-IN-UsoAtlas2 + FILL-IN-UsoPeru2 + FILL-IN-UsoOtros2.

    F-CreDis = F-LinCre - F-CreUsa.

    DISPLAY  F-Credis F-CreUsa F-LinCre.
    /* *********************************************************************** */
    /* RHC 19/10/2017 Julissa */
    /* *********************************************************************** */
    DEF VAR s-Agrupado AS LOG NO-UNDO.
    DEF VAR pCodCli AS CHAR NO-UNDO.    /* Cliente GRUPAL */
    DEF VAR pImpLCred AS DEC NO-UNDO.
    ASSIGN
        s-Agrupado = NO
        pCodCli = gn-clie.codcli
        pImpLCred = 0.
    ASSIGN
        FILL-IN_CodCli = ''
        FILL-IN_LinCre = 0
        FILL-IN_NomCli = ''.
    FIND Vtactabla WHERE VtaCTabla.CodCia = s-CodCia AND
        VtaCTabla.Tabla = 'CLGRP' AND 
        VtaCTabla.Llave = gn-clie.CodCli
        NO-LOCK NO-ERROR.
    IF AVAILABLE Vtactabla THEN s-Agrupado = YES.
    ELSE DO:
        /* ¿es el relacionado? */
        FIND FIRST Vtadtabla WHERE VtaDTabla.CodCia = s-CodCia
            AND VtaDTabla.Tabla = 'CLGRP'
            AND VtaDTabla.Tipo  = gn-clie.CodCli
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaDTabla THEN DO:
            FIND VtaCTabla OF VtaDTabla NO-LOCK NO-ERROR.
            IF AVAILABLE VtaCTabla THEN DO:
                s-Agrupado = YES.
                pCodCli = VtaCTabla.Llave.      /* OJO */
            END.
        END.
    END.
    IF s-Agrupado = YES THEN DO:
        FIND B-CLIE WHERE B-CLIE.codcia = cl-codcia 
            AND B-CLIE.codcli = pCodCli
            NO-LOCK NO-ERROR.
        IF AVAILABLE B-CLIE THEN DO:
            ASSIGN
                FILL-IN_CodCli = B-CLIE.codcli
                FILL-IN_NomCli = B-CLIE.nomcli.
            FOR EACH Gn-ClieL WHERE Gn-ClieL.CodCia = cl-CodCia
                AND Gn-ClieL.CodCli = pCodCli
                AND Gn-ClieL.FchIni <> ? 
                AND Gn-ClieL.FchFin <> ? 
                AND TODAY >= Gn-ClieL.FchIni 
                AND TODAY <= Gn-ClieL.FchFin NO-LOCK
                BY gn-cliel.fchini BY gn-cliel.fchfin:
                pImpLCred = Gn-ClieL.ImpLC.     /* Valor por defecto */
            END.
            ASSIGN
                FILL-IN_LinCre = pImpLCred.
        END.
    END.
    DISPLAY FILL-IN_CodCli FILL-IN_LinCre FILL-IN_NomCli.
END.

SESSION:SET-WAIT-STATE('').
*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-linea-credito V-table-Win 
PROCEDURE get-linea-credito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pLineaCredito AS CHAR.
DEFINE OUTPUT PARAMETER pCreditoUtilizado AS CHAR.
DEFINE OUTPUT PARAMETER pCreditoDisponible AS CHAR.

pLineaCredito = F-LinCre:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
pCreditoUtilizado = F-CreUsa:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
pCreditoDisponible = F-Credis:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

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
  ASSIGN
      F-Credis = 0
      F-CreUsa = 0
      FILL-IN_LinCre = 0
      F-LinCre = 0
      FILL-IN_CodCli = ''
      FILL-IN_NomCli = ''
      .
  DISPLAY F-Credis F-CreUsa FILL-IN_LinCre F-LinCre
      FILL-IN_CodCli FILL-IN_NomCli 
      WITH FRAME {&FRAME-NAME}.
  IF AVAILABLE gn-clie THEN RUN Calcula-Linea-Credito.

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
  {src/adm/template/snd-list.i "gn-clie"}

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
   /* IF CAMPO:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CAMPO.
         RETURN "ADM-ERROR".   
   
      END.
   */

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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSdoAct V-table-Win 
FUNCTION fSdoAct RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR f-Total  AS DEC NO-UNDO.
DEF VAR x-ImpLin AS DEC NO-UNDO.

    f-Total = 0.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK:
        x-ImpLin = (FacDPedi.CanPed - FacDPedi.CanAte) * FacDPedi.ImpLin / FacDPedi.CanPed.
        IF x-ImpLin > 0 THEN f-Total = f-Total + x-ImpLin.
    END.             
    RETURN f-Total.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

