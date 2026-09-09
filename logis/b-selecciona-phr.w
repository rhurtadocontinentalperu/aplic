&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-PHR NO-UNDO LIKE DI-RutaC.



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
&Scoped-define INTERNAL-TABLES T-PHR

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-PHR.Libre_l01 T-PHR.NroDoc ~
T-PHR.FchDoc T-PHR.Libre_d01 T-PHR.Libre_d02 T-PHR.Libre_d03 ~
T-PHR.Libre_d04 T-PHR.Libre_d05 T-PHR.KmtIni T-PHR.Observ 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH T-PHR WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-PHR WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-PHR
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-PHR


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-70 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Clientes FILL-IN-Items ~
FILL-IN-Peso FILL-IN-Volumen 

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
DEFINE VARIABLE FILL-IN-Clientes AS INTEGER FORMAT "ZZZ,ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Items AS INTEGER FORMAT "ZZZ,ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Peso AS INTEGER FORMAT "ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Volumen AS INTEGER FORMAT "ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-70
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 114 BY 1.35
     BGCOLOR 15 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-PHR SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-PHR.Libre_l01 COLUMN-LABEL "Seleccionado" FORMAT "yes/no":U
            VIEW-AS TOGGLE-BOX
      T-PHR.NroDoc FORMAT "X(9)":U WIDTH 9.86
      T-PHR.FchDoc FORMAT "99/99/9999":U
      T-PHR.Libre_d01 COLUMN-LABEL "# Clientes" FORMAT ">>9":U
            WIDTH 8.72
      T-PHR.Libre_d02 COLUMN-LABEL "# Items" FORMAT ">>>9":U WIDTH 7.43
      T-PHR.Libre_d03 COLUMN-LABEL "Peso kg" FORMAT ">>>,>>>,>>9.99":U
      T-PHR.Libre_d04 COLUMN-LABEL "Volumen m3" FORMAT ">>>,>>>,>>9.99":U
            WIDTH 9.72
      T-PHR.Libre_d05 COLUMN-LABEL "Importe" FORMAT ">>>,>>9.99":U
      T-PHR.KmtIni COLUMN-LABEL "Bultos" FORMAT ">,>>9":U
      T-PHR.Observ COLUMN-LABEL "Glosa" FORMAT "x(60)":U WIDTH 27.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 114 BY 6.69
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN-Clientes AT ROW 8 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     FILL-IN-Items AT ROW 8 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-Peso AT ROW 8 COL 47 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     FILL-IN-Volumen AT ROW 8 COL 59 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     "Pulse dos veces con el ~"mouse~" sobre un registro para seleccionarlo" VIEW-AS TEXT
          SIZE 47 BY .5 AT ROW 9.08 COL 1 WIDGET-ID 22
          BGCOLOR 14 FGCOLOR 0 
     RECT-70 AT ROW 7.73 COL 1 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: T-PHR T "?" NO-UNDO INTEGRAL DI-RutaC
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
         HEIGHT             = 9.08
         WIDTH              = 117.14.
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

/* SETTINGS FOR FILL-IN FILL-IN-Clientes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Items IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Peso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Volumen IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-PHR"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.T-PHR.Libre_l01
"T-PHR.Libre_l01" "Seleccionado" ? "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-PHR.NroDoc
"T-PHR.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.T-PHR.FchDoc
     _FldNameList[4]   > Temp-Tables.T-PHR.Libre_d01
"T-PHR.Libre_d01" "# Clientes" ">>9" "decimal" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-PHR.Libre_d02
"T-PHR.Libre_d02" "# Items" ">>>9" "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-PHR.Libre_d03
"T-PHR.Libre_d03" "Peso kg" ">>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-PHR.Libre_d04
"T-PHR.Libre_d04" "Volumen m3" ">>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-PHR.Libre_d05
"T-PHR.Libre_d05" "Importe" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-PHR.KmtIni
"T-PHR.KmtIni" "Bultos" ">,>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-PHR.Observ
"T-PHR.Observ" "Glosa" ? "character" ? ? ? ? ? ? no ? no no "27.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON LEFT-MOUSE-DBLCLICK OF br_table IN FRAME F-Main
DO:
  IF NOT AVAILABLE T-PHR THEN RETURN.
  /* RHC 12/10/19 Uno a la vez */
/*   IF T-PHR.Libre_l01 = NO AND                                                                       */
/*       CAN-FIND(FIRST T-PHR WHERE T-PHR.NroDoc <> T-PHR.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} */
/*               AND T-PHR.Libre_l01 = YES NO-LOCK) THEN DO:                                           */
/*       MESSAGE 'Solo se puede seleccionar uno a la vez' VIEW-AS ALERT-BOX INFORMATION.               */
/*       RETURN.                                                                                       */
/*   END.                                                                                              */


  FIND CURRENT T-PHR EXCLUSIVE-LOCK.
  ASSIGN
      T-PHR.Libre_l01 = NOT (T-PHR.Libre_l01).
  FIND CURRENT T-PHR NO-LOCK.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-PHR.
DEF VAR x-Clientes AS CHAR NO-UNDO.
DEF VAR x-Bultos AS INTE NO-UNDO.

/* 05/02/2026: Optimizado */
FOR EACH Di-RutaC NO-LOCK WHERE DI-RutaC.CodCia = s-codcia AND
    DI-RutaC.CodDiv = s-coddiv AND 
    DI-RutaC.CodDoc = "PHR" AND
    DI-RutaC.FlgEst = "P":
    CREATE T-PHR.
    BUFFER-COPY Di-RutaC TO T-PHR.
    ASSIGN
        T-PHR.Libre_d01 = 0
        T-PHR.Libre_d02 = 0
        T-PHR.Libre_d03 = 0     /* Peso */
        T-PHR.Libre_d04 = 0     /* Volumen */
        T-PHR.Libre_d05 = 0     /* Importe */
        T-PHR.Libre_l01 = NO
        T-PHR.KmtIni = 0.       /* Bultos */
END.

FOR EACH T-PHR:
    x-Bultos = 0.
    x-Clientes = ''.
    FOR EACH DI-RutaD OF T-PHR NO-LOCK:
        FIND FIRST Faccpedi WHERE FacCPedi.CodCia = DI-RutaD.CodCia AND
            FacCPedi.CodDoc = DI-RutaD.CodRef AND
            FacCPedi.NroPed = DI-RutaD.NroRef
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccpedi THEN NEXT.
        IF TRUE <> (x-Clientes > '') OR LOOKUP(FacCPedi.CodCli, x-Clientes) = 0 THEN DO:
            x-Clientes = x-Clientes + (IF TRUE <> (x-Clientes > '') THEN '' ELSE ',') +
                FacCPedi.CodCli.
        END.
        /* # Items */
        T-PHR.Libre_d02 = T-PHR.Libre_d02 + Faccpedi.items.
        /* Peso */
        T-PHR.Libre_d03 = T-PHR.Libre_d03 + Faccpedi.peso.
        /* Volumen */
        T-PHR.Libre_d04 = T-PHR.Libre_d04 + Faccpedi.volumen.
        CASE Faccpedi.CodDoc:
            WHEN "O/D" OR WHEN "O/M" THEN DO:
                T-PHR.Libre_d05 = T-PHR.Libre_d05 + Faccpedi.imptot.
            END.
        END CASE.
        FIND FIRST Ccbcbult WHERE CcbCBult.CodCia = Faccpedi.CodCia AND
            CcbCBult.CodDoc = Faccpedi.CodDoc AND
            CcbCBult.NroDoc = Faccpedi.NroPed NO-LOCK NO-ERROR.
        IF AVAILABLE Ccbcbult THEN x-Bultos = x-Bultos + CcbCBult.Bultos.
    END.
    T-PHR.Libre_d01 = NUM-ENTRIES(x-Clientes).
    T-PHR.KmtIni = x-Bultos.
END.

/*
FOR EACH Di-RutaC NO-LOCK WHERE DI-RutaC.CodCia = s-codcia AND
    DI-RutaC.CodDiv = s-coddiv AND 
    DI-RutaC.CodDoc = "PHR" AND
    DI-RutaC.FlgEst = "P":
    CREATE T-PHR.
    BUFFER-COPY Di-RutaC TO T-PHR.
    ASSIGN
        T-PHR.Libre_d01 = 0
        T-PHR.Libre_d02 = 0
        T-PHR.Libre_d03 = 0     /* Peso */
        T-PHR.Libre_d04 = 0     /* Volumen */
        T-PHR.Libre_d05 = 0     /* Importe */
        T-PHR.Libre_l01 = NO
        T-PHR.KmtIni = 0.       /* Bultos */
        x-Bultos = 0.
    x-Clientes = ''.
    FOR EACH DI-RutaD OF Di-RutaC NO-LOCK,
        FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = DI-RutaD.CodCia AND
        FacCPedi.CodDoc = DI-RutaD.CodRef AND
        FacCPedi.NroPed = DI-RutaD.NroRef:
        FOR EACH FacDPedi OF FacCPedi NO-LOCK, FIRST Almmmatg OF FacDPedi NO-LOCK:
            /* Clientes */
            IF LOOKUP(FacCPedi.CodCli, x-Clientes) = 0 THEN DO:
                x-Clientes = x-Clientes + (IF TRUE <> (x-Clientes > '') THEN '' ELSE ',') +
                    FacCPedi.CodCli.
            END.
            /* # Items */
            T-PHR.Libre_d02 = T-PHR.Libre_d02 + 1.
            /* Peso */
            T-PHR.Libre_d03 = T-PHR.Libre_d03 + (FacDPedi.CanPed * FacDPedi.Factor * Almmmatg.PesMat).
            /* Volumen */
            T-PHR.Libre_d04 = T-PHR.Libre_d04 + (FacDPedi.CanPed * FacDPedi.Factor * Almmmatg.Libre_d02).
            CASE Faccpedi.CodDoc:
                WHEN "O/D" OR WHEN "O/M" THEN DO:
                    T-PHR.Libre_d05 = T-PHR.Libre_d05 + Facdpedi.ImpLin.
                END.
                OTHERWISE DO:
                    T-PHR.Libre_d05 = T-PHR.Libre_d05 + ( (Facdpedi.CanPed * Facdpedi.Factor) *
                                                          Almmmatg.CtoTot *
                                                          (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1) ).
                END.
            END CASE.
        END.
        FIND FIRST Ccbcbult WHERE CcbCBult.CodCia = Faccpedi.CodCia AND
            CcbCBult.CodDoc = Faccpedi.CodDoc AND
            CcbCBult.NroDoc = Faccpedi.NroPed NO-LOCK NO-ERROR.
        IF AVAILABLE Ccbcbult THEN x-Bultos = x-Bultos + CcbCBult.Bultos.
    END.
    T-PHR.Libre_d01 = NUM-ENTRIES(x-Clientes).
    T-PHR.Libre_d04 = T-PHR.Libre_d04 / 1000000.
    T-PHR.KmtIni = x-Bultos.
END.
*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Carga-Temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PHR-Seleccionadas B-table-Win 
PROCEDURE PHR-Seleccionadas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pNroPHR AS CHAR.

DEF BUFFER B-PHR FOR T-PHR.
 
pNroPHR = ''.
FOR EACH B-PHR WHERE B-PHR.Libre_l01 = YES:
    pNroPHR = pNroPHR + (IF TRUE <> (pNroPHR > '') THEN '' ELSE ',') + B-PHR.NroDoc.
END.

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
  {src/adm/template/snd-list.i "T-PHR"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales B-table-Win 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF BUFFER B-PHR FOR T-PHR.
ASSIGN
    FILL-IN-Clientes = 0
    FILL-IN-Items = 0
    FILL-IN-Peso = 0
    FILL-IN-Volumen = 0.
FOR EACH B-PHR WHERE B-PHR.Libre_l01 = YES:
    ASSIGN
        FILL-IN-Clientes = FILL-IN-Clientes + B-PHR.Libre_d01 
        FILL-IN-Items    = FILL-IN-Items    + B-PHR.Libre_d02 
        FILL-IN-Peso     = FILL-IN-Peso     + B-PHR.Libre_d03 
        FILL-IN-Volumen  = FILL-IN-Volumen  + B-PHR.Libre_d04.
END.
DISPLAY
    FILL-IN-Clientes FILL-IN-Items FILL-IN-Peso FILL-IN-Volumen
    WITH FRAME {&FRAME-NAME}.

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

