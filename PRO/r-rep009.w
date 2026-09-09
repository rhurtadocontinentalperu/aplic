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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-TipMov COMBO-BOX-CodMov ~
FILL-IN-Fecha-1 FILL-IN-Fecha-2 BUTTON-2 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-TipMov COMBO-BOX-CodMov ~
FILL-IN-Fecha-1 FILL-IN-Fecha-2 

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

DEFINE VARIABLE COMBO-BOX-CodMov AS CHARACTER FORMAT "X(256)":U 
     LABEL "Movimiento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-TipMov AS CHARACTER FORMAT "X(256)":U INITIAL "Salida" 
     LABEL "Tipo de movimiento" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "Ingreso","Salida" 
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     COMBO-BOX-TipMov AT ROW 2.08 COL 29 COLON-ALIGNED WIDGET-ID 2
     COMBO-BOX-CodMov AT ROW 3.15 COL 29 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-Fecha-1 AT ROW 4.23 COL 29 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-Fecha-2 AT ROW 4.23 COL 52 COLON-ALIGNED WIDGET-ID 12
     BUTTON-2 AT ROW 6.12 COL 11 WIDGET-ID 8
     BtnDone AT ROW 6.12 COL 26 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 99.72 BY 7.31 WIDGET-ID 100.


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
         TITLE              = "IMPRESION DE FORMATOS - PRODUCCION"
         HEIGHT             = 7.31
         WIDTH              = 99.72
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
ON END-ERROR OF wWin /* IMPRESION DE FORMATOS - PRODUCCION */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* IMPRESION DE FORMATOS - PRODUCCION */
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
      COMBO-BOX-CodMov COMBO-BOX-TipMov FILL-IN-Fecha-1 FILL-IN-Fecha-2.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-TipMov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-TipMov wWin
ON VALUE-CHANGED OF COMBO-BOX-TipMov IN FRAME fMain /* Tipo de movimiento */
DO:
    DEF VAR j AS INT.

    FIND Pr-cfgpro WHERE codcia = s-codcia NO-LOCK.

    COMBO-BOX-CodMov:DELETE(COMBO-BOX-CodMov:LIST-ITEMS).
    DO j = 1 TO 4:
        IF Pr-cfgpro.tipmov[j] = SUBSTRING(COMBO-BOX-TipMov:SCREEN-VALUE,1,1) THEN DO:
            FIND almtmovm WHERE almtmovm.codcia = s-codcia
                AND almtmovm.tipmov = Pr-cfgpro.tipmov[j]
                AND almtmovm.codmov = Pr-cfgpro.codmov[j]
                NO-ERROR.
            IF COMBO-BOX-CodMov:LOOKUP(STRING(almtmovm.codmov, '99') + ' - ' + Almtmovm.Desmov) = 0
                THEN COMBO-BOX-CodMov:ADD-LAST(STRING(almtmovm.codmov, '99') + ' - ' + Almtmovm.Desmov).
        END.
    END.
    /* Agregamos las transferencia */
    FIND almtmovm WHERE almtmovm.codcia = s-codcia
        AND almtmovm.tipmov = SUBSTRING(COMBO-BOX-TipMov:SCREEN-VALUE,1,1)
        AND almtmovm.codmov = 03
        NO-ERROR.
    IF AVAILABLE almtmovm 
        THEN COMBO-BOX-CodMov:ADD-LAST(STRING(almtmovm.codmov, '99') + ' - ' + Almtmovm.Desmov).
    COMBO-BOX-CodMov:SCREEN-VALUE = COMBO-BOX-CodMov:ENTRY(1).

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
  DISPLAY COMBO-BOX-TipMov COMBO-BOX-CodMov FILL-IN-Fecha-1 FILL-IN-Fecha-2 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE COMBO-BOX-TipMov COMBO-BOX-CodMov FILL-IN-Fecha-1 FILL-IN-Fecha-2 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-1 wWin 
PROCEDURE Formato-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE FRAME F-FMT
         Almmmatg.ArtPro    FORMAT "X(12)"
         Almdmov.CodMat     AT  14 FORMAT "X(6)"
         Almdmov.CanDes     AT  22 FORMAT ">>>,>>9.99" 
         Almdmov.CodUnd     AT  35 FORMAT "X(4)"          
         Almmmatg.DesMat    AT  41 FORMAT "X(50)"
         Almmmatg.Desmar    AT  91 FORMAT 'x(20)'
         Almmmatg.CatConta[1] AT 115 FORMAT 'x(3)'
         Almmmate.CodUbi    AT  124
         HEADER
         {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN6B} FORMAT "X(45)" SKIP
         "INGRESO No. : " AT 96 Almcmov.NroDoc AT 114 SKIP
         "( " + Almcmov.CODALM + " )" AT 5 FORMAT "X(20)" 
         S-Movimiento  AT 52 "Pag. " AT 108 PAGE-NUMBER(REPORTE) FORMAT ">>9" SKIP(1)
         S-PROCEDENCIA AT 1 FORMAT "X(70)" S-RUC AT 79 "Fecha : " AT 113 Almcmov.FchDoc AT 121 SKIP
         S-Referencia3 AT 1 ": " Almcmov.NroRf3  AT 20 "Almacen Ingreso : " AT 79 Almcmov.CODALM AT 99       "Hora  : " AT 113 Almcmov.HorRcp AT 121 SKIP 
         S-Referencia1 AT 1 ": " Almcmov.NroRf1  AT 20 S-MONEDA AT 79 SKIP
         "Observaciones    : " AT 1 Almcmov.Observ  AT 20 "Responsable     : " AT 79 S-Encargado AT 99 SKIP
         "-----------------------------------------------------------------------------------------------------------------------------------" SKIP
         " COD.PROV.   CODIGO    CANTIDAD    UND.                  DESCRIPCION                          M A R C A           CC      UBICACION" SKIP
         "-----------------------------------------------------------------------------------------------------------------------------------" SKIP
        /*         1         2         3         4         5         6         7         8         9        10        11        12        13        14*/ 
        /*12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890*/
        /*123456789012 123456  >>>,>>9.99   1234  1234567890123456789012345678901234567890123456789012345678901234567890    123      123 */
         WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         
         
  OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 31.
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
                Almmmate.CodAlm = Almcmov.CODALM AND
                Almmmate.CodMat = Almdmov.CodMat NO-LOCK NO-ERROR.
           DISPLAY STREAM Reporte 
                   Almdmov.CodMat 
                   Almdmov.CanDes 
                   Almdmov.CodUnd 
                   Almmmatg.ArtPro 
                   Almmmatg.DesMat 
                   Almmmate.CodUbi
                   Almmmatg.Desmar 
                   Almmmatg.CatConta[1]
                   WITH FRAME F-FMT.
           DOWN STREAM Reporte WITH FRAME F-FMT.
           FIND NEXT Almdmov USE-INDEX Almd01. 
     END.
  END.
  DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 6 :
     PUT STREAM Reporte "" skip.
  END.
  PUT STREAM Reporte "    -----------------            -----------------            -----------------            ----------------- " AT 10 SKIP.
  PUT STREAM Reporte "        Operador                      Recibido                      Vo. Bo.                   ADMINISTRADOR  " AT 10 SKIP.
  PUT STREAM Reporte  Almcmov.usuario AT 18 "JEFE ALMACEN         "  AT 75 SKIP.
  PUT STREAM Reporte " ** ALMACEN ** " AT 121 SKIP.
  OUTPUT STREAM Reporte CLOSE.

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
                Almmmate.CodAlm = Almcmov.CODALM AND
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime_FR_2 wWin 
PROCEDURE Imprime_FR_2 :
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
        FIND gn-clie WHERE gn-clie.CodCia = 0 AND 
             gn-clie.CodCli = Almcmov.CodCli NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-clie THEN 
           FIND gn-clie WHERE gn-clie.CodCia = Almcmov.CodCia AND 
                gn-clie.CodCli = Almcmov.CodCli NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO: 
            S-Procedencia = "Cliente          : " + gn-clie.NomCli.
            S-RUC = "R.U.C.          :   " + gn-clie.Ruc.
        END.
        IF S-RUC = "" THEN S-RUC = "R.U.C.          :   " + Almcmov.CodCli.
                                        
     END.
     IF Almtmovm.PidPro THEN DO:
        FIND gn-prov WHERE gn-prov.CodCia = 0 AND 
             gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-prov THEN 
          FIND gn-prov WHERE gn-prov.CodCia = Almcmov.CodCia AND 
               gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN DO: 
            S-Procedencia = "Proveedor        : " + gn-prov.NomPro.
            S-RUC = "R.U.C.          :   " + gn-prov.Ruc.
        END.
        IF S-RUC = "" THEN S-RUC = "R.U.C.          :   " + Almcmov.CodPro.

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
     IF Almtmovm.PidRef3 THEN ASSIGN S-Referencia3 = Almtmovm.GloRf3.
  END.

  IF Almcmov.TipMov = "I" THEN DO:
/*      IF Almtmovm.PidPCo THEN DO:                        */
/*         RUN Formato-2.     /**** Formato Tesorerìa***/  */
/*         RUN Formato-C.                                  */
/*         RUN Formato-P.     /**** Formato Proveedor ***/ */
/*      END.                                               */
     RUN Formato-1.
  END.
/*   IF Almcmov.TipMov = "S" THEN DO:                                     */
/*       CASE Almcmov.CodMov:                                             */
/*           WHEN 20 OR WHEN 25 OR WHEN 23 OR WHEN 16 THEN RUN Formato-3. */
/*           WHEN 13 THEN DO:                                             */
/*               RUN Formato-C2.                                          */
/*               RUN Formato-4.                                           */
/*           END.                                                         */
/*           OTHERWISE RUN Formato-4.                                     */
/*       END CASE.                                                        */
/*   END.                                                                 */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime_FR_3 wWin 
PROCEDURE Imprime_FR_3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR M AS INT.

  IF LOOKUP(TRIM(Almcmov.CodAlm), '11,85,12') > 0 
    AND (Almcmov.NroSer = 014 OR Almcmov.NroSer = 185 OR Almcmov.NroSer = 102)
  THEN RETURN.

    DO M = 1 TO 2:
        S-TOTPES = 0.
        
        DEFINE VAR s-printer-list AS CHAR.
        DEFINE VAR s-port-list AS CHAR.
        DEFINE VAR s-port-name AS CHAR format "x(20)".
        DEFINE VAR s-printer-count AS INTEGER.

        I-NroSer = S-NROSER.
        FIND FIRST FacCorre WHERE 
                   FacCorre.CodCia = S-CODCIA AND
                   FacCorre.CodDoc = "G/R"    AND
                   FacCorre.CodDiv = S-CODDIV AND
                   FacCorre.NroSer = S-NROSER 
                   NO-LOCK NO-ERROR.

      S-ITEM = 0.
      
      FIND Almacen WHERE Almacen.CodCia = Almcmov.CodCia 
                    AND  Almacen.CodAlm = Almcmov.CodAlm 
                   NO-LOCK NO-ERROR.
      IF AVAILABLE Almacen THEN
         C-DIRPRO = Almacen.Descripcion.
    
      FIND Almacen WHERE Almacen.CodCia = Almcmov.CodCia 
                    AND  Almacen.CodAlm = Almcmov.AlmDes 
                   NO-LOCK NO-ERROR.
      IF AVAILABLE Almacen THEN
        ASSIGN 
             C-DESALM = Almacen.Descripcion
             C-DIRALM = Almacen.DirAlm.
      ELSE 
        ASSIGN
             C-DESALM = "".
      
      FIND GN-PROV WHERE GN-PROV.Codcia = pv-codcia 
                    AND  gn-prov.CodPro = Almcmov.CodTra 
                   NO-LOCK NO-ERROR.
      IF AVAILABLE GN-PROV THEN DO:
         F-NomPro = gn-prov.NomPro.   
         F-DIRTRA = gn-prov.DirPro. 
         F-RUCTRA = gn-prov.Ruc.
      END.

      DEFINE FRAME F-FMT
             S-Item             AT  1   FORMAT "ZZ9"
             Almdmov.CodMat     AT  6   FORMAT "X(8)"
             Almmmatg.DesMat    AT  18  FORMAT "X(45)"
             Almmmatg.Desmar    AT  70  FORMAT "X(18)"
             Almdmov.CanDes     AT  90  FORMAT ">>>,>>9.99" 
             Almdmov.CodUnd     AT  105 FORMAT "X(4)"          
             HEADER
             SKIP
             {&Prn6a} + s-nomcia + {&Prn6b} FORMAT 'x(50)' SKIP
             "GUIA DE TRANSFERENCIA" AT 30 FORMAT "X(40)" 
             STRING(Almcmov.NroDoc,"999999")  AT 80 FORMAT "X(20)" SKIP(1)
             "Almacen : " Almcmov.CodAlm + " - " + C-DIRPRO FORMAT "X(60)" 
              Almcmov.FchDoc AT 106 SKIP
             "Destino : " Almcmov.Almdes + " - " + C-DESALM AT 15 FORMAT "X(60)" SKIP
             "Observaciones    : "  Almcmov.Observ FORMAT "X(40)"  SKIP  
             "Orden de Trabajo : " ALmcmov.CodRef + Almcmov.NroRef FORMAT "X(40)"SKIP    
             "----------------------------------------------------------------------------------------------------------------------" SKIP
             "     CODIGO      DESCRIPCION                                                                 CANTIDAD    UM           " SKIP
             "----------------------------------------------------------------------------------------------------------------------" SKIP
             WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 160 STREAM-IO DOWN.

/*
      OUTPUT STREAM Reporte TO VALUE(s-port-name) PAGED PAGE-SIZE 31.
*/
      OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 31.
      
      FIND FIRST Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia 
                          AND  Almdmov.CodAlm = Almcmov.CodAlm 
                          AND  Almdmov.TipMov = Almcmov.TipMov 
                          AND  Almdmov.CodMov = Almcmov.CodMov 
                          AND  Almdmov.NroSer = ALmcmov.NroSer
                          AND  Almdmov.NroDoc = Almcmov.NroDoc 
                         USE-INDEX Almd01 NO-LOCK NO-ERROR.
      IF AVAILABLE Almdmov THEN DO:
         PUT STREAM Reporte CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN3}.     
         REPEAT WHILE  AVAILABLE  AlmDMov      AND Almdmov.CodAlm = Almcmov.CodAlm AND
               Almdmov.TipMov = Almcmov.TipMov AND Almdmov.CodMov = Almcmov.CodMov AND
               Almdmov.NroSer = Almcmov.NroSer AND Almdmov.NroDoc = Almcmov.NroDoc:
               FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia 
                              AND  Almmmatg.CodMat = Almdmov.CodMat 
                             NO-LOCK NO-ERROR.
               S-TOTPES = S-TOTPES + ( Almdmov.Candes * Almmmatg.Pesmat ).
               S-Item = S-Item + 1.     
               DISPLAY STREAM Reporte 
                       S-Item 
                       Almdmov.CodMat 
                       Almdmov.CanDes 
                       Almdmov.CodUnd 
                       Almmmatg.DesMat 
                       Almmmatg.Desmar 
                       WITH FRAME F-FMT.
               DOWN STREAM Reporte WITH FRAME F-FMT.
               FIND NEXT Almdmov USE-INDEX Almd01.
         END.
      END.
      DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 8 :
         PUT STREAM Reporte "" skip.
      END.
      PUT STREAM Reporte "----------------------------------------------------------------------------------------------------------------------" SKIP .
      PUT STREAM Reporte SKIP(1).
      PUT STREAM Reporte "               ------------------------------                              ------------------------------             " SKIP.
      PUT STREAM Reporte "                      Jefe Almacen                                                  Recepcion                         ".

     
     
      OUTPUT STREAM Reporte CLOSE.
   END.

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

CASE COMBO-BOX-TipMov:
    WHEN "Ingreso" THEN DO:
        CASE ENTRY(1, COMBO-BOX-CodMov, ' - '):
            WHEN "03" THEN DO:
                FOR EACH almcmov NO-LOCK WHERE almcmov.codcia = s-codcia
                    AND almcmov.codalm = s-codalm
                    AND almcmov.tipmov = SUBSTRING(COMBO-BOX-TipMov,1,1)
                    AND almcmov.codmov = INTEGER(ENTRY(1, COMBO-BOX-CodMov, ' - '))
                    AND almcmov.fchdoc >= FILL-IN-Fecha-1
                    AND almcmov.fchdoc <= FILL-IN-Fecha-2
                    AND almcmov.flgest <> "A",
                    FIRST Almacen OF Almcmov NO-LOCK:
                    RUN Imprime_FR.
                END.
            END.
            WHEN "50" THEN DO:  /* Entrada de producto terminado */
                FOR EACH almcmov NO-LOCK WHERE almcmov.codcia = s-codcia
                    AND almcmov.codalm = s-codalm
                    AND almcmov.tipmov = SUBSTRING(COMBO-BOX-TipMov,1,1)
                    AND almcmov.codmov = INTEGER(ENTRY(1, COMBO-BOX-CodMov, ' - '))
                    AND almcmov.fchdoc >= FILL-IN-Fecha-1
                    AND almcmov.fchdoc <= FILL-IN-Fecha-2
                    AND almcmov.flgest <> "A",
                    FIRST Almacen OF Almcmov NO-LOCK:
                    RUN Imprime_FR.
                END.
            END.
            WHEN "53" THEN DO:  /* Entrada de mermas y subproductos */
                FOR EACH almcmov NO-LOCK WHERE almcmov.codcia = s-codcia
                    AND almcmov.codalm = s-codalm
                    AND almcmov.tipmov = SUBSTRING(COMBO-BOX-TipMov,1,1)
                    AND almcmov.codmov = INTEGER(ENTRY(1, COMBO-BOX-CodMov, ' - '))
                    AND almcmov.fchdoc >= FILL-IN-Fecha-1
                    AND almcmov.fchdoc <= FILL-IN-Fecha-2
                    AND almcmov.flgest <> "A",
                    FIRST Almacen OF Almcmov NO-LOCK:
                    RUN Imprime_FR_2.
                END.
            END.
        END CASE.
    END.
    WHEN "Salida" THEN DO:
        CASE ENTRY(1, COMBO-BOX-CodMov, ' - '):
            WHEN "03" THEN DO:
                FOR EACH almcmov NO-LOCK WHERE almcmov.codcia = s-codcia
                    AND almcmov.codalm = s-codalm
                    AND almcmov.tipmov = SUBSTRING(COMBO-BOX-TipMov,1,1)
                    AND almcmov.codmov = INTEGER(ENTRY(1, COMBO-BOX-CodMov, ' - '))
                    AND almcmov.fchdoc >= FILL-IN-Fecha-1
                    AND almcmov.fchdoc <= FILL-IN-Fecha-2
                    AND almcmov.flgest <> "A",
                    FIRST Almacen OF Almcmov NO-LOCK:
                    s-nroser = almcmov.nroser.
                    RUN Imprime_FR_3.
                END.
            END.
            WHEN "50" OR WHEN "55" OR WHEN "56" THEN DO:  /* Entrada de producto terminado */
                FOR EACH almcmov NO-LOCK WHERE almcmov.codcia = s-codcia
                    AND almcmov.codalm = s-codalm
                    AND almcmov.tipmov = SUBSTRING(COMBO-BOX-TipMov,1,1)
                    AND almcmov.codmov = INTEGER(ENTRY(1, COMBO-BOX-CodMov, ' - '))
                    AND almcmov.fchdoc >= FILL-IN-Fecha-1
                    AND almcmov.fchdoc <= FILL-IN-Fecha-2
                    AND almcmov.flgest <> "A",
                    FIRST Almacen OF Almcmov NO-LOCK:
                    RUN Imprime_FR.
                END.
            END.
        END CASE.
    END.
END CASE.

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
  DEF VAR j AS INT.

  FIND Pr-cfgpro WHERE codcia = s-codcia NO-LOCK.
  DO j = 1 TO 4 WITH FRAME {&FRAME-NAME}:
      IF Pr-cfgpro.tipmov[j] = "S" THEN DO:
          FIND almtmovm WHERE almtmovm.codcia = s-codcia
              AND almtmovm.tipmov = Pr-cfgpro.tipmov[j]
              AND almtmovm.codmov = Pr-cfgpro.codmov[j]
              NO-ERROR.
          COMBO-BOX-CodMov:ADD-LAST(STRING(almtmovm.codmov, '99') + ' - ' + Almtmovm.Desmov).
      END.
  END.
  /* Agregamos las salidas por transferencia */
  FOR EACH almtmovm WHERE almtmovm.codcia = s-codcia
      AND almtmovm.tipmov = "S"
      AND LOOKUP(STRING(almtmovm.codmov,"99"),"03,55,56") > 0 NO-LOCK:
      COMBO-BOX-CodMov:ADD-LAST(STRING(almtmovm.codmov, '99') + ' - ' + Almtmovm.Desmov).
  END.

  /*RDP- Ampliar movimientos ****
  FIND almtmovm WHERE almtmovm.codcia = s-codcia
      AND almtmovm.tipmov = "S"
      AND almtmovm.codmov = 03
      NO-ERROR.
  IF AVAILABLE almtmovm 
      THEN COMBO-BOX-CodMov:ADD-LAST(STRING(almtmovm.codmov, '99') + ' - ' + Almtmovm.Desmov).
  COMBO-BOX-CodMov = COMBO-BOX-CodMov:ENTRY(1) IN FRAME {&FRAME-NAME}.
  *****/

  COMBO-BOX-CodMov = COMBO-BOX-CodMov:ENTRY(1) IN FRAME {&FRAME-NAME}.
  ASSIGN
      FILL-IN-Fecha-1 = TODAY - DAY(TODAY) + 1
      FILL-IN-Fecha-2 = TODAY.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

