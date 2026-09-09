&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-AlmDPInv NO-UNDO LIKE INTEGRAL.AlmDPInv
       field desmat like almmmatg.desmat
       field codmar like almmmatg.codmar
       field undstk like almmmatg.undstk
       field stkdif as decimal.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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

DEFINE SHARED VAR s-codalm AS CHAR.
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VARIABLE pRCID AS INT.

DEFINE VAR CerrarUbicacion AS LOG.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-AlmDPInv

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tt-AlmDPInv.codmat tt-AlmDPInv.desmat tt-AlmDPInv.undstk tt-AlmDPInv.codmar tt-AlmDPInv.StkInv tt-AlmDPInv.StkAct tt-AlmDPInv.StkDif   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2   
&Scoped-define SELF-NAME BROWSE-2
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tt-AlmDPInv NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY {&SELF-NAME} FOR EACH tt-AlmDPInv NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tt-AlmDPInv
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tt-AlmDPInv


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BtnExcel BtnGrabar txtCodUbi BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS txtCodAlm txtDesAlm txtCodUbi 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnExcel 
     LABEL "Excel" 
     SIZE 19 BY 1.12.

DEFINE BUTTON BtnGrabar 
     LABEL "CERRAR Ubicacion para CONTEO" 
     SIZE 37 BY 1.12.

DEFINE VARIABLE txtCodAlm AS CHARACTER FORMAT "X(3)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtCodUbi AS CHARACTER FORMAT "X(15)":U 
     LABEL "Ubicacion" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY 1
     FGCOLOR 9 FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tt-AlmDPInv SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _FREEFORM
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tt-AlmDPInv.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U
      tt-AlmDPInv.desmat COLUMN-LABEL "Descripcion" FORMAT "X(40)":U
      tt-AlmDPInv.undstk COLUMN-LABEL "U.Med" FORMAT "X(5)":U
      tt-AlmDPInv.codmar COLUMN-LABEL "Marca" FORMAT "X(25)":U
      tt-AlmDPInv.StkInv COLUMN-LABEL "Conteo" FORMAT "->>,>>>,>>9.99":U
      tt-AlmDPInv.StkAct COLUMN-LABEL "Stock" FORMAT "->>,>>>,>>9.99":U
      tt-AlmDPInv.StkDif COLUMN-LABEL "Diferencia" FORMAT "->>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 117 BY 19.88 ROW-HEIGHT-CHARS .62 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BtnExcel AT ROW 23.88 COL 13 WIDGET-ID 32
     BtnGrabar AT ROW 24.08 COL 74 WIDGET-ID 30
     txtCodAlm AT ROW 1.69 COL 9 COLON-ALIGNED WIDGET-ID 2
     txtDesAlm AT ROW 1.69 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     txtCodUbi AT ROW 1.77 COL 77 COLON-ALIGNED WIDGET-ID 6
     BROWSE-2 AT ROW 3.62 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 119.72 BY 24.46 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-AlmDPInv T "?" NO-UNDO INTEGRAL AlmDPInv
      ADDITIONAL-FIELDS:
          field desmat like almmmatg.desmat
          field codmar like almmmatg.codmar
          field undstk like almmmatg.undstk
          field stkdif as decimal
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 24.46
         WIDTH              = 119.72
         MAX-HEIGHT         = 24.46
         MAX-WIDTH          = 119.72
         VIRTUAL-HEIGHT     = 24.46
         VIRTUAL-WIDTH      = 119.72
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-2 txtCodUbi F-Main */
/* SETTINGS FOR FILL-IN txtCodAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDesAlm IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-AlmDPInv NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnExcel W-Win
ON CHOOSE OF BtnExcel IN FRAME F-Main /* Excel */
DO:
   MESSAGE 'Seguro de Generar el Excel ?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.

        IF rpta = NO THEN RETURN NO-APPLY.    
    RUN ue-excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnGrabar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnGrabar W-Win
ON CHOOSE OF BtnGrabar IN FRAME F-Main /* CERRAR Ubicacion para CONTEO */
DO:

    IF CerrarUbicacion = NO THEN DO:
        MESSAGE "Imposible CERRAR ubicacion!!!!" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
    END.


    FIND FIRST AlmUPinv WHERE AlmUPinv.codcia = s-codcia AND 
            AlmUPinv.codalm = s-codalm AND AlmUPinv.codubi = txtCodUbi
            NO-LOCK NO-ERROR.
   IF AVAILABLE AlmUPInv THEN DO:
       IF AlmUPInv.scerrado = YES THEN DO:
           MESSAGE "Ubicacion ya esta CERRADO" VIEW-AS ALERT-BOX.
           RETURN NO-APPLY.
       END.
   END.

        MESSAGE 'Seguro de CERRAR la Ubicacion ?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.

        IF rpta = NO THEN RETURN NO-APPLY.  

    FOR EACH tt-AlmDPInv NO-LOCK :
        FIND FIRST AlmDPInv WHERE AlmDPInv.codcia = s-codcia 
            AND AlmDPInv.codalm = s-codalm 
            AND AlmDPInv.codubi = tt-AlmDPInv.codubi 
            AND AlmDPInv.codmat = tt-AlmDPInv.codmat EXCLUSIVE NO-ERROR.

        IF AVAILABLE AlmDPInv THEN DO:
            ASSIGN AlmDPInv.stkact     = tt-AlmDPInv.stkact
                AlmDPInv.fchmod    = TODAY
                AlmDPInv.Hormod    = STRING(TIME,"HH:MM:SS")
                AlmDPInv.PRID-mod  = PRCID.
        END.

    END.

    FIND FIRST AlmUPinv WHERE AlmUPinv.codcia = s-codcia AND 
            AlmUPinv.codalm = s-codalm AND AlmUPinv.codubi = txtCodUbi
            EXCLUSIVE NO-ERROR.

    IF NOT AVAILABLE AlmUPInv THEN DO:
        CREATE AlmUPinv.
            ASSIGN AlmUPinv.codcia      = s-codcia
                    AlmUPinv.codalm     = s-codalm
                    AlmUPinv.codubi     = txtCodUbi
                    AlmUPinv.FchCrea    = TODAY
                    AlmUPinv.PRID-crea  = PRCID.
    END.
    ASSIGN AlmUPinv.scerrado = YES
        AlmUPinv.FchMod    = TODAY
        AlmUPinv.PRID-mod  = PRCID.


    EMPTY TEMP-TABLE tt-AlmDPInv.

    {&OPEN-QUERY-BROWSE-2}
    APPLY 'ENTRY':U TO txtCodUbi.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCodUbi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCodUbi W-Win
ON LEAVE OF txtCodUbi IN FRAME F-Main /* Ubicacion */
OR RETURN OF txtCodUbi
   
DO:
    DEFINE VAR lCerrado AS LOGICAL.

    txtcodubi:SCREEN-VALUE = REPLACE(txtcodubi:SCREEN-VALUE,"'","-").

    lCerrado = NO.
    CerrarUbicacion = YES.

    ASSIGN txtCodUbi.

    IF txtCodUbi <> "" THEN DO:            
    
        FIND FIRST AlmCPInv WHERE AlmCPInv.codcia = s-codcia AND 
                AlmCPInv.codalm = s-codalm NO-LOCK NO-ERROR.
        IF NOT AVAILABLE AlmCPInv THEN DO:
            txtCodUbi:SET-SELECTION( 1 , LENGTH(txtCodUbi) + 2).
            MESSAGE "Almacen/Ubicacion no esta en PRE-INVENTARIO" VIEW-AS ALERT-BOX.
            RETURN NO-APPLY.
        END.
        IF NOT (TODAY >= AlmCPInv.fchdesde AND TODAY <= AlmCPInv.FchHasta) THEN DO:
            txtCodUbi:SET-SELECTION( 1 , LENGTH(txtCodUbi) + 2).
            MESSAGE "Pre-Inventario fuera de FECHA" VIEW-AS ALERT-BOX.
            /*RETURN NO-APPLY.*/
        END.
        IF AlmCPInv.suspe = YES THEN DO:
            txtCodUbi:SET-SELECTION( 1 , LENGTH(txtCodUbi) + 2).
            MESSAGE "Esta suspendido la Realizacion del PRE-Inventario para este Almacen" VIEW-AS ALERT-BOX.
            /*RETURN NO-APPLY.*/
            CerrarUbicacion = NO.
        END.
    
        EMPTY TEMP-TABLE tt-AlmDPInv.
        FIND FIRST AlmUPinv WHERE AlmUPinv.codcia = s-codcia AND 
                AlmUPinv.codalm = s-codalm AND AlmUPinv.codubi = txtCodUbi
                NO-LOCK NO-ERROR.
       IF AVAILABLE AlmUPInv THEN DO:
           lCerrado = AlmUPInv.scerrado.
       END.

       IF CerrarUbicacion = NO THEN lCerrado = YES.
    
        FOR EACH AlmDPInv WHERE AlmDPInv.codcia = s-codcia 
                AND AlmDPInv.codalm = s-codalm AND AlmDPInv.codubi = txtCodUbi
                NO-LOCK:
            /* Articulos */
            FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia AND
                    Almmmatg.codmat = AlmDPInv.codmat NO-LOCK NO-ERROR.
            /* Stocks */
            FIND FIRST Almmmate WHERE Almmmate.codcia = s-codcia AND
                almmmate.codalm = s-codalm AND Almmmate.codmat = AlmDPInv.codmat NO-LOCK NO-ERROR.

            CREATE tt-AlmDPInv.
                ASSIGN tt-AlmDPInv.codcia = s-codcia
                        tt-AlmDPInv.codalm = s-codalm
                        tt-AlmDPInv.codubi = txtCodUbi
                        tt-AlmDPInv.codmat = AlmDPInv.codmat
                        tt-AlmDPInv.stkinv = AlmDPInv.stkinv
                        tt-AlmDPInv.stkact = IF(lCerrado = YES) THEN AlmDPInv.stkact ELSE 
                             IF(AVAILABLE almmmate) THEN almmmate.stkact ELSE 0
                        tt-AlmDPInv.stkdif = tt-AlmDPInv.stkinv - tt-AlmDPInv.stkact
                        tt-AlmDPInv.DesMat = IF(AVAILABLE Almmmatg) THEN Almmmatg.desmat ELSE ""
                        tt-AlmDPInv.UndStk = IF(AVAILABLE Almmmatg) THEN Almmmatg.undstk ELSE ""
                        tt-AlmDPInv.Codmar = IF(AVAILABLE Almmmatg) THEN Almmmatg.desmar ELSE ""
                            .
        END.
    
        {&OPEN-QUERY-BROWSE-2}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

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
  DISPLAY txtCodAlm txtDesAlm txtCodUbi 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BtnExcel BtnGrabar txtCodUbi BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
  FIND FIRST Almacen WHERE almacen.codcia = s-codcia AND 
      almacen.codalm = s-codalm NO-LOCK NO-ERROR.

  txtCodAlm:SCREEN-VALUE IN FRAME {&FRAME-NAME} = s-codalm .
  txtDesAlm:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF(AVAILABLE almacen) THEN almacen.descripcion ELSE "".


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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-AlmDPInv"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-buscar-en-browse W-Win 
PROCEDURE ue-buscar-en-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-codigo-valido W-Win 
PROCEDURE ue-codigo-valido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel W-Win 
PROCEDURE ue-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}
iColumn = 0.

iColumn = iColumn + 1.
cColumn = STRING(iColumn).

cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Codigo".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Und.Med".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Marca".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Conteo".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Stock".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Diferencia".

FOR EACH tt-AlmDPInv NO-LOCK:
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-AlmDPInv.codmat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-AlmDPInv.desmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-AlmDPInv.undstk.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-AlmDPInv.codmar.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-AlmDPInv.StkInv.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-AlmDPInv.StkAct.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-AlmDPInv.StkDif.
END.


{lib\excel-close-file.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-registra-conteo-art W-Win 
PROCEDURE ue-registra-conteo-art :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-validar W-Win 
PROCEDURE ue-validar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

