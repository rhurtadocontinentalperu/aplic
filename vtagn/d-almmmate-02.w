&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-MATE NO-UNDO LIKE Almmmate.



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

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF SHARED VAR output-var-1 AS ROWID.
DEF SHARED VAR output-var-2 AS CHAR.
DEF SHARED VAR output-var-3 AS CHAR.
DEF SHARED VAR input-var-1 AS CHAR.
DEF SHARED VAR input-var-2 AS CHAR.
DEF SHARED VAR input-var-3 AS CHAR.

/* DEF SHARED VAR s-aplic-id AS CHAR.               */
/*                                                  */
/* RUN lib/logtabla (INPUT s-aplic-id,              */
/*                   INPUT "vtagn/d-almmmate-02.w", */
/*                   INPUT "RUN-PROGRAM").          */

/* Para calcular el stock en tránsito */
DEFINE TEMP-TABLE tmp-tabla
    FIELD t-CodAlm LIKE Almacen.codalm  FORMAT 'x(3)'
    FIELD t-CodDoc LIKE FacDPedi.CodDoc FORMAT "XXX"
    FIELD t-Nroped LIKE FacDPedi.NroPed FORMAT "XXX-XXXXXXXX"
    FIELD t-CodDiv LIKE FacCPedi.CodDiv FORMAT 'x(5)'
    FIELD t-FchPed LIKE FacDPedi.FchPed
    FIELD t-NomCli LIKE FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(35)"
    FIELD t-CodMat LIKE FacDPedi.codmat
    FIELD t-Canped LIKE FacDPedi.CanPed.

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
&Scoped-define INTERNAL-TABLES T-MATE Almacen

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 T-MATE.CodAlm Almacen.Descripcion ~
T-MATE.UndVta T-MATE.StkAct T-MATE.StkRep T-MATE.StkMax T-MATE.StkActCbd 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH T-MATE NO-LOCK, ~
      EACH Almacen OF T-MATE NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH T-MATE NO-LOCK, ~
      EACH Almacen OF T-MATE NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 T-MATE Almacen
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 T-MATE
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-5 Almacen


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-3 BUTTON-4 BUTTON-Terceros BROWSE-5 ~
Btn_Cancel 

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

DEFINE BUTTON BUTTON-3 
     LABEL "SOLO LOS ALMACENES DE DESPACHO" 
     SIZE 42 BY 1.12.

DEFINE BUTTON BUTTON-4 
     LABEL "SOLO ALMACENES COMERCIALES" 
     SIZE 36 BY 1.12.

DEFINE BUTTON BUTTON-Terceros 
     LABEL "OTROS ALMACENES" 
     SIZE 39 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      T-MATE, 
      Almacen SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 D-Dialog _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      T-MATE.CodAlm FORMAT "x(5)":U
      Almacen.Descripcion FORMAT "X(40)":U
      T-MATE.UndVta COLUMN-LABEL "Unidad" FORMAT "X(8)":U
      T-MATE.StkAct COLUMN-LABEL "Stock Actual" FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
            WIDTH 14.86 COLUMN-BGCOLOR 11
      T-MATE.StkRep COLUMN-LABEL "Comprometido" FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
            WIDTH 15.14 COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
      T-MATE.StkMax COLUMN-LABEL "Disponible" FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
            WIDTH 12.29 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10
      T-MATE.StkActCbd COLUMN-LABEL "Stock en Tránsito" FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
            WIDTH 15.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 120 BY 14.81
         TITLE "Browse 4" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BUTTON-3 AT ROW 1.27 COL 3 WIDGET-ID 6
     BUTTON-4 AT ROW 1.27 COL 46 WIDGET-ID 8
     BUTTON-Terceros AT ROW 1.27 COL 83 WIDGET-ID 10
     BROWSE-5 AT ROW 2.62 COL 2 WIDGET-ID 200
     Btn_OK AT ROW 17.69 COL 2
     Btn_Cancel AT ROW 17.69 COL 19
     SPACE(88.99) SKIP(0.38)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "STOCK DISPONIBLE"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-MATE T "?" NO-UNDO INTEGRAL Almmmate
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-5 BUTTON-Terceros D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON Btn_OK IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.T-MATE,INTEGRAL.Almacen OF Temp-Tables.T-MATE"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.T-MATE.CodAlm
     _FldNameList[2]   = INTEGRAL.Almacen.Descripcion
     _FldNameList[3]   > Temp-Tables.T-MATE.UndVta
"T-MATE.UndVta" "Unidad" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-MATE.StkAct
"T-MATE.StkAct" "Stock Actual" ? "decimal" 11 ? ? ? ? ? no ? no no "14.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-MATE.StkRep
"T-MATE.StkRep" "Comprometido" "(ZZZ,ZZZ,ZZ9.99)" "decimal" 12 15 ? ? ? ? no ? no no "15.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-MATE.StkMax
"T-MATE.StkMax" "Disponible" "(ZZZ,ZZZ,ZZ9.99)" "decimal" 10 0 ? ? ? ? no ? no no "12.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-MATE.StkActCbd
"T-MATE.StkActCbd" "Stock en Tránsito" ? "decimal" 14 0 ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* STOCK DISPONIBLE */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
&Scoped-define SELF-NAME BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-5 D-Dialog
ON LEFT-MOUSE-DBLCLICK OF BROWSE-5 IN FRAME D-Dialog /* Browse 4 */
DO:
  FIND Almmmatg WHERE Almmmatg.codcia = T-MATE.CodCia
      AND Almmmatg.codmat = T-MATE.CodMat
      NO-LOCK.
  RUN ALM/D-DETMOVv2 (T-MATE.CodAlm, T-MATE.CodMat, almmmatg.desmat).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancel */
DO:
  output-var-1 = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
    FIND VtaAlmDiv WHERE VtaAlmDiv.CodCia = s-codcia
        AND VtaAlmDiv.CodDiv = s-coddiv 
        AND VtaAlmDiv.CodAlm =  T-MATE.CodAlm
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaAlmDiv THEN DO:
        MESSAGE "NO es un almacén de despacho permitido"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    ASSIGN
        output-var-1 = ROWID(T-MATE)
        output-var-2 = T-MATE.codalm
        output-var-3 = STRING(T-MATE.StkMax).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 D-Dialog
ON CHOOSE OF BUTTON-3 IN FRAME D-Dialog /* SOLO LOS ALMACENES DE DESPACHO */
DO:
  RUN Carga-Temporal.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 D-Dialog
ON CHOOSE OF BUTTON-4 IN FRAME D-Dialog /* SOLO ALMACENES COMERCIALES */
DO:
  RUN Carga-Temporal-1.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Terceros
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Terceros D-Dialog
ON CHOOSE OF BUTTON-Terceros IN FRAME D-Dialog /* OTROS ALMACENES */
DO:
    RUN Carga-Temporal-2.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
DEF VAR pComprometido AS DEC NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').
EMPTY TEMP-TABLE T-MATE.
FOR EACH VtaAlmDiv NO-LOCK WHERE VtaAlmDiv.CodCia = s-codcia
        AND VtaAlmDiv.CodDiv = s-coddiv,
    FIRST Almacen NO-LOCK WHERE Almacen.codcia = Vtaalmdiv.codcia 
        AND Almacen.codalm = Vtaalmdiv.codalm
        AND Almacen.Campo-C[9] <> "I"
    BY VtaAlmDiv.Orden:
    FIND Almmmate WHERE Almmmate.codcia = s-codcia
        AND Almmmate.codalm = Vtaalmdiv.codalm
        AND Almmmate.codmat = input-var-1
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN NEXT.
    FIND Almmmatg OF Almmmate NO-LOCK.
    CREATE T-MATE.
    ASSIGN
        T-MATE.codcia = s-codcia
        T-MATE.codalm = Vtaalmdiv.codalm
        T-MATE.codmat = Almmmate.codmat
        T-MATE.undvta = Almmmatg.undbas
        T-MATE.stkact = Almmmate.stkact
        pComprometido = 0.
    RUN gn/stock-comprometido-v2.r (Almmmate.codmat, Almmmate.codalm, YES, OUTPUT pComprometido).
    ASSIGN
        T-MATE.StkRep = pComprometido
        T-MATE.StkMax = T-MATE.StkAct - T-MATE.StkRep.
    /* Stock en Tránsito */
    RUN alm\p-articulo-en-transito (Almmmate.codcia,
                                    Almmmate.codalm,
                                    Almmmate.codmat,
                                    INPUT-OUTPUT TABLE tmp-tabla,
                                    OUTPUT pComprometido).
    ASSIGN
        T-MATE.StkActCbd = pComprometido.

END.
SESSION:SET-WAIT-STATE('').

{&BROWSE-NAME}:title IN FRAME {&FRAME-NAME} = 'SOLO LOS ALMACENES DE DESPACHO'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-1 D-Dialog 
PROCEDURE Carga-Temporal-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR pComprometido AS DEC NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').
EMPTY TEMP-TABLE T-MATE.
FOR EACH Almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia
        AND Almmmate.codmat = input-var-1
        AND Almmmate.stkact > 0,
    FIRST Almacen OF Almmmate NO-LOCK WHERE Almacen.Campo-C[9] <> "I" AND
        Almacen.AlmCsg = NO AND
        Almacen.Campo-C[6] = "Si",
    FIRST Almmmatg OF Almmmate NO-LOCK:
    CREATE T-MATE.
    ASSIGN
        T-MATE.codcia = s-codcia
        T-MATE.codalm = Almmmate.codalm
        T-MATE.codmat = Almmmate.codmat
        T-MATE.undvta = Almmmatg.undbas
        T-MATE.stkact = Almmmate.stkact
        pComprometido = 0.
    RUN gn/stock-comprometido-v2 (Almmmate.codmat, Almmmate.codalm, YES, OUTPUT pComprometido).
    ASSIGN
        T-MATE.StkRep = pComprometido
        T-MATE.StkMax = T-MATE.StkAct - T-MATE.StkRep.
    /* Stock en Tránsito */
    RUN alm\p-articulo-en-transito (Almmmate.codcia,
                                    Almmmate.codalm,
                                    Almmmate.codmat,
                                    INPUT-OUTPUT TABLE tmp-tabla,
                                    OUTPUT pComprometido).
    ASSIGN
        T-MATE.StkActCbd = pComprometido.
END.
SESSION:SET-WAIT-STATE('').
 
{&BROWSE-NAME}:title IN FRAME {&FRAME-NAME} = 'SOLO LOS ALMACENES COMERCIALES'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-2 D-Dialog 
PROCEDURE Carga-Temporal-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pComprometido AS DEC NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').
EMPTY TEMP-TABLE T-MATE.
FOR EACH Almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia
        AND Almmmate.codmat = input-var-1
        AND Almmmate.stkact > 0,
    FIRST Almacen OF Almmmate NO-LOCK WHERE Almacen.Campo-C[9] <> "I" AND
        /*Almacen.AlmCsg = NO AND*/
        Almacen.Campo-C[6] = "No",      /* ALmacén Comercial = No */
    FIRST Almmmatg OF Almmmate NO-LOCK:

    CREATE T-MATE.
    ASSIGN
        T-MATE.codcia = s-codcia
        T-MATE.codalm = Almmmate.codalm
        T-MATE.codmat = Almmmate.codmat
        T-MATE.undvta = Almmmatg.undbas
        T-MATE.stkact = Almmmate.stkact
        pComprometido = 0.
    RUN gn/stock-comprometido-v2 (Almmmate.codmat, Almmmate.codalm, YES, OUTPUT pComprometido).
    ASSIGN
        T-MATE.StkRep = pComprometido
        T-MATE.StkMax = T-MATE.StkAct - T-MATE.StkRep.
    /* Stock en Tránsito */
    RUN alm\p-articulo-en-transito (Almmmate.codcia,
                                    Almmmate.codalm,
                                    Almmmate.codmat,
                                    INPUT-OUTPUT TABLE tmp-tabla,
                                    OUTPUT pComprometido).
    ASSIGN
        T-MATE.StkActCbd = pComprometido.
END.
SESSION:SET-WAIT-STATE('').
 
{&BROWSE-NAME}:title IN FRAME {&FRAME-NAME} = 'SOLO LOS ALMACENES DE TERCEROS'.

END PROCEDURE.


/*
SESSION:SET-WAIT-STATE('GENERAL').
EMPTY TEMP-TABLE T-MATE.
FOR EACH Almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia
        AND Almmmate.codmat = input-var-1
        AND Almmmate.stkact > 0,
    FIRST Almacen OF Almmmate NO-LOCK WHERE Almacen.Campo-C[9] <> "I" AND
        Almacen.AlmCsg = NO AND
        Almacen.Campo-C[6] = "No",      /* ALmacén Comercial = No */
    FIRST Almmmatg OF Almmmate NO-LOCK:
    CREATE T-MATE.
    ASSIGN
        T-MATE.codcia = s-codcia
        T-MATE.codalm = Almmmate.codalm
        T-MATE.codmat = Almmmate.codmat
        T-MATE.undvta = Almmmatg.undbas
        T-MATE.stkact = Almmmate.stkact
        pComprometido = 0.
/*     RUN gn/stock-comprometido-v2 (Almmmate.codmat, Almmmate.codalm, YES, OUTPUT pComprometido). */
    ASSIGN
        T-MATE.StkRep = pComprometido
        T-MATE.StkMax = T-MATE.StkAct - T-MATE.StkRep.
END.
SESSION:SET-WAIT-STATE('').
*/

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
  ENABLE BUTTON-3 BUTTON-4 BUTTON-Terceros BROWSE-5 Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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
  RUN Carga-Temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "T-MATE"}
  {src/adm/template/snd-list.i "Almacen"}

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

