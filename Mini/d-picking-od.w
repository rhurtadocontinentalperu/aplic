&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-DPEDI NO-UNDO LIKE FacDPedi
       FIELD CodUbi LIKE Almmmate.CodUbi
       FIELD CodZona LIKE Almtubic.CodZona
       INDEX Llave00 AS PRIMARY NroItm.



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
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR s-coddoc AS CHAR INIT 'O/D' NO-UNDO.

FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = s-codalm 
    NO-LOCK NO-ERROR.
DEF VAR x-HorIni LIKE faccpedi.horsac NO-UNDO.
DEF VAR x-FchIni LIKE faccpedi.fecsac NO-UNDO.

DEF VAR s-NroItm AS INT NO-UNDO.    /* Control del Item en Pantalla */

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
&Scoped-Define ENABLED-OBJECTS x-NroDoc BUTTON-16 BUTTON-18 BUTTON-17 ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS x-NroDoc EDITOR-DesMat 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Cancel" 
     SIZE 9 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-16 
     IMAGE-UP FILE "img/pvback.bmp":U
     IMAGE-DOWN FILE "img/pvbackd.bmp":U
     LABEL "Button 16" 
     SIZE 6 BY 1.12.

DEFINE BUTTON BUTTON-17 
     IMAGE-UP FILE "img\pvforw.bmp":U
     IMAGE-DOWN FILE "img/pvforwd.bmp":U
     LABEL "Button 17" 
     SIZE 5 BY 1.12.

DEFINE BUTTON BUTTON-18 
     IMAGE-UP FILE "img/pvstop.bmp":U
     IMAGE-DOWN FILE "img/pvstopd.bmp":U
     LABEL "Button 18" 
     SIZE 5 BY .96.

DEFINE VARIABLE EDITOR-DesMat AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 31 BY 6.15
     BGCOLOR 14 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE x-NroDoc AS CHARACTER FORMAT "X(13)":U 
     LABEL "O/D" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     x-NroDoc AT ROW 1.19 COL 5 COLON-ALIGNED WIDGET-ID 2 AUTO-RETURN 
     EDITOR-DesMat AT ROW 2.35 COL 2 NO-LABEL WIDGET-ID 4
     BUTTON-16 AT ROW 8.69 COL 2 WIDGET-ID 10
     BUTTON-18 AT ROW 8.69 COL 8 WIDGET-ID 14
     BUTTON-17 AT ROW 8.69 COL 13 WIDGET-ID 12
     Btn_Cancel AT ROW 8.69 COL 25
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "PICKING DE O/D"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-DPEDI T "?" NO-UNDO INTEGRAL FacDPedi
      ADDITIONAL-FIELDS:
          FIELD CodUbi LIKE Almmmate.CodUbi
          FIELD CodZona LIKE Almtubic.CodZona
          INDEX Llave00 AS PRIMARY NroItm
      END-FIELDS.
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
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR EDITOR EDITOR-DesMat IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* PICKING DE O/D */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-16
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-16 D-Dialog
ON CHOOSE OF BUTTON-16 IN FRAME D-Dialog /* Button 16 */
DO:
    FIND PREV T-DPEDI NO-ERROR.
    IF ERROR-STATUS:ERROR THEN FIND T-DPEDI WHERE T-DPEDI.NroItm = 1.
    RUN Pinta-Informacion.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-17
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-17 D-Dialog
ON CHOOSE OF BUTTON-17 IN FRAME D-Dialog /* Button 17 */
DO:
  FIND NEXT T-DPEDI NO-ERROR.
  IF ERROR-STATUS:ERROR THEN FIND PREV T-DPEDI NO-ERROR.
  RUN Pinta-Informacion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-18
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-18 D-Dialog
ON CHOOSE OF BUTTON-18 IN FRAME D-Dialog /* Button 18 */
DO:
  x-NroDoc:SENSITIVE = YES.
  x-NroDoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  EDITOR-Desmat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  APPLY "ENTRY":U TO x-NroDoc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NroDoc D-Dialog
ON LEAVE OF x-NroDoc IN FRAME D-Dialog /* O/D */
OR ENTER OF x-NroDoc
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND Faccpedi WHERE Faccpedi.codcia = s-codcia 
        AND Faccpedi.coddoc = s-coddoc
        AND Faccpedi.nroped = x-nrodoc:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi THEN DO:
        MESSAGE 'Orden de Despacho NO registrada' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    /*RD01- Verifica si la orden ya ha sido chequeado*/
    IF NOT (Faccpedi.flgest = 'P' AND Faccpedi.flgsit <> 'C') THEN DO:
        MESSAGE 'Orden de Despacho NO se puede chequear' VIEW-AS ALERT-BOX ERROR.
        DISPLAY x-NroDoc WITH FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
    IF Faccpedi.DivDes <> s-CodDiv THEN DO:
        MESSAGE "NO tiene almacenes de despacho pertenecientes a esta división"
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    IF x-NroDoc <> SELF:SCREEN-VALUE THEN DO:
        /* Arranca el ciclo */
        ASSIGN
            x-FchIni = TODAY
            x-HorIni = STRING(TIME, 'HH:MM:SS').
        ASSIGN {&SELF-NAME}.
        /*RUN Calcula-NroItems.*/
        RUN Carga-con-kits.
/*         RUN Recarga-Items-Backup.                        */
/*         RUN dispatch IN THIS-PROCEDURE ('open-query':U). */
/*         ASSIGN                                           */
/*             x-fchdoc = Faccpedi.fchped                   */
/*             x-codcli = Faccpedi.codcli                   */
/*             x-nomcli = Faccpedi.nomcli.                  */
/*         DISPLAY                                          */
/*             x-fchdoc                                     */
/*             x-codcli                                     */
/*             x-nomcli                                     */
/*             WITH FRAME {&FRAME-NAME}.                    */
/*         x-CodDoc:SENSITIVE = NO.                         */
        x-NroDoc:SENSITIVE = NO.
        s-NroItm = 0.   /* Inicializamos puntero */
        FOR EACH Facdpedi OF Faccpedi NO-LOCK:
            s-NroItm = s-NroItm + 1.
        END.
        FIND FIRST T-DPEDI NO-ERROR.
        RUN Pinta-Informacion.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */
/*ASSIGN FRAME {&FRAME-NAME}:TITLE = Almacen.codalm + ' ' + Almacen.descrip.*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-con-kits D-Dialog 
PROCEDURE Carga-con-kits :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-DPEDI.
/* RHC 13.07.2012 CARGAMOS TODO EN UNIDADES DE STOCK 
    NO LE AFECTA A LAS VENTAS AL CREDITO 
*/
/* 1ro Sin Kits */
FOR EACH Facdpedi NO-LOCK WHERE Facdpedi.codcia = s-codcia
    AND Facdpedi.coddoc = s-coddoc
    AND Facdpedi.nroped = x-nrodoc,
    FIRST Almmmatg OF Facdpedi NO-LOCK:
    FIND FIRST Almckits OF Facdpedi NO-LOCK NO-ERROR.
    IF AVAILABLE Almckits THEN NEXT.
    FIND T-DPEDI WHERE T-DPEDI.codmat = Facdpedi.codmat NO-ERROR.
    IF NOT AVAILABLE T-DPEDI THEN DO:
        CREATE T-DPEDI.
        ASSIGN
            T-DPEDI.CodCia = Facdpedi.codcia
            T-DPEDI.CodMat = Facdpedi.codmat
            T-DPEDI.AlmDes = Facdpedi.almdes
            T-DPEDI.UndVta = Almmmatg.UndStk
            T-DPEDI.CanPed = Facdpedi.canped * Facdpedi.factor.
        
    END.
    ELSE T-DPEDI.canped = T-DPEDI.canped + Facdpedi.canped * Facdpedi.factor.
END.
/* 2do Con Kits */
FOR EACH Facdpedi NO-LOCK WHERE Facdpedi.codcia = s-codcia
    AND Facdpedi.coddoc = s-coddoc
    AND Facdpedi.nroped = x-nrodoc,
    FIRST Almckits OF Facdpedi NO-LOCK,
    EACH Almdkits OF Almckits NO-LOCK,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = AlmDKits.codmat2:
    FIND T-DPEDI WHERE T-DPEDI.codmat = Almmmatg.codmat NO-ERROR.
    IF NOT AVAILABLE T-DPEDI THEN DO:
        CREATE T-DPEDI.
        ASSIGN
            T-DPEDI.CodCia = Facdpedi.codcia
            T-DPEDI.CodMat = Almmmatg.codmat
            T-DPEDI.AlmDes = Facdpedi.almdes
            T-DPEDI.UndVta = Almmmatg.UndStk
            T-DPEDI.CanPed = Facdpedi.canped * Facdpedi.factor * AlmDKits.Cantidad.
    END.
    ELSE T-DPEDI.canped = T-DPEDI.canped + Facdpedi.canped * Facdpedi.factor * AlmDKits.Cantidad.
END.
/* 3ro Ordenamos por Zona, Ubicación y Artículo */
FOR EACH T-DPEDI, FIRST Almmmatg OF T-DPEDI NO-LOCK:
    ASSIGN
        T-DPEDI.CodZona = "G-0"
        T-DPEDI.CodUbi   = "G-0".
    FIND Almmmate WHERE Almmmate.codcia = T-DPEDI.codcia
        AND Almmmate.codalm = T-DPEDI.almdes
        AND Almmmate.codmat = T-DPEDI.codmat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN NEXT.
    T-DPEDI.CodUbi = Almmmate.codubi.
    FIND FIRST almtubic OF Almmmate NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtubic THEN NEXT.
    T-DPEDI.CodZona = Almtubic.codzona.
END.
s-NroItm = 1.
FOR EACH T-DPEDI BREAK BY T-DPEDI.CodUbi BY T-DPEDI.CodZona BY T-DPEDI.CodMat:
    T-DPEDI.NroItm = s-NroItm.
    s-NroItm = s-NroItm + 1.
END.

/* FOR EACH FacDPedi OF FacCPedi NO-LOCK,                                         */
/*       FIRST Almmmatg OF FacDPedi NO-LOCK,                                      */
/*       FIRST Almmmate WHERE integral.Almmmate.CodCia = integral.FacDPedi.CodCia */
/*   AND integral.Almmmate.CodAlm = integral.FacDPedi.AlmDes                      */
/*   AND integral.Almmmate.codmat = integral.FacDPedi.codmat OUTER-JOIN NO-LOCK,  */
/*       FIRST almtubic OF Almmmate OUTER-JOIN NO-LOCK                            */
/*     BY INTEGRAL.Almmmate.CodUbi                                                */
/*      BY INTEGRAL.almtubic.CodZona                                              */
/*       BY INTEGRAL.FacDPedi.codmat:                                             */

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
  DISPLAY x-NroDoc EDITOR-DesMat 
      WITH FRAME D-Dialog.
  ENABLE x-NroDoc BUTTON-16 BUTTON-18 BUTTON-17 Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pinta-Informacion D-Dialog 
PROCEDURE Pinta-Informacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*FIND T-DPEDI WHERE T-DPEDI.NroItm = s-nroitm NO-ERROR.*/
IF AVAILABLE T-DPEDI THEN DO:
    FIND FIRST Almmmatg OF T-DPEDI NO-LOCK.
    FIND Almacen WHERE Almacen.codcia = T-DPEDI.codcia
        AND Almacen.codalm = T-DPEDI.almdes NO-LOCK NO-ERROR.
    ASSIGN
        EDITOR-Desmat:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
        "     ITEM: " + TRIM(STRING(T-DPEDI.NroItm, '>>9')) +  '/' + TRIM(STRING(s-NroItm, '>>9')) + CHR(10) + CHR(10) + 
        "  ALMACEN: " + T-DPEDI.almdes + ' ' + (IF AVAILABLE Almacen THEN Almacen.Descripcion ELSE '') + CHR(10) + CHR(10) +
        " CANTIDAD: " + STRING(T-DPEDI.CanPed, '>>>,>>9.99') + ' ' + T-DPEDI.UndVta + CHR(10) + CHR(10) +
        "UBICACION: " + T-DPEDI.codubi + ' ' + "ZONA: " + T-DPEDI.codzona + CHR(10) + CHR(10) +
        " ARTICULO: " + T-DPEDI.codmat + CHR(10) + Almmmatg.desmat.
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

