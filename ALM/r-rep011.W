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
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-nromes AS INT.
DEF SHARED VAR s-nomcia AS CHAR.


DEF VAR p AS LOGICAL.
DEF VAR q AS LOGICAL.

DEF VAR PR-CODCIA AS INT NO-UNDO.
DEF VAR desalm    LIKE Almacen.Descripcion.
DEF VAR almacen   LIKE Almacen.codalm.
DEF VAR almdes    AS CHARACTER.

DEF BUFFER B-CMOV FOR AlmcMov.
DEF BUFFER B-DMOV FOR AlmdMov.
DEF BUFFER b-reporte FOR Reporte.

FIND FIRST EMPRESAS WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodPro THEN PR-CODCIA = S-CODCIA.

DEFINE TEMP-TABLE Reporte  
    FIELDS CodAlm   LIKE Almcmov.CodAlm
    FIELDS TpoMov   LIKE Almcmov.TipMov
    FIELDS CodMov   LIKE Almdmov.CodMov
    FIELDS NroDoc   LIKE Almcmov.NroRf1
    FIELDS FchDoc   LIKE Almcmov.FchDoc
    FIELDS AlmDes   LIKE Almcmov.AlmDes
    FIELDS DesAlm   LIKE Almacen.Descripcion
    FIELDS NroPed   LIKE Almcmov.NroRf1
    FIELDS NroRef   LIKE Almcmov.NroRf2
    FIELDS CodMat   LIKE Almmmatg.CodMat
    FIELDS DesMat   LIKE Almmmatg.DesMat
    FIELDS UndBas   AS CHAR FORMAT 'x(7)'   /*LIKE Almdmov.CodUnd */
    FIELDS CanMat   LIKE Almdmov.CanDes
    
    FIELDS AlmRec   LIKE Almcmov.CodAlm
    FIELDS NroDc1   LIKE Almcmov.NroDoc
    FIELDS FchRec   LIKE Almcmov.FchDoc
    FIELDS CodArt   LIKE Almmmatg.CodMat
    FIELDS DesArt   LIKE Almmmatg.DesMat
    FIELDS Unidad   AS CHAR FORMAT 'x(7)'   /*LIKE Almdmov.CodUnd */
    FIELDS CanArt   LIKE Almdmov.CanDes
    FIELDS DiasEn   AS   INTEGER.
    
/*    FIELDS NroRe1   LIKE Almcmov.NroRf1
 *     FIELDS NroRe2   LIKE Almcmov.NroRf2*/

DEFINE TEMP-TABLE Reporte-1  
    FIELDS CodAlm   LIKE Almcmov.CodAlm /*codigo del almacen donde se recibio material*/
    FIELDS NroDoc   LIKE Almcmov.NroDoc /*nro de guia de recepcion*/
    FIELDS FchDoc   LIKE Almcmov.FchDoc /*fecha de recepcion*/
    FIELDS AlmRec   LIKE Almcmov.CodAlm /*codigo de almacen de donde proviene*/
    FIELDS NroDc1   like Almcmov.NroRf1 /*numero de guia de salida*/
    FIELDS CodArt   LIKE Almmmatg.CodMat /*codigo de material*/
    FIELDS DesArt   LIKE Almmmatg.DesMat /*descripcion material*/
    FIELDS Unidad   AS CHAR FORMAT 'x(7)'   /*LIKE Almdmov.CodUnd  /**unidad base*/*/
    FIELDS CanArt   LIKE Almdmov.CanDes. /* cantidad recibida*/
    
    


DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Mensajes
     /*IMAGE-1 AT ROW 1.5 COL 5*/
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16
          FONT 8
     "por favor..." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19
          FONT 8
     "F10 = Cancela Reporte" VIEW-AS TEXT
          SIZE 21 BY 1 AT ROW 3.5 COL 12
          FONT 8          
    SPACE(10.28) SKIP(0.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
        BGCOLOR 15 FGCOLOR 0 TITLE "Cargando...".

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
&Scoped-Define ENABLED-OBJECTS RECT-57 x-nroguia COMBO-BOX-almacen DesdeF ~
HastaF Btn_OK Btn_Cancel Btn_Cancel-2 
&Scoped-Define DISPLAYED-OBJECTS x-nroguia COMBO-BOX-almacen DesdeF HastaF 

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
     SIZE 11 BY 1.5 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON Btn_Cancel-2 
     IMAGE-UP FILE "img\excel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5 TOOLTIP "Detallado por material y todos los almacenes"
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5 TOOLTIP "Imprimir"
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-almacen AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Almacén Destino" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE x-nroguia AS CHARACTER FORMAT "X(3)":U 
     LABEL "N° Serie" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .77 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 62 BY 1.92
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59.86 BY 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-nroguia AT ROW 1.81 COL 14 COLON-ALIGNED WIDGET-ID 2
     COMBO-BOX-almacen AT ROW 2.88 COL 14 COLON-ALIGNED
     DesdeF AT ROW 3.96 COL 14 COLON-ALIGNED
     HastaF AT ROW 3.96 COL 34 COLON-ALIGNED
     Btn_OK AT ROW 5.62 COL 26
     Btn_Cancel AT ROW 5.62 COL 38
     Btn_Cancel-2 AT ROW 5.62 COL 50
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1 COL 6.43
          FONT 6
     RECT-57 AT ROW 1.19 COL 2
     RECT-46 AT ROW 5.42 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 62.14 BY 6.65
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Reporte de Salida de Material por Transferencia"
         HEIGHT             = 6.65
         WIDTH              = 62.14
         MAX-HEIGHT         = 6.65
         MAX-WIDTH          = 62.14
         VIRTUAL-HEIGHT     = 6.65
         VIRTUAL-WIDTH      = 62.14
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
{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte de Salida de Material por Transferencia */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Salida de Material por Transferencia */
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


&Scoped-define SELF-NAME Btn_Cancel-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel-2 W-Win
ON CHOOSE OF Btn_Cancel-2 IN FRAME F-Main /* Cancelar */
DO:
  RUN Asigna-Variables.
  SESSION:SET-WAIT-STATE("GENERAL").
    RUN Excel.
  SESSION:SET-WAIT-STATE("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:

    RUN Asigna-Variables.
    RUN Imprimir.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-almacen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-almacen W-Win
ON VALUE-CHANGED OF COMBO-BOX-almacen IN FRAME F-Main /* Almacén Destino */
DO:
  ASSIGN  COMBO-BOX-almacen.
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
        COMBO-BOX-almacen
        x-nroguia
        DesdeF 
        HastaF.
  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000. 
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal W-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH Reporte:
        DELETE Reporte.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Series W-Win 
PROCEDURE Carga-Series :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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
DEF VAR x-Tipo   AS CHAR.
DEF VAR NRODOC   AS char.
DEF VAR nroser   AS INTEGER.
   
nroser =  integer(x-nroguia:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

RUN Borra-Temporal.
FOR EACH almcmov WHERE almcmov.codcia = s-CodCia
    and almcmov.codalm = s-codalm
    and almcmov.tipmov = 'S'
    and almcmov.codmov = 3
    and almcmov.nroser = nroser
    and almcmov.fchdoc >= DesdeF
    and almcmov.fchdoc <= HastaF,
        each almdmov no-lock where almdmov.codcia = almcmov.codcia
             and almdmov.codalm = almcmov.codalm
             and almdmov.tipmov = almcmov.tipmov
             and almdmov.codmov = almcmov.codmov
             and almdmov.nroser = almcmov.nroser
             and almdmov.nrodoc = almcmov.nrodoc,
             each almmmatg no-lock where almmmatg.codcia = almdmov.codcia
                  and almmmatg.codmat = almdmov.codmat,
                        EACH almacen WHERE almacen.CodCia = Almcmov.CodCia
                            AND almacen.CodAlm = Almcmov.Almdes
                            break by almcmov.nroser
                                  BY almcmov.nrodoc
                                  BY almcmov.almdes:

                       Nrodoc = '0' + string(Almcmov.NroSer) + string(Almcmov.NroDoc).
                       create reporte.                       
                       assign
                           Reporte.CodAlm = Almcmov.CodAlm
                           Reporte.TpoMov = Almcmov.TipMov
                           Reporte.CodMov = Almcmov.CodMov
                           Reporte.NroDoc = Nrodoc /*Almcmov.NroDoc*/
                           Reporte.FchDoc = Almcmov.FchDoc
                           Reporte.AlmDes = Almcmov.AlmDes
                           Reporte.DesAlm = Almacen.Descripcion
                           Reporte.NroPed = Almcmov.NroRf1
                           Reporte.NroRef = Almcmov.NroRf2
                           Reporte.CodMat = Almdmov.CodMat
                           Reporte.DesMat = Almmmatg.DesMat
                           Reporte.UndBas = Almmmatg.UndBas
                           Reporte.CanMat = Almdmov.CanDes.        
                           
                                 
END.    
   
IF COMBO-BOX-almacen:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> 'Todos' THEN DO:
   FOR EACH Reporte WHERE Reporte.AlmDes <> COMBO-BOX-almacen:SCREEN-VALUE IN FRAME {&FRAME-NAME}:
       DELETE Reporte.
   END.
END.

RUN Carga-Temporal2.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal2 W-Win 
PROCEDURE Carga-Temporal2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF VAR x-Tipo AS CHAR.
    DEF VAR x-NroDoc AS CHARACTER.
    DEF VAR x-Valor AS DEC.
  
  FOR EACH Reporte-1:
        DELETE Reporte-1.
  END.  
  
  FOR EACH Reporte NO-LOCK:
    FIND FIRST almcmov WHERE almcmov.codcia = S-CodCia
        and almcmov.codalm = Reporte.AlmDes
        and almcmov.tipmov = 'I'
        and almcmov.codmov = 3
        and almcmov.nrodoc = integer(Reporte.NroRef)
        and almcmov.almdes = Reporte.CodAlm
        no-lock no-error.
        IF AVAILABLE almcmov THEN DO:
           FOR EACH b-dmov no-lock where b-dmov.codcia = almcmov.codcia
             and b-dmov.codalm = almcmov.codalm
             and b-dmov.tipmov = almcmov.tipmov
             and b-dmov.codmov = almcmov.codmov
             and b-dmov.nroser = almcmov.nroser
             and b-dmov.nrodoc = almcmov.nrodoc,
             each almmmatg no-lock where almmmatg.codcia = b-dmov.codcia
                  and almmmatg.codmat = b-dmov.codmat
                       break by almcmov.nrodoc:                       
                       create Reporte-1.
                       assign
                            Reporte-1.CodAlm = almcmov.CodAlm
                            Reporte-1.NroDoc = almcmov.NroDoc
                            Reporte-1.FchDoc = almcmov.FchDoc
                            Reporte-1.AlmRec = almcmov.AlmDes
                            Reporte-1.NroDc1 = '0' + string(decimal(substring(almcmov.NroRf1,1,3))) + string(decimal(substring(almcmov.NroRf1,4)))
                            Reporte-1.CodArt = b-dmov.CodMat
                            Reporte-1.DesArt = Almmmatg.DesMat
                            Reporte-1.Unidad = almmmatg.UndBas 
                            Reporte-1.CanArt = b-dmov.CanDes.                            
           END.  
        END.
  END.
  RELEASE Reporte.

  FOR EACH Reporte-1 break by Reporte-1.CodArt:
      FIND FIRST Reporte Where Reporte.CodAlm = Reporte-1.AlmRec
           AND Reporte.NroDoc = REPORTE-1.NRODC1
           AND Reporte.AlmDes = Reporte-1.CodAlm
           AND INTEGER(Reporte.NroRef) = Reporte-1.NroDoc
           AND Reporte.CodMat = Reporte-1.CodArt
           no-lock no-error.
      IF AVAILABLE Reporte then do:      
           ASSIGN 
              Reporte.AlmRec = Reporte-1.CodAlm
              Reporte.NroDc1 = Reporte-1.NroDoc
              Reporte.FchRec = Reporte-1.FchDoc
              Reporte.CodArt = Reporte-1.CodArt
              Reporte.DesArt = Reporte-1.DesArt
              Reporte.Unidad = Reporte-1.Unidad
              Reporte.CanArt = Reporte-1.CanArt
              Reporte.DiasEn = INTEGER(Reporte.FchRec) - INTEGER(Reporte.FchDoc).
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
  DISPLAY x-nroguia COMBO-BOX-almacen DesdeF HastaF 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 x-nroguia COMBO-BOX-almacen DesdeF HastaF Btn_OK Btn_Cancel 
         Btn_Cancel-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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
DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.

RUN Carga-Temporal.


/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "NºGuía".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Fecha".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Alm.Destino".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion                        ".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "NºPedido".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Cód.Material".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripción".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Und.Bas".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Cantidad".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "Alm. Recepción".
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "Guía Ingreso".
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = "Fecha Ingreso".
cRange = "M" + cColumn.
chWorkSheet:Range(cRange):Value = "Cód.Material".
cRange = "N" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripción".
cRange = "O" + cColumn.
chWorkSheet:Range(cRange):Value = "Unidades".
cRange = "P" + cColumn.
chWorkSheet:Range(cRange):Value = "Cantidad".
cRange = "Q" + cColumn.
chWorkSheet:Range(cRange):Value = "Dias de Entrega".

DEF BUFFER B-Reporte FOR Reporte.
loopREP:
FOR EACH Reporte NO-LOCK BREAK BY Reporte.NroDoc BY Reporte.AlmRec :
   /* IF FIRST-OF(Reporte.NroDoc) THEN DO:*/
        t-Column = t-Column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = Reporte.NroDoc.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = Reporte.FchDoc.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = Reporte.AlmDes.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = Reporte.DesAlm.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = Reporte.NroPed.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = Reporte.CodMat.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = Reporte.DesMat.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = Reporte.UndBas.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = Reporte.CanMat.
        IF Reporte.AlmRec <> '' THEN DO:
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):Value = Reporte.AlmRec.
            cRange = "K" + cColumn.
            chWorkSheet:Range(cRange):Value = Reporte.NroDc1.
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = Reporte.FchRec.
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = Reporte.CodArt.
            cRange = "N" + cColumn.
            chWorkSheet:Range(cRange):Value = Reporte.DesArt.
            cRange = "O" + cColumn.
            chWorkSheet:Range(cRange):Value = Reporte.Unidad.
            cRange = "P" + cColumn.
            chWorkSheet:Range(cRange):Value = Reporte.CanArt.
            cRange = "Q" + cColumn.
            chWorkSheet:Range(cRange):Value = Reporte.DiasEn.
        END.
        
        i-Column = 70.                   /* Letra F */
        j-Column = 0.
        FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
                AND Almacen.FlgRep = YES AND Almacen.AlmCsg = NO:
            i-Column = i-Column + 1.
            IF i-Column > 90            /* 'Z' */
            THEN ASSIGN
                    i-Column = 65       /* 'A' */
                    j-Column = IF j-Column = 0 THEN 65 ELSE j-Column + 1.
            FIND B-Reporte where B-Reporte.NroDoc = Reporte.NroDoc
                AND B-Reporte.CodAlm = Almacen.CodAlm
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE B-Reporte THEN NEXT.
            IF j-Column = 0
            THEN cRange = CHR(i-Column) + cColumn.
            ELSE cRange = CHR(j-Column) + CHR(i-Column) + cColumn.
            /*chWorkSheet:Range(cRange):Value = B-DETALLE.StkAct.*/
        /*END.*/
    
        END.
        DISPLAY
           Reporte.NroDoc
           FORMAT "X(15)" LABEL "   Procesando documento"
           WITH FRAME f-mensajes.
        READKEY PAUSE 0.
        IF LASTKEY = KEYCODE("F10") THEN LEAVE loopREP.
   
END.
HIDE FRAME f-mensajes NO-PAUSE.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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

    DEF VAR cNomProv LIKE Gn-Prov.Nombre NO-UNDO.

    DEFINE FRAME F-REPORTE
                Reporte.TpoMov   COLUMN-LABEL "Mov." 
                Reporte.CodMov   COLUMN-LABEL "Código!Mvto"
                Reporte.NroDoc   COLUMN-LABEL "Nº Guía!Remisión"
                Reporte.FchDoc   COLUMN-LABEL "Fecha!Salida"
                Reporte.AlmDes   COLUMN-LABEL "Código!Almacén"
                Reporte.DesAlm   COLUMN-LABEL "Almacén!Dest"
                Reporte.NroPed   COLUMN-LABEL "NºPedido"
                Reporte.CodMat   COLUMN-LABEL "Material"
                Reporte.DesMat   COLUMN-LABEL "Descripción"
                Reporte.UndBas   COLUMN-LABEL "Unidad!Base" FORMAT 'x(7)'
                Reporte.CanMat   COLUMN-LABEL "Cantidad" 
                Reporte.AlmRec   COLUMN-LABEL "Almacén!Recepción"
                Reporte.NroDc1   COLUMN-LABEL "Nº Guia!Ingreso"
                Reporte.FchRec   COLUMN-LABEL "Fecha!Recepción"
                Reporte.CodArt   COLUMN-LABEL "Material"
                Reporte.DesArt   COLUMN-LABEL "Descripción"
                Reporte.Unidad   COLUMN-LABEL "Unidades"
                Reporte.CanArt   COLUMN-LABEL "Cantidad!Ingresada"
                Reporte.DiasEn   COLUMN-LABEL "Dias de!Entrega"
        HEADER
        "REPORTE DE ENTRADA O SALIDA DE MATERIAL" AT 50 SKIP(2)
        "DESDE EL" DesdeF "HASTA EL" HastaF SKIP(2)
        WITH STREAM-IO NO-BOX DOWN WIDTH 320.
  looprep:
  FOR EACH Reporte NO-LOCK BREAK BY Reporte.NroDoc BY Reporte.AlmRec :
         DISPLAY STREAM REPORT  
                Reporte.TpoMov   
                Reporte.CodMov   
                Reporte.NroDoc  
                Reporte.FchDoc   
                Reporte.AlmDes
                Reporte.DesAlm
                Reporte.NroPed 
                Reporte.CodMat
                Reporte.DesMat
                Reporte.UndBas
                Reporte.CanMat   /*
                Reporte.AlmRec
                Reporte.NroDc1  WHEN Reporte.NroDc1 <> 0
                Reporte.FchRec
                Reporte.CodArt
                Reporte.DesArt
                Reporte.Unidad
                Reporte.CanArt*/
            WITH FRAME F-REPORTE.
            IF Reporte.AlmRec <> '' THEN DO:
                DISPLAY STREAM Report
                    Reporte.AlmRec
                    Reporte.NroDc1 
                    Reporte.FchRec
                    Reporte.CodArt
                    Reporte.DesArt
                    Reporte.Unidad
                    Reporte.CanArt
                    Reporte.DiasEn 
                    WITH FRAME F-REPORTE.
            END.

            DISPLAY
               Reporte.NroDoc
               FORMAT "X(15)" LABEL "   Procesando documento"
               WITH FRAME f-mensajes.
            READKEY PAUSE 0.
            IF LASTKEY = KEYCODE("F10") THEN LEAVE loopREP.
  END.
  HIDE FRAME f-mensajes.
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
      
    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".
    
    RUN Carga-Temporal.
    
    IF not Can-find (First Reporte) then do:
        message "No hay registros a imprimir" VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    
    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM report TO VALUE(s-print-file) /*PAGED PAGE-SIZE 62*/ .
            WHEN 2 THEN
                OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
        RUN Formato.
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
        ASSIGN
            DesdeF = DATE(MONTH(TODAY),1,YEAR(TODAY))
            HastaF = TODAY.
        /*Almacenes*/
        COMBO-BOX-almacen:list-items = "Todos".
        for each almacen no-lock.
           p = COMBO-BOX-almacen:add-last(almacen.codalm).
        end.
        for each faccorre WHERE faccorre.codcia = s-codcia AND faccorre.coddoc = 'G/R'
            AND faccorre.codalm = s-codalm AND faccorre.codmov = 3.
                q = x-nroguia:ADD-LAST(STRING(FacCorre.NroSer,'999')).
        end.
    END.
    

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
        WHEN "c-CodMov" THEN 
            ASSIGN
                input-var-1 = ""
                input-var-2 = ""
                input-var-3 = "".
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

