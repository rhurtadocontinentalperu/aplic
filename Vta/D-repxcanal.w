&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*------------------------------------------------------------------------

  File: 

  Description: from d-repxcanal.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: Programa creado por Maria Avendaño
          
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

DEF VAR cNomCanal AS CHARACTER NO-UNDO.
Def var s-codcia    as inte init 1.
Def var x-signo1    as inte init 1.
DEF VAR i AS INT.
Def var f-factor    as deci init 0.
Def var x-TpoCmbCmp as deci init 1.
Def var x-TpoCmbVta as deci init 1.
Def var x-coe       as deci init 0.

DEF VAR cl-codcia AS INT NO-UNDO.

FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.

Def BUFFER B-CDOCU FOR CcbCdocu.

DEFINE TEMP-TABLE tmp-tempo 
    FIELDS t-canal   LIKE Gn-Clie.canal      FORMAT "x(6)"
    FIELDS t-descan  LIKE Almtabla.Nombre    FORMAT "x(25)"
    FIELDS t-codven  LIKE CcbCDocu.CodVen    FORMAT "x(3)"   
    FIELDS t-nomven  LIKE gn-ven.NomVen      FORMAT "x(40)"
    FIELDS t-codcli  LIKE CcbCDocu.CodCli    FORMAT "x(11)"   
    FIELDS t-nomcli  LIKE Gn-Clie.NomCli     FORMAT "x(40)"
    FIELDS t-codfam  LIKE Almmmatg.codfam    FORMAT "x(3)"
    FIELDS t-desfam  LIKE Almtfami.desfam    FORMAT "x(16)"
    FIELDS t-imptot AS DEC   EXTENT 12       FORMAT "->>>>>>>9.99"
    INDEX LLave01 t-Canal t-CodVen t-CodCli t-CodFam. 
   
DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     FI-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH OVERLAY CENTERED KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-61 RECT-62 F-periodo BUTTON-4 BUTTON-5 ~
BUTTON-6 BUTTON-7 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-periodo F-DIVISION F-Canal F-CodFam ~
F-Vendedor x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-4 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE BUTTON BUTTON-5 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE BUTTON BUTTON-6 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE BUTTON BUTTON-7 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE VARIABLE F-Canal AS CHARACTER FORMAT "X(256)":U 
     LABEL "Canal" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE F-DIVISION AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE F-periodo AS INTEGER FORMAT "9999":U INITIAL 2008 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE F-Vendedor AS CHARACTER FORMAT "X(256)":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 62 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 64 BY 7.23
     BGCOLOR 3 .

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 64 BY 2.15.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-periodo AT ROW 2.15 COL 10 COLON-ALIGNED
     F-DIVISION AT ROW 3.12 COL 10 COLON-ALIGNED
     BUTTON-4 AT ROW 3.12 COL 56
     F-Canal AT ROW 4.08 COL 10 COLON-ALIGNED
     BUTTON-5 AT ROW 4.08 COL 56
     F-CodFam AT ROW 5.04 COL 10 COLON-ALIGNED
     BUTTON-6 AT ROW 5.04 COL 56
     F-Vendedor AT ROW 6 COL 10 COLON-ALIGNED
     BUTTON-7 AT ROW 6 COL 56
     x-mensaje AT ROW 7.46 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     Btn_OK AT ROW 9.08 COL 44
     Btn_Cancel AT ROW 9.08 COL 55
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1.38 COL 4
          FONT 6
     RECT-61 AT ROW 1.58 COL 3
     RECT-62 AT ROW 8.81 COL 3 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 68.72 BY 10.54
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
         TITLE              = "Ventas - Division - Canal - Linea - Vendedor"
         HEIGHT             = 10.54
         WIDTH              = 68.72
         MAX-HEIGHT         = 10.54
         MAX-WIDTH          = 68.72
         VIRTUAL-HEIGHT     = 10.54
         VIRTUAL-WIDTH      = 68.72
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT W-Win:LOAD-ICON("img\climnu3":U) THEN
    MESSAGE "Unable to load icon: img\climnu3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN F-Canal IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-CodFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DIVISION IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Vendedor IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Ventas - Division - Canal - Linea - Vendedor */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Ventas - Division - Canal - Linea - Vendedor */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  RUN Asigna-Variables. 
  RUN Valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR". 
  RUN Imprime.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* ... */
DO:
  DEF VAR x-Divisiones AS CHAR.
  x-Divisiones = f-Division:SCREEN-VALUE.
  RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
  f-Division:SCREEN-VALUE = x-Divisiones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* ... */
DO:
  DEF VAR x-Canales AS CHAR.
  x-Canales = f-Canal:SCREEN-VALUE.
  RUN vta/d-canal.w (INPUT-OUTPUT x-Canales).
  f-Canal:SCREEN-VALUE = x-Canales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* ... */
DO:
  DEF VAR x-Lineas AS CHAR.
  x-Lineas = f-CodFam:SCREEN-VALUE.
  RUN vta/d-familia (INPUT-OUTPUT x-Lineas).
  f-CodFam:SCREEN-VALUE = x-Lineas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* ... */
DO:
  DEF VAR x-Vendedores AS CHAR.
  x-Vendedores = f-Vendedor:SCREEN-VALUE.
  RUN vta/d-vendedor (INPUT-OUTPUT x-Vendedores).
  f-Vendedor:SCREEN-VALUE = x-Vendedores.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Canal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Canal W-Win
ON LEAVE OF F-Canal IN FRAME F-Main /* Canal */
DO:
   ASSIGN F-Canal.
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   IF F-Canal = "" THEN DO:
      SELF:SCREEN-VALUE = "".
      RETURN.
   END.
   FIND AlmTabla WHERE AlmTabla.Tabla = 'CN' 
                 AND  AlmTabla.Codigo = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE AlmTabla THEN DO:
      MESSAGE "Codigo de Canal no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodFam W-Win
ON LEAVE OF F-CodFam IN FRAME F-Main /* Linea */
DO:
   ASSIGN F-CodFam.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DIVISION
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION W-Win
ON LEAVE OF F-DIVISION IN FRAME F-Main /* Division */
DO:
  ASSIGN F-Division.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Vendedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Vendedor W-Win
ON LEAVE OF F-Vendedor IN FRAME F-Main /* Vendedor */
DO:
  ASSIGN F-Vendedor.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

/* Include custom  Main Block code for SmartWindows. */

{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables W-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN 
         F-Periodo
         F-Division 
         F-Canal 
         F-CodFam 
         F-vendedor.
END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BAckup W-Win 
PROCEDURE BAckup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
DEFINE VAR X-ENTRA AS LOGICAL INIT FALSE.

/*******Inicializa la Tabla Temporal ******/
FOR EACH tmp-tempo :
  DELETE tmp-tempo.
END.
/********************************/


FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = S-CODCIA
                           AND  Almmmatg.codfam BEGINS F-CodFam
                           AND  Almmmatg.subfam BEGINS F-Subfam
                           AND  (Almmmatg.codmat >= DesdeC
                           AND   Almmmatg.CodMat <= HastaC)
                           AND  Almmmatg.CodPr1 BEGINS F-prov1
                           AND  Almmmatg.Codmar BEGINS F-Marca
                          USE-INDEX matg09,
    EACH Evtarti NO-LOCK WHERE Evtarti.CodCia = S-CODCIA
                         AND   Evtarti.CodDiv BEGINS F-DIVISION
                         AND   Evtarti.Codmat = Almmmatg.codmat
                         /* AND   (Evtarti.CodAno >= YEAR(DesdeF) 
                         AND   Evtarti.Codano <= YEAR(HastaF))
                         AND   Evtarti.CodMes >= MONTH(DesdeF) */
                         BREAK BY Almmmatg.codcia
                               BY Almmmatg.codmat :
                         

      DISPLAY Evtarti.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      
      T-Vtamn   = 0.
      T-Vtame   = 0.
      T-Ctomn   = 0.
      T-Ctome   = 0.
      F-Salida  = 0.


      /*********************** Calculo Para Obtener los datos diarios ************/
      IF YEAR(DesdeF) = YEAR(HastaF) AND MONTH(DesdeF) = MONTH(HastaF) THEN DO:
        DO I = DAY(DesdeF)  TO DAY(HastaF) :
          FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")) NO-LOCK NO-ERROR.
          IF AVAILABLE Gn-tcmb THEN DO: 
            F-Salida  = F-Salida  + Evtarti.CanxDia[I].
            T-Vtamn   = T-Vtamn   + Evtarti.Vtaxdiamn[I] + Evtarti.Vtaxdiame[I] * Gn-Tcmb.Venta.
            T-Vtame   = T-Vtame   + Evtarti.Vtaxdiame[I] + Evtarti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
          END.
        END.
      END.
      ELSE DO:
        X-ENTRA = FALSE.
        IF Evtarti.Codano = YEAR(DesdeF) AND Evtarti.Codmes = MONTH(DesdeF) THEN DO:
            DO I = DAY(DesdeF)  TO 31 :
              FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")) NO-LOCK NO-ERROR.
              IF AVAILABLE Gn-tcmb THEN DO: 
                  F-Salida  = F-Salida  + Evtarti.CanxDia[I].
                  T-Vtamn   = T-Vtamn   + Evtarti.Vtaxdiamn[I] + Evtarti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                  T-Vtame   = T-Vtame   + Evtarti.Vtaxdiame[I] + Evtarti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
              END.
            END.
            X-ENTRA = TRUE.
        END.
        IF Evtarti.Codano = YEAR(HastaF) AND Evtarti.Codmes = MONTH(HastaF) THEN DO:
            DO I = 1 TO DAY(HastaF) :
              FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")) NO-LOCK NO-ERROR.
              IF AVAILABLE Gn-tcmb THEN DO: 
                F-Salida  = F-Salida  + Evtarti.CanxDia[I].
                T-Vtamn   = T-Vtamn   + Evtarti.Vtaxdiamn[I] + Evtarti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                T-Vtame   = T-Vtame   + Evtarti.Vtaxdiame[I] + Evtarti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
              END.
            END.        
            X-ENTRA = TRUE.
        END.
        IF NOT X-ENTRA THEN DO:    
            DO I = 1 TO 31 :
              FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")) NO-LOCK NO-ERROR.
              IF AVAILABLE Gn-tcmb THEN DO: 
                  F-Salida  = F-Salida  + Evtarti.CanxDia[I].
                  T-Vtamn   = T-Vtamn   + Evtarti.Vtaxdiamn[I] + Evtarti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                  T-Vtame   = T-Vtame   + Evtarti.Vtaxdiame[I] + Evtarti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
              END.
            END.
        END.
      END.
      /******************************************************************************/      

      FIND tmp-tempo WHERE t-codcia  = S-CODCIA
                      AND  t-codfam  = Almmmatg.codfam 
                      AND  t-subfam  = Almmmatg.subfam
                      AND  t-prove   = Almmmatg.CodPr1
                      AND  t-codmat  = Evtarti.codmat
                     NO-ERROR.
      IF NOT AVAIL tmp-tempo THEN DO:
        CREATE tmp-tempo.
        ASSIGN t-codcia  = S-CODCIA
               t-codfam  = Almmmatg.codfam 
               t-subfam  = Almmmatg.subfam
               t-prove   = Almmmatg.CodPr1
               t-codmat  = Evtarti.codmat
               t-desmat  = Almmmatg.DesMat
               t-desmar  = Almmmatg.DesMar
               t-undbas  = Almmmatg.UndBas.
      END.
      ASSIGN T-Canti[10] = T-Canti[10] + F-Salida 
             T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
             T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
      
      /******************************Secuencia Para Cargar Datos en las Columnas *****************/
      
      X-ENTRA = FALSE.
      IF F-DIVISION-1 <> "" AND Evtarti.Coddiv = F-DIVISION-1 THEN DO:
         ASSIGN T-Canti[1] = T-Canti[1] + F-Salida 
                T-Venta[1] = T-venta[1] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[1] = T-Costo[1] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-2 <> "" AND Evtarti.Coddiv = F-DIVISION-2 THEN DO:
         ASSIGN T-Canti[2] = T-Canti[2] + F-Salida 
                T-Venta[2] = T-venta[2] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[2] = T-Costo[2] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-3 <> "" AND Evtarti.Coddiv = F-DIVISION-3 THEN DO:
         ASSIGN T-Canti[3] = T-Canti[3] + F-Salida 
                T-Venta[3] = T-venta[3] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[3] = T-Costo[3] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-4 <> "" AND Evtarti.Coddiv = F-DIVISION-4 THEN DO:
         ASSIGN T-Canti[4] = T-Canti[4] + F-Salida  
                T-Venta[4] = T-venta[4] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[4] = T-Costo[4] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-5 <> "" AND Evtarti.Coddiv = F-DIVISION-5 THEN DO:
         ASSIGN T-Canti[5] = T-Canti[5] + F-Salida 
                T-Venta[5] = T-venta[5] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[5] = T-Costo[5] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-6 <> "" AND Evtarti.Coddiv = F-DIVISION-6 THEN DO:
         ASSIGN T-Canti[6] = T-Canti[6] + F-Salida 
                T-Venta[6] = T-venta[6] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[6] = T-Costo[6] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
                X-ENTRA = TRUE.     
      END.       
      IF NOT X-ENTRA THEN DO:
         ASSIGN T-Canti[7] = T-Canti[7] + F-Salida 
                T-Venta[7] = T-venta[7] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[7] = T-Costo[7] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
                X-ENTRA = TRUE. 
       END.
      
     /**************************************************************************/
    
     /**************************************************/ 
   
   

END.

HIDE FRAME F-PROCESO.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-temporal W-Win 
PROCEDURE Carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
 ------------------------------------------------------------------------------*/

    DEF VAR x-Fecha-D AS DATE NO-UNDO.
    DEF VAR x-Fecha-H AS DATE NO-UNDO.
    DEF VAR x-CodDoc AS CHAR INIT 'FAC,BOL,N/C,TCK' NO-UNDO.
    
    FOR EACH tmp-tempo:
        DELETE tmp-tempo.
    END.
    ASSIGN
        x-Fecha-D = DATE(01,01,f-Periodo)
        x-Fecha-H = DATE(12,31,f-Periodo).

    /*
    DISPLAY WITH FRAME F-PROCESO.
    */
    FOR EACH GN-DIVI NO-LOCK WHERE Gn-Divi.CodCia = s-codcia 
        AND (LOOKUP(Gn-divi.CodDiv,f-division) > 0 OR
             f-division = ""):
        FOR EACH CcbCDocu NO-LOCK USE-INDEX Llave10 WHERE
            CcbCDocu.codcia = s-codcia AND
            CcbcDocu.CodDiv = Gn-Divi.CodDiv AND
            CcbcDocu.FchDoc >= x-Fecha-D AND
            Ccbcdocu.FchDoc <= x-Fecha-H AND
            LOOKUP(Ccbcdocu.coddoc,'FAC,BOL,N/C,TCK') > 0,
            FIRST Gn-Ven NO-LOCK WHERE Gn-Ven.CodCia = CcbcDocu.CodCia AND
                Gn-Ven.CodVen = CcbCDocu.CodVen:
             
            IF CcbCDocu.FlgEst = "A" THEN NEXT.
            IF f-Vendedor <> "" THEN
                IF LOOKUP(CcbCDocu.CodVen,f-Vendedor) = 0  THEN NEXT.            

            FIND GN-Clie WHERE Gn-clie.codcia = cl-codcia AND 
                Gn-Clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-clie THEN NEXT.

            IF LOOKUP(Gn-Clie.Canal,F-Canal) = 0 THEN NEXT.
            FIND Almtabla WHERE Almtabla.Tabla = 'CN' AND
                Almtabla.Codigo = Gn-Clie.Canal
                NO-LOCK NO-ERROR.
             IF AVAILABLE Almtabla THEN cNomCanal = Almtabla.Nombre. ELSE cNomCanal = "".
    
            x-signo1 = IF CcbCdocu.Coddoc = "N/C" THEN -1 ELSE 1.
            IF AVAIL Gn-Tcmb THEN
                ASSIGN
                    x-TpoCmbCmp = Gn-Tcmb.Compra
                    x-TpoCmbVta = Gn-Tcmb.Venta.
            IF Ccbcdocu.coddoc = 'N/C' AND
                Ccbcdocu.CndCre = 'N'    /* NOta de Credito OTROS */
            THEN DO:
                /*
                RUN Procesa-Nota.
                */
                NEXT.
            END.
            FOR EACH CcbDDocu OF CcbCDocu NO-LOCK,
                FIRST Almmmatg NO-LOCK WHERE
                Almmmatg.CodCia = CcbCDocu.CodCia AND
                Almmmatg.CodMat = CcbDDocu.codmat AND
                (LOOKUP(Almmmatg.CodFam,F-CodFam) > 0 OR
                F-CodFam = ""):
                FIND FIRST tmp-tempo WHERE
                    t-Canal  = Gn-Clie.Canal   AND
                    t-CodVen = Ccbcdocu.codven AND
                    t-CodCli = Ccbcdocu.codcli AND
                    t-CodFam = Almmmatg.codfam NO-ERROR.
                IF NOT AVAILABLE tmp-tempo THEN DO:
                    CREATE tmp-tempo.
                    ASSIGN 
                        t-Canal = Gn-Clie.Canal
                        t-CodVen = Ccbcdocu.codven
                        t-CodCli = Ccbcdocu.codcli
                        t-CodFam = Almmmatg.codfam                        
                        t-descan = cNomCanal
                        t-nomven = Gn-Ven.NomVen
                        t-nomcli = Gn-Clie.NomCli.
                    FIND Almtfami WHERE
                        Almtfami.codCia = Almmmatg.CodCia AND
                        Almtfami.codFam = Almmmatg.CodFam NO-LOCK NO-ERROR.
                    IF AVAILABLE Almtfami THEN t-desfam = Almtfami.DesFam.
                END.
                FIND Almtconv WHERE
                    Almtconv.CodUnid  = Almmmatg.UndBas AND
                    Almtconv.Codalter = Ccbddocu.UndVta NO-LOCK NO-ERROR.
                F-FACTOR  = 1. 
                IF AVAILABLE Almtconv THEN DO:
                    F-FACTOR = Almtconv.Equival.
                    IF Almmmatg.FacEqu <> 0 THEN
                        F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
                END.
                i = MONTH(Ccbcdocu.FchDoc).
                IF Ccbcdocu.CodMon = 1 THEN
                    ASSIGN
                        t-imptot[i] = t-imptot[i] + x-signo1 * CcbDdocu.ImpLin.
                IF Ccbcdocu.CodMon = 2 THEN
                    ASSIGN
                        t-impto[i] = t-imptot[i] + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta.
            END.  /* Ccbddocu */

            DISPLAY "Cargando: " + CcbCDocu.coddiv + "-" + CcbCDocu.codcli @ x-mensaje
                WITH FRAME {&FRAME-NAME}.

            /*
            DISPLAY
                CcbCDocu.coddiv "-" CcbCDocu.codcli @ FI-Mensaje
                    LABEL "Cliente"
                WITH FRAME F-PROCESO.
            */    
        END.  /* Ccbcdocu */
    END.  /* DIVISIONES */
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY F-periodo F-DIVISION F-Canal F-CodFam F-Vendedor x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-61 RECT-62 F-periodo BUTTON-4 BUTTON-5 BUTTON-6 BUTTON-7 Btn_OK 
         Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         Tmp-Tempo.t-canal     COLUMN-LABEL "Canal" 
         Tmp-Tempo.t-descan    COLUMN-LABEL "Descripción!Canal" 
         Tmp-Tempo.t-codven    COLUMN-LABEL "Código!Vendedor"
         Tmp-Tempo.t-nomven    COLUMN-LABEL "Nombre!Vendedor"
         Tmp-Tempo.t-codcli    COLUMN-LABEL "Código!Cliente"
         Tmp-Tempo.t-nomcli    COLUMN-LABEL "Nombre!Cliente"
         Tmp-Tempo.t-codfam    COLUMN-LABEL "Familia" 
         Tmp-Tempo.t-desfam    COLUMN-LABEL "Descripción!Familia" 
         Tmp-Tempo.t-impto[1]  COLUMN-LABEL "Enero"
         Tmp-Tempo.t-impto[2]  COLUMN-LABEL "Febrero"
         Tmp-Tempo.t-impto[3]  COLUMN-LABEL "Marzo"
         Tmp-Tempo.t-impto[4]  COLUMN-LABEL "Abril"
         Tmp-Tempo.t-impto[5]  COLUMN-LABEL "Mayo"
         Tmp-Tempo.t-impto[6]  COLUMN-LABEL "Junio"
         Tmp-Tempo.t-impto[7]  COLUMN-LABEL "Julio"
         Tmp-Tempo.t-impto[8]  COLUMN-LABEL "Agosto"
         Tmp-Tempo.t-impto[9]  COLUMN-LABEL "Setiembre"
         Tmp-Tempo.t-impto[10]  COLUMN-LABEL "Octubre"
         Tmp-Tempo.t-impto[11]  COLUMN-LABEL "Noviembre"
         Tmp-Tempo.t-impto[12]  COLUMN-LABEL "Diciembre"  
        WITH STREAM-IO NO-BOX  DOWN WIDTH 360. 

  DISPLAY "Cargando Informacion..." @ x-mensaje WITH FRAME {&FRAME-NAME}.

  FOR EACH Tmp-Tempo NO-LOCK
      BREAK BY Tmp-Tempo.T-canal by Tmp-Tempo.t-CodVen:
      DISPLAY STREAM REPORT
         Tmp-Tempo.t-canal
         Tmp-Tempo.t-descan
         Tmp-Tempo.t-codven
         Tmp-Tempo.t-nomven
         Tmp-Tempo.t-codcli
         Tmp-Tempo.t-nomcli
         Tmp-Tempo.t-codfam
         Tmp-Tempo.t-desfam
         Tmp-Tempo.t-impto[1]
         Tmp-Tempo.t-impto[2]
         Tmp-Tempo.t-impto[3]
         Tmp-Tempo.t-impto[4]
         Tmp-Tempo.t-impto[5]
         Tmp-Tempo.t-impto[6]
         Tmp-Tempo.t-impto[7]
         Tmp-Tempo.t-impto[8]
         Tmp-Tempo.t-impto[9]
         Tmp-Tempo.t-impto[10]
         Tmp-Tempo.t-impto[11]
         Tmp-Tempo.t-impto[12]
      WITH FRAME F-REPORTE.
      /*
      DISPLAY WITH FRAME F-PROCESO.
      */      
  END.

  /*
  HIDE FRAME F-PROCESO.
  */

  DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.  
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime W-Win 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.
DEF VAR x-NameArch AS CHAR.
DEF VAR OKpressed AS LOGICAL INIT TRUE.
    
    SYSTEM-DIALOG GET-FILE x-NameArch
        TITLE      "Guardar Archivo"
        FILTERS    "(*.txt)"   "*.txt"
        ASK-OVERWRITE
        DEFAULT-EXTENSION ".txt"
        RETURN-TO-START-DIR
        SAVE-AS
        USE-FILENAME
        UPDATE OKpressed.
      
    IF OKpressed <> TRUE THEN RETURN.

    RUN Carga-Temporal.
    FIND FIRST TMP-Tempo NO-LOCK NO-ERROR.
    IF NOT AVAILABLE TMP-Tempo THEN DO:
        MESSAGE
            "No hay registros a imprimir"
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    OUTPUT STREAM REPORT TO VALUE (x-NameArch).
    RUN FORMATO.
    MESSAGE "Proceso Terminado" VIEW-AS ALERT-BOX INFORMATION.
    OUTPUT STREAM REPORT CLOSE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Nota W-Win 
PROCEDURE Procesa-Nota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*FOR EACH CcbDdocu OF CcbCdocu:
 *     x-can = IF CcbDdocu.CodMat = "00005" THEN 1 ELSE 0.
 * END.*/
x-signo1= -1.
FIND B-CDOCU WHERE B-CDOCU.Codcia = CcbCdocu.Codcia AND
     B-CDOCU.CodDoc = CcbCdocu.Codref AND
     B-CDOCU.NroDoc = CcbCdocu.Nroref 
     NO-LOCK NO-ERROR.
  IF AVAILABLE B-CDOCU THEN DO:
     x-coe = CcbCdocu.ImpTot / B-CDOCU.ImpTot.
     FOR EACH CcbDdocu OF B-CDOCU NO-LOCK,
         FIRST Almmmatg no-lock WHERE Almmmatg.CodCia = CcbCDocu.CodCia 
         AND Almmmatg.CodMat = CcbDDocu.codmat
         AND (LOOKUP(Almmmatg.CodFam,F-CodFam) > 0 OR
         F-CodFam = ""):
         FIND FIRST tmp-tempo WHERE    
              t-Canal = Gn-Clie.Canal AND
              t-CodVen = Ccbcdocu.codven AND
              t-CodCli = Ccbcdocu.codcli AND
              t-CodFam = Almmmatg.codfam
              NO-ERROR.
         IF NOT AVAILABLE tmp-tempo THEN DO:
              CREATE tmp-tempo.
              ASSIGN 
                  t-Canal = Gn-Clie.Canal
                  t-CodVen = Ccbcdocu.codven
                  t-CodCli = Ccbcdocu.codcli
                  t-CodFam = Almmmatg.codfam                        
                  t-descan = cNomCanal
                  t-nomven = Gn-Ven.NomVen
                  t-nomcli = Gn-Clie.NomCli.
              FIND Almtfami WHERE
                  Almtfami.codCia = Almmmatg.CodCia AND
                  Almtfami.codFam = Almmmatg.CodFam
                  NO-LOCK NO-ERROR.
              IF AVAILABLE Almtfami THEN
                  t-desfam = Almtfami.DesFam.
         END.
         FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
              AND Almtconv.Codalter = Ccbddocu.UndVta NO-LOCK NO-ERROR.
         F-FACTOR  = 1. 
         IF AVAILABLE Almtconv THEN DO:
            F-FACTOR = Almtconv.Equival.
            IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
        END.  
        i = MONTH(Ccbcdocu.FchDoc).     
        IF Ccbcdocu.CodMon = 1 
        THEN ASSIGN
            t-imptot[i] = t-imptot[i] + x-signo1 * CcbDdocu.ImpLin.
        IF Ccbcdocu.CodMon = 2 
        THEN ASSIGN
            t-impto[i] = t-imptot[i] + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta.      
     END. 
     DISPLAY
        CcbCDocu.coddiv "-" CcbCDocu.codcli @ FI-Mensaje
            LABEL "Cliente"
        WITH FRAME F-PROCESO. 
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
PROCEDURE recoge-parametros :
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
        WHEN "F-Subfam" THEN ASSIGN input-var-1 = F-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        WHEN "F-marca1" OR WHEN "F-marca2" THEN ASSIGN input-var-1 = "MK".
        WHEN "" THEN ASSIGN input-var-1 = "".
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida W-Win 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF DECIMAL(F-Periodo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = 0 OR 
    DECIMAL(F-Periodo:SCREEN-VALUE IN FRAME {&FRAME-NAME})< 1950 OR 
    DECIMAL(F-Periodo:SCREEN-VALUE IN FRAME {&FRAME-NAME})> YEAR(TODAY) THEN DO:
    MESSAGE "Periodo Invalido" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO F-PERIODO IN FRAME {&FRAME-NAME}.
    RETURN "ADM-ERROR".
END.

IF F-Division:SCREEN-VALUE = "" THEN DO:
     MESSAGE "Ingrese Division" VIEW-AS ALERT-BOX ERROR.
     FOR EACH GN-DIVI WHERE gn-divi.codcia = s-codcia NO-LOCK:
        IF f-Division = '' 
        THEN f-Division = TRIM(gn-divi.coddiv).
        ELSE f-Division = f-Division + ',' + TRIM(gn-divi.coddiv).
    END.

     /*APPLY "ENTRY" TO F-Division IN FRAME {&FRAME-NAME}.*/
     RETURN "ADM-ERROR".
END.
ELSE DO:
        DO I = 1 TO NUM-ENTRIES(F-DIVISION):
          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                             Gn-Divi.Coddiv = ENTRY(I,F-DIVISION) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
            MESSAGE "Division " + ENTRY(I,F-DIVISION) + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-DIVISION IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.                             
        END.
END.

IF F-CODFAM <> "" THEN DO:
        DO I = 1 TO NUM-ENTRIES(F-CODFAM):
          FIND AlmtFami WHERE AlmtFami.Codcia = S-CODCIA AND
                              AlmtFami.CodFam = ENTRY(I,F-CODFAM) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE AlmtFami THEN DO:
            MESSAGE "Familia " + ENTRY(I,F-CODFAM) + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-CODFAM IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.                             
        END.
END.


IF F-CANAL <> "" THEN DO:
        DO I = 1 TO NUM-ENTRIES(F-Canal):
          FIND AlmTabla WHERE AlmTabla.Tabla = 'CN' AND
                              AlmTabla.Codigo = ENTRY(I,F-Canal) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE AlmTabla THEN DO:
            MESSAGE "Canal " + ENTRY(I,F-Canal) + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-Canal IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.                             
        END.
END.

IF F-VENDEDOR <> "" THEN DO:
        DO I = 1 TO NUM-ENTRIES(F-VENDEDOR):
          FIND Gn-Ven WHERE Gn-Ven.CodCia = S-CODCIA AND
                              Gn-Ven.Codven = ENTRY(I,F-Vendedor) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Ven THEN DO:
            MESSAGE "Vendedor " + ENTRY(I,F-Vendedor) + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-Vendedor IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.                             
        END.
END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

