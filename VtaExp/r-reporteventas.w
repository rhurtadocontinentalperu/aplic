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

DEF SHARED VAR s-codcia     AS INT.
DEF SHARED VAR cl-codcia    AS INT.
DEF SHARED VAR s-nomcia     AS CHAR.

DEFINE VARIABLE s-task-no   AS INTEGER     NO-UNDO.
DEFINE VARIABLE s-task-no02 AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-clientes
    FIELDS codcli LIKE gn-clie.codcli.

DEFINE TEMP-TABLE tt-resumen
    FIELDS codsecu      AS CHAR
    FIELDS nomfila      AS CHAR
    FIELDS nomfila02    AS CHAR
    FIELDS codfila      AS CHAR
    FIELDS codcli       LIKE gn-clie.codcli
    FIELDS nomcli       LIKE gn-clie.nomcli
    FIELDS ddesde       AS DATE
    FIELDS dhasta       AS DATE
    FIELDS codcolu01    AS DEC EXTENT 15 
    FIELDS codcolu02    AS DEC EXTENT 15.

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
&Scoped-Define ENABLED-OBJECTS txt-codcli FILL-IN-file BUTTON-5 txt-desde ~
txt-hasta tg-resumen BUTTON-1 BUTTON-4 
&Scoped-Define DISPLAYED-OBJECTS txt-codcli txt-nomcli FILL-IN-file ~
txt-desde txt-hasta tg-resumen txt-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/print.ico":U
     LABEL "Button 1" 
     SIZE 8 BY 1.88.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 8 BY 1.88.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 4" 
     SIZE 8 BY 1.88.

DEFINE BUTTON BUTTON-5 
     LABEL "..." 
     SIZE 5 BY 1.

DEFINE VARIABLE FILL-IN-file AS CHARACTER FORMAT "X(256)":U 
     LABEL "Clientes Varios" 
     VIEW-AS FILL-IN 
     SIZE 59.29 BY 1 NO-UNDO.

DEFINE VARIABLE txt-codcli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-desde AS DATE FORMAT "99/99/9999":U INITIAL 12/01/10 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-hasta AS DATE FORMAT "99/99/9999":U INITIAL 03/31/11 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 71 BY 1 NO-UNDO.

DEFINE VARIABLE txt-nomcli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Razon Social" 
     VIEW-AS FILL-IN 
     SIZE 57 BY 1
     BGCOLOR 7 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE tg-resumen AS LOGICAL INITIAL no 
     LABEL "Resumen" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-codcli AT ROW 1.27 COL 14.14 COLON-ALIGNED WIDGET-ID 4
     txt-nomcli AT ROW 2.35 COL 14 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-file AT ROW 3.42 COL 14.14 COLON-ALIGNED WIDGET-ID 68
     BUTTON-5 AT ROW 3.42 COL 76 WIDGET-ID 66
     txt-desde AT ROW 4.5 COL 14 COLON-ALIGNED WIDGET-ID 70
     txt-hasta AT ROW 4.5 COL 37 COLON-ALIGNED WIDGET-ID 72
     tg-resumen AT ROW 5.85 COL 11 WIDGET-ID 14
     BUTTON-2 AT ROW 5.85 COL 51 WIDGET-ID 6
     BUTTON-1 AT ROW 5.85 COL 59 WIDGET-ID 2
     BUTTON-4 AT ROW 5.85 COL 67 WIDGET-ID 8
     txt-Mensaje AT ROW 8 COL 10 NO-LABEL WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81.43 BY 8.42 WIDGET-ID 100.


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
         TITLE              = "Resumen Ventas Campañas"
         HEIGHT             = 8.42
         WIDTH              = 81.43
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 83.72
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 83.72
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON BUTTON-2 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-2:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN txt-Mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN txt-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Resumen Ventas Campañas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Resumen Ventas Campañas */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    ASSIGN txt-codcli fill-in-file tg-resumen txt-desde txt-hasta.
    IF tg-resumen THEN RUN Imprimir_Resumen.
    ELSE RUN Imprimir.
    DISPLAY "" @ txt-Mensaje WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  
    ASSIGN txt-codcli txt-nomcli tg-resumen.
    IF tg-resumen THEN RUN Excel-Resumen.
    ELSE RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
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


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* ... */
DO:

    DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.

    SYSTEM-DIALOG GET-FILE FILL-IN-file
        FILTERS
            "Archivos Excel (*.csv)" "*.csv",
            "Archivos Texto (*.txt)" "*.txt",
            "Todos (*.*)" "*.*"
        TITLE
            "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.

    IF OKpressed = TRUE THEN
        FILL-IN-file:SCREEN-VALUE = FILL-IN-file.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-codcli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-codcli W-Win
ON LEAVE OF txt-codcli IN FRAME F-Main /* Cliente */
DO:
  
    ASSIGN txt-codcli.
    IF txt-codcli <> '' THEN DO:
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = txt-codcli NO-LOCK NO-ERROR.
        IF AVAIL gn-clie THEN 
            DISPLAY gn-clie.nomcli @ txt-nomcli WITH FRAME {&FRAME-NAME}.
        ELSE DO:
            MESSAGE "Cliente Inválido"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            APPLY 'entry' TO txt-codcli.
            RETURN "adm-error".
        END.
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Clientes W-Win 
PROCEDURE Carga-Clientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    EMPTY TEMP-TABLE tt-clientes.

    IF fill-in-file <> '' THEN DO:
        /* Carga de Excel */
        IF SEARCH(FILL-IN-file) <> ? THEN DO:
            OUTPUT TO VALUE(FILL-IN-file) APPEND.
            PUT UNFORMATTED "?" CHR(10) SKIP.
            OUTPUT CLOSE.
            INPUT FROM VALUE(FILL-IN-file).
            REPEAT:
                CREATE tt-clientes.
                IMPORT tt-clientes.

            END.
            INPUT CLOSE.
        END.
    END.
    ELSE DO:
        CREATE tt-clientes.
        ASSIGN tt-clientes.codcli = txt-codcli.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Datos W-Win 
PROCEDURE Carga-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cDesMat AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cDesMar AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cUndBas AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cCodSec AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cNomTab AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE fDesde  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE fHasta  AS INTEGER     NO-UNDO.

    fDesde = (YEAR(txt-desde) * 10000) + (MONTH(txt-desde) * 100) + DAY(txt-desde).
    fHasta = (YEAR(txt-Hasta) * 10000) + (MONTH(txt-Hasta) * 100) + DAY(txt-Hasta).

    REPEAT:
        s-task-no = RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no
                        NO-LOCK)
        THEN LEAVE.
    END.

    RUN Carga-Clientes.

    FOR EACH tt-clientes NO-LOCK:
        FOR EACH dwh_ventas_cab WHERE dwh_ventas_cab.CodCia = s-codcia
            AND dwh_ventas_cab.CodCli = tt-clientes.codcli
            AND dwh_ventas_cab.Fecha >= fDesde
            AND dwh_ventas_cab.Fecha <= fHasta NO-LOCK,
            EACH dwh_ventas_det OF dwh_ventas_cab NO-LOCK:
            FIND FIRST w-report WHERE w-report.task-no = s-task-no
                AND w-report.llave-c    = dwh_ventas_cab.CodCli
                AND w-report.Campo-C[1] = dwh_ventas_det.CodMat NO-ERROR.
            IF NOT AVAIL w-report THEN DO:
                /*Cliente*/
                FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
                    AND gn-clie.codcli = dwh_ventas_cab.CodCli NO-LOCK NO-ERROR.
                IF NOT AVAIL gn-clie THEN NEXT.

                /*Articulos*/
                FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
                    AND almmmatg.codmat = dwh_ventas_det.codmat NO-LOCK NO-ERROR.
                IF NOT AVAIL almmmatg THEN NEXT.

                /*IF STRING(SUBSTRING(almmmatg.libre_c05,5,2),'99') = '15' THEN NEXT.*/

                IF AVAIL almmmatg THEN DO:
                    ASSIGN
                        cDesMat = almmmatg.DesMat
                        cDesMar = almmmatg.DesMar
                        cUndBas = almmmatg.UndBas.
                    IF almmmatg.libre_c05 = '' THEN cCodSec = "99".
                    ELSE cCodSec = almmmatg.libre_c05.
                END.

                FIND FIRST almtabla WHERE almtabla.tabla = 'MR'
                    AND almtabla.Codigo = STRING(SUBSTRING(cCodSec,5,2),'99')  NO-LOCK NO-ERROR.
                IF AVAIL almtabla THEN cNomTab = almtabla.nombre.
                ELSE cNomTab = "Sin Grupo".

                CREATE w-report.
                ASSIGN 
                    w-report.task-no    = s-task-no
                    w-report.llave-c    = dwh_ventas_cab.CodCli
                    w-report.Campo-C[1] = dwh_ventas_det.CodMat
                    w-report.Campo-C[2] = gn-clie.nomcli
                    w-report.Campo-C[3] = cDesMat
                    w-report.Campo-C[4] = cDesMar
                    w-report.Campo-C[5] = cUndBas
                    w-report.Campo-C[6] = cCodSec
                    w-report.Campo-C[7] = cNomTab
                    w-report.Campo-C[8] = SUBSTRING(cCodSec,5,2) + '-' + cNomTab
                    w-report.Campo-D[1] = txt-desde
                    w-report.Campo-D[2] = txt-hasta.
            END.
            ASSIGN 
                w-report.Campo-F[1] = dwh_ventas_det.Cantidad + w-report.Campo-F[1]
                w-report.Campo-F[2] = dwh_ventas_det.ImpNacCIGV + w-report.Campo-F[2].

            DISPLAY " ****  Generando Datos  **** " @ txt-Mensaje WITH FRAME {&FRAME-NAME}.

        END.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Resumen W-Win 
PROCEDURE Carga-Resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iSec    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cNom    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cNom02  AS CHARACTER   NO-UNDO.

    RUN Carga-Datos.

    EMPTY TEMP-TABLE tt-resumen.

    FOR EACH w-report WHERE task-no = s-task-no NO-LOCK
        BREAK BY llave-c:
        iSec = INT(SUBSTRING(w-report.Campo-C[6],1,3)).
        IF iSec = 0 THEN MESSAGE iSec.

        FIND FIRST AlmTabla WHERE AlmTabla.Tabla = 'MR'
            AND AlmTabla.Codigo = STRING(SUBSTRING(w-report.Campo-C[6],5,2),'99') NO-LOCK NO-ERROR.
        IF AVAIL AlmTabla THEN cNom = Almtabla.Nombre. ELSE cNom = 'Sin Grupo'.

        FIND FIRST AlmTabla WHERE AlmTabla.Tabla = 'SR'
            AND AlmTabla.Codigo = STRING(SUBSTRING(w-report.Campo-C[6],8,2),'99') NO-LOCK NO-ERROR.
        IF AVAIL AlmTabla THEN cNom02 = Almtabla.Nombre. 
        ELSE cNom02 = ''.

        IF iSec <> 0 THEN DO:
            FIND FIRST tt-resumen WHERE tt-resumen.codcli = w-report.llave-c
                AND tt-resumen.codsecu = SUBSTRING(w-report.Campo-C[6],5)
                NO-ERROR.
            IF NOT AVAIL tt-resumen THEN DO:
                CREATE tt-resumen.
                ASSIGN 
                    codfila     = w-report.Campo-C[6] 
                    codsecu     = SUBSTRING(w-report.Campo-C[6],5)
                    codcli      = w-report.llave-c
                    nomcli      = w-report.Campo-C[2] 
                    dDesde      = w-report.Campo-D[1]
                    dHasta      = w-report.Campo-D[2]
                    nomfila     = cNom 
                    nomfila02   = cNom02 .
            END.

            /*Cantidades*/
            IF SUBSTRING(w-report.Campo-C[6],5,2) = '01' THEN 
                ASSIGN 
                    codcolu01[iSec] =  codcolu01[iSec] + w-report.Campo-F[1]
                    codcolu01[15] =  codcolu01[15] + w-report.Campo-F[1].

            /*Importes*/
            ASSIGN 
                codcolu02[iSec] =  codcolu02[iSec] + INT(w-report.Campo-F[2])
                codcolu02[15]   =  codcolu02[15] + INT(w-report.Campo-F[2]).
        END.
        DISPLAY " ****  Generando Resumen  **** " @ txt-Mensaje WITH FRAME {&FRAME-NAME}.
    END.

    REPEAT:
        s-task-no02 = RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no02
                        NO-LOCK)
        THEN LEAVE.
    END.

    DEFINE VARIABLE iNroItm AS INTEGER     NO-UNDO INIT 1.

    FOR EACH tt-resumen NO-LOCK
        BREAK BY tt-resumen.codsecu:
        FIND FIRST w-report WHERE w-report.task-no = s-task-no02
            AND w-report.llave-i = iNroItm NO-LOCK NO-ERROR.
        IF NOT AVAIL w-report THEN DO:

            CASE codsecu:
                WHEN '15' THEN DO:
                    CREATE w-report.
                    ASSIGN 
                        w-report.task-no        = s-task-no02
                        w-report.llave-i        = (iNroItm + 48000)
                        w-report.Campo-C[1]     = codsecu
                        w-report.Campo-C[2]     = nomfila
                        w-report.Campo-C[3]     = codfila
                        w-report.Campo-C[4]     = codcli
                        w-report.Campo-C[5]     = nomcli
                        w-report.Campo-C[6]     = "Otros"
                        w-report.Campo-C[7]     = nomfila02
                        w-report.Campo-F[1]     = codcolu02[1]  
                        w-report.Campo-F[2]     = codcolu02[2] 
                        w-report.Campo-F[3]     = codcolu02[3] 
                        w-report.Campo-F[4]     = codcolu02[4] 
                        w-report.Campo-F[5]     = codcolu02[5] 
                        w-report.Campo-F[6]     = codcolu02[6] 
                        w-report.Campo-F[7]     = codcolu02[7] 
                        w-report.Campo-F[8]     = codcolu02[8] 
                        w-report.Campo-F[9]     = codcolu02[9] 
                        w-report.Campo-F[10]    = codcolu02[10] 
                        w-report.Campo-F[11]    = codcolu02[11] 
                        w-report.Campo-F[12]    = codcolu02[12] 
                        w-report.Campo-F[15]    = codcolu02[15] 
                        w-report.Campo-D[1]     = dDesde      
                        w-report.Campo-D[2]     = dHasta
                        .

                END.
                OTHERWISE DO:
                    IF codcolu01[15] > 0 THEN DO:
                        CREATE w-report.
                        ASSIGN 
                            w-report.task-no        = s-task-no02
                            w-report.llave-i        = iNroItm
                            w-report.Campo-C[1]     = codsecu
                            w-report.Campo-C[2]     = nomfila
                            w-report.Campo-C[3]     = codfila
                            w-report.Campo-C[4]     = codcli
                            w-report.Campo-C[5]     = nomcli
                            w-report.Campo-C[6]     = "Cantidad"
                            w-report.Campo-C[7]     = nomfila02
                            w-report.Campo-F[1]     = codcolu01[1]  
                            w-report.Campo-F[2]     = codcolu01[2] 
                            w-report.Campo-F[3]     = codcolu01[3] 
                            w-report.Campo-F[4]     = codcolu01[4] 
                            w-report.Campo-F[5]     = codcolu01[5] 
                            w-report.Campo-F[6]     = codcolu01[6] 
                            w-report.Campo-F[7]     = codcolu01[7] 
                            w-report.Campo-F[8]     = codcolu01[8] 
                            w-report.Campo-F[9]     = codcolu01[9] 
                            w-report.Campo-F[10]    = codcolu01[10] 
                            w-report.Campo-F[11]    = codcolu01[11] 
                            w-report.Campo-F[12]    = codcolu01[12] 
                            w-report.Campo-F[15]    = codcolu01[15] 
                            w-report.Campo-D[1]     = dDesde      
                            w-report.Campo-D[2]     = dHasta
                            .
                    END.

                    CREATE w-report.
                    ASSIGN 
                        w-report.task-no        = s-task-no02
                        w-report.llave-i        = (iNroItm + 24000)
                        w-report.Campo-C[1]     = codsecu
                        w-report.Campo-C[2]     = nomfila
                        w-report.Campo-C[3]     = codfila
                        w-report.Campo-C[4]     = codcli
                        w-report.Campo-C[5]     = nomcli
                        w-report.Campo-C[6]     = "Importe Soles (S/.)"
                        w-report.Campo-C[7]     = nomfila02
                        w-report.Campo-F[1]     = codcolu02[1]  
                        w-report.Campo-F[2]     = codcolu02[2] 
                        w-report.Campo-F[3]     = codcolu02[3] 
                        w-report.Campo-F[4]     = codcolu02[4] 
                        w-report.Campo-F[5]     = codcolu02[5] 
                        w-report.Campo-F[6]     = codcolu02[6] 
                        w-report.Campo-F[7]     = codcolu02[7] 
                        w-report.Campo-F[8]     = codcolu02[8] 
                        w-report.Campo-F[9]     = codcolu02[9] 
                        w-report.Campo-F[10]    = codcolu02[10] 
                        w-report.Campo-F[11]    = codcolu02[11] 
                        w-report.Campo-F[12]    = codcolu02[12] 
                        w-report.Campo-F[15]    = codcolu02[15] 
                        w-report.Campo-D[1]     = dDesde      
                        w-report.Campo-D[2]     = dHasta
                        .
                END.
            END CASE.

            iNroItm = iNroItm + 1.
        END.                   
        DISPLAY " ****  Generando Tabla  **** " @ txt-Mensaje WITH FRAME {&FRAME-NAME}.
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
  DISPLAY txt-codcli txt-nomcli FILL-IN-file txt-desde txt-hasta tg-resumen 
          txt-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txt-codcli FILL-IN-file BUTTON-5 txt-desde txt-hasta tg-resumen 
         BUTTON-1 BUTTON-4 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 4.
DEFINE VARIABLE t-Letra                 AS INTEGER.
DEFINE VARIABLE iInt                    AS INTEGER     NO-UNDO.

DEFINE VARIABLE cLetra  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLetra2 AS CHARACTER NO-UNDO.
DEFINE VARIABLE t-col   AS INTEGER     NO-UNDO.

RUN Carga-Datos.

FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
IF NOT AVAILABLE w-report THEN DO:
    MESSAGE 'NO hay registros para imprimir' VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A1"):Value = "Continental SAC".
chWorkSheet:Range("C2"):Value = "COMPRAS CAMPAÑA 2012".
chWorkSheet:Range("C3"):Value = "(DEL 01/01/2010 AL 30/03/2011)".
/*chWorkSheet:Range("B5"):Value = "Cliente: " + txt-codcli + "-" + txt-nomcli.*/

chWorkSheet:Range("A6"):Value = "Cuadro ".
chWorkSheet:Range("B6"):Value = "Articulo".
chWorkSheet:Range("C6"):Value = "Marca".
chWorkSheet:Range("D6"):Value = "Unidad".
chWorkSheet:Range("E6"):Value = "Cantidad".
chWorkSheet:Range("F6"):Value = "Importe".

/* /*Formato*/                                  */
/* chWorkSheet:Columns("B"):NumberFormat = "@". */
/* chWorkSheet:Columns("D"):NumberFormat = "@". */

t-column = 6.

FOR EACH w-report WHERE w-report.task-no = s-task-no 
    AND w-report.llave-c = txt-codcli NO-LOCK
    BREAK BY w-report.llave-c
        BY SUBSTRING(w-report.campo-c[6],5,2)
        BY w-report.campo-c[1]:

    IF FIRST-OF(w-report.llave-c) THEN DO:
        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "Clientes: " + STRING(w-report.llave-c,"99999999999").
    END.

    IF FIRST-OF(SUBSTRING(w-report.campo-c[6],5,2)) THEN DO:
        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + SUBSTRING(w-report.campo-c[6],5,2).
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = STRING(w-report.campo-c[7],'x(40)').
    END.
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-c[1] + '-' + w-report.campo-c[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-c[4].
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-c[5].
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-f[1].
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-f[2].

    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[6].


    ACCUMULATE w-report.campo-f[1](TOTAL BY SUBSTRING(w-report.campo-c[6],5,2)).
    ACCUMULATE w-report.campo-f[2](TOTAL BY SUBSTRING(w-report.campo-c[6],5,2)).

    IF LAST-OF(SUBSTRING(w-report.campo-c[6],5,2)) THEN DO:
        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "Total " + SUBSTRING(w-report.campo-c[6],5,2).
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY SUBSTRING(w-report.campo-c[6],5,2) w-report.campo-f[1] .
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY SUBSTRING(w-report.campo-c[6],5,2) w-report.campo-f[2] .
    END.

    ACCUMULATE w-report.campo-f[1](TOTAL).
    ACCUMULATE w-report.campo-f[2](TOTAL).
END.

t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Total General".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = ACCUM TOTAL w-report.campo-f[1] .
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = ACCUM TOTAL w-report.campo-f[2] .


/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-Resumen W-Win 
PROCEDURE Excel-Resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 4.
DEFINE VARIABLE t-Letra                 AS INTEGER.
DEFINE VARIABLE iInt                    AS INTEGER     NO-UNDO.

DEFINE VARIABLE cLetra  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLetra2 AS CHARACTER NO-UNDO.
DEFINE VARIABLE t-col   AS INTEGER     NO-UNDO.

RUN Carga-Datos.
RUN Carga-Resumen.

FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
IF NOT AVAILABLE w-report THEN DO:
    MESSAGE 'NO hay registros para imprimir' VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Cells(t-column,1) = "Cuadro".
chWorkSheet:Cells(t-column,2) = "Nombre".

iInt = 3.
FOR EACH AlmTabla WHERE AlmTabla.Tabla = "TR" NO-LOCK:
    chWorkSheet:Cells(t-column,iInt) = STRING(AlmTabla.Codigo,"999") + "." + Almtabla.Nombre.
    chWorkSheet:Cells(t-column,(iInt + 12)) = STRING(AlmTabla.Codigo,"999") + "." + Almtabla.Nombre.
    iInt = iInt + 1.
END.

t-column = 4.

FOR EACH tt-resumen NO-LOCK
    BREAK BY tt-resumen.codsecu :
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + codsecu.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = nomfila.

    chWorkSheet:Cells(t-column,3)= codcolu01[1].
    chWorkSheet:Cells(t-column,4)= codcolu01[2].
    chWorkSheet:Cells(t-column,5)= codcolu01[3].
    chWorkSheet:Cells(t-column,6)= codcolu01[4].
    chWorkSheet:Cells(t-column,7)= codcolu01[5].
    chWorkSheet:Cells(t-column,8)= codcolu01[6].
    chWorkSheet:Cells(t-column,9)= codcolu01[7].
    chWorkSheet:Cells(t-column,10)= codcolu01[8].
    chWorkSheet:Cells(t-column,11)= codcolu01[9].
    chWorkSheet:Cells(t-column,12)= codcolu01[10].
    chWorkSheet:Cells(t-column,13)= codcolu01[11].
    chWorkSheet:Cells(t-column,14)= codcolu01[12].

    chWorkSheet:Cells(t-column,15)= codcolu02[1].
    chWorkSheet:Cells(t-column,16)= codcolu02[2].
    chWorkSheet:Cells(t-column,17)= codcolu02[3].
    chWorkSheet:Cells(t-column,18)= codcolu02[4].
    chWorkSheet:Cells(t-column,19)= codcolu02[5].
    chWorkSheet:Cells(t-column,20)= codcolu02[6].
    chWorkSheet:Cells(t-column,21)= codcolu02[7].
    chWorkSheet:Cells(t-column,22)= codcolu02[8].
    chWorkSheet:Cells(t-column,23)= codcolu02[9].
    chWorkSheet:Cells(t-column,24)= codcolu02[10].
    chWorkSheet:Cells(t-column,25)= codcolu02[11].
    chWorkSheet:Cells(t-column,26)= codcolu02[12].

END.


/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

FOR EACH w-report WHERE w-report.task-no = s-task-no:
    DELETE w-report.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    RUN Carga-Datos.
    
    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE 'NO hay registros para imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
        
    DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
    DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
    DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
    DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
    DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */
    
    GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'vta/rbvta.prl'.
    RB-REPORT-NAME = 'Resumen Ventas'.
    RB-INCLUDE-RECORDS = "O".
    RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
    
    RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia.
    
    RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                       RB-REPORT-NAME,
                       RB-INCLUDE-RECORDS,
                       RB-FILTER,
                       RB-OTHER-PARAMETERS).

    
    FOR EACH w-report WHERE w-report.task-no = s-task-no:
        DELETE w-report.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir_Resumen W-Win 
PROCEDURE Imprimir_Resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    
    RUN Carga-Resumen.
    
    FIND FIRST w-report WHERE w-report.task-no = s-task-no02 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE 'NO hay registros para imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
        
    DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
    DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
    DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
    DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
    DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */
    
    GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'vta/rbvta.prl'.
    RB-REPORT-NAME = 'Resumen_Ventas'.
    RB-INCLUDE-RECORDS = "O".
    RB-FILTER = "w-report.task-no = " + STRING(s-task-no02).
    
    RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia.
    
    RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                       RB-REPORT-NAME,
                       RB-INCLUDE-RECORDS,
                       RB-FILTER,
                       RB-OTHER-PARAMETERS).

    /*Data Resumen*/    
    FOR EACH w-report WHERE w-report.task-no = s-task-no02:
        DELETE w-report.
    END.

    /*Data Detalle*/
    FOR EACH w-report WHERE w-report.task-no = s-task-no:
        DELETE w-report.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
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
    DEFINE VAR OUTPUT-var-1 AS ROWID.


    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
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

