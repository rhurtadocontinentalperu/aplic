&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
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

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

DEF SHARED VAR s-CodCia AS INT.
DEF SHARED VAR cl-CodCia AS INT.
DEF SHARED VAR s-CodDiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-nomcia AS CHAR.

DEFINE SHARED VARIABLE S-FLGSIT AS CHAR.

DEF VAR x-FchPed-1 AS DATE NO-UNDO.
DEF VAR x-FchPed-2 AS DATE NO-UNDO.
DEF VAR s-task-no AS INT NO-UNDO.

&SCOPED-DEFINE Condicion ( VtaCDocu.CodCia = s-CodCia AND ~
    VtaCDocu.CodDiv = s-CodDiv AND ~
    VtaCDocu.CodPed = 'HPK' AND ~
    VtaCDocu.FchPed >= x-FchPed-1 AND ~
    VtaCDocu.FchPed <= x-FchPed-2 AND ~
    VtaCDocu.FlgEst = 'P' AND ~
    (s-FlgSit = 'Todos' OR VtaCDocu.FlgSit BEGINS s-FlgSit) )

DEFINE TEMP-TABLE Reporte
    FIELD Tipo      AS CHAR 
    FIELD CodDoc    LIKE FacCPedi.CodDoc
    FIELDS NroPed   LIKE FacCPedi.NroPed
    FIELD  CodRef    LIKE FacCPedi.CodRef
    FIELDS NroRef   LIKE FacCPedi.NroRef
    FIELDS CodAlm   LIKE Facdpedi.almdes
    FIELDS CodMat   LIKE FacDPedi.CodMat
    FIELDS DesMat   LIKE Almmmatg.DesMat
    FIELDS DesMar   LIKE Almmmatg.DesMar
    FIELDS UndBas   LIKE Almmmatg.UndBas
    FIELDS CanPed   LIKE FacDPedi.CanPed
    FIELDS CodUbi   LIKE Almmmate.CodUbi
    FIELDS CodZona  LIKE Almtubic.CodZona
    FIELDS X-TRANS  LIKE FacCPedi.Libre_c01
    FIELDS X-DIREC  LIKE FACCPEDI.Libre_c02
    FIELDS X-LUGAR  LIKE FACCPEDI.Libre_c03
    FIELDS X-CONTC  LIKE FACCPEDI.Libre_c04
    FIELDS X-HORA   LIKE FACCPEDI.Libre_c05
    FIELDS X-FECHA  LIKE FACCPEDI.Libre_f01
    FIELDS X-OBSER  LIKE FACCPEDI.Observa
    FIELDS X-Glosa  LIKE FACCPEDI.Glosa
    FIELDS X-codcli LIKE FACCPEDI.CodCli
    FIELDS X-NomCli LIKE FACCPEDI.NomCli
    FIELDS X-fchent LIKE faccpedi.fchent
    FIELDS X-peso   AS DEC INIT 0
    FIELDS x-empaques AS CHAR FORMAT 'x(25)'
    FIELDS x-corrrsector AS INT INIT 0
    FIELD Picador AS CHAR
        .
   
DEFINE TEMP-TABLE tt-subordenes
    FIELD CodDoc    LIKE FacCPedi.CodDoc
    FIELDS NroPed   LIKE FacCPedi.NroPed.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES VtaCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table VtaCDocu.CodTer VtaCDocu.CodPed ~
VtaCDocu.NroPed VtaCDocu.FchPed VtaCDocu.CodAlm VtaCDocu.ZonaPickeo ~
VtaCDocu.CodOri VtaCDocu.NroOri VtaCDocu.UsrImpOD VtaCDocu.FchImpOD 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH VtaCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH VtaCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table VtaCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table VtaCDocu


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fgen-empaques B-table-Win 
FUNCTION fgen-empaques RETURNS CHARACTER
  ( INPUT pCantidad AS dec )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      VtaCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      VtaCDocu.CodTer COLUMN-LABEL "Tipo" FORMAT "x(15)":U
      VtaCDocu.CodPed FORMAT "x(3)":U
      VtaCDocu.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U WIDTH 13
      VtaCDocu.FchPed COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
      VtaCDocu.CodAlm FORMAT "x(3)":U
      VtaCDocu.ZonaPickeo COLUMN-LABEL "Zona" FORMAT "x(10)":U
      VtaCDocu.CodOri COLUMN-LABEL "Refer." FORMAT "x(3)":U
      VtaCDocu.NroOri COLUMN-LABEL "Número" FORMAT "x(15)":U
      VtaCDocu.UsrImpOD COLUMN-LABEL "Impreso por" FORMAT "x(8)":U
      VtaCDocu.FchImpOD COLUMN-LABEL "Fecha de Impresión" FORMAT "99/99/9999 HH:MM:SS.SSS":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 98 BY 6.69
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 6.85
         WIDTH              = 108.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.VtaCDocu"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST OUTER USED"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > INTEGRAL.VtaCDocu.CodTer
"VtaCDocu.CodTer" "Tipo" "x(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.VtaCDocu.CodPed
     _FldNameList[3]   > INTEGRAL.VtaCDocu.NroPed
"VtaCDocu.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaCDocu.FchPed
"VtaCDocu.FchPed" "Emisión" "99/99/9999" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.VtaCDocu.CodAlm
     _FldNameList[6]   > INTEGRAL.VtaCDocu.ZonaPickeo
"VtaCDocu.ZonaPickeo" "Zona" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.VtaCDocu.CodOri
"VtaCDocu.CodOri" "Refer." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.VtaCDocu.NroOri
"VtaCDocu.NroOri" "Número" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.VtaCDocu.UsrImpOD
"VtaCDocu.UsrImpOD" "Impreso por" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.VtaCDocu.FchImpOD
"VtaCDocu.FchImpOD" "Fecha de Impresión" ? "datetime" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime B-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF NOT AVAILABLE Vtacdocu THEN RETURN.

  /* Cargamos impresion */
  SESSION:SET-WAIT-STATE('GENERAL').

  EMPTY TEMP-TABLE Reporte.
  EMPTY TEMP-TABLE tt-subordenes.
  FOR EACH VtaDDocu OF VtaCDocu NO-LOCK,
      FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = VtaDDocu.CodCia
      AND Almmmatg.CodMat = VtaDDocu.CodMat:
      FIND FIRST Almckits OF VtaDDocu NO-LOCK NO-ERROR.
      IF AVAILABLE Almckits THEN NEXT.
      FIND Reporte WHERE Reporte.CodMat = VtaDDocu.codmat NO-ERROR.
      IF NOT AVAILABLE Reporte THEN CREATE Reporte.      
      FIND Almmmate OF Almmmatg WHERE Almmmate.codalm = VtaDDocu.AlmDes NO-LOCK NO-ERROR.
      ASSIGN 
          Reporte.Tipo   = VtaCDocu.CodTer
          Reporte.CodDoc = VtaCDocu.CodPed
          Reporte.NroPed = VtaCDocu.NroPed
          Reporte.CodRef = VtaCDocu.CodRef
          Reporte.NroRef = VtaCDocu.NroRef
          Reporte.CodMat = VtaDDocu.CodMat
          Reporte.DesMat = Almmmatg.DesMat
          Reporte.DesMar = Almmmatg.DesMar
          Reporte.UndBas = Almmmatg.UndBas
          Reporte.CanPed = Reporte.CanPed + ( VtaDDocu.CanPed * VtaDDocu.Factor )
          Reporte.CodAlm = VtaCDocu.CodAlm
          Reporte.CodUbi = (IF AVAILABLE Almmmate THEN Almmmate.CodUbi ELSE VtaDDocu.CodUbi)
          Reporte.CodZona = "G-0"
          Reporte.x-peso = almmmatg.pesmat
          Reporte.x-empaque = fGen-Empaques(Reporte.CanPed)
          Reporte.Picador = VtaCDocu.UsrSac
          .
      FIND Almtubic WHERE Almtubic.codcia = s-codcia
          AND Almtubic.codubi = Reporte.codubi
          AND Almtubic.codalm = Reporte.codalm
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almtubic THEN Reporte.CodZona = Almtubic.CodZona.
      /* para la actualizacion */
      FIND FIRST tt-subordenes WHERE tt-subordenes.coddoc = vtacdocu.codped AND 
          tt-subordenes.nroped = vtacdocu.nroped NO-ERROR.
      IF NOT AVAILABLE tt-subordenes THEN DO:
          CREATE tt-subordenes.
          ASSIGN  
              tt-subordenes.coddoc = vtacdocu.codped
              tt-subordenes.nroped = vtacdocu.nroped.
      END.
  END.
  /* SOLO KITS */
  FOR EACH VtaDDocu OF VtaCDocu NO-LOCK,
      FIRST Almckits OF VtaDDocu NO-LOCK,
      EACH Almdkits OF Almckits NO-LOCK,
      FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = VtaCDocu.CodCia
      AND Almmmatg.CodMat = AlmDKits.codmat2:
      FIND Reporte WHERE Reporte.codmat = AlmDKits.codmat2 no-error. /*VtaDDocu.codmat NO-ERROR*/
      IF NOT AVAILABLE Reporte THEN CREATE Reporte.
      ASSIGN 
          Reporte.Tipo   = VtaCDocu.CodTer
          Reporte.CodDoc = VtaCDocu.CodPed
          Reporte.NroPed = VtaCDocu.NroPed
          Reporte.CodRef = VtaCDocu.CodRef
          Reporte.NroRef = VtaCDocu.NroRef
          Reporte.CodMat = Almmmatg.CodMat
          Reporte.DesMat = TRIM(Almmmatg.DesMat) + ' (KIT ' + TRIM(Vtaddocu.codmat) + ')'
          Reporte.DesMar = Almmmatg.DesMar
          Reporte.UndBas = Almmmatg.UndBas
          Reporte.CanPed = Reporte.CanPed + ( VtaDDocu.CanPed * VtaDDocu.Factor *  AlmDKits.Cantidad )
          Reporte.CodAlm = VtaCDocu.CodAlm
          Reporte.CodUbi = VtaDDocu.CodUbi
          Reporte.CodZona = "G-0"
          Reporte.x-peso = almmmatg.pesmat
          Reporte.x-empaque = fGen-Empaques(Reporte.CanPed)
          Reporte.Picador = VtaCDocu.UsrSac
          .
      FIND Almtubic WHERE Almtubic.codcia = s-codcia
          AND Almtubic.codubi = Reporte.codubi
          AND Almtubic.codalm = Reporte.codalm
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almtubic THEN Reporte.CodZona = Almtubic.CodZona.
      /* para la actualizacion */
      FIND FIRST tt-subordenes WHERE tt-subordenes.coddoc = vtacdocu.codped AND 
          tt-subordenes.nroped = vtacdocu.nroped NO-ERROR.
      IF NOT AVAILABLE tt-subordenes THEN DO:
          CREATE tt-subordenes.
          ASSIGN  
              tt-subordenes.coddoc = vtacdocu.codped
              tt-subordenes.nroped = vtacdocu.nroped.
      END.
  END.
  /* NOmbre de Picador */
  DEF VAR pNombre AS CHAR NO-UNDO.
  DEF VAR pOrigen AS CHAR NO-UNDO.
  FOR EACH Reporte:
      RUN logis/p-busca-por-dni (Reporte.Picador, OUTPUT pNombre, OUTPUT pOrigen).
      Reporte.Picador = pNombre + ' , ' + pOrigen.
  END.
  SESSION:SET-WAIT-STATE('').

  FIND FIRST Reporte NO-ERROR.
  IF NOT AVAILABLE Reporte THEN DO:
      /* No existe data a imprimir */
      MESSAGE "No existe data a imprimir".
      RETURN .
  END.
  /* Actualizo datos */
  DEFINE BUFFER b-vtacdocu FOR vtacdocu.
  DEFINE BUFFER ic-faccpedi FOR faccpedi.
  
  DEFINE VAR cMsgError AS CHAR NO-UNDO.
  LoopActualizar:
  DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE :
      /* Actualizo el usuario que imprimio las subordenes */
      FOR EACH tt-subordenes NO-LOCK ON ERROR UNDO, THROW:
          FIND FIRST b-vtacdocu WHERE b-vtacdocu.codcia = s-codcia
              AND b-vtacdocu.codped = tt-subordenes.coddoc 
              AND b-vtacdocu.nroped = tt-subordenes.nroped EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE b-vtacdocu THEN DO:
              cMsgError = 'Problemas al actualizar suborden ' + tt-subordenes.nroped + CHR(10) + 
                          "Intente de nuevo...gracias".
              UNDO LoopActualizar, LEAVE.
          END.
          IF (TRUE <> (b-vtacdocu.UsrImpOD > '')) THEN DO:
              ASSIGN 
                  b-vtacdocu.FlgImpOD = YES
                  b-vtacdocu.UsrImpOD = s-user-id
                  b-vtacdocu.FchImpOD = DATETIME(TODAY, MTIME).
              cMsgError = "".
          END.
      END.   
      /* La O/D completa */
/*       IF (TRUE <> (Faccpedi.UsrImpOD > '')) THEN DO:                                                       */
/*           FIND FIRST ic-faccpedi OF Faccpedi EXCLUSIVE-LOCK NO-ERROR.                                      */
/*           IF AVAILABLE ic-Faccpedi THEN DO:                                                                */
/*             ASSIGN                                                                                         */
/*                 ic-FacCPedi.FlgImpOD = YES                                                                 */
/*                 ic-FacCPedi.UsrImpOD = s-user-id                                                           */
/*                 ic-FacCPedi.FchImpOD = DATETIME(TODAY, MTIME).                                             */
/*           END.                                                                                             */
/*           ELSE DO:                                                                                         */
/*               cMsgError = 'Problemas al actualizar ' + faccpedi.coddoc + " " + faccpedi.nroped + CHR(10) + */
/*                  'Intente de nuevo....gracias'.                                                            */
/*               UNDO LoopActualizar, LEAVE.                                                                  */
/*           END.                                                                                             */
/*       END.                                                                                                 */
  END.
  RELEASE b-vtacdocu.
  RELEASE ic-faccpedi.
  IF cMsgError > '' THEN DO:
      MESSAGE cMsgError VIEW-AS ALERT-BOX ERROR.
      RETURN.
  END.
  /* Imprimir */
  RUN ue-cargar-w-report.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

  GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE RB-REPORT-LIBRARY.
  RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "alm/rbalm.prl".
  RB-REPORT-NAME = "Impresion HPK".
  RB-INCLUDE-RECORDS = "O".
  RB-FILTER = " w-report.task-no = " + STRING(s-task-no).
  RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia.
  RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                     RB-REPORT-NAME,
                     RB-INCLUDE-RECORDS,
                     RB-FILTER,
                     RB-OTHER-PARAMETERS).

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pget-peso-items B-table-Win 
PROCEDURE pget-peso-items :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pPeso AS DEC.
DEFINE OUTPUT PARAMETER pItems AS INT.

DEFINE VAR lPeso AS DEC.
DEFINE VAR lItems AS INT.

DEFINE BUFFER b-vtaddocu FOR vtaddocu.

lPeso = 0.
lItems = 0.

FOR EACH b-vtaddocu OF vtacdocu NO-LOCK,
    FIRST almmmatg OF b-vtaddocu NO-LOCK :
    lItems = lItems + 1.
    IF almmmatg.pesmat <> ? AND almmmatg.pesmat > 0 THEN DO:
        lPeso = lPeso + (b-vtaddocu.canped * almmmatg.pesmat).
    END.       
END.
RELEASE b-vtaddocu.

pPeso = lpeso.
pItems = lItems.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
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
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recibe-Parametros B-table-Win 
PROCEDURE Recibe-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM pFchPed-1 AS DATE NO-UNDO.
DEF INPUT PARAM pFchPed-2 AS DATE NO-UNDO.

x-FchPed-1 = pFchPed-1.
x-FchPed-2 = pFchPed-2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "VtaCDocu"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-cargar-w-report B-table-Win 
PROCEDURE ue-cargar-w-report :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEFINE VAR lPeso AS DEC.
DEFINE VAR lItems AS INT.
DEFINE VAR lNoItm AS INT.
DEFINE VAR x-direccion AS CHAR INIT "".
DEFINE VAR lxGlosa AS CHAR INIT "".
DEFINE VAR lSeqSector AS INT.
DEFINE VAR x-Origen AS CHAR NO-UNDO.
DEFINE VAR x-CrossDocking AS LOG NO-UNDO.
DEFINE VAR x-DestinoFinal AS CHAR NO-UNDO.

DEFINE VAR lTipoDocBarra AS CHAR.

FIND FIRST facdocum WHERE facdocum.codcia = s-codcia AND
                        facdocum.coddoc = reporte.coddoc
                        NO-LOCK NO-ERROR.
IF NOT AVAILABLE facdocum THEN DO:
    MESSAGE "Tipo Documento para el Codigo de Barra no existe".
    RETURN.
END.
lTipoDocbarra = TRIM(facdocum.codcta[8]).

lSeqSector = 0.
s-Task-No = 0.
FOR EACH Reporte BREAK BY reporte.nroped BY Reporte.codubi:
    IF FIRST-OF(reporte.nroped) THEN DO:
        lPeso = 0.
        lNoItm = 0.
        lItems = 0.
        lSeqSector = lSeqSector + 1.
        FIND FIRST VtaCDocu WHERE VtaCDocu.codcia = s-codcia AND 
            VtaCDocu.codped = reporte.coddoc AND 
            VtaCDocu.nroped = reporte.nroped NO-LOCK NO-ERROR.
        RUN pget-peso-items(OUTPUT lPeso, OUTPUT lItems).
        FIND Faccpedi WHERE Faccpedi.codcia = s-codcia AND
            Faccpedi.coddoc = Vtacdocu.codref AND
            Faccpedi.nroped = Vtacdocu.nroref
            NO-LOCK NO-ERROR.
        IF AVAILABLE Faccpedi THEN DO:
            FIND gn-divi WHERE gn-divi.codcia = s-codcia AND
                gn-divi.coddiv = Faccpedi.coddiv NO-LOCK NO-ERROR.
            IF AVAILABLE gn-divi THEN x-Origen = gn-divi.desdiv.
            x-CrossDocking = Faccpedi.CrossDocking.
            IF x-CrossDocking = YES THEN x-DestinoFinal = Faccpedi.AlmacenXD.
        END.
        ELSE ASSIGN x-CrossDocking = NO x-Origen = ''.
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = VtaCDocu.codcli NO-LOCK NO-ERROR.
        FIND gn-ven OF VtaCDocu NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            x-Direccion = IF( AVAILABLE gn-clie) THEN gn-clie.dircli ELSE "".
            FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
            IF AVAILABLE TabDepto THEN DO:
                x-Direccion = TRIM(x-Direccion) + " - " + TRIM(TabDepto.NomDepto).
                FIND TabProvi WHERE TabProvi.CodDepto = gn-clie.CodDept
                    AND TabProvi.CodProvi = gn-clie.CodProv
                    NO-LOCK NO-ERROR.
                IF AVAILABLE TabProvi THEN DO:
                    x-Direccion = x-Direccion + ' - '+ TRIM(TabProvi.NomProvi).
                    FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept
                        AND TabDistr.CodProvi = gn-clie.CodProv
                        AND TabDistr.CodDistr = gn-clie.CodDist
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE TabDistr THEN x-Direccion = x-Direccion + ' - ' + TabDistr.NomDistr.
                END.
            END.
        END.
        lxGlosa = VtaCDocu.glosa.
/*         IF VtaCDocu.codped = 'OTR' THEN DO:                                                   */
/*             x-direccion = VtaCDocu.dircli.                                                    */
/*             /* Glosa desde las SOLICTUDES DE R/A  */                                          */
/*             DEFINE VAR lxSer AS INT.                                                          */
/*             DEFINE VAR lxNroDcto AS INT.                                                      */
/*                                                                                               */
/*             IF VtaCDocu.glosa = ? OR VtaCDocu.glosa = '' THEN DO:                             */
/*                 IF VtaCDocu.codref = 'R/A' THEN DO:                                           */
/*                     lxSer = INT(SUBSTRING(VtaCDocu.nroref,1,3)).                              */
/*                     lxNroDcto = INT(SUBSTRING(VtaCDocu.nroref,4)).                            */
/*                                                                                               */
/*                     FIND FIRST almcrepo WHERE almcrepo.codcia = s-codcia AND                  */
/*                                                 almcrepo.codalm = VtaCDocu.codcli AND         */
/*                                                 almcrepo.nroser = lxSer AND                   */
/*                                                 almcrepo.nrodoc = lxNroDcto NO-LOCK NO-ERROR. */
/*                     IF AVAILABLE almcrepo THEN DO:                                            */
/*                         lxGlosa = almcrepo.glosa.                                             */
/*                     END.                                                                      */
/*                 END.                                                                          */
/*             END.                                                                              */
/*         END.                                                                                  */
    END.
    
    /* -------------------------------------------------------------*/
    lNoItm = lNoItm + 1.
    IF s-Task-No = 0 THEN DO:
        REPEAT:
            s-task-no = RANDOM(1, 999999).
            IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK)
                THEN DO:
                LEAVE.
            END.
        END.
    END.
    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no
        w-report.llave-c = reporte.nroped
        w-report.campo-c[20] = "*" + lTipoDocbarra + TRIM(reporte.Nroped) + "*" /* BARRA */
        w-report.campo-c[21] = Reporte.Tipo
        w-report.campo-c[23] = Reporte.Picador
        .
    /* Cabecera */
    ASSIGN  
        w-report.campo-c[6] = reporte.Coddoc + " " + reporte.Nroped
        w-report.campo-c[7] = "Nro. " + VtaCDocu.CodRef + " " + VtaCDocu.NroRef
        w-report.campo-c[8] = "ORIGEN : " + if(AVAILABLE gn-divi) THEN gn-divi.desdiv ELSE ""
        w-report.campo-c[9] = "Nro. DE ITEMS : " + string(lItems,">>>,>>9")
        w-report.campo-c[10] = "F." + IF(VtaCDocu.codped='OTR') THEN "DESPACHO :" ELSE "ENTREGA :"
        w-report.campo-c[10] = w-report.campo-c[10] + STRING(VtaCDocu.Fchent,"99/99/9999")
        w-report.campo-c[11] = IF(VtaCDocu.codped='OTR') THEN "" ELSE IF (AVAILABLE gn-ven) THEN ("VENDEDOR : " + gn-ven.nomven) ELSE ""
        w-report.campo-c[12] = "PESO :" + STRING(lPeso,"-ZZ,ZZZ,ZZ9.99")
        w-report.campo-c[13] = IF(VtaCDocu.Codped = 'OTR') THEN "DESTINO  : " ELSE "CLIENTE   : "
        w-report.campo-c[13] = w-report.campo-c[13] + IF(VtaCDocu.Codped = 'OTR') THEN VtaCDocu.Codcli + " " ELSE ""
        w-report.campo-c[13] = w-report.campo-c[13] + VtaCDocu.nomcli
        w-report.campo-c[14] = "Direccion : " + x-direccion
        w-report.campo-c[15] = "Observacion : " + lxGlosa
        /*w-report.campo-c[16] = (IF vtacdocu.codped = "ODC" THEN "CONSOLIDADA" ELSE "").*/
        w-report.campo-c[16] = "Destino Final : " + x-DestinoFinal
        w-report.campo-c[25] = VtaCDocu.CodOri + " " + VtaCDocu.NroOri.

        ASSIGN w-report.campo-l[1] = x-CrossDocking.
        /* Detalle */
        ASSIGN  w-report.campo-i[1] = lNoItm
                w-report.campo-c[1] = Reporte.CodMat
                w-report.campo-c[2] = Reporte.DesMat
                w-report.campo-c[3] = Reporte.DesMar
                w-report.campo-c[4] = Reporte.UndBas
                w-report.campo-f[1] = Reporte.CanPed
                w-report.campo-c[5] = Reporte.CodUbi
                w-report.campo-c[22] = Reporte.x-empaques.
END.

IF AVAILABLE VtacDocu THEN DO:
    lNoItm = lNoItm + 1.
    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no
        w-report.llave-c = VtaCDocu.nroped + "XXX"
        w-report.campo-c[6] = VtaCDocu.Codped + " " + VtaCDocu.Nroped
        w-report.campo-i[1] = lNoItm.

    DELETE w-report.

END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fgen-empaques B-table-Win 
FUNCTION fgen-empaques RETURNS CHARACTER
  ( INPUT pCantidad AS dec ) :

/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lRetVal AS CHAR INIT "".
    DEFINE VAR lSaldo AS DEC.
    DEFINE VAR lValor AS INT.

    lSaldo = pCantidad.
    IF lSaldo > 0 AND almmmatg.canemp > 0 THEN DO:
        lValor = TRUNCATE(lSaldo / almmmatg.canemp,0).
        IF lValor > 0 THEN DO:
            lRetVal = "M(" + STRING(lValor) + "/" + STRING(almmmatg.canemp) + " )".
        END.
        lSaldo = lSaldo - (lValor * almmmatg.canemp).
    END.
    IF lSaldo > 0 AND almmmatg.StkRep > 0 THEN DO:
        lValor = TRUNCATE(lSaldo / almmmatg.StkRep,0).
        IF lValor > 0 THEN DO:
            lRetVal = lRetVal + IF(lRetVal = "") THEN "" ELSE " ".
            lRetVal = lRetVal + "I(" + STRING(lValor) + "/" + STRING(almmmatg.StkRep) + ")".
        END.
        lSaldo = lSaldo - (lValor * almmmatg.StkRep).
    END.
    IF lSaldo > 0 THEN DO:
        lRetVal = lRetVal + IF(lRetVal = "") THEN "" ELSE " ".
        lRetVal = lRetVal + "U(" + STRING(lSaldo) + ")".
    END.


  RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

