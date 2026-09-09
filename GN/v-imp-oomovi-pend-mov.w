&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-report-2 NO-UNDO LIKE w-report.



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

/* Local Variable Definitions ---                                       */

DEF TEMP-TABLE Seg-Pedidos
    FIELD CodAlm        AS CHAR FORMAT 'x(8)'               LABEL 'ALMACEN'
    FIELD CodMat        AS CHAR FORMAT 'x(8)'               LABEL 'ARTICULO'
    FIELD DesMat        AS CHAR FORMAT 'x(100)'             LABEL 'DESCRIPCION'
    FIELD DesMar        AS CHAR FORMAT 'x(30)'              LABEL 'MARCA'
    FIELD CodFam        AS CHAR FORMAT 'x(8)'               LABEL 'LINEA'
    FIELD SubFam        AS CHAR FORMAT 'x(8)'               LABEL 'SUBLINEA'
    FIELD UndStk        AS CHAR FORMAT 'x(8)'               LABEL 'UNIDAD'
    FIELD Cantidad      AS DECI FORMAT '>>>,>>>,>>9.99'     LABEL 'CANTIDAD'
    FIELD CodUbi        AS CHAR FORMAT 'x(15)'              LABEL 'UBICACION'
    FIELD CodZona       AS CHAR FORMAT 'x(15)'              LABEL 'ZONA'
    FIELD NroSer        AS INTE                             LABEL 'SERIE'
    FIELD NroDoc        AS INTE FORMAT '>>>>>>>>>>>9'       LABEL 'CORRELATIVO'
    FIELD FchDoc        AS DATE FORMAT '99/99/9999'         LABEL 'FECHA'
    FIELD TipMov        AS CHAR FORMAT 'x(8)'               LABEL 'TIP MOV'
    FIELD CodMov        AS CHAR FORMAT 'x(8)'               LABEL 'COD MOV'
    .

DEF VAR pTipMov AS CHAR NO-UNDO.
DEF VAR pCodMov AS CHAR NO-UNDO.
DEF VAR pCodAlm AS CHAR NO-UNDO.
DEF VAR pArchivo AS CHAR NO-UNDO.

ASSIGN
    pTipMov  = "I"
    pCodMov  = "09,90,03"
    pCodAlm  = "11"
    pArchivo = "d:\tmp\spprueba.txt".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX_TipMov BUTTON-1 FILL-IN_CodMov ~
FILL-IN_CodAlm BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_TipMov FILL-IN_CodMov ~
FILL-IN_CodAlm 

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
     IMAGE-UP FILE "img/b-buscar.ico":U
     LABEL "Button 1" 
     SIZE 6 BY 1.08.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/print.ico":U
     LABEL "Button 2" 
     SIZE 11 BY 1.88.

DEFINE VARIABLE COMBO-BOX_TipMov AS CHARACTER FORMAT "X(256)":U 
     LABEL "Seleccione" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Ingreso","I",
                     "Salida","S"
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacenes" 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodMov AS CHARACTER FORMAT "X(256)":U 
     LABEL "Movimiento" 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX_TipMov AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 2
     BUTTON-1 AT ROW 2.62 COL 81 WIDGET-ID 18
     FILL-IN_CodMov AT ROW 2.88 COL 19 COLON-ALIGNED WIDGET-ID 4
     FILL-IN_CodAlm AT ROW 4.23 COL 19 COLON-ALIGNED WIDGET-ID 20
     BUTTON-2 AT ROW 5.58 COL 11 WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: t-report-2 T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
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
         HEIGHT             = 6.85
         WIDTH              = 106.86.
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    DEF VAR x-CodMov AS CHAR NO-UNDO.

    x-CodMov = COMBO-BOX_TipMov:SCREEN-VALUE.
    RUN gn\d-filtro-codmov (COMBO-BOX_TipMov:SCREEN-VALUE,
                            INPUT-OUTPUT x-CodMov,
                            INPUT "Movimientos").
    FILL-IN_CodMov:SCREEN-VALUE = x-CodMov.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 V-table-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  DEF VAR pOptions AS CHAR NO-UNDO.
  DEF VAR cArchivo AS CHAR NO-UNDO.

  RUN lib/tt-file-to-text-01.w (OUTPUT pOptions,
                                OUTPUT pArchivo).
  IF pOptions = "" THEN RETURN NO-APPLY.

  ASSIGN COMBO-BOX_TipMov FILL-IN_CodAlm FILL-IN_CodMov.
  ASSIGN
      pTipMov = COMBO-BOX_TipMov
      pCodMov = FILL-IN_CodMov
      pCodAlm = FILL-IN_CodAlm.

  EMPTY TEMP-TABLE Seg-Pedidos.

  RUN bgn/p-oomovi-pend-ing (INPUT pTipMov,
                             INPUT pCodMov,
                             INPUT pCodAlm,
                             OUTPUT TABLE t-report-2).
  EMPTY TEMP-TABLE Seg-Pedidos.
  FOR EACH t-report-2 NO-LOCK:
      CREATE Seg-Pedidos.
      ASSIGN
          Seg-Pedidos.CodAlm    = t-report-2.Campo-C[1]
          Seg-Pedidos.CodMat    = t-report-2.Campo-C[2]
          Seg-Pedidos.DesMat    = t-report-2.Campo-C[3]
          Seg-Pedidos.DesMar    = t-report-2.Campo-C[4]
          Seg-Pedidos.CodFam    = t-report-2.Campo-C[5]
          Seg-Pedidos.SubFam    = t-report-2.Campo-C[6]
          Seg-Pedidos.UndStk    = t-report-2.Campo-C[7]
          Seg-Pedidos.Cantidad  = decimal(t-report-2.Campo-C[8])
          Seg-Pedidos.CodUbi    = t-report-2.Campo-C[9]
          Seg-Pedidos.CodZona   = t-report-2.Campo-C[10]
          Seg-Pedidos.NroSer    = INTEGER(t-report-2.Campo-C[11])
          Seg-Pedidos.NroDoc    = integer(t-report-2.Campo-C[12])
          Seg-Pedidos.FchDoc    = date(t-report-2.Campo-C[13])
          Seg-Pedidos.TipMov    = t-report-2.Campo-C[14]
          Seg-Pedidos.CodMov    = t-report-2.Campo-C[15]
          .
  END.


  FIND FIRST Seg-Pedidos NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Seg-Pedidos THEN DO:
      MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  cArchivo = LC(pArchivo).
  SESSION:SET-WAIT-STATE('GENERAL').
  IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
  RUN lib/tt-filev2 (TEMP-TABLE Seg-Pedidos:HANDLE, cArchivo, pOptions).
  SESSION:DATE-FORMAT = "dmy".
  SESSION:SET-WAIT-STATE('').
  /* ******************************************************* */
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
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
          COMBO-BOX_TipMov:SCREEN-VALUE = pTipMov
          FILL-IN_CodAlm:SCREEN-VALUE = pCodAlm
          FILL-IN_CodMov:SCREEN-VALUE = pCodMov.
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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartViewer, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

