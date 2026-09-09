&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME    W-Detalle
&Scoped-define FRAME-NAME     W-Detalle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Detalle 
/*------------------------------------------------------------------------

  File:              <cjatpcmb.w>

  Description:       Mantenimiento de Tipos de Cambio

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:  VALMIESA Dpto.de TECNOLOGIA
           Jorge L.Infante B.

  Created: 08/09/95 
  

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE               VARIABLE RECID-ACT   AS RECID.
DEFINE               VARIABLE RECID-stack AS RECID.
DEFINE {&NEW} SHARED VARIABLE s-codcia    AS INTEGER INITIAL 1.
DEFINE               VARIABLE cb-codcia  AS INTEGER INITIAL 0.
DEFINE               VARIABLE CREAR       AS LOGICAL.

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
&Scoped-define FIELDS-IN-QUERY-brw-Detalle integral.gn-tcmb.Fecha ~
integral.gn-tcmb.Compra integral.gn-tcmb.venta 
&Scoped-define OPEN-QUERY-brw-Detalle OPEN QUERY brw-Detalle FOR EACH integral.gn-tcmb NO-LOCK ~
    BY integral.gn-tcmb.Fecha.
&Scoped-define FIRST-TABLE-IN-QUERY-brw-Detalle integral.gn-tcmb
&Scoped-define TABLES-IN-QUERY-brw-Detalle integral.gn-tcmb 

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

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 47.86 BY 2.19
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 47.86 BY 10.5
     BGCOLOR 8 .


/* Query definitions                                                    */
DEFINE QUERY brw-Detalle FOR integral.gn-tcmb SCROLLING.

/* Browse definitions                                                   */
DEFINE BROWSE brw-Detalle QUERY brw-Detalle NO-LOCK DISPLAY 
      integral.gn-tcmb.Fecha COLUMN-LABEL "Fecha"
      integral.gn-tcmb.Compra
      integral.gn-tcmb.venta
    WITH SEPARATORS SIZE 33 BY 9.5
         BGCOLOR 15 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME W-Detalle
     brw-Detalle AT ROW 1.5 COL 9 HELP
          "`"
     integral.gn-tcmb.Fecha AT ROW 2.5 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY 1
          BGCOLOR 15 
     integral.gn-tcmb.Compra AT ROW 5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY 1
          BGCOLOR 15 FONT 1
     integral.gn-tcmb.Venta AT ROW 7.5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY 1
          BGCOLOR 15 FONT 1
     B-acepta AT ROW 12 COL 10
     B-del AT ROW 12 COL 26
     B-Cancela AT ROW 12 COL 30
     b-salir AT ROW 12 COL 37
     b-add AT ROW 12.04 COL 4
     b-mod AT ROW 12.04 COL 15
     RECT-3 AT ROW 1 COL 1.14
     RECT-2 AT ROW 11.5 COL 1.14
     SPACE(0.13) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 
         TITLE "Tipos de Cambio".

 


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

/* SETTINGS FOR FILL-IN integral.gn-tcmb.Compra IN FRAME W-Detalle
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       integral.gn-tcmb.Compra:HIDDEN IN FRAME W-Detalle           = TRUE.

/* SETTINGS FOR FILL-IN integral.gn-tcmb.Fecha IN FRAME W-Detalle
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       integral.gn-tcmb.Fecha:HIDDEN IN FRAME W-Detalle           = TRUE.

/* SETTINGS FOR FILL-IN integral.gn-tcmb.Venta IN FRAME W-Detalle
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       integral.gn-tcmb.Venta:HIDDEN IN FRAME W-Detalle           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brw-Detalle
/* Query rebuild information for BROWSE brw-Detalle
     _TblList          = "integral.gn-tcmb"
     _Options          = "NO-LOCK"
     _OrdList          = "integral.gn-tcmb.Fecha|yes"
     _FldNameList[1]   = integral.gn-tcmb.Fecha
     _FldLabelList[1]  = "Fecha"
     _FldNameList[2]   = integral.gn-tcmb.Compra
     _FldNameList[3]   = integral.gn-tcmb.venta
     _Query            is OPENED
*/  /* BROWSE brw-Detalle */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-acepta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-acepta W-Detalle
ON CHOOSE OF B-acepta IN FRAME W-Detalle /* Acepta */
DO:
    IF INPUT FRAME W-Detalle integral.gn-tcmb.Fecha = DATE ("  /  /  ") THEN DO:
        BELL.
        MESSAGE "Fecha de Cambio Obligatoria" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO integral.gn-tcmb.Fecha IN FRAME W-Detalle.
        RETURN NO-APPLY.
    END.    
    IF INPUT FRAME W-Detalle integral.gn-tcmb.Fecha > TODAY  THEN 
        DO:
            BELL.
            MESSAGE "Fecha Exede a la del Dia " VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO integral.gn-tcmb.Fecha IN FRAME W-Detalle.
            RETURN NO-APPLY.
        END.
    IF INPUT FRAME W-Detalle integral.gn-tcmb.Compra = 0
    THEN DO:
        BELL.
        MESSAGE "Debe Ingresar Tipo de Cambio Compra" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO integral.gn-tcmb.Compra IN FRAME W-Detalle.
        RETURN NO-APPLY.
    END.
    IF INPUT FRAME W-Detalle integral.gn-tcmb.venta = 0
    THEN DO:
        BELL.
        MESSAGE "Debe Ingresar Tipo de Cambio" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO integral.gn-tcmb.venta IN FRAME W-Detalle.
        RETURN NO-APPLY.
    END.
                            
    ASSIGN  integral.gn-tcmb.Fecha
            integral.gn-tcmb.Compra
            integral.gn-tcmb.venta.
            
    ASSIGN integral.gn-tcmb.Fecha:visible = NO
           integral.gn-tcmb.Compra:visible = NO
           integral.gn-tcmb.venta:visible = NO
           B-Acepta:visible = NO
           B-Cancela:visible = NO
           B-Add:visible = YES
           B-Mod:visible = YES
           B-Del:visible = YES
           B-Salir:visible = YES.
    DISABLE integral.gn-tcmb.Fecha
            integral.gn-tcmb.Compra
            integral.gn-tcmb.venta
            B-Acepta B-Cancela            
       WITH FRAME W-Detalle.

    {&OPEN-QUERY-BRW-Detalle}
    BRW-Detalle:visible = YES.
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
    CREATE integral.gn-tcmb.
    CREAR     = yes.
    RECID-ACT = RECID( integral.gn-tcmb ).
 /*   ASSIGN cp-tpro.CodCia = cb-codcia. */
    DISPLAY integral.gn-tcmb.Fecha
            integral.gn-tcmb.Compra
            integral.gn-tcmb.venta
        WITH FRAME W-Detalle.    
    ENABLE integral.gn-tcmb.Fecha
           integral.gn-tcmb.Compra
           integral.gn-tcmb.venta
           B-Acepta B-Cancela
           WITH FRAME W-Detalle.
    APPLY "ENTRY" TO integral.gn-tcmb.Fecha.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Cancela W-Detalle
ON CHOOSE OF B-Cancela IN FRAME W-Detalle /* Cancela */
DO:
    IF CREAR THEN DELETE integral.gn-tcmb.
        
    ASSIGN integral.gn-tcmb.Fecha:visible = NO
           integral.gn-tcmb.Compra:visible = NO
           integral.gn-tcmb.venta:visible = NO
           B-Acepta:visible = NO
           B-Cancela:visible = NO
           B-Add:visible = YES
           B-Mod:visible = YES
           B-Del:visible = YES
           B-Salir:visible = YES.
    DISABLE integral.gn-tcmb.Fecha
            integral.gn-tcmb.Compra
            integral.gn-tcmb.venta
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
    RECID-ACT = RECID( {&FIRST-TABLE-IN-QUERY-BRW-Detalle} ).
    FIND {&FIRST-TABLE-IN-QUERY-BRW-Detalle} WHERE
        RECID-ACT = RECID( {&FIRST-TABLE-IN-QUERY-BRW-Detalle} )
        EXCLUSIVE NO-ERROR.
    IF NOT AVAILABLE {&FIRST-TABLE-IN-QUERY-BRW-Detalle}
    THEN DO:
        CLEAR FRAME F-maestro.
        MESSAGE  "No exiten Registros." VIEW-AS ALERT-BOX ERROR
        BUTTONS OK.
        RETURN.
    END.
    MESSAGE "Eliminar el Registro del " + STRING( integral.gn-tcmb.Fecha )
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE selection AS LOGICAL.
    IF selection THEN DO:
        DELETE {&FIRST-TABLE-IN-QUERY-BRW-Detalle}.
        {&OPEN-QUERY-BRW-Detalle}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-mod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-mod W-Detalle
ON CHOOSE OF b-mod IN FRAME W-Detalle /* Modificar */
DO:
    CREAR     = NO.
    RECID-ACT = RECID( {&FIRST-TABLE-IN-QUERY-BRW-Detalle} ).
    FIND {&FIRST-TABLE-IN-QUERY-BRW-Detalle} WHERE
        RECID-ACT = RECID( {&FIRST-TABLE-IN-QUERY-BRW-Detalle} )
        EXCLUSIVE NO-ERROR.
    IF NOT AVAILABLE {&FIRST-TABLE-IN-QUERY-BRW-Detalle}
    THEN RETURN NO-APPLY.
    ASSIGN BRW-Detalle:visible = NO 
           B-Add:visible = NO
           B-Mod:visible = NO
           B-Del:visible = NO
           B-Salir:visible = NO
           B-Acepta:visible = YES
           B-Cancela:visible = YES.
   
    DISPLAY integral.gn-tcmb.Fecha
            integral.gn-tcmb.Compra
            integral.gn-tcmb.venta
        WITH FRAME W-Detalle.  
    ENABLE /* integral.gn-tcmb.Fecha */
           integral.gn-tcmb.Compra
           integral.gn-tcmb.venta
           B-Acepta B-Cancela
         WITH FRAME W-Detalle.
   APPLY "ENTRY" TO integral.gn-tcmb.Compra.
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


&Scoped-define SELF-NAME integral.gn-tcmb.Fecha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.gn-tcmb.Fecha W-Detalle
ON LEAVE OF integral.gn-tcmb.Fecha IN FRAME W-Detalle /* Fecha de Cambio */
DO:
    IF CAN-FIND ( integral.gn-tcmb WHERE 
                    integral.gn-tcmb.Fecha = 
                        INPUT FRAME W-Detalle integral.gn-tcmb.Fecha )  THEN 
        DO:       
           BELL.
           MESSAGE "Fecha de Cambio " + STRING (INPUT FRAME W-Detalle integral.gn-tcmb.Fecha) 
                 + "  ya Ingresada " VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO integral.gn-tcmb.Fecha IN FRAME W-Detalle.
           RETURN NO-APPLY.
        END.

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

ON "ENDKEY", END-ERROR OF FRAME {&FRAME-NAME}
DO:
    IF B-cancela:VISIBLE THEN APPLY "CHOOSE":U TO B-cancela.
    IF B-salir:VISIBLE   THEN APPLY "CHOOSE":U TO B-salir.
    RETURN NO-APPLY.
END.

ON "GO" OF FRAME {&FRAME-NAME}
DO: 
    IF B-cancela:VISIBLE THEN APPLY "CHOOSE":U TO B-acepta.
    IF B-salir:VISIBLE   THEN APPLY "CHOOSE":U TO B-salir.
    RETURN NO-APPLY.
END.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "CLOSE":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */


MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  WAIT-FOR CLOSE OF FRAME {&FRAME-NAME}.
/*  WAIT-FOR GO OF FRAME {&FRAME-NAME}.*/
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
  ENABLE RECT-3 brw-Detalle RECT-2 B-del b-salir b-add b-mod 
      WITH FRAME W-Detalle.
  {&OPEN-BROWSERS-IN-QUERY-W-Detalle}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE BROWSE-NAME
&UNDEFINE FRAME-NAME
&UNDEFINE WINDOW-NAME
