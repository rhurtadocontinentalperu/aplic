&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

/* Local Variable Definitions ---                                       */

DEF VAR pPeriodo AS CHAR NO-UNDO.
DEF VAR pMeses AS CHAR NO-UNDO.
DEF VAR pMes AS CHAR NO-UNDO.
DEF VAR s-codalm AS CHAR NO-UNDO.
DEF VAR s-coddiv AS CHAR NO-UNDO.

pMeses = "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre".


DISABLE TRIGGERS FOR LOAD OF integral.Almcmov.
DISABLE TRIGGERS FOR LOAD OF integral.Almdmov.
DISABLE TRIGGERS FOR LOAD OF cissac.Almcmov.
DISABLE TRIGGERS FOR LOAD OF cissac.Almdmov.
DISABLE TRIGGERS FOR LOAD OF integral.lg-cocmp.
DISABLE TRIGGERS FOR LOAD OF integral.lg-docmp.
DISABLE TRIGGERS FOR LOAD OF cissac.Faccpedi.
DISABLE TRIGGERS FOR LOAD OF cissac.Facdpedi.
DISABLE TRIGGERS FOR LOAD OF cissac.Ccbcdocu.
DISABLE TRIGGERS FOR LOAD OF cissac.Ccbddocu.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES INTEGRAL.lg-tabla

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 ~
SUBSTRING(lg-tabla.Codigo,1,4) @ pPeriodo ~
ENTRY(INTEGER(SUBSTRING(lg-tabla.Codigo,5,2)), pMeses) @ pMes ~
INTEGRAL.lg-tabla.Codigo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH INTEGRAL.lg-tabla ~
      WHERE INTEGRAL.lg-tabla.CodCia = s-codcia ~
 AND INTEGRAL.lg-tabla.Tabla = "DEVCOCI" NO-LOCK ~
    BY lg-tabla.Codigo DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH INTEGRAL.lg-tabla ~
      WHERE INTEGRAL.lg-tabla.CodCia = s-codcia ~
 AND INTEGRAL.lg-tabla.Tabla = "DEVCOCI" NO-LOCK ~
    BY lg-tabla.Codigo DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 INTEGRAL.lg-tabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 INTEGRAL.lg-tabla


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "EXTORNAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 83 BY 5
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      INTEGRAL.lg-tabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      SUBSTRING(lg-tabla.Codigo,1,4) @ pPeriodo COLUMN-LABEL "Periodo" FORMAT "x(4)":U
      ENTRY(INTEGER(SUBSTRING(lg-tabla.Codigo,5,2)), pMeses) @ pMes COLUMN-LABEL "Mes" FORMAT "x(15)":U
            WIDTH 35.29
      INTEGRAL.lg-tabla.Codigo FORMAT "x(8)":U WIDTH 16.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 63 BY 16.15
         TITLE "SELECCIONE EL PERIODO Y MES A EXTORNAR" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-2 AT ROW 1.19 COL 2 WIDGET-ID 200
     BUTTON-1 AT ROW 1.77 COL 67 WIDGET-ID 14
     EDITOR-1 AT ROW 17.54 COL 2 NO-LABEL WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85.14 BY 21.81 WIDGET-ID 100.


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
         TITLE              = "EXTORNO DE DEVOLUCIONES A CISSAC"
         HEIGHT             = 21.81
         WIDTH              = 85.14
         MAX-HEIGHT         = 22.73
         MAX-WIDTH          = 105.14
         VIRTUAL-HEIGHT     = 22.73
         VIRTUAL-WIDTH      = 105.14
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
/* BROWSE-TAB BROWSE-2 1 F-Main */
/* SETTINGS FOR EDITOR EDITOR-1 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.lg-tabla"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.lg-tabla.Codigo|no"
     _Where[1]         = "INTEGRAL.lg-tabla.CodCia = s-codcia
 AND INTEGRAL.lg-tabla.Tabla = ""DEVCOCI"""
     _FldNameList[1]   > "_<CALC>"
"SUBSTRING(lg-tabla.Codigo,1,4) @ pPeriodo" "Periodo" "x(4)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"ENTRY(INTEGER(SUBSTRING(lg-tabla.Codigo,5,2)), pMeses) @ pMes" "Mes" "x(15)" ? ? ? ? ? ? ? no ? no no "35.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.lg-tabla.Codigo
"lg-tabla.Codigo" ? ? "character" ? ? ? ? ? ? no ? no no "16.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* EXTORNO DE DEVOLUCIONES A CISSAC */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* EXTORNO DE DEVOLUCIONES A CISSAC */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* EXTORNAR */
DO:
   MESSAGE 'Procedemos con el Extorno de Devolcuiones a CISSAC'
       VIEW-AS ALERT-BOX QUESTION 
       BUTTONS YES-NO
       UPDATE rpta AS LOG.
   IF rpta = NO THEN RETURN NO-APPLY.
   SESSION:SET-WAIT-STATE('GENERAL').
   RUN Extorno-Conti-Cissac.
   SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anula-Ingreso-por-Compra W-Win 
PROCEDURE Anula-Ingreso-por-Compra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEF INPUT PARAMETER x-NroRf3 AS CHAR.

DEF VAR r-Rowid AS ROWID NO-UNDO.

trloop:
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND FIRST integral.Almcmov WHERE integral.Almcmov.CodCia  = s-CodCia 
        AND integral.Almcmov.CodAlm  = s-CodAlm 
        AND integral.Almcmov.TipMov  = "I"
        AND integral.Almcmov.CodMov  = 02
        AND integral.Almcmov.NroSer  = 000
        AND integral.Almcmov.NroRf3  = x-NroRf3
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.Almcmov THEN UNDO trloop, RETURN ERROR.
    FOR EACH integral.Almdmov OF integral.Almcmov:
/*         ASSIGN R-ROWID = ROWID(integral.Almdmov).                           */
/*         RUN ALMDCSTK (R-ROWID). /* Descarga del Almacen */                  */
/*         IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'. */
/*         RUN ALMACPR1-ING (R-ROWID,"D").                                     */
/*         IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'. */
        /* *************************************************** */
        DELETE integral.Almdmov.
    END.
    ASSIGN
        integral.Almcmov.flgest = "A".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE des_alm W-Win 
PROCEDURE des_alm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER X-ROWID AS ROWID.

FIND cissac.ccbcdocu WHERE ROWID(cissac.ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE cissac.ccbcdocu THEN RETURN ERROR.

trloop:
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    /* Anulamos orden de despacho */
    FIND cissac.almcmov WHERE cissac.almcmov.codcia = cissac.ccbcdocu.codcia 
        AND cissac.almcmov.codalm = cissac.ccbcdocu.codalm 
        AND cissac.almcmov.tipmov = "S" 
        AND cissac.almcmov.codmov = cissac.ccbcdocu.codmov 
        AND cissac.almcmov.nroSer = 0  
        AND cissac.almcmov.nrodoc = INTEGER(cissac.ccbcdocu.nrosal) EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE cissac.almcmov THEN DO:
        FOR EACH cissac.almdmov OF cissac.almcmov:
/*             RUN almacstk (ROWID(cissac.almdmov)).                         */
/*             IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN ERROR. */
/*             /* RHC 05.04.04 ACTIVAMOS KARDEX POR ALMACEN */               */
/*             RUN almacpr1 (ROWID(cissac.almdmov), 'D').                    */
/*             IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN ERROR. */
            DELETE cissac.almdmov.
        END.
        ASSIGN 
            cissac.almcmov.flgest = "A".
    END.
END.


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
  DISPLAY EDITOR-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-2 BUTTON-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorno-Conti-Cissac W-Win 
PROCEDURE Extorno-Conti-Cissac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE integral.Lg-Tabla THEN RETURN.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND CURRENT integral.Lg-Tabla EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.
    /* 1ro Extornamos los movimientos de salida de Continental */
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} +
        "Extorno Transferencias en CONTINENTAL y Devoluciones a CISSAC...".
    RUN extorno-conti-cissac-salida-conti NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} + 
            "ERROR" + CHR(10) +
            "NO se pudo extornar los movimientos de transferencias y devoluciones en Continental".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} + "OK" + CHR(10).

    /* 2do Generamos los movimientos de ingresos en Cissac */
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} +
        "Extorno Ingresos en el almacén 21 de CISSAC...".
    RUN extorno-conti-cissac-ingreso-cissac NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} + 
            "ERROR" + CHR(10) +
            "NO se pudo extornar los movimientos de ingresos en Cissac".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} + "OK" + CHR(10).

    /* 3ro Generamos la venta de Cissac a Continental */
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} +
        "Extorno Ventas de CISSAC a CONTINENTAL...".
    RUN extorno-conti-cissac-venta-cissac-conti NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} + 
            "ERROR" + CHR(10) +
            'NO se pudo extornar los movimientos de devoluciones en Cissac'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} + "OK" + CHR(10).

    /* 4to Generamos los movimientos de ingreso a Continental */
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} +
        "Extorno Salidas-Ingresos por Transferencias CONTINENTAL...".
    RUN extorno-conti-cissac-transfer-conti NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} + 
            "ERROR" + CHR(10) +
            'NO se pudo extornar los movimientos de salidas-ingreso por transferencia en Continental'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} + "OK" + CHR(10).

    DELETE INTEGRAL.lg-tabla.
END.
{&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
MESSAGE 'Proceso terminado con éxito' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorno-conti-cissac-ingreso-cissac W-Win 
PROCEDURE Extorno-conti-cissac-ingreso-cissac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

trloop:
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FOR EACH cissac.Almcmov WHERE cissac.Almcmov.codcia = s-codcia
        AND cissac.Almcmov.codalm = "21"
        AND cissac.Almcmov.tipmov = "I"
        AND cissac.Almcmov.codmov = 09
        AND cissac.Almcmov.coddoc = "DEVCOCI"
        AND cissac.Almcmov.nrorf3 = INTEGRAL.lg-tabla.Codigo:
        FOR EACH cissac.Ccbcdocu WHERE cissac.Ccbcdocu.codcia = s-codcia
            AND cissac.Ccbcdocu.coddoc = "N/C"
            AND cissac.Ccbcdocu.codalm = cissac.Almcmov.codalm
            AND cissac.Ccbcdocu.codmov = cissac.Almcmov.codmov
            AND INTEGER(cissac.Ccbcdocu.nroped) = cissac.Almcmov.nrodoc:
            ASSIGN
                cissac.Ccbcdocu.flgest = "A".
        END.
        FOR EACH cissac.Almdmov OF cissac.Almcmov:
            DELETE cissac.Almdmov.
        END.
        ASSIGN
            cissac.Almcmov.flgest = "A".
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extorno-conti-cissac-salida-conti W-Win 
PROCEDURE extorno-conti-cissac-salida-conti :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

trloop:
DO TRANSACTION ON ERROR UNDO, RETURN ON STOP UNDO, RETURN ERROR:
    FOR EACH integral.Almacen NO-LOCK WHERE integral.Almacen.codcia = s-codcia:
        FOR EACH integral.Almcmov WHERE integral.Almcmov.codcia = s-codcia
            AND integral.Almcmov.codalm = integral.Almacen.codalm
            AND integral.Almcmov.nrorf3 = integral.Lg-Tabla.Codigo
            AND integral.Almcmov.coddoc = "DEVCOCI":
            FOR EACH integral.Almdmov OF integral.Almcmov:
                DELETE integral.Almdmov.
            END.
            ASSIGN
                 INTEGRAL.Almcmov.FlgEst = "A".
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extorno-conti-cissac-transfer-conti W-Win 
PROCEDURE extorno-conti-cissac-transfer-conti :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


trloop:
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FOR EACH integral.Almcmov WHERE integral.Almcmov.codcia = s-codcia
        AND integral.Almcmov.codalm = "21"
        AND integral.Almcmov.tipmov = "S"
        AND integral.Almcmov.codmov = 03
        AND integral.Almcmov.nrorf3 =  INTEGRAL.lg-tabla.Codigo
        AND integral.Almcmov.coddoc = "DEVCOCI":
        ASSIGN
            integral.Almcmov.flgest = "A".
        FOR EACH integral.Almdmov OF integral.Almcmov:
            DELETE integral.Almdmov.
        END.
    END.
    FOR EACH integral.Almcmov WHERE integral.Almcmov.codcia = s-codcia
        AND integral.Almcmov.almdes = "21"
        AND integral.Almcmov.tipmov = "I"
        AND integral.Almcmov.codmov = 03
        AND integral.Almcmov.nrorf3 =  INTEGRAL.lg-tabla.Codigo
        AND integral.Almcmov.coddoc = "DEVCOCI":
        ASSIGN
            integral.Almcmov.flgest = "A".
        FOR EACH integral.Almdmov OF integral.Almcmov:
            DELETE integral.Almdmov.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorno-conti-cissac-venta-cissac-conti W-Win 
PROCEDURE Extorno-conti-cissac-venta-cissac-conti :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER CCOT FOR cissac.faccpedi.
DEF BUFFER CPED FOR cissac.faccpedi.
DEF BUFFER CORD FOR cissac.faccpedi.
DEF BUFFER CGUI FOR cissac.ccbcdocu.
DEF BUFFER CFAC FOR cissac.ccbcdocu.

FIND cissac.Almacen WHERE cissac.Almacen.codcia = s-codcia
    AND cissac.Almacen.codalm = "21"
    NO-LOCK NO-ERROR.
ASSIGN
    s-codalm = cissac.Almacen.codalm
    s-coddiv = cissac.Almacen.coddiv.

trloop:
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    /* EXTORNAMOS LAS ORDENES DE COMPRA */
    FOR EACH integral.Lg-cocmp WHERE integral.Lg-cocmp.codcia = s-codcia
        AND integral.Lg-cocmp.coddiv = "00000"
        AND integral.Lg-cocmp.tpodoc = "N"
        AND integral.Lg-cocmp.libre_c01 = INTEGRAL.lg-tabla.Codigo
        AND integral.LG-COCmp.Libre_c02 = "DEVCOCI".
        ASSIGN
            integral.Lg-cocmp.flgsit = "A".
    END.
    /* BARREMOS LAS COTIZACIONES */
    FOR EACH CCOT WHERE CCOT.codcia = s-codcia
        AND CCOT.coddiv = s-coddiv
        AND CCOT.coddoc = "COT"
        AND CCOT.libre_c01 = INTEGRAL.lg-tabla.Codigo
        AND CCOT.libre_c02 = "DEVCOCI":
        /* BARREMOS LOS PEDIDOS */
        FOR EACH CPED WHERE CPED.codcia = s-codcia
            AND CPED.coddiv = s-coddiv
            AND CPED.coddoc = "PED"
            AND CPED.codref = CCOT.coddoc
            AND CPED.nroref = CCOT.nroped:
            /* BARREMOS LAS ORDENES DE DESPACHO */
            FOR EACH CORD WHERE CORD.codcia = s-codcia
                AND CORD.coddiv = s-coddiv
                AND CORD.coddoc = "O/D"
                AND CORD.codref = CPED.coddoc
                AND CORD.nroref = CPED.nroped:
                /* BARREMOS LAS GUIAS DE REMISION */
                FOR EACH CGUI WHERE CGUI.codcia = s-codcia
                    AND CGUI.coddiv = s-coddiv
                    AND CGUI.coddoc = "G/R"
                    AND CGUI.codped = CORD.coddoc
                    AND CGUI.nroped = CORD.nroped:
                    /* BARREMOS LAS FACTURAS */
                    FOR EACH CFAC WHERE CFAC.codcia = s-codcia
                        AND CFAC.coddiv = s-coddiv
                        AND CFAC.coddoc = "FAC"
                        AND CFAC.codref = CGUI.coddoc
                        AND CFAC.nroref = CGUI.nrodoc:
                        /* ANULAMOS FACTURAS */
                        ASSIGN 
                            CFAC.FlgEst = "A"
                            CFAC.SdoAct = 0
                            CFAC.UsuAnu = S-USER-ID
                            CFAC.FchAnu = TODAY
                            CFAC.Glosa  = "A N U L A D O".
                    END.
                    /* ACTUALIZAMOS ALMACEN */
                    RUN des_alm ( ROWID (CGUI) ) NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN UNDO trloop, RETURN ERROR.

                    /* ANULAMOS INGRESO POR ORDEN DE COMPRA EN CONTINENTAL */
                    RUN Anula-Ingreso-por-Compra ( CGUI.NroDoc ) NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN UNDO trloop, RETURN ERROR.

                    /* ANULAMOS GUIA */
                    ASSIGN 
                        CGUI.FlgEst = "A"
                        CGUI.SdoAct = 0
                        CGUI.Glosa  = "** A N U L A D O **"
                        CGUI.FchAnu = TODAY
                        CGUI.Usuanu = s-User-Id.
                END.
                /* ANULAMOS ORDENES DE DESPACHO */
                ASSIGN 
                    CORD.FlgEst = "A"
                    CORD.Glosa = " A N U L A D O".
            END.
            /* ANULAMOS PEDIDOS */
            ASSIGN 
                CPED.FlgEst = "A"
                CPED.Glosa = " A N U L A D O".
        END.
        /* ANULAMOS COTIZACIONES */
        ASSIGN 
            CCOT.FlgEst = "A"
            CCOT.Glosa = " A N U L A D O".
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "INTEGRAL.lg-tabla"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

