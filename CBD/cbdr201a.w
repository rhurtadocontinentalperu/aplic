&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
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

{src/adm2/widgetprto.i}

    DEFINE STREAM report.
    DEFINE BUFFER B-Cuentas FOR cb-ctas.

    /* VARIABLES GENERALES :  IMPRESION,SISTEMA,MODULO,USUARIO */
    DEFINE VARIABLE l-immediate-display AS LOGICAL NO-UNDO.
    DEFINE VARIABLE x-Raya     AS CHARACTER FORMAT "X(150)" NO-UNDO.

    DEFINE        SHARED VARIABLE s-user-id  LIKE _user._userid.
    DEFINE        VARIABLE x-Detalle LIKE Modulos.Detalle NO-UNDO.
    DEFINE        VARIABLE i           AS INTEGER NO-UNDO.
    DEFINE        VARIABLE OKpressed   AS LOGICAL NO-UNDO.
    DEFINE        VARIABLE x-con-reg    AS INTEGER NO-UNDO.
    DEFINE        VARIABLE x-smon       AS CHARACTER FORMAT "X(3)".

    DEFINE        VARIABLE PTO        AS LOGICAL NO-UNDO .


    /*VARIABLES PARTICULARES DE LA RUTINA */
    DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)" NO-UNDO.
    DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-" 
                                                    LABEL "Debe      ".
    DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-" 
                                                    LABEL "Haber     ".
    DEFINE VARIABLE x-totdebe  AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-".
    DEFINE VARIABLE x-tothabe  AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-".
    DEFINE VARIABLE x-codope   LIKE cb-cmov.Codope.
    DEFINE VARIABLE x-nom-ope  LIKE cb-oper.nomope.
    DEFINE VARIABLE x-nroast   LIKE cb-cmov.Nroast.
    DEFINE VARIABLE x-fecha    LIKE cb-cmov.fchast.
    DEFINE VARIABLE x-glodoc   LIKE cb-dmov.glodoc.

    DEFINE SHARED VARIABLE s-NroMes    AS INTEGER INITIAL 10.
    DEFINE SHARED VARIABLE s-periodo    AS INTEGER INITIAL 1996.
    DEFINE SHARED VARIABLE s-codcia AS INTEGER INITIAL 4.
    DEFINE SHARED VARIABLE s-nomcia AS CHARACTER FORMAT "X(40)".

    DEF SHARED VAR cb-codcia AS INT.
    DEF SHARED VAR cl-codcia AS INT.
    DEF SHARED VAR pv-codcia AS INT.

    DEFINE IMAGE IMAGE-1
         FILENAME "IMG/print"
         SIZE 5 BY 1.5.

    DEFINE FRAME F-Mensaje
         IMAGE-1 AT ROW 1.5 COL 5
         "Espere un momento" VIEW-AS TEXT
              SIZE 18 BY 1 AT ROW 1.5 COL 16
              font 4
         "por favor ...." VIEW-AS TEXT
              SIZE 10 BY 1 AT ROW 2.5 COL 19
              font 4
         "F10 = Cancela Reporte" VIEW-AS TEXT
              SIZE 21 BY 1 AT ROW 3.5 COL 12
              font 4          
         SPACE(10.28) SKIP /*SKIP(0.14)*/
        WITH CENTERED OVERLAY KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
             BGCOLOR 15 FGCOLOR 0 
             TITLE "Imprimiendo ...".

    def var t-d as decimal init 0.
    def var t-h as decimal init 0.

    DEF VAR s-task-no AS INT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME gDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-Div v-fecha-1 x-codmon y-codope v-fecha-2 ~
x-a1 x-a2 x-Impresora Btn_OK BUTTON-2 Btn_Cancel BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS x-Div v-fecha-1 x-codmon y-codope ~
v-fecha-2 x-a1 x-a2 x-Impresora 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Cancel" 
     SIZE 8 BY 1.88.

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img/print.ico":U
     LABEL "OK" 
     SIZE 8 BY 1.88.

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\tbldat":U
     LABEL "Button 1" 
     SIZE 12 BY 1.5.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 8 BY 1.88.

DEFINE VARIABLE v-fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde la Fecha" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v-fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta la Fecha" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-a1 AS CHARACTER FORMAT "X(6)":U 
     LABEL "Del Comprobante" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-a2 AS CHARACTER FORMAT "X(6)":U 
     LABEL "Al Comprobante" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-Div AS CHARACTER FORMAT "X(5)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE y-codope AS CHARACTER FORMAT "X(3)":U 
     LABEL "Operación" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE x-codmon AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dólares", 2
     SIZE 12.57 BY 1.35 NO-UNDO.

DEFINE VARIABLE x-Impresora AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Impresora matricial", 1,
"Impresora Laser", 2
     SIZE 17 BY 2.15 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     x-Div AT ROW 1.81 COL 26.72 COLON-ALIGNED WIDGET-ID 38
     v-fecha-1 AT ROW 1.81 COL 48 COLON-ALIGNED HELP
          "EN BLANCO ACEPTA TODAS LA FECHAS DEL MES" WIDGET-ID 26
     x-codmon AT ROW 2.58 COL 5.14 NO-LABEL WIDGET-ID 34
     y-codope AT ROW 2.58 COL 26.72 COLON-ALIGNED WIDGET-ID 40
     v-fecha-2 AT ROW 2.58 COL 48 COLON-ALIGNED WIDGET-ID 28
     x-a1 AT ROW 3.35 COL 48 COLON-ALIGNED WIDGET-ID 30
     x-a2 AT ROW 4.12 COL 48 COLON-ALIGNED WIDGET-ID 32
     x-Impresora AT ROW 4.23 COL 4 NO-LABEL WIDGET-ID 42
     Btn_OK AT ROW 6.65 COL 3
     BUTTON-2 AT ROW 6.65 COL 11 WIDGET-ID 4
     Btn_Cancel AT ROW 6.65 COL 19
     BUTTON-1 AT ROW 6.92 COL 28 WIDGET-ID 46
     "Moneda" VIEW-AS TEXT
          SIZE 8 BY .65 AT ROW 1.46 COL 3.14 WIDGET-ID 24
     SPACE(53.99) SKIP(6.88)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Libro Diario General"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* Libro Diario General */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* OK */
DO:
    ASSIGN v-fecha-1
           v-fecha-2
           x-codmon
           y-CodOpe
           x-a1
           x-a2
           x-div
           x-Impresora.
    IF s-NroMes = 0 OR s-NroMes = 13 THEN
    IF x-codmon = 1 THEN x-smon = "S/.".
    ELSE                 x-smon = "US$".
    IF y-codope <> "" AND
         NOT CAN-FIND(FIRST cb-oper  WHERE cb-oper.codcia = cb-codcia AND
                                        cb-oper.codope = y-codope)
    THEN DO:
        BELL.
        MESSAGE "Código de operación no existe " + Y-CODOPE
                VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO y-codope.
        RETURN NO-APPLY.
    END.
    IF x-div  <> "" AND
         NOT CAN-FIND(FIRST GN-DIVI   WHERE GN-DIVI.codcia = S-codcia AND
                                            GN-DIVI.codDIV = x-div) 
    THEN DO:                                        
         BELL.
         MESSAGE "División No Registrada" + Y-CODOPE
                VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO x-div.
         RETURN NO-APPLY.
    END.                                            

    IF v-fecha-1 = ?   THEN v-fecha-1 = DATE(1,1,1).
    IF v-fecha-2 = ?   THEN v-fecha-2 = DATE(12,31,9999).
    IF x-a1      = ""  THEN x-a1      = "000000".
    IF x-a2      = ""  THEN x-a2      = "999999".

        RUN Imprimir.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 gDialog
ON CHOOSE OF BUTTON-1 IN FRAME gDialog /* Button 1 */
DO:
    ASSIGN v-fecha-1
           v-fecha-2
           x-codmon
           y-CodOpe
           x-a1
           x-a2
           x-div
           x-Impresora.
    IF s-NroMes = 0 OR s-NroMes = 13 THEN
    IF x-codmon = 1 THEN x-smon = "S/.".
    ELSE                 x-smon = "US$".
    IF y-codope <> "" AND
         NOT CAN-FIND(FIRST cb-oper  WHERE cb-oper.codcia = cb-codcia AND
                                        cb-oper.codope = y-codope)
    THEN DO:
        BELL.
        MESSAGE "Código de operación no existe " + Y-CODOPE
                VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO y-codope.
        RETURN NO-APPLY.
    END.
    IF x-div  <> "" AND
         NOT CAN-FIND(FIRST GN-DIVI   WHERE GN-DIVI.codcia = S-codcia AND
                                            GN-DIVI.codDIV = x-div) 
    THEN DO:                                        
         BELL.
         MESSAGE "División No Registrada" + Y-CODOPE
                VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO x-div.
         RETURN NO-APPLY.
    END.                                            

    IF v-fecha-1 = ?   THEN v-fecha-1 = DATE(1,1,1).
    IF v-fecha-2 = ?   THEN v-fecha-2 = DATE(12,31,9999).
    IF x-a1      = ""  THEN x-a1      = "000000".
    IF x-a2      = ""  THEN x-a2      = "999999".

    RUN Texto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 gDialog
ON CHOOSE OF BUTTON-2 IN FRAME gDialog /* Button 2 */
DO:
    ASSIGN v-fecha-1
           v-fecha-2
           x-codmon
           y-CodOpe
           x-a1
           x-a2
           x-div.
    IF s-NroMes = 0 OR s-NroMes = 13 THEN
    IF x-codmon = 1 THEN x-smon = "S/.".
    ELSE                 x-smon = "US$".
    IF y-codope <> "" AND
         NOT CAN-FIND(FIRST cb-oper  WHERE cb-oper.codcia = cb-codcia AND
                                        cb-oper.codope = y-codope)
    THEN DO:
        BELL.
        MESSAGE "Código de operación no existe " + Y-CODOPE
                VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO y-codope.
        RETURN NO-APPLY.
    END.
    IF x-div  <> "" AND
         NOT CAN-FIND(FIRST GN-DIVI   WHERE GN-DIVI.codcia = S-codcia AND
                                            GN-DIVI.codDIV = x-div) 
    THEN DO:                                        
         BELL.
         MESSAGE "División No Registrada" + Y-CODOPE
                VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO x-div.
         RETURN NO-APPLY.
    END.                                            
    IF v-fecha-1 = ?   THEN v-fecha-1 = DATE(1,1,1).
    IF v-fecha-2 = ?   THEN v-fecha-2 = DATE(12,31,9999).
    IF x-a1      = ""  THEN x-a1      = "000000".
    IF x-a2      = ""  THEN x-a2      = "999999".

  RUN Excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Div
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Div gDialog
ON F8 OF x-Div IN FRAME gDialog /* División */
OR "MOUSE-SELECT-DBLCLICK":U OF X-DIV DO:
 
 {CBD/H-DIVI01.I NO SELF}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME y-codope
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL y-codope gDialog
ON F8 OF y-codope IN FRAME gDialog /* Operación */
DO:
   DEF VAR X AS RECID.
   RUN cbd/q-oper(cb-codcia,output X).
   FIND cb-oper WHERE RECID(cb-oper) = X
        NO-LOCK NO-ERROR.
   IF AVAILABLE cb-oper THEN DO:
        ASSIGN {&SELF-NAME} = cb-oper.CodOpe.
        DISPLAY {&SELF-NAME} WITH FRAME {&FRAME-NAME}.
   END.     
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal gDialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Orden AS INT INIT 1.

    t-d = 0.
    t-h = 0.
    x-totdebe = 0.
    x-tothabe = 0.

    REPEAT:
        s-task-no = RANDOM(1, 999999).
        IF NOT CAN-FIND(FIRST w-report WHERE
            w-report.task-no = s-task-no AND
            w-report.Llave-C = s-user-id NO-LOCK) THEN LEAVE.
    END.
    
    VIEW FRAME f-mensaje.
    PAUSE 0.

    FOR EACH cb-cmov NO-LOCK WHERE cb-cmov.codcia = s-codcia         
        AND cb-cmov.periodo = s-periodo           
        AND cb-cmov.nromes  = s-NroMes           
        AND cb-cmov.codope BEGINS (y-codope)  
        AND cb-cmov.fchast >= v-fecha-1       
        AND cb-cmov.fchast <= v-fecha-2       
        AND cb-cmov.nroast >= x-a1            
        AND cb-cmov.nroast <= x-a2 
        BREAK BY cb-cmov.codope 
        WITH FRAME f-cab:
        FIND cb-oper WHERE cb-oper.codcia = cb-codcia 
            AND cb-oper.codope = cb-cmov.codope NO-LOCK NO-ERROR.                                         
        x-codope = cb-oper.codope.                     
        x-nom-ope = cb-oper.nomope.
        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia =  cb-cmov.codcia  
            AND cb-dmov.periodo = s-periodo           
            AND cb-dmov.nromes  = s-NroMes           
            AND cb-dmov.codope  = cb-cmov.codope  
            AND cb-dmov.nroast  = cb-cmov.nroast  
            AND cb-dmov.coddiv  BEGINS (x-div) 
            BREAK BY (cb-dmov.nroast):
            x-glodoc = glodoc.
            IF x-glodoc = "" THEN RUN p-nom-aux.
            IF x-glodoc = "" THEN x-glodoc = cb-cmov.notast.
            /* limipamos la glosa */
            x-glodoc = REPLACE(x-glodoc, CHR(13), " " ).
            x-glodoc = REPLACE(x-glodoc, CHR(10), " " ).
            x-glodoc = REPLACE(x-glodoc, CHR(12), " " ).
            /* ****************** */
            IF NOT tpomov THEN 
                CASE x-codmon:
                    WHEN 1 THEN DO:
                        x-debe  = ImpMn1.
                        x-haber = 0.
                    END.
                    WHEN 2 THEN DO:
                        x-debe  = ImpMn2.
                        x-haber = 0.
                    END.
                    WHEN 3 THEN DO:
                        x-debe  = ImpMn3.
                        x-haber = 0.
                    END.
                END CASE.
            ELSE 
                CASE x-codmon:
                    WHEN 1 THEN DO:
                        x-debe  = 0.
                        x-haber = ImpMn1.
                    END.
                    WHEN 2 THEN DO:
                        x-debe  = 0.
                        x-haber = ImpMn2.
                    END.
                    WHEN 3 THEN DO:
                        x-debe  = 0.
                        x-haber = ImpMn3.
                    END.
               END CASE.            
                
            IF NOT (x-haber = 0 AND x-debe = 0) AND x-debe <> ? AND x-haber <> ? THEN DO:
                x-totdebe = x-totdebe + x-debe.
                x-tothabe = x-tothabe + x-haber.
                t-d       = t-d       + x-debe.
                t-h       = t-h       + x-haber.
                ACCUMULATE x-debe  (SUB-TOTAL BY cb-dmov.nroast).
                ACCUMULATE x-haber (SUB-TOTAL BY cb-dmov.nroast).
                IF (x-codmon = 1) AND (cb-dmov.codmon = 2) AND (cb-dmov.impmn2 > 0) THEN DO:
                    x-glodoc = SUBSTRING(x-glodoc,1,11).
                    IF LENGTH(x-glodoc) < 11 THEN x-glodoc = x-glodoc + FILL(" ",14 - LENGTH(x-glodoc)).     
                    x-glodoc = x-glodoc + " ($" +  STRING(cb-dmov.impmn2,"ZZ,ZZZ,ZZ9.99") + ")". 
                END.
                CREATE w-report.
                ASSIGN
                    w-report.task-no = s-task-no
                    w-report.llave-c = s-user-id
                    w-report.llave-i = s-codcia
                    w-report.campo-c[1] = cb-cmov.codope
                    w-report.campo-d[1] = cb-cmov.fchast
                    w-report.campo-c[2] = cb-cmov.nroast
                    w-report.campo-d[2] = cb-dmov.fchdoc
                    w-report.campo-c[3] = cb-dmov.coddoc
                    w-report.campo-c[4] = cb-dmov.nrodoc
                    w-report.campo-d[3] = cb-dmov.fchvto
                    w-report.campo-c[5] = cb-dmov.clfaux
                    w-report.campo-c[6] = cb-dmov.codaux
                    w-report.campo-c[7] = cb-dmov.cco
                    w-report.campo-c[8] = cb-dmov.coddiv
                    w-report.campo-c[9] = cb-dmov.codcta
                    w-report.campo-c[10] = x-glodoc
                    w-report.campo-f[1] = x-debe
                    w-report.campo-f[2] = x-haber
                    w-report.campo-c[20] = x-nom-ope
                    w-report.campo-i[1] = x-orden.
                x-con-reg = x-con-reg + 1.
                x-orden = x-orden + 1.
            END.    
        END.  /* FIN DEL FOR EACH cb-dmov */
        IF cb-cmov.flgest = "A" THEN DO:
            CREATE w-report.
            ASSIGN
                w-report.task-no = s-task-no
                w-report.llave-c = s-user-id
                w-report.campo-c[1] = cb-cmov.codope
                w-report.campo-d[1] = cb-cmov.fchast
                w-report.campo-c[2] = cb-cmov.nroast
                w-report.campo-c[10] = "******* A N U L A D O *******"
                w-report.campo-c[20] = x-nom-ope
                w-report.campo-i[1] = x-orden.
            x-orden = x-orden + 1.
        END.      
        IF x-con-reg = 0 AND cb-cmov.flgest <> "A" THEN DO:
            CREATE w-report.
            ASSIGN
                w-report.task-no = s-task-no
                w-report.llave-c = s-user-id
                w-report.campo-c[1] = cb-cmov.codope
                w-report.campo-d[1] = cb-cmov.fchast
                w-report.campo-c[2] = cb-cmov.nroast
                w-report.campo-c[10] = cb-cmov.notast
                w-report.campo-c[20] = x-nom-ope
                w-report.campo-i[1] = x-orden.
            x-orden = x-orden + 1.
        END.    
        x-con-reg = 0.
    END.
    HIDE FRAME f-mensaje.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  DISPLAY x-Div v-fecha-1 x-codmon y-codope v-fecha-2 x-a1 x-a2 x-Impresora 
      WITH FRAME gDialog.
  ENABLE x-Div v-fecha-1 x-codmon y-codope v-fecha-2 x-a1 x-a2 x-Impresora 
         Btn_OK BUTTON-2 Btn_Cancel BUTTON-1 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel gDialog 
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

    t-d = 0.
    t-h = 0.
    x-totdebe = 0.
    x-tothabe = 0.

    VIEW FRAME f-mensaje.
    PAUSE 0.

    FOR EACH cb-cmov NO-LOCK WHERE cb-cmov.codcia = s-codcia         
        AND cb-cmov.periodo = s-periodo           
        AND cb-cmov.nromes  = s-NroMes           
        AND cb-cmov.codope BEGINS (y-codope)  
        AND cb-cmov.fchast >= v-fecha-1       
        AND cb-cmov.fchast <= v-fecha-2       
        AND cb-cmov.nroast >= x-a1            
        AND cb-cmov.nroast <= x-a2 
        BREAK BY cb-cmov.codope 
        WITH FRAME f-cab:
        IF FIRST-OF(cb-cmov.codope) THEN DO:
            /* titulos */
            RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT pinta-mes ).
            pinta-mes = "MES DE " + pinta-mes + " DE " + STRING( s-periodo , "9999" ).
            FIND cb-oper WHERE cb-oper.codcia = cb-codcia AND 
                                   cb-oper.codope = cb-cmov.codope NO-LOCK NO-ERROR.                                         
            x-codope = cb-oper.codope.                     
            RUN bin/_centrar.p ( INPUT cb-oper.nomope, 40 , OUTPUT x-nom-ope ).
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = "D I A R I O    G E N E R A L".
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = pinta-mes.
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = "L I B R O " + x-codope.
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = x-nom-ope.
            iCount = iCount + 2.
            /* set the column names for the Worksheet */
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = "Fecha Asiento".
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = "Comprobante".
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = "Fecha Doc.".
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = "Cod. Doc.".
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = "Nro. Doc.".
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = "Fecha Vcto.".
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = "Clf. Aux.".
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = "Auxiliar".
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = "C. Costo".
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):Value = "División".
            cRange = "K" + cColumn.
            chWorkSheet:Range(cRange):Value = "Cuenta".
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = "Glosa".
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = "Debe".
            cRange = "N" + cColumn.
            chWorkSheet:Range(cRange):Value = "Haber".
            iCount = iCount + 1.
        END.
        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia =  cb-cmov.codcia  
            AND cb-dmov.periodo = s-periodo           
            AND cb-dmov.nromes  = s-NroMes           
            AND cb-dmov.codope  = cb-cmov.codope  
            AND cb-dmov.nroast  = cb-cmov.nroast  
            AND cb-dmov.coddiv  BEGINS (x-div) 
            BREAK BY (cb-dmov.nroast):
            x-glodoc = glodoc.
            IF x-glodoc = "" THEN RUN p-nom-aux.
            IF x-glodoc = "" THEN x-glodoc = cb-cmov.notast.
            IF NOT tpomov THEN 
                CASE x-codmon:
                    WHEN 1 THEN DO:
                        x-debe  = ImpMn1.
                        x-haber = 0.
                    END.
                    WHEN 2 THEN DO:
                        x-debe  = ImpMn2.
                        x-haber = 0.
                    END.
                    WHEN 3 THEN DO:
                        x-debe  = ImpMn3.
                        x-haber = 0.
                    END.
                END CASE.
            ELSE 
                CASE x-codmon:
                    WHEN 1 THEN DO:
                        x-debe  = 0.
                        x-haber = ImpMn1.
                    END.
                    WHEN 2 THEN DO:
                        x-debe  = 0.
                        x-haber = ImpMn2.
                    END.
                    WHEN 3 THEN DO:
                        x-debe  = 0.
                        x-haber = ImpMn3.
                    END.
               END CASE.            
                
            IF NOT (x-haber = 0 AND x-debe = 0) AND x-debe <> ? AND x-haber <> ? THEN DO:
                x-totdebe = x-totdebe + x-debe.
                x-tothabe = x-tothabe + x-haber.
                t-d       = t-d       + x-debe.
                t-h       = t-h       + x-haber.
                ACCUMULATE x-debe  (SUB-TOTAL BY cb-dmov.nroast).
                ACCUMULATE x-haber (SUB-TOTAL BY cb-dmov.nroast).
                IF (x-codmon = 1) AND (cb-dmov.codmon = 2) AND (cb-dmov.impmn2 > 0) THEN DO:
                    x-glodoc = SUBSTRING(x-glodoc,1,11).
                    IF LENGTH(x-glodoc) < 11 THEN x-glodoc = x-glodoc + FILL(" ",14 - LENGTH(x-glodoc)).     
                    x-glodoc = x-glodoc + " ($" +  STRING(cb-dmov.impmn2,"ZZ,ZZZ,ZZ9.99") + ")". 
                END.
                cColumn = STRING(iCount).
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-cmov.fchast.
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-cmov.nroast.
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-dmov.fchdoc.
                cRange = "D" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-cmov.coddoc.
                cRange = "E" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-dmov.nrodoc.
                cRange = "F" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-dmov.fchvto.
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-dmov.clfaux.
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-dmov.codaux.
                cRange = "I" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-dmov.cco.
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-dmov.coddiv.
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-dmov.codcta.
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = x-glodoc.
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Value = x-debe.
                cRange = "N" + cColumn.
                chWorkSheet:Range(cRange):Value = x-haber.
                iCount = iCount + 1.
                x-con-reg = x-con-reg + 1.
            END.    
            IF LAST-OF (cb-dmov.nroast) AND x-con-reg > 0
            THEN DO:
                x-glodoc = "                TOTALES : " + x-smon.
                cColumn = STRING(iCount).
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = x-glodoc.
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe).
                cRange = "N" + cColumn.
                chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber).
                iCount = iCount + 1.
            END.
        END.  /* FIN DEL FOR EACH cb-dmov */
        IF cb-cmov.flgest = "A" THEN DO:
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-cmov.fchast.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-cmov.nroast.
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = "******* A N U L A D O *******".
            iCount = iCount + 1.
        END.      
        IF x-con-reg = 0 AND cb-cmov.flgest <> "A" THEN DO:
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-cmov.fchast.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-cmov.nroast.
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-cmov.notast.
            iCount = iCount + 1.
        END.    
        x-con-reg = 0.
        IF LAST-OF (cb-cmov.codope) THEN DO:
            cColumn = STRING(iCount).
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = "** TOTAL OPERACION ** " + x-smon.
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = x-totdebe.
            cRange = "N" + cColumn.
            chWorkSheet:Range(cRange):Value = x-tothabe.
            iCount = iCount + 1.
            x-tothabe = 0.
            x-totdebe = 0.
        END.
    END.
    cColumn = STRING(iCount).
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "** TOTAL GENERAL ** " + x-smon.
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = t-d.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = t-h.
    iCount = iCount + 1.
    HIDE FRAME f-mensaje.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR gDialog 
PROCEDURE IMPRIMIR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR RB-REPORT-LIBRARY AS CHAR NO-UNDO.
DEF VAR RB-REPORT-NAME AS CHAR NO-UNDO.
DEF VAR RB-INCLUDE-RECORDS AS CHAR NO-UNDO.
DEF VAR RB-FILTER AS CHAR NO-UNDO.
DEF VAR RB-OTHER-PARAMETERS AS CHAR NO-UNDO.
    
RUN Carga-Temporal.

    FIND FIRST w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT pinta-mes ).
    pinta-mes = "MES DE " + pinta-mes + " DE " + STRING( s-periodo , "9999" ).

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "CBD\RBCBD.PRL"
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER =
            "w-report.task-no = " + STRING(s-task-no) +
            " AND w-report.Llave-C = '" + s-user-id + "'"
        RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia +
                                "~npinta-mes = " + pinta-mes +
                                "~nx-smon = " + x-smon.
    IF x-Impresora = 1 
    THEN RB-REPORT-NAME = "Libro Diario General Draft".
    ELSE RB-REPORT-NAME = "Libro Diario General Laser".

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE p-nom-aux gDialog 
PROCEDURE p-nom-aux :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                CASE cb-dmov.clfaux:
                WHEN "@CL" THEN DO:
                    FIND gn-clie WHERE gn-clie.codcli = cb-dmov.codaux
                                    AND gn-clie.CodCia = cl-codcia
                                 NO-LOCK NO-ERROR. 
                    IF AVAILABLE gn-clie THEN x-glodoc = gn-clie.nomcli.
                END.
                WHEN "@PV" THEN DO:
                    FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                                    AND gn-prov.CodCia = pv-codcia
                                NO-LOCK NO-ERROR.                      
                    IF AVAILABLE gn-prov THEN x-glodoc = gn-prov.nompro.
                END.
                WHEN "@CT" THEN DO:
                    find cb-ctas WHERE cb-ctas.codcta = cb-dmov.codaux
                                    AND cb-ctas.CodCia = cb-codcia
                                NO-LOCK NO-ERROR.                      
                   IF AVAILABLE cb-ctas THEN 
                        x-glodoc = cb-ctas.nomcta.
                END.
                OTHERWISE DO:
                    FIND cb-auxi WHERE cb-auxi.clfaux = cb-dmov.clfaux
                                    AND cb-auxi.codaux = cb-dmov.codaux
                                    AND cb-auxi.CodCia = cb-codcia
                                NO-LOCK NO-ERROR.                      
                    IF AVAILABLE cb-auxi THEN 
                        x-glodoc = cb-auxi.nomaux.
                END.
                END CASE.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto gDialog 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR x-Archivo AS CHAR NO-UNDO.
    DEF VAR x-Rpta    AS LOG  NO-UNDO.

    x-Archivo = 'DiarioGeneral' + STRING(s-Periodo, '9999') + STRING(s-NroMes, '99') + 's.txt'.

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


RUN Carga-Temporal.

    FIND FIRST w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.


/*
DEFINE FRAME f-cab
   w-report.campo-d[1] COLUMN-LABEL "FchAst|" FORMAT '99/99/9999'
   '|'
   w-report.campo-c[2] COLUMN-LABEL "NroAst|" FORMAT 'x(6)'
   '|'
    w-report.campo-d[2] COLUMN-LABEL "FchDoc|" FORMAT '99/99/9999'
    '|'
    w-report.campo-c[3] COLUMN-LABEL "CodDoc|" FORMAT 'x(4)'
     '|'
    w-report.campo-c[4] COLUMN-LABEL "NroDoc|" FORMAT 'x(10)'
     '|'
    w-report.campo-d[3] COLUMN-LABEL "FchVto|" FORMAT '99/99/9999'
    '|'
    w-report.campo-c[5] COLUMN-LABEL "ClfAux|" FORMAT 'x(4)'
     '|'
    w-report.campo-c[6] COLUMN-LABEL "CodAux|" FORMAT 'x(11)'
     '|'
    w-report.campo-c[7] COLUMN-LABEL "Cc|" FORMAT 'x(2)'
     '|'
    w-report.campo-c[8] COLUMN-LABEL "CodDiv|" FORMAT 'x(5)'
     '|'
    w-report.campo-c[9] COLUMN-LABEL "CodCta|" FORMAT 'x(8)'
     '|'
    w-report.campo-c[10] COLUMN-LABEL "Detalle|" FORMAT 'x(25)'
     '|'
    w-report.campo-f[1] COLUMN-LABEL "Debe|" FORMAT '->>>>>>>>>>>9.99'
     '|'
    w-report.campo-f[2] COLUMN-LABEL "Haber|" FORMAT '->>>>>>>>>>>9.99'
     '|'
   WITH WIDTH 300 NO-BOX STREAM-IO NO-UNDERLINE DOWN.

OUTPUT STREAM REPORT TO VALUE(x-Archivo).

FOR EACH w-report NO-LOCK WHERE w-report.task-no = s-task-no
   AND w-report.Llave-C = s-user-id
   BY w-report.Campo-i[1] BY w-report.Campo-c[1] BY w-report.Campo-c[2]:
   DISPLAY STREAM REPORT
       w-report.campo-d[1] 
       w-report.campo-c[2] 
       w-report.campo-d[2] 
       w-report.campo-c[3] 
       w-report.campo-c[4] 
       w-report.campo-d[3] 
       w-report.campo-c[5] 
       w-report.campo-c[6] 
       w-report.campo-c[7] 
       w-report.campo-c[8] 
       w-report.campo-c[9] 
       w-report.campo-c[10] 
       w-report.campo-f[1] 
       w-report.campo-f[2] 
       WITH FRAME f-cab.
END.
PAGE STREAM REPORT.
OUTPUT STREAM REPORT CLOSE.

*/

DEF VAR x-d AS DEC FORMAT '->>>,>>>,>>9.99'.
DEF VAR x-h AS DEC FORMAT '->>>,>>>,>>9.99'.
DEF VAR x-c AS INT FORMAT '>>>>>>>>9'.
x-d = 0.
x-h = 0.
x-c = 0.
OUTPUT STREAM REPORT TO VALUE(x-Archivo).
FOR EACH w-report NO-LOCK WHERE w-report.task-no = s-task-no
   AND w-report.Llave-C = s-user-id
   BY w-report.Campo-i[1] BY w-report.Campo-c[1] BY w-report.Campo-c[2]:
    PUT STREAM REPORT
        s-Periodo FORMAT '9999'
        s-NroMes  FORMAT '99'
        w-report.campo-d[1] FORMAT "99/99/9999"
        w-report.campo-c[2] FORMAT 'X(6)'
        w-report.campo-d[2] FORMAT '99/99/9999'
        w-report.campo-c[3] FORMAT 'X(4)'
        w-report.campo-c[4] FORMAT 'X(10)'
        w-report.campo-d[3] FORMAT '99/99/9999'
        w-report.campo-c[5] FORMAT 'X(4)'
        w-report.campo-c[6] FORMAT 'X(11)'
        w-report.campo-c[7] FORMAT 'X(2)'
        w-report.campo-c[8] FORMAT 'X(5)'
        w-report.campo-c[9] FORMAT 'X(8)'
        w-report.campo-c[10] FORMAT 'x(25)'
        w-report.campo-f[1] FORMAT '->>>>>>>>>>>9.99'
        w-report.campo-f[2] FORMAT '->>>>>>>>>>>9.99'
        SKIP.
    ASSIGN
        x-d = x-d + w-report.campo-f[1]
        x-h = x-h + w-report.campo-f[2]
        x-c = x-c + 1.
END.
OUTPUT STREAM REPORT CLOSE.

MESSAGE 'Proceso Terminado' SKIP
    x-d SKIP x-h SKIP x-c
    VIEW-AS ALERT-BOX.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

