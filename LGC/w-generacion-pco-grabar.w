&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttFacDPedi NO-UNDO LIKE FacDPedi.



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
DEFINE INPUT PARAMETER pCodDOc AS CHAR.
DEFINE INPUT PARAMETER pNroPed AS CHAR.
DEFINE INPUT PARAMETER pFechaEntrega AS DATE.
DEFINE INPUT PARAMETER pFechaTope AS DATE.

DEFINE BUFFER x-facdpedi FOR facdpedi.

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VAR S-CODCLI AS CHAR.

/* Solo una PCO x Cotizacion */
FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
                            faccpedi.coddoc = 'PCO' AND
                            faccpedi.codref = pCodDoc AND 
                            faccpedi.nroref = pNroPed AND 
                            (faccpedi.flgest = 'G' OR faccpedi.flgest = 'T') NO-LOCK NO-ERROR.
IF AVAILABLE faccpedi THEN DO:
    /*
    MESSAGE "Cotizacion ya tiene generado una PCO".
    RETURN "ADM-ERROR".
    */
END.

FIND FIRST facdpedi WHERE facdpedi.codcia = s-codcia AND
                            facdpedi.coddoc = pCodDOc AND
                            facdpedi.nroped = pNroPed AND
                            (facdpedi.canped - facdpedi.canate) > 0 NO-LOCK NO-ERROR.
IF NOT AVAILABLE facdpedi THEN DO:
    MESSAGE "La cotizacion no tiene pendiente de entrega".
    RETURN "ADM-EROR".
END.

FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
                            faccpedi.coddoc = pCodDoc AND 
                            faccpedi.nroped = pNroPed NO-LOCK NO-ERROR.
IF NOT AVAILABLE faccpedi THEN DO:
    MESSAGE "Cotizacion no existe ó esta anulada".
    RETURN "ADM-ERROR".
END.

S-CODCLI = faccpedi.codcli.

FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND 
                            gn-clie.codcli = faccpedi.codcli NO-LOCK NO-ERROR.

DEFINE VAR x-peso AS DEC INIT 0.
DEFINE VAR x-importe AS DEC INIT 0.

DEFINE VAR x-cantidad-anterior AS DEC INIT 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-6

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttFacDPedi Almmmatg

/* Definitions for BROWSE BROWSE-6                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-6 ttFacDPedi.codmat Almmmatg.DesMat ~
Almmmatg.DesMar ttFacDPedi.UndVta ttFacDPedi.CanPed ttFacDPedi.canate ~
ttFacDPedi.CanSol 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-6 ttFacDPedi.CanSol 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-6 ttFacDPedi
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-6 ttFacDPedi
&Scoped-define QUERY-STRING-BROWSE-6 FOR EACH ttFacDPedi NO-LOCK, ~
      EACH Almmmatg OF ttFacDPedi NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-6 OPEN QUERY BROWSE-6 FOR EACH ttFacDPedi NO-LOCK, ~
      EACH Almmmatg OF ttFacDPedi NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-6 ttFacDPedi Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-6 ttFacDPedi
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-6 Almmmatg


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-6}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK BUTTON-3 Btn_Cancel txtFechaEntrega ~
BROWSE-6 
&Scoped-Define DISPLAYED-OBJECTS txtCotizacion txtCliente txtemision ~
txtEntregaTentativa txtFechaTope txtFechaEntrega FILL-IN-peso ~
FILL-IN-importe 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-END-KEY 
     LABEL "Generar PCO" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-3 
     LABEL "Cta Cte." 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-importe AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Importe" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-msg AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Fill 1" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-peso AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Peso" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1
     FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE txtCliente AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 55.14 BY 1
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtCotizacion AS CHARACTER FORMAT "X(12)":U 
     LABEL "Cotizacion" 
     VIEW-AS FILL-IN 
     SIZE 17.29 BY 1
     FGCOLOR 4 FONT 11 NO-UNDO.

DEFINE VARIABLE txtemision AS DATE FORMAT "99/99/9999":U 
     LABEL "Emision" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtEntregaTentativa AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha abastecimiento" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE txtFechaEntrega AS DATE FORMAT "99/99/9999":U 
     LABEL "Entrega" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtFechaTope AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Tope" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-6 FOR 
      ttFacDPedi, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-6 D-Dialog _STRUCTURED
  QUERY BROWSE-6 NO-LOCK DISPLAY
      ttFacDPedi.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U COLUMN-FONT 0
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 39.57 COLUMN-FONT 0
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U WIDTH 15.43
            COLUMN-FONT 0
      ttFacDPedi.UndVta FORMAT "x(8)":U WIDTH 6.72 COLUMN-FONT 0
      ttFacDPedi.CanPed COLUMN-LABEL "Pedida" FORMAT ">,>>>,>>9.9999":U
            WIDTH 10.43 COLUMN-FONT 0
      ttFacDPedi.canate COLUMN-LABEL "x Atender" FORMAT ">,>>>,>>9.99":U
            WIDTH 9.43 COLUMN-FONT 0
      ttFacDPedi.CanSol COLUMN-LABEL "Solicitada" FORMAT ">,>>>,>>9.99":U
            WIDTH 10.43 COLUMN-BGCOLOR 11 COLUMN-FONT 0
  ENABLE
      ttFacDPedi.CanSol
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 105 BY 19.58 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     txtCotizacion AT ROW 1.27 COL 10.72 COLON-ALIGNED WIDGET-ID 2
     txtCliente AT ROW 1.27 COL 28.86 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     Btn_OK AT ROW 1.5 COL 88
     BUTTON-3 AT ROW 2.35 COL 72 WIDGET-ID 20
     txtemision AT ROW 2.42 COL 11 COLON-ALIGNED WIDGET-ID 8
     txtEntregaTentativa AT ROW 2.46 COL 47.72 COLON-ALIGNED WIDGET-ID 6
     Btn_Cancel AT ROW 2.81 COL 88
     FILL-IN-msg AT ROW 3.31 COL 71 COLON-ALIGNED WIDGET-ID 16
     txtFechaTope AT ROW 3.5 COL 47.72 COLON-ALIGNED WIDGET-ID 18
     txtFechaEntrega AT ROW 3.65 COL 11.14 COLON-ALIGNED WIDGET-ID 10
     Btn_Help AT ROW 4.35 COL 88
     FILL-IN-peso AT ROW 4.65 COL 36 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-importe AT ROW 4.65 COL 60.43 COLON-ALIGNED WIDGET-ID 14
     BROWSE-6 AT ROW 6.04 COL 2 WIDGET-ID 200
     SPACE(2.13) SKIP(0.37)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Generacion de PCO." WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttFacDPedi T "?" NO-UNDO INTEGRAL FacDPedi
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
/* BROWSE-TAB BROWSE-6 FILL-IN-importe D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON Btn_Help IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       Btn_Help:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-importe IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-msg IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN-msg:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-peso IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtCliente IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtCotizacion IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtemision IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtEntregaTentativa IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtFechaTope IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-6
/* Query rebuild information for BROWSE BROWSE-6
     _TblList          = "Temp-Tables.ttFacDPedi,INTEGRAL.Almmmatg OF Temp-Tables.ttFacDPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.ttFacDPedi.codmat
"ttFacDPedi.codmat" "Codigo" ? "character" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? 0 ? ? ? no ? no no "39.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? 0 ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttFacDPedi.UndVta
"ttFacDPedi.UndVta" ? ? "character" ? ? 0 ? ? ? no ? no no "6.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ttFacDPedi.CanPed
"ttFacDPedi.CanPed" "Pedida" ? "decimal" ? ? 0 ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttFacDPedi.canate
"ttFacDPedi.canate" "x Atender" ">,>>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ttFacDPedi.CanSol
"ttFacDPedi.CanSol" "Solicitada" ">,>>>,>>9.99" "decimal" 11 ? 0 ? ? ? yes ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-6 */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Generacion de PCO. */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-6
&Scoped-define SELF-NAME BROWSE-6
&Scoped-define SELF-NAME ttFacDPedi.CanSol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttFacDPedi.CanSol BROWSE-6 _BROWSE-COLUMN D-Dialog
ON ENTRY OF ttFacDPedi.CanSol IN BROWSE BROWSE-6 /* Solicitada */
DO:
  x-cantidad-anterior = DECIMAL(ttfacdpedi.cansol:SCREEN-VALUE IN BROWSE {&browse-name}).
  fill-in-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-cantidad-anterior,"->>,>>>,>>9.99").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttFacDPedi.CanSol BROWSE-6 _BROWSE-COLUMN D-Dialog
ON LEAVE OF ttFacDPedi.CanSol IN BROWSE BROWSE-6 /* Solicitada */
DO:
    DEFINE VAR x-cantidad-x-atender AS DEC.
    DEFINE VAR x-cantidad AS DEC.
    DEFINE VAR x-precio AS DEC INIT 0.

    x-cantidad-x-atender = DECIMAL(ttfacdpedi.cansol:SCREEN-VALUE IN BROWSE {&browse-name}).

    IF x-cantidad-anterior <> x-cantidad-x-atender THEN DO:
        IF x-cantidad-x-atender > (ttfacdpedi.canped - ttfacdpedi.canate) THEN DO:
            MESSAGE "Cantidad a solicitada debe ser menor/igual a la cantidad por atender".
            APPLY 'ENTRY':U TO ttfacdpedi.cansol IN BROWSE {&BROWSE-NAME}.
            RETURN NO-APPLY.    /*"ADM-ERROR".*/
        END.

        x-precio = ttfacdpedi.implin / ttfacdpedi.canped.
        x-peso = x-peso - (x-cantidad-anterior * almmmatg.pesmat).
        x-peso = x-peso + (x-cantidad-x-atender * almmmatg.pesmat).
        x-importe = x-importe - (x-cantidad-anterior * x-precio).
        x-importe = x-importe + (x-cantidad-x-atender * x-precio).

        fill-in-peso:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-peso,"->>,>>>,>>9.99").
        fill-in-importe:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-importe,"->>,>>>,>>9.99").
        x-cantidad-anterior = 0.
    END.

    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help D-Dialog
ON CHOOSE OF Btn_Help IN FRAME D-Dialog /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
MESSAGE "Help for File: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Generar PCO */
DO:
    DEFINE VAR x-corre AS INT INIT 0.
    DEFINE VAR x-nroped AS CHAR.
    DEFINE VAR x-proceso-ok AS LOG.

    DEFINE BUFFER b-faccpedi FOR faccpedi.
    DEFINE BUFFER b-facdpedi FOR facdpedi.

    ASSIGN txtFechaEntrega txtEntregaTentativa txtFechaTope.

    IF txtFechaEntrega < txtEntregaTentativa THEN DO:
        MESSAGE "Fecha entrega debe ser mayor/igual a la de abastecimiento" + STRING(txtEntregaTentativa,"99/99/9999").
        RETURN NO-APPLY.
    END.
    IF txtFechaEntrega > txtFechaTope THEN DO:
        MESSAGE "Fecha entrega NO debe ser mayor/igual a la fecha TOPE" + STRING(txtFechaTope,"99/99/9999").
        RETURN NO-APPLY.
    END.

    FIND FIRST ttfacdpedi NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ttfacdpedi  THEN DO:
        MESSAGE "No existen articulos a trabajar".
        RETURN NO-APPLY.
    END.
    /**/
    VALIDAQTY:
    FOR EACH ttfacdpedi WHERE ttfacdpedi.cansol > 0 :
        IF (ttfacdpedi.canped - ttfacdpedi.canate) < ttfacdpedi.cansol THEN DO:
            MESSAGE "Existen cantidades solicitadas mayores a las cantidades por atender".
            RETURN NO-APPLY.
        END.
    END.

        MESSAGE 'Seguro de Grabar proceso?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
    
    FOR EACH b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND 
                                b-faccpedi.codref = 'COT' AND
                                b-faccpedi.nroref = faccpedi.nroped NO-LOCK:
        x-corre = x-corre + 1.
    END.
    x-corre = x-corre + 1.

    SESSION:SET-WAIT-STATE("GENERAL").
    x-proceso-ok = NO.
    DO TRANSACTION ON ERROR UNDO, LEAVE:
        CREATE b-faccpedi.
        BUFFER-COPY faccpedi EXCEPT coddoc nroped TO b-faccpedi.

        x-nroped = faccpedi.nroped + "-" + STRING(x-corre).
        ASSIGN b-faccpedi.coddoc = 'PCO'
                b-faccpedi.nroped = x-nroped
                b-faccpedi.codref = faccpedi.coddoc
                b-faccpedi.nroref = faccpedi.nroped
                b-faccpedi.fchped = TODAY
                b-faccpedi.fchent = txtFechaEntrega
                b-faccpedi.libre_f01 = txtEntregaTentativa  /* abastecimiento */
                b-faccpedi.libre_f02 = txtFechaTope   /* fecha tope */
                b-faccpedi.hora = STRING(TIME,"HH:MM:SS")
                b-faccpedi.usuario = s-user-id                
                b-faccpedi.flgest  = 'G'.

        FOR EACH ttfacdpedi WHERE ttfacdpedi.cansol > 0 ON ERROR UNDO, THROW:
            FIND FIRST facdpedi WHERE facdpedi.codcia = ttfacdpedi.codcia AND
                                        facdpedi.coddoc = faccpedi.coddoc AND
                                        facdpedi.nroped = faccpedi.nroped AND 
                                        facdpedi.codmat = ttfacdpedi.codmat EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE facdpedi THEN DO:
                ASSIGN facdpedi.canate = facdpedi.canate + ttfacdpedi.cansol.
                /**/
                CREATE b-facdpedi.
                BUFFER-COPY ttfacdpedi EXCEPT coddoc nroped TO b-facdpedi.
                ASSIGN  b-facdpedi.coddoc = b-faccpedi.coddoc
                        b-facdpedi.nroped = b-faccpedi.nroped
                        b-facdpedi.libre_d05 = ttfacdpedi.canped
                        b-facdpedi.canped = ttfacdpedi.cansol
                        b-facdpedi.libre_c01 = ""
                        b-facdpedi.libre_c02 = ""
                .
            END.
        END.
        x-proceso-ok = YES.
    END.
    
    RELEASE b-faccpedi.
    RELEASE b-facdpedi.
    SESSION:SET-WAIT-STATE("").

    IF x-proceso-ok = NO THEN DO:
        MESSAGE "Hubo problemas al actualizar la COTIZACION".
    END.
    ELSE DO:
        MESSAGE "Proceso Terminado".
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 D-Dialog
ON CHOOSE OF BUTTON-3 IN FRAME D-Dialog /* Cta Cte. */
DO:
  RUN vta2/d-ctactepend.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-detalle D-Dialog 
PROCEDURE cargar-detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE('GENERAL').

txtCotizacion:SCREEN-VALUE IN FRAME {&FRAME-NAME} = faccpedi.nroped.
txtCliente:SCREEN-VALUE IN FRAME {&FRAME-NAME} = faccpedi.nomcli.
txtemision:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(faccpedi.fchped,"99/99/9999").
txtentregatentativa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(pFechaEntrega,"99/99/9999").
txtFechaTope:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(pFechaTope,"99/99/9999").
txtfechaentrega:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(pFechaEntrega,"99/99/9999").

DEFINE BUFFER x-almmmatg FOR almmmatg.
DEFINE VAR x-precio AS DEC.

FOR EACH facdpedi OF faccpedi NO-LOCK:
    IF (facdpedi.canped - facdpedi.canate) > 0 THEN DO:
        FIND FIRST x-almmmatg OF facdpedi NO-LOCK NO-ERROR.
        IF AVAILABLE x-almmmatg THEN DO:            
            x-peso = x-peso + ((facdpedi.canped - facdpedi.canate) * x-almmmatg.pesmat).
        END.
        x-precio = facdpedi.implin / facdpedi.canped.
        x-importe = x-importe + ((facdpedi.canped - facdpedi.canate) * x-precio).
        CREATE ttFacdpedi.
            BUFFER-COPY facdpedi TO ttfacdpedi.
        ASSIGN  ttFacdpedi.cansol = facdpedi.canped - facdpedi.canate.
    END.
END.

fill-in-peso:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-peso,"->>,>>>,>>9.99").
fill-in-importe:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-importe,"->>,>>>,>>9.99").

{&OPEN-QUERY-BROWSE-6}

SESSION:SET-WAIT-STATE('').

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
  DISPLAY txtCotizacion txtCliente txtemision txtEntregaTentativa txtFechaTope 
          txtFechaEntrega FILL-IN-peso FILL-IN-importe 
      WITH FRAME D-Dialog.
  ENABLE Btn_OK BUTTON-3 Btn_Cancel txtFechaEntrega BROWSE-6 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN cargar-detalle.

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
  {src/adm/template/snd-list.i "ttFacDPedi"}
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

