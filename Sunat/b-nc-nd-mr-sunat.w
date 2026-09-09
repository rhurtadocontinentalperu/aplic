&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER CDOCU FOR CcbCDocu.
DEFINE BUFFER DDOCU FOR CcbDDocu.



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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR x-Diferencia AS DEC NO-UNDO.
DEF VAR x-ImpTot AS DEC NO-UNDO.

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
&Scoped-define INTERNAL-TABLES FacCPedi CcbCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacCPedi.CodDiv FacCPedi.FchPed ~
FacCPedi.NroPed FacCPedi.CodRef FacCPedi.NroRef FacCPedi.CodCli ~
FacCPedi.NomCli CcbCDocu.ImpTot @ x-ImpTot ~
FacCPedi.AcuBon[5] + FacCPedi.ImpTot @ FacCPedi.ImpTot ~
Ccbcdocu.ImpTot - (FacCPedi.AcuBon[5] + FacCPedi.ImpTot) @ x-Diferencia 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND FacCPedi.CodCia = s-codcia ~
 AND FacCPedi.CodDoc = "PMR" ~
 AND FacCPedi.FlgEst = "P" NO-LOCK, ~
      FIRST CcbCDocu WHERE CcbCDocu.CodCia = FacCPedi.CodCia ~
  AND CcbCDocu.CodDoc = FacCPedi.CodRef ~
  AND CcbCDocu.NroDoc = FacCPedi.NroRef NO-LOCK ~
    BY FacCPedi.FchPed DESCENDING ~
       BY FacCPedi.CodDiv ~
        BY FacCPedi.NroPed
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND FacCPedi.CodCia = s-codcia ~
 AND FacCPedi.CodDoc = "PMR" ~
 AND FacCPedi.FlgEst = "P" NO-LOCK, ~
      FIRST CcbCDocu WHERE CcbCDocu.CodCia = FacCPedi.CodCia ~
  AND CcbCDocu.CodDoc = FacCPedi.CodRef ~
  AND CcbCDocu.NroDoc = FacCPedi.NroRef NO-LOCK ~
    BY FacCPedi.FchPed DESCENDING ~
       BY FacCPedi.CodDiv ~
        BY FacCPedi.NroPed.
&Scoped-define TABLES-IN-QUERY-br_table FacCPedi CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-br_table CcbCDocu


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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      FacCPedi, 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacCPedi.CodDiv FORMAT "x(5)":U
      FacCPedi.FchPed COLUMN-LABEL "Fecha" FORMAT "99/99/9999":U
            WIDTH 8
      FacCPedi.NroPed COLUMN-LABEL "Hoja de Cálculo" FORMAT "X(10)":U
            WIDTH 11
      FacCPedi.CodRef FORMAT "x(3)":U
      FacCPedi.NroRef COLUMN-LABEL "Numero" FORMAT "X(12)":U WIDTH 9.86
      FacCPedi.CodCli COLUMN-LABEL "Código Cliente" FORMAT "x(11)":U
            WIDTH 11.43
      FacCPedi.NomCli FORMAT "x(50)":U
      CcbCDocu.ImpTot @ x-ImpTot COLUMN-LABEL "Importe!Comprobante"
      FacCPedi.AcuBon[5] + FacCPedi.ImpTot @ FacCPedi.ImpTot COLUMN-LABEL "Importe!Hoja Cálculo" FORMAT ">,>>>,>>9.99":U
      Ccbcdocu.ImpTot - (FacCPedi.AcuBon[5] + FacCPedi.ImpTot) @ x-Diferencia COLUMN-LABEL "Diferencia" FORMAT "(>>>,>>9.99)":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 125 BY 6.69
         FONT 4.


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
   Temp-Tables and Buffers:
      TABLE: CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: DDOCU B "?" ? INTEGRAL CcbDDocu
   END-TABLES.
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
         WIDTH              = 128.86.
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
     _TblList          = "INTEGRAL.FacCPedi,INTEGRAL.CcbCDocu WHERE INTEGRAL.FacCPedi ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST"
     _OrdList          = "INTEGRAL.FacCPedi.FchPed|no,INTEGRAL.FacCPedi.CodDiv|yes,INTEGRAL.FacCPedi.NroPed|yes"
     _Where[1]         = "FacCPedi.CodCia = s-codcia
 AND FacCPedi.CodDoc = ""PMR""
 AND FacCPedi.FlgEst = ""P"""
     _JoinCode[2]      = "INTEGRAL.CcbCDocu.CodCia = FacCPedi.CodCia
  AND INTEGRAL.CcbCDocu.CodDoc = FacCPedi.CodRef
  AND INTEGRAL.CcbCDocu.NroDoc = FacCPedi.NroRef"
     _FldNameList[1]   = INTEGRAL.FacCPedi.CodDiv
     _FldNameList[2]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Fecha" ? "date" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Hoja de Cálculo" "X(10)" "character" ? ? ? ? ? ? no ? no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = INTEGRAL.FacCPedi.CodRef
     _FldNameList[5]   > INTEGRAL.FacCPedi.NroRef
"FacCPedi.NroRef" "Numero" ? "character" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCPedi.CodCli
"FacCPedi.CodCli" "Código Cliente" ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = INTEGRAL.FacCPedi.NomCli
     _FldNameList[8]   > "_<CALC>"
"CcbCDocu.ImpTot @ x-ImpTot" "Importe!Comprobante" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"FacCPedi.AcuBon[5] + FacCPedi.ImpTot @ FacCPedi.ImpTot" "Importe!Hoja Cálculo" ">,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"Ccbcdocu.ImpTot - (FacCPedi.AcuBon[5] + FacCPedi.ImpTot) @ x-Diferencia" "Diferencia" "(>>>,>>9.99)" ? 14 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-NC B-table-Win 
PROCEDURE Genera-NC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* N/C */                                
DEF INPUT PARAMETER s-coddoc-1 AS CHAR.
DEF INPUT PARAMETER s-nroser-1 AS INT.
DEF INPUT PARAMETER x-Concepto-1 AS CHAR.
/* N/D */
DEF INPUT PARAMETER s-coddoc-2 AS CHAR.
DEF INPUT PARAMETER s-nroser-2 AS INT.
DEF INPUT PARAMETER x-Concepto-2 AS CHAR.

IF NOT AVAILABLE Faccpedi THEN RETURN ERROR.

&SCOPED-DEFINE Graba-Cabecera ASSIGN ~
    CcbCDocu.codcia = s-codcia~
    CcbCDocu.coddiv = s-coddiv ~
    CcbCDocu.divori = CDOCU.coddiv ~
    CcbCDocu.nrodoc = STRING(Faccorre.nroser, '999') + STRING(Faccorre.correlativo, '999999') ~
    CcbCDocu.fchdoc = TODAY ~
    CcbCDocu.fchvto = ADD-INTERVAL(TODAY, 1, 'years') ~
    CcbCDocu.codcli = CDOCU.codcli ~
    CcbCDocu.ruccli = CDOCU.ruccli ~
    CcbCDocu.nomcli = CDOCU.nomcli ~
    CcbCDocu.dircli = CDOCU.dircli ~
    CcbCDocu.porigv = ( IF CDOCU.porigv > 0 THEN CDOCU.porigv ELSE FacCfgGn.PorIgv ) ~
    CcbCDocu.codmon = CDOCU.CodMon ~
    CcbCDocu.usuario = s-user-id ~
    CcbCDocu.tpocmb = Faccfggn.tpocmb[1] ~
    CcbCDocu.codref = CDOCU.coddoc ~
    CcbCDocu.nroref = CDOCU.nrodoc ~
    CcbCDocu.CodPed = Faccpedi.coddoc ~
    CcbCDocu.NroPed = Faccpedi.nroped ~
    CcbCDocu.codven = CDOCU.codven ~
    CcbCDocu.cndcre = 'D' ~
    CcbCDocu.fmapgo = CDOCU.fmapgo ~
    CcbCDocu.tpofac = "PMR".

/* OJO:
    CcbCDocu.cndcre = 'N'   NO es una devolución, afecta directamente al producto
*/    
    

IF Ccbcdocu.ImpTot = (FacCPedi.AcuBon[5] + FacCPedi.ImpTot) THEN DO:
    MESSAGE "NO hay diferencia entre el comprobante y la hoja de cálculo" SKIP
        "Proceso abortado" VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
/* Hay que ver la diferencia por el detalle */
FOR EACH Facdpedi OF Faccpedi NO-LOCK,
    FIRST CcbDDocu NO-LOCK WHERE CcbDDocu.CodCia = FacDPedi.CodCia
    AND CcbDDocu.CodDoc = Faccpedi.codref
    AND CcbDDocu.NroDoc = Faccpedi.nroref
    AND CcbDDocu.codmat = FacDPedi.codmat
    AND Facdpedi.ImpLin <> Ccbddocu.ImpLin:
    IF CcbDDocu.ImpLin < FacDPedi.ImpLin THEN DO:
        /* N/C */
        IF x-Concepto-1 = '' THEN DO:
            MESSAGE 'Ingrese el código del concepto para la N/C' VIEW-AS ALERT-BOX ERROR.
            RETURN ERROR.
        END.
    END.
    ELSE DO:
        /* N/D */
        IF x-Concepto-2 = '' THEN DO:
            MESSAGE 'Ingrese el código del concepto para la N/D' VIEW-AS ALERT-BOX ERROR.
            RETURN ERROR.
        END.
    END.
END.
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi THEN RETURN ERROR.
    FIND FIRST Faccfggn WHERE Faccfggn.codcia = s-codcia NO-LOCK.
    /* Buscamos comprobante original */
    FIND CDOCU WHERE CDOCU.codcia = s-codcia
        AND CDOCU.coddoc = Faccpedi.codref
        AND CDOCU.nrodoc = Faccpedi.nroref
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE CDOCU THEN RETURN ERROR.
    /* ********************* GENERACION N/C ******************* */
    FIND Faccorre WHERE Faccorre.codcia = s-codcia
        AND Faccorre.coddoc = "N/C"
        AND Faccorre.nroser = s-nroser-1
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN UNDO, RETURN ERROR.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK, 
        FIRST DDOCU OF CDOCU WHERE DDOCU.codmat = Facdpedi.codmat
        AND Facdpedi.ImpLin < DDOCU.ImpLin
        BREAK BY Facdpedi.NroPed:
        IF FIRST-OF(Facdpedi.NroPed) THEN DO:
            CREATE CcbCDocu.
            ASSIGN
                CcbCDocu.coddoc = 'N/C'
                CcbCDocu.codcta = x-Concepto-1.
            {&Graba-Cabecera}
            ASSIGN
                Faccorre.correlativo = Faccorre.correlativo + 1.
            /* ACTUALIZAMOS EL CENTRO DE COSTO */
            FIND GN-VEN WHERE GN-VEN.codcia = s-codcia
                AND GN-VEN.codven = CcbCDocu.codven NO-LOCK NO-ERROR.
            IF AVAILABLE GN-VEN THEN CcbCDocu.cco = GN-VEN.cco.
            FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia
                AND CcbTabla.Tabla  = 'N/C' 
                AND CcbTabla.Codigo = x-Concepto-1 NO-LOCK.
            ASSIGN
                 CcbCDocu.Glosa = CcbTabla.Nombre.
        END.
        CREATE CcbDDocu.
        BUFFER-COPY CcbCDocu TO CcbDDocu
            ASSIGN
            CcbDDocu.codmat = Facdpedi.codmat
            CcbDDocu.candes = Facdpedi.canped
            CcbDDocu.factor = Facdpedi.factor
            CcbDDocu.undvta = Facdpedi.undvta
            CcbDDocu.aftigv = Facdpedi.aftigv
            CcbDDocu.preuni = ROUND( (DDOCU.ImpLin - Facdpedi.ImpLin) / CcbDDocu.candes, 4)
            CcbDDocu.implin = (DDOCU.ImpLin - Facdpedi.ImpLin).
        IF CcbDDocu.aftigv 
            THEN CcbDDocu.ImpIgv = ROUND( (CcbDDocu.ImpLin) * ((CcbCDocu.PorIgv / 100) / (1 + (CcbCDocu.PorIgv / 100))), 2).
        ELSE CcbDDocu.ImpIgv = 0.
        IF LAST-OF(Facdpedi.NroPed) THEN DO:
            RUN Graba-Totales-NC.
            /* GENERACION DE CONTROL DE PERCEPCIONES */
            RUN vta2/control-percepcion-abonos (ROWID(Ccbcdocu)) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.
            /* ************************************* */
            /* RUTINA SUNAT  */
            /* ************** */
        END.
    END.
    /* ********************* GENERACION N/D ******************* */
    FIND Faccorre WHERE Faccorre.codcia = s-codcia
        AND Faccorre.coddoc = "N/D"
        AND Faccorre.nroser = s-nroser-2
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN UNDO, RETURN ERROR.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK, 
        FIRST DDOCU OF CDOCU WHERE DDOCU.codmat = Facdpedi.codmat
        AND Facdpedi.ImpLin > DDOCU.ImpLin
        BREAK BY Facdpedi.NroPed:
        IF FIRST-OF(Facdpedi.NroPed) THEN DO:
            CREATE CcbCDocu.
            ASSIGN
                CcbCDocu.coddoc = 'N/D'
                CcbCDocu.codcta = x-Concepto-2.
            {&Graba-Cabecera}
            ASSIGN
                Faccorre.correlativo = Faccorre.correlativo + 1.
            /* ACTUALIZAMOS EL CENTRO DE COSTO */
            FIND GN-VEN WHERE GN-VEN.codcia = s-codcia
                AND GN-VEN.codven = CcbCDocu.codven NO-LOCK NO-ERROR.
            IF AVAILABLE GN-VEN THEN CcbCDocu.cco = GN-VEN.cco.
            FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia
                AND CcbTabla.Tabla  = 'N/D' 
                AND CcbTabla.Codigo = x-Concepto-2 NO-LOCK.
            ASSIGN
                 CcbCDocu.Glosa = CcbTabla.Nombre.
        END.
        CREATE CcbDDocu.
        BUFFER-COPY CcbCDocu TO CcbDDocu
            ASSIGN
            CcbDDocu.codmat = Facdpedi.codmat
            CcbDDocu.candes = Facdpedi.canped
            CcbDDocu.factor = Facdpedi.factor
            CcbDDocu.undvta = Facdpedi.undvta
            CcbDDocu.aftigv = Facdpedi.aftigv
            CcbDDocu.preuni = ABSOLUTE(ROUND( (DDOCU.ImpLin - Facdpedi.ImpLin) / CcbDDocu.candes, 4))
            CcbDDocu.implin = ABSOLUTE((DDOCU.ImpLin - Facdpedi.ImpLin)).
        IF CcbDDocu.aftigv 
            THEN CcbDDocu.ImpIgv = ROUND( (CcbDDocu.ImpLin) * ((CcbCDocu.PorIgv / 100) / (1 + (CcbCDocu.PorIgv / 100))), 2).
        ELSE CcbDDocu.ImpIgv = 0.
        IF LAST-OF(Facdpedi.NroPed) THEN DO:
            RUN Graba-Totales-ND.
            /* RUTINA SUNAT  */
            /* ************** */
        END.
    END.
    ASSIGN
        Faccpedi.FlgEst = "C"
        FacCPedi.FchAprobacion = TODAY
        FacCPedi.UsrAprobacion = s-user-id.
    FIND CURRENT Faccpedi NO-LOCK.
END.
IF AVAILABLE(Faccorre) THEN RELEASE Faccorre.
IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales-NC B-table-Win 
PROCEDURE Graba-Totales-NC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta/graba-totales-abono.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales-ND B-table-Win 
PROCEDURE Graba-Totales-ND :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  ASSIGN
    ccbcdocu.impbrt = 0
    ccbcdocu.impexo = 0
    ccbcdocu.impdto = 0
    CcbCDocu.ImpIsc = 0
    ccbcdocu.impigv = 0
    ccbcdocu.imptot = 0.
  FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
      ccbcdocu.ImpIgv = ccbcdocu.ImpIgv + Ccbddocu.ImpIgv.
      ccbcdocu.ImpTot = ccbcdocu.ImpTot + Ccbddocu.ImpLin.
      IF NOT Ccbddocu.AftIgv THEN CcbCDocu.ImpExo = CcbCDocu.ImpExo + Ccbddocu.ImpLin.
      IF Ccbddocu.AftIgv = YES
      THEN CcbCDocu.ImpDto = CcbCDocu.ImpDto + ROUND(Ccbddocu.ImpDto / (1 + Ccbcdocu.PorIgv / 100), 2).
      ELSE CcbCDocu.ImpDto = CcbCDocu.ImpDto + Ccbddocu.ImpDto.
  END.      
  CcbCDocu.ImpVta = CcbCDocu.ImpTot - CcbCDocu.ImpExo - CcbCDocu.ImpIgv.
  IF CcbCDocu.PorDto > 0 THEN DO:
      ASSIGN
          CcbCDocu.ImpDto = CcbCDocu.ImpDto + ROUND((CcbCDocu.ImpVta + CcbCDocu.ImpExo) * CcbCDocu.PorDto / 100, 2)
          CcbCDocu.ImpTot = ROUND(CcbCDocu.ImpTot * (1 - CcbCDocu.PorDto / 100),2)
          CcbCDocu.ImpVta = ROUND(CcbCDocu.ImpVta * (1 - CcbCDocu.PorDto / 100),2)
          CcbCDocu.ImpExo = ROUND(CcbCDocu.ImpExo * (1 - CcbCDocu.PorDto / 100),2)
          CcbCDocu.ImpIgv = CcbCDocu.ImpTot - CcbCDocu.ImpExo - CcbCDocu.ImpVta.
  END.
  CcbCDocu.ImpBrt = CcbCDocu.ImpVta + CcbCDocu.ImpIsc + CcbCDocu.ImpDto + CcbCDocu.ImpExo.
  CcbCDocu.SdoAct = CcbCDocu.ImpTot.
  /* CALCULO DE PERCEPCIONES */
  RUN vta2/calcula-percepcion-abonos ( ROWID(Ccbcdocu) ).
  FIND CURRENT CcbCDocu.
  /* *********************** */


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
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "CcbCDocu"}

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

