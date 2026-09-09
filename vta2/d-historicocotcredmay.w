&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE TEMP-TABLE COTIZACIONES NO-UNDO LIKE FacCPedi.
DEFINE TEMP-TABLE Detalle LIKE FacDPedi
       FIELD Promedio AS DEC
       FIELD Cotizado AS DEC EXTENT 10
       .
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedi.



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

DEF INPUT PARAMETER pCodCli AS CHAR.   /* INIT '20113367955'.*/
DEF INPUT PARAMETER pCodDoc AS CHAR.    /* INIT 'COT'.*/
DEF OUTPUT PARAMETER pError AS CHAR.

DEF SHARED VAR s-codcia AS INT.

pError = "ADM-ERROR".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Detalle Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 /*Detalle.nroitm*/ Detalle.codmat Almmmatg.DesMat Detalle.UndVta Detalle.CanPed Detalle.Promedio Detalle.Cotizado[1] Detalle.Cotizado[2] Detalle.Cotizado[3] Detalle.Cotizado[4] Detalle.Cotizado[5]   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 Detalle.CanPed   
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-2 Detalle
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-2 Detalle
&Scoped-define SELF-NAME BROWSE-2
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH Detalle NO-LOCK, ~
             EACH Almmmatg OF Detalle NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY {&SELF-NAME} FOR EACH Detalle NO-LOCK, ~
             EACH Almmmatg OF Detalle NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 Detalle Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 Detalle
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 Almmmatg


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 Btn_OK Btn_Cancel 

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
     SIZE 15 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.54
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      Detalle, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 D-Dialog _FREEFORM
  QUERY BROWSE-2 NO-LOCK DISPLAY
      /*Detalle.nroitm*/
      Detalle.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U WIDTH 8
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 40
      Detalle.UndVta COLUMN-LABEL "Unidad" FORMAT "x(6)":U WIDTH 6.43
      Detalle.CanPed FORMAT "ZZZ,ZZ9.99":U WIDTH 11 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      Detalle.Promedio COLUMN-LABEL "Promedio" FORMAT ">>>,>>9.99":U WIDTH 11
      Detalle.Cotizado[1] COLUMN-LABEL "Cotizado!1" FORMAT ">>>,>>9.99":U WIDTH 11
      Detalle.Cotizado[2] COLUMN-LABEL "Cotizado!2" FORMAT ">>>,>>9.99":U WIDTH 11
      Detalle.Cotizado[3] COLUMN-LABEL "Cotizado!3" FORMAT ">>>,>>9.99":U WIDTH 11
      Detalle.Cotizado[4] COLUMN-LABEL "Cotizado!4" FORMAT ">>>,>>9.99":U WIDTH 11
      Detalle.Cotizado[5] COLUMN-LABEL "Cotizado!5" FORMAT ">>>,>>9.99":U WIDTH 11

  ENABLE
      Detalle.CanPed
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 138 BY 19.81
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-2 AT ROW 1.19 COL 2 WIDGET-ID 200
     Btn_OK AT ROW 21.19 COL 2
     Btn_Cancel AT ROW 21.19 COL 18
     SPACE(108.13) SKIP(0.26)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "COTIZACIONES RECURRENTES"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: COTIZACIONES T "?" NO-UNDO INTEGRAL FacCPedi
      TABLE: Detalle T "?" ? INTEGRAL FacDPedi
      ADDITIONAL-FIELDS:
          FIELD Promedio AS DEC
          FIELD Cotizado AS DEC EXTENT 10
          
      END-FIELDS.
      TABLE: ITEM T "SHARED" ? INTEGRAL FacDPedi
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
/* BROWSE-TAB BROWSE-2 1 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH Detalle NO-LOCK,
      EACH Almmmatg OF Detalle NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* COTIZACIONES RECURRENTES */
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
    DEF VAR nItem AS INT INIT 1 NO-UNDO.
    /* Renumeramos */
    FOR EACH ITEM BY ITEM.NroItm:
        nItem = ITEM.NroItm + 1.
    END.
    FOR EACH Detalle WHERE Detalle.CanPed > 0 AND Detalle.NroItm = 0:
        Detalle.NroItm = nItem.
        nItem = nItem + 1.
    END.
    /* Cargamos la tabla ITEM */
    FOR EACH Detalle WHERE Detalle.CanPed > 0 BY Detalle.NroItm:
        FIND ITEM WHERE ITEM.codmat = Detalle.codmat NO-ERROR.
        IF NOT AVAILABLE ITEM THEN CREATE ITEM.
        ASSIGN
            ITEM.codcia = s-codcia
            ITEM.nroitm = Detalle.nroitm
            ITEM.codmat = Detalle.codmat
            ITEM.canped = Detalle.canped.
    END.
    pError = "OK".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Detalle.
EMPTY TEMP-TABLE Cotizaciones.
DEF VAR k AS INT NO-UNDO.
DEF VAR j AS INT NO-UNDO.

/* Buscamos las cotizaciones del cliente */
FOR EACH Ccbcdocu USE-INDEX Llave06 WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.codcli = pCodCli
    AND Ccbcdocu.flgest <> 'A' 
    AND LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') > 0 NO-LOCK,
    FIRST Faccpedi WHERE Faccpedi.codcia = Ccbcdocu.codcia
    AND Faccpedi.coddoc = Ccbcdocu.codped
    AND Faccpedi.nroped = Ccbcdocu.nroped NO-LOCK,
    FIRST B-CPEDI WHERE B-CPEDI.codcia = Faccpedi.codcia 
    AND B-CPEDI.coddoc = Faccpedi.codref
    AND B-CPEDI.nroped = Faccpedi.nroref NO-LOCK:
    FIND Cotizaciones OF B-CPEDI NO-ERROR.
    IF AVAILABLE Cotizaciones THEN NEXT.
    CREATE Cotizaciones.
    BUFFER-COPY B-CPEDI TO Cotizaciones.
END.
/* No mas de 5 */
k = 0.
FOR EACH Cotizaciones BY Cotizaciones.FchPed DESC BY Cotizaciones.NroPed DESC:
    k = k + 1.
    IF k > 5 THEN DELETE Cotizaciones.
END.
k = 0.
FOR EACH Cotizaciones BY Cotizaciones.FchPed DESC BY Cotizaciones.NroPed DESC:
    k = k + 1.
    CASE k:
        WHEN 1 THEN Detalle.Cotizado[1]:LABEL IN BROWSE {&browse-name} = 
            STRING(Cotizaciones.FchPed) + '!' + Cotizaciones.NroPed.
        WHEN 2 THEN Detalle.Cotizado[2]:LABEL IN BROWSE {&browse-name} = 
            STRING(Cotizaciones.FchPed) + '!' + Cotizaciones.NroPed.
        WHEN 3 THEN Detalle.Cotizado[3]:LABEL IN BROWSE {&browse-name} = 
            STRING(Cotizaciones.FchPed) + '!' + Cotizaciones.NroPed.
        WHEN 4 THEN Detalle.Cotizado[4]:LABEL IN BROWSE {&browse-name} = 
            STRING(Cotizaciones.FchPed) + '!' + Cotizaciones.NroPed.
        WHEN 5 THEN Detalle.Cotizado[5]:LABEL IN BROWSE {&browse-name} = 
            STRING(Cotizaciones.FchPed) + '!' + Cotizaciones.NroPed.
    END CASE.
    
END.

k = 0.
FOR EACH Cotizaciones, EACH Facdpedi OF Cotizaciones NO-LOCK
    BREAK BY Cotizaciones.FchPed DESC BY Cotizaciones.NroPed DESC:
    IF FIRST-OF(Cotizaciones.FchPed) OR FIRST-OF(Cotizaciones.NroPed) THEN k = k + 1.
    FIND Detalle WHERE Detalle.codmat = Facdpedi.codmat NO-ERROR.
    IF NOT AVAILABLE Detalle THEN CREATE Detalle.
    BUFFER-COPY Facdpedi 
        TO Detalle
        ASSIGN Detalle.Cotizado[k] = Facdpedi.CanPed * Facdpedi.Factor.
END.

FOR EACH Detalle:
    ASSIGN
        Detalle.CanPed = 0
        Detalle.Promedio = 0
        Detalle.NroItm = 0.
    j = 0.
    DO k = 1 TO 5:
        Detalle.Promedio = Detalle.Promedio + Detalle.Cotizado[k].
        IF Detalle.Cotizado[k] > 0 THEN j = j + 1.
    END.
    IF j > 0 THEN Detalle.Promedio = ROUND(Detalle.Promedio / j, 0).
    FIND ITEM WHERE ITEM.codmat = Detalle.codmat NO-ERROR.
    IF AVAILABLE ITEM THEN ASSIGN Detalle.CanPed = ITEM.CanPed Detalle.nroitm = ITEM.nroitm.
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
  ENABLE BROWSE-2 Btn_OK Btn_Cancel 
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
  SESSION:SET-WAIT-STATE('GENERAL').
   RUN Carga-Temporal.
   SESSION:SET-WAIT-STATE('GENERAL').

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
  {src/adm/template/snd-list.i "Detalle"}
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

