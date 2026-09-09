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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE t-temp
    FIELDS t-codcli LIKE gn-clie.codcli
    FIELDS t-nomcli LIKE gn-clie.nomcli    
    FIELDS t-implcs AS DEC
    FIELDS t-implc-atlas AS DEC
    FIELDS t-implc-pc AS DEC
    FIELDS t-implc-otros AS DEC
    FIELDS t-fchini AS DATE
    FIELDS t-fchfin AS DATE
    FIELDS t-divori AS CHAR
    FIELDS t-vtaano AS DECIMAL EXTENT 3 /* 1:Ante Penultimo Año, 2:Año anterior 3:Año actual */
    FIELDS t-codven AS CHAR
    FIELDS t-pendiente AS DEC
    FIELDS t-vencido AS DEC
    FIELDS t-disponible AS DEC
    FIELDS t-dircli LIKE gn-clie.dircli
    FIELDS t-departamento AS CHAR
    FIELDS t-provincia    AS CHAR
    FIELDS t-distrito     AS CHAR
        
    FIELDS t-numruc LIKE gn-clie.ruc
    FIELDS t-codmon AS CHAR
    FIELDS t-canal  AS CHAR
    FIELDS t-imptot LIKE ccbcdocu.imptot    
    FIELDS t-flagaut AS CHAR
    FIELDS t-email AS CHAR
    FIELDS t-codmaster AS CHAR
    FIELDS t-nommaster AS CHAR
    FIELDS t-fe-email AS CHAR
    FIELDS t-avales AS CHAR
    FIELDS t-fecha-camp AS DATE
    FIELDS t-implc-camp AS DEC
    FIELDS t-fecha-camp2 AS DATE
    FIELDS t-implc-camp2 AS DEC
    FIELDS t-fecha-nocamp AS DATE
    FIELDS t-implc-nocamp AS DEC
    FIELDS t-fecha-nocamp2 AS DATE
    FIELDS t-implc-nocamp2 AS DEC
    .

DEFINE TEMP-TABLE t-clientes NO-UNDO
    FIELDS  tt-codcli    LIKE gn-clie.codcli
    INDEX Llave01 AS PRIMARY tt-codcli.

DEFINE BUFFER b-gn-clieL FOR gn-clieL.

DEFINE VAR x-inicio-campana AS DATE.
DEFINE VAR x-fin-campana AS DATE.
DEFINE VAR x-inicio-no-campana AS DATE.
DEFINE VAR x-fin-no-campana AS DATE.

DEFINE TEMP-TABLE ttlcredito
    FIELD   tdesde-camp     AS  DATE
    FIELD   thasta-camp     AS  DATE
    FIELD   tdesde-no-camp  AS  DATE
    FIELD   thasta-no-camp  AS  DATE.

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
&Scoped-Define ENABLED-OBJECTS RADIO-SET-fechas x-fecha x-codcli BUTTON-1 ~
BUTTON-2 r-opcion x-mes btn-exit btn-excel 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-fechas x-fecha x-codcli x-nomcli ~
txtFile r-opcion x-mes x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-excel 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 7 BY 1.62.

DEFINE BUTTON btn-exit 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 2" 
     SIZE 7 BY 1.62.

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .92.

DEFINE BUTTON BUTTON-2 
     LABEL "Limpiar file TXT" 
     SIZE 16 BY .77.

DEFINE VARIABLE x-mes AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Enero",1,
                     "Febrero",2,
                     "Marzo",3,
                     "Abril",4,
                     "Mayo",5,
                     "Junio",6,
                     "Julio",7,
                     "Agosto",8,
                     "Setiembre",9,
                     "Octubre",10,
                     "Noviembre",11,
                     "Diciembre",12
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE txtFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "File TXT" 
     VIEW-AS FILL-IN 
     SIZE 63 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE x-codcli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-fecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-fecha-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51.29 BY 1
     FONT 1 NO-UNDO.

DEFINE VARIABLE x-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY 1
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE r-opcion AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Línea de Crédito Disponible", 1,
"Línea de Crédito Vencido", 2,
"Línea de Créditos por Vencer", 3,
"Todos los Clientes", 4
     SIZE 34 BY 3.5 NO-UNDO.

DEFINE VARIABLE RADIO-SET-fechas AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Hasta", 1,
"Rango", 2
     SIZE 27 BY .96 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-fechas AT ROW 1.19 COL 6.86 NO-LABEL WIDGET-ID 26
     x-fecha AT ROW 2.35 COL 29.43 COLON-ALIGNED WIDGET-ID 30
     x-fecha-desde AT ROW 2.38 COL 8.86 COLON-ALIGNED WIDGET-ID 18
     x-codcli AT ROW 3.46 COL 8.86 COLON-ALIGNED WIDGET-ID 6
     x-nomcli AT ROW 3.46 COL 23.86 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     txtFile AT ROW 4.77 COL 8.86 COLON-ALIGNED WIDGET-ID 20
     BUTTON-1 AT ROW 4.81 COL 74 WIDGET-ID 22
     BUTTON-2 AT ROW 5.92 COL 57.86 WIDGET-ID 24
     r-opcion AT ROW 6.46 COL 7.86 NO-LABEL WIDGET-ID 12
     x-mes AT ROW 8.15 COL 50 COLON-ALIGNED WIDGET-ID 10
     btn-exit AT ROW 9.62 COL 67 WIDGET-ID 4
     btn-excel AT ROW 9.65 COL 59 WIDGET-ID 2
     x-mensaje AT ROW 10.15 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     "La linea credito debe estar en este rango" VIEW-AS TEXT
          SIZE 37.14 BY .62 AT ROW 2.54 COL 45.86 WIDGET-ID 32
          FGCOLOR 12 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 82.43 BY 11.38 WIDGET-ID 100.


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
         TITLE              = "Reporte Linea de Credito"
         HEIGHT             = 11.38
         WIDTH              = 82.43
         MAX-HEIGHT         = 27.38
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 27.38
         VIRTUAL-WIDTH      = 195.14
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
/* SETTINGS FOR FILL-IN txtFile IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-fecha-desde IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       x-fecha-desde:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte Linea de Credito */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte Linea de Credito */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-excel W-Win
ON CHOOSE OF btn-excel IN FRAME F-Main /* Button 1 */
DO:
    ASSIGN 
        x-codcli r-opcion x-mes x-fecha txtFile radio-set-fechas x-fecha-desde.
    /*RUN Excel.*/
    
    SESSION:SET-WAIT-STATE("GENERAL").

    /*
        Rangos
    */

    EMPTY TEMP-TABLE ttlcredito.

    DEFINE VAR x-year AS INT.
    DEFINE VAR x-year1 AS INT.

    x-year1 = YEAR(x-fecha) + 1.

    REPEAT x-year = x-year1 TO (x-year1 - 25) BY -1:
        /* Campaña */
        x-inicio-campana = DATE(10 , 1 , x-year - 1).   /* Octubre año anterior*/
        x-fin-campana = DATE(4 , 1 , x-year) - 1.       /* Marzo */

        /* NoCampaña */
        x-inicio-no-campana = x-fin-campana + 1.         /* Abril */
        x-fin-no-campana = DATE(10 , 1 , x-year) - 1.   /* Setiembre */

        CREATE ttlcredito.
        ASSIGN  ttlcredito.tdesde-camp = x-inicio-campana
                ttlcredito.thasta-camp = x-fin-campana
                ttlcredito.tdesde-no-camp = x-inicio-no-campana
                ttlcredito.thasta-no-camp = x-fin-no-campana.

    END.

/*
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = 'd:\xpciman\OtrapruebaQQQ.xlsx'.

run pi-crea-archivo-csv IN hProc (input  buffer ttlcredito:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer ttlcredito:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.
*/

    RUN Excel-New.

    SESSION:SET-WAIT-STATE("").

    /*
    IF x-codcli <> "" OR txtFile <> "" THEN DO:
        RUN Excel.
    END.
    ELSE DO:
        MESSAGE "Ingrese Cliente ó seleccione archivo de TEXTO que contenga codigos de Clientes".
    END.
    */
    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-exit W-Win
ON CHOOSE OF btn-exit IN FRAME F-Main /* Button 2 */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:
    DEFINE VAR x-archivo AS CHAR.      
    DEFINE VAR OKpressed AS LOG.
      
          SYSTEM-DIALOG GET-FILE x-Archivo
            FILTERS "Archivo (*.txt)" "*.txt"
            MUST-EXIST
            TITLE "Seleccione archivo..."
            UPDATE OKpressed.   
          IF OKpressed = NO THEN RETURN.

      txtFile:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-archivo .
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Limpiar file TXT */
DO:
  txtFile:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-fechas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-fechas W-Win
ON VALUE-CHANGED OF RADIO-SET-fechas IN FRAME F-Main
DO:
    ASSIGN x-fecha.

         DO WITH FRAME {&FRAME-NAME}:
           x-fecha-desde:VISIBLE = FALSE.
           IF radio-set-fechas:SCREEN-VALUE = '2' THEN DO:
               ENABLE x-fecha-desde.
                x-fecha-desde:VISIBLE = TRUE.
                x-fecha-desde:SCREEN-VALUE = STRING(x-fecha - 60,"99/99/9999").
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Data W-Win 
PROCEDURE Carga-Data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE x-moneda AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE dInicio  AS DATE        NO-UNDO.
    DEFINE VARIABLE dFin     AS DATE        NO-UNDO.
    DEFINE VARIABLE lOpc     AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE lRowid   AS ROWID       NO-UNDO.
    DEFINE VARIABLE cCanal   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE dTpoCmb  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE x-SdoAct AS DECIMAL     NO-UNDO.

    DEFINE VAR lCodCliente AS CHAR.

    DEF VAR  pCodCli AS CHAR.
    DEF VAR pMaster AS CHAR.
    DEF VAR pRelacionados AS CHAR.
    DEF VAR pAgrupados AS LOG.

    DEFINE VAR x-avales AS CHAR.
    DEFINE VAR x-sw AS INT.

    DEFINE VAR x-lc-camp AS INT.
    DEFINE VAR x-lc-nocamp AS INT.    

    DEFINE VAR x-year AS INT.

    DEFINE BUFFER x-gn-clie FOR gn-clie.


    /* FIELDS  t-codcli    LIKE gn-clie.codcli. */
    EMPTY TEMP-TABLE t-temp.
    EMPTY TEMP-TABLE t-clientes.
    IF txtFile <> "" THEN DO:
            INPUT FROM VALUE(txtFile).

          REPEAT:
                CREATE t-clientes.
                IMPORT t-clientes.
            END.
            INPUT CLOSE.
    END.
    ELSE DO:
        IF x-codcli <> "" THEN DO:
            CREATE t-clientes.
            ASSIGN tt-codcli = x-codcli.
        END.
        ELSE DO:
            /* TODOS */
            FOR EACH gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
                AND gn-clie.flgsit = "A"
                /*AND gn-clie.flagaut = "A"*/:
                CREATE t-clientes.
                ASSIGN tt-codcli = gn-clie.codcli.
            END.
        END.
    END.
    /* Depuramos */
    CASE TRUE:
        WHEN r-opcion = 2 THEN DO:
            FOR EACH t-clientes EXCLUSIVE-LOCK:
                FIND FIRST gn-cliel WHERE gn-cliel.codcia = cl-codcia
                    AND gn-cliel.codcli = t-clientes.tt-codcli
                    AND gn-cliel.fchfin > x-fecha
                    NO-LOCK NO-ERROR.
                IF AVAILABLE gn-cliel THEN DELETE t-clientes. 
            END.
        END.
    END CASE.

    Head:
    FOR EACH t-clientes EXCLUSIVE-LOCK:
        lCodCliente = t-clientes.tt-codcli.
        /*Cargando Linea de Credito Campaña*/
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia 
            AND gn-clie.codcli = lCodCliente 
            NO-LOCK NO-ERROR.
        FIND FIRST Almtab WHERE Almtab.Tabla = "CN" 
            AND Almtab.Codigo = gn-clie.Canal NO-LOCK NO-ERROR.
        IF AVAIL Almtab THEN cCanal = almtabla.Nombre.
        ELSE cCanal = "".

        FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK NO-ERROR.
        IF AVAIL gn-tcmb THEN dTpoCmb = gn-tcmb.compra. ELSE dTpoCmb = 0.

        /* La ultima Linea de credito, segun fecha */
        lOpc = NO.
        lRowid = ?.
        FOR EACH Gn-ClieL NO-LOCK WHERE Gn-ClieL.CodCia = gn-clie.codcia 
            AND Gn-ClieL.CodCli = gn-clie.codcli 
            AND Gn-ClieL.FchIni <> ? 
            AND Gn-ClieL.FchFin <> ? 
            BY gn-cliel.fchini BY gn-cliel.fchfin:
            lRowid = ROWID(Gn-ClieL).
        END.

        IF lRowid = ? THEN NEXT Head.

        FIND Gn-ClieL WHERE ROWID(Gn-ClieL) = lRowid NO-LOCK.
        IF radio-set-fechas = 1 THEN DO:
            CASE r-opcion:
                WHEN 1 THEN DO: 
                    IF x-fecha >= gn-cliel.fchini AND x-fecha <= gn-cliel.fchfin THEN lOpc = YES.             
                END.
                WHEN 2 THEN DO: 
                    lOpc = YES. 
                    IF gn-cliel.fchfin > x-fecha THEN NEXT Head.                    
                END.
                WHEN 3 THEN DO:
                    IF YEAR(gn-cliel.fchfin) = YEAR(TODAY) AND MONTH(gn-cliel.fchfin) = x-mes 
                        THEN lOpc = YES.
                    ELSE NEXT Head.
                END.
                WHEN 4 THEN DO:
                    lOpc = YES.
                END.
            END CASE.
        END.
        ELSE DO:
            CASE r-opcion:
                WHEN 1 THEN DO: 
                    IF gn-cliel.fchfin >= x-fecha-desde AND gn-cliel.fchfin <= x-fecha THEN lOpc = YES.             
                END.
                WHEN 2 THEN DO: 
                    lOpc = YES. 
                    IF gn-cliel.fchfin > x-fecha THEN NEXT Head.                    
                END.
                WHEN 3 THEN DO:
                    IF YEAR(gn-cliel.fchfin) = YEAR(TODAY) AND MONTH(gn-cliel.fchfin) = x-mes 
                        THEN lOpc = YES.
                    ELSE NEXT Head.
                END.
                WHEN 4 THEN DO:
                    lOpc = YES.
                END.
            END CASE.
        END.

        /*
        */

        IF lOpc THEN DO:

            FIND FIRST t-temp WHERE t-codcli = gn-clie.codcli NO-LOCK NO-ERROR.                                                       
            IF NOT AVAIL t-temp THEN DO:                                                
                IF Gn-ClieL.monlc = 1 THEN x-moneda = "S/.".                             
                ELSE x-moneda = "US$".                                                    
                CREATE t-temp.                                                          
                ASSIGN                                                                  
                    t-codcli = gn-clie.codcli                                           
                    t-nomcli = gn-clie.nomcli                                           
                    t-dircli = gn-clie.dircli
                    t-numruc = gn-clie.Ruc                                              
                    t-codmon = x-moneda                                                 
                    t-imptot = gn-cliel.implc    
                    t-implc-atlas = gn-cliel.lcimpdiv[1]
                    t-implc-pc = gn-cliel.lcimpdiv[2]
                    t-implc-otros = gn-cliel.lcsdodiv
                    t-canal  = cCanal                                                   
                    t-fchini = gn-cliel.fchini                                          
                    t-fchfin = gn-cliel.fchfin
                    t-codven = gn-clie.codven
                    t-flagaut = gn-clie.flagaut
                    t-divori = gn-clie.coddiv
                    t-email  = gn-clie.E-Mail
                    t-codmaster = ""
                    t-nommaster = ""
                    .

                x-lc-camp = 0.
                x-lc-nocamp = 0.
                LOOPLC:
                FOR EACH b-gn-clieL WHERE b-gn-clieL.codcia = cl-codcia AND
                                            b-gn-clieL.codcli = gn-clie.codcli NO-LOCK BY b-gn-clieL.fchfin DESC:                    
                    
                    x-sw = 0.
                    IF x-lc-camp < 2 THEN DO:
                        FIND FIRST ttlcredito WHERE b-gn-clieL.fchfin >= ttlcredito.tdesde-camp AND
                                                    b-gn-clieL.fchfin <= ttlcredito.thasta-camp NO-LOCK NO-ERROR.
                        IF AVAILABLE ttLcredito THEN DO:
                            
                            x-lc-camp = x-lc-camp + 1.
                            IF x-lc-camp = 1 THEN DO:
                                ASSIGN t-fecha-camp = b-gn-clieL.fchfin
                                        t-implc-camp = b-gn-clieL.implc.
                                x-sw = 1.
                            END.
                            ELSE DO:
                                ASSIGN t-fecha-camp2 = b-gn-clieL.fchfin
                                        t-implc-camp2 = b-gn-clieL.implc.
                                x-sw = 1.
                            END.
                        END.
                    END.
                    IF x-lc-nocamp < 2 AND x-sw = 0 THEN DO:
                        FIND FIRST ttlcredito WHERE b-gn-clieL.fchfin >= ttlcredito.tdesde-no-camp AND
                                                    b-gn-clieL.fchfin <= ttlcredito.thasta-no-camp NO-LOCK NO-ERROR.
                        IF AVAILABLE ttLcredito THEN DO:
                            x-lc-nocamp = x-lc-nocamp + 1.
                            IF x-lc-nocamp = 1 THEN DO:
                                ASSIGN t-fecha-nocamp = b-gn-clieL.fchfin
                                        t-implc-nocamp = b-gn-clieL.implc.
                            END.
                            ELSE DO:
                                ASSIGN t-fecha-nocamp2 = b-gn-clieL.fchfin
                                        t-implc-nocamp2 = b-gn-clieL.implc.
                            END.

                        END.
                    END.
                    IF x-lc-camp >= 2 AND x-lc-nocamp >= 2 THEN DO:
                        LEAVE LOOPLC.
                    END.
                    
                END.

                /* Ic - 11Mar2019, Correo de Julisa del 22Feb2019*/
                /*
                FIELDS t-fe-email AS CHAR
                FIELDS t-email AS CHAR
                FIELDS t-avales AS CHAR
                */
                ASSIGN t-fe-email = IF NOT (TRUE <> (gn-clie.transporte[4] > "")) THEN gn-clie.transporte[4] ELSE ""
                        t-email = IF NOT (TRUE <> (gn-clie.e-mail > "")) THEN gn-clie.e-mail ELSE ""

                x-avales = "".
                /*  */
                IF NUM-ENTRIES(aval1[1],"|") >= 1 THEN DO:
                    IF NOT (TRUE <> (ENTRY(1,aval1[1],"|") > ""))  THEN DO:
                        x-avales = ENTRY(1,aval1[1],"|").
                    END.
                END.
                IF NUM-ENTRIES(aval1[1],"|") >= 2 THEN DO:
                    IF NOT (TRUE <> (ENTRY(2,aval1[1],"|") > ""))  THEN DO:
                        IF x-avales <> "" THEN x-avales = x-avales + ",".
                        x-avales = x-avales + ENTRY(2,aval1[1],"|").
                    END.
                END.
                IF NUM-ENTRIES(aval2[1],"|") >= 1 THEN DO:
                    IF NOT (TRUE <> (aval2[1] > ""))  THEN DO:
                        IF x-avales <> "" THEN x-avales = x-avales + ",".
                        x-avales = x-avales + aval2[1].
                    END.
                END.
                ASSIGN t-avales = x-avales.

                /* Ic - 30Oct2018, correo Julissa Calderon */
                pMaster = "".

                RUN ccb/p-cliente-master (INPUT gn-clie.codcli, OUTPUT pMaster, OUTPUT pRelacionados, OUTPUT pAgrupados).
                IF NOT (TRUE <> (pMaster > "")) THEN DO:
                    ASSIGN t-codmaster = pMaster.
                    FIND FIRST x-gn-clie WHERE x-gn-clie.codcia = cl-codcia AND
                                                x-gn-clie.codcli = pMaster NO-LOCK NO-ERROR.
                    IF AVAILABLE x-gn-clie THEN DO:
                        ASSIGN t-nommaster = x-gn-clie.nomcli.
                    END.
                END.


                IF gn-cliel.monlc <> 1 THEN 
                    ASSIGN
                        t-implcs = gn-cliel.implc * dTpoCmb
                        t-implc-atlas = t-implc-atlas * dTpoCmb
                        t-implc-pc = t-implc-pc * dTpoCmb
                        t-implc-otros = t-implc-otros * dTpoCmb.
                ELSE t-implcs = gn-cliel.implc.  
                FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.coddept NO-LOCK NO-ERROR.
                IF AVAILABLE TabDepto THEN t-departamento = TabDepto.NomDepto.
                FIND  Tabprovi WHERE Tabprovi.CodDepto = gn-clie.CodDept
                    AND Tabprovi.Codprovi = gn-clie.codprov NO-LOCK NO-ERROR.
                IF AVAILABLE Tabprovi THEN t-provincia = Tabprovi.Nomprovi.
                FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept
                    AND Tabdistr.Codprovi = gn-clie.codprov
                    AND Tabdistr.Coddistr = gn-clie.coddist NO-LOCK NO-ERROR.
                IF AVAILABLE Tabdistr THEN t-distrito = Tabdistr.Nomdistr .
            END.   
        END.
        DISPLAY "NOMB.CLIENTE: " + gn-clie.nomcli @ x-mensaje 
            WITH FRAME {&FRAME-NAME}.
        PAUSE 0.

    END.
    FOR EACH t-temp:
        DISPLAY "COD.CLIENTE: " + t-temp.t-codcli @ x-mensaje 
            WITH FRAME {&FRAME-NAME}.
        PAUSE 0.
        FOR EACH VentasxCliente NO-LOCK WHERE VentasxCliente.DateKey >= DATE(01,01,YEAR(TODAY) - 2)
            AND VentasxCliente.CodCli = t-codcli:
            CASE YEAR(VentasxCliente.DateKey):
                WHEN (YEAR(TODAY) - 2) THEN t-vtaano[1] = t-vtaano[1] + VentasxCliente.ImpNacCIGV.
                WHEN (YEAR(TODAY) - 1) THEN t-vtaano[2] = t-vtaano[2] + VentasxCliente.ImpNacCIGV.
                WHEN (YEAR(TODAY)) THEN t-vtaano[3] = t-vtaano[3] + VentasxCliente.ImpNacCIGV.
            END CASE.
        END.
        /* Deudas pendientes */
        x-SdoAct = 0.
        FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
            AND Ccbcdocu.codcli = t-temp.t-codcli
            AND LOOKUP(Ccbcdocu.coddoc, 'LET,FAC,BOL,TCK,N/C,N/D') > 0
            AND Ccbcdocu.flgest = "P":
            x-SdoAct = Ccbcdocu.SdoAct.
            IF Ccbcdocu.codmon = 2 THEN x-SdoAct = Ccbcdocu.SdoAct * Ccbcdocu.TpoCmb.
            IF Ccbcdocu.coddoc = "N/C" THEN x-SdoAct = -1 * x-SdoAct.
            ASSIGN
                t-temp.t-pendiente = t-temp.t-pendiente + x-sdoact.
            IF Ccbcdocu.fchvto < TODAY THEN t-temp.t-vencido = t-temp.t-vencido + x-sdoact.
        END.
        t-temp.t-disponible = t-temp.t-imptot - t-temp.t-pendiente.
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
  DISPLAY RADIO-SET-fechas x-fecha x-codcli x-nomcli txtFile r-opcion x-mes 
          x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RADIO-SET-fechas x-fecha x-codcli BUTTON-1 BUTTON-2 r-opcion x-mes 
         btn-exit btn-excel 
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 3.
DEFINE VARIABLE t-Letra                 AS INTEGER.
DEFINE VARIABLE iInt                    AS INTEGER     NO-UNDO.

DEFINE VARIABLE cLetra  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLetra2 AS CHARACTER NO-UNDO.
DEFINE VARIABLE t-col   AS INTEGER   NO-UNDO.
DEFINE VARIABLE dTpoCmb AS DECIMAL   NO-UNDO.
DEFINE VARIABLE cNomVen AS CHARACTER   NO-UNDO.


RUN Carga-Data.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("B2"):Value = "REPORTE LINEA DE CREDITO CLIENTES".

chWorkSheet:Range("A3"):Value = "CodCli".
chWorkSheet:Range("B3"):Value = "Cliente".
chWorkSheet:Range("C3"):Value = "RUC".
chWorkSheet:Range("D3"):Value = "Moneda".
chWorkSheet:Range("E3"):Value = "Importe".
chWorkSheet:Range("F3"):Value = "Fecha Inicio".
chWorkSheet:Range("G3"):Value = "Fecha Fin".
chWorkSheet:Range("H3"):Value = "Canal".
chWorkSheet:Range("I3"):Value = "Ventas " + STRING(YEAR(TODAY) - 2).
chWorkSheet:Range("J3"):Value = "Ventas " + STRING(YEAR(TODAY) - 1).
chWorkSheet:Range("K3"):Value = "Ventas " + STRING(YEAR(TODAY)).

chWorkSheet:Range("L3"):Value = "Tipo Cambio".
chWorkSheet:Range("M3"):Value = "Rotación " + STRING(YEAR(TODAY) - 2).
chWorkSheet:Range("N3"):Value = "Rotación " + STRING(YEAR(TODAY) - 1).
chWorkSheet:Range("O3"):Value = "Rotación " + STRING(YEAR(TODAY)).

chWorkSheet:Range("P3"):Value = "Vendedor".
chWorkSheet:Range("Q3"):Value = "Autorización".

chWorkSheet:Range("R3"):Value = "Deuda".
chWorkSheet:Range("S3"):Value = "Vencido".
chWorkSheet:Range("T3"):Value = "Disponible".

chWorkSheet:Range("U3"):Value = "Departamento".
chWorkSheet:Range("V3"):Value = "Provincia".
chWorkSheet:Range("W3"):Value = "Distrito".

chWorkSheet:Range("X3"):Value = "Division".
chWorkSheet:Range("Y3"):Value = "e-mail".

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("C"):NumberFormat = "@".

FOR EACH t-temp NO-LOCK:
    FIND FIRST gn-tcmb WHERE gn-tcmb.fecha = TODAY NO-LOCK NO-ERROR.
    IF AVAIL gn-tcmb THEN dTpoCmb = gn-tcmb.compra. ELSE dTpoCmb = 0.

    FIND gn-ven WHERE gn-ven.codcia = s-codcia
        AND gn-ven.CodVen = t-temp.t-codven NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN cNomVen = gn-ven.NomVen.
    ELSE cNomVen = "".

    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-codcli.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-nomcli.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-numruc.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-codmon.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-imptot.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-fchini.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-fchfin.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-canal.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-vtaano[1].
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-vtaano[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-vtaano[3].

    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = dtpocmb.
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-vtaano[1] / t-temp.t-implcs.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-vtaano[2] / t-temp.t-implcs.
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-vtaano[3] / t-temp.t-implcs.

    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-codven + '-' + cNomVen.

    cRange = "Q" + cColumn.
    CASE t-temp.t-flagaut:
        WHEN ""  THEN chWorkSheet:Range(cRange):Value = "SIN AUTORIZAR".
        WHEN "A" THEN chWorkSheet:Range(cRange):Value = "AUTORIZADO".
        WHEN "R" THEN chWorkSheet:Range(cRange):Value = "RECHAZADO".
    END CASE.
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = t-pendiente.
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = t-vencido.
    cRange = "T" + cColumn.
    chWorkSheet:Range(cRange):Value = t-disponible.
    cRange = "U" + cColumn.
    chWorkSheet:Range(cRange):Value = t-departamento.
    cRange = "V" + cColumn.
    chWorkSheet:Range(cRange):Value = t-provincia.
    cRange = "W" + cColumn.
    chWorkSheet:Range(cRange):Value = t-distrito.
    cRange = "X" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + t-divori.
    cRange = "Y" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + t-email.
END.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-New W-Win 
PROCEDURE Excel-New :
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 3.
DEFINE VARIABLE t-Letra                 AS INTEGER.
DEFINE VARIABLE iInt                    AS INTEGER     NO-UNDO.

DEFINE VARIABLE cLetra  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLetra2 AS CHARACTER NO-UNDO.
DEFINE VARIABLE t-col   AS INTEGER   NO-UNDO.
DEFINE VARIABLE dTpoCmb AS DECIMAL   NO-UNDO.
DEFINE VARIABLE cNomVen AS CHARACTER   NO-UNDO.


RUN Carga-Data.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("B2"):Value = "REPORTE LINEA DE CREDITO CLIENTES".

chWorkSheet:Range("A3"):Value = "Cod.Cli".
chWorkSheet:Range("B3"):Value = "Cliente".
chWorkSheet:Range("C3"):Value = "Importe Total".
chWorkSheet:Range("D3"):Value = "R.U.C. Master".
chWorkSheet:Range("E3"):Value = "Cliente Principal".
/*
chWorkSheet:Range("F3"):Value = "LC Otros".
*/
chWorkSheet:Range("F3"):Value = "Fecha Inicio".
chWorkSheet:Range("G3"):Value = "Fecha Fin".
chWorkSheet:Range("H3"):Value = "Div. Comercial".
chWorkSheet:Range("I3"):Value = "Ventas " + STRING(YEAR(TODAY) - 2).
chWorkSheet:Range("J3"):Value = "Ventas " + STRING(YEAR(TODAY) - 1).
chWorkSheet:Range("K3"):Value = "Ventas " + STRING(YEAR(TODAY)).
chWorkSheet:Range("L3"):Value = "Vendedor".
chWorkSheet:Range("M3"):Value = "Deuda".
chWorkSheet:Range("N3"):Value = "Vencido".
chWorkSheet:Range("O3"):Value = "Disponible".
chWorkSheet:Range("P3"):Value = "Direccion".
chWorkSheet:Range("Q3"):Value = "Departamento".
chWorkSheet:Range("R3"):Value = "Provincia".
chWorkSheet:Range("S3"):Value = "Distrito".
chWorkSheet:Range("T3"):Value = "e-Mail Fact.Electronica".
chWorkSheet:Range("U3"):Value = "e-Mail".
chWorkSheet:Range("V3"):Value = "Registro Avales".

chWorkSheet:Range("W3"):Value = "Fecha Final LC - Campaña".
chWorkSheet:Range("X3"):Value = "LC - Campaña".
chWorkSheet:Range("Y3"):Value = "Fecha Final LC - Campaña Anterior".
chWorkSheet:Range("Z3"):Value = "LC - Campaña Anterior".

chWorkSheet:Range("AA3"):Value = "Fecha Final LC - NO Campaña".
chWorkSheet:Range("AB3"):Value = "LC - NO Campaña".
chWorkSheet:Range("AC3"):Value = "Fecha Final LC - NO Campaña Anterior".
chWorkSheet:Range("AD3"):Value = "LC - NO Campaña Anterior".

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("H"):NumberFormat = "@".
chWorkSheet:Columns("F"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Columns("G"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Columns("W"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Columns("Y"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Columns("AA"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Columns("AC"):NumberFormat = "dd/mm/yyyy".

FOR EACH t-temp NO-LOCK:
    FIND FIRST gn-tcmb WHERE gn-tcmb.fecha = TODAY NO-LOCK NO-ERROR.
    IF AVAIL gn-tcmb THEN dTpoCmb = gn-tcmb.compra. ELSE dTpoCmb = 0.

    FIND gn-ven WHERE gn-ven.codcia = s-codcia
        AND gn-ven.CodVen = t-temp.t-codven NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN cNomVen = gn-ven.NomVen.
    ELSE cNomVen = "".

    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-codcli.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-nomcli.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-implcs.      /*t-temp.t-imptot.*/
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-codmaster.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-nommaster.
    /*
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-implc-otros.
    */
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-fchini.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-fchfin.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = t-divori.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-vtaano[1].
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-vtaano[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-vtaano[3].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = t-temp.t-codven + '-' + cNomVen.
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = t-pendiente.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = t-vencido.
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = t-disponible.
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = t-dircli.
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = t-departamento.
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = t-provincia.
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = t-distrito.
    cRange = "T" + cColumn.
    chWorkSheet:Range(cRange):Value = t-fe-email.
    cRange = "U" + cColumn.
    chWorkSheet:Range(cRange):Value = t-email.
    cRange = "V" + cColumn.
    chWorkSheet:Range(cRange):Value = t-avales.
    
    cRange = "W" + cColumn.
    chWorkSheet:Range(cRange):Value = t-fecha-camp.
    cRange = "X" + cColumn.
    chWorkSheet:Range(cRange):Value = t-implc-camp.
    cRange = "Y" + cColumn.
    chWorkSheet:Range(cRange):Value = t-fecha-camp2.
    cRange = "Z" + cColumn.
    chWorkSheet:Range(cRange):Value = t-implc-camp2.

    cRange = "AA" + cColumn.
    chWorkSheet:Range(cRange):Value = t-fecha-nocamp.
    cRange = "AB" + cColumn.
    chWorkSheet:Range(cRange):Value = t-implc-nocamp.
    cRange = "AC" + cColumn.
    chWorkSheet:Range(cRange):Value = t-fecha-nocamp2.
    cRange = "AD" + cColumn.
    chWorkSheet:Range(cRange):Value = t-implc-nocamp2.
    
END.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN 
          x-mes = MONTH(TODAY)
          x-fecha = TODAY
          x-fecha-desde = TODAY - 60. 


  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
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

