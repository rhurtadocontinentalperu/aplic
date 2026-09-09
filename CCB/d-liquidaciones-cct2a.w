&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
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
DEFINE INPUT PARAMETER pCodClie AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE VAR s-task-no AS INT.

DEF VAR RB-REPORT-LIBRARY AS CHAR.  /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.     /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR. /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.  /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     /* Otros parametros */

DEFINE TEMP-TABLE ttFiler
    FIELD   tcoddoc     AS  CHAR
    FIELD   tnrodoc     AS  CHAR.

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
&Scoped-Define ENABLED-OBJECTS txtDesde txtHasta Btn_OK TOGGLE-ic ~
Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS txtDesde txtHasta TOGGLE-ic 

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

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE TOGGLE-ic AS LOGICAL INITIAL yes 
     LABEL "Considerar I/C" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     txtDesde AT ROW 1.38 COL 11 COLON-ALIGNED WIDGET-ID 2
     txtHasta AT ROW 1.38 COL 32 COLON-ALIGNED WIDGET-ID 4
     Btn_OK AT ROW 1.38 COL 51
     TOGGLE-ic AT ROW 2.73 COL 13 WIDGET-ID 64
     Btn_Cancel AT ROW 2.73 COL 51
     Btn_Help AT ROW 4.08 COL 51
     "......" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 3.88 COL 30 WIDGET-ID 6
     SPACE(32.71) SKIP(1.37)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Liquidaciones"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
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
   NOT-VISIBLE FRAME-NAME                                               */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Liquidaciones */
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
  ASSIGN txtDesde txtHasta toggle-ic.

  IF txtDesde > txtHasta THEN DO:
      MESSAGE "Rango de Fechas ERRADOS".
      RETURN NO-APPLY.
  END.

  RUN cargar-info.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-aplicaciones D-Dialog 
PROCEDURE cargar-aplicaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pDescripcion AS CHAR.

DEFINE VAR x-sw AS LOG.


/* Las cabceras */
FOR EACH ccbdmov WHERE ccbdmov.codcia = s-codcia AND
                            ccbdmov.coddoc = pCodDoc AND 
                            (ccbdmov.fchdoc >= txtDesde AND ccbdmov.fchdoc <= txtHasta) AND
                            ccbdmov.codcli = pCodclie  NO-LOCK:

    IF pCodDoc = 'A/R' OR pCodDoc = 'LPA' THEN DO:
        /* Solo las aplicaciones que sean x canje de letra adelantadas */
        FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                    ccbcdocu.coddoc = pCodDOc AND
                                    ccbcdocu.nrodoc = ccbdmov.nrodoc
                                    NO-LOCK NO-ERROR.
        IF (NOT AVAILABLE ccbcdocu) OR ccbcdocu.codref <> 'CLA' THEN NEXT.
    END.

    /* Documentos que involucran */
    FOR EACH ccbdcaja WHERE ccbdcaja.codcia = ccbdmov.codcia AND 
                                ccbdcaja.coddoc = ccbdmov.codref AND 
                                ccbdcaja.nrodoc = ccbdmov.nroref NO-LOCK:

        FIND FIRST ccbccaja OF ccbdcaja NO-LOCK NO-ERROR.
        IF ccbccaja.flgest <> 'A' THEN DO:
            CREATE w-report.
            ASSIGN
                w-report.task-no = s-task-no 
                w-report.llave-c = pDescripcion     /*"ANTICIPOS RECIBIDOS"*/
                w-report.campo-c[1] = ccbdmov.coddoc + " - " + ccbdmov.nrodoc
                w-report.campo-d[1] = ccbdmov.fchdoc 
                w-report.campo-c[2] = IF(ccbdmov.codmon = 1) THEN "SOLES" ELSE "DOLARES"
                w-report.campo-f[1] = ccbdmov.imptot.
                /**/
                ASSIGN w-report.campo-c[3] = ccbdcaja.codref + " - " + ccbdcaja.nroref
                w-report.campo-d[2] = ccbdcaja.fchdoc 
                w-report.campo-c[4] = IF(ccbdcaja.codmon = 1) THEN "SOLES" ELSE "DOLARES"
                w-report.campo-f[2] = ccbdcaja.imptot
                w-report.campo-c[30] = "1.- DOCUMENTOS APLICADOS"
                w-report.campo-f[3] = 0
                w-report.campo-c[6] = "".
                FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                            ccbcdocu.coddoc = ccbdcaja.codref AND
                                            ccbcdocu.nrodoc = ccbdcaja.nroref NO-LOCK NO-ERROR.
                IF AVAILABLE ccbcdocu THEN DO:
                    ASSIGN w-report.campo-f[3] = ccbcdocu.imptot
                            w-report.campo-d[2] = ccbcdocu.fchdoc
                            w-report.campo-c[6] = ccbcdocu.codref + "-" + ccbcdocu.nroref.
                    /*w-report.campo-c[6] = ccbcdocu.codref + " " + SUBSTRING(ccbcdocu.nroref,1,3) + "-" + SUBSTRING(ccbcdocu.nroref,4) NO-ERROR.*/
                END.

        END.
    END.
    
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-canjes D-Dialog 
PROCEDURE cargar-canjes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.

DEFINE VAR x-sw AS LOG.
DEFINE VAR x-titulo AS CHAR.

/* Las cabceras */
FOR EACH ccbcmvto WHERE ccbcmvto.codcia = s-codcia AND
                            ccbcmvto.coddoc = pCodDoc AND 
                            (ccbcmvto.fchdoc >= txtDesde AND ccbcmvto.fchdoc <= txtHasta) AND
                            ccbcmvto.codcli = pCodclie AND ccbcmvto.flgest = 'E' NO-LOCK:

    FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
                            gn-clie.codcli = ccbcmvto.codcli NO-LOCK NO-ERROR.
    /* Documentos que involucran */
    FOR EACH ccbdcaja WHERE ccbdcaja.codcia = ccbcmvto.codcia AND 
                                ccbdcaja.coddoc = ccbcmvto.coddoc AND 
                                ccbdcaja.nrodoc = ccbcmvto.nrodoc NO-LOCK:
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no 
            w-report.llave-c = "A.- CANJES DE DOCUMENTOS"
            w-report.campo-c[1] = ccbcmvto.coddoc + " - " + ccbcmvto.nrodoc
            w-report.campo-d[1] = ccbcmvto.fchdoc 
            w-report.campo-c[2] = IF(ccbcmvto.codmon = 1) THEN "SOLES" ELSE "DOLARES"
            w-report.campo-f[1] = ccbcmvto.imptot.
            /**/
            ASSIGN w-report.campo-c[3] = ccbdcaja.codref + " - " + ccbdcaja.nroref
            w-report.campo-d[2] = ccbdcaja.fchdoc 
            w-report.campo-c[4] = IF(ccbdcaja.codmon = 1) THEN "SOLES" ELSE "DOLARES"
            w-report.campo-f[2] = ccbdcaja.imptot
            w-report.campo-c[30] = "1.- DOCUMENTOS CANJEADOS"
            w-report.campo-f[3] = ccbdcaja.imptot
            w-report.campo-c[6] = "".
            /* */
            FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                        ccbcdocu.coddoc = ccbdcaja.codref AND
                                        ccbcdocu.nrodoc = ccbdcaja.nroref NO-LOCK NO-ERROR.
            IF AVAILABLE ccbcdocu THEN DO:
                ASSIGN w-report.campo-f[3] = ccbcdocu.imptot
                    w-report.campo-d[2] = ccbcdocu.fchdoc
                    w-report.campo-c[6] = ccbcdocu.codref + "-" + ccbcdocu.nroref.
                    /*SUBSTRING(ccbcdocu.nroref,1,3) + "-" + SUBSTRING(ccbcdocu.nroref,4) NO-ERROR.*/
            END.
    END.
    /* Documentos generados */
    x-sw = NO.
    FOR EACH ccbcdocu WHERE ccbcdocu.codcia = ccbcmvto.codcia AND
                                ccbcdocu.codref = ccbcmvto.coddoc AND
                                ccbcdocu.nroref = ccbcmvto.nrodoc NO-LOCK:

        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no 
            w-report.llave-c = "A.- CANJES DE DOCUMENTOS"
            w-report.campo-c[1] = ccbcmvto.coddoc + " - " + ccbcmvto.nrodoc
            w-report.campo-d[1] = ccbcmvto.fchdoc 
            w-report.campo-c[2] = IF(ccbcmvto.codmon = 1) THEN "SOLES" ELSE "DOLARES"
            w-report.campo-f[1] = ccbcmvto.imptot.
            /**/
            ASSIGN w-report.campo-c[3] = ccbcdocu.coddoc + " - " + ccbcdocu.nrodoc
            w-report.campo-d[2] = ccbcdocu.fchdoc 
            w-report.campo-c[4] = IF(ccbcdocu.codmon = 1) THEN "SOLES" ELSE "DOLARES"
            w-report.campo-f[2] = ccbcdocu.imptot
            w-report.campo-c[30] = "2.- LETRAS GENERADAS".

    END.
    
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-info D-Dialog 
PROCEDURE cargar-info :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
SESSION:SET-WAIT-STATE('GENERAL').

/* creo el temporal */ 
REPEAT:
    s-task-no = RANDOM(1, 999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no
                    /*AND w-report.llave-c = s-user-id*/ NO-LOCK)
        THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no
            w-report.llave-c = "".
        LEAVE.
    END.
END.

/* -- */
RUN cargar-canjes(INPUT "CJE").
RUN cargar-letras-adelantadas(INPUT "CLA").
RUN cargar-aplicaciones(INPUT "BD",INPUT "B.- ABONOS REALIZADOS (BD)").
RUN cargar-aplicaciones(INPUT "A/R", INPUT "C.- ANTICIPOS (A/R)").
RUN cargar-aplicaciones(INPUT "LPA", INPUT "D.- LETRA PRE-ACEPTADA (LPA)").
RUN cargar-nc-aplicaciones(INPUT "N/C", INPUT "E.- NOTAS DE CREDITOS").

IF toggle-ic = YES THEN DO:
    RUN cargar_ic_caja(INPUT "I/C", INPUT "E.- PAGOS EN CAJA").
END.

SESSION:SET-WAIT-STATE('').

FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
                        gn-clie.codcli = pCodClie NO-LOCK NO-ERROR.

/* Code placed here will execute AFTER standard behavior.    */
GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
ASSIGN
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'ccb/rbccb.prl'
RB-REPORT-NAME = 'liquidaciones-cajacobranzas'       
RB-INCLUDE-RECORDS = 'O'.

RB-FILTER = " w-report.task-no = " + STRING(s-task-no) + " and w-report.llave-c <> ''".

RB-OTHER-PARAMETERS = "s-codcli = " + pCodclie +                        
                        "~ns-desde = " + STRING(txtDesde,"99/99/9999") + 
                        "~ns-hasta = " + STRING(txtHasta,"99/99/9999") + 
                        "~ns-nomcli = " + IF(AVAILABLE gn-clie) THEN gn-clie.nomcli ELSE "" +                         
                        "~ns-tmp = ' ' ".

/*"~ns-ruc = " + IF(AVAILABLE gn-clie) THEN gn-clie.ruc ELSE "" +*/

RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                    RB-REPORT-NAME,
                    RB-INCLUDE-RECORDS,
                    RB-FILTER,
                    RB-OTHER-PARAMETERS).


/* Borar el temporal */
SESSION:SET-WAIT-STATE('GENERAL').
DEF BUFFER B-w-report FOR w-report.
DEFINE VAR lRowId AS ROWID.

FOR EACH w-report WHERE w-report.task-no = s-task-no NO-LOCK:
    lRowId = ROWID(w-report).
    FIND FIRST b-w-report WHERE ROWID(b-w-report) = lRowid EXCLUSIVE NO-ERROR.
    IF AVAILABLE b-w-report THEN DO:
        DELETE b-w-report.            
    END.    
END.
RELEASE B-w-report.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-letras-adelantadas D-Dialog 
PROCEDURE cargar-letras-adelantadas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.

DEFINE VAR x-sw AS LOG.
DEFINE VAR x-titulo AS CHAR.

/* Las cabceras */
FOR EACH ccbcmvto WHERE ccbcmvto.codcia = s-codcia AND
                            ccbcmvto.coddoc = pCodDoc AND 
                            (ccbcmvto.fchdoc >= txtDesde AND ccbcmvto.fchdoc <= txtHasta) AND
                            ccbcmvto.codcli = pCodclie AND ccbcmvto.flgest = 'E' NO-LOCK:

    FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
                            gn-clie.codcli = ccbcmvto.codcli NO-LOCK NO-ERROR.
    /* Documentos que involucran */
    FOR EACH ccbdcaja WHERE ccbdcaja.codcia = ccbcmvto.codcia AND 
                                ccbdcaja.coddoc = ccbcmvto.coddoc AND 
                                ccbdcaja.nrodoc = ccbcmvto.nrodoc NO-LOCK:
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no 
            w-report.llave-c = "A.- LETRAS ADELANTADAS"
            w-report.campo-c[1] = ccbcmvto.coddoc + " - " + ccbcmvto.nrodoc
            w-report.campo-d[1] = ccbcmvto.fchdoc 
            w-report.campo-c[2] = IF(ccbcmvto.codmon = 1) THEN "SOLES" ELSE "DOLARES"
            w-report.campo-f[1] = ccbcmvto.imptot.
            /**/
            ASSIGN w-report.campo-c[3] = ccbdcaja.codref + " - " + ccbdcaja.nroref
            w-report.campo-d[2] = ccbdcaja.fchdoc 
            w-report.campo-c[4] = IF(ccbdcaja.codmon = 1) THEN "SOLES" ELSE "DOLARES"
            w-report.campo-f[2] = ccbdcaja.imptot
            w-report.campo-c[30] = "1.- DOCUMENTOS CANJEADOS"
            w-report.campo-f[3] = ccbdcaja.imptot
            w-report.campo-c[6] = "".
            /* */
            FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                        ccbcdocu.coddoc = ccbdcaja.codref AND
                                        ccbcdocu.nrodoc = ccbdcaja.nroref NO-LOCK NO-ERROR.
            IF AVAILABLE ccbcdocu THEN DO:
                ASSIGN w-report.campo-f[3] = ccbcdocu.imptot
                    w-report.campo-d[2] = ccbcdocu.fchdoc
                    w-report.campo-c[6] = ccbcdocu.codref + "-" + ccbcdocu.nroref.
                    /*SUBSTRING(ccbcdocu.nroref,1,3) + "-" + SUBSTRING(ccbcdocu.nroref,4) NO-ERROR.*/
            END.
    END.
    /* Documentos generados que esten pendientes*/
    x-sw = NO.
    FOR EACH ccbcdocu WHERE ccbcdocu.codcia = ccbcmvto.codcia AND
                                ccbcdocu.codref = ccbcmvto.coddoc AND
                                ccbcdocu.nroref = ccbcmvto.nrodoc AND
                                ccbcdocu.flgest <> 'A' NO-LOCK:

        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no 
            w-report.llave-c = "A.- LETRAS ADELANTADAS"
            w-report.campo-c[1] = ccbcmvto.coddoc + " - " + ccbcmvto.nrodoc
            w-report.campo-d[1] = ccbcmvto.fchdoc 
            w-report.campo-c[2] = IF(ccbcmvto.codmon = 1) THEN "SOLES" ELSE "DOLARES"
            w-report.campo-f[1] = ccbcmvto.imptot.
            /**/
            ASSIGN w-report.campo-c[3] = ccbcdocu.coddoc + " - " + ccbcdocu.nrodoc
            w-report.campo-d[2] = ccbcdocu.fchdoc 
            w-report.campo-c[4] = IF(ccbcdocu.codmon = 1) THEN "SOLES" ELSE "DOLARES"
            w-report.campo-f[2] = ccbcdocu.imptot
            w-report.campo-c[30] = "2.- LETRAS GENERADAS".

    END.
    
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-nc-aplicaciones D-Dialog 
PROCEDURE cargar-nc-aplicaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pDescripcion AS CHAR.

DEFINE VAR x-sw AS LOG.
DEFINE VAR x-tot AS DEC.

EMPTY TEMP-TABLE ttFiler.

DEFINE BUFFER x-ccbdmov FOR ccbdmov.

/* Las cabeceras */
FOR EACH ccbdmov WHERE ccbdmov.codcia = s-codcia AND
                            ccbdmov.coddoc = pCodDoc AND 
                            (ccbdmov.fchdoc >= txtDesde AND ccbdmov.fchdoc <= txtHasta) AND
                            ccbdmov.codcli = pCodclie  NO-LOCK:

    /* Se comienza a trabajar con el I/C */

    /* Si ya esta trabajado el I/C no continuar */
    FIND FIRST ttFiler WHERE ttFiler.tCoddoc = ccbdmov.codref AND
                                ttFiler.tnrodoc = ccbdmov.nroref NO-LOCK NO-ERROR.
    IF AVAILABLE ttFiler THEN NEXT.

    /* Que la I/C no este anulada */
    FIND FIRST ccbccaja WHERE ccbccaja.codcia = s-codcia AND
                                ccbccaja.coddoc = ccbdmov.codref AND
                                ccbccaja.nrodoc = ccbdmov.nroref NO-LOCK NO-ERROR.
    /* Cargo el I/C en el temporal */
    CREATE ttFiler.
        ASSIGN ttFiler.tcoddoc = ccbdmov.codref
                ttFiler.tnrodoc = ccbdmov.nroref.
    /* Que el I/C no este anulado */
    IF ccbccaja.flgest = 'A' THEN NEXT.

    x-tot = 0.
    FOR EACH x-ccbdmov WHERE x-ccbdmov.codcia = s-codcia AND 
                            x-ccbdmov.codref = ccbdmov.codref AND
                            x-ccbdmov.nroref = ccbdmov.nroref NO-LOCK:
        x-tot = x-tot + x-ccbdmov.imptot.
    END.

    /* Cargos del I/C */
    FOR EACH x-ccbdmov WHERE x-ccbdmov.codcia = s-codcia AND 
                                x-ccbdmov.codref = ccbdmov.codref AND
                                x-ccbdmov.nroref = ccbdmov.nroref NO-LOCK:

        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no 
            w-report.llave-c = pDescripcion 
            w-report.campo-c[1] = x-ccbdmov.codref + " - " + x-ccbdmov.nroref
            w-report.campo-d[1] = ccbccaja.fchdoc 
            w-report.campo-c[2] = "" /*IF(ccbccaja.codmon = 1) THEN "SOLES" ELSE "DOLARES"*/
            w-report.campo-f[1] = x-tot.
            /**/
            ASSIGN w-report.campo-c[3] = x-ccbdmov.coddoc + " - " + x-ccbdmov.nrodoc
            w-report.campo-d[2] = x-ccbdmov.fchdoc 
            w-report.campo-c[4] = IF(x-ccbdmov.codmon = 1) THEN "SOLES" ELSE "DOLARES"
            w-report.campo-f[2] = x-ccbdmov.imptot
            w-report.campo-c[30] = "1.- NOTAS DE CREDITO"
             w-report.campo-f[3] = 0
            w-report.campo-c[5] = ""
            w-report.campo-c[6] = ""   .
             /* */
             FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                         ccbcdocu.coddoc = x-ccbdmov.coddoc AND
                                         ccbcdocu.nrodoc = x-ccbdmov.nrodoc NO-LOCK NO-ERROR.
             IF AVAILABLE ccbcdocu THEN DO:
                 ASSIGN w-report.campo-f[3] = ccbcdocu.imptot
                        w-report.campo-d[2] = ccbcdocu.fchdoc
                        w-report.campo-c[6] = ccbcdocu.codref + "-" + ccbcdocu.nroref.
                 /*w-report.campo-c[6] = ccbcdocu.codref + " " + SUBSTRING(ccbcdocu.nroref,1,3) + "-" + SUBSTRING(ccbcdocu.nroref,4) NO-ERROR.*/
                 /**/
                 FIND FIRST ccbtabla WHERE ccbtabla.codcia = s-codcia AND 
                                             ccbtabla.tabla = 'N/C' AND 
                                             ccbtabla.codigo = ccbcdocu.codcta
                                             NO-LOCK NO-ERROR.
                 IF AVAILABLE ccbtabla THEN DO:
                     w-report.campo-c[5] = ccbtabla.nombre.
                 END.

             END.
             /**/

    END.

    /* Documentos que se aplicaron */
    FOR EACH ccbdcaja WHERE ccbdcaja.codcia = ccbdmov.codcia AND 
                                ccbdcaja.coddoc = ccbdmov.codref AND 
                                ccbdcaja.nrodoc = ccbdmov.nroref NO-LOCK:

        FIND FIRST ccbccaja OF ccbdcaja NO-LOCK NO-ERROR.
        IF AVAILABLE ccbccaja AND ccbccaja.flgest <> 'A' THEN DO:
            CREATE w-report.
            ASSIGN
                w-report.task-no = s-task-no 
                w-report.llave-c = pDescripcion 
                w-report.campo-c[1] = ccbdmov.codref + " - " + ccbdmov.nroref
                w-report.campo-d[1] = ccbccaja.fchdoc 
                w-report.campo-c[2] = IF(ccbccaja.codmon = 1) THEN "SOLES" ELSE "DOLARES"
                w-report.campo-f[1] = x-tot.
                /**/
                ASSIGN w-report.campo-c[3] = ccbdcaja.codref + " - " + ccbdcaja.nroref
                w-report.campo-d[2] = ccbdcaja.fchdoc 
                w-report.campo-c[4] = IF(ccbdcaja.codmon = 1) THEN "SOLES" ELSE "DOLARES"
                w-report.campo-f[2] = ccbdcaja.imptot
                w-report.campo-c[30] = "2.- DOCUMENTOS APLICADOS"
                w-report.campo-f[3] = 0
                w-report.campo-c[6] = "".
                /* */
                FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                            ccbcdocu.coddoc = ccbdcaja.codref AND
                                            ccbcdocu.nrodoc = ccbdcaja.nroref NO-LOCK NO-ERROR.
                IF AVAILABLE ccbcdocu THEN DO:
                    ASSIGN w-report.campo-f[3] = ccbcdocu.imptot
                            w-report.campo-d[2] = ccbcdocu.fchdoc
                            w-report.campo-c[6] = ccbcdocu.codref + "-" + ccbcdocu.nroref.
                    /*w-report.campo-c[6] = ccbcdocu.codref + " " + SUBSTRING(ccbcdocu.nroref,1,3) + "-" + SUBSTRING(ccbcdocu.nroref,4) NO-ERROR.*/
                END.

        END.
    END.
    
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar_ic_caja D-Dialog 
PROCEDURE cargar_ic_caja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pDescripcion AS CHAR.

DEFINE VAR x-sw AS LOG.
DEFINE VAR x-tot AS DEC.

DEFINE BUFFER x-ccbdmov FOR ccbdmov.

/* Las cabeceras */
FOR EACH ccbccaja WHERE ccbccaja.codcia = s-codcia AND
                            ccbccaja.coddoc = pCodDoc AND 
                            (ccbccaja.fchdoc >= txtDesde AND ccbccaja.fchdoc <= txtHasta) AND
                            ccbccaja.codcli = pCodclie  AND 
                            ccbccaja.flgest <> 'A' NO-LOCK:

    /* Se comienza a trabajar con el I/C */

    /* Si ya esta trabajado el I/C no continuar */
    FIND FIRST ttFiler WHERE ttFiler.tCoddoc = ccbccaja.coddoc AND
                                ttFiler.tnrodoc = ccbccaja.nrodoc NO-LOCK NO-ERROR.
    IF AVAILABLE ttFiler THEN NEXT.

    /* Cargo el I/C en el temporal */
    CREATE ttFiler.
        ASSIGN ttFiler.tcoddoc = ccbccaja.coddoc
                ttFiler.tnrodoc = ccbccaja.nrodoc.
    
    IF LOOKUP(ccbccaja.tipo,"CANCELACION,MOSTRADOR") = 0 THEN NEXT.

    x-tot = 0.
    FOR EACH ccbdcaja WHERE ccbdcaja.codcia = ccbccaja.codcia AND 
                                ccbdcaja.coddoc = ccbccaja.coddoc AND 
                                ccbdcaja.nrodoc = ccbccaja.nrodoc NO-LOCK:
            x-tot = x-tot + ccbdcaja.imptot.
        
    END.

    /* Documentos que se aplicaron */
    FOR EACH ccbdcaja WHERE ccbdcaja.codcia = ccbccaja.codcia AND 
                                ccbdcaja.coddoc = ccbccaja.coddoc AND 
                                ccbdcaja.nrodoc = ccbccaja.nrodoc NO-LOCK:

        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no 
            w-report.llave-c = pDescripcion 
            w-report.campo-c[1] = ccbccaja.coddoc + " - " + ccbccaja.nrodoc
            w-report.campo-d[1] = ccbccaja.fchdoc 
            w-report.campo-c[2] = IF(ccbccaja.codmon = 1) THEN "SOLES" ELSE "DOLARES"
            w-report.campo-f[1] = x-tot.
            /**/
            ASSIGN w-report.campo-c[3] = ccbdcaja.codref + " - " + ccbdcaja.nroref
            w-report.campo-d[2] = ccbdcaja.fchdoc 
            w-report.campo-c[4] = IF(ccbdcaja.codmon = 1) THEN "SOLES" ELSE "DOLARES"
            w-report.campo-f[2] = ccbdcaja.imptot
            w-report.campo-c[30] = "1.- DOCUMENTOS CANCELADOS"
            w-report.campo-f[3] = ccbdcaja.imptot
            w-report.campo-c[6] = "".
            /* */
            FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                        ccbcdocu.coddoc = ccbdcaja.codref AND
                                        ccbcdocu.nrodoc = ccbdcaja.nroref NO-LOCK NO-ERROR.
            IF AVAILABLE ccbcdocu THEN DO:
                ASSIGN w-report.campo-f[3] = ccbcdocu.imptot
                    w-report.campo-c[6] = ccbcdocu.codref + "-" + ccbcdocu.nroref
                    w-report.campo-d[2] = ccbcdocu.fchdoc.
                    /*SUBSTRING(ccbcdocu.nroref,1,3) + "-" + SUBSTRING(ccbcdocu.nroref,4) NO-ERROR.*/
            END.
    END.    
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
  DISPLAY txtDesde txtHasta TOGGLE-ic 
      WITH FRAME D-Dialog.
  ENABLE txtDesde txtHasta Btn_OK TOGGLE-ic Btn_Cancel Btn_Help 
      WITH FRAME D-Dialog.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 120,"99/99/9999").
  txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").


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

