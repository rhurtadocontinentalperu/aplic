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
{lib/def-prn.i} 
DEFINE STREAM report.
DEFINE VARIABLE T-CLIEN AS CHAR INIT "" NO-UNDO.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.


/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR cl-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NOMCIA  AS CHAR.
DEFINE SHARED VAR S-CODALM  AS CHAR.

DEFINE TEMP-TABLE tmp-tempo 
    FIELD t-codpro  LIKE Almmmatg.Codpr1
    FIELD t-nompro  LIKE Gn-Prov.Nompro 
    FIELD t-codalm  LIKE FacCpedi.Codalm
    FIELD t-codalm1  LIKE FacCpedi.Codalm
    FIELD t-codcli  LIKE FacCpedi.Codcli
    FIELD t-nomcli  LIKE FacCpedi.Nomcli
    FIELD t-codmat  LIKE FacDpedi.codmat
    FIELD t-desmat  LIKE Almmmatg.DesMat    FORMAT "X(40)"
    FIELD t-desmar  LIKE Almmmatg.DesMar    FORMAT "X(8)"
    FIELD t-undbas  LIKE Almmmatg.UndBas    FORMAT "X(8)"
    FIELD t-codubi  LIKE Almmmate.CodUbi    FORMAT "X(6)"
    FIELD t-nroped  LIKE FacCPedi.NroPed
    FIELD t-fchped  LIKE FacCPedi.FchPed
    FIELD t-glosa   AS CHAR          FORMAT "X(30)"
    FIELD t-stkact  LIKE Almmmate.StkAct    FORMAT "->>>>>,>>9.99"
    FIELD t-stkact1  LIKE Almmmate.StkAct    FORMAT "->>>>>,>>9.99"
    FIELD t-solici  AS DEC           FORMAT "->>>>,>>9.99"
    FIELD t-atendi  AS DEC           FORMAT "->>>>,>>9.99"
    FIELD t-pendie  AS DEC           FORMAT "->>>>,>>9.99"
    FIELD t-totsol  AS DEC           FORMAT "->>>>,>>9.99"
    FIELD t-totdol  AS DEC           FORMAT "->>>>,>>9.99".

DEFINE BUFFER b-tempo FOR tmp-tempo.

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
&Scoped-Define ENABLED-OBJECTS f-clien Btn_OK Btn_Cancel f-desde f-hasta ~
cbo-almD cbo-almT 
&Scoped-Define DISPLAYED-OBJECTS f-clien f-nomcli f-desde f-hasta cbo-almD ~
cbo-almT 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Aceptar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE VARIABLE cbo-almD AS CHARACTER FORMAT "X(25)":U 
     LABEL "Alm. Despacho" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE cbo-almT AS CHARACTER FORMAT "X(25)":U 
     LABEL "Alm. Transferencia" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE f-clien AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .69 NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28.29 BY .69 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     f-clien AT ROW 1.19 COL 5 COLON-ALIGNED
     f-nomcli AT ROW 1.19 COL 17.57 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 1.19 COL 54
     Btn_Cancel AT ROW 2.38 COL 54
     f-desde AT ROW 3.31 COL 12 COLON-ALIGNED
     f-hasta AT ROW 3.31 COL 28 COLON-ALIGNED
     cbo-almD AT ROW 4.65 COL 12 COLON-ALIGNED
     cbo-almT AT ROW 4.65 COL 37 COLON-ALIGNED
     "Rango de Fechas" VIEW-AS TEXT
          SIZE 17.14 BY .62 AT ROW 2.35 COL 19
          FONT 6
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
         TITLE              = "Pedido Pendiente Por Atender"
         HEIGHT             = 4.92
         WIDTH              = 66.14
         MAX-HEIGHT         = 27.73
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.73
         VIRTUAL-WIDTH      = 146.29
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

{src/bin/_prns.i}
{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN f-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Pedido Pendiente Por Atender */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Pedido Pendiente Por Atender */
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

   ASSIGN f-Desde f-hasta f-clien cbo-almd cbo-almt.

  IF f-desde = ? then do:
     MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.   
  END.
   
  IF f-hasta = ? then do:
     MESSAGE "Ingrese Fecha Hasta ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-hasta.
     RETURN NO-APPLY.   
  END.   

  IF f-desde > f-hasta then do:
     MESSAGE "Rango de fechas Mal ingresado" VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.
  END.
 run imprime.
  
  /*IF f-clien <> "" THEN T-clien = "Cliente :  " + f-clien.

  P-largo   = 66.
  P-Copias  = INPUT FRAME D-DIALOG RB-NUMBER-COPIES.
  P-pagIni  = INPUT FRAME D-DIALOG RB-BEGIN-PAGE.
  P-pagfin  = INPUT FRAME D-DIALOG RB-END-PAGE.
  P-select  = INPUT FRAME D-DIALOG RADIO-SET-1.
  P-archivo = INPUT FRAME D-DIALOG RB-OUTPUT-FILE.
  P-detalle = "Impresora Local (EPSON)".
  P-name    = "Epson E/F/J/RX/LQ".
  P-device  = "PRN".*/
     
  /*IF P-select = 2 
 *      THEN P-archivo = SESSION:TEMP-DIRECTORY + 
 *           STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
 *   ELSE RUN setup-print.      
 *      IF P-select <> 1 
 *      THEN P-copias = 1.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-clien
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-clien W-Win
ON LEAVE OF f-clien IN FRAME F-Main /* Cliente */
DO:
  F-clien = "".
  IF F-clien:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
          gn-clie.Codcli = F-clien:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie THEN F-Nomcli = gn-clie.Nomcli.
  END.
  DISPLAY F-NomCli WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal W-Win 
PROCEDURE carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
 DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.  

FOR EACH TMP-TEMPO:
 delete tmp-tempo.
end.


FOR EACH FacCpedi NO-LOCK WHERE
          FacCpedi.CodCia = S-CODCIA AND
          FacCpedi.CodDiv = S-CODDIV AND
          FacCpedi.CodDoc = "PED"    AND
          FacCpedi.FlgEst = "P"      AND
          FacCpedi.FchPed >= F-desde AND
          FacCpedi.FchPed <= F-hasta AND 
          FacCpedi.Codcli BEGINS f-clien ,
   EACH FacDpedi OF FacCpedi  :
          
    


     IF CANPED - CANATE = 0 THEN NEXT.
     
     FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
                         Almmmatg.CodmAT = FacDpedi.CodMat
                         NO-LOCK NO-ERROR. 

     /*FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
                         Almmmatg.CodmAT = FacDpedi.CodMat
                         NO-LOCK NO-ERROR. */

     
     FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                         Almtconv.Codalter = FacDpedi.UndVta
                         NO-LOCK NO-ERROR.
  
      F-FACTOR  = 1. 
          
      IF AVAILABLE Almtconv THEN DO:
        F-FACTOR = Almtconv.Equival.
        IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
      END.
      
      FIND Tmp-tempo WHERE Tmp-Tempo.t-Codcli = Faccpedi.Codcli AND
                           Tmp-Tempo.t-Codmat = FacdPedi.Codmat 
                           NO-LOCK NO-ERROR.
                           
      IF NOT AVAILABLE Tmp-Tempo THEN DO: 
         CREATE Tmp-Tempo.  /*Faccpedi.CodAlm*/
         ASSIGN   Tmp-Tempo.t-CodAlm = cbo-almd
                  Tmp-Tempo.t-CodAlm1 = cbo-almt  
                  Tmp-Tempo.t-Codcli = Faccpedi.Codcli 
                  Tmp-Tempo.t-Nomcli = Faccpedi.Nomcli 
                  Tmp-Tempo.t-Codmat = FacdPedi.Codmat
                  Tmp-Tempo.t-DesMat = Almmmatg.DesMat
                  Tmp-Tempo.t-UndBas = Almmmatg.UndBas. 

       END.  
/*         Tmp-Tempo.t-glosa  = Tmp-Tempo.t-glosa + substring(string(FaccPedi.FchPed),1,5) + "-" + SUBSTRING(FaccPedi.Nroped,4,6) + '/'.*/
         Tmp-Tempo.t-solici = Tmp-Tempo.t-solici + FacdPedi.Canped * F-FACTOR.
/*         Tmp-Tempo.t-atendi = Tmp-Tempo.t-atendi + FacdPedi.Canate * F-FACTOR.*/
         /*Tmp-Tempo.t-pendie = Tmp-Tempo.t-pendie + (FacdPedi.Canped - FacdPedi.CanAte) * F-FACTOR.*/
         If FaccPedi.Codmon = 1 THEN Tmp-Tempo.t-totsol = Tmp-Tempo.t-totsol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).
         If FaccPedi.Codmon = 2 THEN Tmp-Tempo.t-totdol = Tmp-Tempo.t-totdol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).

 END.
 FOR EACH Tmp-Tempo:
     FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
                         Almmmate.CodAlm = tmp-tempo.t-CodAlm AND
                         Almmmate.CodmAT = tmp-tempo.t-CodMat
                         NO-LOCK NO-ERROR. 
     
     IF AVAILABLE Almmmate THEN DO:
        IF Almmmate.stkact >= tmp-tempo.t-solici THEN Tmp-Tempo.t-pendie = 0.
        IF Almmmate.stkact = tmp-tempo.t-solici THEN Tmp-Tempo.t-pendie = 0.
        IF Almmmate.stkact < tmp-tempo.t-solici THEN Tmp-Tempo.t-pendie = (tmp-tempo.t-solici - Almmmate.stkact).
       
     End.
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
  DISPLAY f-clien f-nomcli f-desde f-hasta cbo-almD cbo-almT 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE f-clien Btn_OK Btn_Cancel f-desde f-hasta cbo-almD cbo-almT 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formato W-Win 
PROCEDURE formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*DEFINE VAR W-TOTBRU AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTIGV AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   */
 DEFINE VAR X-STOCK     AS DECIMAL .   
 DEFINE VAR X-STOCK1     AS DECIMAL .
 /*DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.   */
 
 RUN CARGA-TEMPORAL.
 
 DEFINE FRAME f-cab
        tmp-tempo.t-codmat 
        tmp-tempo.t-DesMat FORMAT "X(35)"
        tmp-tempo.t-undbas FORMAT "X(4)"
        x-stock            FORMAT "->>>,>>9.99"
        tmp-tempo.t-solici FORMAT "->>>,>>9.99"
        tmp-tempo.t-pendie FORMAT "->>>,>>9.99"
        x-stock1            FORMAT "->>>,>>9.99"
        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
        
        DEFINE FRAME H-REP
        HEADER
                
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)" skip
        {&PRN6A} + "PEDIDOS PENDIENTES POR ATENDER"  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN6A} + "ALMACEN ( " + CBO-ALMD + ")" + {&PRN6B} AT 1 FORMAT "X(15)"
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)" SKIP
        "--------------------------------------------------------------------------------------------------------------" SKIP
        "                                                       C A N T I D A D        Por        Stock                   " SKIP
        " Codigos      Descripcion                  U.M.       Stock   Solicitado    Transferir    Almacen "+ string(cbo-almt, 'x(3)') format "x(150)" " " SKIP
        "--------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
         VIEW STREAM REPORT FRAME H-REP.
         FOR EACH TMP-TEMPO BREAK
                     BY tmp-tempo.t-codcli
                     BY tmp-tempo.t-codmat:  
         
        DISPLAY STREAM REPORT WITH FRAME F-CAB.

        
     IF FIRST-OF(tmp-tempo.t-Codcli) THEN DO:
       PUT STREAM REPORT "CLIENTE  : "  tmp-tempo.t-Codcli  "  " tmp-tempo.t-NomCli SKIP.
       PUT STREAM REPORT '------------------------------------------' SKIP.
     END.
         
           find Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
                         Almmmate.CodAlm = tmp-tempo.t-CodAlm  AND
                         Almmmate.CodmAT = tmp-tempo.t-CodMat
                         NO-LOCK NO-ERROR.
If Available almmmate Then X-STOCK = almmmate.StkAct.
                         
           find Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
                         Almmmate.CodAlm = tmp-tempo.t-CodAlm1  AND
                         Almmmate.CodmAT = tmp-tempo.t-CodMat
                         NO-LOCK NO-ERROR.
              
    /* X-STOCK = 0.*/
      
     If Available almmmate Then X-STOCK1 = almmmate.StkAct.
          
     DISPLAY STREAM REPORT 
        tmp-tempo.t-codmat
        tmp-tempo.t-Desmat
        tmp-tempo.t-undbas
        X-Stock 
        tmp-tempo.t-solici
        tmp-tempo.t-pendie
        X-Stock1
        WITH FRAME F-Cab.
 
       
 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime W-Win 
PROCEDURE imprime :
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
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM REPORT.
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
assign
    f-desde = today
    f-hasta = today.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
DO WITH FRAME {&FRAME-NAME}:
    FOR EACH almacen NO-LOCK by codalm desc:
        cbo-almd:add-first(almacen.codalm).
    END.
    FOR EACH almacen NO-LOCK by codalm desc:
        cbo-almt:add-first(almacen.codalm).
    END.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
PROCEDURE procesa-parametros :
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
        WHEN "" THEN .
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

