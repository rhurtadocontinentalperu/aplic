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

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-USER-ID AS CHAR.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

/*******/

/* Local Variable Definitions ---                                       */
DEFINE VAR C-DESMOV      AS CHAR NO-UNDO.
DEFINE VAR C-OP          AS CHAR NO-UNDO.
DEFINE VAR X-PROCEDENCIA AS CHAR NO-UNDO.
DEFINE VAR x-codmov      AS CHAR NO-UNDO.
DEFINE VAR X-CODPRO      AS CHAR NO-UNDO.

DEFINE VAR x-titulo1 AS CHAR NO-UNDO.
DEFINE VAR x-titulo2 AS CHAR NO-UNDO.
DEFINE VAR x-tipmov  AS CHAR NO-UNDO.
DEFINE VAR x-desmat  AS CHAR NO-UNDO.
DEFINE VAR x-desmar  AS CHAR NO-UNDO.
DEFINE VAR x-flgest  AS CHAR NO-UNDO.
DEFINE VAR X-Movi    AS CHAR NO-UNDO.

DEFINE TEMP-TABLE T-resume 
       FIELD Codmat LIKE Almmmatg.Codmat
       FIELD Desmat LIKE Almmmatg.Desmat
       FIELD UndBas LIKE Almmmatg.UndBas
       FIELD Precio LIKE Almdmov.CanDes
       FIELD Total  LIKE Almdmov.CanDes
       FIELD CanRea LIKE Almdmov.CanDes
       FIELD CanSis LIKE Almdmov.CanDes .

FIND PR-CFGPRO WHERE PR-CFGPRO.Codcia = S-CODCIA
                     NO-LOCK NO-ERROR.
IF NOT AVAILABLE PR-CFGPRO THEN DO:
   MESSAGE "Registro de Configuracion de Produccion no existe"
           VIEW-AS ALERT-BOX ERROR.
           RETURN.
END.

DEFINE VAR X-FECINI AS DATE.
DEFINE VAR X-FECFIN AS DATE.

DEFINE TEMP-TABLE T-Prod 
       FIELD Codcia LIKE Almdmov.Codcia
       FIELD Codmat LIKE Almmmatg.Codmat
       FIELD Desmat LIKE Almmmatg.Desmat
       FIELD UndBas LIKE Almmmatg.UndBas
       FIELD Precio LIKE Almdmov.CanDes
       FIELD Total  LIKE Almdmov.CanDes
       FIELD CanRea LIKE Almdmov.CanDes
       FIELD CanSis LIKE Almdmov.CanDes .

DEFINE TEMP-TABLE T-Alm 
       FIELD Codcia LIKE Almdmov.Codcia
       FIELD Codmat LIKE Almmmatg.Codmat
       FIELD Desmat LIKE Almmmatg.Desmat
       FIELD UndBas LIKE Almmmatg.UndBas
       FIELD Precio LIKE Almdmov.CanDes
       FIELD Total  LIKE Almdmov.CanDes
       FIELD CanRea LIKE Almdmov.CanDes
       FIELD CanSis LIKE Almdmov.CanDes .


DEFINE TEMP-TABLE T-Merm 
       FIELD Codcia LIKE Almdmov.Codcia
       FIELD Codmat LIKE Almmmatg.Codmat
       FIELD Desmat LIKE Almmmatg.Desmat
       FIELD UndBas LIKE Almmmatg.UndBas
       FIELD Precio LIKE Almdmov.CanDes
       FIELD Total  LIKE Almdmov.CanDes
       FIELD CanRea LIKE Almdmov.CanDes
       FIELD CanSis LIKE Almdmov.CanDes .

DEFINE TEMP-TABLE T-Horas 
       FIELD Codcia LIKE Almdmov.Codcia
       FIELD CodPer LIKE Pl-PERS.CodPer
       FIELD DesPer AS CHAR FORMAT "X(45)"
       FIELD TotMin AS DECI FORMAT "->>>,>>9.99"
       FIELD TotHor AS DECI FORMAT "->>>,>>9.99"
       FIELD Factor AS DECI EXTENT 10 FORMAT "->>9.99" .

DEFINE TEMP-TABLE T-Gastos
       FIELD Codcia LIKE Almdmov.Codcia
       FIELD CodGas LIKE PR-ODPDG.CodGas
       FIELD CodPro LIKE PR-ODPDG.CodPro
       FIELD Total  LIKE Almdmov.CanDes.


DEFINE VARIABLE X-DESPRO AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE X-DESART AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE X-DESPER AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE X-NOMPRO AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE X-NOMGAS AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE X-TOTAL AS DECI INIT 0.
DEFINE VARIABLE X-CODMON AS CHAR .

DEFINE VARIABLE X-UNIMAT AS DECI FORMAT "->>>>>>9.9999".
DEFINE VARIABLE X-UNIHOR AS DECI FORMAT "->>>>>>9.9999".
DEFINE VARIABLE X-UNISER AS DECI FORMAT "->>>>>>9.9999".
DEFINE VARIABLE X-UNIFAB AS DECI FORMAT "->>>>>>9.9999".

DEFINE BUFFER B-DMOV FOR ALMDMOV.

DEFINE  VAR X-CANTI AS DECI INIT 0.
DEFINE  VAR X-CTOMAT AS DECI INIT 0.
DEFINE  VAR X-CTOHOR AS DECI INIT 0.
DEFINE  VAR X-CTOSER AS DECI INIT 0.
DEFINE  VAR X-CTOFAB AS DECI INIT 0.
DEFINE  VAR X-CTOTOT AS DECI INIT 0.
DEFINE  VAR X-PREUNI AS DECI INIT 0.
DEFINE  VAR X-FACFAB AS DECI INIT 0.

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
&Scoped-Define ENABLED-OBJECTS RECT-62 RECT-60 F-Orden F-fecha Btn_Cancel ~
Btn_Genera Btn_OK 
&Scoped-Define DISPLAYED-OBJECTS F-Orden F-fecha 

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

DEFINE BUTTON Btn_Genera 
     IMAGE-UP FILE "img\proces":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5 TOOLTIP "Actualizar Costo de Producto Terminado"
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE F-fecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Liquidacion Al" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-Orden AS CHARACTER FORMAT "X(6)":U 
     LABEL "Orden" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-60
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53 BY 1.85.

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53 BY 3.96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-Orden AT ROW 2.54 COL 11 COLON-ALIGNED
     F-fecha AT ROW 3.35 COL 11.14 COLON-ALIGNED
     Btn_Cancel AT ROW 5.23 COL 37.29
     Btn_Genera AT ROW 5.31 COL 12.72
     Btn_OK AT ROW 5.31 COL 24.72
     RECT-62 AT ROW 1.08 COL 1.14
     RECT-60 AT ROW 5.04 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 10.92
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
         TITLE              = "Pre-Liquidacion de Orden de Produccion"
         HEIGHT             = 5.88
         WIDTH              = 53.72
         MAX-HEIGHT         = 10.92
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 10.92
         VIRTUAL-WIDTH      = 80
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Pre-Liquidacion de Orden de Produccion */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Pre-Liquidacion de Orden de Produccion */
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


&Scoped-define SELF-NAME Btn_Genera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Genera W-Win
ON CHOOSE OF Btn_Genera IN FRAME F-Main /* Aceptar */
DO:
  MESSAGE "Se actualizará el Costo de todos" SKIP
            "los Ingresos de Producto Terminado" SKIP
            "Esta Seguro de realizar la operacion"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE X-OK AS LOGICAL.
    
  IF NOT X-OK THEN RETURN.
  
  ASSIGN F-Fecha  F-Orden.
  X-CANTI = 0.
  X-CTOMAT = 0.
  X-CTOHOR = 0.
  X-CTOSER = 0.
  FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= F-fecha
                    NO-LOCK NO-ERROR.  

   FIND PR-ODPC WHERE PR-ODPC.CodCia = S-CODCIA 
                  AND PR-ODPC.NumOrd = F-Orden
                  NO-LOCK NO-ERROR.
   IF NOT AVAILABLE PR-ODPC THEN DO:
      MESSAGE "Orden de produccion No existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-Orden.
      RETURN NO-APPLY.   
   END.

  
  FIND LAST PR-LIQC WHERE PR-LIQC.Codcia = PR-ODPC.Codcia AND
                          PR-LIQC.NumOrd = PR-ODPC.NumOrd AND
                          PR-LIQC.FlgEst <> "A"
                          NO-LOCK NO-ERROR.
  IF AVAILABLE PR-LIQC THEN DO:
  
     X-FECINI = PR-LIQC.FecFin + 1.                   
     MESSAGE "Periodo Liquidado : " + STRING(PR-LIQC.FecIni,"99/99/9999") + " Al " + STRING(PR-LIQC.FecFin,"99/99/9999") SKIP
             "Fecha             : " + STRING(PR-LIQC.FchLiq,"99/99/9999")     SKIP
             "Numero            : " + PR-LIQC.NumLiq 
             VIEW-AS ALERT-BOX INFORMATION TITLE "Datos Ultima Liquidacion".
     IF F-Fecha <= PR-LIQC.FecFin THEN DO:
        MESSAGE "Fecha Incorrecta " SKIP
                "Verifque........."
                VIEW-AS ALERT-BOX .
                APPLY "ENTRY" TO F-Fecha.
                RETURN NO-APPLY. 
     END.
  
  END.      
  ELSE DO:
    X-FECINI = PR-ODPC.FchOrd.
  END.
  X-FECFIN = F-Fecha .     
  

  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Act-Costos.
  RUN Habilita.
  RUN Inicializa-Variables.

  MESSAGE "Costos Actualizados "
         VIEW-AS ALERT-BOX INFORMATION TITLE "Proceso Concluido".  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN F-Fecha  F-Orden.
  X-CANTI = 0.
  X-CTOMAT = 0.
  X-CTOHOR = 0.
  X-CTOSER = 0.
  FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= F-fecha
                    NO-LOCK NO-ERROR.  

   FIND PR-ODPC WHERE PR-ODPC.CodCia = S-CODCIA 
                  AND PR-ODPC.NumOrd = F-Orden
                  NO-LOCK NO-ERROR.
   IF NOT AVAILABLE PR-ODPC THEN DO:
      MESSAGE "Orden de produccion No existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-Orden.
      RETURN NO-APPLY.   
   END.

  
  FIND LAST PR-LIQC WHERE PR-LIQC.Codcia = PR-ODPC.Codcia AND
                          PR-LIQC.NumOrd = PR-ODPC.NumOrd AND
                          PR-LIQC.FlgEst <> "A"
                          NO-LOCK NO-ERROR.
  IF AVAILABLE PR-LIQC THEN DO:
  
     X-FECINI = PR-LIQC.FecFin + 1.                   
     MESSAGE "Periodo Liquidado : " + STRING(PR-LIQC.FecIni,"99/99/9999") + " Al " + STRING(PR-LIQC.FecFin,"99/99/9999") SKIP
             "Fecha             : " + STRING(PR-LIQC.FchLiq,"99/99/9999")     SKIP
             "Numero            : " + PR-LIQC.NumLiq 
             VIEW-AS ALERT-BOX INFORMATION TITLE "Datos Ultima Liquidacion".
     IF F-Fecha <= PR-LIQC.FecFin THEN DO:
        MESSAGE "Fecha Incorrecta " SKIP
                "Verifque........."
                VIEW-AS ALERT-BOX .
                APPLY "ENTRY" TO F-Fecha.
                RETURN NO-APPLY. 
     END.
  
  END.      
  ELSE DO:
    X-FECINI = PR-ODPC.FchOrd.
  END.
  X-FECFIN = F-Fecha .     
  

  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Orden
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Orden W-Win
ON LEAVE OF F-Orden IN FRAME F-Main /* Orden */
DO:
   SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").  
   ASSIGN F-ORDEN = SELF:SCREEN-VALUE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Act-Costos W-Win 
PROCEDURE Act-Costos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN Crea-Tempo-Prod.
  RUN Crea-Tempo-Alm.
  RUN Crea-Tempo-Merma.
  RUN Crea-Tempo-Horas-3.
  RUN Crea-Tempo-Gastos.

    FOR EACH T-Prod:
        X-CANTI = X-CANTI + T-Prod.CanRea .
    END.
    
    FOR EACH T-Alm:
        X-CTOMAT = X-CTOMAT + T-Alm.Total.
    END.

    FOR EACH T-Horas:
        X-CTOHOR = X-CTOHOR + T-Horas.TotHor.
    END.
    FOR EACH T-Gastos:
        X-CTOSER = X-CTOSER + T-Gastos.Total.
    END.

    X-CTOFAB = PR-CFGPRO.Factor * X-CTOHOR . 
    X-CTOTOT = X-CTOMAT + X-CTOHOR + X-CTOSER + X-CTOFAB.
    X-FACFAB = IF X-CTOFAB > 0 THEN PR-CFGPRO.Factor ELSE 0.
    X-UNIMAT = X-CTOMAT / X-CANTI.
    X-UNIHOR = X-CTOHOR / X-CANTI.
    X-UNISER = X-CTOSER / X-CANTI.
    X-UNIFAB = X-CTOFAB / X-CANTI.
    X-PREUNI = X-CTOTOT / X-CANTI.
    

    FOR EACH Almcmov EXCLUSIVE-LOCK WHERE Almcmov.Codcia = S-CODCIA AND
                                          Almcmov.CodAlm = PR-ODPC.CodAlm AND
                                          Almcmov.TipMov = PR-CFGPRO.TipMov[2] AND
                                          Almcmov.Codmov = PR-CFGPRO.CodMov[2] AND
                                          Almcmov.CodRef = "OP" AND
                                          Almcmov.Nroref = PR-ODPC.NumOrd AND
                                          Almcmov.FchDoc >= X-FecIni AND
                                          Almcmov.FchDoc <= X-FecFin:
     Almcmov.ImpMn1 = 0.
     Almcmov.ImpMn2 = 0.
     Almcmov.CodMon = 1.
     
     FOR EACH Almdmov OF Almcmov EXCLUSIVE-LOCK:
          ASSIGN
          Almdmov.Codmon = Almcmov.CodMon
          Almdmov.ImpCto = X-PreUni * Almdmov.CanDes 
          Almdmov.PreLis = X-PreUni 
          Almdmov.PreUni = X-PreUni
          Almdmov.Dsctos[1] = 0
          Almdmov.Dsctos[2] = 0
          Almdmov.Dsctos[3] = 0           
          Almdmov.ImpMn1    = X-PreUni * Almdmov.CanDes  
          Almdmov.ImpMn2    = X-PreUni * Almdmov.CanDes / Almcmov.TpoCmb .              

          IF Almcmov.codmon = 1 THEN DO:
             Almcmov.ImpMn1 = Almcmov.ImpMn1 + Almdmov.ImpMn1.
          END.
          ELSE DO:
             Almcmov.ImpMn2 = Almcmov.ImpMn2 + Almdmov.ImpMn2.
          END.        
     END.        
     
    END.



 
HIDE FRAME F-PROCESO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  ASSIGN F-Fecha F-Orden .

  x-titulo2 = "ORDEN DE PRODUCCION No " + F-ORDEN.
  x-titulo1 = 'PRE-LIQUIDACION DE ORDEN DE PRODUCCION '.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tempo-Alm W-Win 
PROCEDURE Crea-Tempo-Alm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FOR EACH T-Alm:
      DELETE T-Alm.
  END.
  DEFINE VAR I AS INTEGER.
  DEFINE VAR F-STKGEN AS DECI .
  DEFINE VAR F-VALCTO AS DECI .
  DEFINE VAR F-PRECIO AS DECI.
  DEFINE VAR F-TOTAL AS DECI.
  
            FOR EACH Almcmov NO-LOCK WHERE Almcmov.Codcia = S-CODCIA AND
                                         Almcmov.CodAlm = PR-ODPC.CodAlm AND
                                         Almcmov.TipMov = PR-CFGPRO.TipMov[1] AND
                                         Almcmov.Codmov = PR-CFGPRO.CodMov[1] AND
                                         Almcmov.CodRef = "OP" AND
                                         Almcmov.Nroref = PR-ODPC.NumOrd AND
                                         Almcmov.FchDoc >= X-FECINI AND
                                         Almcmov.FchDoc <= X-FECFIN:
                                     
                                 
             FOR EACH Almdmov OF Almcmov:
                 F-STKGEN = 0.
                 F-VALCTO = 0.
                 F-PRECIO = 0.
                 F-TOTAL  = 0.
                 
                 FIND B-DMOV WHERE ROWID(B-DMOV) = ROWID(almdmov)
                                   NO-LOCK NO-ERROR.
                 REPEAT:           
                    FIND PREV B-DMOV WHERE B-DMOV.Codcia = S-CODCIA AND
                                           B-DMOV.CodMat = Almdmov.CodMat AND
                                           B-DMOV.FchDoc <= Almdmov.FchDoc 
                                           USE-INDEX Almd02
                                           NO-LOCK NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN LEAVE.
                    IF B-DMOV.StkAct > 0 THEN LEAVE.
                 END.      
                 IF AVAILABLE B-DMOV THEN DO:
                    F-PRECIO = B-DMOV.Vctomn1 .
                    F-TOTAL  = F-PRECIO * Almdmov.CanDes.
                 END.
                 
                 /*f-total = Almdmov.Vctomn1 * Almdmov.CanDes.*/
                 
                 FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                                     Almmmatg.CodMat = Almdmov.Codmat
                                     NO-LOCK NO-ERROR.
              
                FIND T-Alm WHERE T-Alm.codmat = Almdmov.Codmat
                                    NO-ERROR.
                IF NOT AVAILABLE T-Alm THEN DO:
                   CREATE T-Alm.
                   ASSIGN 
                      T-Alm.CodCia = S-CODCIA
                      T-Alm.Codmat = Almdmov.Codmat
                      T-Alm.Desmat = Almmmatg.desmat
                      T-Alm.UndBas = Almmmatg.undbas.
                END.                         
                 
                T-Alm.CanRea = T-Alm.CanRea + Almdmov.CanDes.    
                T-Alm.Total  = T-Alm.Total  + F-TOTAL.    
                T-Alm.Precio = T-Alm.Total / T-Alm.CanRea.

             END.        
            END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tempo-Gastos W-Win 
PROCEDURE Crea-Tempo-Gastos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR X-UNIDADES AS DECI INIT 0.
    DEFINE VAR X-PRECIO AS DECI INIT 0 .
        
    FOR EACH T-Gastos:
        DELETE T-Gastos.
    END.
    FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= F-fecha
                            NO-LOCK NO-ERROR.  

/*        
    FOR EACH T-Alm:
        IF T-Alm.CodMat = PR-ODPC.CodArt THEN DO:
           X-UNIDADES = X-UNIDADES + T-Alm.CanRea.
        END.
    END.
*/
    FOR EACH T-Prod:    
        FIND Almmmatg WHERE Almmmatg.Codcia = PR-ODPC.Codcia AND
                            Almmmatg.CodMat = T-Prod.CodMat 
                            NO-LOCK NO-ERROR.
                                
        FOR EACH PR-ODPDG OF PR-ODPC:
            FIND T-Gastos WHERE T-Gastos.CodGas = PR-ODPDG.CodGas AND
                                T-Gastos.CodPro = PR-ODPDG.CodPro
                                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE T-Gastos THEN DO:
                CREATE T-Gastos.
                ASSIGN
                T-Gastos.CodGas = PR-ODPDG.CodGas
                T-Gastos.CodPro = PR-ODPDG.CodPro .
            END.
            
        
            FIND PR-PRESER WHERE PR-PRESER.Codcia = PR-ODPDG.Codcia AND
                                 PR-PRESER.CodPro = PR-ODPDG.CodPro AND
                                 PR-PRESER.CodGas = PR-ODPDG.CodGas AND
                                 PR-PRESER.CodMat = T-Prod.CodMat
                                 NO-LOCK NO-ERROR.
            X-PRECIO = 0.
            IF AVAILABLE PR-PRESER THEN DO:  
               IF PR-ODPC.CodMon = 1 THEN DO:
                  IF PR-PRESER.CodMon = 1 THEN X-PRECIO = PR-PRESER.PreLis[1].
                  IF PR-PRESER.CodMon = 2 THEN X-PRECIO = PR-PRESER.PreLis[1] * Gn-Tcmb.Venta .
               END.
               IF PR-ODPC.CodMon = 2 THEN DO:
                  IF PR-PRESER.CodMon = 1 THEN X-PRECIO = PR-PRESER.PreLis[1] /  Gn-Tcmb.Venta.
                  IF PR-PRESER.CodMon = 2 THEN X-PRECIO = PR-PRESER.PreLis[1]  .

               END.
        
               FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
                              AND  Almtconv.Codalter = PR-PRESER.UndA 
                              NO-LOCK NO-ERROR.
               IF AVAILABLE Almtconv THEN DO:
                  T-Gastos.Total  = T-Gastos.Total + (X-PRECIO * T-Prod.CanRea) / (PR-PRESER.CanDes[1] * Almtconv.Equival).                    
               END.                    
            END.            
        END.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tempo-Horas W-Win 
PROCEDURE Crea-Tempo-Horas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH T-Horas:
        DELETE T-Horas.
    END.

    DEFINE VAR X-DIAS AS INTEGER INIT 208.
    DEFINE VAR I AS INTEGER.
    DEFINE VAR F-STKGEN AS DECI .
    DEFINE VAR F-VALCTO AS DECI .
    DEFINE VAR F-PRECIO AS DECI.
    DEFINE VAR F-TOTAL AS DECI.
    DEFINE VAR X-DESPER  AS CHAR FORMAT "X(35)".
    DEFINE VAR X-HORAI AS DECI .
    DEFINE VAR X-SEGI AS DECI .
    DEFINE VAR X-SEGF AS DECI .
    DEFINE VAR X-IMPHOR AS DECI FORMAT "->>9.99".
    DEFINE VAR X-BASE   AS DECI .
    DEFINE VAR X-HORMEN AS DECI .
    DEFINE VAR X-FACTOR AS DECI .

    DEFINE VAR X-HORA AS DECI EXTENT 10 FORMAT "->>9.99".
    DEFINE VAR X-TOTA AS DECI EXTENT 10 FORMAT "->>>>>9.99".

    DEFINE VAR X-TOT1 AS DECI.
    DEFINE VAR X-TOT2 AS DECI.
    DEFINE VAR X-TOT3 AS DECI.
    DEFINE VAR X-TOT4 AS DECI.
    DEFINE VAR X-TOT5 AS DECI.
    DEFINE VAR X-TOT6 AS DECI.
    DEFINE VAR X-TOT10 AS DECI.

    FOR EACH PR-MOV-MES NO-LOCK WHERE
        PR-MOV-MES.CodCia = S-CODCIA AND
        PR-MOV-MES.NumOrd = PR-ODPC.NumOrd AND
        PR-MOV-MES.FchReg >= X-FECINI AND
        PR-MOV-MES.FchReg <= X-FECFIN
        BREAK BY PR-MOV-MES.NumOrd
        BY PR-MOV-MES.FchReg
        BY PR-MOV-MES.CodPer:

        FIND PL-PERS WHERE
            Pl-PERS.Codper = PR-MOV-MES.CodPer
            NO-LOCK NO-ERROR.
        X-DESPER = "".
        IF AVAILABLE Pl-PERS THEN 
            X-DESPER = TRIM(PL-PERS.PatPer) + " " + TRIM(PL-PERS.MatPer) + " " + TRIM(PL-PERS.NomPer).
        X-HORAI  = PR-MOV-MES.HoraI.
        X-HORA   = 0.
        X-IMPHOR = 0.
        X-TOTA   = 0.
        X-BASE   = 0.
        X-HORMEN = 0.
        X-FACTOR = 0.
        FOR EACH PL-MOV-MES NO-LOCK WHERE
            PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND
            PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND
            PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND
            PL-MOV-MES.CodPln  = 01 AND
            PL-MOV-MES.Codcal  = 0 AND
            PL-MOV-MES.CodPer = PR-MOV-MES.CodPer AND
            (PL-MOV-MES.CodMov = 101 OR PL-MOV-MES.CodMov = 103):
            X-BASE = X-BASE + PL-MOV-MES.VALCAL-MES .                     
        END.
        FIND LAST PL-VAR-MES WHERE
            PL-VAR-MES.Periodo = PR-MOV-MES.Periodo AND
            PL-VAR-MES.NroMes  = PR-MOV-MES.NroMes 
            NO-LOCK NO-ERROR.
        IF AVAILABLE PL-VAR-MES THEN 
           ASSIGN
                X-HORMEN = PL-VAR-MES.ValVar-MES[11]
                X-FACTOR =
                    PL-VAR-MES.ValVar-MES[12] +
                    PL-VAR-MES.ValVar-MES[13] +
                    PL-VAR-MES.ValVar-MES[3] +
                    PL-VAR-MES.ValVar-MES[5] +
                    PL-VAR-MES.ValVar-MES[10].

        X-IMPHOR = (X-BASE / X-HORMEN) * ( 1 + (X-FACTOR / 100) ) / 60.
        FOR EACH PR-CFGPL NO-LOCK WHERE
            PR-CFGPL.Codcia = S-CODCIA:
            IF X-HORAI >= PR-CFGPL.HoraI AND X-HORAI < PR-CFGPL.HoraF THEN DO:
                IF PR-MOV-MES.HoraF <= PR-CFGPL.HoraF THEN DO:
                    X-SEGF = TRUNCATE(PR-MOV-MES.HoraF,0) * 60 + (PR-MOV-MES.HoraF - TRUNCATE(PR-MOV-MES.HoraF,0)) * 100 . 
                    X-SEGI = TRUNCATE(X-HORAI,0) * 60 + (X-HORAI - TRUNCATE(X-HORAI,0)) * 100 . 
                    X-HORA[PR-CFGPL.Nroitm] = X-HORA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) .                 
                    X-TOTA[PR-CFGPL.Nroitm] = X-TOTA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                    X-TOTA[10] = X-TOTA[10] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                    LEAVE.
                END.
                IF PR-MOV-MES.HoraF > PR-CFGPL.HoraF THEN DO:
                    X-SEGF = TRUNCATE(PR-CFGPL.HoraF,0) * 60 + (PR-CFGPL.HoraF - TRUNCATE(PR-CFGPL.HoraF,0)) * 100 . 
                    X-SEGI = TRUNCATE(X-HORAI,0) * 60 + (X-HORAI - TRUNCATE(X-HORAI,0)) * 100 . 
                    X-HORA[PR-CFGPL.Nroitm] = X-HORA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) .                 
                    X-TOTA[PR-CFGPL.Nroitm] = X-TOTA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                    X-TOTA[10] = X-TOTA[10] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                    X-HORAI = PR-CFGPL.HoraF.
                END.
            END.
        END.               
        X-IMPHOR = X-IMPHOR * 60 .         

        X-SEGF = TRUNCATE(PR-MOV-MES.HoraF,0) * 60 + (PR-MOV-MES.HoraF - TRUNCATE(PR-MOV-MES.HoraF,0)) * 100.
        X-SEGI = TRUNCATE(PR-MOV-MES.HoraI,0) * 60 + (PR-MOV-MES.HoraI - TRUNCATE(PR-MOV-MES.HoraI,0)) * 100.

        FIND FIRST T-Horas WHERE
            T-Horas.CodPer = PR-MOV-MES.CodPer NO-ERROR.
        IF NOT AVAILABLE T-Horas THEN DO:
            CREATE T-Horas.
            ASSIGN 
                T-Horas.CodCia = S-CODCIA
                T-Horas.CodPer = PR-MOV-MES.CodPer
                T-Horas.DesPer = X-DESPER.
        END.
        ASSIGN
            T-Horas.TotMin = T-Horas.TotMin +  X-SEGF - X-SEGI
            T-Horas.TotHor = T-Horas.TotHor + X-TOTA[10].
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tempo-Horas-2 W-Win 
PROCEDURE Crea-Tempo-Horas-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  EMPTY TEMP-TABLE t-Horas.

  DEFINE VAR X-DIAS AS INTEGER INIT 208.
  DEFINE VAR I AS INTEGER.
  DEFINE VAR F-STKGEN AS DECI .
  DEFINE VAR F-VALCTO AS DECI .
  DEFINE VAR F-PRECIO AS DECI.
  DEFINE VAR F-TOTAL AS DECI.
  DEFINE VAR X-DESPER  AS CHAR FORMAT "X(35)".
  DEFINE VAR X-HORAI AS DECI .
  DEFINE VAR X-SEGI AS DECI .
  DEFINE VAR X-SEGF AS DECI .
  DEFINE VAR X-IMPHOR AS DECI FORMAT "->>9.99".
  DEFINE VAR X-BASE   AS DECI .
  DEFINE VAR X-HORMEN AS DECI .
  DEFINE VAR X-FACTOR AS DECI .
  DEFINE VAR x-Con144 AS DECI .
  
  DEFINE VAR X-HORA AS DECI EXTENT 10 FORMAT "->>9.99".
  DEFINE VAR X-TOTA AS DECI EXTENT 10 FORMAT "->>>>>9.99".
  
  DEFINE VAR X-TOT1 AS DECI.
  DEFINE VAR X-TOT2 AS DECI.
  DEFINE VAR X-TOT3 AS DECI.
  DEFINE VAR X-TOT4 AS DECI.
  DEFINE VAR X-TOT5 AS DECI.
  DEFINE VAR X-TOT6 AS DECI.
  DEFINE VAR X-TOT10 AS DECI.

  FOR EACH PR-MOV-MES NO-LOCK WHERE PR-MOV-MES.CodCia = S-CODCIA AND  
      PR-MOV-MES.NumOrd = PR-ODPC.NumOrd  AND
      PR-MOV-MES.FchReg >= X-FECINI  AND  
      PR-MOV-MES.FchReg <= X-FECFIN
      BREAK BY PR-MOV-MES.NumOrd
        BY PR-MOV-MES.FchReg
        BY PR-MOV-MES.CodPer :

      FIND PL-PERS WHERE Pl-PERS.Codper = PR-MOV-MES.CodPer
          NO-LOCK NO-ERROR.
      X-DESPER = "".
      IF AVAILABLE Pl-PERS THEN 
          X-DESPER = TRIM(PL-PERS.PatPer) + " " + TRIM(PL-PERS.MatPer) + " " + TRIM(PL-PERS.NomPer).

      ASSIGN
          X-HORAI  = PR-MOV-MES.HoraI
          X-HORA   = 0
          X-IMPHOR = 0
          X-TOTA   = 0
          X-BASE   = 0
          X-HORMEN = 0
          X-FACTOR = 0.
        
      /*Coneptos Actuales*/
      FOR EACH PL-MOV-MES WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND
          PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND
          PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND
          PL-MOV-MES.CodPln  = 01 AND
          PL-MOV-MES.Codcal  = 0 AND
          PL-MOV-MES.CodPer = PR-MOV-MES.CodPer AND
          (PL-MOV-MES.CodMov = 101 OR
           PL-MOV-MES.CodMov = 103) NO-LOCK:
                    
          X-BASE = X-BASE + PL-MOV-MES.VALCAL-MES .                     
      END.

      /*Coneptos Actuales*/
      FOR EACH PL-MOV-MES WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND
          PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND
          PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND
          PL-MOV-MES.CodPln  = 01 AND
          PL-MOV-MES.Codcal  = 01 AND
          PL-MOV-MES.CodPer = PR-MOV-MES.CodPer AND
          LOOKUP(STRING(PL-MOV-MES.CodMov,"999"),'117,125,126,127,113') > 0 NO-LOCK:
          
          X-BASE = X-BASE + PL-MOV-MES.VALCAL-MES .                     
      END.

      /*RDP:Conceptos a incluir - Calculo 01*/
      FOR EACH PL-MOV-MES WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND
          PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND
          PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND
          PL-MOV-MES.CodPln  = 01 AND
          PL-MOV-MES.Codcal  = 01 AND
          PL-MOV-MES.CodPer = PR-MOV-MES.CodPer AND
          LOOKUP(STRING(PL-MOV-MES.CodMov,"999"),"126,301,306") > 0 NO-LOCK:          

          X-BASE = X-BASE + PL-MOV-MES.VALCAL-MES .                     
      END.

      /*RDP:Conceptos a incluir - Calculo 09,10,11*/
      FOR EACH PL-MOV-MES WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND
          PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND
          PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND
          PL-MOV-MES.CodPln  = 01 AND
          LOOKUP(STRING(PL-MOV-MES.Codcal,"99"),"09,10,11") > 0  AND
          PL-MOV-MES.CodPer  = PR-MOV-MES.CodPer AND
          PL-MOV-MES.CodMov  = 403 NO-LOCK:          
          IF PL-MOV-MES.Codcal = 11 THEN x-Con144 = PL-MOV-MES.VALCAL-MES * 0.09.

          X-BASE = X-BASE + PL-MOV-MES.VALCAL-MES .                     
      END.

      FIND LAST PL-VAR-MES WHERE
          PL-VAR-MES.Periodo = PR-MOV-MES.Periodo AND
          PL-VAR-MES.NroMes  = PR-MOV-MES.NroMes NO-ERROR.

      IF AVAILABLE PL-VAR-MES THEN 
          ASSIGN
            X-HORMEN = PL-VAR-MES.ValVar-MES[11]
            X-FACTOR = PL-VAR-MES.ValVar-MES[12] + PL-VAR-MES.ValVar-MES[13] + PL-VAR-MES.ValVar-MES[3] + PL-VAR-MES.ValVar-MES[5] + PL-VAR-MES.ValVar-MES[10].
      
      X-IMPHOR = (X-BASE / X-HORMEN) * ( 1 + (X-FACTOR / 100) ) / 60.

      FOR EACH PR-CFGPL NO-LOCK WHERE PR-CFGPL.Codcia = S-CODCIA 
          /*AND PR-CFGPL.Periodo = PR-MOV-MES.Periodo 
          AND PR-CFGPL.NroMes  = PR-MOV-MES.NroMes*/:

          IF X-HORAI >= PR-CFGPL.HoraI AND X-HORAI < PR-CFGPL.HoraF THEN DO:
              IF PR-MOV-MES.HoraF <= PR-CFGPL.HoraF THEN DO:
                  X-SEGF = TRUNCATE(PR-MOV-MES.HoraF,0) * 60 + (PR-MOV-MES.HoraF - TRUNCATE(PR-MOV-MES.HoraF,0)) * 100 . 
                  X-SEGI = TRUNCATE(X-HORAI,0) * 60 + (X-HORAI - TRUNCATE(X-HORAI,0)) * 100 . 
                  X-HORA[PR-CFGPL.Nroitm] = X-HORA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) .                 
                  X-TOTA[PR-CFGPL.Nroitm] = X-TOTA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                  X-TOTA[10] = X-TOTA[10] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                  LEAVE.
              END.

              IF PR-MOV-MES.HoraF > PR-CFGPL.HoraF THEN DO:
                  X-SEGF = TRUNCATE(PR-CFGPL.HoraF,0) * 60 + (PR-CFGPL.HoraF - TRUNCATE(PR-CFGPL.HoraF,0)) * 100 . 
                  X-SEGI = TRUNCATE(X-HORAI,0) * 60 + (X-HORAI - TRUNCATE(X-HORAI,0)) * 100 . 
                  X-HORA[PR-CFGPL.Nroitm] = X-HORA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) .                 
                  X-TOTA[PR-CFGPL.Nroitm] = X-TOTA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                  X-TOTA[10] = X-TOTA[10] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                  X-HORAI = PR-CFGPL.HoraF.
              END.
          END.
      END.               

      X-IMPHOR = X-IMPHOR * 60 .         
      
      X-SEGF = TRUNCATE(PR-MOV-MES.HoraF,0) * 60 + (PR-MOV-MES.HoraF - TRUNCATE(PR-MOV-MES.HoraF,0)) * 100 . 
      X-SEGI = TRUNCATE(PR-MOV-MES.HoraI,0) * 60 + (PR-MOV-MES.HoraI - TRUNCATE(PR-MOV-MES.HoraI,0)) * 100 . 

      FIND T-Horas WHERE T-Horas.CodPer = PR-MOV-MES.CodPer NO-ERROR.
      IF NOT AVAILABLE T-Horas THEN DO:
          CREATE T-Horas.
          ASSIGN 
              T-Horas.CodPer = PR-MOV-MES.CodPer
              T-Horas.DesPer = X-DESPER .
      END.
      ASSIGN
          T-Horas.TotMin = T-Horas.TotMin +  X-SEGF - X-SEGI .
      T-Horas.TotHor = T-Horas.TotHor + X-TOTA[10] . 
  END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tempo-Horas-3 W-Win 
PROCEDURE Crea-Tempo-Horas-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


RUN pro/calcula-horas-mod (INPUT-OUTPUT TABLE T-Horas,
                           INPUT ROWID(PR-ODPC),
                           INPUT x-FecIni,
                           INPUT x-FecFin).

/* DEFINE VAR X-DIAS AS INTEGER INIT 208.                                                                                       */
/* DEFINE VAR X-DESPER  AS CHAR FORMAT "X(35)".                                                                                 */
/* DEFINE VAR X-HORAI AS DECI .                                                                                                 */
/* DEFINE VAR X-SEGI AS DECI .                                                                                                  */
/* DEFINE VAR X-SEGF AS DECI .                                                                                                  */
/* DEFINE VAR X-IMPHOR AS DECI FORMAT "->>9.99".                                                                                */
/* DEFINE VAR X-BASE   AS DECI .                                                                                                */
/* DEFINE VAR X-HORMEN AS DECI .                                                                                                */
/* DEFINE VAR X-FACTOR AS DECI .                                                                                                */
/*                                                                                                                              */
/* EMPTY TEMP-TABLE t-Horas.                                                                                                    */
/* FOR EACH PR-MOV-MES NO-LOCK WHERE PR-MOV-MES.CodCia = S-CODCIA                                                               */
/*     AND PR-MOV-MES.NumOrd = PR-ODPC.NumOrd                                                                                   */
/*     AND PR-MOV-MES.FchReg >= X-FECINI                                                                                        */
/*     AND PR-MOV-MES.FchReg <= X-FECFIN                                                                                        */
/*     BREAK BY PR-MOV-MES.CodPer BY PR-MOV-MES.Periodo BY PR-MOV-MES.NroMes BY PR-MOV-MES.FchReg:                              */
/*     /* Quiebre por Personal, Periodo y Mes trabajado */                                                                      */
/*     IF FIRST-OF(PR-MOV-MES.CodPer) OR FIRST-OF(PR-MOV-MES.Periodo) OR FIRST-OF(PR-MOV-MES.NroMes) THEN DO:                   */
/*         ASSIGN                                                                                                               */
/*             X-DESPER = ""                                                                                                    */
/*             x-HorMen = 0.                                                                                                    */
/*         FIND PL-PERS WHERE Pl-PERS.Codper = PR-MOV-MES.CodPer NO-LOCK NO-ERROR.                                              */
/*         IF AVAILABLE Pl-PERS THEN X-DESPER = TRIM(PL-PERS.PatPer) + " " + TRIM(PL-PERS.MatPer) + " " + TRIM(PL-PERS.NomPer). */
/*     END.                                                                                                                     */
/*     /* Acumulamos las horas trabajadas según producción */                                                                   */
/*     ASSIGN                                                                                                                   */
/*         X-HORAI  = PR-MOV-MES.HoraI.                                                                                         */
/*     FOR EACH PR-CFGPL NO-LOCK WHERE PR-CFGPL.Codcia = S-CODCIA:                                                              */
/*         IF X-HORAI >= PR-CFGPL.HoraI AND X-HORAI < PR-CFGPL.HoraF THEN DO:                                                   */
/*             IF PR-MOV-MES.HoraF <= PR-CFGPL.HoraF THEN DO:                                                                   */
/*                X-SEGF = TRUNCATE(PR-MOV-MES.HoraF,0) * 60 + (PR-MOV-MES.HoraF - TRUNCATE(PR-MOV-MES.HoraF,0)) * 100 .        */
/*                X-SEGI = TRUNCATE(X-HORAI,0) * 60 + (X-HORAI - TRUNCATE(X-HORAI,0)) * 100 .                                   */
/*                x-HorMen = x-HorMen + (X-SEGF - X-SEGI) * (IF PR-CFGPL.Factor = 0 THEN 0 ELSE 1 ).                            */
/*                LEAVE.                                                                                                        */
/*             END.                                                                                                             */
/*             IF PR-MOV-MES.HoraF > PR-CFGPL.HoraF THEN DO:                                                                    */
/*                X-SEGF = TRUNCATE(PR-CFGPL.HoraF,0) * 60 + (PR-CFGPL.HoraF - TRUNCATE(PR-CFGPL.HoraF,0)) * 100 .              */
/*                X-SEGI = TRUNCATE(X-HORAI,0) * 60 + (X-HORAI - TRUNCATE(X-HORAI,0)) * 100 .                                   */
/*                x-HorMen = x-HorMen + (X-SEGF - X-SEGI) * ( IF PR-CFGPL.Factor = 0 THEN 0 ELSE 1 ).                           */
/*                X-HORAI = PR-CFGPL.HoraF.                                                                                     */
/*             END.                                                                                                             */
/*         END.                                                                                                                 */
/*     END.                                                                                                                     */
/*     IF LAST-OF(PR-MOV-MES.CodPer) OR LAST-OF(PR-MOV-MES.Periodo) OR LAST-OF(PR-MOV-MES.NroMes) THEN DO:                      */
/*         ASSIGN                                                                                                               */
/*             x-Base = 0                                                                                                       */
/*             x-Dias = 0                                                                                                       */
/*             x-ImpHor = 0.                                                                                                    */
/*         /* Calculamos el Valor Hora de acuerdo a la planilla */                                                              */
/*         FIND PL-MOV-MES WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND                                                      */
/*             PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND                                                                      */
/*             PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND                                                                       */
/*             PL-MOV-MES.CodPer  = PR-MOV-MES.CodPer AND                                                                       */
/*             PL-MOV-MES.CodPln  = 01 AND                                                                                      */
/*             PL-MOV-MES.Codcal  = 01 AND                                                                                      */
/*             PL-MOV-MES.CodMov  = 100    /* DIAS TRABAJADOS */                                                                */
/*             NO-LOCK NO-ERROR.                                                                                                */
/*         IF AVAILABLE PL-MOV-MES THEN x-Dias = PL-MOV-MES.ValCal-Mes.                                                         */
/*         /* BOLETA DE SUELDOS 101 Sueldo 103 Asig. fam 117 Alimentacion 125 HHEE 25% 126 HHEE 100% 127 HHEE 35% 301 ESSALUD   */
/*         113 Refrigerio 306 Senati*/                                                                                          */
/*         FOR EACH PL-MOV-MES WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND                                                  */
/*             PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND                                                                      */
/*             PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND                                                                       */
/*             PL-MOV-MES.CodPer  = PR-MOV-MES.CodPer AND                                                                       */
/*             PL-MOV-MES.CodPln  = 01 AND                                                                                      */
/*             PL-MOV-MES.Codcal  = 01 AND                                                                                      */
/*             LOOKUP(STRING(PL-MOV-MES.CodMov,"999"),"101,103,117,113,125,126,127,301,306") > 0 NO-LOCK:                       */
/*             X-BASE = X-BASE + PL-MOV-MES.VALCAL-MES .                                                                        */
/*         END.                                                                                                                 */
/*         /* BOLETA DE GRATIFICACIONES 144 Asig, Extr Grat. 9% */                                                              */
/*         FOR EACH PL-MOV-MES WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND                                                  */
/*             PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND                                                                      */
/*             PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND                                                                       */
/*             PL-MOV-MES.CodPln  = 01 AND                                                                                      */
/*             PL-MOV-MES.Codcal  = 04 AND                                                                                      */
/*             PL-MOV-MES.CodPer = PR-MOV-MES.CodPer AND                                                                        */
/*             LOOKUP(STRING(PL-MOV-MES.CodMov,"999"),"144") > 0 NO-LOCK:                                                       */
/*             X-BASE = X-BASE + PL-MOV-MES.VALCAL-MES .                                                                        */
/*         END.                                                                                                                 */
/*         /* BOLETAS DE PROVISIONES - Calculo 09,10,11 */                                                                      */
/*         FOR EACH PL-MOV-MES WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND                                                  */
/*             PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND                                                                      */
/*             PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND                                                                       */
/*             PL-MOV-MES.CodPln  = 01 AND                                                                                      */
/*             LOOKUP(STRING(PL-MOV-MES.Codcal,"99"),"09,10,11") > 0  AND                                                       */
/*             PL-MOV-MES.CodPer  = PR-MOV-MES.CodPer AND                                                                       */
/*             PL-MOV-MES.CodMov  = 403 NO-LOCK:                                                                                */
/*             X-BASE = X-BASE + PL-MOV-MES.VALCAL-MES .                                                                        */
/*         END.                                                                                                                 */
/*         IF x-Dias > 0 THEN x-ImpHor = x-Base / x-Dias / 8.  /* IMPORTE HORA */                                               */
/*         /* Acumulamos por cada trabajador */                                                                                 */
/*         FIND T-Horas WHERE T-Horas.CodPer = PR-MOV-MES.CodPer NO-ERROR.                                                      */
/*         IF NOT AVAILABLE T-Horas THEN DO:                                                                                    */
/*            CREATE T-Horas.                                                                                                   */
/*            ASSIGN                                                                                                            */
/*                T-Horas.CodPer = PR-MOV-MES.CodPer                                                                            */
/*                T-Horas.DesPer = X-DESPER .                                                                                   */
/*         END.                                                                                                                 */
/*         ASSIGN                                                                                                               */
/*             T-Horas.TotMin = T-Horas.TotMin +  x-HorMen                                                                      */
/*             T-Horas.TotHor = T-Horas.TotHor + ( ( x-HorMen / 60 ) * x-ImpHor ).                                              */
/*     END.                                                                                                                     */
/* END.                                                                                                                         */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tempo-Merma W-Win 
PROCEDURE Crea-Tempo-Merma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH T-Merm:
    DELETE T-Merm.
END.

DEFINE VAR I AS INTEGER.
DEFINE VAR F-STKGEN AS DECI .
DEFINE VAR F-VALCTO AS DECI .
DEFINE VAR F-PRECIO AS DECI.
DEFINE VAR F-TOTAL AS DECI.
  

  FOR EACH Almcmov NO-LOCK WHERE Almcmov.Codcia = S-CODCIA AND
                               Almcmov.CodAlm = PR-ODPC.CodAlm AND
                               Almcmov.TipMov = PR-CFGPRO.TipMov[3] AND
                               Almcmov.Codmov = PR-CFGPRO.CodMov[3]  AND
                               Almcmov.CodRef = "OP" AND
                               Almcmov.Nroref = PR-ODPC.NumOrd AND
                               Almcmov.FchDoc >= X-FECINI AND
                               Almcmov.FchDoc <= X-FECFIN:
                           
                       
   FOR EACH Almdmov OF Almcmov:  
     
       FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                           Almmmatg.CodMat = Almdmov.Codmat
                           NO-LOCK NO-ERROR.
    

      FIND T-Merm WHERE T-Merm.codmat = Almdmov.Codmat
                          NO-ERROR.
      IF NOT AVAILABLE T-Merm THEN DO:
         CREATE T-Merm.
         ASSIGN 
            T-Merm.CodCia = S-CODCIA
            T-Merm.Codmat = Almdmov.Codmat
            T-Merm.Desmat = Almmmatg.desmat
            T-Merm.UndBas = Almmmatg.undbas.
      END.                         
      T-Merm.CanRea = T-Merm.CanRea + Almdmov.CanDes.    

   END.        
  END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tempo-Prod W-Win 
PROCEDURE Crea-Tempo-Prod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


  FOR EACH T-Prod:
      DELETE T-Prod.
  END.
  DEFINE VAR I AS INTEGER.
  DEFINE VAR F-STKGEN AS DECI .
  DEFINE VAR F-VALCTO AS DECI .
  DEFINE VAR F-PRECIO AS DECI.
  DEFINE VAR F-TOTAL AS DECI.
  

            FOR EACH Almcmov NO-LOCK WHERE Almcmov.Codcia = S-CODCIA AND
                                         Almcmov.CodAlm = PR-ODPC.CodAlm AND
                                         Almcmov.TipMov = PR-CFGPRO.TipMov[2] AND
                                         Almcmov.Codmov = PR-CFGPRO.CodMov[2] AND
                                         Almcmov.CodRef = "OP" AND
                                         Almcmov.Nroref = PR-ODPC.NumOrd AND
                                         Almcmov.FchDoc >= X-FECINI AND
                                         Almcmov.FchDoc <= X-FECFIN:
                                     
                                 
             FOR EACH Almdmov OF Almcmov:
    
                 F-STKGEN = AlmDMOV.StkActCbd .
                 F-VALCTO = AlmDMOV.Vctomn1Cbd .
                 F-VALCTO = IF F-STKGEN = 0 THEN 0 ELSE F-VALCTO.
                 F-PRECIO = IF F-STKGEN = 0 THEN 0 ELSE ROUND(F-VALCTO / F-STKGEN,4).
                 F-TOTAL  = F-PRECIO * Almdmov.CanDes.
                 F-Total  = 0.
                 
                 FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                                     Almmmatg.CodMat = Almdmov.Codmat
                                     NO-LOCK NO-ERROR.
              

                FIND T-Prod WHERE T-Prod.codmat = Almdmov.Codmat
                                    NO-ERROR.
                IF NOT AVAILABLE T-Prod THEN DO:
                   CREATE T-Prod.
                   ASSIGN 
                      T-Prod.CodCia = S-CODCIA                      
                      T-Prod.Codmat = Almdmov.Codmat
                      T-Prod.Desmat = Almmmatg.desmat
                      T-Prod.UndBas = Almmmatg.undbas.
                END.                         
                T-Prod.CanRea = T-Prod.CanRea + Almdmov.CanDes.    
                T-Prod.Total  = T-Prod.Total  + F-TOTAL.    

             END.        
            END.


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
  DISPLAY F-Orden F-fecha 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-62 RECT-60 F-Orden F-fecha Btn_Cancel Btn_Genera Btn_OK 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Liquidacion W-Win 
PROCEDURE Genera-Liquidacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 

  RUN Crea-Tempo-Prod.
  RUN Crea-Tempo-Alm.
  RUN Crea-Tempo-Merma.
  RUN Crea-Tempo-Horas-3.
  RUN Crea-Tempo-Gastos.

    FOR EACH T-Prod:
        X-CANTI = X-CANTI + T-Prod.CanRea .
    END.
    
    FOR EACH T-Alm:
        X-CTOMAT = X-CTOMAT + T-Alm.Total.
    END.

    FOR EACH T-Horas:
        X-CTOHOR = X-CTOHOR + T-Horas.TotHor.
    END.
    FOR EACH T-Gastos:
        X-CTOSER = X-CTOSER + T-Gastos.Total.
    END.

    X-CTOFAB = PR-CFGPRO.Factor * X-CTOHOR . 
    X-CTOTOT = X-CTOMAT + X-CTOHOR + X-CTOSER + X-CTOFAB.
    X-FACFAB = IF X-CTOFAB > 0 THEN PR-CFGPRO.Factor ELSE 0.
    X-UNIMAT = X-CTOMAT / X-CANTI.
    X-UNIHOR = X-CTOHOR / X-CANTI.
    X-UNISER = X-CTOSER / X-CANTI.
    X-UNIFAB = X-CTOFAB / X-CANTI.
    X-PREUNI = X-CTOTOT / X-CANTI.
    
  DEFINE FRAME F-Deta
         T-Prod.CodMat  COLUMN-LABEL "Articulo"         
         Almmmatg.DesMat   FORMAT "X(45)" COLUMN-LABEL "Descripcion"
         Almmmatg.Desmar   FORMAT "X(15)" COLUMN-LABEL "Marca"
         T-Prod.UndBas     FORMAT "X(6)"  COLUMN-LABEL "Unidad"
         T-Prod.CanRea   COLUMN-LABEL "Cantidad!Procesada"
         T-Prod.PreCio   COLUMN-LABEL "Precio!Unitario"
         T-Prod.Total    COLUMN-LABEL "Importe!Total"
         WITH NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  DEFINE FRAME F-Deta1
         T-Alm.codmat COLUMN-LABEL "Articulo"         
         Almmmatg.DesMat   FORMAT "X(45)" COLUMN-LABEL "Descripcion"
         Almmmatg.Desmar   FORMAT "X(15)" COLUMN-LABEL "Marca"
         T-Alm.UndBas   FORMAT "X(6)"  COLUMN-LABEL "Unidad"
         T-Alm.CanRea   COLUMN-LABEL "Cantidad!Procesada"
         T-Alm.PreCio   COLUMN-LABEL "Precio!Unitario"
         T-Alm.Total   COLUMN-LABEL "Importe!Total"
         WITH NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  DEFINE FRAME F-Deta2
         T-Horas.Codper  COLUMN-LABEL "Codigo"
         T-Horas.DesPer  COLUMN-LABEL "Nombre"
         T-Horas.TotMin  COLUMN-LABEL "Horas!Laboradas" FORMAT ">,>>>9.99"
         T-Horas.TotHor  COLUMN-LABEL "Importe!Total"
         WITH  NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  DEFINE FRAME F-Deta3
         T-Gastos.CodPro  COLUMN-LABEL "Codigo!Proveedor"
         X-NOMPRO         COLUMN-LABEL "Nombre o Razon Social"
         T-Gastos.CodGas  COLUMN-LABEL "Codigo!Gas/Ser"
         X-NOMGAS         COLUMN-LABEL "Descripcion"
         T-Gastos.Total   COLUMN-LABEL "Importe!Total"
         WITH  NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  DEFINE FRAME F-Deta4
         T-Merm.codmat COLUMN-LABEL "Articulo"         
         Almmmatg.DesMat   FORMAT "X(45)" COLUMN-LABEL "Descripcion"
         Almmmatg.Desmar   FORMAT "X(15)" COLUMN-LABEL "Marca"
         T-Merm.UndBas     FORMAT "X(6)"  COLUMN-LABEL "Unidad"
         T-Merm.CanRea    COLUMN-LABEL "Cantidad!Obtenida"
         WITH NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  DEFINE FRAME F-Orden
         HEADER
         S-NOMCIA FORMAT "X(25)" 
         "PRE-LIQUIDACION DE ORDEN DE PRODUCCION" AT 30 FORMAT "X(45)"
         "ORDEN       No. : " AT 80 F-Orden AT 100 SKIP
         "Fecha Emision   : "   AT 80 TODAY FORMAT "99/99/9999" AT 100 SKIP
         "Periodo Liquidado : "  X-FECINI FORMAT "99/99/9999" " Al " X-FECFIN FORMAT "99/99/9999" 
         "Moneda          : " AT 80 PR-ODPC.CodMon AT 100 SKIP
         "Articulo      : " /*PR-LIQC.CodArt  X-DESART           */
         "Tipo/Cambio   : " AT 80 Gn-Tcmb.Venta  AT 100 SKIP
         "Cantidad      : " X-CANTI SKIP
         "Costo Material: " X-CTOMAT
         "Costo Uni Material      : " AT 60 X-UNIMAT AT 90 SKIP
         "Mano/Obra Dire: " X-CTOHOR
         "Costo Uni Mano/Obra Dire: " AT 60 X-UNIHOR AT 90 SKIP        
         "Servicios     : " X-CTOSER
         "Costo Uni Servicios     : " AT 60 X-UNISER AT 90 SKIP         
         "Gastos/Fabric.: " X-CTOFAB              
         "Costo Uni Gastos/Fabric.: " AT 60 X-UNIFAB AT 90 SKIP         
         "Factor Gas/Fab: " X-FACFAB FORMAT "->>9.99"  
         "Costo Unitario Producto : "  AT 60 X-PREUNI AT 90 SKIP
         "------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         
         
/*
  OUTPUT STREAM Reporte TO PRINTER .
  PUT STREAM Reporte {&PRN0} + {&PRN5A} + CHR(33) + {&PRN3}.     
*/ 
  VIEW STREAM REPORT FRAME F-ORDEN.

  FOR EACH T-Prod BREAK BY T-Prod.Codcia:
      FIND Almmmatg WHERE Almmmatg.CodCia = T-Prod.CodCia AND
                          Almmmatg.CodMat = T-Prod.CodMat NO-LOCK NO-ERROR.
      IF FIRST-OF(T-Prod.Codcia) THEN DO:
         PUT STREAM Report "P R O D U C T O    T E R M I N A D O " SKIP.
         PUT STREAM Report "-------------------------------------" SKIP.      
      END.
 
     
      DISPLAY STREAM Report 
         T-Prod.CodMat
         Almmmatg.DesMat   FORMAT "X(50)"
         Almmmatg.Desmar   FORMAT "X(15)"
         T-Prod.UndBas 
         T-Prod.CanRea 
         T-Prod.PreCio
         T-Prod.Total 
      WITH FRAME F-Deta.
      DOWN STREAM Report WITH FRAME F-Deta.  


  END.


  FOR EACH T-Alm BREAK BY T-Alm.Codcia:
      FIND Almmmatg WHERE Almmmatg.CodCia = T-Alm.CodCia AND
                          Almmmatg.CodMat = T-Alm.CodMat NO-LOCK NO-ERROR.
      IF FIRST-OF(T-ALm.Codcia) THEN DO:
         PUT STREAM Report "M A T E R I A L E S   D I R E C T O S" SKIP.
         PUT STREAM Report "-------------------------------------" SKIP.      
      END.
 
      ACCUM  T-Alm.ToTal ( TOTAL BY T-Alm.CodCia) .      

      X-TOTAL = X-TOTAL + T-Alm.Total.
      
      DISPLAY STREAM Report 
         T-Alm.codmat 
         Almmmatg.DesMat   FORMAT "X(50)"
         Almmmatg.Desmar   FORMAT "X(15)"
         T-Alm.UndBas 
         T-Alm.CanRea 
         T-Alm.PreCio
         T-Alm.Total 
      WITH FRAME F-Deta1.
      DOWN STREAM Report WITH FRAME F-Deta1.  

      IF LAST-OF(t-Alm.Codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            T-Alm.Total            
        WITH FRAME F-Deta1.
        
        DISPLAY STREAM REPORT
            ACCUM TOTAL BY T-Alm.Codcia T-Alm.Total @ T-Alm.Total 
            WITH FRAME F-Deta1.
      END.

  END.
  
  
  FOR EACH T-Gastos BREAK BY T-Gastos.Codcia:
      FIND Gn-Prov WHERE 
           Gn-Prov.Codcia = pv-codcia AND  
           Gn-Prov.CodPro = T-Gastos.CodPro         
           NO-LOCK NO-ERROR.
      IF AVAILABLE Gn-Prov THEN DO:
         X-NOMPRO = Gn-Prov.NomPro .
      END.

      FIND PR-Gastos WHERE 
           PR-Gastos.Codcia = S-CODCIA AND  
           PR-Gastos.CodGas = T-Gastos.CodGas         
           NO-LOCK NO-ERROR.
      IF AVAILABLE PR-Gastos THEN DO:
         X-NOMGAS = PR-Gastos.DesGas.
      END.

      IF FIRST-OF(T-Gastos.Codcia) THEN DO:
         PUT STREAM Report "S E R V I C I O   D E    T E R C E R O S" SKIP.
         PUT STREAM Report "----------------------------------------" SKIP.      
      END.

      ACCUM  T-Gastos.Total ( TOTAL BY T-Gastos.CodCia) .      
      X-TOTAL = X-TOTAL + T-Gastos.Total.
      
      DISPLAY STREAM Report 
         T-Gastos.codPro  
         X-NOMPRO         
         T-Gastos.CodGas  
         X-NOMGAS         
         T-Gastos.Total 
      WITH FRAME F-Deta3.
      DOWN STREAM Report WITH FRAME F-Deta3.  

      IF LAST-OF(T-Gastos.Codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            T-Gastos.Total            
        WITH FRAME F-Deta3.
        
        DISPLAY STREAM REPORT
            ACCUM TOTAL BY T-Gastos.Codcia T-Gastos.Total @ T-Gastos.Total 
            WITH FRAME F-Deta3.
      END.

  END.


  
  FOR EACH T-Horas NO-LOCK BREAK BY T-Horas.Codcia:
      FIND PL-PERS WHERE /*PL-PERS.CodCia = T-Horas.CodCia AND*/
                         PL-PERS.CodPer = T-Horas.CodPer
                         NO-LOCK NO-ERROR.
      X-DESPER = TRIM(PL-PERS.PatPer) + " " + TRIM(PL-PERS.MatPer) + " " + TRIM(PL-PERS.NomPer) .
      IF FIRST-OF(T-Horas.Codcia) THEN DO:
         PUT STREAM Report "M A N O   D E   O B R A   D I R E C T A" SKIP.
         PUT STREAM Report "---------------------------------------" SKIP.      
      END.

      ACCUM  T-Horas.TotHor ( TOTAL BY T-Horas.CodCia) .      
      X-TOTAL = X-TOTAL + T-Horas.TotHor.
      
      DISPLAY STREAM Report 
         T-Horas.codper 
         T-Horas.DesPer FORMAT "X(50)"
         T-Horas.TotMin 
         T-Horas.TotHor 
      WITH FRAME F-Deta2.
      DOWN STREAM Report WITH FRAME F-Deta2.  

      IF LAST-OF(T-Horas.Codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            T-Horas.TotHor            
        WITH FRAME F-Deta2.
        
        DISPLAY STREAM REPORT 
            ACCUM TOTAL BY T-Horas.Codcia T-Horas.TotHor @ T-Horas.TotHor 
            WITH FRAME F-Deta2.
      END.

  END.

  FOR EACH T-Merm BREAK BY T-Merm.Codcia:
      FIND Almmmatg WHERE Almmmatg.CodCia = T-Merm.CodCia AND
                          Almmmatg.CodMat = T-Merm.CodMat NO-LOCK NO-ERROR.
      IF FIRST-OF(T-Merm.Codcia) THEN DO:
         PUT STREAM Report "M E R M A S" SKIP.
         PUT STREAM Report "-----------" SKIP.      
      END.
 
      
      DISPLAY STREAM Report 
         T-Merm.codmat 
         Almmmatg.DesMat   FORMAT "X(50)"
         Almmmatg.Desmar   FORMAT "X(15)"
         T-Merm.UndBas 
         T-Merm.CanRea 
      WITH FRAME F-Deta4.
      DOWN STREAM Report WITH FRAME F-Deta4.  
  END.


 
HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Habilita W-Win 
PROCEDURE Habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ENABLE ALL EXCEPT  .    
END.

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

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM report TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Genera-Liquidacion.
        PAGE STREAM report.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inhabilita W-Win 
PROCEDURE Inhabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    DISABLE ALL.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa-Variables W-Win 
PROCEDURE Inicializa-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN F-fecha F-Orden.
END.

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
  /* Code placed here will execute AFTER standard behavior.    */
  
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN F-Fecha = TODAY.
     DISPLAY F-Fecha .      
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen W-Win 
PROCEDURE Resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME FC4-REP
          T-resume.codmat 
          T-resume.desmat FORMAT "X(35)" 
          T-resume.undbas FORMAT "X(5)"  
          T-resume.canrea FORMAT ">>,>>>,>>9.99" 
          T-resume.cansis FORMAT ">>,>>>,>>9.99" 
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME H-REP2
         HEADER
         "RESUMEN " AT 45 FORMAT "X(35)" 
         "---------------------------------------------------------------------------------------------------" SKIP
         " Articulo  Descripcion                        UM           Cantidad           Cantidad             " SKIP
         "                                                           Procesada       Requerida/Calculada     " SKIP
         "---------------------------------------------------------------------------------------------------" SKIP
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  VIEW STREAM REPORT FRAME H-REP2.


  FOR EACH T-resume:
    DISPLAY STREAM REPORT
            T-resume.codmat  
            T-resume.desmat 
            T-resume.undbas 
            T-resume.canrea 
            T-resume.cansis 
            WITH FRAME FC4-REP.      
  END.

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

