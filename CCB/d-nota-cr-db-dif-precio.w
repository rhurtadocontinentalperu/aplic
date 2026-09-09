&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.
DEFINE TEMP-TABLE ttCcbcdocu NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE ttCcbDDocu NO-UNDO LIKE CcbDDocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
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
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-coddoc AS CHAR INIT "N/C" NO-UNDO.

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER pCoddiv AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pCoddoc AS CHAR NO-UNDO.     /* PNC */
DEFINE INPUT PARAMETER pNrodoc AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

DEF SHARED VAR s-cndcre AS CHAR.
DEF SHARED VAR s-tpofac AS CHAR.
DEF SHARED VAR s-Tipo   AS CHAR.

FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
    ccbcdocu.coddiv = pCoddiv AND
    ccbcdocu.coddoc = pCodDoc AND
    ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN DO:
    pRetVal = "El documento :" + CHR(10) +
        ccbcdocu.coddoc + "-" + ccbcdocu.nrodoc + CHR(10) +
        "De : " + ccbcdocu.codcli + "-" + ccbcdocu.nomcli.
    MESSAGE pRetVal VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.
IF ccbcdocu.flgest <> 'P' AND ccbcdocu.flgest <> 'AP' THEN DO:
    pRetVal = "El documento :" + CHR(10) +
        ccbcdocu.coddoc + "-" + ccbcdocu.nrodoc + CHR(10) +
        "De : " + ccbcdocu.codcli + "-" + ccbcdocu.nomcli + CHR(10) +
        "YA NO ESTA APROBADA!!!".
    MESSAGE pRetVal VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

/* Local Variable Definitions ---                                       */

DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

/* Validación Primaria */
FIND FIRST Vtactabla WHERE Vtactabla.codcia = s-codcia AND
    Vtactabla.tabla = "CFG_TIPO_NC" AND
    Vtactabla.llave = s-TpoFac AND
    CAN-FIND(FIRST Vtadtabla OF Vtactabla WHERE Vtadtabla.tipo = "CONCEPTO" AND
             CAN-FIND(FIRST Ccbtabla WHERE Ccbtabla.codcia = s-codcia AND 
                      Ccbtabla.tabla = s-coddoc AND
                      Ccbtabla.codigo = Vtadtabla.llavedetalle
                      NO-LOCK)
             NO-LOCK)
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Vtactabla THEN DO:
    pRetVal = 'NO está configurado el sistema con el tipo: ' + s-TpoFac.
    MESSAGE pRetVal VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

/* Cargamos los temporales */
RUN Carga-Temporales.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-5

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttCcbDDocu Almmmatg ttCcbcdocu

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 ttCcbDDocu.NroItm ttCcbDDocu.codmat ~
Almmmatg.DesMat Almmmatg.DesMar ttCcbDDocu.CanDes ttCcbDDocu.UndVta ~
ttCcbDDocu.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH ttCcbDDocu OF ttCcbcdocu NO-LOCK, ~
      EACH Almmmatg OF ttCcbDDocu NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH ttCcbDDocu OF ttCcbcdocu NO-LOCK, ~
      EACH Almmmatg OF ttCcbDDocu NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 ttCcbDDocu Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 ttCcbDDocu
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-5 Almmmatg


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define FIELDS-IN-QUERY-D-Dialog ttCcbcdocu.CodDoc ttCcbcdocu.NroDoc ~
ttCcbcdocu.CodCli ttCcbcdocu.NomCli ttCcbcdocu.CodMon 
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-5}
&Scoped-define QUERY-STRING-D-Dialog FOR EACH ttCcbcdocu SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH ttCcbcdocu SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog ttCcbcdocu
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog ttCcbcdocu


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 COMBO-NroSer ~
COMBO-BOX-Concepto BROWSE-5 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-FIELDS ttCcbcdocu.CodDoc ttCcbcdocu.NroDoc ~
ttCcbcdocu.CodCli ttCcbcdocu.NomCli ttCcbcdocu.CodMon 
&Scoped-define DISPLAYED-TABLES ttCcbcdocu
&Scoped-define FIRST-DISPLAYED-TABLE ttCcbcdocu
&Scoped-Define DISPLAYED-OBJECTS COMBO-NroSer FILL-IN-NroDoc ~
COMBO-BOX-Concepto FILL-IN-Importe 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-Concepto AS CHARACTER FORMAT "X(256)":U 
     LABEL "Seleccione el Concepto" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 20
     DROP-DOWN-LIST
     SIZE 59 BY .81 NO-UNDO.

DEFINE VARIABLE COMBO-NroSer AS CHARACTER FORMAT "999":U 
     LABEL "Serie de la N/C" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 7 BY 1
     FGCOLOR 9 FONT 4 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "TOTAL" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "XXX-XXXXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 119 BY 2.96.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 119 BY 2.42.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      ttCcbDDocu, 
      Almmmatg SCROLLING.

DEFINE QUERY D-Dialog FOR 
      ttCcbcdocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 D-Dialog _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      ttCcbDDocu.NroItm COLUMN-LABEL "Item" FORMAT ">>9":U WIDTH 4.43
      ttCcbDDocu.codmat COLUMN-LABEL "Artículo" FORMAT "X(6)":U
            WIDTH 10.43
      Almmmatg.DesMat FORMAT "X(100)":U WIDTH 54.43
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(25)":U WIDTH 18.43
      ttCcbDDocu.CanDes FORMAT ">,>>>,>>9.9999":U WIDTH 7.86
      ttCcbDDocu.UndVta FORMAT "x(8)":U
      ttCcbDDocu.ImpLin FORMAT "->>,>>>,>>9.99":U WIDTH 11
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 119 BY 12.65
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     ttCcbcdocu.CodDoc AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 46
          LABEL "Pre-Nota" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     ttCcbcdocu.NroDoc AT ROW 1.27 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 50
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     ttCcbcdocu.CodCli AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 44
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     ttCcbcdocu.NomCli AT ROW 2.08 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 48 FORMAT "x(100)"
          VIEW-AS FILL-IN 
          SIZE 50 BY .81
     ttCcbcdocu.CodMon AT ROW 2.88 COL 21 NO-LABEL WIDGET-ID 96
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 17 BY .81
     COMBO-NroSer AT ROW 4.5 COL 19 COLON-ALIGNED WIDGET-ID 42
     FILL-IN-NroDoc AT ROW 4.5 COL 29 NO-LABEL WIDGET-ID 80
     COMBO-BOX-Concepto AT ROW 5.31 COL 19 COLON-ALIGNED WIDGET-ID 90
     BROWSE-5 AT ROW 6.38 COL 2 WIDGET-ID 200
     FILL-IN-Importe AT ROW 19.04 COL 105 COLON-ALIGNED WIDGET-ID 4
     Btn_OK AT ROW 19.31 COL 2
     Btn_Cancel AT ROW 19.31 COL 17
     RECT-1 AT ROW 1 COL 2 WIDGET-ID 100
     RECT-2 AT ROW 3.96 COL 2 WIDGET-ID 102
     SPACE(1.42) SKIP(14.38)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "GENERACION DE NOTA DE  CREDITO"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
      TABLE: ttCcbcdocu T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: ttCcbDDocu T "?" NO-UNDO INTEGRAL CcbDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   NOT-VISIBLE FRAME-NAME                                               */
/* BROWSE-TAB BROWSE-5 COMBO-BOX-Concepto D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN ttCcbcdocu.CodCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ttCcbcdocu.CodDoc IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR RADIO-SET ttCcbcdocu.CodMon IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN ttCcbcdocu.NomCli IN FRAME D-Dialog
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN ttCcbcdocu.NroDoc IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.ttCcbDDocu OF Temp-Tables.ttCcbcdocu,INTEGRAL.Almmmatg OF Temp-Tables.ttCcbDDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.ttCcbDDocu.NroItm
"ttCcbDDocu.NroItm" "Item" ? "integer" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ttCcbDDocu.codmat
"ttCcbDDocu.codmat" "Artículo" ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(100)" "character" ? ? ? ? ? ? no ? no no "54.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(25)" "character" ? ? ? ? ? ? no ? no no "18.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ttCcbDDocu.CanDes
"ttCcbDDocu.CanDes" ? ? "decimal" ? ? ? ? ? ? no ? no no "7.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = Temp-Tables.ttCcbDDocu.UndVta
     _FldNameList[7]   > Temp-Tables.ttCcbDDocu.ImpLin
"ttCcbDDocu.ImpLin" ? ? "decimal" ? ? ? ? ? ? no ? no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "Temp-Tables.ttCcbcdocu"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* GENERACION DE NOTA DE  CREDITO */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
    ASSIGN
        COMBO-BOX-Concepto COMBO-NroSer.

    DEFINE VAR hxProc AS HANDLE NO-UNDO.                /* Handle Libreria */
    DEFINE VAR x-retval AS CHAR.
    
    RUN ccb\libreria-ccb.r PERSISTENT SET hxProc.
                                                     
    RUN notas-creditos-supera-comprobante IN hxProc (INPUT ttCcbCdocu.codref, 
                                                     INPUT ttCcbCdocu.nroref,
                                                     OUTPUT x-retval).
    
    DELETE PROCEDURE hxProc.                    /* Release Libreria */
    
    /* 
        pRetVal : NO (importes de N/C NO supera al comprobante)
    */
    IF x-retval <> "NO" THEN DO:
        MESSAGE "El comprobante " + ttCcbCdocu.codref + " " + ttCcbCdocu.nroref SKIP
            "tiene emitida varias N/Cs que la suma de sus importes" SKIP
            "superan al importe total del comprobante"
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.
    ASSIGN 
        COMBO-NroSer.
    IF COMBO-NroSer = ? OR (TRUE <> (COMBO-NroSer > "")) THEN DO:
        MESSAGE "Elija el Nro de Serie" VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.
    MESSAGE 'Seguro de generar la N/C con Serie Nro : ' + STRING(COMBO-NroSer,"999")
        VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
    /* * */
    SESSION:SET-WAIT-STATE("GENERAL").
    RUN grabar-datos.
    SESSION:SET-WAIT-STATE("").
    IF RETURN-VALUE = 'OK' THEN DO:
        pRetVal = "OK".
    END.
    ELSE DO:
        pRetVal = "ADM-ERROR".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer D-Dialog
ON VALUE-CHANGED OF COMBO-NroSer IN FRAME D-Dialog /* Serie de la N/C */
DO:
    /* Correlativo */
    FIND FacCorre WHERE FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDoc = s-CodDoc AND
        FacCorre.CodDiv = s-CodDiv AND
        FacCorre.NroSer = INTEGER(SELF:SCREEN-VALUE)
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCorre THEN
        FILL-IN-NroDoc =
            STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) +
            STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')).
    ELSE FILL-IN-NroDoc = "".
    DISPLAY FILL-IN-NroDoc WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporales D-Dialog 
PROCEDURE Carga-Temporales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE ttCcbcdocu.    
CREATE ttCcbcdocu.
BUFFER-COPY ccbcdocu TO ttCcbcdocu
    ASSIGN 
    ttCcbcdocu.coddiv = s-coddiv
    ttCcbcdocu.codped = Ccbcdocu.coddoc          /* PNC */
    ttCcbcdocu.nroped = Ccbcdocu.nrodoc
    ttCcbcdocu.fchdoc = TODAY
    ttCcbcdocu.fchvto = TODAY + 365
    ttCcbcdocu.usuario = s-user-id
    ttCcbcdocu.flgest = 'P'
    /* Se va recalcular x si algun item no sea APROBADO x el jefe de Linea */
    ttCcbcdocu.ImpBrt = 0
    ttCcbcdocu.ImpExo = 0
    ttCcbcdocu.ImpDto = 0
    ttCcbcdocu.ImpIgv = 0
    ttCcbcdocu.ImpTot = 0
    .
EMPTY TEMP-TABLE ttCcbddocu.
FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
    CREATE ttCcbddocu.
    BUFFER-COPY Ccbddocu TO ttCcbddocu.
END.

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
  DISPLAY COMBO-NroSer FILL-IN-NroDoc COMBO-BOX-Concepto FILL-IN-Importe 
      WITH FRAME D-Dialog.
  IF AVAILABLE ttCcbcdocu THEN 
    DISPLAY ttCcbcdocu.CodDoc ttCcbcdocu.NroDoc ttCcbcdocu.CodCli 
          ttCcbcdocu.NomCli ttCcbcdocu.CodMon 
      WITH FRAME D-Dialog.
  ENABLE RECT-1 RECT-2 COMBO-NroSer COMBO-BOX-Concepto BROWSE-5 Btn_OK 
         Btn_Cancel 
      WITH FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-datos D-Dialog 
PROCEDURE grabar-datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-msg AS CHAR.
DEFINE VAR x-serie AS INT.
DEFINE VAR x-numero AS INT.
DEFINE VAR x-nrodoc AS CHAR.

DEFINE BUFFER b-ccbcdocu   FOR ccbcdocu.
DEFINE BUFFER b-ccbddocu   FOR ccbddocu.
DEFINE BUFFER pnc-ccbcdocu FOR ccbcdocu.

/* Volvemos a cargar el buffer con el registro de la base de datos */
FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
    ccbcdocu.coddiv = pCoddiv AND
    ccbcdocu.coddoc = pCodDoc AND       /* PNC */
    ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
IF AVAILABLE ccbcdocu THEN DO:
    IF (ccbcdocu.flgest <> 'P' AND ccbcdocu.flgest <> 'AP')  THEN DO:
        MESSAGE "El documento :" SKIP
                ccbcdocu.coddoc + "-" ccbcdocu.nrodoc SKIP
                "De : " + ccbcdocu.codcli + "-" + ccbcdocu.nomcli SKIP
                "YA NO ESTA APROBADO!!!"
                VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END.
END.
ELSE DO:
    MESSAGE "El documento :" SKIP
            pCodDoc + "-" pNroDoc SKIP
            "NO EXISTE!!!"
            VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.

/* Grabar datos de la nota de credito */
GRABAR_DOCUMENTO:
DO TRANSACTION ON ERROR UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO:
    EMPTY TEMP-TABLE T-FELogErrores.
    /* El numero de serie */ 
    {lib/lock-genericov3.i ~
        &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = s-codcia ~
        AND FacCorre.CodDiv = s-coddiv ~
        AND FacCorre.CodDoc = s-coddoc ~
        AND FacCorre.NroSer = INTEGER(COMBO-NroSer)" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-WAIT" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="x-Msg" ~
        &TipoError="UNDO, LEAVE GRABAR_DOCUMENTO" ~
        }
    ASSIGN
        x-serie  = FacCorre.nroser
        x-numero = Faccorre.correlativo.
    ASSIGN 
        Faccorre.correlativo = Faccorre.correlativo + 1.
    RELEASE FacCorre.

    /* Ultimos ajustes a los temporales */
    /*x-nrodoc = STRING(x-serie,"999") + STRING(x-numero,"99999999").*/
    x-NroDoc = STRING(x-Serie,ENTRY(1,x-Formato,'-')) + 
        STRING(x-Numero,ENTRY(2,x-Formato,'-')).
    ASSIGN 
        ttccbcdocu.codcia = s-codcia 
        ttccbcdocu.coddiv = s-coddiv
        ttccbcdocu.coddoc = s-coddoc
        ttccbcdocu.nrodoc = x-nrodoc
        ttccbcdocu.fchdoc = TODAY
        ttccbcdocu.horcie = STRING(TIME,"HH:MM:SS")
        ttccbcdocu.fchvto = ADD-INTERVAL(TODAY,1,'year')
        ttCcbCDocu.CndCre = s-CndCre
        ttCcbCDocu.TpoFac = s-TpoFac
        ttCcbCDocu.Tipo   = s-Tipo
        ttCcbCDocu.usuario = S-USER-ID
        ttCcbcdocu.CodCta = ENTRY(1,COMBO-BOX-Concepto," - ")
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        x-msg = "ERROR - ttCcbcdocu :(" + ERROR-STATUS:GET-MESSAGE(1) + ")".
        UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO.
    END.
    /* Detalle */
    FOR EACH ttCcbddocu :
        /* Las notas de credito no tienen descuento */
        ASSIGN 
            ttccbcdocu.codcia = s-codcia 
            ttccbddocu.coddiv = s-coddiv
            ttccbddocu.coddoc = s-coddoc
            ttCcbddocu.nrodoc = x-nrodoc 
            ttCcbddocu.dcto_otros_factor = 0
            ttCcbddocu.Por_Dsctos[1] = 0
            ttCcbddocu.Por_Dsctos[2] = 0
            ttCcbddocu.Por_Dsctos[3] = 0
            NO-ERROR.                
        IF ERROR-STATUS:ERROR THEN DO:
            x-msg = "ERROR - ttCcbddocu (" + ERROR-STATUS:GET-MESSAGE(1) + ")".
            UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO.
        END.
    END.
    /* La cabecera del documento */
    CREATE b-ccbcdocu.
    BUFFER-COPY ttCcbcdocu TO b-ccbcdocu NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        x-msg = "ERROR al crear registro en CCBCDOCU (" + ERROR-STATUS:GET-MESSAGE(1) + ")".
        UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO.
    END.
    /* **************************** */
    /* Control de Aprobación de N/C */
    RUN lib/LogTabla ("ccbcdocu", b-ccbcdocu.coddoc + ',' + b-ccbcdocu.nrodoc, "APROBADO").
    /* **************************** */
    FOR EACH ttCcbddocu ON ERROR UNDO, THROW:
        /* Detalle update block */
        CREATE b-ccbddocu.
        BUFFER-COPY ttCcbddocu TO b-ccbddocu NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            x-msg = "ERROR al crear registro en CCBDDOCU (" + ERROR-STATUS:GET-MESSAGE(1) + ")".
            UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO.
        END.
    END.
    /* TOTALES */
    {vtagn/i-total-factura-sunat.i &Cabecera="b-Ccbcdocu" &Detalle="b-Ccbddocu"}
    /* ****************************** */
    /* Ic - 16Nov2021 - Importes Arimetica de SUNAT */
    /* ****************************** */
    DEF VAR hProc AS HANDLE NO-UNDO.
    RUN sunat/sunat-calculo-importes.r PERSISTENT SET hProc.
    RUN tabla-ccbcdocu IN hProc (INPUT s-coddiv,
                                 INPUT s-coddoc,
                                 INPUT x-nrodoc,
                                 OUTPUT x-msg).
    DELETE PROCEDURE hProc.
    /* ****************************** */
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO.
    END.

    /* Actualizo el estado de la PNC */
    FIND FIRST pnc-ccbcdocu OF ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
    IF LOCKED pnc-ccbcdocu THEN DO:
        x-msg = "La tabla CCBCDOCU esta bloqueada por otro usuario, se intento actualizar el estado de la PNC".
        UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO.
    END.                                  
    ASSIGN 
        pnc-ccbcdocu.flgest = 'G' NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        x-msg = "ERROR al actualizar el estado de la PNC (" + ERROR-STATUS:GET-MESSAGE(1) + ")".
        UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO.
    END.
    RELEASE pnc-ccbcdocu.
    /* ************************************************** */
    /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
    RUN sunat\progress-to-ppll-v3  ( INPUT s-coddiv,
                                     INPUT s-coddoc,
                                     INPUT x-nrodoc,
                                     INPUT-OUTPUT TABLE T-FELogErrores,
                                     OUTPUT x-Msg ).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, LEAVE GRABAR_DOCUMENTO.
    IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
        /* NO se pudo confirmar el comprobante en el e-pos */
        /* Se procede a ANULAR el comprobante              */
        x-Msg = "Hubo problemas en la generación del documento" + CHR(10) +
            "Mensaje : " + x-Msg + CHR(10) +
            "Por favor intente de nuevo".
        ASSIGN
            b-CcbCDocu.FchAnu = TODAY
            b-CcbCDocu.FlgEst = "A"
            b-CcbCDocu.SdoAct = 0
            b-CcbCDocu.UsuAnu = s-user-id.
        /* Por Error, Anular la N/C y cambiar el estado a P (Aprobada) */
        FIND FIRST pnc-ccbcdocu OF ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE pnc-ccbcdocu THEN ASSIGN pnc-ccbcdocu.flgest = 'P' NO-ERROR.
        ASSIGN  
            b-Ccbcdocu.FlgEst = "A"
            b-CcbCDocu.UsuAnu = "ERROR-FE"
            b-CcbCDocu.FchAnu = TODAY
            b-CcbCDocu.SdoAct = 0.
        LEAVE GRABAR_DOCUMENTO.
    END.
    /* *********************************************************** */
    ASSIGN
        x-Msg = "OK".
END. /* TRANSACTION block */

RELEASE b-ccbcdocu.
RELEASE b-ccbddocu.

IF x-Msg <> "OK" THEN DO:
    IF x-Msg > "" THEN MESSAGE x-Msg VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importe-Total D-Dialog 
PROCEDURE Importe-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER bDOCU FOR ttCcbDDocu.

FILL-IN-Importe = 0.

FOR EACH bDOCU NO-LOCK:
    FILL-IN-Importe = FILL-IN-Importe + bDOCU.ImpLin.
END.
DISPLAY FILL-IN-Importe WITH FRAME {&FRAME-NAME}.

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
  DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.
  
  FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
  DO WITH FRAME {&FRAME-NAME}:
      FILL-IN-NroDoc:FORMAT = x-Formato.
      /* CORRELATIVO DE FAC y BOL */
      {sunat\i-lista-series.i &CodCia=s-CodCia ~
          &CodDiv=s-CodDiv ~
          &CodDoc=s-CodDoc ~
          &FlgEst='' ~          /* En blanco si quieres solo ACTIVOS */
          &Tipo=s-Tipo ~
          &ListaSeries=cListItems ~
          }

      ASSIGN
          COMBO-NroSer:LIST-ITEMS = cListItems
          COMBO-NroSer = ENTRY(1,COMBO-NroSer:LIST-ITEMS).
      /* Correlativo */
      FIND FacCorre WHERE FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDoc = s-CodDoc AND
          FacCorre.CodDiv = s-CodDiv AND
          FacCorre.NroSer = INTEGER(COMBO-NroSer)
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN
          FILL-IN-NroDoc =
              STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) +
              STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')).
      /* Conceptos N/C */
      cListItems = "".
      FOR EACH Vtactabla NO-LOCK WHERE Vtactabla.codcia = s-codcia AND
          Vtactabla.tabla = "CFG_TIPO_NC" AND
          Vtactabla.llave = s-TpoFac,
          EACH Vtadtabla OF Vtactabla NO-LOCK WHERE Vtadtabla.tipo = "CONCEPTO",
          FIRST Ccbtabla NO-LOCK WHERE Ccbtabla.codcia = s-codcia AND 
          Ccbtabla.tabla = s-coddoc AND
          Ccbtabla.codigo = Vtadtabla.llavedetalle:
          IF cListItems = "" THEN cListItems = CcbTabla.Codigo +  ' - ' + CcbTabla.Nombre.
          ELSE cListItems = cListItems + "|" + CcbTabla.Codigo +  ' - ' + CcbTabla.Nombre.
      END.
      ASSIGN
          COMBO-BOX-Concepto:DELIMITER = '|'
          COMBO-BOX-Concepto:LIST-ITEMS = cListItems
          COMBO-BOX-Concepto = ENTRY(1,COMBO-BOX-Concepto:LIST-ITEMS, '|').

      RUN Importe-Total.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "ttCcbcdocu"}
  {src/adm/template/snd-list.i "ttCcbDDocu"}
  {src/adm/template/snd-list.i "Almmmatg"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

