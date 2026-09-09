&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME    W-Detalle
&Scoped-define FRAME-NAME     W-Detalle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Detalle 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 06/26/95 - 12:00 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE {&NEW} SHARED VARIABLE s-codcia       AS INTEGER INITIAL 1.
DEFINE {&NEW} SHARED VARIABLE cb-niveles AS CHARACTER INITIAL "2,3,4,5".
DEFINE VARIABLE RECID-ACT   AS RECID.
DEFINE VARIABLE RECID-stack AS RECID.
DEFINE VARIABLE cb-codcia  AS INTEGER INITIAL 0.
DEFINE VARIABLE CREAR       AS LOGICAL.
DEFINE VARIABLE pto         AS LOGICAL.
DEFINE VARIABLE x-nomcta    AS CHARACTER.

FIND Empresas WHERE Empresas.CodCia = s-codcia.
IF NOT Empresas.Campo-CodCbd  THEN cb-codcia = s-codcia.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ********************  Preprocessor Definitions  ******************** */

/* Name of first Frame and/or Browse (alphabetically)                   */
&Scoped-define FRAME-NAME  W-Detalle
&Scoped-define BROWSE-NAME brw-Detalle

/* Custom List Definitions                                              */
&Scoped-define LIST-1 
&Scoped-define LIST-2 
&Scoped-define LIST-3 

/* Definitions for BROWSE brw-Detalle                                   */
&Scoped-define FIELDS-IN-QUERY-brw-Detalle integral.cb-cfgc.CodCta ~
(x-nomcta) integral.cb-cfgc.Metodo 
&Scoped-define OPEN-QUERY-brw-Detalle OPEN QUERY brw-Detalle FOR EACH integral.cb-cfgc ~
      WHERE integral.cb-cfgc.CodCia = cb-codcia ~
 AND integral.cb-cfgc.CodCfg = 3 NO-LOCK.
&Scoped-define FIRST-TABLE-IN-QUERY-brw-Detalle integral.cb-cfgc
&Scoped-define TABLES-IN-QUERY-brw-Detalle integral.cb-cfgc 

/* Definitions for DIALOG-BOX W-Detalle                                 */
&Scoped-define FIELDS-IN-QUERY-W-Detalle 
&Scoped-define ENABLED-FIELDS-IN-QUERY-W-Detalle 
&Scoped-define OPEN-BROWSERS-IN-QUERY-W-Detalle ~
    ~{&OPEN-QUERY-brw-Detalle}

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-acepta 
     LABEL "&Acepta" 
     SIZE 9.72 BY 1.08.

DEFINE BUTTON b-add 
     LABEL "&Adicionar" 
     SIZE 9.72 BY 1.08.

DEFINE BUTTON B-Cancela 
     LABEL "&Cancela" 
     SIZE 9.72 BY 1.08.

DEFINE BUTTON B-del 
     LABEL "&Eliminar" 
     SIZE 9.72 BY 1.08.

DEFINE BUTTON b-mod 
     LABEL "&Modificar" 
     SIZE 9.72 BY 1.08.

DEFINE BUTTON b-salir AUTO-GO 
     LABEL "&Salir" 
     SIZE 9.72 BY 1.08.

DEFINE VARIABLE x-nombre AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descripci¢n" 
     VIEW-AS FILL-IN 
     SIZE 36 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 51 BY 2.19
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 51 BY 10.5
     BGCOLOR 8 .


/* Query definitions                                                    */
DEFINE QUERY brw-Detalle FOR integral.cb-cfgc SCROLLING.

/* Browse definitions                                                   */
DEFINE BROWSE brw-Detalle QUERY brw-Detalle NO-LOCK DISPLAY 
      integral.cb-cfgc.CodCta COLUMN-LABEL "C¢digo!cuenta"
&ANALYZE-SUSPEND
      (x-nomcta) COLUMN-LABEL "Descripci¢n" FORMAT "x(30)"
&ANALYZE-RESUME
      integral.cb-cfgc.Metodo COLUMN-LABEL "M‚-!todo"
    WITH SEPARATORS SIZE 49 BY 9.5
         BGCOLOR 15 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME W-Detalle
     brw-Detalle AT ROW 1.5 COL 2 HELP
          "`"
     integral.cb-cfgc.CodCta AT ROW 4 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY 1
          BGCOLOR 15 
     x-nombre AT ROW 6 COL 1.86
     integral.cb-cfgc.Metodo AT ROW 8 COL 12 COLON-ALIGNED HELP
          "M²todo"
          LABEL "M‚todo"
          VIEW-AS FILL-IN 
          SIZE 3.43 BY 1
          BGCOLOR 15 
     b-add AT ROW 12 COL 5
     B-acepta AT ROW 12 COL 10
     b-mod AT ROW 12 COL 16
     B-del AT ROW 12 COL 27
     B-Cancela AT ROW 12 COL 33
     b-salir AT ROW 12 COL 38
     RECT-3 AT ROW 1 COL 1
     RECT-2 AT ROW 11.5 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 
         TITLE "P‚rdidas y Ganancias por Naturaleza".

 


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
ASSIGN 
       FRAME W-Detalle:SCROLLABLE       = FALSE.

/* SETTINGS FOR BUTTON B-acepta IN FRAME W-Detalle
   NO-ENABLE                                                            */
ASSIGN 
       B-acepta:HIDDEN IN FRAME W-Detalle           = TRUE.

/* SETTINGS FOR BUTTON B-Cancela IN FRAME W-Detalle
   NO-ENABLE                                                            */
ASSIGN 
       B-Cancela:HIDDEN IN FRAME W-Detalle           = TRUE.

/* SETTINGS FOR FILL-IN integral.cb-cfgc.CodCta IN FRAME W-Detalle
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       integral.cb-cfgc.CodCta:HIDDEN IN FRAME W-Detalle           = TRUE.

/* SETTINGS FOR FILL-IN integral.cb-cfgc.Metodo IN FRAME W-Detalle
   NO-DISPLAY NO-ENABLE EXP-LABEL                                       */
ASSIGN 
       integral.cb-cfgc.Metodo:HIDDEN IN FRAME W-Detalle           = TRUE.

/* SETTINGS FOR FILL-IN x-nombre IN FRAME W-Detalle
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       x-nombre:HIDDEN IN FRAME W-Detalle           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brw-Detalle
/* Query rebuild information for BROWSE brw-Detalle
     _TblList          = "integral.cb-cfgc"
     _Options          = "NO-LOCK"
     _OrdList          = ""
     _JoinCode[1]      = ?
     _Where[1]         = "integral.cb-cfgc.CodCia = cb-codcia
 AND integral.cb-cfgc.CodCfg = 3"
     _FldNameList[1]   = integral.cb-cfgc.CodCta
     _FldLabelList[1]  = "C¢digo!cuenta"
     _FldNameList[2]   = "(x-nomcta)"
     _FldLabelList[2]  = "Descripci¢n"
     _FldFormatList[2] = "x(30)"
     _FldNameList[3]   = integral.cb-cfgc.Metodo
     _FldLabelList[3]  = "M‚-!todo"
     _Query            is OPENED
*/  /* BROWSE brw-Detalle */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX W-Detalle
/* Query rebuild information for DIALOG-BOX W-Detalle
     _TblList          = ""
     _Options          = "SHARE-LOCK"
     _OrdList          = ""
     _Query            is NOT OPENED
*/  /* DIALOG-BOX W-Detalle */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-acepta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-acepta W-Detalle
ON CHOOSE OF B-acepta IN FRAME W-Detalle /* Acepta */
DO:
    FIND integral.cb-ctas WHERE integral.cb-ctas.CodCia = cb-codcia AND
        integral.cb-ctas.CodCta = integral.cb-cfgc.CodCta:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas
    THEN DO:
         BELL.
         MESSAGE "Cuenta no registrada" VIEW-AS ALERT-BOX.
         APPLY "ENTRY" TO integral.cb-cfgc.codcta.
         RETURN NO-APPLY.
    END.
    IF integral.cb-cfgc.metodo:SCREEN-VALUE = "" THEN DO.
        MESSAGE "Los d¡gitos v lidos son :" SKIP
                "  'S'   Saldo de la Cuenta" SKIP
                "  'D'   Importe Debe"       SKIP
                "  'H'   Importe Haber"      SKIP
             VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO integral.cb-cfgc.metodo.
        RETURN NO-APPLY.
    END.
    ASSIGN integral.cb-cfgc.Codcta
           integral.cb-cfgc.Metodo.
    ASSIGN integral.cb-cfgc.Codcta:visible = NO
           integral.cb-cfgc.metodo:visible = NO
           x-nombre:visible = NO
           B-Acepta:visible = NO
           B-Cancela:visible = NO
           B-Add:visible = YES
           B-Mod:visible = YES
           B-Del:visible = YES
           B-Salir:visible = YES.
    DISABLE integral.cb-cfgc.Codcta
            integral.cb-cfgc.Metodo
            x-nombre
            B-Acepta B-Cancela
       WITH FRAME W-Detalle.
    BRW-Detalle:visible = YES.
    IF crear THEN
        {&OPEN-QUERY-BRW-Detalle}
    ELSE pto = BRW-Detalle:REFRESH().
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-add W-Detalle
ON CHOOSE OF b-add IN FRAME W-Detalle /* Adicionar */
DO:
    ASSIGN BRW-Detalle:visible = NO 
           B-Add:visible = NO
           B-Mod:visible = NO
           B-Del:visible = NO
           B-Salir:visible = NO
           B-Acepta:visible = YES
           B-Cancela:visible = YES.
    CREATE integral.cb-cfgc.
    CREAR  = yes.
    RECID-ACT = RECID( integral.cb-cfgc ).
    ASSIGN integral.cb-cfgc.CodCia = cb-codcia
           integral.cb-cfgc.codcfg = 3
           x-nombre = "".
    DISPLAY integral.cb-cfgc.Codcta
            integral.cb-cfgc.Metodo
            x-nombre
        WITH FRAME W-Detalle.
    ENABLE integral.cb-cfgc.Codcta
           integral.cb-cfgc.Metodo
           B-Acepta B-Cancela
        WITH FRAME W-Detalle.
    APPLY "ENTRY" TO integral.cb-cfgc.Codcta.
    RETURN NO-APPLY.
    WAIT-FOR CHOOSE OF B-Acepta OR CHOOSE OF B-Cancela.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Cancela W-Detalle
ON CHOOSE OF B-Cancela IN FRAME W-Detalle /* Cancela */
DO:
    IF CREAR THEN DELETE integral.cb-cfgc.

    ASSIGN integral.cb-cfgc.Codcta:visible = NO
           integral.cb-cfgc.metodo:visible = NO
           x-nombre:visible = NO
           B-Acepta:visible = NO
           B-Cancela:visible = NO
           B-Add:visible = YES
           B-Mod:visible = YES
           B-Del:visible = YES
           B-Salir:visible = YES.
    DISABLE integral.cb-cfgc.Codcta
            integral.cb-cfgc.metodo
            B-Acepta B-Cancela
       WITH FRAME W-Detalle.
    BRW-Detalle:visible = YES.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-del W-Detalle
ON CHOOSE OF B-del IN FRAME W-Detalle /* Eliminar */
DO:
    RECID-ACT = RECID( integral.cb-cfgc ).
    DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        FIND integral.cb-cfgc WHERE RECID-ACT = RECID( integral.cb-cfgc )
            EXCLUSIVE NO-ERROR.
        IF NOT AVAILABLE integral.cb-cfgc
        THEN DO:
            CLEAR FRAME F-maestro.
            MESSAGE "Registro no existente." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
            RETURN.
        END.
        MESSAGE "Eliminar el Registro"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE selection AS LOGICAL.
        IF selection THEN DO:
            DELETE integral.cb-cfgc.
            {&OPEN-QUERY-BRW-Detalle}
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-mod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-mod W-Detalle
ON CHOOSE OF b-mod IN FRAME W-Detalle /* Modificar */
DO:
    CREAR     = NO.
    RECID-ACT = RECID( integral.cb-cfgc ).
    DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        FIND integral.cb-cfgc WHERE RECID-ACT = RECID( integral.cb-cfgc )
            EXCLUSIVE NO-ERROR.
        IF NOT AVAILABLE integral.cb-cfgc
        THEN DO:
            MESSAGE "Registro no existente" VIEW-AS ALERT-BOX ERROR.
            RETURN.
        END.
        ASSIGN BRW-Detalle:visible = NO 
               B-Add:visible = NO
               B-Mod:visible = NO
               B-Del:visible = NO
               B-Salir:visible = NO        
               B-Acepta:visible = YES
               B-Cancela:visible = YES
               x-nombre = x-nomcta.
        DISPLAY integral.cb-cfgc.codCta
                integral.cb-cfgc.metodo
                x-nombre
            WITH FRAME W-Detalle.  
        ENABLE integral.cb-cfgc.metodo
               B-Acepta B-Cancela
             WITH FRAME W-Detalle.
        APPLY "ENTRY" TO integral.cb-cfgc.metodo.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-salir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-salir W-Detalle
ON CHOOSE OF b-salir IN FRAME W-Detalle /* Salir */
DO:
    APPLY "CLOSE":U TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brw-Detalle
&Scoped-define SELF-NAME brw-Detalle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brw-Detalle W-Detalle
ON DELETE-CHARACTER OF brw-Detalle IN FRAME W-Detalle
DO:
    APPLY "CHOOSE" TO B-del.
    RETURN NO-APPLY.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brw-Detalle W-Detalle
ON INSERT-MODE OF brw-Detalle IN FRAME W-Detalle
DO:
    APPLY "CHOOSE" TO b-add.
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brw-Detalle W-Detalle
ON MOUSE-SELECT-DBLCLICK OF brw-Detalle IN FRAME W-Detalle
DO:
    APPLY "CHOOSE" TO B-mod.
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brw-Detalle W-Detalle
ON RETURN OF brw-Detalle IN FRAME W-Detalle
DO:
    APPLY "CHOOSE" TO b-mod.
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME integral.cb-cfgc.CodCta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.cb-cfgc.CodCta W-Detalle
ON F8 OF integral.cb-cfgc.CodCta IN FRAME W-Detalle /* Cuenta */
DO:
    RUN cbd/q-cb-ctas.w(cb-codcia, OUTPUT RECID-stack).
    IF RECID-stack <> 0
    THEN DO:
        FIND integral.cb-ctas WHERE RECID( integral.cb-ctas) = RECID-stack
        NO-LOCK NO-ERROR.
        IF AVAIL integral.cb-ctas
        THEN DO:
            cb-cfgc.CodCta:SCREEN-VALUE = cb-ctas.CodCta.
            x-Nombre:SCREEN-VALUE       = cb-ctas.NomCta.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.
    APPLY "ENTRY":U TO integral.cb-cfgc.CodCta.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.cb-cfgc.CodCta W-Detalle
ON LEAVE OF integral.cb-cfgc.CodCta IN FRAME W-Detalle /* Cuenta */
DO:
    IF LAST-EVENT:WIDGET-ENTER = B-Cancela:HANDLE THEN RETURN.
    FIND integral.cb-ctas WHERE integral.cb-ctas.CodCia = cb-codcia AND
        integral.cb-ctas.CodCta = integral.cb-cfgc.CodCta:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas
    THEN DO:
         BELL.
         MESSAGE "Cuenta no registrada" VIEW-AS ALERT-BOX.
         APPLY "ENTRY" TO integral.cb-cfgc.codcta.
         RETURN NO-APPLY.
    END.
    x-nombre:SCREEN-VALUE = integral.cb-ctas.NomCta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.cb-cfgc.CodCta W-Detalle
ON MOUSE-SELECT-DBLCLICK OF integral.cb-cfgc.CodCta IN FRAME W-Detalle /* Cuenta */
DO:
    APPLY "F8" TO integral.cb-cfgc.codcta.
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME integral.cb-cfgc.Metodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.cb-cfgc.Metodo W-Detalle
ON ANY-PRINTABLE OF integral.cb-cfgc.Metodo IN FRAME W-Detalle /* M‚todo */
DO:
    IF LOOKUP( CAPS ( CHR( LASTKEY ) ), "S,D,H") = 0
    THEN DO:
        MESSAGE "Los d¡gitos v lidos son :" SKIP
                "  'S'   Saldo de la Cuenta" SKIP
                "  'D'   Importe Debe"       SKIP
                "  'H'   Importe Haber"      SKIP
             VIEW-AS ALERT-BOX ERROR.        
        BELL.
        RETURN NO-APPLY.
    END.    
    SELF:SCREEN-VALUE = CAPS( CHR( LASTKEY ) ).
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Detalle 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

ON CLOSE OF THIS-PROCEDURE
    RUN disable_UI.

ON "ENDKEY", END-ERROR , ERROR OF FRAME {&FRAME-NAME}
DO:
    IF B-cancela:VISIBLE THEN DO:
        APPLY "CHOOSE":U TO B-cancela.
        RETURN NO-APPLY.
    END.
    IF B-salir:VISIBLE   THEN APPLY "CHOOSE":U TO B-salir.
    RETURN NO-APPLY.
END.

ON "GO" OF FRAME {&FRAME-NAME}
DO: 
    IF B-cancela:VISIBLE THEN DO:
        APPLY "CHOOSE":U TO B-acepta.
        RETURN NO-APPLY.
    END.
    IF B-salir:VISIBLE   THEN APPLY "CHOOSE":U TO B-salir.
    RETURN NO-APPLY.
END.

ON FIND OF integral.cb-cfgc
DO:
    x-nomcta = "".
    FIND integral.cb-ctas WHERE integral.cb-ctas.codcia = cb-codcia AND
        integral.cb-ctas.codcta = integral.cb-cfgc.codcta NO-LOCK NO-ERROR.
    IF AVAIL integral.cb-ctas THEN x-nomcta = integral.cb-ctas.nomcta. 
END.

ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "CLOSE":U TO SELF.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN enable_UI.
    ASSIGN
        integral.cb-cfgc.codcta:VISIBLE = FALSE
        integral.cb-cfgc.metodo:VISIBLE = FALSE
        x-nombre:VISIBLE = FALSE.
    WAIT-FOR CLOSE OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Detalle _DEFAULT-DISABLE
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
  HIDE FRAME W-Detalle.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Detalle _DEFAULT-ENABLE
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
  ENABLE RECT-3 brw-Detalle RECT-2 b-add b-mod B-del b-salir 
      WITH FRAME W-Detalle.
  {&OPEN-BROWSERS-IN-QUERY-W-Detalle}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE BROWSE-NAME
&UNDEFINE FRAME-NAME
&UNDEFINE WINDOW-NAME
