&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w

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

/* Local Variable Definitions ---                                       */

DEFINE SHARED VAR s-CodCia  AS INTEGER.
DEFINE SHARED VAR Cb-CodCia AS INTEGER.
DEFINE SHARED VAR Cl-CodCia AS INTEGER.
DEFINE SHARED VAR s-NroMes  AS INTEGER.
DEFINE SHARED VAR s-NomCia  AS CHARACTER.
DEFINE SHARED VAR s-Periodo AS INTEGER.
DEFINE SHARED VAR s-user-id AS CHAR.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE C-FLGEST AS CHAR NO-UNDO.
DEFINE STREAM REPORT.

DEFINE VAR C-BIMP AS CHAR.
DEFINE VAR C-ISC  AS CHAR.
DEFINE VAR C-IGV  AS CHAR.
DEFINE VAR C-TOT  AS CHAR.

DEF VAR s-task-no LIKE w-report.task-no NO-UNDO.
DEF VAR s-titulo1 AS CHAR NO-UNDO.
DEF VAR s-titulo2 AS CHAR NO-UNDO.
DEF VAR s-titulo3 AS CHAR NO-UNDO.

DEF VAR RB-REPORT-LIBRARY AS CHAR NO-UNDO.
DEF VAR RB-REPORT-NAME AS CHAR NO-UNDO.
DEF VAR RB-INCLUDE-RECORDS AS CHAR NO-UNDO.
DEF VAR RB-FILTER AS CHAR NO-UNDO.
DEF VAR RB-OTHER-PARAMETERS AS CHAR NO-UNDO.

/* BUSCANDO LAS CONFIGURACIONES DEL LIBRO DE VENTAS */

FIND cb-cfgg WHERE cb-cfgg.CODCIA = cb-codcia AND cb-cfgg.CODCFG = "R02"
     NO-LOCK NO-ERROR.
IF NOT AVAIL cb-cfgg THEN DO:
   MESSAGE "No esta configurado el registro de Ventas" VIEW-AS 
   ALERT-BOX ERROR.
   RETURN.
END.

/* Configuraciones */
C-BIMP = TRIM (cb-cfgg.CODCTA[1]).
C-ISC  = TRIM (cb-cfgg.CODCTA[2]).
C-IGV  = TRIM (cb-cfgg.CODCTA[3]).
C-TOT  = TRIM (cb-cfgg.CODCTA[4]).

/* Definicion del Frame de Imprsión y sus Variables  */

DEFINE VAR x-CodDiv AS CHAR.
DEFINE VAR x-NroAst AS CHAR.
DEFINE VAR x-FchDoc AS DATE.
DEFINE VAR x-CodDoc AS CHAR.
DEFINE VAR x-NroDoc AS CHAR.
DEFINE VAR x-Ruc    AS CHAR.
DEFINE VAR x-NomCli AS CHAR.
DEFINE VAR x-Import AS DECIMAL EXTENT 10.
DEFINE VAR x-CodRef AS CHAR.
DEFINE VAR x-NroRef AS CHAR.
DEFINE VAR x-CodMon AS CHAR.
DEFINE VAR x-CodOpe AS CHAR.

/* OTRAS VARIABLES */

DEFINE VAR x-DesMes AS CHAR.

/*DEFINE WORK-TABLE Registro
 *    FIELD CodCia AS CHAR
 *    FIELD CodDiv AS CHAR
 *    FIELD NroAst AS CHAR
 *    FIELD FchDoc AS DATE
 *    FIELD CodDoc AS CHAR
 *    FIELD NroDoc AS CHAR
 *    FIELD NroRef AS CHAR
 *    FIELD NotDeb AS CHAR
 *    FIELD NotCre AS CHAR
 *    FIELD Ruc    AS CHAR
 *    FIELD NomCli AS CHAR
 *    FIELD CodMon AS CHAR
 *    FIELD Cco    AS CHAR
 *    FIELD Implin AS DECIMAL EXTENT 10.*/

DEFINE TEMP-TABLE Registro NO-UNDO
    FIELD CodOpe AS CHAR
    FIELD CodCia AS CHAR
    FIELD CodDiv AS CHAR
    FIELD NroAst AS CHAR
    FIELD FchDoc AS DATE
    FIELD CodDoc AS CHAR
    FIELD NroDoc AS CHAR
    FIELD CodRef AS CHAR
    FIELD NroRef AS CHAR
    FIELD NotDeb AS CHAR
    FIELD NotCre AS CHAR
    FIELD Ruc    AS CHAR
    FIELD NomCli AS CHAR
    FIELD CodMon AS CHAR
    FIELD Cco    AS CHAR
    FIELD Implin AS DECIMAL EXTENT 10
    INDEX Index01 AS PRIMARY CodCia CodDiv CodDoc NroDoc.

DEFINE IMAGE IMAGE-2 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(40)" NO-UNDO.

DEFINE FRAME F-Proceso
    IMAGE-2 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor..." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
        SKIP
    Fi-Mensaje NO-LABEL FONT 6
        SKIP     
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
        BGCOLOR 15 FGCOLOR 0 
        TITLE "Procesando ..." FONT 7.

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
&Scoped-Define ENABLED-OBJECTS RECT-20 RECT-12 C-CodMon x-Div s-CodOpe ~
TOGGLE-1 Btn_OK Btn_Cancel BUTTON-2 BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS C-CodMon x-Div s-CodOpe TOGGLE-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\tbldat":U
     LABEL "Button 1" 
     SIZE 12 BY 1.5 TOOLTIP "Exportar a Texto".

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 12 BY 1.5.

DEFINE VARIABLE s-CodOpe AS CHARACTER FORMAT "X(256)":U 
     LABEL "Operaciones" 
     VIEW-AS FILL-IN 
     SIZE 22.29 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-Div AS CHARACTER FORMAT "X(5)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE C-CodMon AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dólares", 2
     SIZE 10 BY 1.62 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 39.29 BY 3.5.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 13 BY 2.5.

DEFINE VARIABLE TOGGLE-1 AS LOGICAL INITIAL no 
     LABEL "Solo Resumen por División" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     C-CodMon AT ROW 2.23 COL 2.43 NO-LABEL
     x-Div AT ROW 2.35 COL 26 COLON-ALIGNED
     s-CodOpe AT ROW 3.12 COL 18.57
     TOGGLE-1 AT ROW 4.08 COL 28
     Btn_OK AT ROW 5.31 COL 2
     Btn_Cancel AT ROW 5.31 COL 15
     BUTTON-2 AT ROW 5.31 COL 28 WIDGET-ID 2
     BUTTON-1 AT ROW 5.31 COL 41
     " Moneda" VIEW-AS TEXT
          SIZE 7.14 BY .65 AT ROW 1.42 COL 2.86
     RECT-20 AT ROW 1.65 COL 1.72
     RECT-12 AT ROW 1.73 COL 15.72
     SPACE(1.70) SKIP(1.91)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Registro de Ventas".


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

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN s-CodOpe IN FRAME D-Dialog
   ALIGN-L                                                              */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Registro de Ventas */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN C-CodMon s-CodOpe x-Div TOGGLE-1.
  RUN IMPRIMIR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 D-Dialog
ON CHOOSE OF BUTTON-1 IN FRAME D-Dialog /* Button 1 */
DO:
  ASSIGN C-CodMon s-CodOpe x-Div TOGGLE-1.
  RUN Texto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 D-Dialog
ON CHOOSE OF BUTTON-2 IN FRAME D-Dialog /* Button 2 */
DO:
    ASSIGN C-CodMon s-CodOpe x-Div TOGGLE-1.
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Excel.
    SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{lib/def-prn2.i}
{src/adm/template/dialogmn.i}

  FIND cb-cfgg WHERE cb-cfgg.CODCIA = cb-codcia AND cb-cfgg.CODCFG = "R02"
       NO-LOCK NO-ERROR.
  IF AVAIL cb-cfgg THEN DO:
     s-CodOpe:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cb-cfgg.codope.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CAPTURA D-Dialog 
PROCEDURE CAPTURA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR i        AS INTEGER NO-UNDO.
  DEFINE VAR ii       AS INTEGER NO-UNDO.
  DEFINE VAR iii      AS INTEGER NO-UNDO.
  DEFINE VAR x-Debe   AS DECIMAL NO-UNDO.
  DEFINE VAR x-Haber  AS DECIMAL NO-UNDO.
  DEFINE VAR y-Debe   AS DECIMAL NO-UNDO.
  DEFINE VAR y-Haber  AS DECIMAL NO-UNDO.
  DEFINE VAR x-Cco    AS CHAR    NO-UNDO.

  DEFINE VAR x-CodCta AS CHAR.

  DO i = 1 TO NUM-ENTRIES(s-CodOpe) :
      x-codope = ENTRY(i, s-CodOpe).
      FOR EACH cb-cmov NO-LOCK WHERE cb-cmov.CodCia  = s-CodCia  AND
                                     cb-cmov.Periodo = s-Periodo AND
                                     cb-cmov.NroMes  = s-NroMes  AND
                                     cb-cmov.CodOpe  = x-CodOpe
                                     BREAK BY cb-cmov.NroAst :
                                     
          x-NroAst = cb-cmov.NroAst.
          /*x-NomCli = cb-cmov.NotAst.*/
          
          FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.CodCia  = cb-cmov.CodCia  AND
                                         cb-dmov.Periodo = cb-cmov.Periodo AND
                                         cb-dmov.NroMes  = cb-cmov.NroMes  AND
                                         cb-dmov.CodOpe  = cb-cmov.CodOpe  AND
                                         cb-dmov.NroAst  = cb-cmov.NroAst  AND
                                         cb-dmov.CodDiv  BEGINS x-Div 
                                         BREAK BY cb-dmov.CodDiv :
              IF FIRST-OF (cb-dmov.CodDiv) THEN DO :
                 x-Import[1] = 0.
                 x-Import[2] = 0.
                 x-Import[3] = 0.
                 x-Import[4] = 0.
                 x-Import[5] = 0.
                 x-Import[6] = 0.
                 x-Import[9] = 0.
                 x-CodDiv = cb-dmov.CodDiv.
                 x-Cco    = ''.
              END.
              IF NOT tpomov THEN DO:
                 y-debe  = ImpMn2.
                 y-haber = 0.
                 CASE c-codmon:
                 WHEN 1 THEN DO:
                      x-debe  = ImpMn1.
                      x-haber = 0.
                 END.
                 WHEN 2 THEN DO:
                      x-debe  = ImpMn2.
                      x-haber = 0.
                 END.
                 END CASE.
              END.
              ELSE DO:      
                  y-haber = ImpMn2.
                  y-Debe  = 0.
                  CASE c-codmon:
                  WHEN 1 THEN DO:
                      x-debe  = 0.
                      x-haber = ImpMn1.
                  END.
                  WHEN 2 THEN DO:
                      x-debe  = 0.
                      x-haber = ImpMn2.
                  END.
                  END CASE.            
              END.
              
              x-Cco = IF x-Cco = '' THEN Cb-Dmov.Cco ELSE x-Cco.
              
              DO ii = 1 TO NUM-ENTRIES(C-BIMP) :
                 x-CodCta = ENTRY(ii,C-BIMP).
                 IF cb-dmov.CodCta BEGINS x-CodCta THEN DO :                    
                    IF cb-dmov.TM = 1 THEN DO :
                       x-Import[1] = x-Import[1] + (x-Haber - x-Debe).
                       x-Import[4] = x-Import[4] + (x-Haber - x-Debe).
                    END.   
/*                    ELSE x-Import[2] = x-Import[2] + (x-Haber - x-Debe).*/
                    IF cb-dmov.TM = 2 THEN DO :
                       x-Import[2] = x-Import[2] + (x-Haber - x-Debe).
                    END.   

                 END.
              END.   
              
              IF C-ISC <> '' AND 
                 (cb-dmov.CodCta BEGINS C-ISC OR 
                 LOOKUP(cb-dmov.CodCta,C-ISC) > 0)
                 THEN DO :
                 x-Import[3] = x-Import[3] + (x-Haber - x-Debe).
              END.  
                   
              IF cb-dmov.CodCta BEGINS C-IGV OR 
                 LOOKUP(cb-dmov.CodCta,C-IGV) > 0 THEN DO :
                 x-Import[5] = x-Import[5] + (x-Haber - x-Debe).
              END.  

              DO iii = 1 TO NUM-ENTRIES(C-TOT):
                x-CodCta = ENTRY(iii,C-TOT) .
                IF Cb-dmov.codcta BEGINS x-CodCta THEN DO:
                    x-Import[6] = x-Import[6] + (x-Debe - x-Haber).
                    x-import[9] = x-import[9] + (y-Debe - y-Haber).
                    x-FchDoc = cb-dmov.FchDoc.
                    x-CodDoc = cb-dmov.CodDoc.
                    x-NroDoc = cb-dmov.NroDoc.
                    x-CodMon = IF cb-dmov.CodMon = 1 THEN "S/." ELSE "US$".
                    x-NomCli = cb-dmov.GloDoc.
                    x-Ruc    = cb-dmov.NroRuc.
                    x-CodRef = cb-dmov.CodRef.
                    x-NroRef = cb-dmov.NroRef.

                    FIND GN-CLIE WHERE 
                        GN-CLIE.CodCia = cl-codcia AND
                        /****
                        GN-CLIE.codcli = cb-dmov.CodAux and 
                        ****/
/*RD01*/                GN-CLIE.codcli = cb-dmov.NroRuc and 
                        GN-CLIE.codcli <> '' NO-LOCK NO-ERROR.
                    IF AVAILABLE GN-CLIE THEN x-NomCli = GN-CLIE.NomCli.
                    ELSE x-NomCli = cb-dmov.GloDoc.                    
                END.
              END.
/*              IF cb-dmov.CodCta BEGINS C-TOT OR 
 *                  LOOKUP(cb-dmov.CodCta,C-TOT) > 0 THEN DO :
 *                  x-Import[6] = x-Import[6] + (x-Debe - x-Haber).
 *                  x-import[9] = x-import[9] + (y-Debe - y-Haber).
 *                  x-FchDoc = cb-dmov.FchDoc.
 *                  x-CodDoc = cb-dmov.CodDoc.
 *                  x-NroDoc = cb-dmov.NroDoc.
 *                  x-CodMon = IF cb-dmov.CodMon = 1 THEN "S/." ELSE "US$".
 *                  x-NomCli = cb-dmov.GloDoc.
 *                  x-Ruc    = cb-dmov.NroRuc.
 *                  x-CodRef = cb-dmov.CodRef.
 *                  x-NroRef = cb-dmov.NroRef.
 *                  FIND GN-CLIE WHERE 
 *                       GN-CLIE.CodCia = 0 AND
 *                       GN-CLIE.codcli = cb-dmov.CodAux and 
 *                       GN-CLIE.codcli <> '' NO-LOCK NO-ERROR.
 *                  IF AVAILABLE GN-CLIE THEN x-NomCli = GN-CLIE.NomCli.
 *                  ELSE x-NomCli = cb-dmov.GloDoc.
 *               END.*/
              
              IF LAST-OF (cb-dmov.CodDiv) THEN DO :
                 CREATE Registro.
                 Registro.CodDiv = x-CodDiv.
                 Registro.NroAst = x-NroAst.
                 Registro.FchDoc = x-FchDoc.
                 Registro.CodDoc = x-CodDoc.
                 CASE x-CodDoc :
                      WHEN "08" THEN Registro.NotDeb = x-NroDoc.
                      WHEN "08" THEN Registro.NotCre = x-NroDoc.
                      OTHERWISE Registro.NroDoc = x-NroDoc.
                 END CASE.
                 Registro.NroDoc = x-NroDoc.
                 Registro.CodRef = x-CodRef.
                 Registro.NroRef = x-NroRef.
                 Registro.Ruc    = x-Ruc.
                 Registro.NomCli = x-NomCli.
                 Registro.CodMon = x-CodMon.
                 Registro.Cco    = x-Cco.
                 Registro.ImpLin[1] = x-Import[1].
                 Registro.ImpLin[2] = x-Import[2].
                 Registro.ImpLin[3] = x-Import[3].
                 Registro.ImpLin[4] = x-Import[4].
                 Registro.ImpLin[5] = x-Import[5].
                 Registro.ImpLin[6] = x-Import[6].
                 Registro.ImpLin[9] = x-Import[9].
                 /* PARCHE 23.05.07 */
                 Registro.ImpLin[1] = Registro.ImpLin[2] + Registro.ImpLin[3] + Registro.ImpLin[4].
              END.
              
          END. /* FIN DEL FOR cb-dmov */        
                                     
      END. /* FIN DEL FOR cb-cmov */
      
   END. /* FIN DEL DO */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CAPTURA-1 D-Dialog 
PROCEDURE CAPTURA-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR i        AS INTEGER NO-UNDO.
  DEFINE VAR ii       AS INTEGER NO-UNDO.
  DEFINE VAR iii      AS INTEGER NO-UNDO.
  DEFINE VAR x-Debe   AS DECIMAL NO-UNDO.
  DEFINE VAR x-Haber  AS DECIMAL NO-UNDO.
  DEFINE VAR y-Debe   AS DECIMAL NO-UNDO.
  DEFINE VAR y-Haber  AS DECIMAL NO-UNDO.
  DEFINE VAR x-Cco    AS CHAR    NO-UNDO.

  DEFINE VAR x-CodCta AS CHAR.

  DISPLAY WITH FRAME F-Proceso.

  EMPTY TEMP-TABLE Registro.
  DO i = 1 TO NUM-ENTRIES(s-CodOpe) :
      x-codope = ENTRY(i, s-CodOpe).
      FOR EACH cb-cmov NO-LOCK WHERE cb-cmov.CodCia  = s-CodCia  AND
                                     cb-cmov.Periodo = s-Periodo AND
                                     cb-cmov.NroMes  = s-NroMes  AND
                                     cb-cmov.CodOpe  = x-CodOpe
                                     BREAK BY cb-cmov.NroAst :
                                     
          x-NroAst = cb-cmov.NroAst.
          DISPLAY cb-cmov.NroAst @ Fi-Mensaje WITH FRAME F-Proceso.

          FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.CodCia  = cb-cmov.CodCia  AND
                                         cb-dmov.Periodo = cb-cmov.Periodo AND
                                         cb-dmov.NroMes  = cb-cmov.NroMes  AND
                                         cb-dmov.CodOpe  = cb-cmov.CodOpe  AND
                                         cb-dmov.NroAst  = cb-cmov.NroAst  AND
                                         cb-dmov.CodDoc <> ''              AND
                                         (x-Div = '' OR cb-dmov.CodDiv = x-Div)
                                         BREAK BY cb-dmov.CodDoc BY cb-dmov.nrodoc :
              IF FIRST-OF(cb-dmov.CodDoc) OR FIRST-OF(cb-dmov.nrodoc) THEN DO :
                 x-Import[1] = 0.
                 x-Import[2] = 0.
                 x-Import[3] = 0.
                 x-Import[4] = 0.
                 x-Import[5] = 0.
                 x-Import[6] = 0.
                 x-Import[9] = 0.
                 x-CodDiv = cb-dmov.CodDiv.
                 x-Cco    = ''.
              END.
              IF NOT tpomov THEN DO:
                 y-debe  = ImpMn2.
                 y-haber = 0.
                 CASE c-codmon:
                 WHEN 1 THEN DO:
                      x-debe  = ImpMn1.
                      x-haber = 0.
                 END.
                 WHEN 2 THEN DO:
                      x-debe  = ImpMn2.
                      x-haber = 0.
                 END.
                 END CASE.
              END.
              ELSE DO:      
                  y-haber = ImpMn2.
                  y-Debe  = 0.
                  CASE c-codmon:
                  WHEN 1 THEN DO:
                      x-debe  = 0.
                      x-haber = ImpMn1.
                  END.
                  WHEN 2 THEN DO:
                      x-debe  = 0.
                      x-haber = ImpMn2.
                  END.
                  END CASE.            
              END.
              
              x-Cco = IF x-Cco = '' THEN Cb-Dmov.Cco ELSE x-Cco.
              
              DO ii = 1 TO NUM-ENTRIES(C-BIMP) :
                 x-CodCta = TRIM (ENTRY(ii,C-BIMP)).
                 IF cb-dmov.CodCta BEGINS x-CodCta THEN DO :                    
                    IF cb-dmov.TM = 1 THEN DO :
                       x-Import[1] = x-Import[1] + (x-Haber - x-Debe).
                       x-Import[4] = x-Import[4] + (x-Haber - x-Debe).
                    END.   
                    IF cb-dmov.TM = 2 THEN DO :
                       x-Import[2] = x-Import[2] + (x-Haber - x-Debe).
                    END.   
                    /*MESSAGE x-import[1] cb-dmov.codcta x-codcta cb-dmov.tm x-haber x-debe.*/
                 END.
              END.   
              
              IF C-ISC <> '' AND 
                 (cb-dmov.CodCta BEGINS C-ISC OR 
                 LOOKUP(cb-dmov.CodCta,C-ISC) > 0)
                 THEN DO :
                 x-Import[3] = x-Import[3] + (x-Haber - x-Debe).
              END.  
                   
              IF cb-dmov.CodCta BEGINS C-IGV OR 
                 LOOKUP(cb-dmov.CodCta,C-IGV) > 0 THEN DO :
                 x-Import[5] = x-Import[5] + (x-Haber - x-Debe).
              END.  

              DO iii = 1 TO NUM-ENTRIES(C-TOT):
                x-CodCta = TRIM (ENTRY(iii,C-TOT)).
                IF Cb-dmov.codcta BEGINS x-CodCta THEN DO:
                    x-Import[6] = x-Import[6] + (x-Debe - x-Haber).
                    x-import[9] = x-import[9] + (y-Debe - y-Haber).
                    x-FchDoc = cb-dmov.FchDoc.
                    x-CodDoc = cb-dmov.CodDoc.
                    x-NroDoc = cb-dmov.NroDoc.
                    x-CodMon = IF cb-dmov.CodMon = 1 THEN "S/." ELSE "US$".
                    x-NomCli = cb-dmov.GloDoc.
                    x-Ruc    = cb-dmov.NroRuc.
                    x-CodRef = cb-dmov.CodRef.
                    x-NroRef = cb-dmov.NroRef.

                    FIND GN-CLIE WHERE 
                        GN-CLIE.CodCia = cl-codcia AND
                        /*****
                        GN-CLIE.codcli = cb-dmov.CodAux and 
                        *****/
/*RD01*/                GN-CLIE.codcli = cb-dmov.NroRuc and 
                        GN-CLIE.codcli <> '' NO-LOCK NO-ERROR.
                    IF AVAILABLE GN-CLIE THEN x-NomCli = GN-CLIE.NomCli.
                    ELSE x-NomCli = cb-dmov.GloDoc.                    
                END.
              END.
              IF LAST-OF(cb-dmov.CodDoc) OR LAST-OF(cb-dmov.nrodoc) THEN DO :
                 CREATE Registro.
                 Registro.CodDiv = x-CodDiv.
                 Registro.NroAst = x-NroAst.
                 Registro.FchDoc = x-FchDoc.
                 Registro.CodDoc = x-CodDoc.
                 CASE x-CodDoc :
                      WHEN "08" THEN Registro.NotDeb = x-NroDoc.
                      WHEN "07" THEN Registro.NotCre = x-NroDoc.
                      OTHERWISE Registro.NroDoc = x-NroDoc.
                 END CASE.
                 Registro.NroDoc = x-NroDoc.
                 Registro.CodRef = x-CodRef.
                 Registro.NroRef = x-NroRef.
                 Registro.Ruc    = x-Ruc.
                 Registro.NomCli = x-NomCli.
                 Registro.CodMon = x-CodMon.
                 Registro.Cco    = x-Cco.
                 Registro.ImpLin[1] = x-Import[1].
                 Registro.ImpLin[2] = x-Import[2].
                 Registro.ImpLin[3] = x-Import[3].
                 Registro.ImpLin[4] = x-Import[4].
                 Registro.ImpLin[5] = x-Import[5].
                 Registro.ImpLin[6] = x-Import[6].
                 Registro.ImpLin[9] = x-Import[9].
                 /* PARCHE 23.05.07 */
                 Registro.ImpLin[1] = Registro.ImpLin[2] + Registro.ImpLin[3] + Registro.ImpLin[4].
                 /* MLR 19/11/07 */
                 IF Registro.NomCli = "" THEN Registro.NomCli = cb-dmov.Glodoc.
              END.
              
          END. /* FIN DEL FOR cb-dmov */        
                                     
      END. /* FIN DEL FOR cb-cmov */
      
   END. /* FIN DEL DO */

    HIDE FRAME F-Proceso.

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
  DISPLAY C-CodMon x-Div s-CodOpe TOGGLE-1 
      WITH FRAME D-Dialog.
  ENABLE RECT-20 RECT-12 C-CodMon x-Div s-CodOpe TOGGLE-1 Btn_OK Btn_Cancel 
         BUTTON-2 BUTTON-1 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel D-Dialog 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* Encabezados */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = s-Titulo1.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = s-Titulo2.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = s-Titulo3.
    /* set the column names for the Worksheet */
    iCount = iCount + 2.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "División".
    chWorkSheet:Columns("A"):NumberFormat = "@".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro. Asiento".
    chWorkSheet:Columns("B"):NumberFormat = "@".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha de Emisión".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod. Doc.".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro. Serie".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro. Doc.".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod. Doc.".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro. Serie".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro. Referencia".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro. RUC".
    chWorkSheet:Columns("J"):NumberFormat = "@".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cliente".
    chWorkSheet:Columns("K"):NumberFormat = "@".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Valor Venta".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "Importe Exonerado".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "ISC".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "Base Imponible".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "IGV / IPM".
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = "Importe Total".
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = "Importe Total US$".

    /* IMPRESION */
    RUN Formato-1.

    FIND FIRST w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    FOR EACH w-report WHERE w-report.task-no = s-task-no AND w-report.Llave-C = s-user-id:
        /*BREAK BY campo-c[1] BY campo-c[2] BY campo-c[3] BY campo-c[4]:*/
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = campo-c[2].
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = campo-c[5].
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = campo-d[1].
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = campo-c[3].
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = campo-c[6].
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = campo-c[7].
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = campo-c[8].
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = campo-c[9].
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = campo-c[10].
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = campo-c[11].
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = campo-c[12].
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = campo-f[1].
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = campo-f[2].
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = campo-f[3].
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = campo-f[4].
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = campo-f[5].
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = campo-f[6].
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = campo-f[9].
/*         ACCUMULATE campo-f[1] (SUB-TOTAL BY campo-c[1]). */
/*         ACCUMULATE campo-f[2] (SUB-TOTAL BY campo-c[1]). */
/*         ACCUMULATE campo-f[3] (SUB-TOTAL BY campo-c[1]). */
/*         ACCUMULATE campo-f[4] (SUB-TOTAL BY campo-c[1]). */
/*         ACCUMULATE campo-f[5] (SUB-TOTAL BY campo-c[1]). */
/*         ACCUMULATE campo-f[6] (SUB-TOTAL BY campo-c[1]). */
/*         ACCUMULATE campo-f[9] (SUB-TOTAL BY campo-c[1]). */
/*         ACCUMULATE campo-f[1] (SUB-TOTAL BY campo-c[2]). */
/*         ACCUMULATE campo-f[2] (SUB-TOTAL BY campo-c[2]). */
/*         ACCUMULATE campo-f[3] (SUB-TOTAL BY campo-c[2]). */
/*         ACCUMULATE campo-f[4] (SUB-TOTAL BY campo-c[2]). */
/*         ACCUMULATE campo-f[5] (SUB-TOTAL BY campo-c[2]). */
/*         ACCUMULATE campo-f[6] (SUB-TOTAL BY campo-c[2]). */
/*         ACCUMULATE campo-f[9] (SUB-TOTAL BY campo-c[2]). */
/*         ACCUMULATE campo-f[1] (SUB-TOTAL BY campo-c[3]). */
/*         ACCUMULATE campo-f[2] (SUB-TOTAL BY campo-c[3]). */
/*         ACCUMULATE campo-f[3] (SUB-TOTAL BY campo-c[3]). */
/*         ACCUMULATE campo-f[4] (SUB-TOTAL BY campo-c[3]). */
/*         ACCUMULATE campo-f[5] (SUB-TOTAL BY campo-c[3]). */
/*         ACCUMULATE campo-f[6] (SUB-TOTAL BY campo-c[3]). */
/*         ACCUMULATE campo-f[9] (SUB-TOTAL BY campo-c[3]). */
/*         IF LAST-OF(campo-c[3]) THEN DO:                                                 */
/*             iCount = iCount + 1.                                                        */
/*             cColumn = STRING(iCount).                                                   */
/*             cRange = "K" + cColumn.                                                     */
/*             chWorkSheet:Range(cRange):Value = 'TOTAL ' + campo-c[3].                    */
/*             cRange = "L" + cColumn.                                                     */
/*             chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY campo-c[3] campo-f[1]. */
/*             cRange = "M" + cColumn.                                                     */
/*             chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY campo-c[3] campo-f[2]. */
/*             cRange = "N" + cColumn.                                                     */
/*             chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY campo-c[3] campo-f[3]. */
/*             cRange = "P" + cColumn.                                                     */
/*             chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY campo-c[3] campo-f[4]. */
/*             cRange = "Q" + cColumn.                                                     */
/*             chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY campo-c[3] campo-f[5]. */
/*             cRange = "R" + cColumn.                                                     */
/*             chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY campo-c[3] campo-f[6]. */
/*         END.                                                                            */
/*         IF LAST-OF(campo-c[2]) THEN DO:                                                 */
/*             iCount = iCount + 1.                                                        */
/*             cColumn = STRING(iCount).                                                   */
/*             cRange = "K" + cColumn.                                                     */
/*             chWorkSheet:Range(cRange):Value = 'TOTAL POR DIVISION ' + campo-c[2].       */
/*             cRange = "L" + cColumn.                                                     */
/*             chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY campo-c[2] campo-f[1]. */
/*             cRange = "M" + cColumn.                                                     */
/*             chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY campo-c[2] campo-f[2]. */
/*             cRange = "N" + cColumn.                                                     */
/*             chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY campo-c[2] campo-f[3]. */
/*             cRange = "P" + cColumn.                                                     */
/*             chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY campo-c[2] campo-f[4]. */
/*             cRange = "Q" + cColumn.                                                     */
/*             chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY campo-c[2] campo-f[5]. */
/*             cRange = "R" + cColumn.                                                     */
/*             chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY campo-c[2] campo-f[6]. */
/*         END.                                                                            */
/*         IF LAST-OF(campo-c[1]) THEN DO:                                                 */
/*             iCount = iCount + 1.                                                        */
/*             cColumn = STRING(iCount).                                                   */
/*             cRange = "K" + cColumn.                                                     */
/*             chWorkSheet:Range(cRange):Value = 'TOTAL GENERAL'.                          */
/*             cRange = "L" + cColumn.                                                     */
/*             chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY campo-c[1] campo-f[1]. */
/*             cRange = "M" + cColumn.                                                     */
/*             chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY campo-c[1] campo-f[2]. */
/*             cRange = "N" + cColumn.                                                     */
/*             chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY campo-c[1] campo-f[3]. */
/*             cRange = "P" + cColumn.                                                     */
/*             chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY campo-c[1] campo-f[4]. */
/*             cRange = "Q" + cColumn.                                                     */
/*             chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY campo-c[1] campo-f[5]. */
/*             cRange = "R" + cColumn.                                                     */
/*             chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY campo-c[1] campo-f[6]. */
/*         END.                                                                            */
    END.
/*     FOR EACH w-report WHERE              */
/*         w-report.task-no = s-task-no AND */
/*         w-report.Llave-C = s-user-id:    */
/*         DELETE w-report.                 */
/*     END.                                 */


    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FORMATO D-Dialog 
PROCEDURE FORMATO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-Miluska AS CHAR NO-UNDO.
DEF VAR x-CodDoc  AS CHAR NO-UNDO.

 DEFINE VAR Titulo1 AS CHAR FORMAT "X(230)".
 DEFINE VAR Titulo2 AS CHAR FORMAT "X(230)".
 DEFINE VAR Titulo3 AS CHAR FORMAT "X(230)".
 DEFINE VAR VAN     AS DECI EXTENT 10.
 DEFINE VAR X-LLAVE AS LOGICAL.
  
 RUN CAPTURA.
 
 RUN bin/_mes.p ( INPUT s-NroMes  , 1, OUTPUT x-DesMes ).     
 
 Titulo1 = "R E G I S T R O  D E  V E N T A S".
 Titulo2 = "DEL MES DE " + x-DesMes.
 Titulo3 = "EXPRESADO EN " + IF C-CodMon = 1 THEN "NUEVOS SOLES" ELSE "DOLARES AMERICANOS".
 
 
 RUN BIN/_centrar.p ( INPUT Titulo1, 230, OUTPUT Titulo1).
 RUN BIN/_centrar.p ( INPUT Titulo2, 230, OUTPUT Titulo2).
 RUN BIN/_centrar.p ( INPUT Titulo3, 230, OUTPUT Titulo3).
 
 DEFINE FRAME f-cab
       Registro.CodDiv    COLUMN-LABEL "División"
       Registro.NroAst    COLUMN-LABEL "Nro.Ast"
       Registro.FchDoc    COLUMN-LABEL "Fecha de!Emisión"
       Registro.CodDoc    COLUMN-LABEL "Cod.!Doc." FORMAT "X(4)"
       Registro.NroDoc    COLUMN-LABEL "Nro.!Documento" FORMAT "999-9999999"
       Registro.NroRef    COLUMN-LABEL "Nro.!Referencia" FORMAT "999-9999999"
       /*x-Miluska COLUMN-LABEL "Nro.!Referencia" FORMAT "999-9999999"*/
       /*x-Miluska          COLUMN-LABEL "Cco" FORMAT "x(11)"*/
       Registro.NotDeb    COLUMN-LABEL "Notas de!Debito" FORMAT "999-9999999"
       Registro.NotCre    COLUMN-LABEL "Notas de!Credito" FORMAT "999-9999999"
       Registro.Ruc       COLUMN-LABEL "Nro.!R.U.C." FORMAT "X(11)"
       Registro.NomCli    COLUMN-LABEL "C l i e n t e" FORMAT "X(40)"
       Registro.CodMon    COLUMN-LABEL "Mon" FORMAT "X(3)"
       Registro.ImpLin[1] COLUMN-LABEL "Valor!Venta" FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[2] COLUMN-LABEL "Importe!Exonerado" FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[3] COLUMN-LABEL "I.S.C" FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[4] COLUMN-LABEL "Base!Imponible" FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[5] COLUMN-LABEL "I.G.V.!I.P.M." FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[6] COLUMN-LABEL "Importe!Total" FORMAT "(>>>,>>>,>>9.99)"       
       Registro.ImpLin[9] COLUMN-LABEL "Importe!Total" FORMAT "(>>>,>>>,>>9.99)"       
       HEADER
       S-NOMCIA FORMAT "X(60)" 
       /*"FECHA  : " TO 163 TODAY */
       "PAGINA : " TO 193 PAGE-NUMBER(REPORT) FORMAT "ZZ9"        
       Titulo1 
       Titulo2 SKIP 
       Titulo3 SKIP(2)               
       "-------- -------- -------- ---- ----------- ----------- ----------- ----------- ----------- ---------------------------------------- --- ---------------- ---------------- ---------------- ---------------- ---------------- ---------------- ----------------"
       "                  Fecha de Cod. Nro.        Nro.        Notas de    Notas de    Nro.                                                                Valor          Importe                              Base           I.G.V.          Importe   Importe Total "
       "División Nro.Ast  Emisión  Doc. Documento   Referencia  Debito      Credito     R.U.C.      C l i e n t e                            Mon            Venta        Exonerado            I.S.C        Imponible           I.P.M.            Total       US$       "
       "-------- -------- -------- ---- ----------- ----------- ----------- ----------- ----------- ---------------------------------------- --- ---------------- ---------------- ---------------- ---------------- ---------------- ---------------- ----------------"
       WITH WIDTH 255 NO-BOX STREAM-IO NO-LABELS NO-UNDERLINE DOWN.
    
 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
 
 PUT STREAM REPORT CONTROL CHR(27) "@".
 PUT STREAM REPORT CONTROL CHR(27) "C" CHR(66).
 PUT STREAM REPORT CONTROL CHR(27) CHR(120) 0.
 PUT STREAM REPORT CONTROL CHR(15).
 PUT STREAM REPORT CONTROL {&PRN4}.
 FOR EACH Registro BREAK BY Registro.CodCia BY Registro.CodDiv BY Registro.CodDoc BY Registro.NroDoc:
     IF FIRST-OF (Registro.CodDiv) THEN DO :
     END.
     IF PAGE-NUMBER(REPORT) > 1 AND X-LLAVE = TRUE THEN DO:
        DISPLAY STREAM REPORT  
                 "V I E N E N  . . . . . . . . "  @ Registro.NomCli    
                 Van[1]  @ Registro.ImpLin[1] 
                 Van[2]  @ Registro.ImpLin[2] 
                 Van[3]  @ Registro.ImpLin[3] 
                 Van[4]  @ Registro.ImpLin[4] 
                 Van[5]  @ Registro.ImpLin[5] 
                 Van[6]  @ Registro.ImpLin[6] 
                 WITH FRAME F-cab.
        DOWN STREAM REPORT 2 WITH FRAME F-cab.
        X-LLAVE = FALSE.
     END.
CASE Registro.CodDoc:
    WHEN '01' THEN x-coddoc = 'FAC'.
    WHEN '03' THEN x-coddoc = 'BOL'.
    WHEN '07' THEN x-coddoc = 'N/C'.
    WHEN '08' THEN x-coddoc = 'N/D'.
    OTHERWISE x-coddoc = ''.
END CASE.    

FIND ccbcdocu where ccbcdocu.codcia = s-codcia 
    AND ccbcdocu.coddoc = x-coddoc
    AND ccbcdocu.nrodoc = Registro.nrodoc
    NO-LOCK NO-ERROR.
IF AVAILABLE ccbcdocu THEN x-Miluska = ccbcdocu.codven.
ELSE x-Miluska = Registro.NroRef.
/*x-Miluska = Registro.cco.*/

     DISPLAY STREAM REPORT  
             Registro.CodDiv
             Registro.NroAst    
             Registro.FchDoc    
             Registro.CodDoc    
             Registro.NroDoc    
             Registro.NroRef
             /*x-Miluska*/
             Registro.Ruc           WHEN NOT ( Registro.CodDoc = '03' OR (AVAILABLE ccbcdocu AND ccbcdocu.codref = 'BOL') )
             Registro.NomCli    
             Registro.CodMon    
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] 
             Registro.ImpLin[9] WHEN Registro.ImpLin[9] > 0 
             WITH FRAME F-CAB. 
     
     ACCUMULATE Registro.ImpLin[1] ( SUB-TOTAL BY Registro.CodCia ).
     ACCUMULATE Registro.ImpLin[2] ( SUB-TOTAL BY Registro.CodCia ).
     ACCUMULATE Registro.ImpLin[3] ( SUB-TOTAL BY Registro.CodCia ).
     ACCUMULATE Registro.ImpLin[4] ( SUB-TOTAL BY Registro.CodCia ).
     ACCUMULATE Registro.ImpLin[5] ( SUB-TOTAL BY Registro.CodCia ).
     ACCUMULATE Registro.ImpLin[6] ( SUB-TOTAL BY Registro.CodCia ).
     
     ACCUMULATE Registro.ImpLin[1] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[2] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[3] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[4] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[5] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[6] ( SUB-TOTAL BY Registro.CodDiv ).
     
     ACCUMULATE Registro.ImpLin[1] ( SUB-TOTAL BY Registro.CodDoc ).
     ACCUMULATE Registro.ImpLin[2] ( SUB-TOTAL BY Registro.CodDoc ).
     ACCUMULATE Registro.ImpLin[3] ( SUB-TOTAL BY Registro.CodDoc ).
     ACCUMULATE Registro.ImpLin[4] ( SUB-TOTAL BY Registro.CodDoc ).
     ACCUMULATE Registro.ImpLin[5] ( SUB-TOTAL BY Registro.CodDoc ).
     ACCUMULATE Registro.ImpLin[6] ( SUB-TOTAL BY Registro.CodDoc ).
     
     Van[1] = Van[1] + Registro.ImpLin[1].
     Van[2] = Van[2] + Registro.ImpLin[2].
     Van[3] = Van[3] + Registro.ImpLin[3].
     Van[4] = Van[4] + Registro.ImpLin[4].
     Van[5] = Van[5] + Registro.ImpLin[5].
     Van[6] = Van[6] + Registro.ImpLin[6].
     
     IF LINE-COUNTER(Report) > (PAGE-SIZE(Report) - 3) THEN DO:
        X-LLAVE = TRUE.
        DO WHILE LINE-COUNTER(Report) < PAGE-SIZE(Report) - 1 :
           PUT STREAM Report "" skip.
        END.
        UNDERLINE STREAM REPORT 
             Registro.NomCli 
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] 
             WITH FRAME F-CAB. 

        DISPLAY STREAM REPORT  
                 "V A N  . . . . . . . . "  @ Registro.NomCli    
                 Van[1]  @ Registro.ImpLin[1] 
                 Van[2]  @ Registro.ImpLin[2] 
                 Van[3]  @ Registro.ImpLin[3] 
                 Van[4]  @ Registro.ImpLin[4] 
                 Van[5]  @ Registro.ImpLin[5] 
                 Van[6]  @ Registro.ImpLin[6] 
                 WITH FRAME F-cab.
        DOWN STREAM REPORT 2 WITH FRAME F-cab.

     END.

     IF LAST-OF (Registro.CodDoc) THEN DO:
        UNDERLINE STREAM REPORT               
             Registro.NomCli                 
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] WITH FRAME F-CAB. 
             
        DISPLAY STREAM REPORT  
                 "TOTAL  " + Registro.CodDoc @ Registro.NomCli    
                 ACCUM SUB-TOTAL BY Registro.CodDoc Registro.ImpLin[1] @ Registro.ImpLin[1] 
                 ACCUM SUB-TOTAL BY Registro.CodDoc Registro.ImpLin[2] @ Registro.ImpLin[2] 
                 ACCUM SUB-TOTAL BY Registro.CodDoc Registro.ImpLin[3] @ Registro.ImpLin[3] 
                 ACCUM SUB-TOTAL BY Registro.CodDoc Registro.ImpLin[4] @ Registro.ImpLin[4] 
                 ACCUM SUB-TOTAL BY Registro.CodDoc Registro.ImpLin[5] @ Registro.ImpLin[5] 
                 ACCUM SUB-TOTAL BY Registro.CodDoc Registro.ImpLin[6] @ Registro.ImpLin[6] 
                 WITH FRAME F-CAB.             
     END.
     
     IF LAST-OF (Registro.CodDiv) THEN DO:
        UNDERLINE STREAM REPORT               
             Registro.NomCli                 
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] WITH FRAME F-CAB. 
             
        DISPLAY STREAM REPORT  
                 "TOTAL POR DIVISION " + x-CodDiv @ Registro.NomCli    
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[1] @ Registro.ImpLin[1] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[2] @ Registro.ImpLin[2] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[3] @ Registro.ImpLin[3] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[4] @ Registro.ImpLin[4] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[5] @ Registro.ImpLin[5] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[6] @ Registro.ImpLin[6] 
                 WITH FRAME F-CAB.        
     
     END.
     IF LAST-OF (Registro.CodCia) THEN DO:
        UNDERLINE STREAM REPORT               
             Registro.NomCli                 
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] WITH FRAME F-CAB. 
             
        DISPLAY STREAM REPORT  
                 "TOTAL GENERAL "  @ Registro.NomCli    
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[1] @ Registro.ImpLin[1] 
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[2] @ Registro.ImpLin[2] 
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[3] @ Registro.ImpLin[3] 
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[4] @ Registro.ImpLin[4] 
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[5] @ Registro.ImpLin[5] 
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[6] @ Registro.ImpLin[6] 
                 WITH FRAME F-CAB.        
     
     END.
 END.
 
 PAGE STREAM REPORT.
 OUTPUT STREAM REPORT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-1 D-Dialog 
PROCEDURE Formato-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR x-Miluska AS CHAR NO-UNDO.
    DEF VAR x-CodDoc  AS CHAR NO-UNDO.
    DEFINE VAR x-NroSer AS CHAR NO-UNDO.
    DEFINE VAR x-NroDoc AS CHAR NO-UNDO.
    DEFINE VAR cNomcli AS CHAR NO-UNDO.
    DEFINE VAR cRUC AS CHAR NO-UNDO.

    RUN CAPTURA-1.
    RUN bin/_mes.p ( INPUT s-NroMes  , 1, OUTPUT x-DesMes ).     
 
    s-titulo1 = "R E G I S T R O  D E  V E N T A S".
    s-titulo2 = "DEL MES DE " + x-DesMes.
    s-titulo3 = "EXPRESADO EN " + IF C-CodMon = 1 THEN "NUEVOS SOLES" ELSE "DOLARES AMERICANOS".
    s-task-no = 0.

    REPEAT:
        s-task-no = RANDOM(1, 999999).
        IF NOT CAN-FIND(FIRST w-report WHERE
            w-report.task-no = s-task-no AND
            w-report.Llave-C = s-user-id NO-LOCK) THEN LEAVE.
    END.

    FOR EACH Registro BREAK BY
        Registro.CodCia BY
        Registro.CodDiv BY
        Registro.CodDoc BY
        Registro.NroDoc:

        CASE Registro.CodDoc:
            WHEN '01' THEN x-coddoc = 'FAC'.
            WHEN '03' THEN x-coddoc = 'BOL'.
            WHEN '07' THEN x-coddoc = 'N/C'.
            WHEN '08' THEN x-coddoc = 'N/D'.
            OTHERWISE x-coddoc = ''.
        END CASE.
        FIND ccbcdocu WHERE
            ccbcdocu.codcia = s-codcia AND
            ccbcdocu.coddoc = x-coddoc AND
            ccbcdocu.nrodoc = Registro.nrodoc
            NO-LOCK NO-ERROR.
        IF AVAILABLE ccbcdocu THEN DO:
            x-Miluska = ccbcdocu.codven.
            IF LOOKUP(ccbcdocu.coddoc, "FAC,N/C,N/D") > 0 AND
                Registro.Ruc = "" THEN Registro.Ruc = ccbcdocu.ruc.
        END.
        ELSE DO:
            x-Miluska = Registro.NroRef.
        END.

        cNomCli = Registro.NomCli.
        IF Registro.NomCli = "" AND
            Registro.Ruc <> "" THEN DO:
            FIND GN-CLIE WHERE 
                GN-CLIE.CodCia = 0 AND
                GN-CLIE.codcli = Registro.Ruc
                NO-LOCK NO-ERROR.
            IF AVAILABLE GN-CLIE THEN cNomCli = GN-CLIE.NomCli.
        END.
        ASSIGN
            x-NroSer = SUBSTRING(Registro.NroDoc,1,3)
            x-NroDoc = SUBSTRING(Registro.NroDoc,4).
        IF Registro.CodDiv = '00012' AND
            Registro.NomCli BEGINS 'TCK' THEN
            ASSIGN
                x-NroSer = 'A4UK'
                x-NroDoc = '016216'.

/*         IF s-task-no = 0 THEN REPEAT:                             */
/*             s-task-no = RANDOM(1, 999999).                        */
/*             IF NOT CAN-FIND(FIRST w-report WHERE                  */
/*                 w-report.task-no = s-task-no AND                  */
/*                 w-report.Llave-C = s-user-id NO-LOCK) THEN LEAVE. */
/*         END.                                                      */
        CREATE w-report.
        ASSIGN
            w-report.Task-No = s-task-no
            w-report.Llave-C = s-user-id
            w-report.Campo-C[1] = Registro.CodCia
            w-report.Campo-C[2] = Registro.CodDiv
            w-report.Campo-C[3] = Registro.CodDoc
            w-report.Campo-C[4] = Registro.nrodoc
            w-report.Campo-C[5] = Registro.NroAst
            w-report.Campo-D[1] = Registro.FchDoc
            w-report.Campo-C[6] = x-NroSer
            w-report.Campo-C[7] = x-NroDoc
            w-report.Campo-C[8] = Registro.CodRef                
            w-report.Campo-C[9] = SUBSTRING(Registro.NroRef,1,3)
            w-report.Campo-C[10] = SUBSTRING(Registro.NroRef,4)
            w-report.Campo-C[11] = IF NOT (Registro.CodDoc = '03' OR (AVAILABLE ccbcdocu AND ccbcdocu.codref = 'BOL')) THEN Registro.Ruc ELSE ""
            w-report.Campo-C[12] = cNomCli
            w-report.Campo-F[1] = Registro.ImpLin[1] 
            w-report.Campo-F[2] = Registro.ImpLin[2] 
            w-report.Campo-F[3] = Registro.ImpLin[3] 
            w-report.Campo-F[4] = Registro.ImpLin[4] 
            w-report.Campo-F[5] = Registro.ImpLin[5] 
            w-report.Campo-F[6] = Registro.ImpLin[6] 
            w-report.Campo-F[9] = IF Registro.ImpLin[9] > 0 THEN Registro.ImpLin[9] ELSE 0
            w-report.Campo-L[1] = NOT LAST(Registro.CodCia).

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-2 D-Dialog 
PROCEDURE Formato-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR Titulo1 AS CHAR FORMAT "X(230)".
 DEFINE VAR Titulo2 AS CHAR FORMAT "X(230)".
 DEFINE VAR Titulo3 AS CHAR FORMAT "X(230)".
 DEFINE VAR VAN     AS DECI EXTENT 10.
 DEFINE VAR X-LLAVE AS LOGICAL.
  
 RUN CAPTURA.
 
 RUN bin/_mes.p ( INPUT s-NroMes  , 1, OUTPUT x-DesMes ).     
 
 Titulo1 = "R E G I S T R O  D E  V E N T A S".
 Titulo2 = "DEL MES DE " + x-DesMes.
 Titulo3 = "EXPRESADO EN " + IF C-CodMon = 1 THEN "NUEVOS SOLES" ELSE "DOLARES AMERICANOS".
  
 RUN BIN/_centrar.p ( INPUT Titulo1, 230, OUTPUT Titulo1).
 RUN BIN/_centrar.p ( INPUT Titulo2, 230, OUTPUT Titulo2).
 RUN BIN/_centrar.p ( INPUT Titulo3, 230, OUTPUT Titulo3).
 
 DEFINE FRAME f-cab
       Registro.CodDiv    COLUMN-LABEL "División"
       Registro.NroAst    COLUMN-LABEL "Nro.Ast"
       Registro.FchDoc    COLUMN-LABEL "Fecha de!Emisión"
       Registro.CodDoc    COLUMN-LABEL "Cod.!Doc." FORMAT "X(4)"
       Registro.NroDoc    COLUMN-LABEL "Nro.!Documento" FORMAT "999-9999999"
       Registro.NroRef    COLUMN-LABEL "Nro.!Referencia" FORMAT "999-9999999"
       Registro.NotDeb    COLUMN-LABEL "Notas de!Debito" FORMAT "999-9999999"
       Registro.NotCre    COLUMN-LABEL "Notas de!Credito" FORMAT "999-9999999"
       Registro.Ruc       COLUMN-LABEL "Nro.!R.U.C." FORMAT "X(11)"
       Registro.NomCli    COLUMN-LABEL "C l i e n t e" FORMAT "X(40)"
       Registro.CodMon    COLUMN-LABEL "Mon" FORMAT "X(3)"
       Registro.ImpLin[1] COLUMN-LABEL "Valor!Venta" FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[2] COLUMN-LABEL "Importe!Exonerado" FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[3] COLUMN-LABEL "I.S.C" FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[4] COLUMN-LABEL "Base!Imponible" FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[5] COLUMN-LABEL "I.G.V.!I.P.M." FORMAT "(>>>,>>>,>>9.99)"
       Registro.ImpLin[6] COLUMN-LABEL "Importe!Total" FORMAT "(>>>,>>>,>>9.99)"       
       Registro.ImpLin[9] COLUMN-LABEL "Importe!Total" FORMAT "(>>>,>>>,>>9.99)"       
       HEADER
       S-NOMCIA FORMAT "X(60)" 
       "PAGINA : " TO 193 c-Pagina FORMAT "ZZ9"  
       Titulo1 
       Titulo2 SKIP 
       Titulo3 SKIP(2)               
       "-------- -------- -------- ---- ----------- ----------- ----------- ----------- ----------- ---------------------------------------- --- ---------------- ---------------- ---------------- ---------------- ---------------- ---------------- ----------------"
       "                  Fecha de Cod. Nro.        Nro.        Notas de    Notas de    Nro.                                                                Valor          Importe                              Base           I.G.V.          Importe   Importe Total "
       "División Nro.Ast  Emisión  Doc. Documento   Referencia  Debito      Credito     R.U.C.      C l i e n t e                            Mon            Venta        Exonerado            I.S.C        Imponible           I.P.M.            Total       US$       "
       "-------- -------- -------- ---- ----------- ----------- ----------- ----------- ----------- ---------------------------------------- --- ---------------- ---------------- ---------------- ---------------- ---------------- ---------------- ----------------"
       WITH WIDTH 255 NO-BOX STREAM-IO NO-LABELS NO-UNDERLINE DOWN.
    
 FOR EACH Registro NO-LOCK BREAK BY Registro.CodCia BY Registro.CodDiv BY Registro.CodDoc BY Registro.NroDoc
     ON ERROR UNDO, RETURN ERROR:
     ACCUMULATE Registro.ImpLin[1] ( SUB-TOTAL BY Registro.CodCia ).
     ACCUMULATE Registro.ImpLin[2] ( SUB-TOTAL BY Registro.CodCia ).
     ACCUMULATE Registro.ImpLin[3] ( SUB-TOTAL BY Registro.CodCia ).
     ACCUMULATE Registro.ImpLin[4] ( SUB-TOTAL BY Registro.CodCia ).
     ACCUMULATE Registro.ImpLin[5] ( SUB-TOTAL BY Registro.CodCia ).
     ACCUMULATE Registro.ImpLin[6] ( SUB-TOTAL BY Registro.CodCia ).
     
     ACCUMULATE Registro.ImpLin[1] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[2] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[3] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[4] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[5] ( SUB-TOTAL BY Registro.CodDiv ).
     ACCUMULATE Registro.ImpLin[6] ( SUB-TOTAL BY Registro.CodDiv ).
     
     IF LAST-OF (Registro.CodDiv) THEN DO:
        {&NEW-PAGE}.
        DISPLAY STREAM REPORT  
                 Registro.CodDiv
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[1] @ Registro.ImpLin[1] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[2] @ Registro.ImpLin[2] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[3] @ Registro.ImpLin[3] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[4] @ Registro.ImpLin[4] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[5] @ Registro.ImpLin[5] 
                 ACCUM SUB-TOTAL BY Registro.CodDiv Registro.ImpLin[6] @ Registro.ImpLin[6] 
                 WITH FRAME F-CAB.        
     
     END.
     IF LAST-OF (Registro.CodCia) THEN DO:
        {&NEW-PAGE}.
        UNDERLINE STREAM REPORT               
             Registro.CodDiv
             Registro.NomCli                 
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] WITH FRAME F-CAB. 
        {&NEW-PAGE}.
        DISPLAY STREAM REPORT  
                 "TOTAL GENERAL "  @ Registro.NomCli    
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[1] @ Registro.ImpLin[1] 
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[2] @ Registro.ImpLin[2] 
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[3] @ Registro.ImpLin[3] 
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[4] @ Registro.ImpLin[4] 
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[5] @ Registro.ImpLin[5] 
                 ACCUM SUB-TOTAL BY Registro.CodCia Registro.ImpLin[6] @ Registro.ImpLin[6] 
                 WITH FRAME F-CAB.        
     
     END.
 END.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR D-Dialog 
PROCEDURE IMPRIMIR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN Formato-1.

    FIND FIRST w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "CBD\RBCBD.PRL"
        RB-REPORT-NAME = "REGISTRO DE VENTAS DRAFT"
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER =
            "w-report.task-no = " + STRING(s-task-no) +
            " AND w-report.Llave-C = '" + s-user-id + "'"
        RB-OTHER-PARAMETERS =
            "s-nomcia = " + s-nomcia +
            "~ns-titulo1 = " + s-titulo1 +
            "~ns-titulo2 = " + s-titulo2 +
            "~ns-titulo3 = " + s-titulo3.

    IF TOGGLE-1 THEN RB-REPORT-NAME = "REGISTRO DE VENTAS RESUMEN DRAFT".
    ELSE RB-REPORT-NAME = "REGISTRO DE VENTAS DRAFT".

    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).

    FOR EACH w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id:
        DELETE w-report.
    END.

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
  
  FIND cb-cfgg WHERE cb-cfgg.CODCIA = cb-codcia AND cb-cfgg.CODCFG = "R02"
       NO-LOCK NO-ERROR.
  IF AVAIL cb-cfgg THEN DO:
     s-CodOpe:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cb-cfgg.codope.
  END.  
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto D-Dialog 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-Rpta    AS LOG  NO-UNDO.
 
  x-Archivo = 'Ventas' + STRING(s-Periodo, '9999') + STRING(s-NroMes, '99') + '.txt'.
  SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Texto' '*.txt'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.txt'
    INITIAL-DIR 'c:\tmp'
    RETURN-TO-START-DIR 
    USE-FILENAME
    SAVE-AS
    UPDATE x-rpta.
  IF x-rpta = NO THEN RETURN.

  RUN Formato-1.

  FIND FIRST w-report WHERE
      w-report.task-no = s-task-no AND
      w-report.Llave-C = s-user-id NO-LOCK NO-ERROR.
  IF NOT AVAILABLE w-report THEN DO:
      MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
      RETURN.
  END.
 
 DEFINE FRAME f-cab
     w-report.campo-c[2]  COLUMN-LABEL "CodDiv" FORMAT 'x(5)'
     w-report.campo-c[5]  COLUMN-LABEL "NroAst" FORMAT 'x(8)'
     w-report.campo-d[1]  COLUMN-LABEL "FchAst" FORMAT '99/99/9999'
     w-report.campo-c[3]  COLUMN-LABEL "CodDoc" FORMAT "X(3)"
     w-report.campo-c[6]  COLUMN-LABEL "NroSer" FORMAT 'x(5)'
     w-report.campo-c[7]  COLUMN-LABEL "NroDoc" FORMAT "x(11)"
     w-report.campo-c[8]  COLUMN-LABEL "CodRef" FORMAT "x(4)"
     w-report.campo-c[9]  COLUMN-LABEL "SerRef" FORMAT 'x(5)'
     w-report.campo-c[10] COLUMN-LABEL "NroRef" FORMAT 'x(11)'
     w-report.campo-c[11] COLUMN-LABEL "NroRuc" FORMAT "X(11)"
     w-report.campo-c[12] COLUMN-LABEL "NomCli" FORMAT "X(40)"
     w-report.campo-f[1] COLUMN-LABEL "ValVta" FORMAT '->>>>>>>>>.99'
     w-report.campo-f[2] COLUMN-LABEL "ImpExo" FORMAT '->>>>>>>>>.99'
     w-report.campo-f[3] COLUMN-LABEL "ImpIsc" FORMAT '->>>>>>>>>.99'
     w-report.campo-f[4] COLUMN-LABEL "BasImp" FORMAT '->>>>>>>>>.99'
     w-report.campo-f[5] COLUMN-LABEL "IgvIpm" FORMAT '->>>>>>>>>.99'
     w-report.campo-f[6] COLUMN-LABEL "ImpTot" FORMAT '->>>>>>>>>.99'
     w-report.campo-f[9] COLUMN-LABEL "ImpDol" FORMAT '->>>>>>>>>.99'
     WITH WIDTH 320 STREAM-IO NO-BOX NO-UNDERLINE DOWN.
    
  OUTPUT STREAM REPORT TO VALUE(x-Archivo).
  FOR EACH w-report NO-LOCK WHERE w-report.task-no = s-task-no 
      AND w-report.Llave-C = s-user-id
      BY w-report.campo-c[1] BY w-report.campo-c[2] BY w-report.campo-c[3] BY w-report.campo-c[4] :
      PUT STREAM REPORT
          w-report.campo-c[2]  FORMAT 'x(5)'
          w-report.campo-c[5]  FORMAT 'x(8)'
          w-report.campo-d[1]  FORMAT '99/99/9999'
          w-report.campo-c[3]  FORMAT "X(3)"
          w-report.campo-c[6]  FORMAT 'x(5)'
          w-report.campo-c[7]  FORMAT "x(11)"
          w-report.campo-c[8]  FORMAT "x(4)"
          w-report.campo-c[9]  FORMAT 'x(5)'
          w-report.campo-c[10] FORMAT 'x(11)'
          w-report.campo-c[11] FORMAT "X(11)"
          w-report.campo-c[12] FORMAT "X(40)"
          w-report.campo-f[1] FORMAT '->>>>>>>>>.99'
          w-report.campo-f[2] FORMAT '->>>>>>>>>.99'
          w-report.campo-f[3] FORMAT '->>>>>>>>>.99'
          w-report.campo-f[4] FORMAT '->>>>>>>>>.99'
          w-report.campo-f[5] FORMAT '->>>>>>>>>.99'
          w-report.campo-f[6] FORMAT '->>>>>>>>>.99'
          w-report.campo-f[9] FORMAT '->>>>>>>>>.99'
          SKIP.
  END.
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

