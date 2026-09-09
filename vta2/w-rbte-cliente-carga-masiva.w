&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



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
DEFINE INPUT PARAMETER pProceso AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia AS INT.

DEFINE VAR x-archivo AS CHAR.

DEFINE BUFFER b-rbte_cliente FOR rbte_cliente.

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
&Scoped-define INTERNAL-TABLES tt-w-report

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tt-w-report.Campo-I[1] ~
tt-w-report.Campo-C[1] tt-w-report.Campo-C[2] tt-w-report.Campo-C[3] ~
tt-w-report.Campo-C[4] tt-w-report.Campo-F[1] tt-w-report.Campo-F[2] ~
tt-w-report.Campo-F[3] tt-w-report.Campo-C[10] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tt-w-report NO-LOCK ~
    BY tt-w-report.Campo-I[1] INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tt-w-report NO-LOCK ~
    BY tt-w-report.Campo-I[1] INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tt-w-report


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 Btn_OK Btn_Cancel BUTTON-excel ~
TOGGLE-eliminar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-2 TOGGLE-eliminar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     LABEL "Grabar las metas" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-excel 
     LABEL "..." 
     SIZE 4 BY .96.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(150)":U INITIAL "Seleccione el Excel a cargar" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .81
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE TOGGLE-eliminar AS LOGICAL INITIAL no 
     LABEL "ELIMINAR registros que estan actualmente en la BD" 
     VIEW-AS TOGGLE-BOX
     SIZE 39 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 D-Dialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tt-w-report.Campo-I[1] COLUMN-LABEL "" FORMAT ">>,>>9":U
            WIDTH 4.43
      tt-w-report.Campo-C[1] COLUMN-LABEL "Cod.Cliente" FORMAT "X(11)":U
            WIDTH 13.43
      tt-w-report.Campo-C[2] COLUMN-LABEL "Agrupador" FORMAT "X(25)":U
            WIDTH 21.86
      tt-w-report.Campo-C[3] COLUMN-LABEL "R.U.C." FORMAT "X(11)":U
            WIDTH 13
      tt-w-report.Campo-C[4] COLUMN-LABEL "Nombre del Cliente" FORMAT "X(60)":U
            WIDTH 38.43
      tt-w-report.Campo-F[1] COLUMN-LABEL "Meta #1!Importe S/" FORMAT "->>,>>>,>>9.99":U
      tt-w-report.Campo-F[2] COLUMN-LABEL "Meta #2!Importe S/" FORMAT "->>,>>>,>>9.99":U
      tt-w-report.Campo-F[3] COLUMN-LABEL "Meta #3!Importe S/" FORMAT "->>,>>>,>>9.99":U
            WIDTH 9.86
      tt-w-report.Campo-C[10] COLUMN-LABEL "ERROR" FORMAT "X(150)":U
            WIDTH 54.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 132 BY 20.38
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-2 AT ROW 1.38 COL 2 WIDGET-ID 200
     Btn_Help AT ROW 20.85 COL 119
     Btn_OK AT ROW 22.15 COL 98.29
     Btn_Cancel AT ROW 22.15 COL 117.86
     BUTTON-excel AT ROW 22.27 COL 30 WIDGET-ID 6
     FILL-IN-2 AT ROW 22.35 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     TOGGLE-eliminar AT ROW 22.35 COL 57.86 WIDGET-ID 2
     SPACE(37.70) SKIP(0.60)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Carga masiva de metas" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
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

/* SETTINGS FOR BUTTON Btn_Help IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       Btn_Help:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tt-w-report.Campo-I[1]|yes"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-I[1]
"Campo-I[1]" "" ">>,>>9" "integer" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[1]
"Campo-C[1]" "Cod.Cliente" "X(11)" "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[2]
"Campo-C[2]" "Agrupador" "X(25)" "character" ? ? ? ? ? ? no ? no no "21.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[3]
"Campo-C[3]" "R.U.C." "X(11)" "character" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-C[4]
"Campo-C[4]" "Nombre del Cliente" "X(60)" "character" ? ? ? ? ? ? no ? no no "38.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-w-report.Campo-F[1]
"Campo-F[1]" "Meta #1!Importe S/" "->>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-w-report.Campo-F[2]
"Campo-F[2]" "Meta #2!Importe S/" "->>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-w-report.Campo-F[3]
"Campo-F[3]" "Meta #3!Importe S/" "->>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-w-report.Campo-C[10]
"Campo-C[10]" "ERROR" "X(150)" "character" ? ? ? ? ? ? no ? no no "54.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON END-ERROR OF FRAME D-Dialog /* Carga masiva de metas */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Carga masiva de metas */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  /*APPLY "END-ERROR":U TO SELF.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancel */
DO:
  /*btn_cancel:CANCEL-BUTTON = THIS-PROCEDURE:HANDLE.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help D-Dialog
ON CHOOSE OF Btn_Help IN FRAME D-Dialog /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
MESSAGE "Help for File: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Grabar las metas */
DO:

    ASSIGN toggle-eliminar.

    btn_ok:AUTO-GO = NO.        /* del Boton OK */      
    MESSAGE 'Seguro de grabar el proceso?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = YES THEN DO:

        IF toggle-eliminar = YES THEN DO:

            MESSAGE 'Se ELIMINARAN todas las metas actualmente registradas' SKIP
                    'Esta seguro de seguir con el proceso de GRABAR'
                    VIEW-AS ALERT-BOX QUESTION
                    BUTTONS YES-NO UPDATE rpta2 AS LOG.

            IF rpta2 = YES THEN DO:
                RUN grabar-metas.
                btn_ok:AUTO-GO = YES.
            END.

        END.
        ELSE DO:
            RUN grabar-metas.
            btn_ok:AUTO-GO = YES.
        END.
        
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-excel D-Dialog
ON CHOOSE OF BUTTON-excel IN FRAME D-Dialog /* ... */
DO:
    
    DEFINE VAR rpta AS LOG.

    x-Archivo = "".

        SYSTEM-DIALOG GET-FILE x-Archivo
            FILTERS 'Excel (*.xls)' '*.xls,*.xlsx'
            DEFAULT-EXTENSION '.xls'
            RETURN-TO-START-DIR
            TITLE 'Importar Excel'
            UPDATE rpta.
        IF rpta = NO OR x-Archivo = '' THEN DO:
        RETURN NO-APPLY.
    END.
  
    RUN cargar-excel.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-excel D-Dialog 
PROCEDURE cargar-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lFileXls                 AS CHARACTER.
        DEFINE VARIABLE lNuevoFile               AS LOG.

    DEFINE VAR x-Cliente AS CHAR.
    DEFINE VAR x-Agrupador AS CHAR.
    DEFINE VAR x-meta1 AS DEC.
    DEFINE VAR x-meta2 AS DEC.
    DEFINE VAR x-meta3 AS DEC.
    DEFINE VAR lLinea AS INT.
    DEFINE VAR x-item AS INT.

    SESSION:SET-WAIT-STATE("GENERAL").

        lFileXls = x-archivo.           /* Nombre el archivo a abrir o crear, vacio solo para nuevos */
        lNuevoFile = NO.                            /* Si va crear un nuevo archivo o abrir */

        {lib\excel-open-file.i}

    lMensajeAlTerminar = NO. /*  */
    lCerrarAlTerminar = YES.    /* Si permanece abierto el Excel luego de concluir el proceso */

        iColumn = 1.
    lLinea = 0.
    x-item = 0.

    EMPTY TEMP-TABLE tt-w-report.

    cColumn = STRING(lLinea).
    REPEAT iColumn = 2 TO 500000 :
        cColumn = STRING(iColumn).

        cRange = "A" + cColumn.
        x-Cliente = chWorkSheet:Range(cRange):TEXT.

        IF x-Cliente = "" OR x-Cliente = ? THEN LEAVE.    /* FIN DE DATOS */

        x-cliente = TRIM(x-cliente).

        IF LENGTH(x-Cliente) < 11 THEN DO:
            x-cliente = FILL("0", 11 - LENGTH(x-Cliente)) + x-cliente.
        END.

        cRange = "C" + cColumn.
        x-Agrupador = TRIM(chWorkSheet:Range(cRange):TEXT).

        lLinea = lLinea + 1.

        CREATE tt-w-report.
            ASSIGN tt-w-report.campo-c[1] = x-cliente
                    tt-w-report.campo-c[2] = x-agrupador
                    tt-w-report.campo-c[3] = ""
                    tt-w-report.campo-c[4] = ""
                    tt-w-report.campo-c[10] = "" 
                    tt-w-report.campo-f[1] = 0
                    tt-w-report.campo-f[2] = 0
                    tt-w-report.campo-f[3] = 0
                    tt-w-report.campo-i[1] = llinea
                .


        FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
                                    gn-clie.codcli = x-cliente NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-clie THEN DO:
            tt-w-report.campo-c[10] = "Codigo de Cliente no existe".
            NEXT.
        END.
        ASSIGN tt-w-report.campo-c[3] = gn-clie.ruc
        tt-w-report.campo-c[4] = gn-clie.nomcli.
        

        /* El cliente debe tener RUC */
        IF TRUE <> (gn-clie.ruc > "") THEN DO :
            IF TRUE <> (x-agrupador > "") THEN DO :
                tt-w-report.campo-c[10] = "Cliente NO tiene RUC".
                NEXT.
            END.
        END.
            
        cRange = "D" + cColumn.        
        x-meta1 = DECIMAL(TRIM(chWorkSheet:Range(cRange):TEXT)).
        cRange = "E" + cColumn.        
        x-meta2 = DECIMAL(TRIM(chWorkSheet:Range(cRange):TEXT)).
        cRange = "F" + cColumn.        
        x-meta3 = DECIMAL(TRIM(chWorkSheet:Range(cRange):TEXT)).

        /* Las metas deben ser mayor a CERO */
        IF NOT (x-meta1 > 0 AND x-meta2 > 0 AND x-meta3 > 0) THEN DO:
            tt-w-report.campo-c[10] = "Las metas debe ser mayor a cero".
            NEXT.
        END.
            
        /* Las metas debe ser de menor a mayor */
        IF NOT (x-meta1 < x-meta2 AND x-meta2 < x-meta3) THEN DO:
            tt-w-report.campo-c[10] = "Las metas debe ser de menor a mayor".
            NEXT.
        END.
             
        x-item = x-item + 1.
        ASSIGN tt-w-report.campo-f[1] = x-meta1
                tt-w-report.campo-f[2] = x-meta2
                tt-w-report.campo-f[3] = x-meta3.

    END.

    {lib\excel-close-file.i}

    {&open-query-browse-2}

    SESSION:SET-WAIT-STATE("").

    MESSAGE "Se encontraron " + STRING(x-item) + " registros validos" SKIP
                "de un total de " + STRING(lLinea)
                VIEW-AS ALERT-BOX INFORMATION.


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
  DISPLAY FILL-IN-2 TOGGLE-eliminar 
      WITH FRAME D-Dialog.
  ENABLE BROWSE-2 Btn_OK Btn_Cancel BUTTON-excel TOGGLE-eliminar 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-metas D-Dialog 
PROCEDURE grabar-metas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE("GENERAL").

DEFINE VAR x-msg AS CHAR INIT "OK".
DEFINE VAR x-rowid AS ROWID.

GRABAR_DATOS:
DO TRANSACTION ON ERROR UNDO, LEAVE:
    DO:
        IF toggle-eliminar = YES THEN DO:
            /* Eliminamos data anterior */
            FOR EACH rbte_cliente WHERE rbte_cliente.codcia = s-codcia AND
                                        rbte_cliente.codproceso = pProceso NO-LOCK:
                x-rowid = ROWID(rbte_cliente).
                FIND FIRST b-rbte_cliente WHERE ROWID(b-rbte_cliente) = x-rowid EXCLUSIVE-LOCK NO-ERROR.
                IF LOCKED b-rbte_cliente THEN DO:
                    x-msg = "La tabla RBTE_CLIENTE esta siendo usado de manera exclusivo por otro usuario(1)".
                    UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
                END.
                ELSE DO:
                    IF AVAILABLE b-rbte_cliente THEN DO:
                        DELETE b-rbte_cliente NO-ERROR.
                        IF ERROR-STATUS:ERROR = YES THEN DO:     
                            x-msg = ERROR-STATUS:GET-MESSAGE(1).
                            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
                        END.
                    END.
                END.
            END.
        END.
        
        /*  */
        FOR EACH tt-w-report WHERE tt-w-report.campo-c[10] = "" :

            FIND FIRST b-rbte_cliente WHERE b-rbte_cliente.codcia = s-codcia AND
                                                b-rbte_cliente.codproceso = pProceso AND
                                                b-rbte_cliente.codcli = tt-w-report.campo-c[1]
                                                EXCLUSIVE-LOCK NO-ERROR.
            IF LOCKED b-rbte_cliente THEN DO:
                x-msg = "La tabla RBTE_CLIENTE esta siendo usado de manera exclusivo por otro usuario(2)".
                UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
            END.
            IF NOT AVAILABLE b-rbte_cliente THEN DO:
                CREATE b-rbte_cliente.
                ASSIGN b-rbte_cliente.codcia = s-codcia
                         b-rbte_cliente.codproceso = pProceso
                         b-rbte_cliente.codcli = tt-w-report.campo-c[1]
                         b-rbte_cliente.ruc = tt-w-report.campo-c[3]
                         b-rbte_cliente.campo-c[1] = USERID("DICTDB") + "|" + STRING(TODAY,"99/99/9999") + "|" +
                                                        STRING(TIME,"HH:MM:SS") + "|CARGA MASIVA"
                        NO-ERROR.

                        IF ERROR-STATUS:ERROR = YES THEN DO:     
                            x-msg = ERROR-STATUS:GET-MESSAGE(1).
                            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
                        END.
            END.
            ASSIGN b-rbte_cliente.codagrupa = tt-w-report.campo-c[2]
                    b-rbte_cliente.meta[1] = tt-w-report.campo-f[1]
                    b-rbte_cliente.meta[2] = tt-w-report.campo-f[2]
                    b-rbte_cliente.meta[3] = tt-w-report.campo-f[3]
                    b-rbte_cliente.campo-c[2] = USERID("DICTDB") + "|" + STRING(TODAY,"99/99/9999") + "|" +
                                               STRING(TIME,"HH:MM:SS") + "|CARGA MASIVA" NO-ERROR.
            IF ERROR-STATUS:ERROR = YES THEN DO:     
                x-msg = ERROR-STATUS:GET-MESSAGE(1).
                UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
            END.

        END.

    END.
END.

SESSION:SET-WAIT-STATE("").

RELEASE b-rbte_cliente.

IF x-msg = 'OK' THEN DO:
    MESSAGE "Las METAS se grabaron de forma CORRECTA"
                VIEW-AS ALERT-BOX INFORMATION.
END.
ELSE DO:
    MESSAGE "Hubieron problemas al grabar los datos" SKIP
            x-msg VIEW-AS ALERT-BOX INFORMATION.
END.

END PROCEDURE.

/*
        DO TRANSACTION ON ERROR UNDO, LEAVE:
            DO:
                    /* Header update block */
            END.
            FOR EACH OrderLine ON ERROR UNDO, THROW:
                    /* Detalle update block */
            END.
        END. /* TRANSACTION block */

        IF NOT ERROR-STATUS:ERROR THEN      
                ERROR-STATUS:GET-MESSAGE(1)

*/

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
  {src/adm/template/snd-list.i "tt-w-report"}

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

