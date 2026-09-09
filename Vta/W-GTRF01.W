&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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
DEFINE     SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE     SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE     SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE     SHARED VARIABLE S-USER-ID  AS CHAR.

/* Local Variable Definitions ---                                       */
DEF VAR wtotsol AS DEC NO-UNDO.
DEF VAR wtotdol AS DEC NO-UNDO.
DEF VAR wtotcts AS DEC NO-UNDO.
DEF VAR wtotctd AS DEC NO-UNDO.
DEF VAR wtotcrs AS DEC NO-UNDO.
DEF VAR wtotcrd AS DEC NO-UNDO.
DEF VAR wtipcam AS DEC NO-UNDO.

DEF VAR wfactor AS DECIMAL NO-UNDO.
DEF VAR I       AS INT NO-UNDO.

DEF VAR w-perio AS INT NO-UNDO.
DEF VAR w-mes   AS INT NO-UNDO.
DEF VAR w-dia   AS INT NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
wtipcam = FacCfgGn.Tpocmb[1] .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 COMBO-BOX-1 f-periodo F-MesAct ~
BUTTON-12 BUTTON-13 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-2 FILL-IN-1 COMBO-BOX-1 f-periodo ~
F-MesAct 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-12 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Cerrar" 
     SIZE 12.43 BY 1.54.

DEFINE BUTTON BUTTON-13 AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 12.43 BY 1.54.

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "A¤o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "A¤o","Mes" 
     SIZE 80 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR-2 AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 33.14 BY 2.04
     BGCOLOR 11 FONT 6 NO-UNDO.

DEFINE VARIABLE F-MesAct AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 4.14 BY .81 NO-UNDO.

DEFINE VARIABLE f-periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 7.29 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48.14 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 52.72 BY 5.35.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     EDITOR-2 AT ROW 1.46 COL 3.29 NO-LABEL
     FILL-IN-1 AT ROW 5.12 COL 3.43 NO-LABEL
     COMBO-BOX-1 AT ROW 16.92 COL 1 NO-LABEL
     f-periodo AT ROW 3.92 COL 9 COLON-ALIGNED
     F-MesAct AT ROW 3.88 COL 23.43 COLON-ALIGNED
     BUTTON-12 AT ROW 1.5 COL 39.43
     BUTTON-13 AT ROW 3.15 COL 39.43
     RECT-1 AT ROW 1.08 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Actualizacion del Consolidado de VENTAS"
         HEIGHT             = 5.88
         WIDTH              = 53.43
         MAX-HEIGHT         = 21.27
         MAX-WIDTH          = 109.57
         VIRTUAL-HEIGHT     = 21.27
         VIRTUAL-WIDTH      = 109.57
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT W-Win:LOAD-ICON("img\caja3":U) THEN
    MESSAGE "Unable to load icon: img\caja3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   Default                                                              */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-1 IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR EDITOR EDITOR-2 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       EDITOR-2:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Actualizacion del Consolidado de VENTAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Actualizacion del Consolidado de VENTAS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 W-Win
ON CHOOSE OF BUTTON-12 IN FRAME F-Main /* Cerrar */
DO:
  ASSIGN
        f-periodo
        f-mesAct.
        
  MESSAGE " Esta seguro de Actualizar Informaci¢n a GERENCIA " VIEW-AS ALERT-BOX QUESTION 
  BUTTONS yes-no
  UPDATE wresp AS LOGICAL.
  CASE wresp:
       WHEN yes THEN DO:
            IF f-periodo = 0 then DO:
               MESSAGE " Ingrese el Periodo a Condolidar " VIEW-AS ALERT-BOX ERROR.
               APPLY "ENTRY" TO f-periodo.
               return NO-APPLY.  
            END.   
            IF f-mesAct  = 0 then DO:
               MESSAGE " Ingrese el Mes a Consolidar " VIEW-AS ALERT-BOX ERROR.
               APPLY "ENTRY" TO f-mesAct.
               return NO-APPLY.  
            END.   
            if session:set-wait-state("GENERAL") then.
            RUN consolida-vtas.
            RUN consol-und-vta.
            RUN consolida-arti.
/*          RUN consolida-vend.
            RUN consolida-clie.  */
            if session:set-wait-state(" ") then.
            MESSAGE " Proceso Terminado " VIEW-AS ALERT-BOX INFORMATION. 
         END.  
       WHEN no  THEN 
            RETURN.
  END CASE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 W-Win
ON ENTRY OF BUTTON-12 IN FRAME F-Main /* Cerrar */
DO:
   IF BUTTON-12:LOAD-MOUSE-POINTER("GLOVE") THEN . 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 W-Win
ON CHOOSE OF BUTTON-13 IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 W-Win
ON ENTRY OF BUTTON-13 IN FRAME F-Main /* Cancelar */
DO:
  IF BUTTON-13:LOAD-MOUSE-POINTER("GLOVE") THEN . 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consol-und-vta W-Win 
PROCEDURE consol-und-vta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR T        AS INTEGER INITIAL 1.
DEFINE VAR A        AS INTEGER INITIAL 1.
DEFINE VAR T-TMPSTK AS DECIMAL INITIAL 0.
DEFINE VAR T-STKVTA AS DECIMAL INITIAL 0.
DEFINE VAR T-VENTAD AS DECIMAL INITIAL 0.
DEFINE VAR T-TMPDOL AS DECIMAL INITIAL 0.

/********** Actualiza Consolidado de Articulos - Unidades Vendidas  ************/

FOR EACH TMSVART0 NO-LOCK WHERE TMSVART0.CODCIA   = S-CODCIA  AND
                                TMSVART0.PERIODO  = F-PERIODO 
                                BREAK BY TMSVART0.CODART
                                      BY TMSVART0.CODDIV :
                                
    FILL-IN-1 = "Articulo : " + TMSVART0.CODART + " " + TMSVART0.CODDIV + " " + TMSVART0.DESART.
    DISPLAY FILL-IN-1 WITH FRAME {&FRAME-NAME}. 

    T-STKVTA = T-STKVTA + TMSVART0.CANMES[F-MESACT].
    T-VENTAD = T-VENTAD + TmsVart0.ImpMes[F-MESACT].
    
    IF LAST-OF(TMSVART0.CODART) THEN DO:

       /********** Actualiza Acumulado Ventas - Articulos x Periodo **********/
       FIND FIRST THGERENC.TGECART0 WHERE THGERENC.TGECART0.CODCIA  = S-CODCIA  AND
                                          THGERENC.TGECART0.PERIODO = F-PERIODO AND
                                          THGERENC.TGECART0.CODDIV  = "TH000"   AND 
                                          THGERENC.TGECART0.CODART  = TMSVART0.CODART NO-ERROR.
            IF AVAILABLE THGERENC.TGECART0 THEN DO:
               ASSIGN
                  THGERENC.TGECART0.CodFam = TMSVART0.CodFam    
                  THGERENC.TGECART0.SubFam = TMSVART0.CodSub
                  THGERENC.TGECART0.CodPro = TMSVART0.CodPro
                  THGERENC.TGECART0.DesMar = TMSVART0.DesMar
                  THGERENC.TGECART0.Unidad = TMSVART0.Unidad
                  THGERENC.TGECART0.DESART = TMSVART0.DESART
                  THGERENC.TGECART0.VTATOMES[F-MESACT] = T-VENTAD.
            END.
            ELSE DO:
               CREATE THGERENC.TGECART0.
               ASSIGN
                 THGERENC.TGECART0.CODCIA   = S-CODCIA
                 THGERENC.TGECART0.PERIODO  = F-PERIODO
                 THGERENC.TGECART0.CODDIV   = "TH000"
                 THGERENC.TGECART0.CODART   = TMSVART0.CODART
                 THGERENC.TGECART0.DESART   = TMSVART0.DESART
                 THGERENC.TGECART0.CodFam   = TMSVART0.CodFam    
                 THGERENC.TGECART0.SubFam   = TMSVART0.CodSub
                 THGERENC.TGECART0.CodPro   = TMSVART0.CodPro
                 THGERENC.TGECART0.DesMar   = TMSVART0.DesMar
                 THGERENC.TGECART0.Unidad   = TMSVART0.Unidad
                 THGERENC.TGECART0.VTATOMES[F-MESACT] = T-VENTAD.
            END.
            DO T = 1 TO 12 :
               T-TMPDOL = T-TMPDOL + THGERENC.TGECART0.VTATOMES[T].
            END.
            T = 1.
            ASSIGN 
                THGERENC.TGECART0.VTATODOL = T-TMPDOL.    

            T-VENTAD = 0.
            T-TMPDOL = 0.
            
       /************** Actualiza Unidades Vendidas **************/
       FIND FIRST THGERENC.TVTCART0 WHERE THGERENC.TVTCART0.ARTCODIG = TMSVART0.CODART NO-ERROR.
            IF AVAILABLE THGERENC.TVTCART0 THEN DO:
               ASSIGN
                  THGERENC.TVTCART0.ARTNOMBR = TMSVART0.DESART
                  THGERENC.TVTCART0.ARTV1999[F-MESACT] = T-STKVTA.
            END.
            ELSE DO:
               CREATE THGERENC.TVTCART0.
               ASSIGN
                 THGERENC.TVTCART0.ARTCODIG = TMSVART0.CODART
                 THGERENC.TVTCART0.ARTNOMBR = TMSVART0.DESART
                 THGERENC.TVTCART0.ARTUNIDA = TMSVART0.UNIDAD
                 THGERENC.TVTCART0.ARTMARCA = TMSVART0.DESMAR
                 THGERENC.TVTCART0.ARTFAMIL = TMSVART0.CODFAM
                 THGERENC.TVTCART0.ARTSUBFA = TMSVART0.CODSUB
                 THGERENC.TVTCART0.ARTV1999[F-MESACT] = T-STKVTA.
            END.
       T-STKVTA = 0.         

    END. 

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consolida-arti W-Win 
PROCEDURE consolida-arti :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR A        AS INTEGER INITIAL 1.
DEFINE VAR T-TMPTPR AS DECIMAL INITIAL 0.

/********** Actualiza Consolidado Articulos Ventas Por DIVISION ************/

FOR EACH TMSVART0 NO-LOCK WHERE TMSVART0.CODCIA   = S-CODCIA  AND
                                TMSVART0.PERIODO  = F-PERIODO 
                                BREAK BY TMSVART0.CODDIV
                                      BY TMSVART0.CODART :
                                
    FILL-IN-1 = "Articulo : " + TMSVART0.CODART + " " + TMSVART0.CODDIV + " " + TMSVART0.DESART.
    DISPLAY FILL-IN-1 WITH FRAME {&FRAME-NAME}. 
    IF LAST-OF(TMSVART0.CODART) THEN DO:
       FIND FIRST THGERENC.TGECART0 WHERE THGERENC.TGECART0.CODCIA  = S-CODCIA  AND
                                          THGERENC.TGECART0.PERIODO = F-PERIODO AND
                                          THGERENC.TGECART0.CODDIV  = TMSVART0.CODDIV AND 
                                          THGERENC.TGECART0.CODART  = TMSVART0.CODART NO-ERROR.
            IF AVAILABLE THGERENC.TGECART0 THEN DO:
               ASSIGN
                  THGERENC.TGECART0.CodFam = TMSVART0.CodFam
                  THGERENC.TGECART0.SubFam = TMSVART0.CodSub
                  THGERENC.TGECART0.CodPro = TMSVART0.CodPro
                  THGERENC.TGECART0.DesMar = TMSVART0.DesMar
                  THGERENC.TGECART0.Unidad = TMSVART0.Unidad
                  THGERENC.TGECART0.DESART = TMSVART0.DESART
                  THGERENC.TGECART0.VTATOMES[F-MESACT] = TMSVART0.IMPMES[F-MESACT].
            END.
            ELSE DO:
               CREATE THGERENC.TGECART0.
               ASSIGN
                 THGERENC.TGECART0.CODCIA   = S-CODCIA
                 THGERENC.TGECART0.PERIODO  = F-PERIODO
                 THGERENC.TGECART0.CODDIV   = TMSVART0.CODDIV
                 THGERENC.TGECART0.CODART   = TMSVART0.CODART
                 THGERENC.TGECART0.DESART   = TMSVART0.DESART
                 THGERENC.TGECART0.CodFam   = TMSVART0.CodFam    
                 THGERENC.TGECART0.SubFam   = TMSVART0.CodSub
                 THGERENC.TGECART0.CodPro   = TMSVART0.CodPro
                 THGERENC.TGECART0.DesMar   = TMSVART0.DesMar
                 THGERENC.TGECART0.Unidad   = TMSVART0.Unidad
                 THGERENC.TGECART0.VTATOMES[F-MESACT] = TMSVART0.IMPMES[F-MESACT].
            END.
            DO A = 1 TO 12 :
                 T-TMPTPR = T-TMPTPR + THGERENC.TGECART0.VTATOMES[A].
            END.
            A = 1.
            ASSIGN 
                THGERENC.TGECART0.VTATODOL = T-TMPTPR.    
                REPEAT WHILE A <= 12 :   
                      ASSIGN THGERENC.TGECART0.VTAFAMTO[A] = ( THGERENC.TGECART0.VTATOMES[A] / T-TMPTPR ) * 100.    
                      A = A + 1.
                END.
       T-TMPTPR = 0.         
    END. 

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consolida-clie W-Win 
PROCEDURE consolida-clie :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR L        AS INTEGER INITIAL 1.
DEFINE VAR T-TMPTCL AS DECIMAL INITIAL 0.

/********** Actualiza Consolidado x Clientes ************/

FOR EACH TMSVVAR0 NO-LOCK WHERE TMSVVAR0.CODCIA   = S-CODCIA  AND
                                TMSVVAR0.TIPTABLA = "CLI"     AND 
                                TMSVVAR0.PERIODO  = F-PERIODO 
                                BREAK BY TMSVVAR0.CODDIV
                                      BY TMSVVAR0.CODVAR :
                                
    FILL-IN-1 = "Cliente : " + TMSVVAR0.CODVAR + " " + TMSVVAR0.CODDIV + " " + TMSVVAR0.NOMBRE.
    DISPLAY FILL-IN-1 WITH FRAME {&FRAME-NAME}. 
    IF LAST-OF(TMSVVAR0.CODVAR) THEN DO:
       FIND FIRST THGERENC.TGECVTC0 WHERE THGERENC.TGECVTC0.VTAPERIO = F-PERIODO AND
                                          THGERENC.TGECVTC0.VTAPUNTO = TMSVVAR0.CODDIV AND 
                                          THGERENC.TGECVTC0.VTACLIEN = TMSVVAR0.CODVAR NO-ERROR.
            IF AVAILABLE THGERENC.TGECVTC0 THEN DO:
               ASSIGN
                  THGERENC.TGECVTC0.VTANOMBR = TMSVVAR0.NOMBRE
                  THGERENC.TGECVTC0.VTATOMES[F-MESACT] = TMSVVAR0.TOTMES[F-MESACT].
            END.
            ELSE DO:
               CREATE THGERENC.TGECVTC0.
               ASSIGN
                 THGERENC.TGECVTC0.VTAPERIO = F-PERIODO
                 THGERENC.TGECVTC0.VTAPUNTO = TMSVVAR0.CODDIV
                 THGERENC.TGECVTC0.VTACLIEN = TMSVVAR0.CODVAR
                 THGERENC.TGECVTC0.VTANOMBR = TMSVVAR0.NOMBRE
                 THGERENC.TGECVTC0.VTATOMES[F-MESACT] = TMSVVAR0.TOTMES[F-MESACT].
            END.
            DO L = 1 TO 12 :
                 T-TMPTCL = T-TMPTCL + THGERENC.TGECVTC0.VTATOMES[L].
            END.
            L = 1.
            ASSIGN 
                THGERENC.TGECVTC0.VTATODOL = T-TMPTCL.    
                REPEAT WHILE L <= 12 :   
                      ASSIGN THGERENC.TGECVTC0.VTAFAMTO[L] = ( THGERENC.TGECVTC0.VTATOMES[L] / T-TMPTCL ) * 100.    
                      L = L + 1.
                END.
       T-TMPTCL = 0.         
    END. 

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consolida-vend W-Win 
PROCEDURE consolida-vend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR V        AS INTEGER INITIAL 1.
DEFINE VAR T-TMPTVE AS DECIMAL INITIAL 0.

/********** Actualiza Consolidado x Vendedor ************/

FOR EACH TMSVVAR0 NO-LOCK WHERE TMSVVAR0.CODCIA   = S-CODCIA  AND
                                TMSVVAR0.TIPTABLA = "VEN"     AND 
                                TMSVVAR0.PERIODO  = F-PERIODO 
                                BREAK BY TMSVVAR0.CODDIV
                                      BY TMSVVAR0.CODVAR :
                                
    FILL-IN-1 = "Vendedor : " + TMSVVAR0.CODVAR + " " + TMSVVAR0.CODDIV + " " + TMSVVAR0.NOMBRE.
    DISPLAY FILL-IN-1 WITH FRAME {&FRAME-NAME}. 
    IF LAST-OF(TMSVVAR0.CODVAR) THEN DO:
       FIND FIRST THGERENC.TGECVTV0 WHERE THGERENC.TGECVTV0.VTAPERIO = F-PERIODO AND
                                          THGERENC.TGECVTV0.VTAPUNTO = TMSVVAR0.CODDIV AND 
                                          THGERENC.TGECVTV0.VTAVENDE = TMSVVAR0.CODVAR NO-ERROR.
            IF AVAILABLE THGERENC.TGECVTV0 THEN DO:
               ASSIGN
                  THGERENC.TGECVTV0.VTANOMBR = TMSVVAR0.NOMBRE
                  THGERENC.TGECVTV0.VTATOMES[F-MESACT] = TMSVVAR0.TOTMES[F-MESACT].
            END.
            ELSE DO:
               CREATE THGERENC.TGECVTV0.
               ASSIGN
                 THGERENC.TGECVTV0.VTAPERIO = F-PERIODO
                 THGERENC.TGECVTV0.VTAPUNTO = TMSVVAR0.CODDIV
                 THGERENC.TGECVTV0.VTAVENDE = TMSVVAR0.CODVAR
                 THGERENC.TGECVTV0.VTANOMBR = TMSVVAR0.NOMBRE
                 THGERENC.TGECVTV0.VTATOMES[F-MESACT] = TMSVVAR0.TOTMES[F-MESACT].
            END.
            DO V = 1 TO 12 :
                 T-TMPTVE = T-TMPTVE + THGERENC.TGECVTV0.VTATOMES[V].
            END.
            V = 1.
            ASSIGN 
                THGERENC.TGECVTV0.VTATODOL = T-TMPTVE.    
                REPEAT WHILE V <= 12 :   
                      ASSIGN THGERENC.TGECVTV0.VTAFAMTO[V] = ( THGERENC.TGECVTV0.VTATOMES[V] / T-TMPTVE ) * 100.    
                      V = V + 1.
                END.
       T-TMPTVE = 0.         
    END. 

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consolida-vtas W-Win 
PROCEDURE consolida-vtas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR T-TOTMES AS DECIMAL INITIAL 0.
DEFINE VAR T-TOTDIV AS DECIMAL INITIAL 0.
DEFINE VAR T-TMPTDV AS DECIMAL INITIAL 0.
DEFINE VAR T-TMPTVT AS DECIMAL INITIAL 0.
DEFINE VAR C        AS INTEGER INITIAL 1.

/********** Actualiza Consolidado x Division ************/

FOR EACH TMSVDIV0 NO-LOCK WHERE TmsvDiv0.DivCia   = S-CODCIA AND
                                TmsvDiv0.DivPerio = F-PERIODO AND 
                                TmsvDiv0.DivMes   = F-MESACT
                                BREAK BY TmsvDiv0.DivCod :
                     
    T-TOTMES = T-TOTMES + TmsvDiv0.DivVtdol.
    T-TOTDIV = T-TOTDIV + TmsvDiv0.DivVtdol.
    
    FILL-IN-1 = "Division :" + TmsvDiv0.DivCod.
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
    
    IF LAST-OF(integral.TmsvDiv0.DivCod) THEN DO:
       FIND FIRST THGERENC.TGECVTP0 WHERE THGERENC.TGECVTP0.VTAPERIO = F-PERIODO AND
                                          THGERENC.TGECVTP0.VTAPUNTO = TMSVDIV0.DIVCOD NO-ERROR.
            IF AVAILABLE THGERENC.TGECVTP0 THEN DO:
               ASSIGN
                  THGERENC.TGECVTP0.VTATOMES[F-MESACT] = T-TOTDIV.
            END.
            ELSE DO:
               CREATE THGERENC.TGECVTP0.
               ASSIGN
                 THGERENC.TGECVTP0.VTAPERIO = F-PERIODO
                 THGERENC.TGECVTP0.VTAPUNTO = TMSVDIV0.DIVCOD
                 THGERENC.TGECVTP0.VTATOMES[F-MESACT] = T-TOTDIV.
            END.
            DO C = 1 TO 12 :
                   T-TMPTDV = T-TMPTDV + THGERENC.TGECVTP0.VTATOMES[C].
            END.
            C = 1.
            ASSIGN 
                THGERENC.TGECVTP0.VTATODOL = T-TMPTDV.    
                REPEAT WHILE C <= 12 :   
                      ASSIGN THGERENC.TGECVTP0.VTAFAMES[C] = ( THGERENC.TGECVTP0.VTATOMES[C] / T-TMPTDV ) * 100.    
                      C = C + 1.
                END.      
 
      
       /******** Actualizando CONSOLIDADO Ventas por PERIODO Y MES ********/
     
       FIND FIRST THGERENC.TGECVTM0 WHERE THGERENC.TGECVTM0.VTAPERIO = F-PERIODO AND
                                          THGERENC.TGECVTM0.VTAPUNTO = TMSVDIV0.DIVCOD AND
                                          THGERENC.TGECVTM0.VTANUMES = F-MESACT NO-ERROR.
            IF AVAILABLE THGERENC.TGECVTM0 THEN 
               ASSIGN THGERENC.TGECVTM0.VTATODOL = T-TOTDIV.
            ELSE DO:
               CREATE THGERENC.TGECVTM0.
               ASSIGN 
                  THGERENC.TGECVTM0.VTAPERIO = F-PERIODO
                  THGERENC.TGECVTM0.VTAPUNTO = TMSVDIV0.DIVCOD
                  THGERENC.TGECVTM0.VTANUMES = F-MESACT
                  THGERENC.TGECVTM0.VTATODOL = T-TOTDIV.
            END.       

       T-TOTDIV = 0.
       T-TMPTDV = 0.
     
           
    END. 

END.


C = 1.
/*********** Actualiza CONSOLIDADO de VENTAS *************/

FIND FIRST THGERENC.TGECVTA0 WHERE THGERENC.TGECVTA0.VTAPERIO = F-PERIODO NO-ERROR.
     IF AVAILABLE THGERENC.TGECVTA0 THEN DO:
        ASSIGN 
           THGERENC.TGECVTA0.VTATOMES[F-MESACT] = T-TOTMES.
     END.   
     ELSE DO:
        CREATE THGERENC.TGECVTA0.
        ASSIGN 
           THGERENC.TGECVTA0.VTAPERIO = F-PERIODO
           THGERENC.TGECVTA0.VTATOMES[F-MESACT] = T-TOTMES.

     END.
     DO C = 1 TO 12 :
        T-TMPTVT = T-TMPTVT + THGERENC.TGECVTA0.VTATOMES[C].
     END.   
     C = 1.
     ASSIGN    
         THGERENC.TGECVTA0.VTATODOL = T-TMPTVT.
         REPEAT WHILE C <= 12 :
                ASSIGN THGERENC.TGECVTA0.VTAFAMES[F-MESACT] = ( THGERENC.TGECVTA0.VTATOMES[C] / T-TMPTVT ) * 100.
                C = C + 1.
         END.       
     T-TMPTVT = 0.
     RELEASE THGERENC.TGECVTA0.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  DISPLAY EDITOR-2 FILL-IN-1 COMBO-BOX-1 f-periodo F-MesAct 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 COMBO-BOX-1 f-periodo F-MesAct BUTTON-12 BUTTON-13 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  editor-2 = "Proceso que Actualiza el Consolidado de Ventas Dolarizado, 
  en el Modulo de GERENCIA".
  DISPLAY EDITOR-2 WITH FRAME {&FRAME-NAME}.
  ASSIGN
        f-periodo = year(today)
        f-mesAct  = month(today).
        
  DISPLAY f-periodo
          f-mesAct  WITH FRAME {&FRAME-NAME}.                  
  /* Code placed here will execute AFTER standard behavior.    */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
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


