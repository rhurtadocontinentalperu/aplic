&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR cl-codcia AS INT.
DEF VAR pv-codcia AS INT.


FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

/* Local Variable Definitions ---                                       */

DEF TEMP-TABLE DETALLE
    FIELD CodMat LIKE Almmmatg.codmat
    FIELD Desmat LIKE Almmmatg.desmat
    FIELD DesMar LIKE Almmmatg.desmar
    FIELD UndBas LIKE Almmmatg.undbas
    FIELD CodPro LIKE Gn-prov.codpro
    FIELD CodCli LIKE Gn-clie.codcli
    FIELD CodFam LIKE Almmmatg.codfam
    FIELD Pedido    AS DEC EXTENT 50
    FIELD Facturado AS DEC EXTENT 50.

DEF TEMP-TABLE RESUMEN LIKE DETALLE.
    
DEF TEMP-TABLE T-Clientes
    FIELD Orden AS INT
    FIELD CodCli LIKE Gn-clie.codcli
    INDEX Llave01 AS PRIMARY Orden.

/* Cargamos los clientes */
DEF VAR x-Cuenta-Clientes AS INT.

FOR EACH Gn-clie NO-LOCK WHERE Gn-clie.codcia = cl-codcia 
    AND Gn-clie.venant <> '' BREAK BY Gn-clie.venant:
    IF FIRST-OF(Gn-clie.venant) THEN DO:
        CREATE T-Clientes.
        ASSIGN
            T-Clientes.orden = INTEGER(Gn-clie.venant)
            T-Clientes.codcli = Gn-clie.codcli
            x-Cuenta-Clientes = INTEGER(Gn-clie.venant).
        PAUSE 0.
    END.
    ELSE T-Clientes.codcli = TRIM(T-Clientes.codcli) + ',' + Gn-clie.codcli.
END.

DEF VAR x-CodCli AS CHAR FORMAT 'x(11)'.
DEF FRAME f-Mensaje
    "Cliente:" x-CodCli
    WITH CENTERED OVERLAY NO-LABELS VIEW-AS DIALOG-BOX.

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
&Scoped-Define ENABLED-OBJECTS x-CodDiv x-CodFam x-CodPro x-CodMat-1 ~
x-CodMat-2 x-Fecha-1 x-Fecha-2 x-Tipo-1 x-Tipo-2 x-CodMon BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS x-CodDiv x-CodFam x-CodPro x-CodMat-1 ~
x-CodMat-2 x-Fecha-1 x-Fecha-2 x-Tipo-1 x-Tipo-2 x-CodMon txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\print1":U
     LABEL "Button 1" 
     SIZE 7 BY 1.73.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\exit":U
     LABEL "Button 2" 
     SIZE 7 BY 1.73.

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE x-CodFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Linea" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE x-Tipo-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Proveedor - Articulo" 
     LABEL "Tipo de Reporte" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Proveedor - Articulo","Resumen - Proveedor","Resumen - Linea" 
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE x-Tipo-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Cantidad" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Cantidad","Venta","Costo" 
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U INITIAL "Cargando Informacion....." 
     VIEW-AS FILL-IN 
     SIZE 34.29 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-CodMat-1 AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodMat-2 AS CHARACTER FORMAT "X(6)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodPro AS CHARACTER FORMAT "x(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE x-Fecha-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-Fecha-2 AS DATE FORMAT "99/99/99":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodMon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 18 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodDiv AT ROW 1.38 COL 14 COLON-ALIGNED
     x-CodFam AT ROW 2.35 COL 14 COLON-ALIGNED
     x-CodPro AT ROW 3.31 COL 14 COLON-ALIGNED
     x-CodMat-1 AT ROW 4.27 COL 14 COLON-ALIGNED
     x-CodMat-2 AT ROW 4.27 COL 30 COLON-ALIGNED
     x-Fecha-1 AT ROW 5.23 COL 14 COLON-ALIGNED
     x-Fecha-2 AT ROW 5.23 COL 30 COLON-ALIGNED
     x-Tipo-1 AT ROW 6.19 COL 14 COLON-ALIGNED
     x-Tipo-2 AT ROW 7.15 COL 14 COLON-ALIGNED NO-LABEL
     x-CodMon AT ROW 8.12 COL 16 NO-LABEL
     BUTTON-1 AT ROW 9.27 COL 5
     BUTTON-2 AT ROW 9.27 COL 14
     txt-msj AT ROW 9.62 COL 24 NO-LABEL WIDGET-ID 2
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 8.12 COL 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.86 BY 11.5
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
         TITLE              = "VENTAS CLIENTES VIP"
         HEIGHT             = 11.5
         WIDTH              = 71.86
         MAX-HEIGHT         = 11.5
         MAX-WIDTH          = 71.86
         VIRTUAL-HEIGHT     = 11.5
         VIRTUAL-WIDTH      = 71.86
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       txt-msj:HIDDEN IN FRAME F-Main           = TRUE
       txt-msj:READ-ONLY IN FRAME F-Main        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* VENTAS CLIENTES VIP */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* VENTAS CLIENTES VIP */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  ASSIGN
      x-CodDiv x-CodFam x-CodMat-1 x-CodMat-2 
      x-CodPro x-Fecha-1 x-Fecha-2 x-Tipo-1 
      x-Tipo-2 x-CodMon.

  IF  x-Fecha-1 = ? OR x-Fecha-2 = ? THEN DO:
      MESSAGE 'Ingrese el rango de fechas' VIEW-AS ALERT-BOX ERROR.
      APPLY "entry" TO x-fecha-1.
      RETURN NO-APPLY.
  END.
  RUN Imprimir.
  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-TpoCmb AS DEC.
  DEF VAR x-CodMes AS INT.
  DEF VAR x-CodAno AS INT.
  DEF VAR x-Fecha AS DATE.
  DEF VAR i AS INT.
  DEF VAR j AS INT.
    
  FOR EACH Detalle:
    DELETE Detalle.
  END.

  FOR EACH T-Clientes:
      DO j = 1 TO NUM-ENTRIES(T-Clientes.codcli):
          x-CodCli = ENTRY(j, T-Clientes.codcli).
          /* PEDIDOS */
          FOR EACH FacCPedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
              AND Faccpedi.coddoc = 'PED'
              AND Faccpedi.codcli = x-CodCli
              AND (x-CodDiv = 'Todas' OR Faccpedi.coddiv = x-CodDiv)
              AND (x-Fecha-1 = ? OR Faccpedi.fchped >= x-Fecha-1)
              AND (x-Fecha-2 = ? OR Faccpedi.fchped <= x-Fecha-2)
              AND Faccpedi.flgest <> 'A',
              EACH FacDPedi OF FacCPedi NO-LOCK,
                FIRST Almmmatg OF Facdpedi NO-LOCK WHERE Almmmatg.codpr1 BEGINS x-CodPro
                    AND (x-CodMat-1 = '' OR Almmmatg.codmat >= x-CodMat-1)
                    AND (x-CodMat-2 = '' OR Almmmatg.codmat <= x-CodMat-2)
                    AND (x-CodFam = 'Todas' OR Almmmatg.codfam = x-CodFam):

              IF Faccpedi.codmon = x-codmon THEN x-TpoCmb = 1.
              ELSE IF x-codmon = 1 
                  THEN x-TpoCmb = Faccpedi.tpocmb.
                ELSE x-TpoCmb = 1 / Faccpedi.tpocmb.
              CREATE Detalle.
              ASSIGN
                  Detalle.CodMat = Almmmatg.codmat
                  Detalle.Desmat = Almmmatg.desmat
                  Detalle.DesMar = Almmmatg.desmar
                  Detalle.UndBas = Almmmatg.undbas
                  Detalle.CodPro = Almmmatg.codpr1
                  Detalle.CodFam = Almmmatg.codfam.
              CASE x-Tipo-2:
                  WHEN 'Cantidad' THEN DO:
                      Detalle.Pedido[T-Clientes.orden] = Detalle.Pedido[T-Clientes.orden] + (Facdpedi.canped * Facdpedi.factor).
                  END.
                  WHEN 'Venta' THEN DO:
                      Detalle.Pedido[T-Clientes.orden] = Detalle.Pedido[T-Clientes.orden] + Facdpedi.implin * x-TpoCmb.
                  END.
/*            WHEN 'Costo' THEN DO:
 *                 Detalle.Pedido[T-Clientes.orden] = Detalle.Pedido[T-Clientes.orden] + Facdpedi.impcto.
 *             END.*/
              END CASE.            
          END.
          /* ESTADISTICAS DE VENTAS */
          FOR EACH Almmmatg WHERE Almmmatg.codcia = s-codcia
              AND (x-CodMat-1 = '' OR Almmmatg.codmat >= x-CodMat-1)
              AND (x-CodMat-2 = '' OR Almmmatg.codmat <= x-CodMat-2)
              AND (x-CodFam = 'Todas' OR Almmmatg.codfam = x-CodFam)
              AND Almmmatg.codpr1 BEGINS x-CodPro,
              EACH EvtClArti NO-LOCK WHERE EvtClArti.CodCia = s-codcia
                  AND EvtClArti.CodDiv = x-CodDiv
                  AND EvtClArti.CodCli = x-CodCli
                  AND EvtClArti.codmat = Almmmatg.codmat
                  AND (x-Fecha-1 = ? OR EvtClArti.Nrofch >= YEAR(x-Fecha-1) * 100 + MONTH(x-Fecha-1))
                  AND (x-Fecha-2 = ? OR EvtClArti.Nrofch <= YEAR(x-Fecha-2) * 100 + MONTH(x-Fecha-2)):
              CREATE Detalle.
              ASSIGN
                  Detalle.CodMat = Almmmatg.codmat
                  Detalle.Desmat = Almmmatg.desmat
                  Detalle.DesMar = Almmmatg.desmar
                  Detalle.UndBas = Almmmatg.undbas
                  Detalle.CodPro = Almmmatg.codpr1
                  Detalle.CodFam = Almmmatg.codfam.

              IF EvtClArti.Codmes < 12 THEN DO:
                  ASSIGN
                      X-CODMES = EvtClArti.Codmes + 1
                      X-CODANO = EvtClArti.Codano.
              END.
              ELSE DO: 
                  ASSIGN
                      X-CODMES = 01
                      X-CODANO = EvtClArti.Codano + 1.
              END.
              DO I = 1 TO DAY( DATE(STRING(01,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ):
                  X-FECHA = DATE(STRING(I,"99") + "/" + STRING(EvtClArti.Codmes,"99") + "/" + STRING(EvtClArti.Codano,"9999")).
                  IF X-FECHA >= x-Fecha-1 AND X-FECHA <= x-Fecha-2 THEN DO:
                      FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + 
                                                              STRING(EvtClArti.Codmes,"99") + "/" + 
                                                              STRING(EvtClArti.Codano,"9999")) NO-LOCK NO-ERROR.
                      IF AVAILABLE Gn-tcmb THEN DO: 
                          CASE x-Tipo-2:
                              WHEN 'Cantidad' THEN DO:
                                  Detalle.Facturado[T-Clientes.orden] = Detalle.Facturado[T-Clientes.orden] + EvtClArti.Canxdia[I].
                              END.
                              WHEN 'Venta' THEN DO:
                                IF x-CodMon = 1
                                    THEN Detalle.Facturado[T-Clientes.orden] = Detalle.Facturado[T-Clientes.orden] + EvtClArti.Vtaxdiamn[I] + EvtClArti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                                ELSE Detalle.Facturado[T-Clientes.orden] = Detalle.Facturado[T-Clientes.orden] + EvtClArti.Vtaxdiame[I] + EvtClArti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                              END.
                              WHEN 'Costo' THEN DO:
                                IF x-CodMon = 1
                                    THEN Detalle.Facturado[T-Clientes.orden] = Detalle.Facturado[T-Clientes.orden] + EvtClArti.Ctoxdiamn[I] + EvtClArti.Ctoxdiame[I] * Gn-Tcmb.Venta.
                                ELSE Detalle.Facturado[T-Clientes.orden] = Detalle.Facturado[T-Clientes.orden] + EvtClArti.Ctoxdiame[I] + EvtClArti.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                              END.
                          END CASE.            
                      END.
                  END.
              END.    /* FIN DEL DO I = 1 */
          END.    /* FIN DEL FOR EACH */
      END.
  END.
  /*
  HIDE FRAME f-Mensaje.
  */          
END PROCEDURE.

/*
  FOR EACH T-Clientes:
    DO i = 1 TO NUM-ENTRIES(T-Clientes.codcli):
        x-CodCli = ENTRY(i, T-Clientes.codcli).
        /* PEDIDOS */
        FOR EACH FacCPedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
                AND Faccpedi.coddoc = 'PED'
                AND Faccpedi.codcli = x-CodCli
                AND (x-CodDiv = 'Todas' OR Faccpedi.coddiv = x-CodDiv)
                AND (x-Fecha-1 = ? OR Faccpedi.fchped >= x-Fecha-1)
                AND (x-Fecha-2 = ? OR Faccpedi.fchped <= x-Fecha-2)
                AND Faccpedi.flgest <> 'A',
                EACH FacDPedi OF FacCPedi NO-LOCK,
                    FIRST Almmmatg OF Facdpedi NO-LOCK WHERE Almmmatg.codpr1 BEGINS x-CodPro
                        AND (x-CodMat-1 = '' OR Almmmatg.codmat >= x-CodMat-1)
                        AND (x-CodMat-2 = '' OR Almmmatg.codmat <= x-CodMat-2)
                        AND (x-CodFam = 'Todas' OR Almmmatg.codfam = x-CodFam):
            IF Faccpedi.codmon = x-codmon THEN x-TpoCmb = 1.
            ELSE IF x-codmon = 1 
                THEN x-TpoCmb = Faccpedi.tpocmb.
                ELSE x-TpoCmb = 1 / Faccpedi.tpocmb.
            CREATE Detalle.
            ASSIGN
                Detalle.CodMat = Almmmatg.codmat
                Detalle.Desmat = Almmmatg.desmat
                Detalle.DesMar = Almmmatg.desmar
                Detalle.UndBas = Almmmatg.undbas
                Detalle.CodPro = Almmmatg.codpr1
                Detalle.CodFam = Almmmatg.codfam.
            CASE x-Tipo-2:
            WHEN 'Cantidad' THEN DO:
                Detalle.Pedido[T-Clientes.orden] = Detalle.Pedido[T-Clientes.orden] + (Facdpedi.canped * Facdpedi.factor).
            END.
            WHEN 'Venta' THEN DO:
                    Detalle.Pedido[T-Clientes.orden] = Detalle.Pedido[T-Clientes.orden] + Facdpedi.implin * x-TpoCmb.
            END.
/*            WHEN 'Costo' THEN DO:
 *                 Detalle.Pedido[T-Clientes.orden] = Detalle.Pedido[T-Clientes.orden] + Facdpedi.impcto.
 *             END.*/
            END CASE.            
        END.
        /* FACTURACION */
        FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
                AND (Ccbcdocu.coddoc = 'FAC' OR Ccbcdocu.coddoc = 'BOL')
                AND Ccbcdocu.codcli = x-CodCli
                AND (x-CodDiv = 'Todas' OR Ccbcdocu.coddiv = x-CodDiv)
                AND (x-Fecha-1 = ? OR Ccbcdocu.fchdoc >= x-Fecha-1)
                AND (x-Fecha-2 = ? OR Ccbcdocu.fchdoc <= x-Fecha-2)
                AND Ccbcdocu.flgest <> 'A',
                EACH Ccbddocu OF Ccbcdocu NO-LOCK,
                    FIRST Almmmatg OF Ccbddocu NO-LOCK WHERE Almmmatg.codpr1 BEGINS x-CodPro
                        AND (x-CodMat-1 = '' OR Almmmatg.codmat >= x-CodMat-1)
                        AND (x-CodMat-2 = '' OR Almmmatg.codmat <= x-CodMat-2)
                        AND (x-CodFam = 'Todas' OR Almmmatg.codfam = x-CodFam):
            IF Ccbcdocu.codmon = x-codmon THEN x-TpoCmb = 1.
            ELSE IF x-codmon = 1 
                THEN x-TpoCmb = Ccbcdocu.tpocmb.
                ELSE x-TpoCmb = 1 / Ccbcdocu.tpocmb.
            CREATE Detalle.
            ASSIGN
                Detalle.CodMat = Almmmatg.codmat
                Detalle.Desmat = Almmmatg.desmat
                Detalle.DesMar = Almmmatg.desmar
                Detalle.UndBas = Almmmatg.undbas
                Detalle.CodPro = Almmmatg.codpr1
                Detalle.CodFam = Almmmatg.codfam.
            CASE x-Tipo-2:
            WHEN 'Cantidad' THEN DO:
                Detalle.Facturado[T-Clientes.orden] = Detalle.Facturado[T-Clientes.orden] + (Ccbddocu.candes * Ccbddocu.factor).
            END.
            WHEN 'Venta' THEN DO:
                Detalle.Facturado[T-Clientes.orden] = Detalle.Facturado[T-Clientes.orden] + Ccbddocu.implin * x-TpoCmb.
            END.
            WHEN 'Costo' THEN DO:
                Detalle.Facturado[T-Clientes.orden] = Detalle.Facturado[T-Clientes.orden] + Ccbddocu.impcto * x-TpoCmb.
            END.
            END CASE.            
        END.
    END.
  END.
*/

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
  DISPLAY x-CodDiv x-CodFam x-CodPro x-CodMat-1 x-CodMat-2 x-Fecha-1 x-Fecha-2 
          x-Tipo-1 x-Tipo-2 x-CodMon txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-CodDiv x-CodFam x-CodPro x-CodMat-1 x-CodMat-2 x-Fecha-1 x-Fecha-2 
         x-Tipo-1 x-Tipo-2 x-CodMon BUTTON-1 BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-1 W-Win 
PROCEDURE Excel-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Acumulamos */
DEFINE VARIABLE iContador               AS INTEGER.

FOR EACH Resumen:
    DELETE Resumen.
END.
FOR EACH Detalle BREAK BY Detalle.CodMat:
    IF FIRST-OF(Detalle.codmat) THEN DO:
        CREATE Resumen.
        ASSIGN
            Resumen.CodMat = Detalle.codmat
            Resumen.Desmat = Detalle.desmat
            Resumen.DesMar = Detalle.desmar
            Resumen.UndBas = Detalle.undbas.
    END.
    DO iContador = 1 TO x-Cuenta-Clientes:
        Resumen.Pedido[iContador] = Resumen.Pedido[iContador] + Detalle.Pedido[iContador].
        Resumen.Facturado[iContador] = Resumen.Facturado[iContador] + Detalle.Facturado[iContador].
    END.        
END.   
/* ************ */

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.
DEFINE VARIABLE cCaracter               AS CHARACTER.
DEFINE VARIABLE cCaracter-2             AS CHARACTER.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
cColumn = STRING(t-Column).
cRange = "B" + cColumn.
CASE x-Tipo-2:
    WHEN 'Cantidad' THEN chWorkSheet:Range(cRange):Value = "Cantidades".
    WHEN 'Venta' THEN chWorkSheet:Range(cRange):Value = "Ventas".
    WHEN 'Costo' THEN chWorkSheet:Range(cRange):Value = "Costos".
END CASE.
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "B" + cColumn.
IF x-CodMon = 1
THEN chWorkSheet:Range(cRange):Value = "Importes en Nuevos Soles".
ELSE chWorkSheet:Range(cRange):Value = "Importes en Dolares Americanos".

t-Column = t-Column + 1.
cCaracter = 'D'.
cCaracter-2 = ''.
cColumn = STRING(t-Column).
DO iContador = 1 TO x-Cuenta-Clientes:
    IF ASC(cCaracter) + 2 > 90 THEN DO:
        cCaracter = CHR(ASC('A') - 1).
        IF cCaracter-2 = ''
        THEN cCaracter-2 = 'A'.
        ELSE cCaracter-2 = TRIM(CHR(ASC(cCaracter-2) + 1)).
    END.
    cCaracter = TRIM(CHR(ASC(cCaracter) + 2)).
    cRange = cCaracter-2 + cCaracter + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + STRING(iContador, '99').
END.

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
chWorkSheet:Columns("A"):ColumnWidth = 6.
chWorkSheet:Columns("B"):ColumnWidth = 40.
chWorkSheet:Columns("C"):ColumnWidth = 20.
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Codigo".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Marca".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Uni".
cCaracter = 'D'.
cCaracter-2 = ''.
DO iContador = 1 TO x-Cuenta-Clientes:
    IF ASC(cCaracter) + 1 > 90 THEN DO:
        cCaracter = CHR(ASC('A') - 1).
        IF cCaracter-2 = ''
        THEN cCaracter-2 = 'A'.
        ELSE cCaracter-2 = TRIM(CHR(ASC(cCaracter-2) + 1)).
    END.
    cCaracter = TRIM(CHR(ASC(cCaracter) + 1)).
    cRange = cCaracter-2 + cCaracter + cColumn.
    chWorkSheet:Range(cRange):Value = 'Pedido'.
    IF ASC(cCaracter) + 1 > 90 THEN DO:
        cCaracter = CHR(ASC('A') - 1).
        IF cCaracter-2 = ''
        THEN cCaracter-2 = 'A'.
        ELSE cCaracter-2 = TRIM(CHR(ASC(cCaracter-2) + 1)).
    END.
    cCaracter = TRIM(CHR(ASC(cCaracter) + 1)).
    cRange = cCaracter-2 + cCaracter + cColumn.
    chWorkSheet:Range(cRange):Value = 'Facturado'.
END.

FOR EACH Resumen BY Resumen.CodMat:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Resumen.codmat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = Resumen.desmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = Resumen.desmar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = Resumen.undbas.
    cCaracter = 'D'.
    cCaracter-2 = ''.
    DO iContador = 1 TO x-Cuenta-Clientes:
        IF ASC(cCaracter) + 1 > 90 THEN DO:
            cCaracter = CHR(ASC('A') - 1).
            IF cCaracter-2 = ''
            THEN cCaracter-2 = 'A'.
            ELSE cCaracter-2 = TRIM(CHR(ASC(cCaracter-2) + 1)).
        END.
        cCaracter = TRIM(CHR(ASC(cCaracter) + 1)).
        cRange = cCaracter-2 + cCaracter + cColumn.
        chWorkSheet:Range(cRange):Value = Resumen.Pedido[iContador].
        IF ASC(cCaracter) + 1 > 90 THEN DO:
            cCaracter = CHR(ASC('A') - 1).
            IF cCaracter-2 = ''
            THEN cCaracter-2 = 'A'.
            ELSE cCaracter-2 = TRIM(CHR(ASC(cCaracter-2) + 1)).
        END.
        cCaracter = TRIM(CHR(ASC(cCaracter) + 1)).
        cRange = cCaracter-2 + cCaracter + cColumn.
        chWorkSheet:Range(cRange):Value = Resumen.Facturado[iContador].
    END.
END.

t-Column = t-Column + 3.
FOR EACH Gn-clie WHERE Gn-clie.codcia = cl-codcia 
        AND Gn-clie.venant <> '' BREAK BY Gn-clie.venant:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Gn-clie.venant.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Gn-clie.codcli.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = Gn-clie.nomcli.
END.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-2 W-Win 
PROCEDURE Excel-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Acumulamos */
DEFINE VARIABLE iContador               AS INTEGER.

FOR EACH Resumen:
    DELETE Resumen.
END.
FOR EACH Detalle BREAK BY Detalle.CodPro:
    IF FIRST-OF(Detalle.codpro) THEN DO:
        CREATE Resumen.
        ASSIGN
            Resumen.CodPro = Detalle.codpro.
    END.
    DO iContador = 1 TO x-Cuenta-Clientes:
        Resumen.Pedido[iContador] = Resumen.Pedido[iContador] + Detalle.Pedido[iContador].
        Resumen.Facturado[iContador] = Resumen.Facturado[iContador] + Detalle.Facturado[iContador].
    END.        
END.   
/* ************ */

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.
DEFINE VARIABLE cCaracter               AS CHARACTER.
DEFINE VARIABLE cCaracter-2             AS CHARACTER.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
cColumn = STRING(t-Column).
cRange = "B" + cColumn.
CASE x-Tipo-2:
    WHEN 'Cantidad' THEN chWorkSheet:Range(cRange):Value = "Cantidades".
    WHEN 'Venta' THEN chWorkSheet:Range(cRange):Value = "Ventas".
    WHEN 'Costo' THEN chWorkSheet:Range(cRange):Value = "Costos".
END CASE.
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "B" + cColumn.
IF x-CodMon = 1
THEN chWorkSheet:Range(cRange):Value = "Importes en Nuevos Soles".
ELSE chWorkSheet:Range(cRange):Value = "Importes en Dolares Americanos".

t-Column = t-Column + 1.
cCaracter = 'B'.
cCaracter-2 = ''.
cColumn = STRING(t-Column).
DO iContador = 1 TO x-Cuenta-Clientes:
    IF ASC(cCaracter) + 2 > 90 THEN DO:
        cCaracter = CHR(ASC('A') - 1).
        IF cCaracter-2 = ''
        THEN cCaracter-2 = 'A'.
        ELSE cCaracter-2 = TRIM(CHR(ASC(cCaracter-2) + 1)).
    END.
    cCaracter = TRIM(CHR(ASC(cCaracter) + 2)).
    cRange = cCaracter-2 + cCaracter + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + STRING(iContador, '99').
END.

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
chWorkSheet:Columns("A"):ColumnWidth = 11.
chWorkSheet:Columns("B"):ColumnWidth = 40.
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Proveedor".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Nombre".
cCaracter = 'B'.
cCaracter-2 = ''.
DO iContador = 1 TO x-Cuenta-Clientes:
    IF ASC(cCaracter) + 1 > 90 THEN DO:
        cCaracter = CHR(ASC('A') - 1).
        IF cCaracter-2 = ''
        THEN cCaracter-2 = 'A'.
        ELSE cCaracter-2 = TRIM(CHR(ASC(cCaracter-2) + 1)).
    END.
    cCaracter = TRIM(CHR(ASC(cCaracter) + 1)).
    cRange = cCaracter-2 + cCaracter + cColumn.
    chWorkSheet:Range(cRange):Value = 'Pedido'.
    IF ASC(cCaracter) + 1 > 90 THEN DO:
        cCaracter = CHR(ASC('A') - 1).
        IF cCaracter-2 = ''
        THEN cCaracter-2 = 'A'.
        ELSE cCaracter-2 = TRIM(CHR(ASC(cCaracter-2) + 1)).
    END.
    cCaracter = TRIM(CHR(ASC(cCaracter) + 1)).
    cRange = cCaracter-2 + cCaracter + cColumn.
    chWorkSheet:Range(cRange):Value = 'Facturado'.
END.

FOR EACH Resumen ,
        FIRST GN-PROV NO-LOCK WHERE Gn-prov.codcia = pv-codcia
            AND Gn-prov.codpro = Resumen.codpro
            BY Resumen.CodPro:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Resumen.codpro.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = gn-prov.NomPro.
    cCaracter = 'B'.
    cCaracter-2 = ''.
    DO iContador = 1 TO x-Cuenta-Clientes:
        IF ASC(cCaracter) + 1 > 90 THEN DO:
            cCaracter = CHR(ASC('A') - 1).
            IF cCaracter-2 = ''
            THEN cCaracter-2 = 'A'.
            ELSE cCaracter-2 = TRIM(CHR(ASC(cCaracter-2) + 1)).
        END.
        cCaracter = TRIM(CHR(ASC(cCaracter) + 1)).
        cRange = cCaracter-2 + cCaracter + cColumn.
        chWorkSheet:Range(cRange):Value = Resumen.Pedido[iContador].
        IF ASC(cCaracter) + 1 > 90 THEN DO:
            cCaracter = CHR(ASC('A') - 1).
            IF cCaracter-2 = ''
            THEN cCaracter-2 = 'A'.
            ELSE cCaracter-2 = TRIM(CHR(ASC(cCaracter-2) + 1)).
        END.
        cCaracter = TRIM(CHR(ASC(cCaracter) + 1)).
        cRange = cCaracter-2 + cCaracter + cColumn.
        chWorkSheet:Range(cRange):Value = Resumen.Facturado[iContador].
    END.
END.

t-Column = t-Column + 3.
FOR EACH Gn-clie WHERE Gn-clie.codcia = cl-codcia 
        AND Gn-clie.venant <> '' BREAK BY Gn-clie.venant:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Gn-clie.venant.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Gn-clie.codcli.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = Gn-clie.nomcli.
END.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-3 W-Win 
PROCEDURE Excel-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Acumulamos */
DEFINE VARIABLE iContador               AS INTEGER.

FOR EACH Resumen:
    DELETE Resumen.
END.
FOR EACH Detalle BREAK BY Detalle.CodFam:
    IF FIRST-OF(Detalle.codfam) THEN DO:
        CREATE Resumen.
        ASSIGN
            Resumen.CodFam = Detalle.codfam.
    END.
    DO iContador = 1 TO x-Cuenta-Clientes:
        Resumen.Pedido[iContador] = Resumen.Pedido[iContador] + Detalle.Pedido[iContador].
        Resumen.Facturado[iContador] = Resumen.Facturado[iContador] + Detalle.Facturado[iContador].
    END.        
END.   
/* ************ */

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.
DEFINE VARIABLE cCaracter               AS CHARACTER.
DEFINE VARIABLE cCaracter-2             AS CHARACTER.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
cColumn = STRING(t-Column).
cRange = "B" + cColumn.
CASE x-Tipo-2:
    WHEN 'Cantidad' THEN chWorkSheet:Range(cRange):Value = "Cantidades".
    WHEN 'Venta' THEN chWorkSheet:Range(cRange):Value = "Ventas".
    WHEN 'Costo' THEN chWorkSheet:Range(cRange):Value = "Costos".
END CASE.
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "B" + cColumn.
IF x-CodMon = 1
THEN chWorkSheet:Range(cRange):Value = "Importes en Nuevos Soles".
ELSE chWorkSheet:Range(cRange):Value = "Importes en Dolares Americanos".

t-Column = t-Column + 1.
cCaracter = 'B'.
cCaracter-2 = ''.
cColumn = STRING(t-Column).
DO iContador = 1 TO x-Cuenta-Clientes:
    IF ASC(cCaracter) + 2 > 90 THEN DO:
        cCaracter = CHR(ASC('A') - 1).
        IF cCaracter-2 = ''
        THEN cCaracter-2 = 'A'.
        ELSE cCaracter-2 = TRIM(CHR(ASC(cCaracter-2) + 1)).
    END.
    cCaracter = TRIM(CHR(ASC(cCaracter) + 2)).
    cRange = cCaracter-2 + cCaracter + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + STRING(iContador, '99').
END.

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
chWorkSheet:Columns("A"):ColumnWidth = 11.
chWorkSheet:Columns("B"):ColumnWidth = 40.
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Linea".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion".
cCaracter = 'B'.
cCaracter-2 = ''.
DO iContador = 1 TO x-Cuenta-Clientes:
    IF ASC(cCaracter) + 1 > 90 THEN DO:
        cCaracter = CHR(ASC('A') - 1).
        IF cCaracter-2 = ''
        THEN cCaracter-2 = 'A'.
        ELSE cCaracter-2 = TRIM(CHR(ASC(cCaracter-2) + 1)).
    END.
    cCaracter = TRIM(CHR(ASC(cCaracter) + 1)).
    cRange = cCaracter-2 + cCaracter + cColumn.
    chWorkSheet:Range(cRange):Value = 'Pedido'.
    IF ASC(cCaracter) + 1 > 90 THEN DO:
        cCaracter = CHR(ASC('A') - 1).
        IF cCaracter-2 = ''
        THEN cCaracter-2 = 'A'.
        ELSE cCaracter-2 = TRIM(CHR(ASC(cCaracter-2) + 1)).
    END.
    cCaracter = TRIM(CHR(ASC(cCaracter) + 1)).
    cRange = cCaracter-2 + cCaracter + cColumn.
    chWorkSheet:Range(cRange):Value = 'Facturado'.
END.

FOR EACH Resumen, 
        FIRST AlmTFami WHERE Almtfami.codcia = s-codcia
            AND Almtfami.codfam = Resumen.codfam BY Resumen.CodFam:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Resumen.codfam.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = Almtfami.desfam.
    cCaracter = 'B'.
    cCaracter-2 = ''.
    DO iContador = 1 TO x-Cuenta-Clientes:
        IF ASC(cCaracter) + 1 > 90 THEN DO:
            cCaracter = CHR(ASC('A') - 1).
            IF cCaracter-2 = ''
            THEN cCaracter-2 = 'A'.
            ELSE cCaracter-2 = TRIM(CHR(ASC(cCaracter-2) + 1)).
        END.
        cCaracter = TRIM(CHR(ASC(cCaracter) + 1)).
        cRange = cCaracter-2 + cCaracter + cColumn.
        chWorkSheet:Range(cRange):Value = Resumen.Pedido[iContador].
        IF ASC(cCaracter) + 1 > 90 THEN DO:
            cCaracter = CHR(ASC('A') - 1).
            IF cCaracter-2 = ''
            THEN cCaracter-2 = 'A'.
            ELSE cCaracter-2 = TRIM(CHR(ASC(cCaracter-2) + 1)).
        END.
        cCaracter = TRIM(CHR(ASC(cCaracter) + 1)).
        cRange = cCaracter-2 + cCaracter + cColumn.
        chWorkSheet:Range(cRange):Value = Resumen.Facturado[iContador].
    END.
END.

t-Column = t-Column + 3.
FOR EACH Gn-clie WHERE Gn-clie.codcia = cl-codcia 
        AND Gn-clie.venant <> '' BREAK BY Gn-clie.venant:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Gn-clie.venant.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Gn-clie.codcli.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = Gn-clie.nomcli.
END.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  txt-msj:VISIBLE IN FRAME {&FRAME-NAME} = YES.
  RUN Carga-Temporal.
  
  CASE x-Tipo-1:
    WHEN 'Proveedor - Articulo' THEN RUN Excel-1.
    WHEN 'Resumen - Proveedor' THEN RUN Excel-2.
    WHEN 'Resumen - Linea' THEN RUN Excel-3.
  END CASE.
    
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
  
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH GN-DIVI WHERE GN-DIVI.codcia = s-codcia NO-LOCK:
        x-CodDiv:ADD-LAST(GN-DIVI.coddiv).
    END.
    x-coddiv = s-coddiv.
    FOR EACH Almtfami WHERE Almtfami.CodCia = s-codcia NO-LOCK:
        x-CodFam:ADD-LAST(Almtfami.codfam).
    END.
    ASSIGN
        x-Fecha-1 = TODAY - DAY(TODAY) + 1
        x-Fecha-2 = TODAY.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
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

