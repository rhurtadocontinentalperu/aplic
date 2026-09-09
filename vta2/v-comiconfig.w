&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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
DEF SHARED VAR s-codcia AS INT.
/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE Detalle LIKE ComiDetail.

{lib/tt-file.i}

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
&Scoped-define EXTERNAL-TABLES ComiConfig
&Scoped-define FIRST-EXTERNAL-TABLE ComiConfig


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ComiConfig.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ComiConfig.Divisiones ComiConfig.Desde ~
ComiConfig.Hasta ComiConfig.FlagRecalculo 
&Scoped-define ENABLED-TABLES ComiConfig
&Scoped-define FIRST-ENABLED-TABLE ComiConfig
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 
&Scoped-Define DISPLAYED-FIELDS ComiConfig.Divisiones ComiConfig.Desde ~
ComiConfig.Hasta ComiConfig.FlagRecalculo ComiConfig.Estado ~
ComiConfig.Inicio ComiConfig.Termino 
&Scoped-define DISPLAYED-TABLES ComiConfig
&Scoped-define FIRST-DISPLAYED-TABLE ComiConfig


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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 6.54.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 2.69.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     ComiConfig.Divisiones AT ROW 1.77 COL 12 NO-LABEL WIDGET-ID 16
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 37 BY 4
     BUTTON-1 AT ROW 1.77 COL 49 WIDGET-ID 24
     ComiConfig.Desde AT ROW 6 COL 10 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ComiConfig.Hasta AT ROW 6 COL 28 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ComiConfig.FlagRecalculo AT ROW 6.96 COL 12 WIDGET-ID 30
          LABEL "Recalcular Comisiones"
          VIEW-AS TOGGLE-BOX
          SIZE 19 BY .77
     ComiConfig.Estado AT ROW 8.31 COL 33 NO-LABEL WIDGET-ID 34
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Recálculo concluido", "T":U,
"Recálculo en proceso", "P":U,
"Sin histórico", ""
          SIZE 19 BY 2.31
     ComiConfig.Inicio AT ROW 8.5 COL 8 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 17.86 BY .81
     ComiConfig.Termino AT ROW 9.27 COL 8 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 17.86 BY .81
     "Parámetros para recalcular las comisiones" VIEW-AS TEXT
          SIZE 29 BY .5 AT ROW 1.19 COL 3 WIDGET-ID 26
          BGCOLOR 9 FGCOLOR 15 
     "Divisiones:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.77 COL 4 WIDGET-ID 18
     "Información Histórica" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 7.92 COL 3 WIDGET-ID 32
          BGCOLOR 9 FGCOLOR 15 
     RECT-2 AT ROW 1.38 COL 2 WIDGET-ID 28
     RECT-3 AT ROW 8.12 COL 2 WIDGET-ID 40
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.ComiConfig
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 10.04
         WIDTH              = 53.29.
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

/* SETTINGS FOR BUTTON BUTTON-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET ComiConfig.Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX ComiConfig.FlagRecalculo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ComiConfig.Inicio IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ComiConfig.Termino IN FRAME F-Main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 V-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:
  DEF VAR x-Divisiones AS CHAR.
  x-Divisiones = ComiConfig.Divisiones:SCREEN-VALUE.
  RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
  ComiConfig.Divisiones:SCREEN-VALUE = x-Divisiones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

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
  {src/adm/template/row-list.i "ComiConfig"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ComiConfig"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal V-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Detalle.

FOR EACH ComiDetail NO-LOCK WHERE ComiDetail.CodCia = s-codcia:
    CREATE Detalle.
    BUFFER-COPY ComiDetail TO Detalle.
END.

END PROCEDURE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Reporte V-table-Win 
PROCEDURE Imprime-Reporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN vta2/d-comi-reporte (ComiConfig.Divisiones, ComiConfig.Desde, ComiConfig.Hasta).

RETURN .

/*
DEF VAR pOptions AS CHAR.
DEF VAR pArchivo AS CHAR.
DEF VAR cArchivo AS CHAR.
DEF VAR zArchivo AS CHAR.
DEF VAR cComando AS CHAR.
DEF VAR pDirectorio AS CHAR.
DEF VAR lOptions AS CHAR.

RUN lib/tt-file-to-text-7zip (OUTPUT pOptions, OUTPUT pArchivo, OUTPUT pDirectorio).
IF pOptions = "" THEN RETURN.

    SESSION:SET-WAIT-STATE('GENERAL').
    IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
    RUN Carga-Temporal.
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').

    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    pOptions = pOptions + CHR(1) + "SkipList:CodCia".
    /* El archivo se va a generar en un archivo temporal de trabajo antes 
    de enviarlo a su directorio destino */
    pArchivo = REPLACE(pArchivo, '.', STRING(RANDOM(1,9999), '9999') + ".").
    cArchivo = LC(SESSION:TEMP-DIRECTORY + pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
    RUN lib/tt-file (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').
    /* Secuencia de comandos para encriptar el archivo con 7zip */
    IF INDEX(cArchivo, ".xls") > 0 THEN zArchivo = REPLACE(cArchivo, ".xls", ".zip").
    IF INDEX(cArchivo, ".txt") > 0 THEN zArchivo = REPLACE(cArchivo, ".txt", ".zip").
    cComando = '"C:\Archivos de programa\7-Zip\7z.exe" a ' + zArchivo + ' ' + cArchivo.
    OS-COMMAND 
        SILENT 
        VALUE ( cComando ).
    IF SEARCH(zArchivo) = ? THEN DO:
        MESSAGE 'NO se pudo encriptar el archivo' SKIP
            'Avise a sistemas'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    OS-DELETE VALUE(cArchivo).

    IF INDEX(cArchivo, '.xls') > 0 THEN cArchivo = REPLACE(pArchivo, ".xls", ".zip").
    IF INDEX(cArchivo, '.txt') > 0 THEN cArchivo = REPLACE(pArchivo, ".txt", ".zip").
    cComando = "copy " + zArchivo + ' ' + TRIM(pDirectorio) + TRIM(cArchivo).
    OS-COMMAND 
        SILENT 
        /*NO-WAIT */
        /*NO-CONSOLE */
        VALUE(cComando).
    OS-DELETE VALUE(zArchivo).
    /* ******************************************************* */

    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      BUTTON-1:SENSITIVE = NO.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      BUTTON-1:SENSITIVE = YES.
      ComiConfig.Divisiones:SENSITIVE = NO.
  END.

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
  {src/adm/template/snd-list.i "ComiConfig"}

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
IF ComiConfig.Estado = "P" THEN DO:
    MESSAGE 'Recálculo en proceso' SKIP 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

