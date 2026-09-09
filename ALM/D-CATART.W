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
DEFINE {&NEW} SHARED VARIABLE xTerm AS CHARACTER INITIAL "".
DEFINE {&NEW} SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE {&NEW} SHARED VARIABLE s-user-id   LIKE _user._userid.*/

DEFINE NEW SHARED VARIABLE xTerm AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.
 
def var l-immediate-display  AS LOGICAL.
DEFINE VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE PTO       AS LOGICAL.

DEFINE VARIABLE F-TIPO   AS CHAR INIT "0".
DEFINE VARIABLE T-TITULO AS CHAR INIT "".
DEFINE VARIABLE T-TITUL1 AS CHAR INIT "".
DEFINE VARIABLE T-FAMILI AS CHAR INIT "".
DEFINE VARIABLE T-SUBFAM AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-5 RECT-54 f-filtro f-provee f-familia ~
f-marca f-subfam RADIO-SET-1 B-imprime B-cancela B-impresoras ~
RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
&Scoped-Define DISPLAYED-OBJECTS f-despro f-filtro f-provee f-desmar ~
f-desfam f-dessub f-familia f-marca f-subfam RADIO-SET-1 RB-NUMBER-COPIES ~
RB-BEGIN-PAGE RB-END-PAGE 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-archivo 
     IMAGE-UP FILE "IMG/pvstop":U
     LABEL "&Archivos.." 
     SIZE 5 BY 1.

DEFINE BUTTON B-cancela AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 13 BY 1.5.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON B-imprime AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Imprimir" 
     SIZE 13 BY 1.5.

DEFINE VARIABLE f-desfam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .69 NO-UNDO.

DEFINE VARIABLE f-desmar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.86 BY .69 NO-UNDO.

DEFINE VARIABLE f-despro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27.43 BY .69 NO-UNDO.

DEFINE VARIABLE f-dessub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.86 BY .69 NO-UNDO.

DEFINE VARIABLE f-familia AS CHARACTER FORMAT "X(256)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 6.14 BY .69 NO-UNDO.

DEFINE VARIABLE f-marca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 6.14 BY .69 NO-UNDO.

DEFINE VARIABLE f-provee AS CHARACTER FORMAT "X(8)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .69 NO-UNDO.

DEFINE VARIABLE f-subfam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sub-Familia" 
     VIEW-AS FILL-IN 
     SIZE 6.14 BY .69 NO-UNDO.

DEFINE VARIABLE RB-BEGIN-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-END-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 9999 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-NUMBER-COPIES AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "No. Copias" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-OUTPUT-FILE AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22.72 BY .69
     BGCOLOR 15 FGCOLOR 0 FONT 12 NO-UNDO.

DEFINE VARIABLE f-filtro AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Familia", 1,
"Sub-Familia ", 2,
"Marca", 3
     SIZE 33.43 BY .73
     FONT 6 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 3.38
     FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL 
     SIZE 45.29 BY 6.

DEFINE RECTANGLE RECT-54
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 45.14 BY 5.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     f-despro AT ROW 2.23 COL 8.43 COLON-ALIGNED NO-LABEL
     f-filtro AT ROW 3.08 COL 10.29 NO-LABEL
     f-provee AT ROW 1.42 COL 8.43 COLON-ALIGNED
     f-desmar AT ROW 5.58 COL 15.14 COLON-ALIGNED NO-LABEL
     f-desfam AT ROW 4.04 COL 15.14 COLON-ALIGNED NO-LABEL
     f-dessub AT ROW 4.81 COL 15.14 COLON-ALIGNED NO-LABEL
     f-familia AT ROW 4.04 COL 8.14 COLON-ALIGNED
     f-marca AT ROW 5.58 COL 8.14 COLON-ALIGNED
     f-subfam AT ROW 4.81 COL 8.14 COLON-ALIGNED
     RADIO-SET-1 AT ROW 7.5 COL 2.43 NO-LABEL
     B-imprime AT ROW 2.69 COL 48.29
     B-cancela AT ROW 6.04 COL 48.43
     B-impresoras AT ROW 8.65 COL 15.72
     b-archivo AT ROW 9.88 COL 15.86
     RB-OUTPUT-FILE AT ROW 10.08 COL 19.72 COLON-ALIGNED NO-LABEL
     RB-NUMBER-COPIES AT ROW 11.58 COL 8.86 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 11.62 COL 23.14 COLON-ALIGNED
     RB-END-PAGE AT ROW 11.58 COL 35.57 COLON-ALIGNED
     RECT-5 AT ROW 6.73 COL 1
     RECT-54 AT ROW 1.04 COL 1
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 43.72 BY .62 AT ROW 6.96 COL 1.72
          BGCOLOR 1 FGCOLOR 15 FONT 6
     "Páginas" VIEW-AS TEXT
          SIZE 8.14 BY .58 AT ROW 10.96 COL 30.14
          FONT 6
     SPACE(24.85) SKIP(1.49)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Catalogos de Materiales".


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

/* SETTINGS FOR BUTTON b-archivo IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       b-archivo:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN f-desfam IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-desmar IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-despro IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-dessub IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RB-OUTPUT-FILE IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       RB-OUTPUT-FILE:HIDDEN IN FRAME D-Dialog           = TRUE.

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

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Catalogos de Materiales */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-archivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-archivo D-Dialog
ON CHOOSE OF b-archivo IN FRAME D-Dialog /* Archivos.. */
DO:
     SYSTEM-DIALOG GET-FILE RB-OUTPUT-FILE
        TITLE      "Archivo de Impresi¢n ..."
        FILTERS    "Archivos Impresi¢n (*.txt)"   "*.txt",
                   "Todos (*.*)"   "*.*"
        INITIAL-DIR "./txt"
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
      
    IF OKpressed = TRUE THEN
        RB-OUTPUT-FILE:SCREEN-VALUE = RB-OUTPUT-FILE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-impresoras
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-impresoras D-Dialog
ON CHOOSE OF B-impresoras IN FRAME D-Dialog
DO:
    SYSTEM-DIALOG PRINTER-SETUP.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-imprime D-Dialog
ON CHOOSE OF B-imprime IN FRAME D-Dialog /* Imprimir */
DO:

  ASSIGN f-familia f-subfam f-marca f-filtro. 
 
  P-largo   = 66.
  P-Copias  = INPUT FRAME D-DIALOG RB-NUMBER-COPIES.
  P-pagIni  = INPUT FRAME D-DIALOG RB-BEGIN-PAGE.
  P-pagfin  = INPUT FRAME D-DIALOG RB-END-PAGE.
  P-select  = INPUT FRAME D-DIALOG RADIO-SET-1.
  P-archivo = INPUT FRAME D-DIALOG RB-OUTPUT-FILE.
  P-detalle = "Impresora Local (EPSON)".
  P-name    = "Epson E/F/J/RX/LQ".
  P-device  = "PRN".

  T-TITULO = " CATALOGO DE MATERIALES ".
       
  IF P-select = 2 
     THEN P-archivo = SESSION:TEMP-DIRECTORY + 
          STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
  ELSE RUN setup-print.      
     IF P-select <> 1 THEN P-copias = 1.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-familia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-familia D-Dialog
ON LEAVE OF f-familia IN FRAME D-Dialog /* Familia */
DO:
  assign f-familia.
  IF F-familia <> "" THEN DO: 
     FIND Almtfami WHERE Almtfami.CodCia = S-CODCIA AND Almtfami.Codfam = F-familia NO-LOCK NO-ERROR.
     IF AVAILABLE Almtfami THEN F-desfam = Almtfami.desfam.
  END.
  DISPLAY F-desfam WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-filtro D-Dialog
ON VALUE-CHANGED OF f-filtro IN FRAME D-Dialog
DO:
    assign f-filtro.
    CASE F-FILTRO:
         WHEN 1 THEN DO:
              f-familia:sensitive = yes.
              f-subfam :sensitive = yes.
              f-marca  :sensitive = yes.
         END.   
         WHEN 2 THEN DO:
              f-familia:sensitive = yes.
              f-subfam :sensitive = yes.
              f-marca  :sensitive = no.
         END.   
         WHEN 3 THEN DO:
              f-familia:sensitive = no.
              f-subfam :sensitive = no.
              f-marca  :sensitive = yes.
         END.   
     END CASE.     

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-marca D-Dialog
ON LEAVE OF f-marca IN FRAME D-Dialog /* Marca */
DO:
  assign f-marca.
  IF f-marca <> "" THEN DO: 
     FIND AlmTabla WHERE AlmTabla.tabla = "MK" AND AlmTabla.codigo = f-marca NO-LOCK NO-ERROR.
     IF AVAILABLE AlmTabla THEN F-desmar = AlmTabla.Nombre.
  END.
  DISPLAY f-desmar WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-subfam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-subfam D-Dialog
ON LEAVE OF f-subfam IN FRAME D-Dialog /* Sub-Familia */
DO:
  assign f-subfam.
  IF f-subfam <> "" THEN DO: 
     FIND AlmSfami WHERE AlmSfami.CodCia = S-CODCIA AND AlmSfami.Codfam = f-familia AND
     AlmSFami.subfam = f-subfam NO-LOCK NO-ERROR.
     IF AVAILABLE AlmSfami THEN F-dessub = AlmSFami.dessub.
  END.
  DISPLAY F-dessub WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 D-Dialog
ON VALUE-CHANGED OF RADIO-SET-1 IN FRAME D-Dialog
DO:
    IF SELF:SCREEN-VALUE = "3"
    THEN ASSIGN b-archivo:VISIBLE = YES
                RB-OUTPUT-FILE:VISIBLE = YES
                b-archivo:SENSITIVE = YES
                RB-OUTPUT-FILE:SENSITIVE = YES.
    ELSE ASSIGN b-archivo:VISIBLE = NO
                RB-OUTPUT-FILE:VISIBLE = NO
                b-archivo:SENSITIVE = NO
                RB-OUTPUT-FILE:SENSITIVE = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */
/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */

IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  PTO                  = SESSION:SET-WAIT-STATE("").    
  l-immediate-display  = SESSION:IMMEDIATE-DISPLAY.

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  RUN disable_UI.

  FRAME F-Mensaje:TITLE =  FRAME D-DIALOG:TITLE.
  VIEW FRAME F-Mensaje.  
  PAUSE 0.           
  SESSION:IMMEDIATE-DISPLAY = YES.

  DO c-Copias = 1 to P-copias ON ERROR UNDO, LEAVE
                                ON STOP UNDO, LEAVE:
        OUTPUT STREAM report TO NUL PAGED PAGE-SIZE 1000.
        c-Pagina = 0.
        RUN IMPRIMIR.
    OUTPUT STREAM report CLOSE.        
  END.
  OUTPUT STREAM report CLOSE.        
  SESSION:IMMEDIATE-DISPLAY =   l-immediate-display.
  
  IF NOT LASTKEY = KEYCODE("ESC") AND P-select = 2 THEN DO: 
        RUN bin/_vcat.p ( P-archivo ). 
  END.    
  HIDE FRAME F-Mensaje.  
  RETURN.
END.


RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  DISPLAY f-despro f-filtro f-provee f-desmar f-desfam f-dessub f-familia 
          f-marca f-subfam RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE 
          RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE RECT-5 RECT-54 f-filtro f-provee f-familia f-marca f-subfam 
         RADIO-SET-1 B-imprime B-cancela B-impresoras RB-NUMBER-COPIES 
         RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir D-Dialog 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   IF F-FILTRO = 3 THEN RUN LisTmar.
   ELSE RUN LisMate.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LisMate D-Dialog 
PROCEDURE LisMate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME f-cab
        Almmmatg.codfam AT 3   FORMAT "XX"
        Almmmatg.subfam AT 7   FORMAT "XXX"
        Almmmatg.CodMat AT 12  FORMAT "XXXXXX"
        Almmmatg.Desmat AT 20  FORMAT "X(48)"
        Almmmatg.UndStk AT 69  FORMAT "XXXX" 
        Almmmatg.FacEqu AT 74  FORMAT "->,>>>,>>9.99"
        Almmmatg.UndBas AT 89  FORMAT "XXXX"
        Almmmatg.CanEmp AT 95  FORMAT "->>,>>9.99" 
        Almmmatg.Pesmat AT 107 FORMAT ">,>>9.99"
        Almmmatg.FchIng AT 117
        Almmmatg.FchCes AT 128
        Almmmatg.TipArt AT 140 FORMAT "X" 

        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 107 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + T-TITULO + {&PRN6B} + {&PRN3} AT 54 FORMAT "X(45)" 
        {&PRN3} + "Fecha : " AT 121 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" SKIP
        "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        " FAM SUB  CODIGO                                                    UND   F A C T O R   UND     EMPAQUE   P E S O   F E C H A  F E C H A  TIPO" SKIP
        "     FAM ARTICULO        D E S C R I P C I O N                      STK   EQUIVALENCIA  BASE                Kg/.    MATRICULA     CESE        " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*         99  999  999999  123456789012345678901234567890123456789012345678 XXXX ->,>>>,>>9.99  XXXX  ->>,>>9.99  >,>>9.99  99/99/9999 99/99/9999  A  
           3   7    12      20                                               69   74             89    95          107       117        128         140*/
        
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.       

 FOR EACH integral.Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
          Almmmatg.Codmar BEGINS f-marca    AND
          Almmmatg.Codfam BEGINS f-familia  AND
          Almmmatg.Subfam BEGINS f-subfam  
          
     BREAK BY Almmmatg.Codfam
           BY Almmmatg.Subfam
           BY Almmmatg.CodMar
           BY Almmmatg.DesMat:
           
     {&NEW-PAGE}.           
     CASE F-FILTRO:
     WHEN 1 OR WHEN 2 THEN DO:
         /***********  x Familia  ***********/
         IF FIRST-OF(Almmmatg.Codfam) THEN DO:
            FIND AlmTfami WHERE AlmTfami.Codcia = S-CODCIA AND AlmTfami.CodFam = Almmmatg.CodFam
                 NO-LOCK NO-ERROR.
            IF AVAILABLE AlmTfami THEN do:                    
               DISPLAY STREAM REPORT
               {&PRN2} + {&PRN6A} + AlmTfami.Codfam + "- " + CAPS(AlmTfami.Desfam) + {&PRN6B} + {&PRN3} @ Almmmatg.desmat WITH FRAME F-Cab.
               DOWN STREAM REPORT 2 WITH FRAME F-Cab.
           END.    
         END.     
         /*********  x SubFamilia  **********/
         IF FIRST-OF(Almmmatg.Subfam) THEN DO:
            FIND AlmSfami WHERE AlmSfami.Codcia = S-CODCIA AND AlmSfami.CodFam = Almmmatg.CodFam
                 AND AlmSfami.Subfam = Almmmatg.Subfam NO-LOCK NO-ERROR.
            IF AVAILABLE AlmSfami THEN do:                    
               DISPLAY STREAM REPORT
               {&PRN2} + {&PRN6A} + "           " + AlmSfami.Subfam + "- " + CAPS(AlmSfami.DesSub) + {&PRN6B} + {&PRN3} @ Almmmatg.desmat  WITH FRAME F-Cab.
               DOWN STREAM REPORT 2 WITH FRAME F-Cab.
            END.    
        END.     
     END.
     END.

     /************  x Marca  ************/
     IF FIRST-OF(Almmmatg.Codmar) THEN DO:
        DISPLAY STREAM REPORT
        {&PRN2} + {&PRN7A} + {&PRN6A} + "            " + CAPS(Almmmatg.DesMar) + {&PRN6B} + {&PRN7B} + {&PRN3} @ Almmmatg.DesMat WITH FRAME F-Cab.
        DOWN STREAM REPORT 2 WITH FRAME F-Cab.
     END.     
     
     DISPLAY STREAM REPORT
        Almmmatg.codfam 
        Almmmatg.subfam 
        Almmmatg.CodMat 
        Almmmatg.Desmat 
        Almmmatg.UndStk 
        Almmmatg.FacEqu WHEN Almmmatg.FacEqu > 0
        Almmmatg.UndBas 
        Almmmatg.CanEmp 
        Almmmatg.Pesmat 
        Almmmatg.FchIng 
        Almmmatg.FchCes 
        Almmmatg.TipArt 
        WITH FRAME F-Cab.
     
     IF LAST-OF(Almmmatg.Codmar) THEN DO:
        DOWN STREAM REPORT 1 WITH FRAME F-Cab.
     END.
    
     CASE F-FILTRO:
     WHEN 1 OR WHEN 2 THEN DO:
          IF LAST-OF(Almmmatg.Subfam) THEN DO:
             DOWN STREAM REPORT 1 WITH FRAME F-Cab.
          END.
          IF LAST-OF(Almmmatg.Codfam) THEN DO:
             DOWN STREAM REPORT 1 WITH FRAME F-Cab.
          END.
     END.
     end.
 END.
 
 OUTPUT STREAM REPORT CLOSE.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LISTMAR D-Dialog 
PROCEDURE LISTMAR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME f-cab
        Almmmatg.codfam AT 3   FORMAT "XX"
        Almmmatg.subfam AT 7   FORMAT "XXX"
        Almmmatg.CodMat AT 12  FORMAT "XXXXXX"
        Almmmatg.Desmat AT 20  FORMAT "X(48)"
        Almmmatg.UndStk AT 69  FORMAT "XXXX" 
        Almmmatg.FacEqu AT 74  FORMAT "->,>>>,>>9.99"
        Almmmatg.UndBas AT 89  FORMAT "XXXX"
        Almmmatg.CanEmp AT 95  FORMAT "->>,>>9.99" 
        Almmmatg.Pesmat AT 107 FORMAT ">,>>9.99"
        Almmmatg.FchIng AT 117
        Almmmatg.FchCes AT 128
        Almmmatg.TipArt AT 140 FORMAT "X" 

        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 107 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + T-TITULO + {&PRN6B} + {&PRN3} AT 54 FORMAT "X(45)" 
        {&PRN3} + "Fecha : " AT 121 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" SKIP
        "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        " FAM SUB  CODIGO                                                    UND   F A C T O R   UND     EMPAQUE   P E S O   F E C H A  F E C H A  TIPO" SKIP
        "     FAM ARTICULO        D E S C R I P C I O N                      STK   EQUIVALENCIA  BASE                Kg/.    MATRICULA     CESE        " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*         99  999  999999  123456789012345678901234567890123456789012345678 XXXX ->,>>>,>>9.99  XXXX  ->>,>>9.99  >,>>9.99  99/99/9999 99/99/9999  A  
           3   7    12      20                                               69   74             89    95          107       117        128         140*/
        
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.       

 FOR EACH integral.Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
          Almmmatg.Codmar BEGINS f-marca    AND
          Almmmatg.Codfam BEGINS f-familia  AND
          Almmmatg.Subfam BEGINS f-subfam  
          
     BREAK BY Almmmatg.DesMar
           BY Almmmatg.DesMat:
           
     {&NEW-PAGE}.           
     
/*   CASE F-FILTRO:
     WHEN 1 OR WHEN 2 THEN DO:
         /***********  x Familia  ***********/
         IF FIRST-OF(Almmmatg.Codfam) THEN DO:
            FIND AlmTfami WHERE AlmTfami.Codcia = S-CODCIA AND AlmTfami.CodFam = Almmmatg.CodFam
                 NO-LOCK NO-ERROR.
            IF AVAILABLE AlmTfami THEN do:                    
               DISPLAY STREAM REPORT
               {&PRN2} + {&PRN6A} + AlmTfami.Codfam + "- " + CAPS(AlmTfami.Desfam) + {&PRN6B} + {&PRN3} @ Almmmatg.desmat WITH FRAME F-Cab.
               DOWN STREAM REPORT 2 WITH FRAME F-Cab.
           END.    
         END.     
         /*********  x SubFamilia  **********/
         IF FIRST-OF(Almmmatg.Subfam) THEN DO:
            FIND AlmSfami WHERE AlmSfami.Codcia = S-CODCIA AND AlmSfami.CodFam = Almmmatg.CodFam
                 AND AlmSfami.Subfam = Almmmatg.Subfam NO-LOCK NO-ERROR.
            IF AVAILABLE AlmSfami THEN do:                    
               DISPLAY STREAM REPORT
               {&PRN2} + {&PRN6A} + "           " + AlmSfami.Subfam + "- " + CAPS(AlmSfami.DesSub) + {&PRN6B} + {&PRN3} @ Almmmatg.desmat  WITH FRAME F-Cab.
               DOWN STREAM REPORT 2 WITH FRAME F-Cab.
            END.    
        END.     
     END.
     END.*/

     /************  x Marca  ************/
     IF FIRST-OF(Almmmatg.Desmar) THEN DO:
        DISPLAY STREAM REPORT
        {&PRN2} + {&PRN7A} + {&PRN6A} + "            " + CAPS(Almmmatg.DesMar) + {&PRN6B} + {&PRN7B} + {&PRN3} @ Almmmatg.DesMat WITH FRAME F-Cab.
        DOWN STREAM REPORT 2 WITH FRAME F-Cab.
     END.     
     
     DISPLAY STREAM REPORT
        Almmmatg.codfam 
        Almmmatg.subfam 
        Almmmatg.CodMat 
        Almmmatg.Desmat 
        Almmmatg.UndStk 
        Almmmatg.FacEqu WHEN Almmmatg.FacEqu > 0
        Almmmatg.UndBas 
        Almmmatg.CanEmp 
        Almmmatg.Pesmat 
        Almmmatg.FchIng 
        Almmmatg.FchCes 
        Almmmatg.TipArt 
        WITH FRAME F-Cab.
     
     IF LAST-OF(Almmmatg.Desmar) THEN DO:
        DOWN STREAM REPORT 1 WITH FRAME F-Cab.
     END.
    
/*   CASE F-FILTRO:
     WHEN 1 OR WHEN 2 THEN DO:
          IF LAST-OF(Almmmatg.Subfam) THEN DO:
             DOWN STREAM REPORT 1 WITH FRAME F-Cab.
          END.
          IF LAST-OF(Almmmatg.Codfam) THEN DO:
             DOWN STREAM REPORT 1 WITH FRAME F-Cab.
          END.
     END.
     end.*/
 END.
 
 OUTPUT STREAM REPORT CLOSE.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NEW-PAGE D-Dialog 
PROCEDURE NEW-PAGE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    c-Pagina = c-Pagina + 1.
    IF c-Pagina > P-pagfin
    THEN RETURN ERROR.
    DISPLAY c-Pagina WITH FRAME f-mensaje.
    IF c-Pagina > 1 THEN PAGE STREAM report.
    IF P-pagini = c-Pagina 
    THEN DO:
        OUTPUT STREAM report CLOSE.
        IF P-select = 1 
        THEN DO:
               OUTPUT STREAM report TO PRINTER NO-MAP NO-CONVERT UNBUFFERED
                    PAGED PAGE-SIZE 1000.
               PUT STREAM report CONTROL P-reset NULL P-flen NULL P-config NULL.
        END.
        ELSE DO:
            OUTPUT STREAM report TO VALUE ( P-archivo ) NO-MAP NO-CONVERT UNBUFFERED
                 PAGED PAGE-SIZE 1000.
            IF P-select = 3 THEN
                PUT STREAM report CONTROL P-reset P-flen P-config.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
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

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
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
        WHEN "F-SUBFAM" THEN ASSIGN input-var-1 = f-familia.
        WHEN "F-MARCA"  THEN ASSIGN input-var-1 = "MK".
        /*    ASSIGN
              input-para-1 = ""
              input-para-2 = ""
              input-para-3 = "".
         */      
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remvar D-Dialog 
PROCEDURE remvar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER IN-VAR AS CHARACTER.
    DEFINE OUTPUT PARAMETER OU-VAR AS CHARACTER.
    DEFINE VARIABLE P-pos AS INTEGER.
    OU-VAR = IN-VAR.
    IF P-select = 2 THEN DO:
        OU-VAR = "".
        RETURN.
    END.
    P-pos =  INDEX(OU-VAR, "[NULL]" ).
    IF P-pos <> 0
    THEN OU-VAR = SUBSTR(OU-VAR, 1, P-pos - 1) +
                     CHR(0) + SUBSTR(OU-VAR, P-pos + 6).
    P-pos =  INDEX(OU-VAR, "[#B]" ).
    IF P-pos <> 0
    THEN OU-VAR = SUBSTR(OU-VAR, 1, P-pos - 1) +
                     CHR(P-Largo) + SUBSTR(OU-VAR, P-pos + 4).
    P-pos =  INDEX(OU-VAR, "[#]" ).
    IF P-pos <> 0
    THEN OU-VAR = SUBSTR(OU-VAR, 1, P-pos - 1) +
                     STRING(P-Largo, ">>9" ) + SUBSTR(OU-VAR, P-pos + 3).
    RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Setup-Print D-Dialog 
PROCEDURE Setup-Print :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND integral.P-Codes WHERE integral.P-Codes.Name = P-name NO-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.P-Codes
    THEN DO:
        MESSAGE "Invalido Tabla de Impresora" SKIP
                "configurado al Terminal" XTerm
                VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    /* Configurando Variables de Impresion */
    RUN RemVar (INPUT integral.P-Codes.Reset,    OUTPUT P-Reset).
    RUN RemVar (INPUT integral.P-Codes.Flen,     OUTPUT P-Flen).
    RUN RemVar (INPUT integral.P-Codes.C6lpi,    OUTPUT P-6lpi).
    RUN RemVar (INPUT integral.P-Codes.C8lpi,    OUTPUT P-8lpi).
    RUN RemVar (INPUT integral.P-Codes.C10cpi,   OUTPUT P-10cpi).
    RUN RemVar (INPUT integral.P-Codes.C12cpi,   OUTPUT P-12cpi).
    RUN RemVar (INPUT integral.P-Codes.C15cpi,   OUTPUT P-15cpi).
    RUN RemVar (INPUT integral.P-Codes.C20cpi,   OUTPUT P-20cpi).
    RUN RemVar (INPUT integral.P-Codes.Landscap, OUTPUT P-Landscap).
    RUN RemVar (INPUT integral.P-Codes.Portrait, OUTPUT P-Portrait).
    RUN RemVar (INPUT integral.P-Codes.DobleOn,  OUTPUT P-DobleOn).
    RUN RemVar (INPUT integral.P-Codes.DobleOff, OUTPUT P-DobleOff).
    RUN RemVar (INPUT integral.P-Codes.BoldOn,   OUTPUT P-BoldOn).
    RUN RemVar (INPUT integral.P-Codes.BoldOff,  OUTPUT P-BoldOff).
    RUN RemVar (INPUT integral.P-Codes.UlineOn,  OUTPUT P-UlineOn).
    RUN RemVar (INPUT integral.P-Codes.UlineOff, OUTPUT P-UlineOff).
    RUN RemVar (INPUT integral.P-Codes.ItalOn,   OUTPUT P-ItalOn).
    RUN RemVar (INPUT integral.P-Codes.ItalOff,  OUTPUT P-ItalOff).
    RUN RemVar (INPUT integral.P-Codes.SuperOn,  OUTPUT P-SuperOn).
    RUN RemVar (INPUT integral.P-Codes.SuperOff, OUTPUT P-SuperOff).
    RUN RemVar (INPUT integral.P-Codes.SubOn,    OUTPUT P-SubOn).
    RUN RemVar (INPUT integral.P-Codes.SubOff,   OUTPUT P-SubOff).
    RUN RemVar (INPUT integral.P-Codes.Proptnal, OUTPUT P-Proptnal).
    RUN RemVar (INPUT integral.P-Codes.Lpi,      OUTPUT P-Lpi).

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


