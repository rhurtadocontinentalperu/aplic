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
&Scoped-Define ENABLED-OBJECTS x-codmon COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 ~
BUTTON-1 Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS x-codmon COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 ~
f-Mensaje 

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
     SIZE 8 BY 1.73.

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\tbldat":U
     LABEL "Button 1" 
     SIZE 12 BY 1.73.

DEFINE VARIABLE COMBO-BOX-Mes-1 AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Desde el mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "01","02","03","04","05","06","07","08","09","10","11","12" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Mes-2 AS INTEGER FORMAT "99":U INITIAL 12 
     LABEL "Hasta el mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "01","02","03","04","05","06","07","08","09","10","11","12" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .81 NO-UNDO.

DEFINE VARIABLE x-codmon AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dólares", 2
     SIZE 9 BY 1.35 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     x-codmon AT ROW 1.38 COL 11 NO-LABEL WIDGET-ID 34
     COMBO-BOX-Mes-1 AT ROW 1.38 COL 33 COLON-ALIGNED WIDGET-ID 48
     COMBO-BOX-Mes-2 AT ROW 2.35 COL 33 COLON-ALIGNED WIDGET-ID 50
     BUTTON-1 AT ROW 3.69 COL 4 WIDGET-ID 46
     Btn_Cancel AT ROW 3.69 COL 16
     f-Mensaje AT ROW 4.46 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     "Moneda:" VIEW-AS TEXT
          SIZE 6.86 BY .65 AT ROW 1.38 COL 4 WIDGET-ID 24
     SPACE(54.27) SKIP(3.84)
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

/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME gDialog
   NO-ENABLE                                                            */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 gDialog
ON CHOOSE OF BUTTON-1 IN FRAME gDialog /* Button 1 */
DO:
    ASSIGN 
        x-codmon
        COMBO-BOX-Mes-1 
        COMBO-BOX-Mes-2.

    RUN Texto.
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

ASSIGN
    t-d = 0
    t-h = 0
    x-totdebe = 0
    x-tothabe = 0.

REPEAT:
    s-task-no = RANDOM(1, 999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no 
                    AND w-report.Llave-C = s-user-id NO-LOCK) THEN LEAVE.
END.

FOR EACH cb-cmov NO-LOCK WHERE cb-cmov.codcia = s-codcia         
    AND cb-cmov.periodo = s-periodo           
    AND cb-cmov.nromes  >= COMBO-BOX-Mes-1
    AND cb-cmov.nromes  <= COMBO-BOX-Mes-2:
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
        "Mes: " + STRING(cb-cmov.nromes, '99') +
        " Libro: " + cb-cmov.codope + " Asiento: " + cb-cmov.nroast.
    FIND cb-oper WHERE cb-oper.codcia = cb-codcia AND 
        cb-oper.codope = cb-cmov.codope NO-LOCK NO-ERROR.                                         
    ASSIGN
        x-codope = cb-oper.codope
        x-nom-ope = cb-oper.nomope.
    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia =  cb-cmov.codcia  
        AND cb-dmov.periodo = s-periodo           
        AND cb-dmov.nromes  = s-NroMes           
        AND cb-dmov.codope  = cb-cmov.codope  
        AND cb-dmov.nroast  = cb-cmov.nroast  
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
                w-report.campo-i[1] = x-orden
                w-report.campo-i[2] = cb-cmov.nromes.
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
            w-report.campo-i[1] = x-orden
            w-report.campo-i[2] = cb-cmov.nromes.
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
            w-report.campo-i[1] = x-orden
            w-report.campo-i[2] = cb-cmov.nromes.
        x-orden = x-orden + 1.
    END.    
    x-con-reg = 0.
END.
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

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
  DISPLAY x-codmon COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 f-Mensaje 
      WITH FRAME gDialog.
  ENABLE x-codmon COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 BUTTON-1 Btn_Cancel 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
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

x-Archivo = 'Diario.txt'.

SYSTEM-DIALOG GET-FILE x-Archivo
  FILTERS 'Texto' '*.txt'
  ASK-OVERWRITE
  CREATE-TEST-FILE
  DEFAULT-EXTENSION '.txt'
  RETURN-TO-START-DIR 
  USE-FILENAME
  SAVE-AS
  UPDATE x-rpta.
IF x-rpta = NO THEN RETURN.


RUN Carga-Temporal.
FIND FIRST w-report WHERE w-report.task-no = s-task-no 
    AND w-report.Llave-C = s-user-id NO-LOCK NO-ERROR.
IF NOT AVAILABLE w-report THEN DO:
    MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

OUTPUT STREAM REPORT TO VALUE(x-Archivo).
PUT STREAM REPORT UNFORMATTED
    "DMES|DNUMASIOPE|DNUMCTACON|DFECOPE|DGLOSA|DCENCOS|DDEBE|DHABER|DINTREG"
    SKIP.
FOR EACH w-report NO-LOCK WHERE w-report.task-no = s-task-no
    AND w-report.Llave-C = s-user-id
    BY w-report.Campo-i[1] BY w-report.Campo-c[1] BY w-report.Campo-c[2]:
    PUT STREAM REPORT 
        w-report.campo-i[2] FORMAT "99"     '|'
        w-report.campo-c[2] FORMAT 'X(6)'   '|'
        w-report.campo-c[9] FORMAT 'X(8)'   '|'
        w-report.campo-d[1] FORMAT "99/99/9999" '|'
        w-report.campo-c[10] FORMAT 'x(50)' '|'
        w-report.campo-c[7] FORMAT 'X(2)'   '|'
        w-report.campo-f[1] FORMAT '->>>>>>>>>>>9.99' '|'
        w-report.campo-f[2] FORMAT '->>>>>>>>>>>9.99' '|'
        '|'
        SKIP.
END.
OUTPUT STREAM REPORT CLOSE.
MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

