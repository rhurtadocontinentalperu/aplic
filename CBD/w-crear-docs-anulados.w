&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 rsTipoDoc txtSerie TxtNumero ~
RADIO-SET-como TxtNuevoNumero BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS rsTipoDoc txtSerie TxtNumero txtCodCliente ~
txtRUC txtNombreCliente RADIO-SET-como txtNuevaSerie TxtNuevoNumero 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Generar el Comprobante" 
     SIZE 32.29 BY 1.12.

DEFINE VARIABLE txtCodCliente AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cod.Cliente" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .96 NO-UNDO.

DEFINE VARIABLE txtNombreCliente AS CHARACTER FORMAT "X(80)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 43.57 BY .96 NO-UNDO.

DEFINE VARIABLE txtNuevaSerie AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 6.29 BY .96 NO-UNDO.

DEFINE VARIABLE TxtNuevoNumero AS INTEGER FORMAT "99999999":U INITIAL 0 
     LABEL "Numero" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .96 NO-UNDO.

DEFINE VARIABLE TxtNumero AS INTEGER FORMAT "99999999":U INITIAL 0 
     LABEL "Numero" 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .96 NO-UNDO.

DEFINE VARIABLE txtRUC AS CHARACTER FORMAT "X(12)":U 
     LABEL "R.U.C." 
     VIEW-AS FILL-IN 
     SIZE 17.72 BY .96 NO-UNDO.

DEFINE VARIABLE txtSerie AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 6.29 BY .96 NO-UNDO.

DEFINE VARIABLE RADIO-SET-como AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "ANULADO", 1,
"PENDIENTE", 2
     SIZE 15 BY 1.58 NO-UNDO.

DEFINE VARIABLE rsTipoDoc AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "BOLETA", "BOL",
"FACTURA", "FAC"
     SIZE 35 BY .96 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 58 BY 5.08.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.72 BY 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     rsTipoDoc AT ROW 1.96 COL 6.14 NO-LABEL WIDGET-ID 2
     txtSerie AT ROW 3.08 COL 9.43 COLON-ALIGNED WIDGET-ID 8
     TxtNumero AT ROW 3.08 COL 24.72 COLON-ALIGNED WIDGET-ID 10
     txtCodCliente AT ROW 4.31 COL 13.43 COLON-ALIGNED WIDGET-ID 24
     txtRUC AT ROW 4.31 COL 33.29 COLON-ALIGNED WIDGET-ID 26
     txtNombreCliente AT ROW 5.42 COL 13.43 COLON-ALIGNED WIDGET-ID 28
     RADIO-SET-como AT ROW 7.42 COL 46.43 NO-LABEL WIDGET-ID 30
     txtNuevaSerie AT ROW 8.04 COL 9.43 COLON-ALIGNED WIDGET-ID 16
     TxtNuevoNumero AT ROW 8.04 COL 24.72 COLON-ALIGNED WIDGET-ID 14
     BUTTON-1 AT ROW 10.23 COL 29.29 WIDGET-ID 22
     "El Numero del documento a crear como" VIEW-AS TEXT
          SIZE 32.72 BY .62 AT ROW 6.77 COL 13.29 WIDGET-ID 20
          BGCOLOR 4 FGCOLOR 15 FONT 6
     "[  Documento de REFERENCIA que se toma como base  ]" VIEW-AS TEXT
          SIZE 48 BY .62 AT ROW 1.15 COL 5 WIDGET-ID 12
          FGCOLOR 9 FONT 6
     RECT-1 AT ROW 1.5 COL 3 WIDGET-ID 6
     RECT-2 AT ROW 7.46 COL 3.29 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.14 BY 17 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Genera comprobantes anulados"
         HEIGHT             = 10.88
         WIDTH              = 63.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN txtCodCliente IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtNombreCliente IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtNuevaSerie IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtRUC IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Genera comprobantes anulados */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Genera comprobantes anulados */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Main
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Main W-Win
ON LEAVE OF FRAME F-Main
DO:
  RUN muestra-datos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Generar el Comprobante */
DO:
  
    ASSIGN rsTipoDoc txtSerie txtNumero txtNuevaSerie txtNuevoNumero radio-set-como.

    DEFINE VAR x-serie AS CHAR.
    DEFINE VAR x-numero AS CHAR.
    DEFINE VAR x-numero-doc AS CHAR.
    DEFINE VAR x-nueva-serie AS CHAR.
    DEFINE VAR x-nuevo-numero AS CHAR.
    DEFINE VAR x-nuevo-numero-doc AS CHAR.

    DEFINE VAR x-como-se-crea AS CHAR.

    x-como-se-crea = "ANULADO".
    IF radio-set-como = 2 THEN x-como-se-crea = "PENDIENTE".

    x-serie = STRING(txtSerie,"999").
    x-numero = STRING(txtNumero,"99999999").
    x-numero-doc = x-serie + x-numero.

    x-nueva-serie = STRING(txtNuevaSerie,"999").
    x-nuevo-numero = STRING(txtNuevoNumero,"99999999").
    x-nuevo-numero-doc = x-nueva-serie + x-nuevo-numero.

    DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.

    /* Buscamos que el documento de REFERENCIA exista */
    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                                ccbcdocu.coddoc = rsTipoDOc AND 
                                ccbcdocu.nrodoc = x-numero-doc NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcdocu THEN DO:

        IF ccbcdocu.flgest = 'A' THEN DO:
            MESSAGE 'El documento de REFERENCIA esta anulado' SKIP
                    'Continuamos con la creacion?'
                     VIEW-AS ALERT-BOX QUESTION
                    BUTTONS YES-NO UPDATE rpta2 AS LOG.
            IF rpta2 = NO THEN RETURN NO-APPLY.

        END.

        /* El nuevo documento a Crear */
        FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND 
                                    x-ccbcdocu.coddoc = rsTipoDOc AND 
                                    x-ccbcdocu.nrodoc = x-nuevo-numero-doc NO-LOCK NO-ERROR.
        IF AVAILABLE x-ccbcdocu THEN DO:
            MESSAGE "El nuevo documento a crear como " + x-como-se-crea + ", ya existe".
            RETURN NO-APPLY.
        END.

        /* Validar que el nuevo documento a crear sea un numero intermedio */
        FIND FIRST faccorre WHERE faccorre.codcia = s-codcia AND 
                                    faccorre.coddoc = rsTipoDoc AND 
                                    faccorre.nroser = txtNuevaSerie NO-LOCK NO-ERROR.
        IF NOT AVAILABLE faccorre THEN DO:
            MESSAGE "La serie del documento a crear no existe".
            RETURN NO-APPLY.
        END.
        IF faccorre.flgest = NO THEN DO:
            MESSAGE "La serie del documento a crear no esta activo".
            RETURN NO-APPLY.
        END.
        /* Chequeamos que el numero a crear este por debajo del correlativo */
        IF txtNuevoNumero > faccorre.correlativo THEN DO:
            MESSAGE "El nuevo numero documento que desea crear, excede al ultimo correlativo!!!".
            RETURN NO-APPLY.
        END.

        MESSAGE 'Esta SEGURO de crear el documento ' + x-como-se-crea + ' ?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

        /* Creamo el registro */
        CREATE x-ccbcdocu.
        BUFFER-COPY ccbcdocu EXCEPT nrodoc TO x-ccbcdocu.
            ASSIGN
            /*x-ccbcdocu.fchdoc = TODAY  Toma la misma fecha del documento de REFERENCIA  */
            x-ccbcdocu.flgest = IF radio-set-como = 2 THEN 'P' ELSE 'A'
            x-ccbcdocu.nrodoc = x-nuevo-numero-doc 
            x-ccbcdocu.usuario = s-user-id
            x-ccbcdocu.horcie = STRING(TIME,"HH:MM:SS")
            x-ccbcdocu.fchcobranza = TODAY
            x-ccbcdocu.codcaja = ""
            x-ccbcdocu.fchvto = TODAY
            x-ccbcdocu.fchcan = TODAY
            NO-ERROR. 
        IF ERROR-STATUS:ERROR = YES THEN DO:
            MESSAGE "Hubo problemas al crear el documento.".
        END.

    END.
    ELSE DO:
        MESSAGE "El documento de REFERENCIA no existe".
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TxtNumero
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TxtNumero W-Win
ON LEAVE OF TxtNumero IN FRAME F-Main /* Numero */
DO:
  RUN muestra-datos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtSerie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtSerie W-Win
ON LEAVE OF txtSerie IN FRAME F-Main /* Serie */
DO:
  txtNuevaSerie:SCREEN-VALUE IN FRAME {&FRAME-NAME} = txtSerie:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  RUN muestra-datos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY rsTipoDoc txtSerie TxtNumero txtCodCliente txtRUC txtNombreCliente 
          RADIO-SET-como txtNuevaSerie TxtNuevoNumero 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 rsTipoDoc txtSerie TxtNumero RADIO-SET-como 
         TxtNuevoNumero BUTTON-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE muestra-datos W-Win 
PROCEDURE muestra-datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-tipo-doc AS CHAR.
DEFINE VAR x-serie-doc AS CHAR.
DEFINE VAR x-numero-doc AS CHAR.

x-tipo-doc = rsTipoDoc:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
x-serie-doc = TRIM(txtSerie:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
x-numero-doc = TRIM(txtNumero:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

x-serie-doc = STRING(INTEGER(x-serie-doc),"999").
x-numero-doc = STRING(INTEGER(x-numero-doc),"99999999").

FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                            ccbcdocu.coddoc = x-tipo-doc AND 
                            ccbcdocu.nrodoc = x-serie-doc + x-numero-doc NO-LOCK NO-ERROR.

txtCodCliente:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
txtRUC:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
txtNombreCliente:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

IF AVAILABLE ccbcdocu THEN DO:
    txtCodCliente:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ccbcdocu.codcli.
    txtRUC:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ccbcdocu.ruc.
    txtNombreCliente:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ccbcdocu.nomcli.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
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

