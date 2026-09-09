&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
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
    DEFINE TEMP-TABLE t-w-report LIKE w-report.

    /* VARIABLES GENERALES :  IMPRESION,SISTEMA,MODULO,USUARIO */
    DEF NEW SHARED VAR input-var-1 AS CHAR.
    DEF NEW SHARED VAR input-var-2 AS CHAR.
    DEF NEW SHARED VAR input-var-3 AS CHAR.
    DEF NEW SHARED VAR output-var-1 AS ROWID.
    DEF NEW SHARED VAR output-var-2 AS CHAR.
    DEF NEW SHARED VAR output-var-3 AS CHAR.

    DEFINE {&NEW} SHARED VARIABLE s-user-id  LIKE _user._userid.
    DEFINE {&NEW} SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,4,5".
    DEFINE        VARIABLE x-Detalle LIKE Modulos.Detalle NO-UNDO.
    DEFINE        VARIABLE i           AS INTEGER NO-UNDO.
    DEFINE        VARIABLE OKpressed   AS LOGICAL NO-UNDO.
    DEFINE        VARIABLE Ult-Nivel   AS INTEGER NO-UNDO.
    DEFINE        VARIABLE Max-Digitos AS INTEGER NO-UNDO.

    DEFINE        VARIABLE PTO        AS LOGICAL NO-UNDO.

    /*VARIABLES PARTICULARES DE LA RUTINA */
    DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)" NO-UNDO.
    DEFINE VARIABLE x-moneda   AS CHARACTER FORMAT "X(40)" NO-UNDO.
    DEFINE VARIABLE x-expres   AS CHARACTER FORMAT "X(40)" NO-UNDO.
    DEFINE VARIABLE x-fchast   AS CHARACTER FORMAT "X(5)" NO-UNDO.
    DEFINE VARIABLE x-fchdoc   AS CHARACTER FORMAT "X(5)" NO-UNDO.
    DEFINE VARIABLE x-fchvto   AS CHARACTER FORMAT "X(5)" NO-UNDO.
    DEFINE VARIABLE x-clfaux   LIKE cb-dmov.clfaux NO-UNDO.
    DEFINE VARIABLE x-codaux   LIKE cb-dmov.codaux NO-UNDO.
    DEFINE VARIABLE x-nroast   LIKE cb-dmov.nroast NO-UNDO.
    DEFINE VARIABLE x-codope   LIKE cb-dmov.codope NO-UNDO.
    DEFINE VARIABLE x-coddoc   LIKE cb-dmov.coddoc NO-UNDO.
    DEFINE VARIABLE x-nrodoc   LIKE cb-dmov.nrodoc NO-UNDO.
    DEFINE VARIABLE x-nroref   LIKE cb-dmov.nroref NO-UNDO.
    DEFINE VARIABLE x-glodoc   LIKE cb-dmov.glodoc NO-UNDO.
    DEFINE VARIABLE x-CodCta   LIKE cb-dmov.CodCta NO-UNDO.

    DEFINE VARIABLE x-Cco      LIKE cb-dmov.Cco    NO-UNDO.

    DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-" 
                               COLUMN-LABEL "M o v i m i!Cargos     " NO-UNDO. 
    DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-" 
                               COLUMN-LABEL "e n t o s      !Abonos     " NO-UNDO.
    DEFINE VARIABLE x-saldoi   AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-"
                               COLUMN-LABEL "Saldo     !Inicial    " NO-UNDO.
    DEFINE VARIABLE x-saldof   AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-"
                               COLUMN-LABEL "S a l d o!Deudor    " NO-UNDO.
    DEFINE VARIABLE x-deudor   AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-"
                               COLUMN-LABEL "S a l d o!Deudor    " NO-UNDO.
    DEFINE VARIABLE x-acreedor AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-" 
                               COLUMN-LABEL "A c t u a l    !Acreedor   " NO-UNDO.
    DEFINE VARIABLE x-importe AS DECIMAL FORMAT "->>>>>>>,>>9.99" 
                               COLUMN-LABEL "Importe S/." NO-UNDO. 
    DEFINE VARIABLE c-debe     AS DECIMAL NO-UNDO.
    DEFINE VARIABLE c-haber    AS DECIMAL NO-UNDO.
    DEFINE VARIABLE t-debe     AS DECIMAL NO-UNDO.
    DEFINE VARIABLE t-haber    AS DECIMAL NO-UNDO.
    DEFINE VARIABLE t-saldoi   AS DECIMAL NO-UNDO.
    DEFINE VARIABLE t-saldof   AS DECIMAL NO-UNDO.

    DEFINE VARIABLE x-conreg   AS INTEGER NO-UNDO.

    DEFINE VARIABLE v-Saldoi   AS DECIMAL   EXTENT 10 NO-UNDO.
    DEFINE VARIABLE v-Debe     AS DECIMAL   EXTENT 10 NO-UNDO.
    DEFINE VARIABLE v-Haber    AS DECIMAL   EXTENT 10 NO-UNDO.
    DEFINE VARIABLE v-CodCta   AS CHARACTER EXTENT 10 NO-UNDO.

    DEFINE SHARED VARIABLE s-NroMes    AS INTEGER.
    DEFINE SHARED VARIABLE s-periodo    AS INTEGER.
    DEFINE SHARED VARIABLE s-codcia AS INTEGER.
    DEFINE SHARED VARIABLE s-nomcia AS CHARACTER FORMAT "X(40)".
    DEFINE SHARED VARIABLE x-DIRCIA AS CHARACTER FORMAT "X(40)".
    DEFINE SHARED VARIABLE cb-codcia AS INTEGER.
    DEFINE SHARED VARIABLE cl-codcia AS INTEGER.
    DEFINE SHARED VARIABLE pv-codcia AS INTEGER.

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
         SPACE(10.28) SKIP(0.14)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
             BGCOLOR 15 FGCOLOR 0 
             TITLE "Imprimiendo ...".

    def var x-coddiv like cb-dmov.coddiv.

    def var x-codmon as integer init 1.
    def var x-clfaux-1 as char.
    def var x-clfaux-2 as char.

    DEF VAR G-NOMCTA AS CHAR FORMAT "X(60)".
    DEFINE VAR X-MENSAJE AS CHAR FORMAT "X(40)".
    DEFINE FRAME F-AUXILIAR
         X-MENSAJE
    WITH TITLE "Espere un momento por favor" VIEW-AS DIALOG-BOX CENTERED
              NO-LABELS.

    DEF VAR s-task-no AS INT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS C-Moneda COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 ~
BUTTON-1 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS C-Moneda COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 ~
f-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 8 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\tbldat":U
     LABEL "Button 1" 
     SIZE 12 BY 1.73.

DEFINE VARIABLE C-Moneda AS CHARACTER FORMAT "X(256)":U INITIAL "Soles" 
     LABEL "Moneda" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Soles","Dólares" 
     DROP-DOWN-LIST
     SIZE 16 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Mes-1 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Desde el mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "00","01","02","03","04","05","06","07","08","09","10","11","12" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Mes-2 AS INTEGER FORMAT "99":U INITIAL 12 
     LABEL "Hasta el mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "00","01","02","03","04","05","06","07","08","09","10","11","12" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     C-Moneda AT ROW 1.19 COL 9 COLON-ALIGNED WIDGET-ID 28
     COMBO-BOX-Mes-1 AT ROW 1.19 COL 42 COLON-ALIGNED WIDGET-ID 60
     COMBO-BOX-Mes-2 AT ROW 2.15 COL 42 COLON-ALIGNED WIDGET-ID 62
     BUTTON-1 AT ROW 3.69 COL 4 WIDGET-ID 50
     BtnDone AT ROW 3.69 COL 16 WIDGET-ID 56
     f-Mensaje AT ROW 4.46 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 58
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 72.57 BY 5.35 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Libro Mayor Analítico (detallado)"
         HEIGHT             = 5.35
         WIDTH              = 72.57
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Libro Mayor Analítico (detallado) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Libro Mayor Analítico (detallado) */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone wWin
ON CHOOSE OF BtnDone IN FRAME fMain /* Done */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* Button 1 */
DO:
    ASSIGN 
        C-Moneda COMBO-BOX-Mes-1 COMBO-BOX-Mes-2.
    Ult-Nivel   = NUM-ENTRIES(cb-niveles).
    Max-Digitos = INTEGER( ENTRY( Ult-Nivel, cb-niveles) ).
    RUN Texto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-Moneda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Moneda wWin
ON VALUE-CHANGED OF C-Moneda IN FRAME fMain /* Moneda */
DO:
  
  x-codmon = lookup (self:screen-value,c-moneda:list-items).
  
                                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal wWin 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR con-ctas AS INTEGER.
    DEF VAR xi AS INTEGER INIT 0.
    DEF VAR No-tiene-mov AS LOGICAL.
    DEF VAR x-Orden AS INT INIT 1.

    REPEAT:
        s-task-no = RANDOM(1, 999999).
        IF NOT CAN-FIND(FIRST t-w-report WHERE
            t-w-report.task-no = s-task-no AND
            t-w-report.Llave-C = s-user-id NO-LOCK) THEN LEAVE.
    END.
    
    ASSIGN t-debe   = 0
           t-haber  = 0
           t-saldoi = 0
           t-saldof = 0
           con-ctas = 0 .

    FOR EACH cb-ctas NO-LOCK WHERE cb-ctas.codcia = cb-codcia
        AND cb-ctas.CodCta <> ""
        AND LENGTH( cb-ctas.CodCta ) = Max-Digitos
        BREAK BY (cb-ctas.Codcta):
        x-CodCta = cb-ctas.CodCta.
        ASSIGN c-debe   = 0
               c-haber  = 0
               x-saldoi = 0 
               xi       = 0 
               No-tiene-mov = yes.
        ASSIGN x-nroast = x-codcta
               x-GloDoc = ""
               x-fchast = ""
               x-codope = ""
               x-fchDoc = ""
               x-nroDoc = ""
               x-fchVto = ""
               x-nroref = "".
        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia  = s-codcia
            AND cb-dmov.periodo = s-periodo 
            AND cb-dmov.nromes  >= COMBO-BOX-Mes-1
            AND cb-dmov.nromes  <= COMBO-BOX-Mes-2
            AND cb-dmov.codcta  = x-CodCta
            BREAK BY cb-dmov.CodOpe BY cb-dmov.NroAst BY cb-dmov.NroItm:
            f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
                "Cuenta: " + cb-dmov.codcta + " Operacion: " +  cb-dmov.codope + " Asiento: " + cb-dmov.nroast.
            No-tiene-mov = no.
            IF xi = 0 THEN DO:
               xi = xi + 1.
            END.    
            /* Buscando la cabecera correspondiente */
            x-fchast = ?.
            FIND cb-cmov WHERE cb-cmov.codcia  = cb-dmov.codcia
                           AND cb-cmov.periodo = cb-dmov.periodo 
                           AND cb-cmov.nromes  = cb-dmov.nromes
                           AND cb-cmov.codope  = cb-dmov.codope
                           AND cb-cmov.nroast  = cb-dmov.nroast
                           NO-LOCK NO-ERROR.
             IF AVAILABLE cb-cmov THEN x-fchast = STRING(cb-cmov.fchast, '99/99/9999').
             ASSIGN x-glodoc = cb-dmov.glodoc
                    x-NroAst = cb-dmov.NroAst
                    x-CodOpe = cb-dmov.CodOpe
                    x-codaux = cb-dmov.codaux
                    x-NroDoc = cb-dmov.NroDoc
                    x-NroRef = cb-dmov.NroRef
                    x-coddiv = cb-dmov.CodDiv
                    x-clfaux = cb-dmov.clfaux
                    x-coddoc = cb-dmov.coddoc
                    x-cco    = cb-dmov.cco.
             IF x-glodoc = "" THEN IF AVAILABLE cb-cmov THEN x-glodoc = cb-cmov.notast.
             IF  x-glodoc = "" THEN DO:
                CASE cb-dmov.clfaux:
                    WHEN "@CL" THEN DO:
                        FIND gn-clie WHERE gn-clie.codcli = cb-dmov.codaux
                                        AND gn-clie.CodCia = cl-codcia
                                    NO-LOCK NO-ERROR. 
                        IF AVAILABLE gn-clie THEN
                            x-glodoc = gn-clie.nomcli.
                    END.
                    WHEN "@PV" THEN DO:
                        FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                                        AND gn-prov.CodCia = pv-codcia
                                    NO-LOCK NO-ERROR.                      
                        IF AVAILABLE gn-prov THEN 
                            x-glodoc = gn-prov.nompro.
                    END.
                    WHEN "@CT" THEN DO:
                        find b-cuentas WHERE b-cuentas.codcta = cb-dmov.codaux
                                        AND b-cuentas.CodCia = cb-codcia
                                    NO-LOCK NO-ERROR.                      
                        IF AVAILABLE b-cuentas THEN x-glodoc = b-cuentas.nomcta.
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
            END.
            /* limipamos la glosa */
/*             x-glodoc = REPLACE(x-glodoc, CHR(13), " " ). */
/*             x-glodoc = REPLACE(x-glodoc, CHR(10), " " ). */
/*             x-glodoc = REPLACE(x-glodoc, CHR(12), " " ). */
            DEF VAR pGloDoc AS CHAR.
            RUN lib/limpiar-texto (x-glodoc," ",OUTPUT pGloDoc).
            x-GloDoc = pGloDoc.
            x-GloDoc = REPLACE(x-GloDoc, '?', ' ').
            /* ****************** */
            IF NOT tpomov THEN DO:
                x-importe = ImpMn1.
                CASE x-codmon:
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
                x-importe = ImpMn1 * -1. 
                CASE x-codmon:
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
            IF NOT (x-haber = 0 AND x-debe = 0) AND x-debe <> ? AND x-haber <> ? THEN DO:
                x-fchdoc = STRING(cb-dmov.fchdoc).  
                x-fchvto = STRING(cb-dmov.fchvto).
                t-Debe  = t-Debe  + x-Debe.
                t-Haber = t-Haber + x-Haber.
                c-Debe  = c-Debe  + x-Debe.
                c-Haber = c-Haber + x-Haber.
                CREATE t-w-report.
                ASSIGN
                    t-w-report.task-no = s-task-no 
                    t-w-report.Llave-C = s-user-id 
                    t-w-report.campo-i[1] = cb-dmov.nromes
                    t-w-report.campo-c[1] = cb-ctas.codcta
                    t-w-report.campo-c[2] = cb-ctas.nomcta
                    t-w-report.campo-c[3] = x-coddiv
                    t-w-report.campo-c[4] = x-cco
                    t-w-report.campo-c[20] = (IF x-fchast <> ? THEN x-fchast ELSE "")
                    t-w-report.campo-c[5] = x-nroast
                    t-w-report.campo-c[6] = x-codope
                    t-w-report.campo-c[7] = x-clfaux
                    t-w-report.campo-c[8] = x-codaux
                    t-w-report.campo-c[21] = (IF x-fchdoc <> ? THEN x-fchdoc ELSE "")
                    t-w-report.campo-c[9] = x-coddoc
                    t-w-report.campo-c[10] = x-nrodoc
                    t-w-report.campo-c[11] = x-nroref
                    t-w-report.campo-c[12] = x-glodoc
                    t-w-report.llave-i = x-Orden.
                x-Orden = x-Orden + 1.
                IF x-debe <> 0 THEN DO:
                    t-w-report.campo-f[1] = x-debe.
                END.
                IF x-haber <> 0 THEN DO:
                    t-w-report.campo-f[2] = x-haber.
                END.
                IF x-importe <> 0 AND x-codmon = 2 THEN DO:
                    t-w-report.campo-f[3] = x-importe.
                END.
                x-conreg = x-conreg + 1.
            END.            
        END.    /* FOR EACH cb-dmov */
        IF no-tiene-mov THEN NEXT.
        con-ctas = con-ctas + 1 .
    END.
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY C-Moneda COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 f-Mensaje 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE C-Moneda COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 BUTTON-1 BtnDone 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto wWin 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR x-Archivo AS CHAR NO-UNDO.
    DEF VAR x-Rpta    AS LOG  NO-UNDO.

    x-Archivo = 'Mayor.txt'.
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
    FIND FIRST t-w-report WHERE t-w-report.task-no = s-task-no AND
        t-w-report.Llave-C = s-user-id NO-LOCK NO-ERROR.
    IF NOT AVAILABLE t-w-report THEN DO:
        MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

   OUTPUT STREAM REPORT TO VALUE(x-Archivo).
   PUT STREAM REPORT
       "MMES|MNUMASIOPE|MNUMCTACON|MFECOPE|MGLOSA|MCCO|MDEBE|MHABER"
       SKIP.
   FOR EACH t-w-report NO-LOCK WHERE t-w-report.task-no = s-task-no
       AND t-w-report.Llave-C = s-user-id
       BY t-w-report.Llave-i BY t-w-report.Campo-c[1]:
       PUT STREAM REPORT
           t-w-report.campo-i[1] FORMAT '99' '|'
           t-w-report.campo-c[6] FORMAT 'x(3)'
           t-w-report.campo-c[5] FORMAT 'x(6)' '|'
           t-w-report.campo-c[1] FORMAT 'x(8)' '|'
           t-w-report.campo-c[20] FORMAT 'x(10)' '|'
           t-w-report.campo-c[12] FORMAT 'x(50)' '|'
           t-w-report.campo-c[4] FORMAT 'x(8)' '|'
           t-w-report.campo-f[1] FORMAT '->>>,>>>,>>>,>>9.99' '|'
           t-w-report.campo-f[2] FORMAT '->>>,>>>,>>>,>>9.99' '|'
           SKIP.
   END.
   OUTPUT STREAM REPORT CLOSE.
   MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

