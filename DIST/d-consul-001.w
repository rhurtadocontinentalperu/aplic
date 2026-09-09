&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-RutaD NO-UNDO LIKE DI-RutaD.



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

/* Parameters Definitions ---                                           */
DEF INPUT PARAMETER pRowid AS ROWID.

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.

FIND Di-RutaC WHERE ROWID(Di-RutaC) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Di-RutaC THEN RETURN ERROR.

RUN Carga-Temporal.

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
&Scoped-define INTERNAL-TABLES T-RutaD

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 T-RutaD.Libre_c01 T-RutaD.Libre_c02 ~
T-RutaD.Libre_c03 T-RutaD.Libre_d01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH T-RutaD NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH T-RutaD NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 T-RutaD
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 T-RutaD


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-5 Btn_Cancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fUbigeo D-Dialog 
FUNCTION fUbigeo RETURNS CHARACTER
  ( INPUT pTipo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "CERRAR" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      T-RutaD SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 D-Dialog _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      T-RutaD.Libre_c01 COLUMN-LABEL "Ruta" FORMAT "x(20)":U WIDTH 19.43
      T-RutaD.Libre_c02 COLUMN-LABEL "Cliente" FORMAT "x(50)":U
            WIDTH 49.43
      T-RutaD.Libre_c03 COLUMN-LABEL "Dirección" FORMAT "x(60)":U
            WIDTH 57
      T-RutaD.Libre_d01 COLUMN-LABEL "# Bultos" FORMAT ">>>,>>9":U
            WIDTH 7.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 138 BY 9.96
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-5 AT ROW 1 COL 2 WIDGET-ID 200
     Btn_Cancel AT ROW 10.96 COL 2
     SPACE(126.42) SKIP(0.19)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "DETALLE"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-RutaD T "?" NO-UNDO INTEGRAL DI-RutaD
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
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-5 1 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.T-RutaD"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-RutaD.Libre_c01
"T-RutaD.Libre_c01" "Ruta" "x(20)" "character" ? ? ? ? ? ? no ? no no "19.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-RutaD.Libre_c02
"T-RutaD.Libre_c02" "Cliente" "x(50)" "character" ? ? ? ? ? ? no ? no no "49.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-RutaD.Libre_c03
"T-RutaD.Libre_c03" "Dirección" ? "character" ? ? ? ? ? ? no ? no no "57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-RutaD.Libre_d01
"T-RutaD.Libre_d01" "# Bultos" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* DETALLE */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-RutaD.

/* Acumulamos por Cliente */
FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
    FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddoc = Di-RutaD.codref
        AND Ccbcdocu.nrodoc = Di-RutaD.nroref,
    FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.coddoc = Ccbcdocu.libre_c01
        AND Faccpedi.nroped = Ccbcdocu.libre_c02
    BREAK BY Ccbcdocu.codcli:
    IF FIRST-OF(Ccbcdocu.codcli) THEN DO:
        CREATE T-RutaD.
        ASSIGN
            T-Rutad.CodCia = Di-RutaC.CodCia
            T-Rutad.CodDoc = Di-RutaC.CodDoc
            T-Rutad.NroDoc = Di-RutaC.NroDoc
            T-Rutad.Libre_c01 = fUbigeo("DI-RUTAD")
            T-Rutad.Libre_c02 = Ccbcdocu.nomcli
            T-Rutad.Libre_c03 = (IF TRUE <> (Ccbcdocu.lugent < '') THEN Ccbcdocu.dircli ELSE Ccbcdocu.lugent).
            .
    END.
    FOR EACH Ccbcbult NO-LOCK WHERE CcbCBult.CodCia = CcbCDocu.CodCia 
        AND CcbCBult.CodDiv = CcbCDocu.CodDiv 
        AND CcbCBult.CodDoc = CcbCDocu.Libre_c01 
        AND CcbCBult.NroDoc = CcbCDocu.Libre_c02:
        T-RutaD.Libre_d01 = T-RutaD.Libre_d01 + CcbCBult.Bultos.
    END.
END.

FOR EACH Di-RutaG OF Di-RutaC NO-LOCK,
    FIRST Almcmov NO-LOCK WHERE Almcmov.CodCia = s-codcia
        AND Almcmov.CodAlm = Di-RutaG.CodAlm 
        AND Almcmov.TipMov = Di-RutaG.Tipmov 
        AND Almcmov.CodMov = Di-RutaG.Codmov 
        AND Almcmov.NroSer = Di-RutaG.serref 
        AND Almcmov.NroDoc = Di-RutaG.nroref,
    FIRST Almacen NO-LOCK WHERE Almacen.codcia = Almcmov.codcia
        AND Almacen.codalm = Almcmov.almdes,
    FIRST Faccpedi WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.coddoc = Almcmov.codref
        AND Faccpedi.nroped = Almcmov.nroref
    BREAK BY Almcmov.AlmDes:
    IF FIRST-OF(Almcmov.almdes) THEN DO:
        CREATE T-RutaD.
        ASSIGN
            T-Rutad.CodCia = Di-RutaC.CodCia
            T-Rutad.CodDoc = Di-RutaC.CodDoc
            T-Rutad.NroDoc = Di-RutaC.NroDoc
            T-Rutad.Libre_c01 = fUbigeo("DI-RUTAG")
            T-Rutad.Libre_c02 = Almacen.Descripcion
            T-Rutad.Libre_c03 = Almacen.DirAlm.
            .
    END.
    FOR EACH Ccbcbult NO-LOCK WHERE CcbCBult.CodCia = CcbCDocu.CodCia 
        AND CcbCBult.CodDiv = CcbCDocu.CodDiv 
        AND CcbCBult.CodDoc = CcbCDocu.Libre_c01 
        AND CcbCBult.NroDoc = CcbCDocu.Libre_c02:
        T-RutaD.Libre_d01 = T-RutaD.Libre_d01 + CcbCBult.Bultos.
    END.
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
  ENABLE BROWSE-5 Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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
  {src/adm/template/snd-list.i "T-RutaD"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fUbigeo D-Dialog 
FUNCTION fUbigeo RETURNS CHARACTER
  ( INPUT pTipo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pCodDpto AS CHAR NO-UNDO.
  DEF VAR pCodProv AS CHAR NO-UNDO.
  DEF VAR pCodDist AS CHAR NO-UNDO.
  DEF VAR pCodPos  AS CHAR NO-UNDO.
  DEF VAR pZona    AS CHAR NO-UNDO.
  DEF VAR pSubZona AS CHAR NO-UNDO.

  CASE pTipo:
      WHEN "DI-RUTAD" THEN DO:
          RUN gn/fUbigeo (
              Faccpedi.CodDiv, 
              Faccpedi.CodDoc,
              Faccpedi.NroPed,
              OUTPUT pCodDpto,
              OUTPUT pCodProv,
              OUTPUT pCodDist,
              OUTPUT pCodPos,
              OUTPUT pZona,
              OUTPUT pSubZona
              ).
      END.
      WHEN "DI-RUTAG" THEN DO:
          FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
              AND Faccpedi.coddoc = Almcmov.codref
              AND Faccpedi.nroped = Almcmov.nroref
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Faccpedi THEN RETURN "".
          RUN gn/fUbigeo (
              Faccpedi.CodDiv, 
              Faccpedi.CodDoc,
              Faccpedi.NroPed,
              OUTPUT pCodDpto,
              OUTPUT pCodProv,
              OUTPUT pCodDist,
              OUTPUT pCodPos,
              OUTPUT pZona,
              OUTPUT pSubZona
              ).
      END.
  END CASE.
  FIND TabDistr WHERE TabDistr.CodDepto = pCodDpto
      AND TabDistr.CodProvi = pCodProv
      AND TabDistr.CodDistr = pCodDist
      NO-LOCK NO-ERROR.
    IF AVAILABLE TabDistr THEN RETURN TabDistr.NomDistr.
    ELSE RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

