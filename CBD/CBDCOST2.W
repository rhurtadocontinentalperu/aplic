&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME    DIALOG-1
&Scoped-define FRAME-NAME     DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 07/14/95 -  7:08 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

&IF "{&NEW}" = "" &THEN
    DEFINE INPUT PARAMETER x-CodCta AS CHARACTER.
    DEFINE INPUT PARAMETER x-ClfAux AS CHARACTER.
    DEFINE INPUT PARAMETER x-CodAux AS CHARACTER.
    DEFINE INPUT PARAMETER s-NroMes    AS INTEGER.
    DEFINE INPUT PARAMETER y-codcia AS INTEGER.
&ELSE
    DEFINE VARIABLE x-CodCta AS CHARACTER INITIAL "90000".
    DEFINE VARIABLE x-ClfAux AS CHARACTER INITIAL "04".
    DEFINE VARIABLE x-CodAux AS CHARACTER INITIAL "220".
    DEFINE VARIABLE s-NroMes    AS INTEGER   INITIAL 2.
    DEFINE VARIABLE y-codcia AS INTEGER   INITIAL 0.
&ENDIF

/* Local Variable Definitions ---                                       */

DEFINE {&NEW} SHARED VARIABLE s-codcia       AS INTEGER   INITIAL 1.
DEFINE {&NEW} SHARED VARIABLE s-periodo          AS INTEGER   INITIAL 1995.
DEFINE {&NEW} SHARED VARIABLE s-user-id       AS CHARACTER INITIAL "JORGE".
DEFINE {&NEW} SHARED VARIABLE cb-niveles AS CHARACTER INITIAL "2,3,4,5".

DEFINE VARIABLE x-NivMax    AS INTEGER INITIAL 5.
DEFINE VARIABLE lista-ope   AS CHARACTER.
DEFINE VARIABLE lista-aux   AS CHARACTER.
DEFINE VARIABLE x-CodOpe    AS CHARACTER.
DEFINE VARIABLE RECID-stack AS RECID.
DEFINE VARIABLE RegAct      AS RECID.
DEFINE VARIABLE x-Suma1     AS DECIMAL INITIAL 0.
DEFINE VARIABLE x-Suma2     AS DECIMAL INITIAL 0.
DEFINE VARIABLE i           AS INTEGER.
DEFINE VARIABLE pto1        AS LOGICAL.
DEFINE VARIABLE pto         AS LOGICAL.

pto = SESSION:SET-WAIT-STATE("").
x-NivMax = INTEGER ( ENTRY ( NUM-ENTRIES ( cb-niveles ),cb-niveles ) ).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ********************  Preprocessor Definitions  ******************** */

/* Name of first Frame and/or Browse (alphabetically)                   */
&Scoped-define FRAME-NAME  DIALOG-1
&Scoped-define BROWSE-NAME BROWSE-2

/* Custom List Definitions                                              */
&Scoped-define LIST-1 
&Scoped-define LIST-2 
&Scoped-define LIST-3 

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 integral.cb-dmov.Codope ~
integral.cb-dmov.Codaux integral.cb-dmov.Nroast ~
integral.cb-dmov.Glodoc integral.cb-dmov.Nrodoc ~
integral.cb-dmov.TpoMov integral.cb-dmov.ImpMn1 ~
integral.cb-dmov.ImpMn2 integral.cb-dmov.Coddoc ~
integral.cb-dmov.Fchdoc integral.cb-dmov.Fchvto ~
integral.cb-dmov.Nroref integral.cb-dmov.Clfaux 
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH integral.cb-dmov ~
      WHERE cb-dmov.CodCia = s-codcia ~
 AND cb-dmov.Codcta = x-CodCta ~
 AND cb-dmov.Codope BEGINS x-CodOpe ~
 AND cb-dmov.ClfAux BEGINS x-ClfAux ~
 AND cb-dmov.Codaux BEGINS x-CodAux ~
 AND cb-dmov.Periodo = s-periodo ~
 AND cb-dmov.NroMes = s-NroMes NO-LOCK INDEXED-REPOSITION.
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 integral.cb-dmov
&Scoped-define TABLES-IN-QUERY-BROWSE-2 integral.cb-dmov 

/* Definitions for DIALOG-BOX DIALOG-1                                  */
&Scoped-define FIELDS-IN-QUERY-DIALOG-1 integral.cb-auxi.Codaux ~
integral.cb-auxi.Nomaux 
&Scoped-define ENABLED-FIELDS-IN-QUERY-DIALOG-1 
&Scoped-define OPEN-BROWSERS-IN-QUERY-DIALOG-1 ~
    ~{&OPEN-QUERY-BROWSE-2}
&Scoped-define OPEN-QUERY-DIALOG-1 OPEN QUERY DIALOG-1 FOR EACH integral.cb-auxi ~
      WHERE cb-auxi.CodCia = y-CodCia ~
 AND cb-auxi.Clfaux = x-ClfAux ~
 AND cb-auxi.Codaux = x-CodAux SHARE-LOCK.
&Scoped-define FIRST-TABLE-IN-QUERY-DIALOG-1 integral.cb-auxi
&Scoped-define TABLES-IN-QUERY-DIALOG-1 integral.cb-auxi 

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-continuar 
     LABEL "&Continuar" 
     SIZE 13 BY 1.

DEFINE BUTTON B-operacion 
     IMAGE-UP FILE "adeicon/y-combo"
     LABEL "" 
     SIZE 3.57 BY .96.

DEFINE BUTTON B-print 
     IMAGE-UP FILE "IMG/print"
     LABEL "" 
     SIZE 6 BY 1.69.

DEFINE BUTTON B-salir AUTO-END-KEY 
     LABEL "&Atr s" 
     SIZE 13 BY 1.

DEFINE BUTTON B-suma 
     IMAGE-UP FILE "G:/integral/IMG/suma-u"
     IMAGE-DOWN FILE "G:/integral/IMG/suma-d"
     IMAGE-INSENSITIVE FILE "G:/integral/IMG/suma-i"
     LABEL "" 
     SIZE 6 BY 1.69.

DEFINE VARIABLE Combo-mon AS CHARACTER FORMAT "X(256)":U INITIAL "S/." 
     LABEL "Moneda" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "S/.","US$" 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE F-operacion AS CHARACTER FORMAT "X(256)":U 
     LABEL "Operaci¢n" 
     VIEW-AS FILL-IN 
     SIZE 39 BY .96 NO-UNDO.

DEFINE VARIABLE x-suma AS DECIMAL FORMAT "(ZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "Suma" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 86.3 BY 2
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 86.3 BY 9
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 59 BY 3
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 86.3 BY 2.58
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 27.29 BY 3
     BGCOLOR 8 .


/* Query definitions                                                    */
DEFINE QUERY BROWSE-2 FOR integral.cb-dmov SCROLLING.
DEFINE QUERY DIALOG-1 FOR integral.cb-auxi SCROLLING.

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2 QUERY BROWSE-2 NO-LOCK DISPLAY 
      integral.cb-dmov.Codope COLUMN-LABEL "Opera-!ci¢n"
      integral.cb-dmov.Codaux COLUMN-LABEL "C¢digo!Auxil."
      integral.cb-dmov.Nroast COLUMN-LABEL "Compro-!bante"
      integral.cb-dmov.Glodoc
      integral.cb-dmov.Nrodoc COLUMN-LABEL "N£mero de!Documento"
      integral.cb-dmov.TpoMov
      integral.cb-dmov.ImpMn1 COLUMN-LABEL "Importe!(Soles)"
      integral.cb-dmov.ImpMn2 COLUMN-LABEL "Importe!(D¢lares)"
      integral.cb-dmov.Coddoc COLUMN-LABEL "C¢digo!Docum."
      integral.cb-dmov.Fchdoc COLUMN-LABEL "Fecha!Docum."
      integral.cb-dmov.Fchvto COLUMN-LABEL "Fecha!Vcto."
      integral.cb-dmov.Nroref COLUMN-LABEL "N£mero de!Referencia"
      integral.cb-dmov.Clfaux COLUMN-LABEL "Clasif.!Auxil"
    WITH SEPARATORS MULTIPLE SIZE 82 BY 8
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     integral.cb-auxi.Codaux AT ROW 1.5 COL 1 COLON-ALIGNED HELP
          "C¢digo de Auxiliar" NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
          BGCOLOR 1 FGCOLOR 15 
     integral.cb-auxi.Nomaux AT ROW 1.5 COL 10 COLON-ALIGNED HELP
          "Nombre de Auxiliar" NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
          BGCOLOR 1 FGCOLOR 15 
     Combo-mon AT ROW 1.5 COL 77 COLON-ALIGNED
     BROWSE-2 AT ROW 3.5 COL 3
     F-operacion AT ROW 13 COL 13 COLON-ALIGNED
     B-operacion AT ROW 13 COL 54
     x-suma AT ROW 13 COL 66 COLON-ALIGNED
     B-continuar AT ROW 15.5 COL 5
     B-salir AT ROW 15.5 COL 22
     B-suma AT ROW 15.5 COL 69
     B-print AT ROW 15.5 COL 78
     RECT-2 AT ROW 1 COL 1
     RECT-3 AT ROW 3 COL 1
     RECT-4 AT ROW 12 COL 1
     RECT-7 AT ROW 12 COL 60
     RECT-5 AT ROW 15 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         TITLE "Consulta".

 


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

ASSIGN 
       B-operacion:AUTO-RESIZE IN FRAME DIALOG-1      = TRUE.

/* SETTINGS FOR FILL-IN integral.cb-auxi.Codaux IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN integral.cb-auxi.Nomaux IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-suma IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "integral.cb-dmov"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = ""
     _JoinCode[1]      = ?
     _Where[1]         = "cb-dmov.CodCia = s-codcia
 AND cb-dmov.Codcta = x-CodCta
 AND cb-dmov.Codope BEGINS x-CodOpe
 AND cb-dmov.ClfAux BEGINS x-ClfAux
 AND cb-dmov.Codaux BEGINS x-CodAux
 AND cb-dmov.Periodo = s-periodo
 AND cb-dmov.NroMes = s-NroMes"
     _FldNameList[1]   = integral.cb-dmov.Codope
     _FldLabelList[1]  = "Opera-!ci¢n"
     _FldNameList[2]   = integral.cb-dmov.Codaux
     _FldLabelList[2]  = "C¢digo!Auxil."
     _FldNameList[3]   = integral.cb-dmov.Nroast
     _FldLabelList[3]  = "Compro-!bante"
     _FldNameList[4]   = integral.cb-dmov.Glodoc
     _FldNameList[5]   = integral.cb-dmov.Nrodoc
     _FldLabelList[5]  = "N£mero de!Documento"
     _FldNameList[6]   = integral.cb-dmov.TpoMov
     _FldNameList[7]   = integral.cb-dmov.ImpMn1
     _FldLabelList[7]  = "Importe!(Soles)"
     _FldNameList[8]   = integral.cb-dmov.ImpMn2
     _FldLabelList[8]  = "Importe!(D¢lares)"
     _FldNameList[9]   = integral.cb-dmov.Coddoc
     _FldLabelList[9]  = "C¢digo!Docum."
     _FldNameList[10]   = integral.cb-dmov.Fchdoc
     _FldLabelList[10]  = "Fecha!Docum."
     _FldNameList[11]   = integral.cb-dmov.Fchvto
     _FldLabelList[11]  = "Fecha!Vcto."
     _FldNameList[12]   = integral.cb-dmov.Nroref
     _FldLabelList[12]  = "N£mero de!Referencia"
     _FldNameList[13]   = integral.cb-dmov.Clfaux
     _FldLabelList[13]  = "Clasif.!Auxil"
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX DIALOG-1
/* Query rebuild information for DIALOG-BOX DIALOG-1
     _TblList          = "integral.cb-auxi"
     _Options          = "SHARE-LOCK"
     _OrdList          = ""
     _JoinCode[1]      = ?
     _Where[1]         = "cb-auxi.CodCia = y-CodCia
 AND cb-auxi.Clfaux = x-ClfAux
 AND cb-auxi.Codaux = x-CodAux"
     _Query            is OPENED
*/  /* DIALOG-BOX DIALOG-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DIALOG-1 DIALOG-1
ON ENTRY OF FRAME DIALOG-1 /* Consulta */
DO:
    RUN suma.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-continuar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-continuar DIALOG-1
ON CHOOSE OF B-continuar IN FRAME DIALOG-1 /* Continuar */
DO:
    IF RECID(cb-dmov) = ?
    THEN DO:
        BELL.
        MESSAGE "Seleccione s¢lo un Movimiento" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    FIND cb-dmov WHERE RECID(cb-dmov)  = RegAct  NO-LOCK NO-ERROR.
    FIND cb-cmov WHERE cb-cmov.CodCia  = cb-dmov.CodCia   AND
                       cb-cmov.Periodo = cb-dmov.Periodo  AND
                       cb-cmov.NroMes  = cb-dmov.NroMes   AND
                       cb-cmov.CodOpe  = cb-dmov.CodOpe   AND
                       cb-cmov.NroAst  = cb-dmov.NroAst NO-LOCK NO-ERROR.
    RegAct = RECID(cb-cmov).
    RUN cbd/cbdcons3.w(RegAct, y-codcia).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-operacion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-operacion DIALOG-1
ON CHOOSE OF B-operacion IN FRAME DIALOG-1
DO:
    RUN cbd/q-oper.w(y-CodCia, OUTPUT RECID-stack).
    IF RECID-stack <> 0
    THEN DO:
        FIND cb-oper
             WHERE RECID(cb-oper) = RECID-stack NO-LOCK  NO-ERROR.
        IF AVAILABLE cb-oper
        THEN DO:
            DISPLAY cb-oper.NomOpe @ F-operacion WITH FRAME DIALOG-1.
            x-CodOpe = cb-oper.CodOpe.
            {&OPEN-QUERY-{&BROWSE-NAME}}
            RUN suma.
            APPLY "ENTRY" TO BROWSE-2.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-suma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-suma DIALOG-1
ON CHOOSE OF B-suma IN FRAME DIALOG-1
DO:
    ASSIGN x-Suma1 = 0
           x-Suma2 = 0.
    DO i = 1 TO BROWSE-2:NUM-SELECTED-ROWS:
        pto1 = BROWSE-2:FETCH-SELECTED-ROW(i).
        IF NOT cb-dmov.TpoMov AND cb-dmov.ImpMn1 <> ? AND cb-dmov.ImpMn2 <> ?
        THEN DO:
            x-Suma1 = x-Suma1 + cb-dmov.ImpMn1.
            x-Suma2 = x-Suma2 + cb-dmov.ImpMn2.
        END.
        ELSE DO:
            x-Suma1 = x-Suma1 - cb-dmov.ImpMn1.
            x-Suma2 = x-Suma2 - cb-dmov.ImpMn2.
        END.
    END.
    IF Combo-mon:SCREEN-VALUE IN FRAME DIALOG-1 = "S/."
    THEN DISPLAY x-Suma1 @ x-Suma WITH FRAME DIALOG-1.
    ELSE DISPLAY x-Suma2 @ x-Suma WITH FRAME DIALOG-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 DIALOG-1
ON VALUE-CHANGED OF BROWSE-2 IN FRAME DIALOG-1
DO:
    RegAct = RECID(cb-dmov).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Combo-mon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Combo-mon DIALOG-1
ON VALUE-CHANGED OF Combo-mon IN FRAME DIALOG-1 /* Moneda */
DO:
    pto1 = BROWSE-2:MOVE-COLUMN(6, 7).
    IF Combo-mon:SCREEN-VALUE IN FRAME DIALOG-1 = "S/."
    THEN DISPLAY x-Suma1 @ x-Suma WITH FRAME DIALOG-1.
    ELSE DISPLAY x-Suma2 @ x-Suma WITH FRAME DIALOG-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-operacion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-operacion DIALOG-1
ON F8 OF F-operacion IN FRAME DIALOG-1 /* Operaci¢n */
DO:
    APPLY "CHOOSE" TO B-operacion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-operacion DIALOG-1
ON LEAVE OF F-operacion IN FRAME DIALOG-1 /* Operaci¢n */
DO:
    IF F-operacion = "" THEN x-CodOpe = "".
    {&OPEN-QUERY-{&BROWSE-NAME}}
    RUN suma.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DIALOG-1 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    find cb-ctas WHERE cb-ctas.CodCia = y-CodCia AND
                       cb-ctas.CodCta = x-CodCta NO-LOCK NO-ERROR.
    RUN enable_UI.
    WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DIALOG-1 _DEFAULT-DISABLE
PROCEDURE disable_UI :
/* --------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
   -------------------------------------------------------------------- */
  /* Hide all frames. */
  HIDE FRAME DIALOG-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DIALOG-1 _DEFAULT-ENABLE
PROCEDURE enable_UI :
/* --------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
   -------------------------------------------------------------------- */

  {&OPEN-QUERY-DIALOG-1}
  GET FIRST DIALOG-1.
  DISPLAY Combo-mon F-operacion x-suma 
      WITH FRAME DIALOG-1.
  IF AVAILABLE integral.cb-auxi THEN 
    DISPLAY integral.cb-auxi.Codaux integral.cb-auxi.Nomaux 
      WITH FRAME DIALOG-1.
  ENABLE RECT-2 Combo-mon RECT-3 BROWSE-2 RECT-4 RECT-7 F-operacion B-operacion 
         RECT-5 B-continuar B-salir B-suma B-print 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE suma DIALOG-1 
PROCEDURE suma :
ASSIGN x-Suma1 = 0
           x-Suma2 = 0.
    FOR EACH cb-dmov WHERE cb-dmov.CodCia  = s-codcia AND
                           cb-dmov.Periodo = s-periodo    AND
                           cb-dmov.NroMes  = s-NroMes    AND
                           cb-dmov.ClfAux  = x-ClfAux AND
                           cb-dmov.CodAux  = x-CodAux AND
                           cb-dmov.CodCta  = x-CodCta AND
                           cb-dmov.CodOpe  BEGINS x-CodOpe:
        IF NOT cb-dmov.TpoMov AND cb-dmov.ImpMn1 <> ? AND cb-dmov.ImpMn2 <> ?
        THEN DO:
            x-Suma1 = x-Suma1 + cb-dmov.ImpMn1.
            x-Suma2 = x-Suma2 + cb-dmov.ImpMn2.
        END.
        ELSE DO:
            x-Suma1 = x-Suma1 - cb-dmov.ImpMn1.
            x-Suma2 = x-Suma2 - cb-dmov.ImpMn2.
        END.
    END.
    IF Combo-mon:SCREEN-VALUE IN FRAME DIALOG-1 = "S/."
    THEN DISPLAY x-Suma1 @ x-Suma WITH FRAME DIALOG-1.
    ELSE DISPLAY x-Suma2 @ x-Suma WITH FRAME DIALOG-1.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE BROWSE-NAME
&UNDEFINE FRAME-NAME
&UNDEFINE WINDOW-NAME
