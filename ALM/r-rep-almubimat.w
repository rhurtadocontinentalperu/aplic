&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-UBIMAT FOR almubimat.



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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

DEF TEMP-TABLE Reporte
    FIELD Tipo   AS CHAR FORMAT 'x(15)' LABEL 'Tipo'
    FIELD CodAlm AS CHAR FORMAT 'x(6)' LABEL 'Almacén'
    FIELD DesAlm AS CHAR FORMAT 'x(40)' LABEL 'Descripción'
    FIELD CodUbi AS CHAR FORMAT 'x(8)' LABEL 'Ubicación'
    FIELD DesUbi AS CHAR FORMAT 'x(40)' LABEL 'Descripción'
    FIELD CodZona AS CHAR FORMAT 'x(8)' LABEL 'Zona'
    FIELD DesZona AS CHAR FORMAT 'x(30)' LABEL 'Descripción'
    FIELD CodMat AS CHAR FORMAT 'x(10)' LABEL 'Artículo'
    FIELD DesMat AS CHAR FORMAT 'x(80)' LABEL 'Descripción'
    FIELD DesMar AS CHAR FORMAT 'x(30)' LABEL 'Marca'
    FIELD CodUni AS CHAR FORMAT 'x(8)' LABEL 'Unidad'
    FIELD Libre_d03 AS CHAR FORMAT 'x(2)' LABEL 'Pasaje'
    FIELD Libre_d04 AS CHAR FORMAT 'x(2)' LABEL 'Piso'
    .

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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX_CodAlm FILL-IN_CodMat ~
COMBO-BOX_CodZona COMBO-BOX_CodUbi FILL-IN_Pasaje FILL-IN_Piso BUTTON-2 ~
BtnDone 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_CodAlm FILL-IN_CodMat ~
FILL-IN_DesMat COMBO-BOX_CodZona COMBO-BOX_CodUbi FILL-IN_Pasaje ~
FILL-IN_Piso 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 8 BY 1.88
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/printer.ico":U
     LABEL "Button 2" 
     SIZE 8 BY 1.88.

DEFINE VARIABLE COMBO-BOX_CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "uno","uno"
     DROP-DOWN-LIST
     SIZE 66 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_CodUbi AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Ubicación" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_CodZona AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Zona" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Artículo" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Pasaje AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Pasaje" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Piso AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Piso" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX_CodAlm AT ROW 1.27 COL 9 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_CodMat AT ROW 2.08 COL 9 COLON-ALIGNED WIDGET-ID 4
     FILL-IN_DesMat AT ROW 2.08 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     COMBO-BOX_CodZona AT ROW 2.88 COL 9 COLON-ALIGNED WIDGET-ID 20
     COMBO-BOX_CodUbi AT ROW 3.69 COL 9 COLON-ALIGNED WIDGET-ID 8
     FILL-IN_Pasaje AT ROW 4.5 COL 9 COLON-ALIGNED WIDGET-ID 10
     FILL-IN_Piso AT ROW 5.31 COL 9 COLON-ALIGNED WIDGET-ID 12
     BUTTON-2 AT ROW 5.58 COL 53 WIDGET-ID 16
     BtnDone AT ROW 5.58 COL 63 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 7.27
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-UBIMAT B "?" ? INTEGRAL almubimat
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "REPORTE DE ARTICULOS ZONIFICADOS"
         HEIGHT             = 7.27
         WIDTH              = 80
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
/* SETTINGS FOR FILL-IN FILL-IN_DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE ARTICULOS ZONIFICADOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE ARTICULOS ZONIFICADOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
    ASSIGN COMBO-BOX_CodAlm COMBO-BOX_CodUbi FILL-IN_CodMat FILL-IN_Pasaje FILL-IN_Piso.

    /* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.

    RUN lib/tt-file-to-text-01 (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    DEFINE VAR hProc AS HANDLE NO-UNDO.

    RUN alm/almacen-library PERSISTENT SET hProc.

    SESSION:SET-WAIT-STATE('GENERAL').
    EMPTY TEMP-TABLE Reporte.
    FOR EACH Almubimat NO-LOCK WHERE almubimat.CodCia = s-CodCia
        AND almubimat.CodAlm = COMBO-BOX_CodAlm
        AND ( TRUE <> (FILL-IN_CodMat > '') OR almubimat.CodMat = FILL-IN_CodMat )
        AND ( COMBO-BOX_CodZona = 'Todas' OR almubimat.CodZona = COMBO-BOX_CodZona )
        AND ( COMBO-BOX_CodUbi  = 'Todas' OR almubimat.CodUbi  = COMBO-BOX_CodUbi  ),
        FIRST Almacen OF Almubimat NO-LOCK,
        FIRST Almmmatg OF Almubimat NO-LOCK,
        FIRST Almtubic OF Almubimat NO-LOCK,
        FIRST Almtzona OF Almubimat NO-LOCK :
        IF FILL-IN_Pasaje > 0 AND almtubic.Libre_d03 <> STRING(FILL-IN_Pasaje,'99') 
            THEN NEXT.
        IF FILL-IN_Piso > 0 AND almtubic.Libre_d04 <> STRING(FILL-IN_Pasaje,'99') 
            THEN NEXT.

        /* Buscamos si tiene multiubicacion */
        FIND FIRST B-UBIMAT WHERE B-UBIMAT.CodCia = Almubimat.codcia AND
            B-UBIMAT.CodAlm = Almubimat.codalm AND
            B-UBIMAT.CodMat = Almubimat.codmat AND
            B-UBIMAT.CodUbi <> Almubimat.codubi
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-UBIMAT THEN NEXT.

        CREATE Reporte.
        BUFFER-COPY Almubimat TO Reporte
            ASSIGN
            Reporte.DesAlm = Almacen.Descripcion
            Reporte.DesUbi = Almtubic.desubi
            Reporte.DesZona = Almtzona.deszona
            Reporte.DesMat = Almmmatg.desmat
            Reporte.DesMar = Almmmatg.desmar
            Reporte.CodUni = Almmmatg.undbas
            Reporte.Libre_d03 = Almtubic.Libre_d03
            Reporte.Libre_d04 = Almtubic.Libre_d04
            .
        RUN ALM_Tipo-MultiUbic IN hProc (almubimat.CodAlm,
                                         almubimat.CodMat,
                                         almubimat.CodUbi).
        Reporte.Tipo = RETURN-VALUE.
    END.
    DELETE PROCEDURE hProc.
    SESSION:SET-WAIT-STATE('').
    FIND FIRST Reporte NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Reporte THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    cArchivo = LC(pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
    RUN lib/tt-filev2 (TEMP-TABLE Reporte:HANDLE, cArchivo, pOptions).
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_CodAlm W-Win
ON VALUE-CHANGED OF COMBO-BOX_CodAlm IN FRAME F-Main /* Almacén */
DO:
    SESSION:SET-WAIT-STATE('GENERAL').
    COMBO-BOX_CodZona:DELETE(COMBO-BOX_CodZona:LIST-ITEMS).
    COMBO-BOX_CodZona:ADD-LAST('Todas').
    FOR EACH AlmtZona NO-LOCK WHERE AlmtZona.CodCia = s-codcia 
        AND AlmtZona.CodAlm = COMBO-BOX_CodAlm:SCREEN-VALUE:
        COMBO-BOX_CodZona:ADD-LAST(AlmtZona.CodZona).
    END.
    COMBO-BOX_CodZona:SCREEN-VALUE = 'Todas'.

    COMBO-BOX_CodUbi:DELETE(COMBO-BOX_CodUbi:LIST-ITEMS).
    COMBO-BOX_CodUbi:ADD-LAST('Todas').
/*     FOR EACH Almtubic NO-LOCK WHERE Almtubic.codcia = s-codcia */
/*         AND Almtubic.codalm = COMBO-BOX_CodAlm:SCREEN-VALUE:   */
/*         COMBO-BOX_CodUbi:ADD-LAST(almtubic.CodUbi).            */
/*     END.                                                       */
    COMBO-BOX_CodUbi:SCREEN-VALUE = 'Todas'.
    SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_CodZona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_CodZona W-Win
ON VALUE-CHANGED OF COMBO-BOX_CodZona IN FRAME F-Main /* Zona */
DO:
    COMBO-BOX_CodUbi:DELETE(COMBO-BOX_CodUbi:LIST-ITEMS).
    COMBO-BOX_CodUbi:ADD-LAST('Todas').
    FOR EACH Almtubic NO-LOCK WHERE Almtubic.codcia = s-codcia
        AND Almtubic.codalm = COMBO-BOX_CodAlm:SCREEN-VALUE
        AND Almtubic.codzona = COMBO-BOX_CodZona:SCREEN-VALUE:
        COMBO-BOX_CodUbi:ADD-LAST(almtubic.CodUbi).
    END.
    COMBO-BOX_CodUbi:SCREEN-VALUE = 'Todas'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodMat W-Win
ON LEAVE OF FILL-IN_CodMat IN FRAME F-Main /* Artículo */
DO:
    FILL-IN_DesMat:SCREEN-VALUE = ''.
    IF SELF:SCREEN-VALUE = "" THEN RETURN.

    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
    IF pCodMat = '' THEN DO:
        ASSIGN SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    SELF:SCREEN-VALUE = pCodMat.
    FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK.
    FILL-IN_DesMat:SCREEN-VALUE = Almmmatg.desmat.
  
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
  DISPLAY COMBO-BOX_CodAlm FILL-IN_CodMat FILL-IN_DesMat COMBO-BOX_CodZona 
          COMBO-BOX_CodUbi FILL-IN_Pasaje FILL-IN_Piso 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX_CodAlm FILL-IN_CodMat COMBO-BOX_CodZona COMBO-BOX_CodUbi 
         FILL-IN_Pasaje FILL-IN_Piso BUTTON-2 BtnDone 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  SESSION:SET-WAIT-STATE('GENERAL').
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX_CodAlm:DELIMITER = '|'.
      COMBO-BOX_CodAlm:DELETE(1).
      FOR EACH almacen NO-LOCK WHERE almacen.codcia = s-codcia
          AND almacen.coddiv = s-coddiv
          AND almacen.campo-c[9] <> "I":
          COMBO-BOX_CodAlm:ADD-LAST(Almacen.CodAlm + ' - '  + Almacen.Descripcion,Almacen.CodAlm ).
      END.
      COMBO-BOX_CodAlm = s-CodAlm.
      COMBO-BOX_CodZona:DELIMITER = '|'.
      FOR EACH AlmtZona NO-LOCK WHERE AlmtZona.CodCia = s-codcia 
          AND AlmtZona.CodAlm = s-CodAlm:
          COMBO-BOX_CodZona:ADD-LAST(AlmtZona.CodZona).
      END.
      COMBO-BOX_CodUbi:DELIMITER = '|'.
/*       FOR EACH Almtubic NO-LOCK WHERE Almtubic.codcia = s-codcia */
/*           AND Almtubic.codalm = s-CodAlm:                        */
/*           COMBO-BOX_CodUbi:ADD-LAST(almtubic.CodUbi).            */
/*       END.                                                       */
  END.
  SESSION:SET-WAIT-STATE('').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

