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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR S-DESALM AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

/* variables de impresion */
DEFINE VAR S-Moneda      AS CHAR FORMAT "X(32)"  INIT "".
DEFINE VAR S-Mon         AS CHAR FORMAT "X(4)"  INIT "".
DEFINE VAR S-Movimiento  AS CHAR FORMAT "X(40)" INIT "".
DEFINE VAR S-Procedencia AS CHAR FORMAT "X(55)" INIT "".
DEFINE VAR S-RUC         AS CHAR FORMAT "X(32)" INIT "".
DEFINE VAR S-Referencia1 AS CHAR FORMAT "X(16)" INIT "".
DEFINE VAR S-Referencia2 AS CHAR FORMAT "X(16)" INIT "".
DEFINE VAR S-Referencia3 AS CHAR FORMAT "X(16)" INIT "".
DEFINE VAR S-TOTAL       AS DECIMAL INIT 0.
DEFINE VAR S-Encargado   AS CHAR FORMAT "X(32)" INIT "".
DEFINE VAR S-Item        AS INTEGER INIT 0.
DEFINE VAR S-TOTPES AS DECIMAL.
DEFINE VAR I-NroSer AS INTEGER .
DEFINE VAR S-NroSer AS INTEGER .
DEFINE VAR C-DIRPRO AS CHAR FORMAT "X(60)" INIT "".
DEFINE VAR C-DESALM AS CHAR     NO-UNDO.
DEFINE VAR C-DIRALM AS CHAR FORMAT "X(60)" INIT "".
DEFINE VAR F-NOMPRO AS CHAR FORMAT "X(50)" INIT "".
DEFINE VAR F-DIRTRA AS CHAR FORMAT "X(50)" INIT "".
DEFINE VAR F-RUCTRA AS CHAR FORMAT "X(8)"  INIT "". 

DEFINE STREAM Reporte.

FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
     Almacen.CodAlm = S-CODALM NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN S-Encargado = Almacen.EncAlm.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-Fecha-1 FILL-IN-Fecha-2 ~
FILL-IN-NroLiq-1 FILL-IN-NroLiq-2 BUTTON-2 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Fecha-1 FILL-IN-Fecha-2 ~
FILL-IN-NroLiq-1 FILL-IN-NroLiq-2 

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
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/print.ico":U
     LABEL "Button 2" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroLiq-1 AS CHARACTER FORMAT "X(6)":U 
     LABEL "# Liquidación desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroLiq-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     FILL-IN-Fecha-1 AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-Fecha-2 AT ROW 1.27 COL 42 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-NroLiq-1 AT ROW 2.35 COL 19 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-NroLiq-2 AT ROW 2.35 COL 42 COLON-ALIGNED WIDGET-ID 16
     BUTTON-2 AT ROW 3.96 COL 11 WIDGET-ID 8
     BtnDone AT ROW 3.96 COL 26 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71 BY 5.35 WIDGET-ID 100.


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
         TITLE              = "IMPRESION DE LIQUIDACIONES BATCH"
         HEIGHT             = 5.35
         WIDTH              = 71
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

{src/bin/_prns.i}
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
ON END-ERROR OF wWin /* IMPRESION DE LIQUIDACIONES BATCH */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* IMPRESION DE LIQUIDACIONES BATCH */
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


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 wWin
ON CHOOSE OF BUTTON-2 IN FRAME fMain /* Button 2 */
DO:
  ASSIGN
      FILL-IN-Fecha-1 FILL-IN-Fecha-2 FILL-IN-NroLiq-1 FILL-IN-NroLiq-2.
  RUN Imprimir.
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
  DISPLAY FILL-IN-Fecha-1 FILL-IN-Fecha-2 FILL-IN-NroLiq-1 FILL-IN-NroLiq-2 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE FILL-IN-Fecha-1 FILL-IN-Fecha-2 FILL-IN-NroLiq-1 FILL-IN-NroLiq-2 
         BUTTON-2 BtnDone 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-4 wWin 
PROCEDURE Formato-4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE FRAME F-FMT
         S-Item             AT  1   FORMAT "ZZ9"
         Almdmov.CodMat     AT  6   FORMAT "X(6)"
         Almmmatg.DesMat    AT  14  FORMAT "X(50)"
         Almmmatg.Desmar    AT  65  FORMAT "X(15)"
         Almdmov.CodUnd     AT  82  FORMAT "X(4)"          
         Almmmatg.CanEmp    AT  88  FORMAT ">>,>>9.99"
         Almdmov.CanDes     AT  99  FORMAT ">>>,>>9.99" 
         "__________"       AT  111  
         Almmmate.CodUbi    AT  125 FORMAT "X(6)"
         HEADER
         {&Prn6a} + S-NOMCIA + {&Prn6b} FORMAT "X(45)" SKIP
         "( " + Almacen.Descripcion + " )" FORMAT "X(50)" 
         S-Movimiento  AT 52  /*"Pag. " AT 108 PAGE-NUMBER(REPORTE) FORMAT ">>9"*/ SKIP
         "( PRE - DESPACHO )" AT 58 SKIP
         "Nro Documento : " AT 105 Almcmov.Nroser AT 121 "-" AT 124 Almcmov.NroDoc AT 125 SKIP         
         S-PROCEDENCIA AT 1 FORMAT "X(70)" 
         "Fecha : " AT 113 Almcmov.FchDoc AT 121 SKIP
         S-Referencia1 AT 1 ": " Almcmov.NroRf1  AT 20 
         "Almacen Salida  : " AT 79 Almcmov.CODALM AT 99       
         "Hora  : " AT 113 Almcmov.HorRcp AT 121 SKIP 
         "Observaciones    : " AT 1 Almcmov.Observ  AT 20 "Responsable     : " AT 79 S-Encargado AT 99 SKIP
         "-----------------------------------------------------------------------------------------------------------------------------------" SKIP
         "ITEM CODIGO                DESCRIPCION                             M A R C A     UND.    EMPAQUE    CANTIDAD  DESPACHADO  UBICACION" SKIP
         "-----------------------------------------------------------------------------------------------------------------------------------" SKIP
/*           99  999999 12345678901234567890123456789012345678901234567890 123456789012345  81                                       
               6      13                                                  65 */
         WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         
         
  OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 30.
  FIND FIRST Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia AND
             Almdmov.CodAlm = Almcmov.CodAlm AND
             Almdmov.TipMov = Almcmov.TipMov AND
             Almdmov.CodMov = Almcmov.CodMov AND
             Almdmov.NroDoc = Almcmov.NroDoc USE-INDEX Almd01 NO-LOCK NO-ERROR.
  IF AVAILABLE Almdmov THEN DO:
     PUT STREAM Reporte CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN3}.     
     REPEAT WHILE  AVAILABLE  AlmDMov      AND Almdmov.CodAlm = Almcmov.CodAlm AND
           Almdmov.TipMov = Almcmov.TipMov AND Almdmov.CodMov = Almcmov.CodMov AND
           Almdmov.NroDoc = Almcmov.NroDoc:
           FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia AND
                Almmmatg.CodMat = Almdmov.CodMat NO-LOCK NO-ERROR.
           FIND Almmmate WHERE Almmmate.Codcia = Almdmov.CodCia AND
                Almmmate.CodAlm = Almacen.CODALM AND
                Almmmate.CodMat = Almdmov.CodMat NO-LOCK NO-ERROR.
           S-Item = S-Item + 1.     
           DISPLAY STREAM Reporte 
                   S-Item 
                   Almdmov.CodMat 
                   Almdmov.CanDes 
                   Almdmov.CodUnd 
                   Almmmatg.ArtPro 
                   Almmmatg.DesMat 
                   Almmmatg.CanEmp
                   Almmmate.CodUbi
                   Almmmatg.Desmar WITH FRAME F-FMT.
           DOWN STREAM Reporte WITH FRAME F-FMT.
           FIND NEXT Almdmov USE-INDEX Almd01.
     END.
  END.
  DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 4 :
     PUT STREAM Reporte "" skip.
  END.
  PUT STREAM Reporte "    -----------------            -----------------             -----------------       "  AT 10 SKIP.
  PUT STREAM Reporte "        Operador                    Despachador                     Vo. Bo.            "  AT 10 SKIP.
  PUT STREAM Reporte  Almcmov.usuario AT 18 "JEFE ALMACEN         "  AT 75 SKIP.
  PUT STREAM Reporte " ** ALMACEN ** " AT 121 SKIP.
  OUTPUT STREAM Reporte CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-C wWin 
PROCEDURE Formato-C :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  S-TOTAL = 0.
  DEFINE VAR F-MONEDA AS CHAR FORMAT "X(4)".
  
  DEFINE FRAME F-FMT
         Almmmatg.Artpro FORMAT "X(09)"
         Almdmov.CodMat     FORMAT "X(6)"
         Almdmov.CanDes     FORMAT ">>>,>>9.99" 
         Almdmov.CodUnd     FORMAT "X(4)" 
         Almmmatg.DesMat    FORMAT "X(47)"
         Almmmatg.Desmar    FORMAT "X(20)"
         F-MONEDA           FORMAT "X(4)" 
         Almdmov.Prelis     FORMAT ">>,>>>.9999"
         Almdmov.ImpMn1     FORMAT ">,>>>,>>9.99"
         HEADER
         {&Prn6a} + S-NOMCIA + {&prn6b} FORMAT "X(45)" SKIP
         "INGRESO No. : " AT 96 Almcmov.NroDoc AT 114 SKIP
         "( " + Almcmov.CODALM + " )" AT 5 FORMAT "X(20)" 
         S-Movimiento  AT 52  "Pag. " AT 108 PAGE-NUMBER(Reporte) FORMAT ">>9" SKIP(1)
         S-PROCEDENCIA AT 1 FORMAT "X(70)" S-RUC AT 79 "Fecha : " AT 113 Almcmov.FchDoc AT 121 SKIP
         S-Referencia2 AT 1 ": " Almcmov.NroRf2  AT 20 "Almacen Ingreso : " AT 79 Almcmov.CODALM AT 99 "Hora  : " AT 113 Almcmov.HorRcp AT 121 SKIP 
         S-Referencia1 AT 1 ": " Almcmov.NroRf1  AT 20 S-MONEDA AT 79  "Tpo.Cam : " AT 113 Almdmov.TpoCmb AT 123 FORMAT ">>9.9999" SKIP
         "Observaciones    : " AT 1 Almcmov.Observ  AT 20 "Responsable     : " AT 79 S-Encargado AT 99 SKIP
         "-----------------------------------------------------------------------------------------------------------------------------------" SKIP
         "Cod.Pro.  CODIGO  CANTIDAD  UND.              DESCRIPCION                        M A R C A            MON  VALOR VENTA  IMPORTE S/." SKIP
         "-----------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.

  OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 30.
  FIND FIRST Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia AND
                           Almdmov.CodAlm = Almcmov.CodAlm AND
                           Almdmov.TipMov = Almcmov.TipMov AND
                           Almdmov.CodMov = Almcmov.CodMov AND
                           Almdmov.NroDoc = Almcmov.NroDoc USE-INDEX Almd01 NO-LOCK NO-ERROR.

  IF AVAILABLE Almdmov THEN DO:  
     PUT STREAM Reporte CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN3}.  
     REPEAT WHILE  AVAILABLE  AlmDMov AND 
                   Almdmov.CodAlm = Almcmov.CodAlm AND
                   Almdmov.TipMov = Almcmov.TipMov AND 
                   Almdmov.CodMov = Almcmov.CodMov AND
                   Almdmov.NroDoc = Almcmov.NroDoc:

           FIND FIRST Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia AND
                      Almmmatg.CodMat = Almdmov.CodMat NO-LOCK NO-ERROR.
                S-TOTAL = S-TOTAL + Almdmov.ImpMn1.
            
           IF ALMDMOV.CODMON = 1 THEN F-MONEDA = "S/.".
           ELSE F-MONEDA = "US$.".                 
           DISPLAY stream Reporte
                   Almdmov.CodMat 
                   Almdmov.CanDes 
                   Almdmov.CodUnd 
                   Almmmatg.ArtPro 
                   Almmmatg.DesMat 
                   Almmmatg.Desmar
                   F-MONEDA
                   Almdmov.Prelis
                   Almdmov.ImpMn1
                   WITH FRAME F-FMT.
           FIND NEXT Almdmov USE-INDEX Almd01.
     END.
     PUT STREAM Reporte "------------" AT 120 skip.
     PUT STREAM Reporte S-TOTAL FORMAT ">,>>>,>>9.99" AT 120 SKIP.     
  END.
  DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 6 :
     PUT STREAM Reporte "" skip.
  END.
  PUT STREAM Reporte "    -----------------       -----------------       -----------------      -----------------"  AT 10 SKIP.
  PUT STREAM Reporte "        Operador                 Vo. Bo.                  Vo. Bo.               Vo. Bo.     "  AT 10 SKIP.
  PUT STREAM Reporte Almcmov.usuario AT 18 "JEFE ALMACEN             CONTABILIDAD            GERENCIA     "  AT 40 SKIP.
  PUT STREAM Reporte " ** CONTABILIDAD ** " AT 119 SKIP.

  OUTPUT STREAM Reporte CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime_FR wWin 
PROCEDURE Imprime_FR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF almcmov.Codmon = 1 THEN DO:
     S-Moneda = "Compra en       :   SOLES".
     S-Mon    = "S/.".
  END.
  ELSE DO:
     S-Moneda = "Compra en       :   DOLARES".
     S-Mon    = "US$.".
  END.
     
       
  FIND FIRST Almtmovm WHERE  Almtmovm.CodCia = Almcmov.CodCia AND
             Almtmovm.Tipmov = Almcmov.TipMov AND 
             Almtmovm.Codmov = Almcmov.CodMov NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm THEN DO:
     S-Movimiento = Almcmov.TipMov + STRING(Almcmov.CodMov,"99") + "-" + CAPS(Almtmovm.Desmov).
     IF Almtmovm.PidCli THEN DO:
        FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
             gn-clie.CodCli = Almcmov.CodCli NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-clie THEN 
           FIND gn-clie WHERE gn-clie.CodCia = Almcmov.CodCia AND 
                gn-clie.CodCli = Almcmov.CodCli NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN S-Procedencia = "Cliente          : " + gn-clie.NomCli.
           S-RUC = "R.U.C.          :   " + Almcmov.CodCli.
                                        
     END.
     IF Almtmovm.PidPro THEN DO:
        FIND gn-prov WHERE gn-prov.CodCia = cl-codcia AND 
             gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-prov THEN 
          FIND gn-prov WHERE gn-prov.CodCia = Almcmov.CodCia AND 
               gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN S-Procedencia = "Proveedor        : " + gn-prov.NomPro.
          S-RUC = "R.U.C.          :   " + Almcmov.CodPro.

     END.
     IF Almtmovm.Movtrf THEN DO:
        S-Moneda = "".
        FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
             Almacen.CodAlm = Almcmov.AlmDes NO-LOCK NO-ERROR.
        IF AVAILABLE Almacen THEN DO:
           IF Almcmov.TipMov = "I" THEN
              S-Procedencia = "Procedencia      : " + Almcmov.AlmDes + " - " + Almacen.Descripcion.
           ELSE 
              S-Procedencia = "Destino          : " + Almcmov.AlmDes + " - " + Almacen.Descripcion.   
           END.            
     END.   
     IF Almtmovm.PidRef1 THEN ASSIGN S-Referencia1 = Almtmovm.GloRf1.
     IF Almtmovm.PidRef2 THEN ASSIGN S-Referencia2 = Almtmovm.GloRf2.
  END.

  IF Almcmov.TipMov = "I" THEN RUN Formato-C.
  IF Almcmov.TipMov = "S" THEN RUN Formato-4.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir wWin 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE answer AS LOGICAL NO-UNDO.
SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
IF answer = NO THEN RETURN.

DEF VAR i-CuentaHojas AS INT.

/* Impresion de Liquidaciones y los sustentos */
FOR EACH PR-LIQC WHERE PR-LIQC.Codcia = S-CODCIA 
    AND PR-LIQC.FchLiq >= FILL-IN-Fecha-1
    AND PR-LIQC.FchLiq <= FILL-IN-Fecha-2
    AND (FILL-IN-NroLiq-1 = '' OR PR-LIQC.NumLiq >= FILL-IN-NroLiq-1)
    AND (FILL-IN-NroLiq-2 = '' OR PR-LIQC.NumLiq <= FILL-IN-NroLiq-2)
    AND PR-LIQC.flgest <> 'A' NO-LOCK,
    FIRST PR-ODPC NO-LOCK WHERE PR-ODPC.codcia = s-codcia
    AND PR-ODPC.NumOrd = PR-LIQC.NumOrd:
    RUN R-IMPLIQOP.     /* Liquidaciones */
    i-CuentaHojas = 0.
    FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = s-codcia
        AND Almcmov.codalm = PR-ODPC.codalm
        AND Almcmov.tipmov = 'I'
        AND Almcmov.codmov = 50
        AND Almcmov.codref = "OP"
        AND Almcmov.nroref = PR-ODPC.numord
        AND Almcmov.fchdoc >= PR-LIQC.FecIni
        AND Almcmov.fchdoc <= PR-LIQC.FecFin
        AND Almcmov.flgest <> "A",
        FIRST Almacen OF Almcmov NO-LOCK:
        RUN Imprime_FR.     /* I50 Ingresos de productos terminados */
        i-CuentaHojas = i-CuentaHojas + 1.
    END.
    FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = s-codcia
        AND Almcmov.codalm = PR-ODPC.codalm
        AND Almcmov.tipmov = 'S'
        AND Almcmov.codmov = 50
        AND Almcmov.codref = "OP"
        AND Almcmov.nroref = PR-ODPC.numord
        AND Almcmov.fchdoc >= PR-LIQC.FecIni
        AND Almcmov.fchdoc <= PR-LIQC.FecFin
        AND Almcmov.flgest <> "A",
        FIRST Almacen OF Almcmov NO-LOCK:
        RUN Imprime_FR.     /* S50 Consumo de materiales */
        i-CuentaHojas = i-CuentaHojas + 1.
    END.
    IF ( i-CuentaHojas MODULO 2 ) > 0 THEN DO:  
        /* Saltar 1/2 hoja */
        OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 30.
        PUT STREAM Reporte CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN3}.  
        PAGE STREAM REPORTE.
        OUTPUT STREAM Reporte CLOSE.
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN
      FILL-IN-Fecha-1 = TODAY - DAY(TODAY) + 1
      FILL-IN-Fecha-2 = TODAY.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE R-IMPLIQOP wWin 
PROCEDURE R-IMPLIQOP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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

X-UNIMAT = PR-LIQC.CtoMat / PR-LIQC.CanFin.
X-UNIFAB = PR-LIQC.CtoFab / PR-LIQC.CanFin.
X-UNISER = PR-LIQC.CtoGas / PR-LIQC.CanFin.
X-UNIHOR = PR-LIQC.CtoHor / PR-LIQC.CanFin.

FIND Almmmatg WHERE Almmmatg.CodCia = PR-LIQC.CodCia AND
                    Almmmatg.CodMat = PR-LIQC.CodArt NO-LOCK NO-ERROR.
IF AVAILABLE Almmmatg THEN X-DESART = Almmmatg.DesMat.

X-CODMON = IF PR-LIQC.CodMon = 1 THEN "S/." ELSE "US$".

  DEFINE FRAME F-Deta
         PR-LIQCX.CodArt  COLUMN-LABEL "Articulo"         
         Almmmatg.DesMat   FORMAT "X(45)" COLUMN-LABEL "Descripcion"
         Almmmatg.Desmar   FORMAT "X(15)" COLUMN-LABEL "Marca"
         PR-LIQCX.CodUnd   FORMAT "X(6)"  COLUMN-LABEL "Unidad"
         PR-LIQCX.CanFin   COLUMN-LABEL "Cantidad!Procesada"
         PR-LIQCX.PreUni   COLUMN-LABEL "Precio!Unitario"
         PR-LIQCX.CtoTot   COLUMN-LABEL "Importe!Total"
         WITH NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  DEFINE FRAME F-Deta1
         PR-LIQD1.codmat COLUMN-LABEL "Articulo"         
         Almmmatg.DesMat   FORMAT "X(45)" COLUMN-LABEL "Descripcion"
         Almmmatg.Desmar   FORMAT "X(15)" COLUMN-LABEL "Marca"
         PR-LIQD1.CodUnd   FORMAT "X(6)"  COLUMN-LABEL "Unidad"
         PR-LIQD1.CanDes   COLUMN-LABEL "Cantidad!Procesada"
         PR-LIQD1.PreUni   COLUMN-LABEL "Precio!Unitario"
         PR-LIQD1.ImpTot   COLUMN-LABEL "Importe!Total"
         WITH NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  DEFINE FRAME F-Deta2
         PR-LIQD2.codper  COLUMN-LABEL "Codigo"
         X-DESPER         COLUMN-LABEL "Nombre"
         PR-LIQD2.Horas   COLUMN-LABEL "Horas!Laboradas" FORMAT ">>>9.99"
         PR-LIQD2.HorVal  COLUMN-LABEL "Importe!Total"
         WITH  NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  DEFINE FRAME F-Deta3
         PR-LIQD3.codPro  COLUMN-LABEL "Codigo!Proveedor"
         X-NOMPRO         COLUMN-LABEL "Nombre o Razon Social"
         PR-LIQD3.CodGas  COLUMN-LABEL "Codigo!Gas/Ser"
         X-NOMGAS         COLUMN-LABEL "Descripcion"
         PR-LIQD3.ImpTot  COLUMN-LABEL "Importe!Total"
         WITH  NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  DEFINE FRAME F-Deta4
         PR-LIQD4.codmat COLUMN-LABEL "Articulo"         
         Almmmatg.DesMat   FORMAT "X(45)" COLUMN-LABEL "Descripcion"
         Almmmatg.Desmar   FORMAT "X(15)" COLUMN-LABEL "Marca"
         PR-LIQD4.CodUnd   FORMAT "X(6)"  COLUMN-LABEL "Unidad"
         PR-LIQD4.CanDes   COLUMN-LABEL "Cantidad!Obtenida"
         WITH NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  DEFINE FRAME F-Orden
         HEADER
         S-NOMCIA FORMAT "X(25)" 
         "LIQUIDACION DE ORDEN DE PRODUCCION" AT 30 FORMAT "X(45)"
         "LIQUIDACION No. : " AT 80 PR-LIQC.NumLiq AT 100 SKIP
         "ORDEN       No. : " AT 80 PR-LIQC.Numord AT 100 SKIP
         "Fecha Emision   : "   AT 80 PR-LIQC.FchLiq FORMAT "99/99/9999" AT 100 SKIP
         "Periodo Liquidado : "  PR-LIQC.FecIni FORMAT "99/99/9999" " Al " PR-LIQC.FecFin FORMAT "99/99/9999" 
         "Moneda          : " AT 80 X-CODMON AT 100 SKIP
         "Articulo      : " /*PR-LIQC.CodArt  X-DESART  */
         "Tipo/Cambio   : " AT 80 PR-LIQC.TpoCmb AT 100 SKIP
         "Cantidad      : " PR-LIQC.CanFin PR-LIQC.CodUnd SKIP
         "Costo Material: " PR-LIQC.CtoMat 
         "Costo Uni Material      : " AT 60 X-UNIMAT AT 90 SKIP
         "Mano/Obra Dire: " PR-LIQC.CtoHor 
         "Costo Uni Mano/Obra Dire: " AT 60 X-UNIHOR AT 90 SKIP        
         "Servicios     : " PR-LIQC.CtoGas 
         "Costo Uni Servicios     : " AT 60 X-UNISER AT 90 SKIP         
         "Gastos/Fabric.: " PR-LIQC.CtoFab                   
         "Costo Uni Gastos/Fabric.: " AT 60 X-UNIFAB AT 90 SKIP         
         "Factor Gas/Fab: " PR-LIQC.Factor FORMAT "->>9.99"        
         "Costo Unitario Producto : " AT 60 PR-LIQC.PreUni AT 90 SKIP
         "Observaciones : " SUBSTRING(PR-LIQC.Observ[1],1,60) FORMAT "X(60)"  
         "------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         
 
  OUTPUT STREAM REPORTE TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
  PUT STREAM REPORTE CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN3}.

  VIEW STREAM REPORTE FRAME F-ORDEN.

  FOR EACH PR-LIQCX OF PR-LIQC NO-LOCK BREAK BY PR-LIQCX.Codcia:
      FIND Almmmatg WHERE Almmmatg.CodCia = PR-LIQCX.CodCia AND
                          Almmmatg.CodMat = PR-LIQCX.CodArt NO-LOCK NO-ERROR.
      IF FIRST-OF(PR-LIQCX.Codcia) THEN DO:
         PUT STREAM REPORTE "P R O D U C T O    T E R M I N A D O " SKIP.
         PUT STREAM REPORTE "-------------------------------------" SKIP.      
      END.
 
     
      DISPLAY STREAM REPORTE
         PR-LIQCX.CodArt 
         Almmmatg.DesMat   FORMAT "X(50)"
         Almmmatg.Desmar   FORMAT "X(15)"
         PR-LIQCX.CodUnd 
         PR-LIQCX.CanFin 
         PR-LIQCX.PreUni
         PR-LIQCX.CtoTot 
      WITH FRAME F-Deta.
      DOWN STREAM REPORTE WITH FRAME F-Deta.  


  END.


  FOR EACH PR-LIQD1 OF PR-LIQC NO-LOCK BREAK BY PR-LIQD1.Codcia:
      FIND Almmmatg WHERE Almmmatg.CodCia = PR-LIQD1.CodCia AND
                          Almmmatg.CodMat = PR-LIQD1.CodMat NO-LOCK NO-ERROR.
      IF FIRST-OF(PR-LIQD1.Codcia) THEN DO:
         PUT STREAM REPORTE "M A T E R I A L E S   D I R E C T O S" SKIP.
         PUT STREAM REPORTE "-------------------------------------" SKIP.      
      END.
 
      ACCUM  PR-LIQD1.ImpTot ( TOTAL BY PR-LIQD1.CodCia) .      

      X-TOTAL = X-TOTAL + PR-LIQD1.ImpTot.
      
      DISPLAY STREAM REPORTE 
         PR-LIQD1.codmat 
         Almmmatg.DesMat   FORMAT "X(50)"
         Almmmatg.Desmar   FORMAT "X(15)"
         PR-LIQD1.CodUnd 
         PR-LIQD1.CanDes 
         PR-LIQD1.PreUni
         PR-LIQD1.ImpTot 
      WITH FRAME F-Deta1.
      DOWN STREAM REPORTE WITH FRAME F-Deta1.  

      IF LAST-OF(PR-LIQD1.Codcia) THEN DO:
        UNDERLINE STREAM REPORTE 
            PR-LIQD1.ImpTot            
        WITH FRAME F-Deta1.
        
        DISPLAY STREAM REPORTE 
            ACCUM TOTAL BY PR-LIQD1.Codcia PR-LIQD1.ImpTot @ PR-LIQD1.ImpTot 
            WITH FRAME F-Deta1.
      END.

  END.
  
  
  FOR EACH PR-LIQD3 OF PR-LIQC NO-LOCK BREAK BY PR-LIQD3.Codcia:
      FIND Gn-Prov WHERE 
           Gn-Prov.Codcia = pv-codcia AND  
           Gn-Prov.CodPro = PR-LIQD3.CodPro         
           NO-LOCK NO-ERROR.
      IF AVAILABLE Gn-Prov THEN DO:
         X-NOMPRO = Gn-Prov.NomPro .
      END.

      FIND PR-Gastos WHERE 
           PR-Gastos.Codcia = S-CODCIA AND  
           PR-Gastos.CodGas = PR-LIQD3.CodGas         
           NO-LOCK NO-ERROR.
      IF AVAILABLE PR-Gastos THEN DO:
         X-NOMGAS = PR-Gastos.DesGas.
      END.

      IF FIRST-OF(PR-LIQD3.Codcia) THEN DO:
         PUT STREAM REPORTE "S E R V I C I O   D E    T E R C E R O S" SKIP.
         PUT STREAM REPORTE "----------------------------------------" SKIP.      
      END.

      ACCUM  PR-LIQD3.ImpTot ( TOTAL BY PR-LIQD3.CodCia) .      
      X-TOTAL = X-TOTAL + PR-LIQD3.ImpTot.
      
      DISPLAY STREAM REPORTE 
         PR-LIQD3.codPro  
         X-NOMPRO         
         PR-LIQD3.CodGas  
         X-NOMGAS         
         PR-LIQD3.ImpTot 
      WITH FRAME F-Deta3.
      DOWN STREAM REPORTE WITH FRAME F-Deta3.  

      IF LAST-OF(PR-LIQD3.Codcia) THEN DO:
        UNDERLINE STREAM REPORTE 
            PR-LIQD3.ImpTot            
        WITH FRAME F-Deta3.
        
        DISPLAY STREAM REPORTE 
            ACCUM TOTAL BY PR-LIQD3.Codcia PR-LIQD3.ImpTot @ PR-LIQD3.ImpTot 
            WITH FRAME F-Deta3.
      END.

  END.


  
  FOR EACH PR-LIQD2 OF PR-LIQC NO-LOCK BREAK BY PR-LIQD2.Codcia:
      FIND PL-PERS WHERE PL-PERS.CodCia = PR-LIQD2.CodCia AND
                         PL-PERS.CodPer = PR-LIQD2.CodPer
                         NO-LOCK NO-ERROR.
      X-DESPER = TRIM(PL-PERS.PatPer) + " " + TRIM(PL-PERS.MatPer) + " " + TRIM(PL-PERS.NomPer) .
      IF FIRST-OF(PR-LIQD2.Codcia) THEN DO:
         PUT STREAM REPORTE "M A N O   D E   O B R A   D I R E C T A" SKIP.
         PUT STREAM REPORTE "---------------------------------------" SKIP.      
      END.

      ACCUM  HorVal ( TOTAL BY PR-LIQD2.CodCia) .      
      X-TOTAL = X-TOTAL + HorVal.
      
      DISPLAY STREAM REPORTE 
         PR-LIQD2.codper 
         X-DESPER FORMAT "X(50)"
         PR-LIQD2.Horas 
         PR-LIQD2.HorVal 
      WITH FRAME F-Deta2.
      DOWN STREAM REPORTE WITH FRAME F-Deta2.  

      IF LAST-OF(PR-LIQD2.Codcia) THEN DO:
        UNDERLINE STREAM REPORTE 
            PR-LIQD2.HorVal            
        WITH FRAME F-Deta2.
        
        DISPLAY STREAM REPORTE 
            ACCUM TOTAL BY PR-LIQD2.Codcia PR-LIQD2.HorVal @ PR-LIQD2.HorVal 
            WITH FRAME F-Deta2.
      END.

  END.

  FOR EACH PR-LIQD4 OF PR-LIQC NO-LOCK BREAK BY PR-LIQD4.Codcia:
      FIND Almmmatg WHERE Almmmatg.CodCia = PR-LIQD4.CodCia AND
                          Almmmatg.CodMat = PR-LIQD4.CodMat NO-LOCK NO-ERROR.
      IF FIRST-OF(PR-LIQD4.Codcia) THEN DO:
         PUT STREAM REPORTE "M E R M A S" SKIP.
         PUT STREAM REPORTE "-----------" SKIP.      
      END.
 
      
      DISPLAY STREAM REPORTE 
         PR-LIQD4.codmat 
         Almmmatg.DesMat   FORMAT "X(50)"
         Almmmatg.Desmar   FORMAT "X(15)"
         PR-LIQD4.CodUnd 
         PR-LIQD4.CanDes 
      WITH FRAME F-Deta4.
      DOWN STREAM REPORTE WITH FRAME F-Deta4.  
  END.


  PUT STREAM REPORTE SKIP(4).
  PUT STREAM REPORTE "              ---------------------                       ---------------------             "  AT 10 SKIP.
  PUT STREAM REPORTE "                    Elaborado                                   Aprobado                    "  AT 10 SKIP.
  PUT STREAM REPORTE  PR-LIQC.Usuario  SKIP.

  PAGE STREAM REPORTE.
  OUTPUT STREAM REPORTE CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

