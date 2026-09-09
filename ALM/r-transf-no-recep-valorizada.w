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

DEFINE SHARED VAR S-CODCIA AS INTEGER.

DEFINE VAR x-Almacenes  AS CHAR NO-UNDO.
DEFINE VAR x-tipmov     AS CHAR NO-UNDO.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\AUXILIAR" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR NO-UNDO.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
    SKIP
    Fi-Mensaje FORMAT 'x(50)' NO-LABEL FONT 6
    SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
    BGCOLOR 15 FGCOLOR 0 
    TITLE "Procesando ..." FONT 7.

DEF TEMP-TABLE Detalle NO-UNDO
    FIELD Origen AS CHAR        FORMAT 'x(8)'           LABEL 'Origen'
    FIELD NomOrigen AS CHAR     FORMAT 'x(80)'          LABEL 'Descripcion Origen'
    FIELD NroDoc AS CHAR        FORMAT 'x(15)'          LABEL 'Documento'
    FIELD FchDoc AS DATE        FORMAT '99/99/9999'     LABEL 'Fecha'
    FIELD Destino AS CHAR       FORMAT 'x(8)'           LABEL 'Destino'
    FIELD NomDestino AS CHAR    FORMAT 'x(80)'          LABEL 'Descripcion Destino'
    FIELD Observ AS CHAR        FORMAT 'x(100)'         LABEL 'Observaciones'
    FIELD CodMat AS CHAR        FORMAT 'x(8)'           LABEL 'Artículo'
    FIELD DesMat AS CHAR        FORMAT 'x(100)'         LABEL 'Descripción Artículo'
    FIELD Unidad AS CHAR        FORMAT 'x(8)'           LABEL 'Unidad'
    FIELD DesMar AS CHAR        FORMAT 'x(60)'          LABEL 'Marca'
    FIELD CodFam AS CHAR        FORMAT 'x(8)'           LABEL 'Línea'
    FIELD DesFam AS CHAR        FORMAT 'x(60)'          LABEL 'Descripción Línea'
    FIELD Cantidad AS DECI      FORMAT '>>>,>>>,>>9.99' LABEL 'Cantidad'
    FIELD Orden AS CHAR         FORMAT 'x(15)'          LABEL 'Orden de Transferencia'
    FIELD Intermedio AS CHAR    FORMAT 'x(8)'           LABEL 'Almacén Intermedio'
    FIELD NomIntermedio AS CHAR FORMAT 'x(80)'          LABEL 'Nombre Almacén Intermedio'
    FIELD CtoProm AS DECI       FORMAT '>>>,>>>,>>9.99' LABEL 'Costo Promedio'
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
&Scoped-Define ENABLED-OBJECTS BUTTON-3 BUTTON-10 desdeF hastaF ~
BUTTON_Texto BtnDone 
&Scoped-Define DISPLAYED-OBJECTS EDITOR_Almacenes desdeF hastaF C-Tipmov ~
I-CodMov N-MOVI 

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
     SIZE 9 BY 2.15
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-10 
     IMAGE-UP FILE "img/search.ico":U
     LABEL "Button 3" 
     SIZE 7 BY 1.62.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/search.ico":U
     LABEL "Button 3" 
     SIZE 7 BY 1.62.

DEFINE BUTTON BUTTON_Texto 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "Button 5" 
     SIZE 9 BY 2.15 TOOLTIP "Exportar a Texto".

DEFINE VARIABLE C-Tipmov AS CHARACTER FORMAT "X(256)":U INITIAL "Salida" 
     LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 1
     LIST-ITEMS "Salida" 
     DROP-DOWN-LIST
     SIZE 9.43 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR_Almacenes AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 40 BY 4.31
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE desdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE hastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE I-CodMov AS CHARACTER FORMAT "X(2)":U INITIAL "03" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .81 NO-UNDO.

DEFINE VARIABLE N-MOVI AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.57 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     EDITOR_Almacenes AT ROW 1.27 COL 13 NO-LABEL WIDGET-ID 10
     BUTTON-3 AT ROW 1.27 COL 53 WIDGET-ID 4
     BUTTON-10 AT ROW 1.27 COL 53 WIDGET-ID 8
     desdeF AT ROW 5.85 COL 11 COLON-ALIGNED WIDGET-ID 28
     hastaF AT ROW 5.85 COL 29.72 COLON-ALIGNED WIDGET-ID 30
     C-Tipmov AT ROW 7.19 COL 11 COLON-ALIGNED WIDGET-ID 26
     I-CodMov AT ROW 7.19 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     N-MOVI AT ROW 7.19 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     BUTTON_Texto AT ROW 9.35 COL 4 WIDGET-ID 42
     BtnDone AT ROW 9.35 COL 14 WIDGET-ID 40
     "Almacenes:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.27 COL 3 WIDGET-ID 12
     "Almacenes:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.27 COL 3 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 11.88
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "TRANSFERENCIAS NO RECEPCIONADAS"
         HEIGHT             = 11.88
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
/* SETTINGS FOR COMBO-BOX C-Tipmov IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR EDITOR_Almacenes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN I-CodMov IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN N-MOVI IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* TRANSFERENCIAS NO RECEPCIONADAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* TRANSFERENCIAS NO RECEPCIONADAS */
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


&Scoped-define SELF-NAME BUTTON-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-10 W-Win
ON CHOOSE OF BUTTON-10 IN FRAME F-Main /* Button 3 */
DO:
  x-Almacenes = EDITOR_Almacenes:SCREEN-VALUE.
  RUN alm/d-almacen (INPUT-OUTPUT x-Almacenes).
  EDITOR_Almacenes:SCREEN-VALUE = x-Almacenes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  x-Almacenes = EDITOR_Almacenes:SCREEN-VALUE.
  RUN alm/d-almacen (INPUT-OUTPUT x-Almacenes).
  EDITOR_Almacenes:SCREEN-VALUE = x-Almacenes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Texto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Texto W-Win
ON CHOOSE OF BUTTON_Texto IN FRAME F-Main /* Button 5 */
DO:
    ASSIGN C-Tipmov desdeF EDITOR_Almacenes hastaF I-CodMov N-MOVI.

    IF TRUE <> (EDITOR_Almacenes > '') THEN NEXT.

    CASE C-tipmov:
       /*WHEN "Ingreso" THEN X-Tipmov = "I".*/
       WHEN "Salida"  THEN X-Tipmov = "S".
    END.

    /* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.

    RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    /* Cargamos la informacion al temporal */
    SESSION:SET-WAIT-STATE('GENERAL').

    RUN Carga-Temporal.

    /* Programas que generan el Excel */
    DISPLAY "GENERANDO TEXTO" @ fi-Mensaje WITH FRAME f-Proceso.

    cArchivo = LC(pArchivo).
    IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
    RUN lib/tt-filev2 (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    SESSION:SET-WAIT-STATE('').
    HIDE FRAME f-Proceso.
    MESSAGE 'Proceso Concluido' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-Tipmov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Tipmov W-Win
ON LEAVE OF C-Tipmov IN FRAME F-Main /* Tipo */
DO:
  /*FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
                      Almtmovm.tipmov = X-TIPMOV AND
                      Almtmovm.codmov = integer(I-CodMov:screen-value)  NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm THEN
  assign
    N-MOVI:screen-value = Almtmovm.Desmov.
  ELSE DO:
      MESSAGE "Movimiento No Existe ....." VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  
  IF Almtmovm.MovTrf THEN DO:
      F-AlmDes:SENSITIVE = YES.
     
  END.
  ELSE DO:
      F-AlmDes:SENSITIVE = NO.
      F-NomDes:SCREEN-VALUE = "".
      F-AlmDes:SCREEN-VALUE = "".
  END.  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Tipmov W-Win
ON VALUE-CHANGED OF C-Tipmov IN FRAME F-Main /* Tipo */
DO:
  ASSIGN C-TIPMOV.
  
  CASE C-tipmov:
     /*WHEN "Ingreso" THEN X-Tipmov = "I".*/
     WHEN "Salida"  THEN X-Tipmov = "S".
  END.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-CodMov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-CodMov W-Win
ON F8 OF I-CodMov IN FRAME F-Main
DO:
  /*ASSIGN  input-var-1 = X-tipmov
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?.

  RUN lkup\C-TMovm ("Movimientos de Ingreso").
  IF output-var-2 = ? THEN output-var-2 = "". 
  I-Codmov = output-var-2.
  DO WITH FRAME {&FRAME-NAME}:
     Display I-Codmov .
  END.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-CodMov W-Win
ON LEAVE OF I-CodMov IN FRAME F-Main
DO:
  
  /* RHC 27-03-04 se puede dejar en blanco I-CodMov */
  /*IF SELF:SCREEN-VALUE = ''
  THEN DO:
    N-MOVI:screen-value = "Todos".
   
  END.
  ELSE DO:
    FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA 
        AND Almtmovm.tipmov = X-TIPMOV 
        AND Almtmovm.codmov = integer(I-CodMov:screen-value)  
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtmovm 
    THEN N-MOVI:screen-value = Almtmovm.Desmov.
    ELSE DO:
        MESSAGE "Movimiento No Existe ....." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

  END.*/
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-CodMov W-Win
ON MOUSE-SELECT-DBLCLICK OF I-CodMov IN FRAME F-Main
DO:
  /*ASSIGN  input-var-1 = X-tipmov
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?.

  RUN lkup\C-TMovm ("Movimientos de " + C-tipmov).
  IF output-var-2 = ? THEN output-var-2 = "". 
  I-Codmov = output-var-2.
  DO WITH FRAME {&FRAME-NAME}:
     Display I-Codmov .
  END.*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Detalle.
DEF BUFFER bAlmacen FOR Almacen.

FOR EACH Almacen WHERE Almacen.codcia = s-codcia AND LOOKUP(TRIM(Almacen.codalm), EDITOR_Almacenes) > 0 NO-LOCK,
    EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = S-CODCIA AND  
        Almcmov.CodAlm = Almacen.codalm AND
        Almcmov.TipMov = X-TipMov AND  
        Almcmov.CodMov = INTEGER(I-CodMov) AND
        Almcmov.FchDoc >= DesdeF  AND  
        Almcmov.FchDoc <= HastaF:
    DISPLAY 'Almacén: ' + Almacen.codalm @ fi-Mensaje WITH FRAME f-Proceso.
    IF Almcmov.flgest = "A" THEN NEXT.
    IF Almcmov.flgsit <> "T" THEN NEXT.
    FOR EACH Almdmov OF almcmov NO-LOCK, FIRST Almmmatg OF Almdmov NO-LOCK, FIRST Almtfami OF Almmmatg NO-LOCK:
        CREATE Detalle.
        ASSIGN
            Detalle.origen = Almcmov.codalm
            Detalle.nrodoc = STRING(Almcmov.nroser,'999') + "-" + STRING(Almcmov.nrodoc,'999999999')
            Detalle.fchdoc = Almcmov.fchdoc
            Detalle.destino = Almcmov.almdes
            Detalle.observ = Almcmov.observ
            Detalle.codmat = Almdmov.codmat
            Detalle.desmat = Almmmatg.desmat
            Detalle.unidad = Almmmatg.undbas
            Detalle.desmar = Almmmatg.desmar
            Detalle.codfam = Almmmatg.codfam
            Detalle.cantidad = Almdmov.candes * Almdmov.factor
            Detalle.orden = Almcmov.nroref
            .
        FIND LAST Almstkge WHERE AlmStkge.CodCia = s-codcia
            AND AlmStkge.codmat = Almdmov.codmat
            AND AlmStkge.Fecha <= Almcmov.fchdoc
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almstkge THEN Detalle.ctoprom = AlmStkge.CtoUni.
        IF Almcmov.crossdocking = YES THEN DO:
            Detalle.Intermedio = Almcmov.almacenxd.
            FIND bAlmacen WHERE bAlmacen.codcia = s-codcia
                AND bAlmacen.codalm = Detalle.Intermedio
                NO-LOCK NO-ERROR.
            IF AVAILABLE bAlmacen THEN Detalle.nomintermedio = bAlmacen.Descripcion.
        END.
        /* Datos adicionales */
        ASSIGN
            Detalle.nomorigen = Almacen.Descripcion
            Detalle.desfam = Almtfami.desfam
            .
        FIND bAlmacen WHERE bAlmacen.codcia = s-codcia 
            AND bAlmacen.codalm = Detalle.destino
            NO-LOCK NO-ERROR.
        IF AVAILABLE bAlmacen THEN Detalle.nomdestino = bAlmacen.Descripcion.
    END.
END.
HIDE FRAME f-Proceso.

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
  DISPLAY EDITOR_Almacenes desdeF hastaF C-Tipmov I-CodMov N-MOVI 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-3 BUTTON-10 desdeF hastaF BUTTON_Texto BtnDone 
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN 
         DesdeF = TODAY
         HastaF = TODAY
         C-tipmov.
     CASE C-tipmov:
         WHEN "Salida"  THEN X-Tipmov = "S".
     END.
     FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
         Almtmovm.tipmov = X-TIPMOV AND
         Almtmovm.codmov = INTEGER(I-CodMov) NO-LOCK NO-ERROR.
     IF AVAILABLE Almtmovm THEN N-MOVI = Almtmovm.Desmov.
     DISPLAY DesdeF HastaF I-Codmov C-tipmov N-movi.    
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

