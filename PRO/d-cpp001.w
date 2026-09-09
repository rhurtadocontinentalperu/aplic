&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR s-Archivo AS CHAR NO-UNDO.
DEF VAR s-Ok AS LOG NO-UNDO.

DEF TEMP-TABLE DETALLE
    FIELD CodMat LIKE Almmmatg.codmat   COLUMN-LABEL 'Codigo'
    FIELD DesMat LIKE Almmmatg.desmat   COLUMN-LABEL 'Descripcion'
    FIELD DesMar LIKE Almmmatg.desmar   COLUMN-LABEL 'Marca'
    FIELD UndBas LIKE Almmmatg.undbas   COLUMN-LABEL 'Unidad'
    FIELD PreVta LIKE Almmmatg.prevta   COLUMN-LABEL 'Precio Lista'
    FIELD ProVta LIKE Pr-Mcpp.ProVta    COLUMN-LABEL 'Proyeccion!de Venta'
    FIELD VtaMes AS DEC EXTENT 6        COLUMN-LABEL 'Venta Mensual'
    FIELD VtaRef AS DEC                 COLUMN-LABEL 'Venta Referencial!Periodo Anterior'
    FIELD ProPro LIKE Pr-Mcpp.ProPro    COLUMN-LABEL 'Proyeccion!de Produccion'
    FIELD IngAlm AS DEC                 COLUMN-LABEL 'Ingreso!a almacen'
    FIELD StkAct AS DEC EXTENT 30       COLUMN-LABEL 'Stock Actual'
    FIELD ProVtaCan     LIKE Pr-Mcpp.ProVtaCan
    FIELD ProVtaCanA    LIKE Pr-Mcpp.ProVtaCan
    FIELD ProVtaCanAte  LIKE Pr-Mcpp.ProVtaCanAte
    FIELD ProVtaCanAteA LIKE Pr-Mcpp.ProVtaCanAte
    FIELD CanCot AS DEC                 COLUMN-LABEL 'Cotizadas'
    FIELD ValPro AS DEC                 COLUMN-LABEL 'Cto.Promedio US$'.

DEF TEMP-TABLE T-Clientes
    FIELD CodCli LIKE Gn-clie.codcli.
    
DEF VAR x-Almacenes AS CHAR NO-UNDO.     /* Stock Actual, el orden importa */
x-Almacenes = '03,03a,04,04a,05,05a,83b,19,11,22,130,131,15,16,22a,152,30,40,41,42,35,20,18,17'.

DEF VAR cl-codcia AS INT NO-UNDO.
FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-Periodo x-Periodo-1 x-NroMes-1 x-Periodo-2 ~
x-NroMes-2 x-TpoCmb x-VtaRef-1 x-VtaRef-2 x-IngAlm-1 x-IngAlm-2 x-FchCot-1 ~
x-FchCot-2 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS x-Periodo x-Periodo-1 x-NroMes-1 ~
x-Periodo-2 x-NroMes-2 x-TpoCmb x-VtaRef-1 x-VtaRef-2 x-IngAlm-1 x-IngAlm-2 ~
x-FchCot-1 x-FchCot-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE VARIABLE x-NroMes-1 AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Desde el mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "01","02","03","04","05","06","07","08","09","10","11","12" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE x-NroMes-2 AS INTEGER FORMAT "99":U INITIAL 4 
     LABEL "Hasta el mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "01","02","03","04","05","06","07","08","09","10","11","12" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE x-FchCot-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Fecha de Cotizaciones desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchCot-2 AS DATE FORMAT "99/99/99":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-IngAlm-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Ingresos a almacen desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-IngAlm-2 AS DATE FORMAT "99/99/99":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo del Maestro" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE x-Periodo-1 AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Desde el periodo" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE x-Periodo-2 AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Hasta el periodo" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE x-TpoCmb AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Tipo de cambio" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-VtaRef-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Venta Referencial desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-VtaRef-2 AS DATE FORMAT "99/99/99":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     x-Periodo AT ROW 1.58 COL 24 COLON-ALIGNED
     x-Periodo-1 AT ROW 2.54 COL 24 COLON-ALIGNED
     x-NroMes-1 AT ROW 2.54 COL 43 COLON-ALIGNED
     x-Periodo-2 AT ROW 3.5 COL 24 COLON-ALIGNED
     x-NroMes-2 AT ROW 3.5 COL 43 COLON-ALIGNED
     x-TpoCmb AT ROW 4.46 COL 24 COLON-ALIGNED
     x-VtaRef-1 AT ROW 5.62 COL 24 COLON-ALIGNED
     x-VtaRef-2 AT ROW 5.62 COL 43 COLON-ALIGNED
     x-IngAlm-1 AT ROW 6.58 COL 24 COLON-ALIGNED
     x-IngAlm-2 AT ROW 6.58 COL 43 COLON-ALIGNED
     x-FchCot-1 AT ROW 7.54 COL 24 COLON-ALIGNED
     x-FchCot-2 AT ROW 7.54 COL 43 COLON-ALIGNED
     Btn_OK AT ROW 9.08 COL 6
     Btn_Cancel AT ROW 9.08 COL 19
     SPACE(34.13) SKIP(1.10)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "REPORTE DE CONTROL DE PRODUCTOS PROPIOS".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* REPORTE DE CONTROL DE PRODUCTOS PROPIOS */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN
    x-NroMes-1 x-NroMes-2 x-Periodo x-Periodo-1 x-Periodo-2
    x-IngAlm-1 x-IngAlm-2 x-VtaRef-1 x-VtaRef-2
    x-FchCot-1 x-FchCot-2
    x-TpoCmb.
  IF x-TpoCmb <= 0 THEN DO:
    MESSAGE 'Ingrese el tipo de cambio' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Periodo D-Dialog
ON LEAVE OF x-Periodo IN FRAME D-Dialog /* Periodo del Maestro */
DO:
  ASSIGN
    x-Periodo-1:SCREEN-VALUE = SELF:SCREEN-VALUE
    x-Periodo-2:SCREEN-VALUE = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Acumula-Cotizaciones D-Dialog 
PROCEDURE Acumula-Cotizaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
        /*AND Faccpedi.coddiv = s-coddiv*/
        AND Faccpedi.coddiv = '00015'     /* OJO SOLO EXPO */
        AND Faccpedi.coddoc = 'COT'
        AND Faccpedi.fchped >= x-FchCot-1
        AND Faccpedi.fchped <= x-FchCot-2
        AND Faccpedi.flgest <> 'A':

/*    FIND T-Clientes WHERE T-Clientes.codcli = Faccpedi.codcli NO-LOCK NO-ERROR.
 *     IF NOT AVAILABLE T-Clientes THEN NEXT.*/
    FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia
            AND Gn-clie.codcli = Faccpedi.codcli
            NO-LOCK NO-ERROR.
/*    IF NOT AVAILABLE Gn-clie OR LOOKUP(TRIM(Gn-clie.canal), '0005,0007') = 0
 *     THEN NEXT.*/

    FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.codmat = Pr-Mcpp.codmat:
        DETALLE.CanCot = DETALLE.CanCot + (Facdpedi.canped * Facdpedi.factor).
    END.
  END.
          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-temporal D-Dialog 
PROCEDURE Carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-NroFch-1 AS INT NO-UNDO.
  DEF VAR x-NroFch-2 AS INT NO-UNDO.
  DEF VAR x-NroMes AS INT NO-UNDO.
  
  DEF VAR x-NroFch AS INT EXTENT 6 NO-UNDO.     /* 6 es el tope */
  DEF VAR j AS INT NO-UNDO.
  DEF VAR i AS INT NO-UNDO.
  DEF VAR X-CODANO AS INTEGER NO-UNDO.
  DEF VAR X-CODMES AS INTEGER NO-UNDO.
  DEF VAR X-FECHA  AS DATE NO-UNDO.

  FOR EACH DETALLE:
    DELETE DETALLE.
  END.
  FOR EACH T-Clientes:
    DELETE T-Clientes.
  END.

  FOR EACH Gn-clie WHERE Gn-clie.codcia = cl-codcia 
        AND Gn-clie.venant <> '':
    CREATE T-Clientes.
    ASSIGN
        T-Clientes.codcli = Gn-clie.codcli.
  END.
  
  FOR EACH Pr-MCpp WHERE Pr-Mcpp.CodCia = s-codcia 
        AND Pr-Mcpp.Periodo = x-Periodo NO-LOCK,
        FIRST Almmmatg OF Pr-Mcpp NO-LOCK:
    DISPLAY 
        Almmmatg.codmat LABEL 'Codigo'
        WITH SIDE-LABELS OVERLAY CENTERED VIEW-AS DIALOG-BOX TITLE 'Procesando'
            FRAME f-Mensaje.
    /* cargamos la informacion ya registrada */
    CREATE DETALLE.
    BUFFER-COPY Almmmatg TO DETALLE.
    BUFFER-COPY Pr-Mcpp  TO DETALLE.
    /* Ventas Mensuales */
    ASSIGN
        x-NroMes = 0
        x-NroFch-1 = x-Periodo-1 * 100 + x-NroMes-1
        x-NroFch-2 = x-Periodo-2 * 100 + x-NroMes-2.
    i = 0.
    DO j = x-NroFch-1 TO x-NroFch-2:
        i = i + 1.
        IF i <= 6 THEN x-NroFch[i] = j.
    END.
    IF i > 6 THEN i = 6.
    DO x-NroMes = 1 TO i:
        FOR EACH GN-DIVI NO-LOCK WHERE GN-DIVI.codcia = s-codcia:
            FOR EACH EvtArti WHERE EvtArti.CodCia = s-codcia
                    AND EvtArti.codmat = Pr-Mcpp.codmat
                    AND EvtArti.coddiv = GN-DIVI.coddiv
                    AND EvtArti.Nrofch = x-NroFch[x-NroMes] NO-LOCK:
                ASSIGN
                    DETALLE.VtaMes[x-NroMes] = DETALLE.VtaMes[x-NroMes] + EvtArti.CanxMes.
            END.            
        END.            
    END.
    /* Ventas Referencial */
    ASSIGN
        x-NroFch-1 = YEAR(x-VtaRef-1) * 100 + MONTH(x-VtaRef-1)
        x-NroFch-2 = YEAR(x-VtaRef-2) * 100 + MONTH(x-VtaRef-2).
    FOR EACH GN-DIVI NO-LOCK WHERE GN-DIVI.codcia = s-codcia:
        FOR EACH EvtArti WHERE EvtArti.CodCia = s-codcia
                AND EvtArti.codmat = Pr-Mcpp.codmat
                AND EvtArti.coddiv = GN-DIVI.coddiv
                AND EvtArti.Nrofch >= x-NroFch-1
                AND EvtArti.Nrofch <= x-NroFch-2 NO-LOCK:
            /*****************Capturando el Mes siguiente *******************/
            IF Evtarti.Codmes < 12 THEN DO:
              ASSIGN
                  X-CODMES = Evtarti.Codmes + 1
                  X-CODANO = Evtarti.Codano.
            END.
            ELSE DO: 
              ASSIGN
                  X-CODMES = 01
                  X-CODANO = Evtarti.Codano + 1.
            END.
            /*********************** Calculo Para Obtener los datos diarios ************/
             DO I = 1 TO DAY( DATE("01" + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
                  X-FECHA = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")).
                  IF X-FECHA >= x-VtaRef-1 AND X-FECHA <= x-VtaRef-2 THEN DO:
                        DETALLE.VtaRef = DETALLE.VtaRef + Evtarti.CanxDia[I].
                  END.
             END.         
        END.            
    END.            
/*    ASSIGN
 *         x-NroFch-1 = x-NroFch-1 - 100
 *         x-NroFch-2 = x-NroFch-2 - 100.
 *     i = 0.
 *     DO j = x-NroFch-1 TO x-NroFch-2:
 *         i = i + 1.
 *         IF i <= 6 THEN x-NroFch[i] = j.
 *     END.
 *     IF i > 6 THEN i = 6.
 *     DO x-NroMes = 1 TO i:
 *         FOR EACH GN-DIVI NO-LOCK WHERE GN-DIVI.codcia = s-codcia:
 *             FOR EACH EvtArti WHERE EvtArti.CodCia = s-codcia
 *                     AND EvtArti.codmat = Pr-Mcpp.codmat
 *                     AND EvtArti.coddiv = GN-DIVI.coddiv
 *                     AND EvtArti.Nrofch = x-NroFch[x-NroMes] NO-LOCK:
 *                 ASSIGN
 *                     DETALLE.VtaRef = DETALLE.VtaRef + EvtArti.CanxMes.
 *             END.            
 *         END.            
 *     END.*/
    /* Ingresos de Productos Terminados */
    RUN Produccion.
/*    ASSIGN
 *         x-FchDoc-1 = DATE(x-NroMes-1,01,x-Periodo-1).
 *     RUN bin/_dateif(x-NroMes-2, x-Periodo-2, OUTPUT x-Fecha, OUTPUT x-FchDoc-2).        
 *     FOR EACH Almdmov WHERE Almdmov.codcia = s-codcia
 *             AND Almdmov.codalm = '12'
 *             AND Almdmov.codmat = Pr-Mcpp.codmat
 *             AND LOOKUP(TRIM(Almdmov.almori), '11,22') > 0
 *             AND Almdmov.tipmov = 'S'
 *             AND Almdmov.codmov = 03     /* Transferencia */
 *             AND Almdmov.fchdoc >= x-FchDoc-1
 *             AND Almdmov.fchdoc <= x-FchDoc-2
 *             NO-LOCK:
 *         DETALLE.IngAlm = DETALLE.IngAlm + Almdmov.candes.
 *     END.*/
    /* Stock Actual por Almacen */
    DEF VAR x-Cuenta    AS INT  NO-UNDO.
    DO x-Cuenta = 1 TO NUM-ENTRIES(x-Almacenes):
        FIND Almmmate WHERE Almmmate.codcia = s-codcia
            AND Almmmate.codalm = ENTRY(x-Cuenta, x-Almacenes)
            AND Almmmate.codmat = Pr-Mcpp.codmat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DETALLE.StkAct[x-Cuenta] = Almmmate.stkact.
    END.
    /* Acumulado de ventas por division */
    ASSIGN
        x-NroFch-1 = x-Periodo-1 * 100 + x-NroMes-1
        x-NroFch-2 = x-Periodo-2 * 100 + x-NroMes-2.
    FOR EACH GN-DIVI NO-LOCK WHERE GN-DIVI.codcia = s-codcia:
        FOR EACH EvtArti WHERE EvtArti.CodCia = s-codcia
                AND EvtArti.codmat = Pr-Mcpp.codmat 
                AND EvtArti.coddiv = GN-DIVI.coddiv
                AND EvtArti.Nrofch >= x-NroFch-1
                AND EvtArti.NroFch <= x-NroFch-2 NO-LOCK:
            CASE EvtArti.CodDiv:
                WHEN '00001' THEN DETALLE.ProVtaCanA[1] = DETALLE.ProVtaCanA[1] + EvtArti.CanxMes.
                WHEN '00002' THEN DETALLE.ProVtaCanA[2] = DETALLE.ProVtaCanA[2] + EvtArti.CanxMes.
                WHEN '00003' THEN DETALLE.ProVtaCanA[3] = DETALLE.ProVtaCanA[3] + EvtArti.CanxMes.
                WHEN '00014' THEN DETALLE.ProVtaCanA[14] = DETALLE.ProVtaCanA[14] + EvtArti.CanxMes.
                WHEN '00008' THEN DETALLE.ProVtaCanA[8] = DETALLE.ProVtaCanA[8] + EvtArti.CanxMes.
                WHEN '00012' THEN DETALLE.ProVtaCanA[12] = DETALLE.ProVtaCanA[12] + EvtArti.CanxMes.
                WHEN '00005' THEN DETALLE.ProVtaCanA[5] = DETALLE.ProVtaCanA[5] + EvtArti.CanxMes.
                WHEN '00011' THEN DETALLE.ProVtaCanA[11] = DETALLE.ProVtaCanA[11] + EvtArti.CanxMes.
                WHEN '00016' THEN DETALLE.ProVtaCanA[16] = DETALLE.ProVtaCanA[16] + EvtArti.CanxMes.
                WHEN '00015' THEN DETALLE.ProVtaCanA[15] = DETALLE.ProVtaCanA[15] + EvtArti.CanxMes.
            END CASE.
        END.            
    END.
    /* Acumulado por Canal */
    FOR EACH Evtclarti NO-LOCK WHERE Evtclarti.CodCia = S-CODCIA
            AND Evtclarti.CodDiv = '00000'      /* ATE */
            AND Evtclarti.Codmat = Pr-Mcpp.codmat
            AND Evtclarti.Nrofch >= x-NroFch-1
            AND Evtclarti.Nrofch <= x-NroFch-2,
            FIRST Gn-clie WHERE Gn-clie.codcia = cl-codcia
                AND Gn-clie.codcli = Evtclarti.codcli NO-LOCK:
        CASE Gn-clie.canal:
            WHEN '0005' OR WHEN '0007' THEN DETALLE.ProVtaCanAteA[1] = DETALLE.ProVtaCanAteA[1] + EvtClArti.CanxMes.
            WHEN '0008' THEN DETALLE.ProVtaCanAteA[2] = DETALLE.ProVtaCanAteA[2] + EvtClArti.CanxMes.
            WHEN '0003' THEN DETALLE.ProVtaCanAteA[3] = DETALLE.ProVtaCanAteA[3] + EvtClArti.CanxMes.
            WHEN '0001' THEN DETALLE.ProVtaCanAteA[4] = DETALLE.ProVtaCanAteA[4] + EvtClArti.CanxMes.
            OTHERWISE DETALLE.ProVtaCanAteA[10] = DETALLE.ProVtaCanAteA[10] + EvtClArti.CanxMes.
        END CASE.
    END.
    /* Acumulamos cotizaciones clientes VIP */
    RUN Acumula-Cotizaciones.
    /* Valor Promedio en US$ */
/*    FIND LAST Almstkge WHERE Almstkge.codcia = s-codcia
 *         AND Almstkge.codmat = Pr-Mcpp.codmat
 *         NO-LOCK NO-ERROR.
 *     IF AVAILABLE Almstkge 
 *     THEN Detalle.ValPro = AlmStkge.CtoUni / x-TpoCmb.*/
    /* ********************* */
    Detalle.ValPro = Almmmatg.CtoTot.
    IF Almmmatg.MonVta = 1 THEN Detalle.ValPro / x-TpoCmb.
  END.
  HIDE FRAME f-Mensaje.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY x-Periodo x-Periodo-1 x-NroMes-1 x-Periodo-2 x-NroMes-2 x-TpoCmb 
          x-VtaRef-1 x-VtaRef-2 x-IngAlm-1 x-IngAlm-2 x-FchCot-1 x-FchCot-2 
      WITH FRAME D-Dialog.
  ENABLE x-Periodo x-Periodo-1 x-NroMes-1 x-Periodo-2 x-NroMes-2 x-TpoCmb 
         x-VtaRef-1 x-VtaRef-2 x-IngAlm-1 x-IngAlm-2 x-FchCot-1 x-FchCot-2 
         Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel D-Dialog 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-VtaMes AS DEC NO-UNDO.
DEF VAR x-StkAct AS DEC NO-UNDO.

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 5.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 10.
chWorkSheet:Columns("B"):ColumnWidth = 35.
chWorkSheet:Columns("C"):ColumnWidth = 15.
chWorkSheet:Columns("D"):ColumnWidth = 5.
chWorkSheet:Columns("E"):ColumnWidth = 10.
chWorkSheet:Columns("F"):ColumnWidth = 10.
chWorkSheet:Columns("G"):ColumnWidth = 10.
chWorkSheet:Columns("H"):ColumnWidth = 10.
chWorkSheet:Columns("I"):ColumnWidth = 10.
chWorkSheet:Columns("J"):ColumnWidth = 10.
chWorkSheet:Columns("K"):ColumnWidth = 10.
chWorkSheet:Columns("L"):ColumnWidth = 10.
chWorkSheet:Columns("M"):ColumnWidth = 10.
chWorkSheet:Columns("N"):ColumnWidth = 10.
chWorkSheet:Columns("O"):ColumnWidth = 10.
chWorkSheet:Columns("P"):ColumnWidth = 10.
chWorkSheet:Columns("Q"):ColumnWidth = 10.
chWorkSheet:Columns("R"):ColumnWidth = 10.
chWorkSheet:Columns("S"):ColumnWidth = 10.
chWorkSheet:Columns("T"):ColumnWidth = 10.
chWorkSheet:Columns("U"):ColumnWidth = 10.
chWorkSheet:Columns("V"):ColumnWidth = 10.
chWorkSheet:Columns("W"):ColumnWidth = 10.
chWorkSheet:Columns("X"):ColumnWidth = 10.
chWorkSheet:Columns("Y"):ColumnWidth = 10.
chWorkSheet:Columns("Z"):ColumnWidth = 10.
chWorkSheet:Columns("AA"):ColumnWidth = 10.
chWorkSheet:Columns("AB"):ColumnWidth = 10.
chWorkSheet:Columns("AC"):ColumnWidth = 10.
chWorkSheet:Columns("AD"):ColumnWidth = 10.
chWorkSheet:Columns("AE"):ColumnWidth = 10.
chWorkSheet:Columns("AF"):ColumnWidth = 10.
chWorkSheet:Columns("AG"):ColumnWidth = 10.
chWorkSheet:Columns("AH"):ColumnWidth = 10.
chWorkSheet:Columns("AI"):ColumnWidth = 10.
chWorkSheet:Columns("AJ"):ColumnWidth = 10.
chWorkSheet:Columns("AK"):ColumnWidth = 10.
chWorkSheet:Columns("AL"):ColumnWidth = 10.
chWorkSheet:Columns("AM"):ColumnWidth = 10.
chWorkSheet:Columns("AN"):ColumnWidth = 10.
chWorkSheet:Columns("AO"):ColumnWidth = 10.
chWorkSheet:Columns("AP"):ColumnWidth = 10.
chWorkSheet:Columns("AQ"):ColumnWidth = 10.
chWorkSheet:Columns("AR"):ColumnWidth = 10.
chWorkSheet:Columns("AS"):ColumnWidth = 10.
chWorkSheet:Columns("AT"):ColumnWidth = 10.
chWorkSheet:Columns("AU"):ColumnWidth = 10.
chWorkSheet:Columns("AV"):ColumnWidth = 10.
chWorkSheet:Columns("AW"):ColumnWidth = 10.
chWorkSheet:Columns("AX"):ColumnWidth = 10.
chWorkSheet:Columns("AY"):ColumnWidth = 10.
chWorkSheet:Columns("AZ"):ColumnWidth = 10.
chWorkSheet:Columns("BA"):ColumnWidth = 10.
chWorkSheet:Columns("BB"):ColumnWidth = 10.
chWorkSheet:Columns("BC"):ColumnWidth = 10.
chWorkSheet:Columns("BD"):ColumnWidth = 10.
chWorkSheet:Columns("BE"):ColumnWidth = 10.
chWorkSheet:Columns("BF"):ColumnWidth = 10.
chWorkSheet:Columns("BG"):ColumnWidth = 10.
chWorkSheet:Columns("BH"):ColumnWidth = 10.
chWorkSheet:Columns("BI"):ColumnWidth = 10.
chWorkSheet:Columns("BJ"):ColumnWidth = 10.
chWorkSheet:Columns("BK"):ColumnWidth = 10.
chWorkSheet:Columns("BL"):ColumnWidth = 10.

chWorkSheet:Range("A3"):Value = "Codigo".
chWorkSheet:Range("B3"):Value = "Descripcion".
chWorkSheet:Range("C3"):Value = "Marca".
chWorkSheet:Range("D3"):Value = "Unidad".
chWorkSheet:Range("E2"):Value = "Proyeccion".
chWorkSheet:Range("E3"):Value = "de Venta".
chWorkSheet:Range("F3"):Value = "M1".
chWorkSheet:Range("G3"):Value = "M2".
chWorkSheet:Range("H3"):Value = "M3".
chWorkSheet:Range("I3"):Value = "M4".
chWorkSheet:Range("J3"):Value = "M5".
chWorkSheet:Range("K3"):Value = "M6".
chWorkSheet:Range("L3"):Value = "Acumulado".
chWorkSheet:Range("M2"):Value = "Venta".
chWorkSheet:Range("M3"):Value = "Referencial".
chWorkSheet:Range("N2"):Value = "Proyeccion".
chWorkSheet:Range("N3"):Value = "de Produccion".
chWorkSheet:Range("O2"):Value = "Ingreso".
chWorkSheet:Range("O3"):Value = "a Almacen".

chWorkSheet:Range("P3"):Value = "'" + "03".
chWorkSheet:Range("Q3"):Value = "03A".
chWorkSheet:Range("R3"):Value = "'" + "04".
chWorkSheet:Range("S3"):Value = "04A".
chWorkSheet:Range("T3"):Value = "'" + "05".
chWorkSheet:Range("U3"):Value = "05A".
chWorkSheet:Range("V3"):Value = "83B".
chWorkSheet:Range("W3"):Value = "'" + "19".
chWorkSheet:Range("X3"):Value = "'" + "11".
chWorkSheet:Range("Y3"):Value = "'" + "22".
chWorkSheet:Range("Z3"):Value = "'" + "130".
chWorkSheet:Range("AA3"):Value = "'" + "131".
chWorkSheet:Range("AB3"):Value = "'" + "15".
chWorkSheet:Range("AC3"):Value = "'" + "16".
chWorkSheet:Range("AD3"):Value = "'" + "22A".
chWorkSheet:Range("AE3"):Value = "'" + "152".
chWorkSheet:Range("AF3"):Value = "'" + "30".
chWorkSheet:Range("AG2"):Value = "Total".
chWorkSheet:Range("AG3"):Value = "Stock".

chWorkSheet:Range("AH1"):Value = "Proy".
chWorkSheet:Range("AH2"):Value = "Venta".
chWorkSheet:Range("AH3"):Value = "'" + "00001".
chWorkSheet:Range("AI1"):Value = "Acum".
chWorkSheet:Range("AI2"):Value = "Venta".
chWorkSheet:Range("AI3"):Value = "'" + "00001".
chWorkSheet:Range("AJ1"):Value = "Proy".
chWorkSheet:Range("AJ2"):Value = "Venta".
chWorkSheet:Range("AJ3"):Value = "'" + "00002".
chWorkSheet:Range("AK1"):Value = "Acum".
chWorkSheet:Range("AK2"):Value = "Venta".
chWorkSheet:Range("AK3"):Value = "'" + "00002".
chWorkSheet:Range("AL1"):Value = "Proy".
chWorkSheet:Range("AL2"):Value = "Venta".
chWorkSheet:Range("AL3"):Value = "'" + "00003".
chWorkSheet:Range("AM1"):Value = "Acum".
chWorkSheet:Range("AM2"):Value = "Venta".
chWorkSheet:Range("AM3"):Value = "'" + "00003".
chWorkSheet:Range("AN1"):Value = "Proy".
chWorkSheet:Range("AN2"):Value = "Venta".
chWorkSheet:Range("AN3"):Value = "'" + "00014".
chWorkSheet:Range("AO1"):Value = "Acum".
chWorkSheet:Range("AO2"):Value = "Venta".
chWorkSheet:Range("AO3"):Value = "'" + "00014".
chWorkSheet:Range("AP1"):Value = "Proy".
chWorkSheet:Range("AP2"):Value = "Venta".
chWorkSheet:Range("AP3"):Value = "'" + "00008".
chWorkSheet:Range("AQ1"):Value = "Acum".
chWorkSheet:Range("AQ2"):Value = "Venta".
chWorkSheet:Range("AQ3"):Value = "'" + "00008".
chWorkSheet:Range("AR1"):Value = "Proy Vta".
chWorkSheet:Range("AR2"):Value = "'" + "00000".
chWorkSheet:Range("AR3"):Value = "Provi".
chWorkSheet:Range("AS1"):Value = "Acum Vta".
chWorkSheet:Range("AS2"):Value = "'" + "00000".
chWorkSheet:Range("AS3"):Value = "Provi".
chWorkSheet:Range("AT1"):Value = "Proy Vta".
chWorkSheet:Range("AT2"):Value = "'" + "00000".
chWorkSheet:Range("AT3"):Value = "Auto".
chWorkSheet:Range("AU1"):Value = "Acum Vta".
chWorkSheet:Range("AU2"):Value = "'" + "00000".
chWorkSheet:Range("AU3"):Value = "Auto".
chWorkSheet:Range("AV1"):Value = "Proy Vta".
chWorkSheet:Range("AV2"):Value = "'" + "00000".
chWorkSheet:Range("AV3"):Value = "Oficin".
chWorkSheet:Range("AW1"):Value = "Acum Vta".
chWorkSheet:Range("AW2"):Value = "'" + "00000".
chWorkSheet:Range("AW3"):Value = "Oficin".
chWorkSheet:Range("AX1"):Value = "Proy Vta".
chWorkSheet:Range("AX2"):Value = "'" + "00000".
chWorkSheet:Range("AX3"):Value = "Estata".
chWorkSheet:Range("AY1"):Value = "Acum Vta".
chWorkSheet:Range("AY2"):Value = "'" + "00000".
chWorkSheet:Range("AY3"):Value = "Estata".
chWorkSheet:Range("AZ1"):Value = "Proy Vta".
chWorkSheet:Range("AZ2"):Value = "'" + "00000".
chWorkSheet:Range("AZ3"):Value = "Varios".
chWorkSheet:Range("BA1"):Value = "Acum Vta".
chWorkSheet:Range("BA2"):Value = "'" + "00000".
chWorkSheet:Range("BA3"):Value = "Varios".

chWorkSheet:Range("BB1"):Value = "Proy".
chWorkSheet:Range("BB2"):Value = "Venta".
chWorkSheet:Range("BB3"):Value = "'" + "00012".
chWorkSheet:Range("BC1"):Value = "Acum".
chWorkSheet:Range("BC2"):Value = "Venta".
chWorkSheet:Range("BC3"):Value = "'" + "00012".
chWorkSheet:Range("BD1"):Value = "Proy".
chWorkSheet:Range("BD2"):Value = "Venta".
chWorkSheet:Range("BD3"):Value = "'" + "00005".
chWorkSheet:Range("BE1"):Value = "Acum".
chWorkSheet:Range("BE2"):Value = "Venta".
chWorkSheet:Range("BE3"):Value = "'" + "00005".
chWorkSheet:Range("BF1"):Value = "Proy".
chWorkSheet:Range("BF2"):Value = "Venta".
chWorkSheet:Range("BF3"):Value = "'" + "00011".
chWorkSheet:Range("BG1"):Value = "Acum".
chWorkSheet:Range("BG2"):Value = "Venta".
chWorkSheet:Range("BG3"):Value = "'" + "00011".
chWorkSheet:Range("BH1"):Value = "Proy".
chWorkSheet:Range("BH2"):Value = "Venta".
chWorkSheet:Range("BH3"):Value = "'" + "00016".
chWorkSheet:Range("BI1"):Value = "Acum".
chWorkSheet:Range("BI2"):Value = "Venta".
chWorkSheet:Range("BI3"):Value = "'" + "00016".
chWorkSheet:Range("BJ1"):Value = "Proy".
chWorkSheet:Range("BJ2"):Value = "Venta".
chWorkSheet:Range("BJ3"):Value = "'" + "00015".
chWorkSheet:Range("BK1"):Value = "Acum".
chWorkSheet:Range("BK2"):Value = "Venta".
chWorkSheet:Range("BL3"):Value = "'" + "00015".
chWorkSheet:Range("BL3"):Value = "Cotizaciones".
chWorkSheet:Range("BM3"):Value = "Precio Lista".
chWorkSheet:Range("BN3"):Value = "Costo Unitario US$".

chWorkSheet:Range("BO3"):Value = "'" + "Stock".
chWorkSheet:Range("BO3"):Value = "'" + "40".
chWorkSheet:Range("BP3"):Value = "'" + "Stock".
chWorkSheet:Range("BP3"):Value = "'" + "41".
chWorkSheet:Range("BQ3"):Value = "'" + "Stock".
chWorkSheet:Range("BQ3"):Value = "'" + "42".
chWorkSheet:Range("BR3"):Value = "'" + "Stock".
chWorkSheet:Range("BR3"):Value = "'" + "35".
chWorkSheet:Range("BS3"):Value = "'" + "Stock".
chWorkSheet:Range("BS3"):Value = "'" + "20".
chWorkSheet:Range("BT3"):Value = "'" + "Stock".
chWorkSheet:Range("BT3"):Value = "'" + "18".
chWorkSheet:Range("BU3"):Value = "'" + "Stock".
chWorkSheet:Range("BU3"):Value = "'" + "17".

FOR EACH DETALLE:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + DETALLE.codmat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.desmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.desmar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.undbas.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVta.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.VtaMes[1].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.VtaMes[2].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.VtaMes[3].
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.VtaMes[4].
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.VtaMes[5].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.VtaMes[6].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = x-VtaMes.
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.VtaRef.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProPro.
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.IngAlm.

    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[1].
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[2].
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[3].
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[4].
    cRange = "T" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[5].
    cRange = "U" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[6].
    cRange = "V" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[7].
    cRange = "W" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[8].
    cRange = "X" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[9].
    cRange = "Y" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[10].
    cRange = "Z" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[11].
    cRange = "AA" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[12].
    cRange = "AB" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[13].
    cRange = "AC" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[14].
    cRange = "AD" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[15].
    cRange = "AE" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[16].
    cRange = "AF" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[17].

    cRange = "AG" + cColumn.
    chWorkSheet:Range(cRange):Value = x-StkAct.
    cRange = "AH" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCan[1].
    cRange = "AI" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCanA[1].
    cRange = "AJ" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCan[2].
    cRange = "AK" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCanA[2].
    cRange = "AL" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCan[3].
    cRange = "AM" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCanA[3].
    cRange = "AN" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCan[14].
    cRange = "AO" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCanA[14].
    cRange = "AP" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCan[8].
    cRange = "AQ" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCanA[8].

    cRange = "AR" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCanAte[1].
    cRange = "AS" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCanAteA[1].
    cRange = "AT" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCanAte[2].
    cRange = "AU" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCanAteA[2].
    cRange = "AV" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCanAte[3].
    cRange = "AW" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCanAteA[3].
    cRange = "AX" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCanAte[4].
    cRange = "AY" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCanAteA[4].
    cRange = "AZ" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCanAte[10].
    cRange = "BA" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCanAteA[10].

    cRange = "BB" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCan[12].
    cRange = "BC" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCanA[12].
    cRange = "BD" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCan[5].
    cRange = "BE" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCanA[5].
    cRange = "BF" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCan[11].
    cRange = "BG" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCanA[11].
    cRange = "BH" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCan[16].
    cRange = "BI" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCanA[16].
    cRange = "BJ" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCan[15].
    cRange = "BK" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ProVtaCanA[15].
    cRange = "BL" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.CanCot.
    cRange = "BM" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.PreVta[1].
    cRange = "BN" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ValPro.

    cRange = "BO" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[18].
    cRange = "BP" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[19].
    cRange = "BQ" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[20].
    cRange = "BR" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[21].
    cRange = "BS" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[22].
    cRange = "BT" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[23].
    cRange = "BU" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.StkAct[24].
END.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato D-Dialog 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-VtaMes AS DEC NO-UNDO.
  DEF VAR x-StkAct AS DEC NO-UNDO.
  
  DEF FRAME F-DETALLE
    DETALLE.codmat      
    DETALLE.desmat      FORMAT 'x(35)'
    DETALLE.desmar      FORMAT 'x(20)'
    DETALLE.undbas      FORMAT 'x(6)'
    DETALLE.ProVta      FORMAT '>>>>>9'
    DETALLE.VtaMes[1]   FORMAT '>>>>>9'
    DETALLE.VtaMes[2]   FORMAT '>>>>>9'
    DETALLE.VtaMes[3]   FORMAT '>>>>>9'
    DETALLE.VtaMes[4]   FORMAT '>>>>>9'
    DETALLE.VtaMes[5]   FORMAT '>>>>>9'
    DETALLE.VtaMes[6]   FORMAT '>>>>>9'
    x-VtaMes            FORMAT '>>>>>9'     COLUMN-LABEL 'Acumulado!Mensual'
    DETALLE.VtaRef      FORMAT '>>>>>9'
    DETALLE.ProPro      FORMAT '>>>>>9'
    DETALLE.IngAlm      FORMAT '>>>>>9'

    DETALLE.StkAct[1]   FORMAT '>>>>>9'     COLUMN-LABEL '03'
    DETALLE.StkAct[2]   FORMAT '>>>>>9'     COLUMN-LABEL '03A'
    DETALLE.StkAct[3]   FORMAT '>>>>>9'     COLUMN-LABEL '04'
    DETALLE.StkAct[4]   FORMAT '>>>>>9'     COLUMN-LABEL '04A'
    DETALLE.StkAct[5]   FORMAT '>>>>>9'     COLUMN-LABEL '05'
    DETALLE.StkAct[6]   FORMAT '>>>>>9'     COLUMN-LABEL '05A'
    DETALLE.StkAct[7]   FORMAT '>>>>>9'     COLUMN-LABEL '83B'
    DETALLE.StkAct[8]   FORMAT '>>>>>9'     COLUMN-LABEL '19'
    DETALLE.StkAct[9]   FORMAT '>>>>>9'     COLUMN-LABEL '11'
    DETALLE.StkAct[10]   FORMAT '>>>>>9'     COLUMN-LABEL '22'
    DETALLE.StkAct[11]   FORMAT '>>>>>9'     COLUMN-LABEL '130'
    DETALLE.StkAct[12]   FORMAT '>>>>>9'     COLUMN-LABEL '131'
    DETALLE.StkAct[13]   FORMAT '>>>>>9'     COLUMN-LABEL '15'
    DETALLE.StkAct[14]   FORMAT '>>>>>9'     COLUMN-LABEL '16'
    x-StkAct            FORMAT '>>>>>9'     COLUMN-LABEL 'Total!Stock'
    DETALLE.ProVtaCan[1]    FORMAT '>>>>9'  COLUMN-LABEL 'Proy!Venta!00001'    
    DETALLE.ProVtaCanA[1]   FORMAT '>>>>9'  COLUMN-LABEL 'Acum!Venta!00001'    
    DETALLE.ProVtaCan[2]    FORMAT '>>>>9'  COLUMN-LABEL 'Proy!Venta!00002'
    DETALLE.ProVtaCanA[2]   FORMAT '>>>>9'  COLUMN-LABEL 'Acum!Venta!00002'
    DETALLE.ProVtaCan[3]    FORMAT '>>>>9'  COLUMN-LABEL 'Proy!Venta!00003'
    DETALLE.ProVtaCanA[3]   FORMAT '>>>>9'  COLUMN-LABEL 'Acum!Venta!00003'
    DETALLE.ProVtaCan[14]    FORMAT '>>>>9'  COLUMN-LABEL 'Proy!Venta!00014'
    DETALLE.ProVtaCanA[14]   FORMAT '>>>>9'  COLUMN-LABEL 'Acum!Venta!00014'
    DETALLE.ProVtaCan[8]    FORMAT '>>>>9'  COLUMN-LABEL 'Proy!Venta!00008'
    DETALLE.ProVtaCanA[8]   FORMAT '>>>>9'  COLUMN-LABEL 'Acum!Venta!00008'

    DETALLE.ProVtaCanAte[1]     FORMAT '>>>>9'  COLUMN-LABEL 'Proy!Venta!00000!Provi'
    DETALLE.ProVtaCanAteA[1]    FORMAT '>>>>9'  COLUMN-LABEL 'Acum!Venta!00000!Provi'
    DETALLE.ProVtaCanAte[2]     FORMAT '>>>>9'  COLUMN-LABEL 'Proy!Venta!00000!Auto'
    DETALLE.ProVtaCanAteA[2]    FORMAT '>>>>9'  COLUMN-LABEL 'Acum!Venta!00000!Auto'
    DETALLE.ProVtaCanAte[3]     FORMAT '>>>>9'  COLUMN-LABEL 'Proy!Venta!00000!Oficin'
    DETALLE.ProVtaCanAteA[3]    FORMAT '>>>>9'  COLUMN-LABEL 'Acum!Venta!00000!Oficin'
    DETALLE.ProVtaCanAte[4]     FORMAT '>>>>9'  COLUMN-LABEL 'Proy!Venta!00000!Estata'
    DETALLE.ProVtaCanAteA[4]    FORMAT '>>>>9'  COLUMN-LABEL 'Acum!Venta!00000!Estata'
    DETALLE.ProVtaCanAte[10]     FORMAT '>>>>9'  COLUMN-LABEL 'Proy!Venta!00000!Vario'
    DETALLE.ProVtaCanAteA[10]    FORMAT '>>>>9'  COLUMN-LABEL 'Acum!Venta!00000!Vario'

    DETALLE.ProVtaCan[12]    FORMAT '>>>>9'  COLUMN-LABEL 'Proy!Venta!00012'
    DETALLE.ProVtaCanA[12]   FORMAT '>>>>9'  COLUMN-LABEL 'Acum!Venta!00012'
    DETALLE.ProVtaCan[5]    FORMAT '>>>>9'  COLUMN-LABEL 'Proy!Venta!00005'
    DETALLE.ProVtaCanA[5]   FORMAT '>>>>9'  COLUMN-LABEL 'Acum!Venta!00005'
    DETALLE.ProVtaCan[11]    FORMAT '>>>>9'  COLUMN-LABEL 'Proy!Venta!00011'
    DETALLE.ProVtaCanA[11]   FORMAT '>>>>9'  COLUMN-LABEL 'Acum!Venta!00011'
    DETALLE.ProVtaCan[16]    FORMAT '>>>>9'  COLUMN-LABEL 'Proy!Venta!00016'
    DETALLE.ProVtaCanA[16]   FORMAT '>>>>9'  COLUMN-LABEL 'Acum!Venta!00016'
    DETALLE.ProVtaCan[15]    FORMAT '>>>>9'  COLUMN-LABEL 'Proy!Venta!00015'
    DETALLE.ProVtaCanA[15]   FORMAT '>>>>9'  COLUMN-LABEL 'Acum!Venta!00015'
    WITH STREAM-IO NO-BOX NO-LABELS WIDTH 320.

  OUTPUT TO VALUE(s-Archivo).
  FOR EACH DETALLE:
    x-VtaMes = DETALLE.VtaMes[1] + DETALLE.VtaMes[2] + DETALLE.VtaMes[3] + DETALLE.VtaMes[4] + DETALLE.VtaMes[5] + DETALLE.VtaMes[6].
    x-StkAct = DETALLE.StkAct[1] + DETALLE.StkAct[2] + DETALLE.StkAct[3] + DETALLE.StkAct[4] + DETALLE.StkAct[6] + DETALLE.StkAct[6] + 
                DETALLE.StkAct[7] + DETALLE.StkAct[8] + DETALLE.StkAct[9] + DETALLE.StkAct[10] + DETALLE.StkAct[11] + DETALLE.StkAct[12] + 
                DETALLE.StkAct[13] + DETALLE.StkAct[14].
    DISPLAY
        DETALLE.codmat      
        DETALLE.desmat      
        DETALLE.desmar      
        DETALLE.undbas      
        DETALLE.ProVta      
        DETALLE.VtaMes[1]   
        DETALLE.VtaMes[2]   
        DETALLE.VtaMes[3]   
        DETALLE.VtaMes[4]   
        DETALLE.VtaMes[5]   
        DETALLE.VtaMes[6]   
        x-VtaMes            
        DETALLE.VtaRef      
        DETALLE.ProPro      
        DETALLE.IngAlm      
    
        DETALLE.StkAct[1]   
        DETALLE.StkAct[2]   
        DETALLE.StkAct[3]   
        DETALLE.StkAct[4]   
        DETALLE.StkAct[5]   
        DETALLE.StkAct[6]   
        DETALLE.StkAct[7]   
        DETALLE.StkAct[8]   
        DETALLE.StkAct[9]   
        DETALLE.StkAct[10]  
        DETALLE.StkAct[11]  
        DETALLE.StkAct[12]  
        DETALLE.StkAct[13]  
        DETALLE.StkAct[14]   
        x-StkAct            
        DETALLE.ProVtaCan[1]    
        DETALLE.ProVtaCanA[1]   
        DETALLE.ProVtaCan[2]    
        DETALLE.ProVtaCanA[2]   
        DETALLE.ProVtaCan[3]    
        DETALLE.ProVtaCanA[3]   
        DETALLE.ProVtaCan[14]   
        DETALLE.ProVtaCanA[14]  
        DETALLE.ProVtaCan[8]    
        DETALLE.ProVtaCanA[8]   
    
        DETALLE.ProVtaCanAte[1]   
        DETALLE.ProVtaCanAteA[1]  
        DETALLE.ProVtaCanAte[2]   
        DETALLE.ProVtaCanAteA[2]    
        DETALLE.ProVtaCanAte[3]     
        DETALLE.ProVtaCanAteA[3]    
        DETALLE.ProVtaCanAte[4]     
        DETALLE.ProVtaCanAteA[4]    
        DETALLE.ProVtaCanAte[10]    
        DETALLE.ProVtaCanAteA[10]   
    
        DETALLE.ProVtaCan[12]    
        DETALLE.ProVtaCanA[12]  
        DETALLE.ProVtaCan[5]    
        DETALLE.ProVtaCanA[5]   
        DETALLE.ProVtaCan[11]   
        DETALLE.ProVtaCanA[11]  
        DETALLE.ProVtaCan[16]   
        DETALLE.ProVtaCanA[16]  
        DETALLE.ProVtaCan[15]   
        DETALLE.ProVtaCanA[15]  
        WITH FRAME F-DETALLE.
  END.
  OUTPUT CLOSE.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir D-Dialog 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
/*  SYSTEM-DIALOG GET-FILE s-Archivo  
 *     FILTERS 'texto (*.txt)' '*.txt'  
 *     ASK-OVERWRITE 
 *     CREATE-TEST-FILE  
 *     DEFAULT-EXTENSION '.txt'  
 *     RETURN-TO-START-DIR 
 *     SAVE-AS  
 *     TITLE 'GENERAR ARCHIVO TEXTO'  
 *     UPDATE s-Ok.
 *   
 *   IF s-Ok = NO THEN RETURN.*/
  
  RUN Carga-Temporal.
  
  /*RUN Formato.*/
  RUN Excel.
  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN
    x-VtaRef-1 = DATE(01,01,YEAR(TODAY))
    x-IngAlm-1 = DATE(01,01,YEAR(TODAY))
    x-FchCot-1 = DATE(01,01,YEAR(TODAY))
    x-VtaRef-2 = TODAY
    x-IngAlm-2 = TODAY
    x-FchCot-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Produccion D-Dialog 
PROCEDURE Produccion :
/*------------------------------------------------------------------------------
  Purpose:     Ingresos de productos terminados 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Almacenes AS CHAR INIT '11,22,22a,152' NO-UNDO.

  FOR EACH Almacen NO-LOCK WHERE LOOKUP(TRIM(CodAlm), x-Almacenes) > 0:
    FOR EACH Almdmov NO-LOCK WHERE Almdmov.codcia = s-codcia
            AND Almdmov.codalm = Almacen.codalm
            AND Almdmov.tipmov = 'I'
            AND Almdmov.codmov = 03
            AND Almdmov.codmat = Pr-Mcpp.codmat
            AND Almdmov.fchdoc >= x-IngAlm-1
            AND Almdmov.fchdoc <= x-IngAlm-2,
            FIRST Almcmov OF Almdmov NO-LOCK:
        IF Almdmov.almori = '12' AND Almcmov.observ BEGINS 'OP'     /* Fabrica y convertidoras */
        THEN DETALLE.IngAlm = DETALLE.IngAlm + Almdmov.candes.            
        IF LOOKUP(TRIM(Almdmov.almori), '101,102,103,104,117,138,149,150,153,154,161,163,162,164,157') > 0    /* Fabrica y convertidoras */
        THEN DETALLE.IngAlm = DETALLE.IngAlm + Almdmov.candes.            
    END.            
  END.
  FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = s-codcia
        AND Almcmov.codalm = '11'
        AND Almcmov.tipmov = 'I'
        AND Almcmov.codmov = 02
        AND Almcmov.codpro = '51135890'     /* CISSAC */
        AND Almcmov.fchdoc >= x-IngAlm-1
        AND Almcmov.fchdoc <= x-IngAlm-2:
    FOR EACH Almdmov OF Almcmov NO-LOCK WHERE Almdmov.codmat = Pr-Mcpp.codmat:        
        DETALLE.IngAlm = DETALLE.IngAlm + Almdmov.candes * Almdmov.factor.
    END.
  END.        
  
  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
PROCEDURE Recoge-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

