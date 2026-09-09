&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR cl-codcia AS INT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-55 RECT-56 FILL-IN-Canasta ~
FILL-IN-Anaquel Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Canasta FILL-IN-Anaquel F-CodCli ~
RADIO-SET-Libre_C01 f-ApePat f-ApeMat f-Nombre F-NomCli F-DirCli F-RucCli ~
F-DNICli 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "IMG/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 15 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "IMG/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.73
     BGCOLOR 8 .

DEFINE VARIABLE f-ApeMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Apellido Materno" 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81 NO-UNDO.

DEFINE VARIABLE f-ApePat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Apellido Paterno" 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE F-DirCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Direccion" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81 NO-UNDO.

DEFINE VARIABLE F-DNICli AS CHARACTER FORMAT "x(8)" 
     LABEL "DNI" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81.

DEFINE VARIABLE f-Nombre AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre/Razón Social" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81 NO-UNDO.

DEFINE VARIABLE F-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-RucCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "RUC" 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Anaquel AS CHARACTER FORMAT "X(256)":U 
     LABEL "Gabinete" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Canasta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Canasta" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Libre_C01 AS CHARACTER INITIAL "J" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Jurídica", "J",
"Natural", "N"
     SIZE 17 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-55
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 74 BY 7.31.

DEFINE RECTANGLE RECT-56
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 74 BY 2.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-Canasta AT ROW 1.58 COL 21 COLON-ALIGNED WIDGET-ID 2 PASSWORD-FIELD 
     FILL-IN-Anaquel AT ROW 2.54 COL 21 COLON-ALIGNED WIDGET-ID 62 PASSWORD-FIELD 
     F-CodCli AT ROW 4.08 COL 21 COLON-ALIGNED WIDGET-ID 42
     RADIO-SET-Libre_C01 AT ROW 4.08 COL 55 NO-LABEL WIDGET-ID 34
     f-ApePat AT ROW 4.88 COL 21 COLON-ALIGNED WIDGET-ID 40
     f-ApeMat AT ROW 5.69 COL 21 COLON-ALIGNED WIDGET-ID 38
     f-Nombre AT ROW 6.5 COL 21 COLON-ALIGNED WIDGET-ID 48
     F-NomCli AT ROW 7.38 COL 21 COLON-ALIGNED WIDGET-ID 50
     F-DirCli AT ROW 8.19 COL 21 COLON-ALIGNED WIDGET-ID 44
     F-RucCli AT ROW 9 COL 21 COLON-ALIGNED WIDGET-ID 52
     F-DNICli AT ROW 9.85 COL 21 COLON-ALIGNED HELP
          "DNI DEL (Cliente)" WIDGET-ID 46
     Btn_OK AT ROW 11.19 COL 3
     Btn_Cancel AT ROW 11.19 COL 19
     "Información del Cliente" VIEW-AS TEXT
          SIZE 17 BY .5 AT ROW 3.5 COL 4 WIDGET-ID 58
          BGCOLOR 9 FGCOLOR 15 
     "Persona:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 4.27 COL 48 WIDGET-ID 54
     RECT-55 AT ROW 3.69 COL 3 WIDGET-ID 56
     RECT-56 AT ROW 1.19 COL 3 WIDGET-ID 60
     SPACE(2.28) SKIP(9.72)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "RECEPCION DE CANASTAS"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
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
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN f-ApeMat IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-ApePat IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-CodCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DirCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DNICli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-Nombre IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-RucCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET RADIO-SET-Libre_C01 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* RECEPCION DE CANASTAS */
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
  ASSIGN 
      FILL-IN-Canasta FILL-IN-Anaquel
      f-ApeMat f-ApePat F-CodCli F-DirCli F-DNICli f-Nombre F-NomCli F-RucCli RADIO-SET-Libre_C01.

  /* Chequeo */
  FIND VtamBasket WHERE VtamBasket.CodCia = s-codcia
      AND VtamBasket.CodDiv = s-coddiv
      AND VtamBasket.Codigo = FILL-IN-Canasta
      AND VtamBasket.FlgEst = "L"   /* LIBRE */
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE VtamBasket THEN DO:
      MESSAGE 'Canasta NO válida' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  FIND VtamAnaquel WHERE VtamAnaquel.CodCia = s-codcia
      AND VtamAnaquel.CodDiv = s-coddiv
      AND VtamAnaquel.Codigo = FILL-IN-Anaquel
      AND VtamAnaquel.FlgEst = "L"  /* LIBRE */
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE VtamAnaquel THEN DO:
      MESSAGE 'Anaquel NO válido' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  DO TRANSACTION ON ERROR UNDO, RETURN NO-APPLY ON STOP UNDO, RETURN NO-APPLY:
      FIND CURRENT VtamBasket EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE VtamBasket THEN UNDO, RETURN NO-APPLY.
      FIND CURRENT VtamAnaquel EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE VtamAnaquel THEN UNDO, RETURN NO-APPLY.
      ASSIGN
          VtamAnaquel.FlgEst = "O"  /* OCUPADO */
          VtamAnaquel.Canasta = VtamBasket.Codigo
          VtamAnaquel.CodDoc = "" 
          VtamAnaquel.NroPed = "".
      ASSIGN
          VtamBasket.FlgEst = "R".  /* RECEPCIONADO */
      CREATE LogTabla.
      ASSIGN
          logtabla.codcia = s-codcia
          logtabla.Dia = TODAY
          logtabla.Evento = "R"
          logtabla.Hora = STRING(TIME, 'HH:MM:SS')
          logtabla.Tabla = "VtamBasket"
          logtabla.Usuario = s-user-id
          logtabla.ValorLlave = "CANASTA|" + s-coddiv + '|' + VtamBasket.Codigo + '|' +
                                VtamAnaquel.Codigo.
      /* Cliente */
      ASSIGN
          VtamAnaquel.CodCli = f-CodCli
          VtamAnaquel.DirCli = f-DirCli
          VtamAnaquel.ApeMat = f-ApeMat
          VtamAnaquel.ApePat = f-ApePat
          VtamAnaquel.Nombre = f-Nombre
          VtamAnaquel.NomCli = f-NomCli
          VtamAnaquel.DNI    = f-DniCli
          VtamAnaquel.Persona = RADIO-SET-Libre_C01
          VtamAnaquel.Ruc    = f-RucCli.
      RELEASE VtamBasket.
      RELEASE VtamAnaquel.
      RELEASE LogTabla.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-ApeMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-ApeMat D-Dialog
ON LEAVE OF f-ApeMat IN FRAME D-Dialog /* Apellido Materno */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    f-nomcli:SCREEN-VALUE = TRIM (f-apepat:SCREEN-VALUE) + " " +
        TRIM (f-apemat:SCREEN-VALUE) + ", " +
        f-nombre:SCREEN-VALUE.
    IF f-apepat:SCREEN-VALUE = '' AND f-apemat:SCREEN-VALUE = '' 
    THEN f-nomcli:SCREEN-VALUE = f-nombre:SCREEN-VALUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-ApePat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-ApePat D-Dialog
ON LEAVE OF f-ApePat IN FRAME D-Dialog /* Apellido Paterno */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    f-nomcli:SCREEN-VALUE = TRIM (f-apepat:SCREEN-VALUE) + " " +
        TRIM (f-apemat:SCREEN-VALUE) + ", " +
        f-nombre:SCREEN-VALUE.
    IF f-apepat:SCREEN-VALUE = '' AND f-apemat:SCREEN-VALUE = '' 
    THEN f-nomcli:SCREEN-VALUE = f-nombre:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodCli D-Dialog
ON LEAVE OF F-CodCli IN FRAME D-Dialog /* Codigo */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  ASSIGN
      SELF:SCREEN-VALUE = STRING(DECIMAL(SELF:SCREEN-VALUE), '99999999999') NO-ERROR.
  FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
      AND  gn-clie.CodCli = SELF:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie THEN DO:
      DISPLAY
          gn-clie.ApeMat @ f-ApeMat
          gn-clie.ApePat @ f-ApePat
          gn-clie.DirCli @ F-DirCli
          gn-clie.DNI    @ F-DNICli
          gn-clie.Nombre @ f-Nombre
          gn-clie.NomCli @ F-NomCli
          gn-clie.Ruc    @ F-RucCli
          WITH FRAME {&FRAME-NAME}.
      RADIO-SET-Libre_C01:SCREEN-VALUE = gn-clie.Libre_C01.
      ASSIGN
          f-ApeMat:SENSITIVE = NO
          f-ApePat:SENSITIVE = NO
          F-DirCli:SENSITIVE = NO
          F-DNICli:SENSITIVE = NO
          f-Nombre:SENSITIVE = NO
          F-NomCli:SENSITIVE = NO
          F-RucCli:SENSITIVE = NO
          RADIO-SET-Libre_C01:SENSITIVE = NO.
  END.
  ELSE DO:
      /* dígito verificador en caso de que se un número de ruc */
      DEF VAR pResultado AS CHAR.
      IF LOOKUP(SUBSTRING(SELF:SCREEN-VALUE,1,2), '10,20,15,17') > 0 THEN DO:
          RUN lib/_ValRuc (SELF:SCREEN-VALUE, OUTPUT pResultado).
          IF pResultado = 'ERROR' THEN DO:
              MESSAGE 'Código MAL registrado' VIEW-AS ALERT-BOX WARNING.
              RETURN NO-APPLY.
          END.
           RADIO-SET-Libre_C01:SCREEN-VALUE = "J".
      END.
      ELSE RADIO-SET-Libre_C01:SCREEN-VALUE = "N".
      DISPLAY
          "" @ f-ApeMat
          "" @ f-ApePat
          "" @ F-DirCli
          "" @ F-DNICli
          "" @ f-Nombre
          "" @ F-NomCli
          "" @ F-RucCli
          WITH FRAME {&FRAME-NAME}.
      RADIO-SET-Libre_C01:SCREEN-VALUE = "J".
      ASSIGN
          f-ApeMat:SENSITIVE = YES
          f-ApePat:SENSITIVE = YES
          F-DirCli:SENSITIVE = YES
          F-DNICli:SENSITIVE = YES
          f-Nombre:SENSITIVE = YES
          F-NomCli:SENSITIVE = NO
          F-RucCli:SENSITIVE = YES
          RADIO-SET-Libre_C01:SENSITIVE = YES.
      F-RucCli:SCREEN-VALUE = SUBSTRING(SELF:SCREEN-VALUE,1,11).
      APPLY 'VALUE-CHANGED':U TO RADIO-SET-Libre_C01.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-Nombre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-Nombre D-Dialog
ON LEAVE OF f-Nombre IN FRAME D-Dialog /* Nombre/Razón Social */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    f-nomcli:SCREEN-VALUE = TRIM (f-apepat:SCREEN-VALUE) + " " +
        TRIM (f-apemat:SCREEN-VALUE) + ", " +
        f-nombre:SCREEN-VALUE.
    IF f-apepat:SCREEN-VALUE = '' AND f-apemat:SCREEN-VALUE = '' 
    THEN f-nomcli:SCREEN-VALUE = f-nombre:SCREEN-VALUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-NomCli D-Dialog
ON LEAVE OF F-NomCli IN FRAME D-Dialog /* Nombre */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-RucCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-RucCli D-Dialog
ON LEAVE OF F-RucCli IN FRAME D-Dialog /* RUC */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    IF LENGTH(SELF:SCREEN-VALUE) < 11 OR LOOKUP(SUBSTRING(SELF:SCREEN-VALUE,1,2), '10,20,15,17') = 0 THEN DO:
        MESSAGE 'Debe tener 11 dígitos y comenzar con 20, 10, 15 ó 17' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    /* dígito verificador */
    DEF VAR pResultado AS CHAR.
    RUN lib/_ValRuc (SELF:SCREEN-VALUE, OUTPUT pResultado).
    IF pResultado = 'ERROR' THEN DO:
        MESSAGE 'Código MAL registrado' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-Libre_C01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-Libre_C01 D-Dialog
ON VALUE-CHANGED OF RADIO-SET-Libre_C01 IN FRAME D-Dialog
DO:
    IF SELF:SCREEN-VALUE <> "N" 
        THEN ASSIGN
        f-ApeMat:SENSITIVE = NO
        f-ApePat:SENSITIVE = NO
        f-Nombre:SENSITIVE = YES
        f-ApeMat:SCREEN-VALUE = ''
        f-ApePat:SCREEN-VALUE = ''.
    ELSE ASSIGN
        f-ApeMat:SENSITIVE = YES
        f-ApePat:SENSITIVE = YES
        f-Nombre:SENSITIVE = YES.
    APPLY 'LEAVE':U TO f-ApePat.
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
  DISPLAY FILL-IN-Canasta FILL-IN-Anaquel F-CodCli RADIO-SET-Libre_C01 f-ApePat 
          f-ApeMat f-Nombre F-NomCli F-DirCli F-RucCli F-DNICli 
      WITH FRAME D-Dialog.
  ENABLE RECT-55 RECT-56 FILL-IN-Canasta FILL-IN-Anaquel Btn_OK Btn_Cancel 
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
  DO WITH FRAME {&FRAME-NAME}:
/*       FOR EACH VtamAnaquel NO-LOCK WHERE VtamAnaquel.CodCia = s-codcia                              */
/*           AND VtamAnaquel.CodDiv = s-coddiv                                                         */
/*           AND VtamAnaquel.FlgEst = "L"                                                              */
/*           BREAK BY VtamAnaquel.Codigo:                                                              */
/*           IF FIRST-OF(VtamAnaquel.Codigo) THEN COMBO-BOX-Anaquel:SCREEN-VALUE = VtamAnaquel.Codigo. */
/*           COMBO-BOX-Anaquel:ADD-LAST(VtamAnaquel.Codigo).                                           */
/*       END.                                                                                          */
      /* RHC 30/06/2015 Depende de la división */
      FIND gn-divi WHERE gn-divi.codcia = s-codcia 
          AND gn-divi.coddiv = s-coddiv NO-LOCK.
      IF GN-DIVI.Campo-Log[1] = YES THEN  F-CodCli:SENSITIVE = YES.

  END.

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

