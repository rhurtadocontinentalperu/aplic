&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttVtaTabla NO-UNDO LIKE VtaTabla.



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
DEFINE OUTPUT PARAMETER p-msg AS CHAR.
DEFINE INPUT PARAMETER pRowId AS ROWID.

/* Local Variable Definitions ---                                       */

FIND FIRST factabla WHERE ROWID(factabla) = pRowId NO-LOCK NO-ERROR.
IF NOT AVAILABLE factabla THEN DO:
    MESSAGE "No existe registro en FACTABLA" 
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN ERROR.
END.

DEFINE VAR x-col-precio AS DEC.
DEFINE SHARED VAR s-codcia AS INT.

DEFINE VAR X-archivo AS CHAR.

DEFINE BUFFER x-almmmatg FOR almmmatg.

p-msg = "ERROR".


DEFINE VAR x-salto-linea AS CHAR.
x-salto-linea = CHR(13) + CHR(10).

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

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES FacTabla
&Scoped-define FIRST-EXTERNAL-TABLE FacTabla


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacTabla.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttVtaTabla Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 ttVtaTabla.Llave_c2 Almmmatg.DesMat ~
Almmmatg.DesMar Almmmatg.Chr__01 ~
Almmmatg.Prevta[1] * (if (almmmatg.monvta = 2) then almmmatg.tpocmb else 1) @ x-col-precio ~
ttVtaTabla.Valor[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH ttVtaTabla WHERE TRUE /* Join to FacTabla incomplete */ NO-LOCK, ~
      EACH Almmmatg WHERE Almmmatg.CodCia = ttVtatabla.codcia and ~
almmmatg.codmat = ttVtatabla.llave_c2 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH ttVtaTabla WHERE TRUE /* Join to FacTabla incomplete */ NO-LOCK, ~
      EACH Almmmatg WHERE Almmmatg.CodCia = ttVtatabla.codcia and ~
almmmatg.codmat = ttVtatabla.llave_c2 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 ttVtaTabla Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 ttVtaTabla
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 Almmmatg


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel Btn_Help BROWSE-2 ~
BUTTON-11 
&Scoped-Define DISPLAYED-FIELDS FacTabla.Nombre FacTabla.Campo-D[1] ~
FacTabla.Campo-D[2] FacTabla.Campo-C[1] 
&Scoped-define DISPLAYED-TABLES FacTabla
&Scoped-define FIRST-DISPLAYED-TABLE FacTabla
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-codigo 

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

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-11 
     LABEL "Importar desde Excel" 
     SIZE 20 BY 1.12.

DEFINE VARIABLE FILL-IN-codigo AS CHARACTER FORMAT "X(50)":U 
     LABEL "Clasificacion Cliente" 
     VIEW-AS FILL-IN 
     SIZE 63 BY 1
     FGCOLOR 9  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      ttVtaTabla, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 D-Dialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      ttVtaTabla.Llave_c2 COLUMN-LABEL "Articulo" FORMAT "x(8)":U
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 39.86
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U WIDTH 20.43
      Almmmatg.Chr__01 COLUMN-LABEL "Und Vta" FORMAT "X(8)":U
      Almmmatg.Prevta[1] * (if (almmmatg.monvta = 2) then almmmatg.tpocmb else 1) @ x-col-precio COLUMN-LABEL "Precio (S/)" FORMAT "->,>>>,>>9.9999":U
            WIDTH 8.86
      ttVtaTabla.Valor[1] COLUMN-LABEL "Nuevo!Precio" FORMAT "->>>,>>>,>>9.9999":U
            WIDTH 12.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 112 BY 10.77
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-codigo AT ROW 1.08 COL 14 COLON-ALIGNED WIDGET-ID 12
     Btn_OK AT ROW 1.38 COL 107
     FacTabla.Nombre AT ROW 2.08 COL 14 COLON-ALIGNED WIDGET-ID 10
          LABEL "Descripcion" FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 41.43 BY 1
          FGCOLOR 9 
     Btn_Cancel AT ROW 2.62 COL 107
     FacTabla.Campo-D[1] AT ROW 3.08 COL 14 COLON-ALIGNED WIDGET-ID 4
          LABEL "Vigencia Desde" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 16 BY .96
          FGCOLOR 9 
     FacTabla.Campo-D[2] AT ROW 3.08 COL 37.72 COLON-ALIGNED WIDGET-ID 6
          LABEL "Hasta" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .96
          FGCOLOR 9 
     FacTabla.Campo-C[1] AT ROW 4.04 COL 14 COLON-ALIGNED WIDGET-ID 2
          LABEL "Estado" FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .92
          FGCOLOR 9 
     Btn_Help AT ROW 4.12 COL 107
     BROWSE-2 AT ROW 5.27 COL 2 WIDGET-ID 200
     BUTTON-11 AT ROW 16.27 COL 10 WIDGET-ID 14
     SPACE(94.28) SKIP(0.33)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Importar desde Excel" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   External Tables: INTEGRAL.FacTabla
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttVtaTabla T "?" NO-UNDO INTEGRAL VtaTabla
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
/* BROWSE-TAB BROWSE-2 Btn_Help D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FacTabla.Campo-C[1] IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacTabla.Campo-D[1] IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacTabla.Campo-D[2] IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FILL-IN-codigo IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacTabla.Nombre IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.ttVtaTabla WHERE INTEGRAL.FacTabla <external> ...,INTEGRAL.Almmmatg WHERE Temp-Tables.ttVtaTabla ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _JoinCode[2]      = "Almmmatg.CodCia = ttVtatabla.codcia and
almmmatg.codmat = ttVtatabla.llave_c2"
     _FldNameList[1]   > Temp-Tables.ttVtaTabla.Llave_c2
"Temp-Tables.ttVtaTabla.Llave_c2" "Articulo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"INTEGRAL.Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "39.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"INTEGRAL.Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.Chr__01
"INTEGRAL.Almmmatg.Chr__01" "Und Vta" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"Almmmatg.Prevta[1] * (if (almmmatg.monvta = 2) then almmmatg.tpocmb else 1) @ x-col-precio" "Precio (S/)" "->,>>>,>>9.9999" ? ? ? ? ? ? ? no ? no no "8.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttVtaTabla.Valor[1]
"Temp-Tables.ttVtaTabla.Valor[1]" "Nuevo!Precio" "->>>,>>>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON END-ERROR OF FRAME D-Dialog /* Importar desde Excel */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Importar desde Excel */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
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
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
        btn_ok:AUTO-GO = NO.	/* del Boton OK */	

        DEFINE VAR x-proceso AS CHAR.

        MESSAGE 'Seguro de grabar el proceso?' VIEW-AS ALERT-BOX QUESTION
	            BUTTONS YES-NO UPDATE rpta AS LOG.
	    IF rpta = YES THEN DO:
            p-msg = "".
            x-proceso = "".
            RUN grabar-data(OUTPUT x-proceso).
            IF x-proceso = 'OK' THEN DO:
                p-msg = "OK".               
                btn_ok:AUTO-GO = YES.           
            END.
       END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-11 D-Dialog
ON CHOOSE OF BUTTON-11 IN FRAME D-Dialog /* Importar desde Excel */
DO:
    
    DEFINE VAR rpta AS LOG.

	SYSTEM-DIALOG GET-FILE x-Archivo
	    FILTERS 'Excel (*.xls)' '*.xls,*.xlsx'
        DEFAULT-EXTENSION '.xls'
	    RETURN-TO-START-DIR
	    TITLE 'Importar Excel'
	    UPDATE rpta.
	IF rpta = NO OR x-Archivo = '' THEN RETURN.

    RUN leer-excel.

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "FacTabla"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FacTabla"}

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
  DISPLAY FILL-IN-codigo 
      WITH FRAME D-Dialog.
  IF AVAILABLE FacTabla THEN 
    DISPLAY FacTabla.Nombre FacTabla.Campo-D[1] FacTabla.Campo-D[2] 
          FacTabla.Campo-C[1] 
      WITH FRAME D-Dialog.
  ENABLE Btn_OK Btn_Cancel Btn_Help BROWSE-2 BUTTON-11 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-data D-Dialog 
PROCEDURE grabar-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE OUTPUT PARAMETER x-grabo AS CHAR NO-UNDO.
                       
    SESSION:SET-WAIT-STATE("GENERAL").

    x-grabo = "GRABANDOOO".
    GRABAR_DATOS:
    DO TRANSACTION ON ERROR UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS:
	    DO:
		    /* Header update block */
	    END.
	    FOR EACH ttvtatabla ON ERROR UNDO, THROW:
		    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                        vtatabla.tabla = factabla.tabla AND
                                        vtatabla.llave_c1 = factabla.codigo AND
                                        vtatabla.llave_c2 = ttvtatabla.llave_c2 EXCLUSIVE-LOCK NO-ERROR.
            IF LOCKED vtatabla THEN DO:
                x-grabo = "La tabla VTATABLA esta bloqueada por otro usuario" + x-salto-linea +
                        ERROR-STATUS:GET-MESSAGE(1).
                UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
            END.
            IF NOT AVAILABLE vtatabla THEN DO:
                CREATE vtatabla.
                    ASSIGN vtatabla.codcia = ttvtatabla.codcia
                            vtatabla.tabla = ttvtatabla.tabla
                            vtatabla.llave_c1 = ttvtatabla.llave_c1
                            vtatabla.llave_c2 = ttvtatabla.llave_c2
                            vtatabla.valor[1] = ttvtatabla.valor[1] NO-ERROR
                        .
                    IF ERROR-STATUS:ERROR THEN DO:
                        x-grabo = "Error en la tabla VTATABLA al insertar registro" + x-salto-linea +
                                ERROR-STATUS:GET-MESSAGE(1).
                        UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
                    END.                       
            END.
            ELSE DO:
                ASSIGN vtatabla.valor[1] = ttvtatabla.valor[1] NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:
                    x-grabo = "Error en la tabla VTATABLA al actualizar registro" + x-salto-linea +
                            ERROR-STATUS:GET-MESSAGE(1).
                    UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
                END.                       
            END.
	    END.
        x-grabo = "OK".
	END. /* TRANSACTION block */

    SESSION:SET-WAIT-STATE("").

    RELEASE vtatabla.

    IF x-grabo = 'OK' THEN DO:
        MESSAGE "Proceso de grabado fue CORRECTAMENTE" VIEW-AS ALERT-BOX INFORMATION.       
    END.
    ELSE DO:
        MESSAGE "Hubo PROBLEMAS al momento de grabar" SKIP
                x-grabo VIEW-AS ALERT-BOX INFORMATION.
    END.

    /*
	IF NOT ERROR-STATUS:ERROR THEN      
		ERROR-STATUS:GET-MESSAGE(1)
    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leer-excel D-Dialog 
PROCEDURE leer-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

	
    DEFINE VARIABLE lFileXls                 AS CHARACTER.
	DEFINE VARIABLE lNuevoFile               AS LOG.

    DEFINE VAR xCaso AS CHAR.
    DEFINE VAR xFamilia AS CHAR.
    DEFINE VAR xSubFamilia AS CHAR.
    DEFINE VAR lLinea AS INT.
    DEFINE VAR dValor AS DEC.
    DEFINE VAR lTpoCmb AS DEC.

    SESSION:SET-WAIT-STATE("GENERAL").

	lFileXls = X-archivo.		/* Nombre el archivo a abrir o crear, vacio solo para nuevos */
	lNuevoFile = NO.	                    /* Si va crear un nuevo archivo o abrir */

	{lib\excel-open-file.i}

    lMensajeAlTerminar = NO. /*  */
    lCerrarAlTerminar = YES.	/* Si permanece abierto el Excel luego de concluir el proceso */

    iColumn = 1.
    lLinea = 1.
    

    EMPTY TEMP-TABLE ttVtatabla.

    DEFINE VAR x-precio AS DEC.
    DEFINE VAR x-cod1 AS INT.
    DEFINE VAR x-total-regs AS INT.
    DEFINE VAR x-total-validos AS INT.

    cColumn = STRING(lLinea).
    REPEAT iColumn = 2 TO 65000 :
        cColumn = STRING(iColumn).

        cRange = "A" + cColumn.
        xCaso = chWorkSheet:Range(cRange):TEXT.

        IF xCaso = "" OR xCaso = ? THEN LEAVE.    /* FIN DE DATOS */
        
        x-cod1 = INTEGER(TRIM(xCaso)).
        xCaso = STRING(x-cod1,"999999").

        x-total-regs = x-total-regs + 1.

        FIND FIRST x-almmmatg WHERE x-almmmatg.codcia = s-codcia AND
                                    x-almmmatg.codmat = xCaso NO-LOCK NO-ERROR.
        IF AVAILABLE x-almmmatg THEN DO:

            cRange = "B" + cColumn.
            x-precio = chWorkSheet:Range(cRange):VALUE.

            IF x-precio > 0 THEN DO:
                CREATE ttVtatabla.
                    ASSIGN ttVtatabla.codcia = s-codcia
                            ttVtatabla.tabla = factabla.tabla
                            ttVtatabla.llave_c1 = factabla.codigo
                            ttVtatabla.llave_c2 = xCaso
                            ttVtatabla.valor[1] = x-precio
                        .
                x-total-validos = x-total-validos + 1.
            END.
        END.

    END.

	{lib\excel-close-file.i}

    {&open-query-browse-2}

    SESSION:SET-WAIT-STATE("").

    MESSAGE "Se trabajaron " SKIP
            STRING(x-total-validos) + " de " + STRING(x-total-regs) + " Registro(s)"
            VIEW-AS ALERT-BOX INFORMATION.

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
      fill-in-codigo:SCREEN-VALUE = factabla.codigo.
      FIND FIRST clfclie WHERE clfclie.categoria = factabla.codigo NO-LOCK NO-ERROR.
      IF AVAILABLE clfclie THEN DO:
            fill-in-codigo:SCREEN-VALUE = clfclie.descat.
      END.
      ELSE DO:
          FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
                                    gn-clie.codcli = factabla.codigo NO-LOCK NO-ERROR.
          IF AVAILABLE gn-clie THEN fill-in-codigo:SCREEN-VALUE = gn-clie.nomcli.
      END.
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "FacTabla"}
  {src/adm/template/snd-list.i "ttVtaTabla"}
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

