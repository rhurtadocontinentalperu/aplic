&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
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
DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pOk AS CHAR.

ASSIGN
    pOk = "ADM-ERROR".

FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN.
/* Debe tener al menos 1 producto ARTE */
DEF VAR pImporteArte AS DEC NO-UNDO.
FOR EACH Facdpedi OF Faccpedi NO-LOCK, 
    FIRST Almmmatg OF Facdpedi NO-LOCK WHERE Almmmatg.codfam = '014':
    pImporteArte = pImporteArte + Facdpedi.ImpLin.
END.
IF pImporteArte <= 0 THEN DO:
    pOk = "OK".
    RETURN.
END.

/* Verificamos que NO esté registrado */
FIND BaseArte WHERE BaseArte.CodCia = Faccpedi.codcia
    AND BaseArte.CodDiv = Faccpedi.coddiv
    AND BaseArte.NroDocumento = Faccpedi.atencion
    NO-LOCK NO-ERROR.
IF AVAILABLE BaseArte THEN DO:
    pOk = "OK".
    RETURN.
END.
MESSAGE "Desea Registrarse en la Base de Clientes de productos de ARTE?"
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN DO:
    pOk = "OK".
    RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES BaseArte

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define QUERY-STRING-D-Dialog FOR EACH BaseArte SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH BaseArte SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog BaseArte
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog BaseArte


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN_NroDocumento FILL-IN_ApePat ~
FILL-IN_ApeMat FILL-IN_Nombre FILL-IN_DscDireccion FILL-IN_DscDistrito ~
FILL-IN_TelefonoFijo FILL-IN_TelefonoCelular FILL-IN_DscProfesion Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_NroDocumento FILL-IN_ApePat ~
FILL-IN_ApeMat FILL-IN_Nombre FILL-IN_DscNombre FILL-IN_DscDireccion ~
FILL-IN_DscDistrito FILL-IN_TelefonoFijo FILL-IN_TelefonoCelular ~
FILL-IN_DscProfesion 

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
     SIZE 15 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.73
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN_ApeMat AS CHARACTER FORMAT "X(20)" 
     LABEL "Ap. Materno" 
     VIEW-AS FILL-IN 
     SIZE 21.43 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_ApePat AS CHARACTER FORMAT "X(20)" 
     LABEL "Ap. Paterno" 
     VIEW-AS FILL-IN 
     SIZE 21.43 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_DscDireccion AS CHARACTER FORMAT "x(100)" 
     LABEL "Dirección" 
     VIEW-AS FILL-IN 
     SIZE 64.14 BY 1.

DEFINE VARIABLE FILL-IN_DscDistrito AS CHARACTER FORMAT "x(30)" 
     LABEL "Distrito" 
     VIEW-AS FILL-IN 
     SIZE 31.43 BY 1.

DEFINE VARIABLE FILL-IN_DscNombre AS CHARACTER FORMAT "x(60)" 
     LABEL "Apellidos y Nombres" 
     VIEW-AS FILL-IN 
     SIZE 61.43 BY 1.

DEFINE VARIABLE FILL-IN_DscProfesion AS CHARACTER FORMAT "x(30)" 
     LABEL "Profesion" 
     VIEW-AS FILL-IN 
     SIZE 31.43 BY 1.

DEFINE VARIABLE FILL-IN_Nombre AS CHARACTER FORMAT "X(20)" 
     LABEL "Nombres" 
     VIEW-AS FILL-IN 
     SIZE 21.43 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroDocumento AS CHARACTER FORMAT "X(12)" 
     LABEL "Nro Doc Identidad" 
     VIEW-AS FILL-IN 
     SIZE 21.43 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_TelefonoCelular AS CHARACTER FORMAT "x(20)" 
     LABEL "Telefono Celular" 
     VIEW-AS FILL-IN 
     SIZE 21.43 BY 1.

DEFINE VARIABLE FILL-IN_TelefonoFijo AS CHARACTER FORMAT "x(20)" 
     LABEL "Telefono Fijo" 
     VIEW-AS FILL-IN 
     SIZE 21.43 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      BaseArte SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN_NroDocumento AT ROW 2.92 COL 26 COLON-ALIGNED WIDGET-ID 18
     FILL-IN_ApePat AT ROW 3.88 COL 26 COLON-ALIGNED HELP
          "Apellido paterno del personal" WIDGET-ID 4
     FILL-IN_ApeMat AT ROW 4.85 COL 26 COLON-ALIGNED HELP
          "Apellido materno del personal" WIDGET-ID 2
     FILL-IN_Nombre AT ROW 5.81 COL 26 COLON-ALIGNED HELP
          "Nombres del personal" WIDGET-ID 20
     FILL-IN_DscNombre AT ROW 6.77 COL 9.14 WIDGET-ID 10
     FILL-IN_DscDireccion AT ROW 7.73 COL 19 HELP
          "Direcci¢n del Cliente" WIDGET-ID 6
     FILL-IN_DscDistrito AT ROW 8.69 COL 26 COLON-ALIGNED WIDGET-ID 8
     FILL-IN_TelefonoFijo AT ROW 9.65 COL 26 COLON-ALIGNED WIDGET-ID 16
     FILL-IN_TelefonoCelular AT ROW 10.62 COL 26 COLON-ALIGNED WIDGET-ID 14
     FILL-IN_DscProfesion AT ROW 11.58 COL 26 COLON-ALIGNED WIDGET-ID 12
     Btn_OK AT ROW 13.31 COL 4
     Btn_Cancel AT ROW 13.31 COL 19
     "REGISTRO DE CLIENTES EN LA BASE DE ARTE" VIEW-AS TEXT
          SIZE 81 BY .77 AT ROW 1.38 COL 10 WIDGET-ID 22
          BGCOLOR 9 FGCOLOR 15 FONT 8
     SPACE(15.56) SKIP(13.34)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE ""
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
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_DscDireccion IN FRAME D-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN_DscNombre IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "INTEGRAL.BaseArte"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancel */
DO:
  ASSIGN
    pOk = "ADM-ERROR".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
  ASSIGN FILL-IN_ApeMat FILL-IN_ApePat FILL-IN_DscDireccion 
        FILL-IN_DscDistrito FILL-IN_DscNombre FILL-IN_DscProfesion 
        FILL-IN_Nombre FILL-IN_NroDocumento FILL-IN_TelefonoCelular FILL-IN_TelefonoFijo.
  FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccpedi THEN DO:
      MESSAGE 'Pedido mostrador bloqueado por otro usuario' SKIP
          'Vuelva a intentarlo'
          VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  ASSIGN
      Faccpedi.nomcli   = FILL-IN_DscNombre
      Faccpedi.dircli   = FILL-IN_DscDireccion
      Faccpedi.Atencion = FILL-IN_NroDocumento.
  /* Grabamos cliente */
  FIND FIRST BaseArte WHERE BaseArte.CodCia = Faccpedi.codcia
      AND BaseArte.CodDiv = Faccpedi.coddiv
      AND BaseArte.NroDocumento = FILL-IN_NroDocumento
      EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
  IF NOT AVAILABLE Faccpedi AND LOCKED(BaseArte)
      THEN DO:
      MESSAGE 'Tabla BaseArte bloqueada por otro usuario' SKIP
          'Vuelva a intentarlo'
          VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF AVAILABLE BaseArte THEN DO:
      MESSAGE 'El cliente YA está registrado en el sistema' SKIP
          'Se va a continuar con estos datos'
          VIEW-AS ALERT-BOX WARNING.
      /*RETURN NO-APPLY.*/
  END.
  IF NOT AVAILABLE BaseArte THEN DO:
      CREATE BaseArte.
      ASSIGN
          BaseArte.CodCia = Faccpedi.codcia
          BaseArte.CodDiv = Faccpedi.coddiv
          BaseArte.NroDocumento = FILL-IN_NroDocumento
          BaseArte.FechaHora = DATETIME(TODAY,MTIME)
          BaseArte.SwPrimeraCompra = TRUE.
  END.
  ASSIGN
      BaseArte.ApeMat = FILL-IN_ApeMat
      BaseArte.ApePat = FILL-IN_ApePat
      BaseArte.DscDireccion = FILL-IN_DscDireccion
      BaseArte.DscDistrito = FILL-IN_DscDistrito
      BaseArte.DscNombre = FILL-IN_DscNombre
      BaseArte.DscProfesion = FILL-IN_DscProfesion
      BaseArte.Nombre = FILL-IN_Nombre
      BaseArte.TelefonoCelular = FILL-IN_TelefonoCelular
      BaseArte.TelefonoFijo = FILL-IN_TelefonoFijo
      NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
      MESSAGE 'DNI duplicado' VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN NO-APPLY.
  END.
  ASSIGN
      pOk = FILL-IN_NroDocumento.
  /* Aplicamos descuento al comprobante y volvemos a calcular */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ApeMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ApeMat D-Dialog
ON ANY-PRINTABLE OF FILL-IN_ApeMat IN FRAME D-Dialog /* Ap. Materno */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  RUN Arma-Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ApeMat D-Dialog
ON LEAVE OF FILL-IN_ApeMat IN FRAME D-Dialog /* Ap. Materno */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  RUN Arma-Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ApePat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ApePat D-Dialog
ON ANY-PRINTABLE OF FILL-IN_ApePat IN FRAME D-Dialog /* Ap. Paterno */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    RUN Arma-Nombre.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ApePat D-Dialog
ON LEAVE OF FILL-IN_ApePat IN FRAME D-Dialog /* Ap. Paterno */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    RUN Arma-Nombre.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_DscDireccion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_DscDireccion D-Dialog
ON LEAVE OF FILL-IN_DscDireccion IN FRAME D-Dialog /* Dirección */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_DscDistrito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_DscDistrito D-Dialog
ON LEAVE OF FILL-IN_DscDistrito IN FRAME D-Dialog /* Distrito */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_DscProfesion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_DscProfesion D-Dialog
ON LEAVE OF FILL-IN_DscProfesion IN FRAME D-Dialog /* Profesion */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Nombre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Nombre D-Dialog
ON ANY-PRINTABLE OF FILL-IN_Nombre IN FRAME D-Dialog /* Nombres */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    RUN Arma-Nombre.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Nombre D-Dialog
ON LEAVE OF FILL-IN_Nombre IN FRAME D-Dialog /* Nombres */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    RUN Arma-Nombre.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_NroDocumento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_NroDocumento D-Dialog
ON LEAVE OF FILL-IN_NroDocumento IN FRAME D-Dialog /* Nro Doc Identidad */
DO:
  FIND FIRST BaseArte WHERE BaseArte.CodCia = Faccpedi.codcia
      AND BaseArte.CodDiv = Faccpedi.coddiv
      AND BaseArte.NroDocumento = FILL-IN_NroDocumento:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE BaseArte THEN
      ASSIGN
      FILL-IN_ApeMat:SCREEN-VALUE = BaseArte.ApeMat
      FILL-IN_ApePat:SCREEN-VALUE = BaseArte.ApePat
      FILL-IN_DscDireccion:SCREEN-VALUE = BaseArte.DscDireccion
      FILL-IN_DscDistrito:SCREEN-VALUE = BaseArte.DscDistrito
      FILL-IN_DscNombre:SCREEN-VALUE = BaseArte.DscNombre
      FILL-IN_DscProfesion:SCREEN-VALUE = BaseArte.DscProfesion
      FILL-IN_Nombre:SCREEN-VALUE = BaseArte.Nombre
      FILL-IN_TelefonoCelular:SCREEN-VALUE = BaseArte.TelefonoCelular
      FILL-IN_TelefonoFijo:SCREEN-VALUE = BaseArte.TelefonoFijo.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Arma-Nombre D-Dialog 
PROCEDURE Arma-Nombre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    FILL-IN_DscNombre:SCREEN-VALUE =
        CAPS(TRIM(FILL-IN_ApePat:SCREEN-VALUE)) + ' ' +
        CAPS(TRIM(FILL-IN_ApeMat:SCREEN-VALUE)) + ', ' +
        CAPS(TRIM(FILL-IN_Nombre:SCREEN-VALUE)).

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
  DISPLAY FILL-IN_NroDocumento FILL-IN_ApePat FILL-IN_ApeMat FILL-IN_Nombre 
          FILL-IN_DscNombre FILL-IN_DscDireccion FILL-IN_DscDistrito 
          FILL-IN_TelefonoFijo FILL-IN_TelefonoCelular FILL-IN_DscProfesion 
      WITH FRAME D-Dialog.
  ENABLE FILL-IN_NroDocumento FILL-IN_ApePat FILL-IN_ApeMat FILL-IN_Nombre 
         FILL-IN_DscDireccion FILL-IN_DscDistrito FILL-IN_TelefonoFijo 
         FILL-IN_TelefonoCelular FILL-IN_DscProfesion Btn_OK Btn_Cancel 
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
  FILL-IN_NroDocumento = Faccpedi.Atencion.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "BaseArte"}

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

