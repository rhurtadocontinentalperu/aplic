&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-FacTabla FOR FacTabla.
DEFINE NEW SHARED TEMP-TABLE T-FacTabla LIKE FacTabla.
DEFINE TEMP-TABLE ttFacTabla NO-UNDO LIKE FacTabla
       INDEX Llave01 AS PRIMARY codigo.



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
DEF SHARED VAR s-codcia AS INTE.
/* Local Variable Definitions ---                                       */

DEF NEW SHARED VAR s-Tabla   AS CHAR.
DEF NEW SHARED VAR s-Tabla-1 AS CHAR.
DEF NEW SHARED VAR lh_Handle AS HANDLE.
DEF NEW SHARED VAR S-CODDOC   AS CHAR.

s-Tabla   = "DVXSALDOC".      /* Descto x Vol x Saldos Cabecera */
s-Tabla-1 = "DVXSALDOD".      /* Descto x Vol x Saldos Detalle */

DEFINE VARIABLE chExcelApplication          AS COM-HANDLE.
DEFINE VARIABLE chWorkbook                  AS COM-HANDLE.
DEFINE VARIABLE chWorksheet                 AS COM-HANDLE.
DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.

DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 BUTTON-4 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_bdctxvolacuxsaldos-01 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bdctxvolacuxsaldos-02 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-dctoxvolacuxsaldos-out AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv10 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vdctxvolacuxsaldos-01 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/import-excel.bmp":U
     LABEL "Button 4" 
     SIZE 19 BY 1.62.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 30 BY 4.04
     BGCOLOR 14 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-4 AT ROW 18.5 COL 74 WIDGET-ID 2
     RECT-1 AT ROW 16.88 COL 71 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 104.43 BY 23.31 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-FacTabla B "?" ? INTEGRAL FacTabla
      TABLE: T-FacTabla T "NEW SHARED" ? INTEGRAL FacTabla
      TABLE: ttFacTabla T "?" NO-UNDO INTEGRAL FacTabla
      ADDITIONAL-FIELDS:
          INDEX Llave01 AS PRIMARY codigo
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "DESCUENTOS POR VOLUMEN POR VENTAS ACUMULADAS - SALDOS"
         HEIGHT             = 23.31
         WIDTH              = 104.43
         MAX-HEIGHT         = 23.31
         MAX-WIDTH          = 115.57
         VIRTUAL-HEIGHT     = 23.31
         VIRTUAL-WIDTH      = 115.57
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* DESCUENTOS POR VOLUMEN POR VENTAS ACUMULADAS - SALDOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* DESCUENTOS POR VOLUMEN POR VENTAS ACUMULADAS - SALDOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
  DEF VAR pMensaje AS CHAR NO-UNDO.
  DEF VAR pAvisos AS LONGCHAR NO-UNDO.

  RUN Captura-Excel (OUTPUT pMensaje, OUTPUT pAvisos).

  IF TRUE <> (pMensaje > '') THEN DO:
      /* Todo OK */
      RUN dispatch IN h_bdctxvolacuxsaldos-01 ('open-query':U).
      MESSAGE 'Carga Terminada' VIEW-AS ALERT-BOX INFORMATION.
  END.
  ELSE MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
  IF pAvisos > '' THEN MESSAGE STRING(pAvisos) VIEW-AS ALERT-BOX INFORMATION.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
lh_Handle = THIS-PROCEDURE.

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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv10.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv10 ).
       RUN set-position IN h_p-updv10 ( 1.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv10 ( 1.42 , 41.72 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/bdctxvolacuxsaldos-01.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bdctxvolacuxsaldos-01 ).
       RUN set-position IN h_bdctxvolacuxsaldos-01 ( 2.54 , 2.00 ) NO-ERROR.
       RUN set-size IN h_bdctxvolacuxsaldos-01 ( 6.69 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/vdctxvolacuxsaldos-01.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_vdctxvolacuxsaldos-01 ).
       RUN set-position IN h_vdctxvolacuxsaldos-01 ( 2.54 , 70.00 ) NO-ERROR.
       /* Size in UIB:  ( 11.23 , 34.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/bdctxvolacuxsaldos-02.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bdctxvolacuxsaldos-02 ).
       RUN set-position IN h_bdctxvolacuxsaldos-02 ( 9.46 , 2.00 ) NO-ERROR.
       RUN set-size IN h_bdctxvolacuxsaldos-02 ( 13.27 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96 ).
       RUN set-position IN h_p-updv96 ( 13.69 , 70.00 ) NO-ERROR.
       RUN set-size IN h_p-updv96 ( 1.54 , 26.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/f-dctoxvolacuxsaldos-out.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-dctoxvolacuxsaldos-out ).
       RUN set-position IN h_f-dctoxvolacuxsaldos-out ( 17.15 , 74.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.12 , 20.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = Multiple-Records':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 22.73 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 1.42 , 34.14 ) NO-ERROR.

       /* Links to SmartBrowser h_bdctxvolacuxsaldos-01. */
       RUN add-link IN adm-broker-hdl ( h_p-updv10 , 'TableIO':U , h_bdctxvolacuxsaldos-01 ).

       /* Links to SmartViewer h_vdctxvolacuxsaldos-01. */
       RUN add-link IN adm-broker-hdl ( h_bdctxvolacuxsaldos-01 , 'Record':U , h_vdctxvolacuxsaldos-01 ).
       RUN add-link IN adm-broker-hdl ( h_p-updv96 , 'TableIO':U , h_vdctxvolacuxsaldos-01 ).

       /* Links to SmartBrowser h_bdctxvolacuxsaldos-02. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_bdctxvolacuxsaldos-02 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv10 ,
             BUTTON-4:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_bdctxvolacuxsaldos-01 ,
             h_p-updv10 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_vdctxvolacuxsaldos-01 ,
             h_bdctxvolacuxsaldos-01 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_bdctxvolacuxsaldos-02 ,
             h_vdctxvolacuxsaldos-01 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96 ,
             h_bdctxvolacuxsaldos-02 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-dctoxvolacuxsaldos-out ,
             h_p-updv96 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             BUTTON-4:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Excel W-Win 
PROCEDURE Captura-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER pAvisos AS LONGCHAR NO-UNDO.

    DEF VAR FILL-IN-Archivo AS CHAR NO-UNDO.
    DEF VAR OKpressed AS LOG NO-UNDO.

    /* RUTINA GENERAL */
    SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
        FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls,*.xlsx", "Todos (*.*)" "*.*"
        TITLE "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN DO:
        pMensaje = "Proceso cancelado por el usuario".
        RETURN.
    END.

    /* CREAMOS LA HOJA EXCEL */
    CREATE "Excel.Application" chExcelApplication.
    chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Carga-Temporal (OUTPUT pMensaje, OUTPUT pAvisos).
    SESSION:SET-WAIT-STATE('').
    /* CERRAMOS EL EXCEL */
    chExcelApplication:QUIT().
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet. 

    IF TRUE <> (pMensaje > '') THEN DO:
        RUN Grabacion.
    END.

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
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pAvisos AS LONGCHAR NO-UNDO.

DEF VAR k         AS INT NO-UNDO.
DEF VAR cCodMat AS CHAR NO-UNDO.
DEF VAR x-Codigo AS CHAR NO-UNDO.

/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
ASSIGN
    t-Column = 0
    t-Row = 1.     /* Saltamos 1ra linea */

cValue = chWorkSheet:Cells(1,1):VALUE.
IF cValue = "" OR cValue = ? THEN DO:
    pMensaje = 'Formato del archivo Excel errado'.
    RETURN.
END.

/* ******** */
ASSIGN
    t-Row    = t-Row + 1
    t-column = t-column + 1.
cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
IF cValue = "" OR cValue = ? OR cValue <> "ARTICULO" THEN DO:
    pMensaje = 'Formato del archivo Excel errado'.
    RETURN.
END.

/* Cargamos temporal */
EMPTY TEMP-TABLE ttFacTabla.

ASSIGN
    t-Column = 0
    t-Row = 2.     /* Saltamos el encabezado de los campos */
REPEAT:
    ASSIGN
        t-column = 0
        t-Row    = t-Row + 1.
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 

    /* Artículo */
    ASSIGN cCodMat = cValue.

    /* Llaves */
    IF NOT CAN-FIND(FIRST ttFacTabla WHERE ttFacTabla.campo-c[1] = cCodMat NO-LOCK) THEN DO:
        CREATE ttFacTabla.
        ASSIGN
            ttFacTabla.campo-c[1] = cCodMat.
    END.
    ELSE pAvisos = pAvisos + (IF TRUE <> (pAvisos > '') THEN '' ELSE CHR(10)) +
        "Artículo: " + cCodMat + " ya registrado".
END.

/* Depuración */
FOR EACH ttFacTabla:
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = ttFacTabla.campo-c[1] NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        pAvisos = pAvisos + (IF TRUE <> (pAvisos > '') THEN '' ELSE CHR(10)) +
            "Artículo: " + ttFacTabla.campo-c[1] + " no registrado en el catálogo de artículos".        
        DELETE ttFacTabla.
        NEXT.
    END.
    IF Almmmatg.TpoArt = "D" THEN DO:
        pAvisos = pAvisos + (IF TRUE <> (pAvisos > '') THEN '' ELSE CHR(10)) +
            "Artículo: " + ttFacTabla.campo-c[1] + " DESACTIVADO".        
        DELETE ttFacTabla.
        NEXT.
    END.
    /* FAMILIA DE VENTAS */
    FIND Almtfami OF Almmmatg NO-LOCK.
    IF Almtfami.SwComercial = NO THEN DO:
        pAvisos = pAvisos + (IF TRUE <> (pAvisos > '') THEN '' ELSE CHR(10)) +
            "Artículo: " + ttFacTabla.campo-c[1] + " no pertenece a una línea comercial".
        DELETE ttFacTabla.
        NEXT.
    END.
    /* REGISTRADO EN OTRA PROMOCION */
    x-Codigo = s-CodDoc + '|' + ttFacTabla.Campo-C[1].
    IF CAN-FIND(FIRST B-FacTabla WHERE B-FacTabla.codcia = s-codcia
                AND B-FacTabla.tabla = s-tabla-1
                AND B-FacTabla.codigo <> x-codigo
                AND B-FacTabla.Campo-C[1] = ttFacTabla.campo-c[1]
                NO-LOCK) THEN DO:
        pAvisos = pAvisos + (IF TRUE <> (pAvisos > '') THEN '' ELSE CHR(10)) +
            "Artículo: " + ttFacTabla.campo-c[1] + " registrado en otra promoción".
        DELETE ttFacTabla.
        NEXT.
    END.
END.
FIND FIRST ttFacTabla NO-LOCK NO-ERROR.
IF NOT AVAILABLE ttFacTabla THEN pMensaje = 'No hay registros que procesar'.

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
  ENABLE RECT-1 BUTTON-4 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabacion W-Win 
PROCEDURE Grabacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Grabación */
DEF VAR x-Codigo AS CHAR NO-UNDO.
DEF VAR pEvento AS CHAR NO-UNDO.
DEF VAR pValorLlave AS CHAR NO-UNDO.

FOR EACH ttFacTabla:
  x-Codigo = s-CodDoc + '|' + ttFacTabla.Campo-C[1].

  IF CAN-FIND(FIRST B-FacTabla WHERE B-FacTabla.codcia = s-codcia
              AND B-FacTabla.tabla = s-tabla-1
              AND B-FacTabla.codigo = x-codigo NO-LOCK)
      THEN DO:
/*       MESSAGE 'Artículo:' ttFacTabla.Campo-C[1] 'repetido' VIEW-AS ALERT-BOX WARNING. */
      NEXT.
  END.
  IF CAN-FIND(FIRST B-FacTabla WHERE B-FacTabla.codcia = s-codcia
              AND B-FacTabla.tabla = s-tabla-1
              AND B-FacTabla.codigo <> x-Codigo
              AND B-FacTabla.Campo-C[1] = ttFacTabla.Campo-C[1]
              NO-LOCK)
      THEN DO:
/*       MESSAGE 'Artículo:' ttFacTabla.Campo-C[1] 'registrado en otra promoción' VIEW-AS ALERT-BOX WARNING. */
      NEXT.
  END.
  ASSIGN
      ttFacTabla.CodCia = s-codcia
      ttFacTabla.Tabla  = s-Tabla-1
      ttFacTabla.Codigo = x-Codigo.
  CREATE B-FacTabla.
  BUFFER-COPY ttFacTabla TO B-FacTabla.

  /* LOG */
  pEvento = 'CREATE'.
  pValorLlave = B-FacTabla.Tabla + '|' + B-FacTabla.Codigo + '|' + B-FacTabla.Campo-C[1].
  RUN lib/logtabla (INPUT 'FacTabla',
                    INPUT pValorLlave,
                    INPUT pEvento).
  RELEASE B-FacTabla.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle W-Win 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pParametro AS CHAR.

CASE pParametro:
    WHEN "Open-Browse" THEN IF h_bdctxvolacuxsaldos-02 <> ? THEN RUN dispatch IN h_bdctxvolacuxsaldos-02 ('open-query':U).
    WHEN "Disable-Others" THEN DO:
        RUN dispatch IN h_p-updv12 ('disable':U).
        RUN dispatch IN h_p-updv96 ('disable':U).
    END.
    WHEN "Enable-Others" THEN DO:
        RUN dispatch IN h_p-updv12 ('enable':U).
        RUN dispatch IN h_p-updv96 ('enable':U).
    END.
    WHEN "Disable-Headers" THEN DO:
        RUN dispatch IN h_p-updv10 ('disable':U).
        RUN dispatch IN h_p-updv96 ('disable':U).
    END.
    WHEN "Enable-Headers" THEN DO:
        RUN dispatch IN h_p-updv10 ('enable':U).
        RUN dispatch IN h_p-updv96 ('enable':U).
    END.
    WHEN "Disable-Others-2" THEN DO:
        RUN dispatch IN h_p-updv12 ('disable':U).
        RUN dispatch IN h_p-updv10 ('disable':U).
    END.
    WHEN "Enable-Others-2" THEN DO:
        RUN dispatch IN h_p-updv12 ('enable':U).
        RUN dispatch IN h_p-updv10 ('enable':U).
    END.
END CASE.

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

