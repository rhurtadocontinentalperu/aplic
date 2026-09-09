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
DEFINE        VAR C-OP     AS CHAR.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE        VAR F-PESALM AS DECIMAL NO-UNDO.

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
DEFINE BUFFER T-MATE FOR Almmmate.





DEFINE SHARED VAR S-DESALM AS CHARACTER.
/*DEFINE SHARED VAR S-CODALM AS CHARACTER.*/


/* Local Variable Definitions ---                                       */
DEFINE VAR F-Ingreso AS DECIMAL NO-UNDO.
DEFINE VAR F-Salida  AS DECIMAL NO-UNDO.
DEFINE VAR F-Saldo   AS DECIMAL NO-UNDO.
DEFINE VAR S-SUBTIT  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VAR chdivi    AS CHARACTER NO-UNDO.
DEFINE VAR chfami    AS CHARACTER NO-UNDO.

DEFINE BUFFER DMOV FOR Almdmov.

DEFINE BUFFER b-Almcmov FOR Almcmov.
DEFINE BUFFER b-Almdmov FOR Almdmov.

DEFINE TEMP-TABLE Reporte1
    FIELDS TipMov LIKE Almcmov.TipMov 
    FIELDS CodMov LIKE Almcmov.CodMov 
    FIELDS CodMat LIKE Almdmov.CodMAt
    FIELDS DesMat LIKE Almmmatg.DesMAt
    FIELDS UndMed LIKE Almmmatg.UndBas
    FIELDS CodFam LIKE Almmmatg.codfam
    FIELDS CanMAt LIKE Almdmov.CanDes
    FIELDS CstTot LIKE Almdmov.ImpLin.

DEFINE TEMP-TABLE Reporte LIKE Reporte1.
DEFINE VAR costot AS DECIMAL NO-UNDO FORMAT "->>,>>>,>>>,>>9.99".
DEFINE VAR cantot AS DECIMAL NO-UNDO FORMAT "->>,>>>,>>>,>>9.99".

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
&Scoped-Define ENABLED-OBJECTS x-fam x-div DesdeC HastaC DesdeF HastaF ~
Btn_OK Btn_Cancel Btn_Help RECT-57 
&Scoped-Define DISPLAYED-OBJECTS x-fam x-div DesdeC HastaC DesdeF HastaF ~
F-DesFam 

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

DEFINE BUTTON Btn_Help 
     IMAGE-UP FILE "img\b-ayuda":U
     LABEL "A&yuda" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE x-div AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "División" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE x-fam AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Linea" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(9)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .69 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(9)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 67 BY 1.69
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 66 BY 5.19.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-fam AT ROW 3.12 COL 14.43 COLON-ALIGNED WIDGET-ID 4
     x-div AT ROW 2.08 COL 14.43 COLON-ALIGNED WIDGET-ID 2
     DesdeC AT ROW 4.12 COL 14.43 COLON-ALIGNED
     HastaC AT ROW 4.12 COL 33 COLON-ALIGNED
     DesdeF AT ROW 4.88 COL 14.43 COLON-ALIGNED
     HastaF AT ROW 4.88 COL 33 COLON-ALIGNED
     F-DesFam AT ROW 3.15 COL 26 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 6.46 COL 34
     Btn_Cancel AT ROW 6.46 COL 45
     Btn_Help AT ROW 6.46 COL 56.14
     "Criterio de Selección" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     RECT-46 AT ROW 6.38 COL 1
     RECT-57 AT ROW 1.19 COL 1.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 68 BY 7.15
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
         TITLE              = "Reporte de Costo Neto"
         HEIGHT             = 7.04
         WIDTH              = 67
         MAX-HEIGHT         = 10.92
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 10.92
         VIRTUAL-WIDTH      = 80
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN F-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte de Costo Neto */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Costo Neto */
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


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help W-Win
ON CHOOSE OF Btn_Help IN FRAME F-Main /* Ayuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
MESSAGE "Help for File: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  RUN Borra-Temporales.
  RUN Asigna-Variables.
  RUN Imprime.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC W-Win
ON LEAVE OF DesdeC IN FRAME F-Main /* Articulo */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC W-Win
ON LEAVE OF HastaC IN FRAME F-Main /* A */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.  
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-fam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-fam W-Win
ON VALUE-CHANGED OF x-fam IN FRAME F-Main /* Linea */
DO:
   ASSIGN x-fam.
   
   FIND Almtfami WHERE Almtfami.CodCia = S-CODCIA 
                  AND  Almtfami.codfam = x-fam:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
                 NO-LOCK NO-ERROR.
   IF AVAILABLE Almtfami THEN 
      DISPLAY Almtfami.desfam @ F-DesFam WITH FRAME {&FRAME-NAME}.
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
    DesdeC HastaC DesdeF HastaF x-div .
   
  IF HastaC <> "" THEN 
    S-SUBTIT = "Materiales del " + DesdeC + " al " + HastaC .
  ELSE 
    S-SUBTIT = "".
  S-SUBTIT = "Fecha   : " + STRING(DesdeF,"99/99/9999") + " al " + STRING(HastaF,"99/99/9999").

  IF HastaC = "" THEN HastaC = "zzzzzzzzzzzzzz".
  
  IF X-Div:SCREEN-VALUE = "Todas" THEN ASSIGN chdivi = ''. ELSE ASSIGN chdivi = X-Div:SCREEN-VALUE.
  IF X-Fam:SCREEN-VALUE = "Todas" THEN ASSIGN chfami = ''. ELSE ASSIGN chfami = X-Fam:SCREEN-VALUE.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporales W-Win 
PROCEDURE Borra-Temporales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH Reporte.
    DELETE Reporte.
END.

FOR EACH Reporte1.
    DELETE Reporte1.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Datos W-Win 
PROCEDURE Carga-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER tipmov AS CHAR.
DEFINE INPUT PARAMETER codmov AS INTEGER.
DEFINE INPUT PARAMETER sigmov AS DECIMAL.

FOR EACH Reporte1:
    DELETE Reporte1.
END.

FOR EACH Almacen NO-LOCK WHERE Almacen.CodCia = s-CodCia
    AND Almacen.CodDiv BEGINS chdivi:
    FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = s-codcia
        AND Almcmov.TipMov = tipmov 
        AND AlmcMov.CodMov = codmov 
        AND AlmCmov.CodAlm = Almacen.CodAlm
        AND Almcmov.FchDoc >= DesdeF
        AND Almcmov.FchDoc <= HastaF,
        EACH AlmdMov OF AlmCMov NO-LOCK
            WHERE (AlmdMov.CodMAt >= DesdeC:SCREEN-VALUE IN FRAME {&FRAME-NAME} OR 
                   DesdeC:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "")
                   AND (AlmdMov.CodMAt <= HastaC:SCREEN-VALUE IN FRAME {&FRAME-NAME} OR 
                   HastaC:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""),
            FIRST AlmStkGe NO-LOCK WHERE AlmStkGe.CodCia = Almcmov.CodCia
                AND AlmStkGe.CodMat = AlmdMov.CodMat
                AND AlmStkge.Fecha = Almcmov.FchDoc,
                FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = Almcmov.CodCia
                    AND Almmmatg.CodMat = Almdmov.CodMat
                    AND Almmmatg.CodFam BEGINS chfami
                    BREAK BY Almdmov.FchDoc
                          BY Almdmov.codmat:
                    ACCUMULATE Almdmov.CanDes *  INTEGRAL.Almdmov.Factor (TOTAL BY Almdmov.codmat).
    
                IF LAST-OF(Almdmov.codmat) THEN DO:
                    cantot = ACCUM TOTAL BY Almdmov.codmat Almdmov.CanDes *  INTEGRAL.Almdmov.Factor.
                    /*cantot = cantot * (-1) * sigmov.   */
                    costot = cantot * AlmStkge.CtoUni.
                    CREATE Reporte1.
                    ASSIGN 
                        Reporte1.TipMov = Almcmov.TipMov
                        Reporte1.CodMov = Almcmov.CodMov
                        Reporte1.CodMat = Almdmov.CodMAt
                        Reporte1.Desmat = Almmmatg.DesMat
                        Reporte1.UndMed = Almmmatg.UndBas
                        Reporte1.CodFam = Almmmatg.CodFam
                        Reporte1.CanMat = cantot
                        Reporte1.CstTot = costot.
                    DISPLAY Reporte1.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
                        FORMAT "X(11)" WITH FRAME F-Proceso.
                END.
                
    END.
END.

FOR EACH Reporte1 BREAK BY Reporte1.CodMat:
    ACCUMULATE Reporte1.CanMat (SUB-TOTAL BY Reporte1.CodMat).
    ACCUMULATE Reporte1.CstTot (SUB-TOTAL BY Reporte1.CodMat).
    IF LAST-OF(Reporte1.CodMat) THEN DO:
        CREATE Reporte.
        ASSIGN
            Reporte.TipMov = Reporte1.TipMov
            Reporte.CodMov = Reporte1.CodMov
            Reporte.CodMat = Reporte1.CodMat
            Reporte.Desmat = Reporte1.DesMat
            Reporte.UndMed = Reporte1.UndMed
            Reporte.CodFam = Reporte1.CodFam
            Reporte.CanMat = ACCUM SUB-TOTAL BY Reporte1.CodMat Reporte1.CanMat.
            Reporte.CstTot = ACCUM SUB-TOTAL BY Reporte1.CodMat Reporte1.CstTot.
            Reporte.CstTot = Reporte.CstTot * sigmov.
    END.
END.

HIDE FRAME F-PROCESO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Reporte W-Win 
PROCEDURE Carga-Reporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 RUN Carga-Datos ('S', 02, 1). 
 RUN Carga-Datos ('I', 09, (-1)).

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
  DISPLAY x-fam x-div DesdeC HastaC DesdeF HastaF F-DesFam 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-fam x-div DesdeC HastaC DesdeF HastaF Btn_OK Btn_Cancel Btn_Help 
         RECT-57 
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
  /*DEFINE VARIABLE S-CODMOV AS CHAR NO-UNDO. 
  DEFINE VARIABLE x-codpro LIKE Almcmov.codpro NO-UNDO.
  DEFINE VARIABLE x-codcli LIKE Almcmov.codcli NO-UNDO.
  DEFINE VARIABLE x-nrorf1 LIKE Almcmov.nrorf1 NO-UNDO.
  DEFINE VARIABLE x-nrorf2 LIKE Almcmov.nrorf2 NO-UNDO.
  DEFINE VARIABLE x-codmov LIKE Almcmov.codmov NO-UNDO.
  

  /* Tipo de movimiento de la salida por G/R */
  FIND FacDocum WHERE FacDocum.CodCia = s-codcia AND
       FacDocum.CodDoc = 'G/R' NO-LOCK NO-ERROR.
  IF AVAILABLE FacDocum THEN x-codmov = FacDocum.CodMov.

  DEFINE FRAME F-REPORTE
         S-CODMOV        FORMAT "X(3)"
         Almdmov.NroDoc  
         x-CodPro        FORMAT "X(11)" 
         x-CodCli        FORMAT "X(11)" 
         x-NroRf1 
         x-NroRf2 
         Almdmov.FchDoc 
         F-Ingreso    FORMAT "(>>>,>>>,>>9.99)"
         F-Salida     FORMAT "(>>>,>>>,>>9.99)"
         F-Saldo      FORMAT "(>>>,>>>,>>9.99)"
  WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP
         "( " + S-CODALM + ")"  FORMAT "X(15)"
         "MOVIMIENTOS POR ALMACEN" AT 45
         "Pagina :"  TO 104 PAGE-NUMBER(REPORT) TO 115 FORMAT "ZZZZZ9" SKIP
         "Fecha  :"  TO 104 TODAY TO 115 FORMAT "99/99/9999" SKIP
         S-SUBTIT 
         "Hora   :"  TO 104 STRING(TIME,"HH:MM:SS") TO 115 SKIP             
         "----------------------------------------------------------------------------------------------------------------------" SKIP
         "Cod Numero Codigo    Codigo                            Fecha                                                          " SKIP
         "Mov Docmto Proveedor Cliente  Referencia Referencia    Documento          Ingresos          Salidas            Saldos " SKIP
         "----------------------------------------------------------------------------------------------------------------------" SKIP
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
       
  FOR EACH Almmmate NO-LOCK WHERE Almmmate.CodCia = S-CODCIA 
                             AND  Almmmate.CodAlm = S-CODALM 
                             AND  Almmmate.CodMat >= DesdeC  
                             AND  Almmmate.CodMat <= HastaC , 
      EACH Almmmatg OF Almmmate NO-LOCK WHERE Almmmatg.codfam BEGINS F-CodFam 
                                         AND  Almmmatg.FchCes = ?,
      EACH Almdmov NO-LOCK WHERE Almdmov.CodCia = Almmmate.CodCia 
                            AND  Almdmov.CodAlm = Almmmate.CodAlm 
                            AND  Almdmov.codmat = Almmmate.CodMat 
                            AND  Almdmov.FchDoc >= DesdeF 
                            AND  Almdmov.FchDoc <= HastaF
                           BREAK BY Almmmate.CodCia 
                                 BY Almmmatg.CodFam
                                 BY Almmmatg.SubFam
                                 BY Almmmate.CodMat
                                 BY Almdmov.FchDoc
                                 BY Almdmov.TipMov
                                 BY Almdmov.CodMov
                                 BY Almdmov.NroDoc:

      DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(Almmmatg.CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = Almmmatg.CodCia 
                        AND  Almtfami.codfam = Almmmatg.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT Almtfami.codfam '    ' Almtfami.desfam SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
      IF FIRST-OF(Almmmatg.SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = Almmmatg.CodCia 
                        AND  Almsfami.codfam = Almmmatg.CodFam 
                        AND  Almsfami.subfam = Almmmatg.Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             PUT STREAM REPORT Almsfami.subfam '   ' AlmSFami.dessub SKIP.
             DOWN 1 STREAM REPORT WITH FRAME F-REPORTE.
         END.
      END.
              
      IF FIRST-OF(Almmmate.CodMat) THEN DO:
         FIND LAST DMOV WHERE DMOV.CodCia = S-CODCIA 
                         AND  DMOV.CodAlm = Almmmate.CodAlm 
                         AND  DMOV.CodMat = Almmmate.CodMat 
                         AND  DMOV.FchDoc < DesdeF 
                        USE-INDEX Almd03 NO-LOCK NO-ERROR.
         IF AVAILABLE DMOV THEN F-Saldo = DMOV.StkSub.
         ELSE F-Saldo = 0.
         PUT STREAM REPORT Almmmate.CodMat AT 2   FORMAT "X(9)"
                           Almmmatg.DesMat AT 14  FORMAT "X(50)"
                           Almmmatg.DesMar AT 66  FORMAT "X(12)"
                           Almmmatg.UndStk AT 80  FORMAT "X(4)" 
                           F-Saldo         AT 105 FORMAT "(>>>,>>>,>>9.999)".         DOWN STREAM REPORT WITH FRAME F-REPORTE.
      END.
      x-codpro = "".
      x-codcli = "".
      x-nrorf1 = "".
      x-nrorf2 = "".
      FIND Almcmov WHERE Almcmov.CodCia = Almdmov.codcia 
                    AND  Almcmov.CodAlm = Almdmov.codalm 
                    AND  Almcmov.TipMov = Almdmov.tipmov 
                    AND  Almcmov.CodMov = Almdmov.codmov 
                    AND  Almcmov.NroDoc = Almdmov.nrodoc 
                   NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almcmov THEN DO:
         IF Almdmov.CodMov = x-codmov THEN DO:
            FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia 
                           AND  CcbCDocu.CodDoc = 'G/R' 
                           AND  CcbCDocu.NroDoc = STRING(Almdmov.nroser,'999') + STRING(Almdmov.Nrodoc,'999999') 
                          NO-LOCK NO-ERROR.
            IF AVAILABLE CcbCDocu THEN 
               ASSIGN
                  x-codcli = CcbCDocu.codcli
                  x-nrorf1 = CcbCDocu.Nroped.
            END.
         END.
      ELSE 
         ASSIGN
            x-codpro = Almcmov.codpro
            x-codcli = Almcmov.codcli
            x-nrorf1 = Almcmov.nrorf1
            x-nrorf2 = Almcmov.nrorf2.
         
      S-CODMOV  = Almdmov.TipMov + STRING(Almdmov.CodMov,"99"). 
      F-Ingreso = IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
      F-Salida  = IF LOOKUP(Almdmov.TipMov,"S,T") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
      F-Saldo   = F-Saldo + F-Ingreso - F-Salida.
      ACCUMULATE F-Ingreso (TOTAL BY Almmmate.CodMat).
      ACCUMULATE F-Salida  (TOTAL BY Almmmate.CodMat).
      DISPLAY STREAM REPORT 
               S-CODMOV  
               Almdmov.NroDoc 
               x-CodPro 
               x-CodCli 
               x-NroRf1 
               x-NroRf2 
               Almdmov.FchDoc 
               F-Ingreso /*WHEN F-Ingreso > 0*/
               F-Salida  /*WHEN F-Salida  > 0*/
               F-Saldo   /*WHEN F-Saldo   > 0*/
               WITH FRAME F-REPORTE.
      IF LAST-OF(Almmmate.CodMat) THEN DO:
         UNDERLINE STREAM REPORT F-Ingreso F-Salida F-Saldo WITH FRAME F-REPORTE.
         DISPLAY STREAM  REPORT 
                 ACCUM TOTAL BY Almmmate.CodMat F-Ingreso @ F-Ingreso 
                 ACCUM TOTAL BY Almmmate.CodMat F-Salida  @ F-Salida  
                 F-Saldo   WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT F-Ingreso F-Salida F-Saldo WITH FRAME F-REPORTE.
         DOWN STREAM REPORT WITH FRAME F-REPORTE.
      END.
  END.
  HIDE FRAME F-PROCESO.

*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato_1 W-Win 
PROCEDURE Formato_1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR dtotales AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>>,>>9.99".

DEFINE FRAME F-HEADER
     HEADER
     S-NOMCIA FORMAT "X(50)" AT 1 SKIP
     "COSTO NETO POR ARTICULO" AT 45
     "Pagina :"  TO 104 PAGE-NUMBER(REPORT) TO 115 FORMAT "ZZZZZ9" SKIP
     "Fecha  :"  TO 104 TODAY TO 115 FORMAT "99/99/9999" SKIP
     S-SUBTIT SKIP
     "------------------------------------------------------------------------------------------------------------------------------" SKIP
     " Tip  Cod  Codigo    Descripción                              Unidad  Código                         Costo                      " SKIP
     " Mov  Mov  Material  Material                                 Medida  Familia      Cantidad          Total                      " SKIP
     "------------------------------------------------------------------------------------------------------------------------------" SKIP
WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 




DEFINE FRAME F-Det
    Reporte.TipMov  COLUMN-LABEL "Tip.Mov."     FORMAT 'X(4)'
    Reporte.CodMov  COLUMN-LABEL "Cod.Mov."     FORMAT '>>99'
    Reporte.CodMat  COLUMN-LABEL "Artículo"     FORMAT 'X(8)'
    Reporte.DesMat  COLUMN-LABEL "Descripción"
    Reporte.UndMed  COLUMN-LABEL "UndMed"
    Reporte.CodFam  COLUMN-LABEL "Familia"
    Reporte.CanMat  COLUMN-LABEL "Cantidad"
    Reporte.CstTot  COLUMN-LABEL "Costo Total"
    WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

VIEW STREAM report FRAME F-Header.
FOR EACH Reporte 
    BREAK BY Reporte.TipMov DESC
          BY Reporte.CstTot DESC:
    ACCUMULATE Reporte.CstTot (SUB-TOTAL BY Reporte.TipMov).
    ACCUMULATE Reporte.CstTot (TOTAL).
    DISPLAY STREAM Report
        Reporte.TipMov
        Reporte.CodMov
        Reporte.CodMat
        Reporte.DesMat
        Reporte.UndMed
        Reporte.CodFam
        Reporte.CanMat
        Reporte.CstTot
        WITH FRAME F-Det.
    IF LAST-OF(Reporte.TipMov) THEN DO:
        dtotales = ACCUM SUB-TOTAL BY Reporte.TipMov Reporte.CstTot.
        DOWN STREAM Report 1 WITH FRAME F-Det.
        UNDERLINE STREAM Report Reporte.CstTot WITH FRAME F-Det.
        DISPLAY STREAM Report
            "Total" @ Reporte.CanMat
            dtotales @ Reporte.CstTot
            WITH FRAME F-Det.
    END.
    IF LAST(Reporte.TipMov) THEN DO:
        DOWN STREAM Report 1 WITH FRAME F-Det.
        UNDERLINE STREAM Report Reporte.CstTot WITH FRAME F-Det.
        DISPLAY STREAM Report
            "Costo Total" @ Reporte.CanMat
            ACCUM TOTAL Reporte.CstTot @ Reporte.CstTot
            WITH FRAME F-Det.
    END.
END.

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
    ENABLE ALL EXCEPT F-DesFam .
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

    RUN Carga-Reporte.

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato_1.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
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
  ASSIGN DesdeC HastaC DesdeF HastaF .

  IF HastaC <> "" THEN HastaC = "".
  
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
  DEFINE VARIABLE q AS LOGICAL.
  DEFINE VARIABLE p AS LOGICAL.

  x-div:LIST-ITEMS IN FRAME {&FRAME-NAME} = "Todas".

  FOR EACH Gn-Divi WHERE GN-DIVI.CodCia = s-CodCia:
      q = x-div:ADD-LAST(GN-DIVI.CodDiv) IN FRAME {&FRAME-NAME}.
  END.
  
  x-fam:LIST-ITEMS IN FRAME {&FRAME-NAME} = "Todas".
  FOR EACH Almtfami WHERE Almtfami.CodCia = s-CodCia:
      p = x-fam:ADD-LAST(Almtfami.codfam) IN FRAME {&FRAME-NAME}.
  END.
   
   
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN DesdeF = TODAY  + 1 - DAY(TODAY).
            HastaF = TODAY.
     DISPLAY DesdeF HastaF.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
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
        WHEN "F-Subfam" THEN ASSIGN input-var-1 = x-fam:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        WHEN "F-marca1" OR WHEN "F-marca2" THEN ASSIGN input-var-1 = "MK".
    /*    WHEN "DesdeC" THEN ASSIGN input-var-1 = S-CODALM.
        WHEN "HastaC" THEN ASSIGN input-var-1 = S-CODALM.*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _Header W-Win 
PROCEDURE _Header :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
titulo = "REPORTE DE MOVIMIENTOS POR DIA".

mens1 = "TIPO Y CODIGO DE MOVIMIENTO : " + C-TipMov + "-" + STRING(I-CodMov, "99") + " " + D-Movi:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
mens2 = "MATERIAL : " + DesdeC + " A: " + HastaC .
mens3 = "FECHA : " + STRING(F-FchDes, "99/99/9999") + " A: " + STRING(F-FchHas, "99/99/9999").

titulo = S-NomCia + fill(" ", (INT((90 - length(titulo)) / 2)) - length(S-NomCia)) + titulo.
mens1 = fill(" ", INT((90 - length(mens1)) / 2)) + mens1.
mens2 = fill(" ", INT((90 - length(mens2)) / 2)) + mens2.
mens3 = C-condicion:SCREEN-VALUE + fill(" ", INT((90 - length(mens3)) / 2) - LENGTH(C-condicion:SCREEN-VALUE)) + mens3.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

