&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
SESSION:DATE-FORMAT = "dmy".


DEFINE VARIABLE P-Largo    AS INTEGER.
DEFINE VARIABLE P-Ancho    AS INTEGER.
DEFINE VARIABLE P-pagini   AS INTEGER FORMAT ">>>9".
DEFINE VARIABLE P-pagfin   AS INTEGER FORMAT ">>>9".
DEFINE VARIABLE P-copias   AS INTEGER FORMAT ">9".
DEFINE VARIABLE P-select   AS INTEGER FORMAT "9".
DEFINE VARIABLE P-archivo  AS CHARACTER FORMAT "x(30)".

DEFINE VARIABLE P-detalle  AS CHAR.
DEFINE VARIABLE P-comando  AS CHAR.
DEFINE VARIABLE P-device   AS CHAR.
DEFINE VARIABLE P-name     AS CHAR.

DEFINE VARIABLE P-Reset    AS CHARACTER.
DEFINE VARIABLE P-Flen     AS CHARACTER.
DEFINE VARIABLE P-6lpi     AS CHARACTER.
DEFINE VARIABLE P-8lpi     AS CHARACTER.
DEFINE VARIABLE P-10cpi    AS CHARACTER.
DEFINE VARIABLE P-12cpi    AS CHARACTER.
DEFINE VARIABLE P-15cpi    AS CHARACTER.
DEFINE VARIABLE P-20cpi    AS CHARACTER.
DEFINE VARIABLE P-Landscap AS CHARACTER.
DEFINE VARIABLE P-Portrait AS CHARACTER.
DEFINE VARIABLE P-DobleOn  AS CHARACTER.
DEFINE VARIABLE P-DobleOff AS CHARACTER.
DEFINE VARIABLE P-BoldOn   AS CHARACTER.
DEFINE VARIABLE P-BoldOff  AS CHARACTER.
DEFINE VARIABLE P-UlineOn  AS CHARACTER.
DEFINE VARIABLE P-UlineOff AS CHARACTER.
DEFINE VARIABLE P-ItalOn   AS CHARACTER.
DEFINE VARIABLE P-ItalOff  AS CHARACTER.
DEFINE VARIABLE P-SuperOn  AS CHARACTER.
DEFINE VARIABLE P-SuperOff AS CHARACTER.
DEFINE VARIABLE P-SubOn    AS CHARACTER.
DEFINE VARIABLE P-SubOff   AS CHARACTER.
DEFINE VARIABLE P-Proptnal AS CHARACTER.
DEFINE VARIABLE P-Lpi      AS CHARACTER.
DEFINE VARIABLE l-immediate-display  AS LOGICAL.

DEFINE {&NEW} SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE {&NEW} SHARED VARIABLE x-userid  LIKE _user._userid.


DEFINE        VARIABLE P-config  AS CHARACTER.
DEFINE        VARIABLE c-Pagina  AS INTEGER LABEL "                 Imprimiendo Pagina ".
DEFINE        VARIABLE c-Copias  AS INTEGER.
DEFINE        VARIABLE OKpressed AS LOGICAL.
DEFINE        VARIABLE PTO        AS LOGICAL.


&GLOBAL-DEFINE NEW-PAGE READKEY PAUSE 0. ~
IF LASTKEY = KEYCODE("F10") THEN RETURN ERROR. ~
IF LINE-COUNTER(report)  + 5 > 66 OR c-Pagina = 0 ~
THEN RUN NEW-PAGE

DEFINE STREAM report.

DEFINE IMAGE IMAGE-1
     FILENAME "IMG\print"
     SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Mensaje
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16
          FONT 4
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19
          FONT 4
          SKIP
     Fi-Mensaje NO-LABEL
          FONT 4
     SKIP     
     "F10 = Cancela Reporte" VIEW-AS TEXT
          SIZE 21 BY 1 AT ROW 4.5 COL 12
          FONT 4
     SPACE(10.28) SKIP(0.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Imprimiendo ...".

{bin/s-global.i}
{ajt/ajglobal.i}

DEF VAR X-mensaje AS CHAR FORMAT "X(30)".

DEFINE FRAME F-AUXILIAR
   X-MENSAJE 
WITH NO-LABEL VIEW-AS DIALOG-BOX  CENTERED 
TITLE "Espere un momento por favor ... ".

DEF VAR I-31-12-Per-Ant AS DECIMAL INIT 0.
DEFINE VARIABLE x-codope as char.
DEFINE VARIABLE x-nroast as char.
DEFINE VARIABLE x-TpoCmb as decimal .
DEFINE VARIABLE x-FchAst as date.
DEFINE VARIABLE x-TotItm as decimal.
DEFINE VARIABLE x-dbemn1 as decimal.
DEFINE VARIABLE x-Hbemn1 as decimal.
DEFINE VAR F-CAB AS LOGICAL INIT NO.
DEFINE BUFFER B-DMOV FOR CB-DMOV.
DEFINE VAR K  AS INTEGER FORMAT "Z999" .

DEFINE TEMP-TABLE TMP-AJUSTE
     FIELD Item         AS INTEGER FORMAT "ZZZ9"             COLUMN-LABEL "Item"
     FIELD NroMes       AS INTEGER FORMAT "99"               COLUMN-LABEL "Mes"
     FIELD Codope       AS CHAR    FORMAT "X(3)"             COLUMN-LABEL "Ope"
     FIELD NroAst       AS CHAR    FORMAT "X(6)"             COLUMN-LABEL "Asiento"
     FIELD CodCta       AS CHAR    FORMAT "X(8)"             COLUMN-LABEL "Cuenta"
     FIELD CtaAft       AS CHAR    FORMAT "X(8)"             COLUMN-LABEL "Cta de!Ajuste"
     FIELD CtrCta       AS CHAR    FORMAT "X(8)"             COLUMN-LABEL "Contra!Cuenta"
     FIELD Metodo       AS CHAR    FORMAT "X"                COLUMN-LABEL "M"
     FIELD FchDoc       AS DATE    FORMAT "99/99/99"         COLUMN-LABEL "Fecha"
     FIELD CodAux       AS CHAR    FORMAT "X(8)"             COLUMN-LABEL "Auxil."
     FIELD CodDoc       AS CHAR    FORMAT "X(4)"             COLUMN-LABEL "Doc"
     FIELD NroDoc       AS CHAR    FORMAT "X(10)"            COLUMN-LABEL "Nro!Documento"
     FIELD Glodoc       AS CHAR    FORMAT "X(40)"            COLUMN-LABEL "Concepto"
     FIELD Coddiv       AS CHAR    FORMAT "X(5)"             COLUMN-LABEL "Cod!Divi."
     FIELD Importe      AS DECIMAL FORMAT "(ZZ,ZZZ,ZZ9.99)"  COLUMN-LABEL "Saldo ¢! Valor"
     FIELD F-Ajuste     AS DECIMAL FORMAT "Z9.999999"        COLUMN-LABEL "Factor!Ajuste"
     FIELD Rei-Ant      AS DECIMAL FORMAT "(ZZ,ZZZ,ZZ9.99)"  COLUMN-LABEL "REI!Anterior"
     FIELD Rei-Mes      AS DECIMAL FORMAT "(ZZ,ZZZ,ZZ9.99)"  COLUMN-LABEL "REI!Actual"
     FIELD Val-ajt      AS DECIMAL FORMAT "(ZZ,ZZZ,ZZ9.99)"  COLUMN-LABEL "Valor!Ajustado"
     INDEX IDX01 CODCTA ITEM .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-5 RECT-6 l-NroMes RB-NUMBER-COPIES ~
RADIO-SET-1 RB-BEGIN-PAGE B-impresoras RB-END-PAGE B-imprime B-cancela 
&Scoped-Define DISPLAYED-OBJECTS l-NroMes RB-NUMBER-COPIES RADIO-SET-1 ~
RB-BEGIN-PAGE RB-END-PAGE 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-archivo 
     IMAGE-UP FILE "img/pvstop":U
     LABEL "&Archivos.." 
     SIZE 5 BY 1.

DEFINE BUTTON B-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 11 BY .81.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "img/pvprint":U
     IMAGE-DOWN FILE "img/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON B-imprime AUTO-GO 
     LABEL "&Imprimir" 
     SIZE 11 BY .81.

DEFINE VARIABLE l-NroMes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 13
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12" 
     DROP-DOWN-LIST
     SIZE 8.86 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE RB-BEGIN-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "P gina Desde" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-END-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 9999 
     LABEL "P gina Hasta" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-NUMBER-COPIES AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "No. Copias" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81
     BGCOLOR 15 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE RB-OUTPUT-FILE AS CHARACTER FORMAT "X(8)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 10.29 BY 3
     FONT 4 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE    
     SIZE 64.86 BY 4.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 4 GRAPHIC-EDGE    
     SIZE 64.86 BY 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     l-NroMes AT ROW 1.42 COL 26.29 COLON-ALIGNED
     RB-NUMBER-COPIES AT ROW 3.96 COL 57.43 COLON-ALIGNED
     RADIO-SET-1 AT ROW 4 COL 2 NO-LABEL
     RB-BEGIN-PAGE AT ROW 4.92 COL 57.43 COLON-ALIGNED
     B-impresoras AT ROW 5 COL 12.86
     RB-OUTPUT-FILE AT ROW 5.96 COL 16.86 COLON-ALIGNED NO-LABEL
     RB-END-PAGE AT ROW 5.96 COL 57.43 COLON-ALIGNED
     b-archivo AT ROW 6 COL 12.86
     B-imprime AT ROW 7.96 COL 17.86
     B-cancela AT ROW 8 COL 48
     " Configuraci¢n de Impresi¢n" VIEW-AS TEXT
          SIZE 64.86 BY .62 AT ROW 2.81 COL 1
          BGCOLOR 1 FGCOLOR 15 
     RECT-5 AT ROW 3.42 COL 1
     RECT-6 AT ROW 7.5 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4
         TITLE "Ajuste y Depreciaci¢n".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DIALOG-1
   FRAME-NAME                                                           */
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

/* SETTINGS FOR BUTTON b-archivo IN FRAME DIALOG-1
   NO-ENABLE                                                            */
ASSIGN 
       b-archivo:HIDDEN IN FRAME DIALOG-1           = TRUE.

/* SETTINGS FOR FILL-IN RB-OUTPUT-FILE IN FRAME DIALOG-1
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       RB-OUTPUT-FILE:HIDDEN IN FRAME DIALOG-1           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DIALOG-1 DIALOG-1
ON GO OF FRAME DIALOG-1 /* Ajuste y Depreciaci¢n */
DO:
    APPLY "CHOOSE" TO B-imprime.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-archivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-archivo DIALOG-1
ON CHOOSE OF b-archivo IN FRAME DIALOG-1 /* Archivos.. */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-impresoras DIALOG-1
ON CHOOSE OF B-impresoras IN FRAME DIALOG-1
DO:
    SYSTEM-DIALOG PRINTER-SETUP.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-imprime DIALOG-1
ON CHOOSE OF B-imprime IN FRAME DIALOG-1 /* Imprimir */
DO:
    Assign 
           l-nromes.
    P-Copias = INPUT FRAME DIALOG-1 RB-NUMBER-COPIES.
    P-pagIni = INPUT FRAME DIALOG-1 RB-BEGIN-PAGE.
    P-pagfin = INPUT FRAME DIALOG-1 RB-END-PAGE.
    P-select = INPUT FRAME DIALOG-1 RADIO-SET-1.
    P-archivo= INPUT FRAME DIALOG-1 RB-OUTPUT-FILE.
    P-detalle = "Impresora Local (EPSON)".
    P-name  = "Epson E/F/J/RX/LQ".
    P-device  = "PRN".
    IF P-select = 2 
    THEN P-archivo = SESSION:TEMP-DIRECTORY + 
          STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
    ELSE RUN setup-print.      
    IF P-select <> 1 
    THEN P-copias = 1.
    
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 DIALOG-1
ON VALUE-CHANGED OF RADIO-SET-1 IN FRAME DIALOG-1
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DIALOG-1 


/* ***************************  Main Block  *************************** */
/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
ASSIGN L-NROMES = month(today).
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  PTO                  = SESSION:SET-WAIT-STATE("").    
  l-immediate-display  = SESSION:IMMEDIATE-DISPLAY.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  RUN disable_UI.

  FRAME F-Mensaje:TITLE =  FRAME DIALOG-1:TITLE.
  VIEW FRAME F-Mensaje.  
  PAUSE 0.           
  SESSION:IMMEDIATE-DISPLAY = YES.
  DO c-Copias = 1 to P-copias ON ERROR UNDO, LEAVE
                                ON STOP UNDO, LEAVE:
        OUTPUT STREAM report TO NUL PAGED PAGE-SIZE 66.
        c-Pagina = 0.
        RUN IMPRIMIR.
        OUTPUT STREAM report CLOSE.        
  END.
  HIDE FRAME F-Mensaje.  
  OUTPUT STREAM report CLOSE.        
  IF NOT LASTKEY = KEYCODE("ESC") AND P-select = 2 THEN DO: 
        RUN BIN/_readme.p ( P-archivo ). 
        OS-DELETE VALUE ( P-archivo ). 
  END.    
  RETURN.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE agotamiento DIALOG-1 
PROCEDURE agotamiento :
define input parameter p-codcta as char.
define input parameter p-ctaaft as char.
define input parameter p-ctrcta as char.

def var VAL-HIS as decimal.
def var REI-ANT as decimal.
def var REI-MES as decimal.
def var Val-Ajt as decimal.
def var cargos as decimal extent 14.
def var i as integer.
def var Mes-inicio as integer.
def var saldo as decimal.
def var saldo-ant as decimal.
def var t-rowid as rowid.
def var x-indice as decimal.
def var f-ajuste as decimal.
def var t-val-ajt as decimal.
FOR EACH CB-DMOV NO-LOCK WHERE      CB-DMOV.CODCIA  =  S-CODCIA
                           AND      CB-DMOV.PERIODO =  S-PERIODO
                           AND      CB-DMOV.CODCTA  =  P-CODCTA
                           AND      CB-DMOV.NROMES <=  L-NROMES
                           BREAK BY CB-DMOV.CODCTA
                                 BY CB-DMOV.CODDIV :
                        
                                          
       IF FIRST-OF (CB-DMOV.CODDIV) THEN DO:
          T-ROWID = ROWID(CB-DMOV).
          Mes-Inicio   = CB-DMOV.NROMES.
          saldo        = 0.
          saldo-ant    = 0.
          VAL-HIS      = 0.
          Val-Ajt      = 0.
          REI-ANT      = 0.
          REI-MES      = 0.
          x-indice     = 0.
          t-val-ajt    = 0.
          do i = 1 to 14 : cargos[i] = 0 . end.
       END.
       if not cb-dmov.tpomov then 
          cargos[ cb-dmov.nromes + 1 ] = cargos[ cb-dmov.nromes + 1 ] + cb-dmov.impmn1.
       VAL-HIS = IF CB-DMOV.TPOMOV THEN VAL-HIS - CB-DMOV.IMPMN1 ELSE VAL-HIS + CB-DMOV.IMPMN1.
       
       IF  LAST-OF (CB-DMOV.CODDIV) AND VAL-HIS <> 0 THEN DO:
          saldo = VAL-HIS.
          X-TotItm = X-TotItm + 1.          
          
          lazo:
          DO I = L-NROMES + 1 TO 1 by -1 :                
             saldo-ant   = saldo.
             saldo = saldo  - cargos[ i ] .
             IF I = 1 THEN x-indice = I-31-12-PER-ANT.
             ELSE          x-indice = aj-inme.indice[ i - 1].             
             if saldo > 0 then 
             do:
                F-AJUSTE  = aj-inme.indice[L-NROMES] / x-indice.
                t-val-ajt = cargos[i] * aj-inme.indice[L-NROMES] / x-indice.
                val-ajt = val-ajt + cargos[i] * aj-inme.indice[L-NROMES] / x-indice.
                RUN GEN-AGO(P-CODCTA , 
                            P-CTAAFT , 
                            P-CTRCTA ,
                            "A"      ,
                            i - 1 ,
                            f-ajuste ,
                            cargos[i],
                            t-VAL-AJT  ).
             end.
             else              
               do:
                 F-AJUSTE = aj-inme.indice[L-NROMES] / x-indice.
                 t-val-ajt = Saldo-Ant * aj-inme.indice[L-NROMES] / x-indice.
                 RUN GEN-AGO(P-CODCTA , 
                            P-CTAAFT , 
                            P-CTRCTA ,
                            "A"      ,
                            i - 1    ,
                            f-ajuste ,
                            Saldo-Ant,
                            t-VAL-AJT  ).
                  
                 val-ajt = val-ajt + saldo-ant * aj-inme.indice[L-NROMES] / x-indice.
                 leave lazo.
               end.  
          END.
         REI-ANT      = 0. 
         REI-MES      = 0.         
         FOR EACH  B-DMOV WHERE B-DMOV.CODCIA  = CB-DMOV.CODCIA  AND
                                B-DMOV.PERIODO = CB-DMOV.PERIODO AND          
                                B-DMOV.CODCTA  = P-CTAAFT        AND
                                B-DMOV.CODDIV  = CB-DMOV.CODDIV  AND
                                B-DMOV.NROMES  < CB-DMOV.NROMES
                                NO-LOCK :
              REI-ANT = REI-ANT +  IF NOT CB-DMOV.TPOMOV THEN CB-DMOV.IMPMN1 
                                                         ELSE - CB-DMOV.IMPMN1.
          END.
          REI-MES = (VAL-AJT - VAL-HIS ) - REI-ANT.
          IF VAL-AJT <> 0 THEN DO:
             RUN GEN-LIN(P-CODCTA , 
                         P-CTAAFT , 
                         P-CTRCTA ,
                         "A"      ,
                         0        ,
                         VAL-HIS  ,
                         REI-ANT  ,
                         REI-MES  , 
                         VAL-AJT  ,
                         ROWID(CB-DMOV) ).
          END.                



       END. /*FIN DEL LAST-OF */
      
END. /* FIN DEL FOR EACH */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DIALOG-1  _DEFAULT-DISABLE
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
  HIDE FRAME DIALOG-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DIALOG-1  _DEFAULT-ENABLE
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
  DISPLAY l-NroMes RB-NUMBER-COPIES RADIO-SET-1 RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME DIALOG-1.
  ENABLE RECT-5 RECT-6 l-NroMes RB-NUMBER-COPIES RADIO-SET-1 RB-BEGIN-PAGE 
         B-impresoras RB-END-PAGE B-imprime B-cancela 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GEN-AGO DIALOG-1 
PROCEDURE GEN-AGO :
DEFINE INPUT PARAMETER P-CODCTA    AS CHAR.
DEFINE INPUT PARAMETER P-CTAAFT    AS CHAR.
DEFINE INPUT PARAMETER P-CTRCTA    AS CHAR .
DEFINE INPUT PARAMETER P-METODO    AS CHAR.
DEFINE INPUT PARAMETER P-MES       AS INTEGER.
DEFINE INPUT PARAMETER P-F-AJUSTE  AS DECIMAL.
DEFINE INPUT PARAMETER P-VAL-HIS   AS DECIMAL.
DEFINE INPUT PARAMETER P-VAL-AJU   AS DECIMAL.




CREATE TMP-AJUSTE.
ASSIGN

      TMP-AJUSTE.Item          =   X-TotItm
      TMP-AJUSTE.NroMes        =   P-MES
      /*
      TMP-AJUSTE.Codope        =   b-dmov.codope
      TMP-AJUSTE.NroAst        =   b-dmov.nroast
      */
      TMP-AJUSTE.CodCta        =   p-codcta
      TMP-AJUSTE.CtaAft        =   p-ctaaft
      TMP-AJUSTE.CtrCta        =   p-ctrcta
      TMP-AJUSTE.Metodo        =   p-metodo
/*
      TMP-AJUSTE.CodAux        =   b-dmov.codaux
      TMP-AJUSTE.CodDoc        =   b-dmov.coddoc
      TMP-AJUSTE.NroDoc        =   b-dmov.nrodoc
      TMP-AJUSTE.Glodoc        =   b-dmov.glodoc
      TMP-AJUSTE.Coddiv        =   b-dmov.coddiv
 */     
      TMP-AJUSTE.Importe       =   p-val-his
      TMP-AJUSTE.F-Ajuste      =   p-f-ajuste 
      TMP-AJUSTE.Val-ajt       =   p-val-ajU .
F-CAB = YES.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen-lin DIALOG-1 
PROCEDURE gen-lin :
DEFINE INPUT PARAMETER P-CODCTA    AS CHAR.
DEFINE INPUT PARAMETER P-CTAAFT    AS CHAR.
DEFINE INPUT PARAMETER P-CTRCTA    AS CHAR .
DEFINE INPUT PARAMETER P-METODO    AS CHAR.
DEFINE INPUT PARAMETER P-F-AJUSTE  AS DECIMAL.
DEFINE INPUT PARAMETER P-VAL-HIS   AS DECIMAL.
DEFINE INPUT PARAMETER P-REI-ANT   AS DECIMAL.
DEFINE INPUT PARAMETER P-REI-MES   AS DECIMAL.
DEFINE INPUT PARAMETER P-VAL-AJU   AS DECIMAL.
DEFINE INPUT PARAMETER P-ROWID     AS ROWID.

FIND B-DMOV WHERE ROWID(B-DMOV) = P-ROWID NO-LOCK NO-ERROR.
IF NOT AVAIL B-DMOV THEN DO:
   Message "Registro no entrado en GEN-LIN"
   VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.


CREATE TMP-AJUSTE.
IF P-METODO <> "A" THEN  X-TotItm = X-TotItm + 1.

ASSIGN

      TMP-AJUSTE.Item          =   X-TotItm
      TMP-AJUSTE.NroMes        =   b-dmov.nromes
      TMP-AJUSTE.Codope        =   b-dmov.codope
      TMP-AJUSTE.NroAst        =   b-dmov.nroast
      TMP-AJUSTE.CodCta        =   p-codcta
      TMP-AJUSTE.CtaAft        =   p-ctaaft
      TMP-AJUSTE.CtrCta        =   p-ctrcta
      TMP-AJUSTE.Metodo        =   p-metodo
      TMP-AJUSTE.CodAux        =   b-dmov.codaux
      TMP-AJUSTE.CodDoc        =   b-dmov.coddoc
      TMP-AJUSTE.NroDoc        =   b-dmov.nrodoc
      TMP-AJUSTE.Glodoc        =   b-dmov.glodoc
      TMP-AJUSTE.Coddiv        =   b-dmov.coddiv
      TMP-AJUSTE.Importe       =   p-val-his
      TMP-AJUSTE.F-Ajuste      =   p-f-ajuste 
      TMP-AJUSTE.Val-ajt       =   p-val-ajU 
      TMP-AJUSTE.Rei-Mes       =   p-rei-mes
      TMP-AJUSTE.Rei-ANT       =   p-rei-ant
      TMP-AJUSTE.FCHDOC        =   B-DMOV.FCHDOC. 
     
F-CAB = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genera DIALOG-1 
PROCEDURE genera :
DEFINE VAR i as integer.
RUN VALIDA.
IF RETURN-VALUE = "ERROR" THEN RETURN.

IF L-NROMES = 12 THEN x-fchast = date ( 12, 31 , s-periodo).
                 ELSE x-fchast = date ( L-NROMES + 1 , 1, s-periodo) - 1.

LAZO_1:
FOR EACH CB-CFGC NO-LOCK WHERE CB-CFGC.CODCIA = CB-CODCIA AND
                               CB-CFGC.CODCFG = 1         AND
                               CB-CFGC.CTAAFT <> ""       AND
                               CB-CFGC.CTRCTA <> ""       AND
                               CB-CFGC.ORIGEN  
                               BREAK BY CB-CFGC.CODCTA  :
                               
                               
    LAZO_2:                           
    FOR EACH CB-CTAS NO-LOCK
                     WHERE CB-CTAS.CODCIA    =   CB-CODCIA   AND
                    LENGTH(CB-CTAS.CODCTA)   =   CB-MAXNIVEL AND
                           CB-CTAS.CODCTA   BEGINS    CB-CFGC.CODCTA :
        IF CAN-FIND (FIRST CB-CFGC WHERE CB-CFGC.CODCIA = CB-CODCIA AND
                                         CB-CFGC.CTAAFT = CB-CTAS.CODCTA )
        THEN NEXT LAZO_2.    
        X-MENSAJE = "Procesando Cuenta: " +  CB-CTAS.CODCTA .
        DISPLAY X-MENSAJE WITH FRAME F-AUXILIAR.
        PAUSE 0.             
      

        CASE CB-CFGC.METODO :
             WHEN "S" THEN RUN SALDO-PARTIDA(cb-ctas.codcta ,
                                             cb-cfgc.ctaaft ,
                                             cb-cfgc.ctrcta) .

             WHEN "A" THEN RUN AGOTAMIENTO  (cb-ctas.codcta ,
                                             cb-cfgc.ctaaft ,
                                             cb-cfgc.ctrcta) .
                               
                                
         
        END.                     

    END.

END.

HIDE FRAME F-AUXILIAR.

IF F-CAB THEN RETURN "OK".
         ELSE RETURN "ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR DIALOG-1 
PROCEDURE IMPRIMIR :
run genera.
  if return-value = "ERROR" THEN RETURN.
  DEF VAR F-REP AS DATE.
  DEF VAR X-NOMREP AS CHAR FORMAT "X(80)".
  x-NomRep = "A J U S T E S    P O R   I N F L A C I O N  A L " + string(X-FCHAST).
  
  DEFINE FRAME f-cab 
  
      TMP-AJUSTE.Item     
      TMP-AJUSTE.NroMes   
      TMP-AJUSTE.Codope   
      TMP-AJUSTE.NroAst   
      TMP-AJUSTE.CodCta   
      TMP-AJUSTE.CtaAft   
    /*  
      TMP-AJUSTE.CtrCta   
    */  
      TMP-AJUSTE.Metodo   
      TMP-AJUSTE.FCHDOC
      TMP-AJUSTE.CodAux   
      TMP-AJUSTE.CodDoc   
      TMP-AJUSTE.NroDoc   
      TMP-AJUSTE.Glodoc   
      TMP-AJUSTE.Coddiv   
      TMP-AJUSTE.Importe  
      TMP-AJUSTE.F-Ajuste 
      TMP-AJUSTE.REI-ANT
      TMP-AJUSTE.Rei-Mes  
      TMP-AJUSTE.Val-ajt  
  HEADER  
       s-nomcia  FORMAT "X(70)"
                   "Fecha  :" to 195 TODAY    to 205   SKIP
                   "P gina :" to 195 c-pagina to 205   SKIP
                   "Hora   :" to 195 STRING(TIME, "HH:MM AM") to 205 SKIP
       x-NomRep AT 75  SKIP(2)
  WITH DOWN NO-BOX STREAM-IO  WIDTH 255. 
  
  
  
    P-Largo = 66.    /* Largo de Pagina */ 
    P-Ancho = 180.   /* Ancho de Pagina */
    /* Configurando Setup de Impresora */
    P-Config = P-20cpi . 
    K = 0 .
  
    
 DO WITH FRAME F-CAB :   
 
    FOR EACH  TMP-AJUSTE   BREAK BY tmp-ajuste.CODCTA
                                 BY tmp-ajuste.ITEM :
      
       X-MENSAJE = "Imprimiendo Cuenta:  " + TMP-AJUSTE.codcta .
       DISPLAY X-Mensaje WITH FRAME f-AUXILIAR .
       PAUSE 0.
       {&NEW-PAGE}.
        DISPLAY STREAM REPORT
            TMP-AJUSTE.Item     
            TMP-AJUSTE.NroMes   
            TMP-AJUSTE.Codope   
            TMP-AJUSTE.NroAst   
            TMP-AJUSTE.CodCta   
            TMP-AJUSTE.CtaAft   
          /*  TMP-AJUSTE.CtrCta   */
            TMP-AJUSTE.Metodo   
            TMP-AJUSTE.FCHDOC
            TMP-AJUSTE.CodAux   
            TMP-AJUSTE.CodDoc   
            TMP-AJUSTE.NroDoc   
            TMP-AJUSTE.Glodoc   
            TMP-AJUSTE.Coddiv   
            TMP-AJUSTE.Importe  
            TMP-AJUSTE.F-Ajuste 
            TMP-AJUSTE.Rei-Ant
            TMP-AJUSTE.Rei-Mes  
            TMP-AJUSTE.Val-ajt  
        WITH FRAME F-CAB.   
        
        
        DOWN STREAM report  WITH FRAME f-cab.
        IF LAST-OF(TMP-AJUSTE.ITEM ) THEN DO:
        ACCUM     tmp-ajuste.importe  (SUB-TOTAL BY tmp-ajuste.codcta)
                  tmp-ajuste.rei-ant  (SUB-TOTAL BY tmp-ajuste.codcta)
                  tmp-ajuste.rei-mes  (SUB-TOTAL BY tmp-ajuste.codcta)
                  tmp-ajuste.Val-Ajt  (SUB-TOTAL BY tmp-ajuste.codcta) .
        ACCUM     tmp-ajuste.importe  (TOTAL )
                  tmp-ajuste.rei-ant  (TOTAL )
                  tmp-ajuste.rei-mes  (TOTAL )
                  tmp-ajuste.Val-Ajt   (TOTAL ) .
        IF TMP-AJUSTE.METODO = "A" THEN
            DOWN STREAM report 1 WITH FRAME f-cab.          
        END.          
       IF LAST-OF (TMP-AJUSTE.CODCTA) THEN DO:           
          {&NEW-PAGE}.
           UNDERLINE  STREAM REPORT
            TMP-AJUSTE.Item     
            TMP-AJUSTE.NroMes   
            TMP-AJUSTE.Codope   
            TMP-AJUSTE.NroAst   
            TMP-AJUSTE.CodCta   
            TMP-AJUSTE.CtaAft   
          /*  TMP-AJUSTE.CtrCta   */
            TMP-AJUSTE.Metodo   
            TMP-AJUSTE.FCHDOC
            TMP-AJUSTE.CodAux   
            TMP-AJUSTE.CodDoc   
            TMP-AJUSTE.NroDoc   
            TMP-AJUSTE.Glodoc   
            TMP-AJUSTE.Coddiv   
            TMP-AJUSTE.Importe  
            TMP-AJUSTE.F-Ajuste 
            TMP-AJUSTE.Rei-Ant
            TMP-AJUSTE.Rei-Mes  
            TMP-AJUSTE.Val-ajt  
        WITH FRAME F-CAB.   
        DOWN STREAM report 1 WITH FRAME f-cab.
        {&NEW-PAGE}.
        DISPLAY STREAM REPORT
            TMP-AJUSTE.CodCta   
            "S u b  T o t a l ....." @ TMP-AJUSTE.Glodoc   
            ACCUM SUB-TOTAL BY TMP-AJUSTE.CODCTA TMP-AJUSTE.IMPORTE @ TMP-AJUSTE.Importe  
            ACCUM SUB-TOTAL BY TMP-AJUSTE.CODCTA TMP-AJUSTE.REI-ANT @ TMP-AJUSTE.Rei-Ant
            ACCUM SUB-TOTAL BY TMP-AJUSTE.CODCTA TMP-AJUSTE.REI-MES @ TMP-AJUSTE.Rei-Mes  
            ACCUM SUB-TOTAL BY TMP-AJUSTE.CODCTA TMP-AJUSTE.VAL-AJT @ TMP-AJUSTE.Val-ajt  
            WITH FRAME F-CAB.   
          DOWN STREAM report 2 WITH FRAME f-cab.
                  
                  
       END.         
                  
        
  END. /* FIN DEL FOR EACH */        
  
          {&NEW-PAGE}.
           UNDERLINE  STREAM REPORT
            TMP-AJUSTE.Item     
            TMP-AJUSTE.NroMes   
            TMP-AJUSTE.Codope   
            TMP-AJUSTE.NroAst   
            TMP-AJUSTE.CodCta   
            TMP-AJUSTE.CtaAft   
          /*  TMP-AJUSTE.CtrCta   */
            TMP-AJUSTE.Metodo   
            TMP-AJUSTE.FCHDOC
            TMP-AJUSTE.CodAux   
            TMP-AJUSTE.CodDoc   
            TMP-AJUSTE.NroDoc   
            TMP-AJUSTE.Glodoc   
            TMP-AJUSTE.Coddiv   
            TMP-AJUSTE.Importe  
            TMP-AJUSTE.F-Ajuste 
            TMP-AJUSTE.Rei-Ant
            TMP-AJUSTE.Rei-Mes  
            TMP-AJUSTE.Val-ajt  
        WITH FRAME F-CAB.   
        DOWN STREAM report 1 WITH FRAME f-cab.
        {&NEW-PAGE}.
        DISPLAY STREAM REPORT
            "   T o t a l e s ....." @ TMP-AJUSTE.Glodoc   
            ACCUM TOTAL  TMP-AJUSTE.IMPORTE @ TMP-AJUSTE.Importe  
            ACCUM TOTAL  TMP-AJUSTE.REI-ANT @ TMP-AJUSTE.Rei-Ant
            ACCUM TOTAL  TMP-AJUSTE.REI-MES @ TMP-AJUSTE.Rei-Mes  
            ACCUM TOTAL  TMP-AJUSTE.VAL-AJT @ TMP-AJUSTE.Val-ajt  
            WITH FRAME F-CAB.   
          DOWN STREAM report 2 WITH FRAME f-cab.
  
  
  
    
END. /* FIN DEL FRAME */      
HIDE FRAME F-AUXILIAR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NEW-PAGE DIALOG-1 
PROCEDURE NEW-PAGE :
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
               OUTPUT STREAM report TO PRINTER /*NO-MAP NO-CONVERT 
                UNBUFFERED */ PAGED PAGE-SIZE 66.
               PUT STREAM report CONTROL P-reset NULL P-flen NULL P-config NULL. 
        END.
        ELSE DO:
            OUTPUT STREAM report TO VALUE ( P-archivo ) NO-MAP NO-CONVERT 
               UNBUFFERED
                 PAGED PAGE-SIZE 1000.
            IF P-select = 3 THEN
                PUT STREAM report CONTROL P-reset P-flen P-config.
        END.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remvar DIALOG-1 
PROCEDURE remvar :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saldo-partida DIALOG-1 
PROCEDURE saldo-partida :
define input parameter p-codcta as char.
define input parameter p-ctaaft as char.
define input parameter p-ctrcta as char.


def var VAL-HIS as decimal.
def var REI-ANT as decimal.
def var REI-MES as decimal.
def var Val-Ajt as decimal.
def var f-ajuste as decimal.

def var Mes-inicio as integer.

def var t-rowid as rowid.

FOR EACH CB-DMOV NO-LOCK WHERE      CB-DMOV.CODCIA  =  S-CODCIA
                           AND      CB-DMOV.PERIODO =  S-PERIODO
                           AND      CB-DMOV.CODCTA  =  P-CODCTA
                           AND      CB-DMOV.NROMES <=  L-NROMES
                           BREAK BY CB-DMOV.CODDIV
                                 BY CB-DMOV.CODAUX
                                 BY CB-DMOV.CODDOC
                                 BY CB-DMOV.NRODOC :
      
                                          
       IF FIRST-OF (CB-DMOV.NRODOC) THEN DO:
          T-ROWID = ROWID(CB-DMOV).
          Mes-Inicio   = CB-DMOV.NROMES.
          VAL-HIS      = 0.
          Val-Ajt      = 0.
          f-ajuste     = 0.
       END.

       IF CB-DMOV.NROMES < Mes-Inicio THEN DO:
          Mes-Inicio = CB-DMOV.NROMES.
          T-ROWID = ROWID(CB-DMOV).
       END.   
       VAL-HIS = IF CB-DMOV.TPOMOV THEN VAL-HIS - CB-DMOV.IMPMN1 ELSE VAL-HIS + CB-DMOV.IMPMN1.

       IF LAST-OF (CB-DMOV.NRODOC) THEN DO:
          IF Mes-Inicio = 0  THEN  DO:
             VAL-AJT  =  VAL-HIS * aj-inme.indice[L-NROMES] / I-31-12-Per-ant.
             F-AJUSTE =  aj-inme.indice[L-NROMES] / I-31-12-Per-ant.
          END.   
          ELSE DO:
             VAL-AJT  =  VAL-HIS * aj-inme.indice[L-NROMES] / aj-inme.indice[Mes-Inicio] .
             F-AJUSTE = aj-inme.indice[L-NROMES] / aj-inme.indice[Mes-Inicio] .
          END.   
          
         REI-ANT      = 0. 
         REI-MES      = 0.         
         FOR EACH  B-DMOV WHERE B-DMOV.CODCIA  = CB-DMOV.CODCIA  AND
                                B-DMOV.PERIODO = CB-DMOV.PERIODO AND          
                                B-DMOV.CODCTA  = P-CTAAFT        AND
                                B-DMOV.CODDIV  = CB-DMOV.CODDIV  AND
                                B-DMOV.CODAUX  = CB-DMOV.CODAUX  AND
                                B-DMOV.CODDOC  = CB-DMOV.CODDOC  AND
                                B-DMOV.NRODOC  = CB-DMOV.NRODOC  AND
                                B-DMOV.NROMES  < CB-DMOV.NROMES
                                NO-LOCK :
              REI-ANT = REI-ANT +  IF NOT CB-DMOV.TPOMOV THEN CB-DMOV.IMPMN1 
                                                         ELSE - CB-DMOV.IMPMN1.
          END.
          REI-MES = (VAL-AJT - VAL-HIS ) - REI-ANT.
          IF VAL-AJT <> 0 THEN DO:
             RUN GEN-LIN(P-CODCTA , 
                         P-CTAAFT , 
                         P-CTRCTA ,
                         "S"      ,
                         f-ajuste ,
                         VAL-HIS  ,
                         REI-ANT  ,
                         REI-MES  , 
                         VAL-AJT  ,
                          T-rowid ).
         
          END.   
       END.
             
END. /* FIN DEL FOR EACH */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setup-print DIALOG-1 
PROCEDURE setup-print :
FIND PF-P001 WHERE PF-P001.P-Code = P-name NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PF-P001
    THEN DO:
        MESSAGE "Invalido Tabla de Impresora" SKIP
                "configurado al Terminal" /* XTerm*/
                VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    /* Configurando Variables de Impresion */
    RUN RemVar (INPUT PF-P001.Reset,    OUTPUT P-Reset).
    RUN RemVar (INPUT PF-P001.Flen,     OUTPUT P-Flen).
    RUN RemVar (INPUT PF-P001.C6lpi,    OUTPUT P-6lpi).
    RUN RemVar (INPUT PF-P001.C8lpi,    OUTPUT P-8lpi).
    RUN RemVar (INPUT PF-P001.C10cpi,   OUTPUT P-10cpi).
    RUN RemVar (INPUT PF-P001.C12cpi,   OUTPUT P-12cpi).
    RUN RemVar (INPUT PF-P001.C15cpi,   OUTPUT P-15cpi).
    RUN RemVar (INPUT PF-P001.C20cpi,   OUTPUT P-20cpi).
    RUN RemVar (INPUT PF-P001.Landscap, OUTPUT P-Landscap).
    RUN RemVar (INPUT PF-P001.Portrait, OUTPUT P-Portrait).
    RUN RemVar (INPUT PF-P001.DobleOn,  OUTPUT P-DobleOn).
    RUN RemVar (INPUT PF-P001.DobleOff, OUTPUT P-DobleOff).
    RUN RemVar (INPUT PF-P001.BoldOn,   OUTPUT P-BoldOn).
    RUN RemVar (INPUT PF-P001.BoldOff,  OUTPUT P-BoldOff).
    RUN RemVar (INPUT PF-P001.UlineOn,  OUTPUT P-UlineOn).
    RUN RemVar (INPUT PF-P001.UlineOff, OUTPUT P-UlineOff).
    RUN RemVar (INPUT PF-P001.ItalOn,   OUTPUT P-ItalOn).
    RUN RemVar (INPUT PF-P001.ItalOff,  OUTPUT P-ItalOff).
    RUN RemVar (INPUT PF-P001.SuperOn,  OUTPUT P-SuperOn).
    RUN RemVar (INPUT PF-P001.SuperOff, OUTPUT P-SuperOff).
    RUN RemVar (INPUT PF-P001.SubOn,    OUTPUT P-SubOn).
    RUN RemVar (INPUT PF-P001.SubOff,   OUTPUT P-SubOff).
    RUN RemVar (INPUT PF-P001.Proptnal, OUTPUT P-Proptnal).
    RUN RemVar (INPUT PF-P001.Lpi,      OUTPUT P-Lpi).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida DIALOG-1 
PROCEDURE valida :
DEF VAR I AS INTEGER.

if L-NROMES < 1 or L-NROMES > 14 then DO:
   Message "Invalido Nro de Mes " L-NROMES
   VIEW-AS ALERT-BOX ERROR.
   return "ERROR".   
END.
FIND CB-PERI WHERE CB-PERI.CodCia  = s-Codcia  AND
                    CB-PERI.PERIODO = s-periodo
                    NO-LOCK NO-ERROR.
IF NOT AVAIL CB-PERI THEN DO:
   Message "Periodo no registrado"
   VIEW-AS ALERT-BOX ERROR.
   return "ERROR". 
END.
IF CB-PERI.MesCie[L-NROMES + 1 ] THEN DO:
   Message "Mes contable cerrado" 
   VIEW-AS ALERT-BOX ERROR.
   return "ERROR". 
END.

/*
IF AVAIL AJ-CFGA THEN DO:
   x-Codope = AJ-CFGA.CodOpe.
   x-NroAst = AJ-CFGA.NroAst.
END.
ELSE DO:
   MESSAGE "Configuraci¢n de Asiento a generar incorrecta"
   VIEW-AS ALERT-BOX ERROR.
   RETURN "ERROR".
END.

FIND cb-oper WHERE cb-oper.CODCIA = CB-CODCIA AND
                       cb-oper.CODOPE = X-CODOPE 
                       NO-LOCK NO-ERROR.
IF NOT AVAIL cb-oper THEN DO:
  MESSAGE "Operaci¢n " x-codope " no registrada" 
  VIEW-AS ALERT-BOX ERROR.
  RETURN "ERROR".
END.     
*/

FIND AJ-INME WHERE AJ-INME.PERIODO = S-PERIODO - 1 NO-LOCK NO-ERROR.
IF NOT AVAIL AJ-INME THEN DO:
   MESSAGE "Registro de indices mensuales del " SKIP
           "periodo anterior no registrado"
   VIEW-AS ALERT-BOX ERROR.
   RETURN "ERROR".
END.
if aj-inme.indice[12] = 0 then do:
   MESSAGE "Indice mensual" aj-inme.periodo "-"  "12 incorrecto"
   VIEW-AS ALERT-BOX ERROR.
   RETURN "ERROR".
end.
I-31-12-Per-Ant = aj-inme.indice[12].
FIND AJ-INME WHERE AJ-INME.PERIODO = S-PERIODO NO-LOCK NO-ERROR.
IF NOT AVAIL AJ-INME THEN DO:
   MESSAGE "Registro de indices mensuales del periodo no registrado"
   VIEW-AS ALERT-BOX ERROR.
   RETURN "ERROR".
END.




do i = 1 to L-NROMES :

   IF aj-inme.indice[i] <= 0 then do:

      MESSAGE "Indice mensual" aj-inme.periodo "-" i "incorrecto"
      VIEW-AS ALERT-BOX ERROR.
      RETURN "ERROR".

   END.

end.



RETURN "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

