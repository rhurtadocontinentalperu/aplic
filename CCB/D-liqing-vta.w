&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
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

/* Local Variable Definitions ---                                       */
/*
    @PRINTER2.W    VERSION 1.0
*/
{lib/def-prn.i}    
DEFINE STREAM report.
/*DEFINE VARIABLE x-Raya     AS CHARACTER FORMAT "X(145)".
DEFINE {&NEW} SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE {&NEW} SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE {&NEW} SHARED VARIABLE s-user-id  LIKE _user._userid.*/

DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
/*DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.*/
  
def var l-immediate-display  AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE T-CAJA   AS CHAR INIT "".
DEFINE VARIABLE T-CJRO   AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE SHARED VAR S-CODTER AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR.


/*** DEFINE VARIABLES SUB-TOTALES ***/
DEFINE VAR T-EFESOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
DEFINE VAR T-EFEDOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
DEFINE VAR T-CHDSOL AS DECIMAL FORMAT "->>>>>9.99"   INIT 0.  
DEFINE VAR T-CHDDOL AS DECIMAL FORMAT "->>>>>9.99"   INIT 0.
DEFINE VAR T-CHFSOL AS DECIMAL FORMAT "->>>>>9.99"   INIT 0.
DEFINE VAR T-CHFDOL AS DECIMAL FORMAT "->>>>>9.99"   INIT 0.
DEFINE VAR T-NCRSOL AS DECIMAL FORMAT "->>>>>9.99"   INIT 0.
DEFINE VAR T-NCRDOL AS DECIMAL FORMAT "->>>>>9.99"   INIT 0.  
DEFINE VAR T-DEPSOL AS DECIMAL FORMAT "->>>>>>9.99"  INIT 0.
DEFINE VAR T-DEPDOL AS DECIMAL FORMAT "->>>>>>9.99"  INIT 0.
DEFINE VAR T-MOVTO  AS CHAR INIT "".

/* define variable para subtotales" */
def var x-filename as char init "".
def var x-imptot as deci  extent 2 format ">>>,>>>,>>>,>>>,>>9.99".
def var x-sdoact as deci  extent 2 format ">>>,>>>,>>>,>>>,>>9.99".
def var x-codmon as char init "".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-49 f-desde f-hasta Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-3 f-desde f-hasta 

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

DEFINE BUTTON Btn_Help 
     IMAGE-UP FILE "img\excel":U
     LABEL "Exportar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .69
     BGCOLOR 8 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-49
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 4.15.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-3 AT ROW 1.85 COL 8.86 NO-LABEL
     f-desde AT ROW 3.88 COL 13.14 COLON-ALIGNED
     f-hasta AT ROW 3.96 COL 30.57 COLON-ALIGNED
     Btn_Cancel AT ROW 5.62 COL 24
     Btn_Help AT ROW 5.62 COL 8.57
     RECT-49 AT ROW 1 COL 1
     "Rango de Fechas" VIEW-AS TEXT
          SIZE 15.57 BY .54 AT ROW 3.15 COL 2.43
          FONT 6
     SPACE(29.42) SKIP(3.80)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Liquidación de I/C por Documentos".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   Custom                                                               */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}
{src/bin/_prns.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help D-Dialog
ON CHOOSE OF Btn_Help IN FRAME D-Dialog /* Exportar */
DO:
    x-filename = "c:\sie\" + "d-liqing" + substring(string(today,'99999999'),5,4) + substring(string(today,'99999999'),3,2) + substring(string(today,'99999999'),1,2)  + substring(string(time,'HH:MM'),1,2) + substring(string(time,'HH:MM'),4,2) + ".txt".

    ASSIGN f-Desde f-hasta .
 
  IF f-desde = ? then do:
     MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.   
  END.
  
  IF f-hasta = ? then do:
     MESSAGE "Ingrese Fecha Hasta ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-hasta.
     RETURN NO-APPLY.   
  END.   

  IF f-desde > f-hasta then do:
     MESSAGE "Rango de fechas Mal ingresado" VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.
  END.
 
 
 output to VALUE(x-filename).
 display "codven|fchdoc|coddoc|nrodoc|codcli|noncli|mon|imp S/.|imp $|sdo S/.|sdo $|estado".

   FOR EACH CcbCcaja WHERE 
          CcbcCaja.CodCia  = S-CODCIA AND 
          CcbcCaja.CodDiv  = S-CODDIV AND 
          CcbcCaja.CodDoc  = "I/C"    AND
          CcbcCaja.FchDoc >= F-desde  AND 
          CcbcCaja.FchDoc <= F-hasta 
          NO-LOCK USE-INDEX LLAVE07,
          EACH CcbDCaja OF CcbCcaja 
     BREAK BY CcbcCaja.CodCia 
           BY CcbCcaja.Tipo   
           BY CcbDcaja.NroDoc:
           
        find ccbcdocu 
            where ccbcdocu.codcia = s-codcia
            and ccbcdocu.coddoc = CcbDCaja.CodRef
            and ccbcdocu.nrodoc = CcbDCaja.NroRef 
            no-lock no-error.   

     x-imptot[1] = if ccbcdocu.codmon = 1 then ccbcdocu.imptot else 0.00.
     x-imptot[2] = if ccbcdocu.codmon = 2 then ccbcdocu.imptot else 0.00.
     x-sdoact[1] = if ccbcdocu.codmon = 1 then ccbcdocu.sdoact else 0.00.
     x-sdoact[2] = if ccbcdocu.codmon = 2 then ccbcdocu.sdoact else 0.00.
     x-codmon = if ccbcdocu.codmon = 1 then "S/." else "$".

    
    export delimiter "|"
            ccbcdocu.codven
            ccbcdocu.fchdoc
            CcbDCaja.CodRef
            CcbDCaja.NroRef
            ccbcdocu.codcli
            ccbcdocu.nomcli format "x(40)"
            x-codmon
            x-imptot[1] format ">>>,>>>,>>>,>>>,>>9.99"
            x-imptot[2] format ">>>,>>>,>>>,>>>,>>9.99"
            x-sdoact[1] format ">>>,>>>,>>>,>>>,>>9.99"
            x-sdoact[2] format ">>>,>>>,>>>,>>>,>>9.99"       
            ccbcdocu.flgest.
        
    end.
output close.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/*
 *     FILL-IN-3:screen-value = s-coddiv.
 *     f-desde:screen-value = "01/" + substring(string(today,'99/99/99'),3,5).
 *     f-hasta:screen-value = today.
 * trabajando , se contineuar mañana 
 * last-of(day).*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


