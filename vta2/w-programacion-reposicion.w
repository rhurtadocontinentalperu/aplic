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

DEFINE SHARED VAR s-codcia AS INT.
DEFINE VAR lFechaProceso AS DATE.

DEF TEMP-TABLE tt-factabla LIKE FacTabla.

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
&Scoped-Define ENABLED-OBJECTS txtAlmacen txtAlmacenes FILL-IN-1 btnProc 
&Scoped-Define DISPLAYED-OBJECTS txtAlmacen txtAlmacenes FILL-IN-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnProc 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtAlmacen AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen principal a abastecer" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE txtAlmacenes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacenes a consultar" 
     VIEW-AS FILL-IN 
     SIZE 55 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtAlmacen AT ROW 1.77 COL 31 COLON-ALIGNED WIDGET-ID 2
     txtAlmacenes AT ROW 3.12 COL 23 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-1 AT ROW 5.81 COL 25 COLON-ALIGNED WIDGET-ID 10
     btnProc AT ROW 8.31 COL 61 WIDGET-ID 8
     "Separado por comas (ejm. 11,85,04,etc)" VIEW-AS TEXT
          SIZE 36 BY .62 AT ROW 4.27 COL 31 WIDGET-ID 6
          FONT 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Reposicion de Mercaderia"
         HEIGHT             = 17
         WIDTH              = 80
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Reposicion de Mercaderia */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Reposicion de Mercaderia */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnProc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnProc wWin
ON CHOOSE OF btnProc IN FRAME fMain /* Procesar */
DO:
    ASSIGN txtAlmacen txtAlmacenes.

    IF txtAlmacen = "" OR txtAlmacenes = "" THEN DO:
        MESSAGE "Almacen Principal O Almacenes a Consultar estan ERRADOS" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
    END.

    RUN ue-procesar.

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
  DISPLAY txtAlmacen txtAlmacenes FILL-IN-1 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE txtAlmacen txtAlmacenes FILL-IN-1 btnProc 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-cargar-articulos wWin 
PROCEDURE ue-cargar-articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR lFiler AS INT.

EMPTY TEMP-TABLE tt-factabla.

FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.llave_c1 = "DISTRIB" 
    AND (vtatabla.llave_c2 <> "GLOBAL" AND vtatabla.llave_c2 <> "ORGPROD") NO-LOCK:
    /**/
    FIND FIRST tt-factabla WHERE tt-factabla.codigo = vtatabla.llave_c2 NO-LOCK NO-ERROR.   

    IF NOT AVAILABLE tt-factabla THEN DO:
        /**/
        CREATE tt-factabla.
            
        /* */
        REPEAT lFiler = 1 TO 20:
            ASSIGN tt-factabla.valor[lFiler]    = 0.00
                tt-factabla.campo-c[lFiler]     = "".

        END.

        /**/
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND almmmatg.codmat = vtatabla.llave_c2 NO-LOCK NO-ERROR.
        ASSIGN tt-factabla.codigo = vtatabla.llave_c2
                tt-factabla.campo-c[1] = IF (AVAILABLE almmmatg) THEN almmmatg.Chr__02 ELSE 'X'.
    END.
    ASSIGN tt-factabla.valor[1] = tt-factabla.valor[1] + vtatabla.valor[1]
            tt-factabla.valor[2] = tt-factabla.valor[2] + vtatabla.valor[2]
            tt-factabla.valor[3] = almmmatg.ctolis.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-fecha-proceso wWin 
PROCEDURE ue-fecha-proceso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

lFechaProceso = TODAY.

FIND RatioCab WHERE RatioCab.CodDIv = 'XXXXX' NO-LOCK NO-ERROR.
IF AVAILABLE RatioCab THEN DO:
    lFechaProceso = RatioCab.fproceso.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-gen-excel wWin 
PROCEDURE ue-gen-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.
DEFINE VAR lCosto AS DEC.

lFileXls = "".		/* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.	/* YES : Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

iColumn = 1.
cColumn = STRING(iColumn).

cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "CodArt".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "CodMarca".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion Marca".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Prod.Propios".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Prod.Terceros".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Importe".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Cant.Distrib.".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Impte.Distrib.".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "Cant.Produccion.".
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "Impte.Produccion.".
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = "Cant.Compras.".
cRange = "M" + cColumn.
chWorkSheet:Range(cRange):Value = "Impte.Compras.".


FOR EACH tt-factabla :

    lCosto = 1.
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia 
        AND almmmatg.codmat = tt-factabla.codigo NO-LOCK NO-ERROR.
    FIND FIRST almtabla WHERE almtabla.tabla = 'MK' AND
        almtabla.codigo = almmmatg.codmar NO-LOCK NO-ERROR.

    IF AVAILABLE almmmatg THEN DO:
        lCosto = almmmatg.ctolis.
        IF almmmatg.monvta = 2 THEN DO:
            /* Doalres */
            lCosto = lCosto * almmmatg.tpocmb.
        END.
    END.

    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-factabla.codigo.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + (IF (AVAILABLE almmmatg) THEN almmmatg.desmat ELSE "").
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + almmmatg.codmar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + (IF (AVAILABLE almtabla) THEN almtabla.nombre ELSE "").
    IF tt-factabla.campo-c[1] = "P" THEN DO:
        /* Prod.Propios */
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-factabla.valor[8] + tt-factabla.valor[9] + tt-factabla.valor[10].
    END.
    ELSE DO:
        /* Prod.Propios */
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-factabla.valor[8] + tt-factabla.valor[9] + tt-factabla.valor[10].
    END.    
    /* Impte */
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = ((tt-factabla.valor[8] + tt-factabla.valor[9] + tt-factabla.valor[10]) 
                                       * lCosto).
    /* Distribucion */
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-factabla.valor[8].
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = (tt-factabla.valor[8] * lCosto).

    /* Produccion */
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-factabla.valor[9].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = (tt-factabla.valor[9] * lCosto).

    /* Compras */
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-factabla.valor[10].
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = (tt-factabla.valor[10] * lCosto).

END.

{lib\excel-close-file.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-grabar wWin 
PROCEDURE ue-grabar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DISABLE TRIGGERS FOR LOAD OF factabla.

DEF BUFFER b-factabla FOR factabla.
DEFINE VAR lRowId AS ROWID.

/* Eliminar datos del proceso anterior */
FOR EACH factabla WHERE factabla.codcia = s-codcia AND factabla.tabla = 'REPEXPO' NO-LOCK:
    ASSIGN lRowId = ROWID(factabla).
    FIND b-factabla WHERE RowId(b-factabla) = lRowId EXCLUSIVE NO-ERROR.
    IF AVAILABLE b-factabla THEN DO:
        DELETE b-factabla.
    END.
END.

/* GRabo los nuevos datos */
FOR EACH tt-factabla WHERE tt-factabla.campo-c[2] <> "BORRAR" :
    CREATE factabla.
        BUFFER-COPY tt-factabla TO factabla.
        ASSIGN factabla.tabla = 'REPEXPO'
                factabla.codcia = s-codcia.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-procesar wWin 
PROCEDURE ue-procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
SESSION:SET-WAIT-STATE('GENERAL').

RUN ue-cargar-articulos.
RUN ue-fecha-proceso.
RUN ue-verifica-stock.
RUN ue-grabar.
RUN ue-gen-excel.

SESSION:SET-WAIT-STATE('').

MESSAGE "Proceso Concluido.." VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-verifica-stock wWin 
PROCEDURE ue-verifica-stock :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lStock AS DEC.
DEFINE VAR lSumaStock AS DEC.
DEFINE VAR lxAtender AS DEC.
DEFINE VAR alm AS CHAR.
DEFINE VAR lSec AS INT.
DEFINE VAR lSuma AS DEC.

DEFINE VAR lAlmAlimentadores AS CHAR.
DEFINE VAR lStkAlimentadores AS CHAR.
DEFINE VAR lAlmLosDemas AS CHAR.
DEFINE VAR lStkLosDemas AS CHAR.

lSumaStock = 0.

FOR EACH tt-factabla :  

    lAlmAlimentadores   = "".    
    lStkAlimentadores   = "".
    lAlmLosDemas        = "".
    lStkLosDemas        = "".
    lSumaStock          = 0.

    /* Cuanto hay x Atender */    
    lxAtender = tt-factabla.valor[1] - tt-factabla.valor[2].
    IF lxAtender > 0 THEN DO:
        /* Bsuco el Stock x el almacen principal */
        FIND almmmate WHERE almmmate.codcia = s-codcia AND almmmate.codalm = txtAlmacen
            AND almmmate.codmat = tt-factabla.codigo NO-LOCK NO-ERROR.
        lStock = if(AVAILABLE almmmate) THEN almmmate.stkact ELSE 0.    
        /* Actulizo , desde la posicion hacia adelante los almacenes con Stock*/
        tt-factabla.valor[5] = lStock.
        tt-factabla.campo-c[5] = txtAlmacen.

        /*  */
        lSumaStock = lSumaStock + lStock.

        /* Por los almacenes que abastecen al Principal */
        lSuma = 0.
        DO lSec = 1 TO NUM-ENTRIES(txtAlmacenes):
                Alm = ENTRY(lSec,txtAlmacenes,",").
            FIND almmmate WHERE almmmate.codcia = s-codcia AND almmmate.codalm = alm
                AND almmmate.codmat = tt-factabla.codigo NO-LOCK NO-ERROR.
            lStock = if(AVAILABLE almmmate) THEN almmmate.stkact ELSE 0.  
    

            IF lStock > 0 THEN DO:
                lSuma = lSuma + lStock.

                lAlmAlimentadores = lAlmAlimentadores + (IF(lAlmAlimentadores = "") THEN "" ELSE ",") + Alm.
                lStkAlimentadores = lStkAlimentadores + 
                    (IF(lStkAlimentadores = "") THEN "" ELSE ",") + STRING(lStock,">>,>>>,>>9.99").
    
                /*  */
                lSumaStock = lSumaStock + lStock.    
            END.
        END.
        tt-factabla.valor[6] = lSuma.
        tt-factabla.campo-c[6] = lAlmAlimentadores.
        tt-factabla.campo-c[7] = lStkAlimentadores.

    END.
    /* Si no hay stock suficiente en el almacen principal
        mas los almacenes alimentadores
        Verificamos en los demas almacenes comerciales de Continental.
     */
    
    lxAtender = (lxAtender - lSumaStock).

    IF lxAtender > 0 THEN DO:
        /* */
        lSuma = 0.
        FOR EACH almacen WHERE almacen.codcia = s-codcia AND CAPS(almacen.campo-c[6]) = 'SI' NO-LOCK:
            Alm = almacen.codalm.
            IF alm <> txtAlmacen AND lookup(alm,txtAlmacenes) = 0 THEN DO:
                FIND almmmate WHERE almmmate.codcia = s-codcia AND almmmate.codalm = alm
                    AND almmmate.codmat = tt-factabla.codigo NO-LOCK NO-ERROR.
                lStock = if(AVAILABLE almmmate) THEN almmmate.stkact ELSE 0.  

                IF lStock > 0 THEN DO:
                    lAlmLosDemas = lAlmLosDemas + (IF(lAlmLosDemas = "") THEN "" ELSE ",") + Alm.
                    lStkLosDemas = lStkLosDemas + 
                            (IF(lStkLosDemas = "") THEN "" ELSE ",") + STRING(lStock,">>,>>>,>>9.99").

                    /*  */
                    lSumaStock = lSumaStock + lStock.
                    lSuma = lSuma + lStock.
                END.
            END.
        END.
        ASSIGN tt-factabla.valor[7] = lStock
            tt-factabla.campo-c[8] = lAlmLosDemas
            tt-factabla.campo-c[9] = lStkLosDemas.

        IF tt-factabla.campo-c[1] = 'P' THEN DO:
            /* Propios */
            ASSIGN tt-factabla.valor[8] = IF(lSuma < lxAtender) THEN lSuma ELSE lxAtender
                tt-factabla.valor[9] = IF(lxAtender > lSuma) THEN (lxAtender - lSuma)  ELSE 0.
        END.
        ELSE DO:
            /* Teceros */
            ASSIGN tt-factabla.valor[8] = IF(lSuma < lxAtender) THEN lSuma ELSE lxAtender
                tt-factabla.valor[10] = IF(lxAtender > lSuma) THEN (lxAtender - lSuma)  ELSE 0.
        END.
    END.
    ELSE DO:
        ASSIGN tt-factabla.campo-c[2] = "BORRAR".
    END.
    
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

