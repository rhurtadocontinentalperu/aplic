&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE DATOS NO-UNDO LIKE AlmCatVtaD
       Fields ImpUnit AS DEC.
DEFINE SHARED TEMP-TABLE PEDI2 NO-UNDO LIKE VtaDDocu.



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

DEFINE SHARED VAR S-CODCIA AS INT.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR s-nrocot AS CHAR.
DEFINE SHARED VAR s-CodCli LIKE gn-clie.codcli.
DEFINE SHARED VAR s-CodMon AS INT.
DEFINE SHARED VAR s-TpoCmb AS DEC.
DEFINE SHARED VAR s-CndVta AS CHAR.
DEFINE NEW SHARED VAR s-task-no AS INT.
DEFINE SHARED VAR s-codalm AS CHAR.
DEFINE SHARED VAR lh_handle AS HANDLE.

DEFINE SHARED VAR s-FlgEmpaque LIKE GN-DIVI.FlgEmpaque.
/*DEFINE SHARED VAR s-FlgRotacion LIKE gn-divi.flgrotacion.-*/
DEFINE SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.

DEFINE VARIABLE dImpLin AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dTotImp AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dTotCan AS DECIMAL     NO-UNDO.

DEFINE VARIABLE x-canPed AS DECIMAL     NO-UNDO.
DEFINE VARIABLE f-factor AS DECIMAL     NO-UNDO.
DEFINE VARIABLE f-PreBas AS DECIMAL     NO-UNDO.
DEFINE VARIABLE f-PreVta AS DECIMAL     NO-UNDO.
DEFINE VARIABLE f-Dsctos AS DECIMAL     NO-UNDO.
DEFINE VARIABLE y-Dsctos AS DECIMAL     NO-UNDO.
DEFINE VARIABLE z-Dsctos AS DECIMAL     NO-UNDO.
DEFINE VARIABLE s-undvta AS CHARACTER   NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER  NO-UNDO FORMAT 'x(35)'.


/*DEFINE VARIABLE x-task-no AS INTEGER    NO-UNDO.*/
FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE FRAME F-Mensaje
    x-mensaje SKIP
    " Espere un momento por favor..." SKIP
    WITH VIEW-AS DIALOG-BOX CENTERED OVERLAY WIDTH 40 TITLE 'Mensaje'.

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

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES AlmCatVtaC
&Scoped-define FIRST-EXTERNAL-TABLE AlmCatVtaC


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR AlmCatVtaC.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES DATOS Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table DATOS.codmat Almmmatg.DesMat ~
Almmmatg.DesMar DATOS.UndBas DATOS.PorDto DATOS.PorDto2 DATOS.Por_Dsctos[1] ~
DATOS.PreAlt[4] DATOS.Libre_d01 DATOS.NroSec ImpUnit @ ImpUnit 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table DATOS.Libre_d01 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table DATOS
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table DATOS
&Scoped-define QUERY-STRING-br_table FOR EACH DATOS WHERE DATOS.CodCia = AlmCatVtaC.CodCia ~
  AND DATOS.NroPag = AlmCatVtaC.NroPag ~
  AND DATOS.CodDiv = AlmCatVtaC.CodDiv ~
  AND DATOS.CodPro = AlmCatVtaC.CodPro NO-LOCK, ~
      EACH Almmmatg WHERE Almmmatg.CodCia = DATOS.CodCia ~
  AND Almmmatg.codmat = DATOS.codmat NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH DATOS WHERE DATOS.CodCia = AlmCatVtaC.CodCia ~
  AND DATOS.NroPag = AlmCatVtaC.NroPag ~
  AND DATOS.CodDiv = AlmCatVtaC.CodDiv ~
  AND DATOS.CodPro = AlmCatVtaC.CodPro NO-LOCK, ~
      EACH Almmmatg WHERE Almmmatg.CodCia = DATOS.CodCia ~
  AND Almmmatg.codmat = DATOS.codmat NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table DATOS Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table DATOS
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table btn-save BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS x-TotCan x-TotImp 

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
DEFINE BUTTON btn-save AUTO-END-KEY 
     IMAGE-UP FILE "img/save.bmp":U
     LABEL "Button 5" 
     SIZE 9 BY 2.15.

DEFINE BUTTON BUTTON-1 
     LABEL "Calcula" 
     SIZE 15 BY .85.

DEFINE VARIABLE x-TotCan AS DECIMAL FORMAT "->,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY 1
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE x-TotImp AS DECIMAL FORMAT "->>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13.57 BY 1
     BGCOLOR 8  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      DATOS, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      DATOS.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U WIDTH 8
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 45
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(25)":U WIDTH 19
      DATOS.UndBas COLUMN-LABEL "Unid" FORMAT "X(4)":U
      DATOS.PorDto COLUMN-LABEL "% Dscto 1." FORMAT ">>9.99":U
      DATOS.PorDto2 COLUMN-LABEL "% Dscto 2." FORMAT ">>9.99":U
      DATOS.Por_Dsctos[1] COLUMN-LABEL "% Dscto!Manual" FORMAT "->>9.99":U
      DATOS.PreAlt[4] COLUMN-LABEL "Precio!Unitario" FORMAT "->>,>>>,>>9.9999":U
      DATOS.Libre_d01 COLUMN-LABEL "Cantidad" FORMAT "->>>,>>>,>>9.99<<<":U
            COLUMN-FGCOLOR 9
      DATOS.NroSec COLUMN-LABEL "Sec" FORMAT "9999":U WIDTH 4.29
      ImpUnit @ ImpUnit COLUMN-LABEL "Importe" FORMAT "->>,>>>,>>9.9999":U
  ENABLE
      DATOS.Libre_d01
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 146 BY 12.92
         FONT 4
         TITLE "Detalle Articulos por Pagina".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     btn-save AT ROW 3.15 COL 148 WIDGET-ID 6
     x-TotCan AT ROW 14 COL 111 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     x-TotImp AT ROW 14 COL 127.86 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     BUTTON-1 AT ROW 14.12 COL 70 WIDGET-ID 18
     "Totales:" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 14.19 COL 91.29 WIDGET-ID 14
     "GRABAR" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 5.31 COL 148.72 WIDGET-ID 8
          FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.AlmCatVtaC
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: DATOS T "SHARED" NO-UNDO INTEGRAL AlmCatVtaD
      ADDITIONAL-FIELDS:
          Fields ImpUnit AS DEC
      END-FIELDS.
      TABLE: PEDI2 T "SHARED" NO-UNDO INTEGRAL VtaDDocu
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
         HEIGHT             = 14.19
         WIDTH              = 156.57.
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

/* SETTINGS FOR FILL-IN x-TotCan IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-TotImp IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.DATOS WHERE INTEGRAL.AlmCatVtaC <external> ...,INTEGRAL.Almmmatg WHERE Temp-Tables.DATOS ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _JoinCode[1]      = "Temp-Tables.DATOS.CodCia = AlmCatVtaC.CodCia
  AND Temp-Tables.DATOS.NroPag = AlmCatVtaC.NroPag
  AND Temp-Tables.DATOS.CodDiv = AlmCatVtaC.CodDiv
  AND Temp-Tables.DATOS.CodPro = AlmCatVtaC.CodPro"
     _JoinCode[2]      = "INTEGRAL.Almmmatg.CodCia = Temp-Tables.DATOS.CodCia
  AND INTEGRAL.Almmmatg.codmat = Temp-Tables.DATOS.codmat"
     _FldNameList[1]   > Temp-Tables.DATOS.codmat
"DATOS.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(25)" "character" ? ? ? ? ? ? no ? no no "19" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.DATOS.UndBas
"DATOS.UndBas" "Unid" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.DATOS.PorDto
"DATOS.PorDto" "% Dscto 1." ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.DATOS.PorDto2
"DATOS.PorDto2" "% Dscto 2." ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.DATOS.Por_Dsctos[1]
"DATOS.Por_Dsctos[1]" "% Dscto!Manual" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.DATOS.PreAlt[4]
"DATOS.PreAlt[4]" "Precio!Unitario" "->>,>>>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.DATOS.Libre_d01
"DATOS.Libre_d01" "Cantidad" ? "decimal" ? 9 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.DATOS.NroSec
"DATOS.NroSec" "Sec" ? "integer" ? ? ? ? ? ? no ? no no "4.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"ImpUnit @ ImpUnit" "Importe" "->>,>>>,>>9.9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* Detalle Articulos por Pagina */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* Detalle Articulos por Pagina */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* Detalle Articulos por Pagina */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DATOS.Libre_d01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DATOS.Libre_d01 br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF DATOS.Libre_d01 IN BROWSE br_table /* Cantidad */
DO:
    DATOS.codmat:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    Almmmatg.DesMar:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    Almmmatg.DesMat:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    DATOS.UndBas:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    DATOS.PorDto:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    DATOS.PorDto2:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    DATOS.Por_Dsctos[1]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    DATOS.PreAlt[4]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    DATOS.Libre_d01:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    DATOS.NroSec:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    DATOS.ImpUni:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DATOS.Libre_d01 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF DATOS.Libre_d01 IN BROWSE br_table /* Cantidad */
DO:
    DEFINE VARIABLE x-canPed AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE f-factor AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE f-PreBas AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE f-PreVta AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE f-Dsctos AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE y-Dsctos AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE z-Dsctos AS DECIMAL     NO-UNDO.

    /*Colorea Fila*/
    DATOS.codmat:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    Almmmatg.DesMar:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    Almmmatg.DesMat:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    DATOS.UndBas:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    DATOS.PorDto:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    DATOS.PorDto2:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    DATOS.Por_Dsctos[1]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    DATOS.PreAlt[4]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    DATOS.Libre_d01:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    DATOS.NroSec:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    DATOS.ImpUni:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.



    ASSIGN 
        ImpUnit = (DEC(datos.libre_d01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) 
             * datos.prealt[4]).    
    DISPLAY ImpUnit @ ImpUnit WITH BROWSE {&BROWSE-NAME}.          
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-save B-table-Win
ON CHOOSE OF btn-save IN FRAME F-Main /* Button 5 */
DO:
  RUN Graba-Datos.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Calcula */
DO:
   RUN Generar-Consulta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/*     RUN Calcula_Total_Importe.                                                 */

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "AlmCatVtaC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "AlmCatVtaC"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula_Total_Importe B-table-Win 
PROCEDURE Calcula_Total_Importe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    dTotImp = 0.
    dTotCan = 0.
    FOR EACH datos WHERE datos.codcia = s-codcia
        AND datos.coddiv = s-coddiv
        AND datos.libre_d01 <> 0 NO-LOCK:
        dTotImp = dTotImp + datos.impuni.
        dTotCan = dTotCan + datos.libre_d01.
        PAUSE 0.
    END.
    IF dtotCan = 0 THEN DO:
        FOR EACH pedi2 NO-LOCK
            WHERE pedi2.canped > 0:
            dTotImp = dTotImp + pedi2.implin.
            dTotCan = dTotCan + pedi2.canped.
        END.

    END.

    DISPLAY 
        dTotImp @ x-TotImp 
        dTotCan @ x-TotCan
        WITH FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel B-table-Win 
PROCEDURE Genera-Excel :
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 5.
DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.

DEFINE VARIABLE K AS INTEGER NO-UNDO.
DEFINE VARIABLE P AS INTEGER NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
/*chWorkbook = chExcelApplication:Workbooks:Add("C:\PRG\Templates\q fue\Cotizacion.xlt").*/
DEF var x-Plantilla AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta' VALUE x-Plantilla .
x-Plantilla = x-Plantilla + "Catalogo02.xlt".

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add(x-Plantilla).

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*Header del Excel */
chWorkSheet:Range('B5'):Font:Bold = TRUE.
chWorkSheet:Range('B5'):Value = "CATALOGO DE PRODUCTOS".
chWorkSheet:Range('E5'):Value = TODAY.

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".

t-Column = t-Column + 5.
P = t-Column.

x-mensaje = 'Generando Archivo Excel'.
/*VIEW FRAME f-mensaje.*/
DISPLAY 
    x-mensaje NO-LABEL
    WITH FRAME f-mensaje.
FOR EACH datos WHERE datos.codcia = s-codcia
    AND datos.coddiv = s-coddiv
    AND datos.codpro = almcatvtac.codpro 
    AND datos.libre_d01 > 0 NO-LOCK,
    FIRST almmmatg WHERE almmmatg.codcia = s-codcia
        AND almmmatg.codmat = datos.codmat NO-LOCK
    BREAK BY datos.nropag DESC
        BY datos.nrosec DESC:
    
    /*Agrega Row*/
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):EntireRow:INSERT.
    
    p = p + 1.   
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.    
    chWorkSheet:Range(cRange):Value = datos.codmat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = datos.DesMat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.undbas.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.PreAlt[4].        
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = datos.libre_d01.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.PreAlt[4] *  datos.libre_d01.
    /****SubTotales****
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = '=+IF($J' + STRING(t-column - 1) + ' = "S", H' + STRING(t-column) + ', (H' + STRING(t-column) + ' + K' + STRING(t-column - 1) + '))'.         
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = '=+IF($J' + STRING(t-column - 1) + ' = "S", I' + STRING(t-column) + ', (I' + STRING(t-column) + ' + L' + STRING(t-column - 1) + '))'.         
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = '=+IF($J' + STRING(t-column) + ' = "S", K' + STRING(t-column) + ', "" )'.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = '=+IF($J' + STRING(t-column) + ' = "S", L' + STRING(t-column) + ', "" )'.    
    */

END.

HIDE FRAME f-mensaje.

/* launch Excel so it is visible to the user */
 chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Listado B-table-Win 
PROCEDURE Genera-Listado :
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 5.
DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.

DEFINE VARIABLE K AS INTEGER NO-UNDO.
DEFINE VARIABLE P AS INTEGER NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
/*chWorkbook = chExcelApplication:Workbooks:Add("C:\PRG\Templates\q fue\Cotizacion.xlt").*/
DEF var x-Plantilla AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta' VALUE x-Plantilla .
x-Plantilla = x-Plantilla + "Catalogo.xlt".

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add(x-Plantilla).

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*Header del Excel */
chWorkSheet:Range('D5'):Font:Bold = TRUE.
chWorkSheet:Range('D5'):Value = "CATALOGO DE PRODUCTOS PARA EL PROVEEDOR: " + almcatvtac.codpro.
chWorkSheet:Range('G5'):Value = TODAY.

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("B"):NumberFormat = "@".
chWorkSheet:Columns("C"):NumberFormat = "@".
chWorkSheet:Columns("D"):NumberFormat = "@".


t-Column = t-Column + 5.
P = t-Column.

x-mensaje = 'Generando Archivo Excel'.
/*VIEW FRAME f-mensaje.*/
DISPLAY 
    x-mensaje NO-LABEL
    WITH FRAME f-mensaje.
FOR EACH datos WHERE datos.codcia = s-codcia
    AND datos.coddiv = s-coddiv
    AND datos.codpro = almcatvtac.codpro /*
    AND datos.nropag = almcatvtac.nropag*/ NO-LOCK,
    FIRST almmmatg WHERE almmmatg.codcia = s-codcia
        AND almmmatg.codmat = datos.codmat NO-LOCK
    BREAK BY datos.nropag DESC
        BY datos.nrosec DESC:
    
    /*Agrega Row*/
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):EntireRow:INSERT.
    
    p = p + 1.   
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + datos.codpro.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(datos.nropag,'999').
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(datos.nrosec,'999').
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = datos.codmat.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = datos.DesMat.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.undbas.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.PreAlt[4].        
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = datos.libre_d01.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = '=H'+ STRING(t-column) + '*I' + STRING(t-column).        
    /****SubTotales****
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = '=+IF($J' + STRING(t-column - 1) + ' = "S", H' + STRING(t-column) + ', (H' + STRING(t-column) + ' + K' + STRING(t-column - 1) + '))'.         
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = '=+IF($J' + STRING(t-column - 1) + ' = "S", I' + STRING(t-column) + ', (I' + STRING(t-column) + ' + L' + STRING(t-column - 1) + '))'.         
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = '=+IF($J' + STRING(t-column) + ' = "S", K' + STRING(t-column) + ', "" )'.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = '=+IF($J' + STRING(t-column) + ' = "S", L' + STRING(t-column) + ', "" )'.    
    */

END.

HIDE FRAME f-mensaje.

/* launch Excel so it is visible to the user */
 chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generar-Consulta B-table-Win 
PROCEDURE Generar-Consulta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR L-Ubica   AS LOGICAL INIT YES.   
    DEFINE VAR dTotGru   AS DECIMAL NO-UNDO FORMAT '->>>,>>>,>>9.9999'.
    DEFINE VAR dTotCan   AS DECIMAL NO-UNDO FORMAT '->>>,>>>,>>9.9999'.      
    DEFINE VAR iInt      AS INTEGER NO-UNDO INIT 1.
    
    REPEAT WHILE L-Ubica:
           s-task-no = RANDOM(900000,999999).
           FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
           IF NOT AVAILABLE w-report THEN L-Ubica = NO.
    END.

    FOR EACH datos WHERE datos.codcia = s-codcia NO-LOCK
        BREAK BY datos.codpro
            BY datos.nropag
            BY datos.nrosec:
        
        FIND FIRST w-report WHERE w-report.task-no = s-task-no
            AND w-report.llave-c = datos.codmat NO-ERROR.
        IF NOT AVAIL w-report THEN DO:            
            IF datos.libre_d01 > 0 THEN DO:
                CREATE w-report.
                ASSIGN 
                    w-report.task-no = s-task-no
                    w-report.llave-c = datos.codmat
                    w-report.Campo-I[1] = datos.nropag
                    w-report.Campo-I[2] = datos.nrosec
                    w-report.Campo-C[1] = datos.desmat
                    w-report.Campo-C[2] = 'S' + STRING(iint)
                    w-report.Campo-C[3] = datos.codpro
                    w-report.Campo-F[1] = datos.libre_d01
                    w-report.Campo-F[2] = datos.impuni
                    w-report.Campo-I[3] = 15.    
            END.
            dTotCan = dTotCan + datos.libre_d01.
            dTotGru = dTotGru + datos.impuni.
            
        END.
        IF datos.flgqui = 'S' AND dTotCan > 0 THEN DO:            
            CREATE w-report.
            ASSIGN 
                w-report.task-no = s-task-no
                w-report.llave-c = '099999'
                w-report.Campo-I[1] = datos.nropag
                w-report.Campo-I[2] = 999
                w-report.Campo-C[1] = 'SUB TOTAL (' + datos.codpro + ')'
                w-report.Campo-C[2] = datos.flgqui + STRING(iint)
                w-report.Campo-C[3] = datos.codpro
                w-report.Campo-F[1] = dTotCan
                w-report.Campo-F[2] = dTotGru
                w-report.Campo-I[3] = 8.    
            dTotGru = 0.
            dTotCan = 0.
            iint = iint + 1.
        END.
        
        IF LAST-OF(datos.nropag) AND dTotCan > 0 THEN DO: 
            MESSAGE 'CodPro ' datos.codpro SKIP
                'Secuencia ' datos.nrosec.
            CREATE w-report.
            ASSIGN 
                w-report.task-no = s-task-no
                w-report.llave-c = '099999'
                w-report.Campo-I[1] = datos.nropag
                w-report.Campo-I[2] = 999
                w-report.Campo-C[1] = 'SUB TOTAL (' + datos.codpro + ')'
                w-report.Campo-C[2] = 'S' + STRING(iint)
                w-report.Campo-C[3] = datos.codpro
                w-report.Campo-F[1] = dTotCan
                w-report.Campo-F[2] = dTotGru
                w-report.Campo-I[3] = 8.    
            dTotGru = 0.
            dTotCan = 0.
            iint = 1.
        END.
    END.
    RUN vtaexp/w-consultaexp.

    FOR EACH w-report WHERE w-report.task-no = s-task-no :
        DELETE w-report.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Datos B-table-Win 
PROCEDURE Graba-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*Elimina otros datos*/
    FOR EACH pedi2:
        DELETE pedi2.
    END.

    FOR EACH datos WHERE datos.codcia = s-codcia
        AND datos.coddiv = s-coddiv 
        AND datos.libre_d01 <> 0 NO-LOCK,
        FIRST almmmatg WHERE almmmatg.codcia = s-codcia
        AND almmmatg.codmat = datos.codmat NO-LOCK:
        FIND FIRST pedi2 WHERE pedi2.codcia = s-codcia
            AND pedi2.codped = "PET"
            AND pedi2.nroped = s-nrocot
            AND pedi2.codmat = datos.codmat NO-ERROR.
        IF NOT AVAIL pedi2 THEN DO:
            f-factor = 1.
            RUN vtagn/PrecioListaMayorista (
                                s-CodDiv,
                                s-CodCli,
                                s-CodMon,
                                s-TpoCmb,
                                OUTPUT s-UndVta,
                                OUTPUT f-Factor,
                                Almmmatg.CodMat,
                                s-CndVta,
                                x-CanPed,
                                4,
                                OUTPUT f-PreBas,
                                OUTPUT f-PreVta,
                                OUTPUT f-Dsctos,
                                OUTPUT y-Dsctos,
                                OUTPUT z-Dsctos
                                ).

            CREATE PEDI2.
            ASSIGN
                PEDI2.CodCia = s-codcia
                PEDI2.CodDiv = s-coddiv
                PEDI2.AlmDes = s-codalm
                PEDI2.CodMat = datos.codmat                
                PEDI2.CodPed = "PET"
                PEDI2.NroPed = s-nrocot
                PEDI2.Factor = f-factor
                PEDI2.UndVta = datos.undbas:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                PEDI2.PreUni = f-prevta
                PEDI2.CanPed = datos.libre_d01
                PEDI2.Libre_d01 = datos.libre_d01
                PEDI2.Libre_c01 = STRING(datos.nropag,"9999")
                PEDI2.Libre_c02 = STRING(datos.nrosec,"9999")
                PEDI2.Libre_c03 = datos.codpro
                PEDI2.PorDto = F-DSCTOS
                PEDI2.Por_Dsctos[1] = z-Dsctos
                PEDI2.PreBas = F-PreBas 
                PEDI2.Por_DSCTOS[2] = Almmmatg.PorMax
                PEDI2.Por_Dsctos[3] = Y-DSCTOS
                PEDI2.AftIgv = Almmmatg.AftIgv 
                PEDI2.AftIsc = Almmmatg.AftIsc 
                PEDI2.ImpDto = ROUND( PEDI2.PreUni * PEDI2.CanPed * (PEDI2.Por_Dsctos[1] / 100),4 )
                PEDI2.ImpLin = ROUND( PEDI2.PreUni * PEDI2.CanPed , 2 ) - PEDI2.ImpDto
                PEDI2.PesMat = PEDI2.CanPed * Almmmatg.PesMat.

            IF PEDI2.AftIsc THEN PEDI2.ImpIsc = ROUND(PEDI2.PreBas * PEDI2.CanPed * (Almmmatg.PorIsc / 100),4).
            IF PEDI2.AftIgv THEN  PEDI2.ImpIgv = PEDI2.ImpLin - ROUND(PEDI2.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
        END.
        /*PEDI2.ImpLin    = (datos.prealt[4] * datos.libre_d01).*/
        .
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel B-table-Win 
PROCEDURE Importar-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.
DEFINE VARIABLE FILL-IN-file AS CHAR NO-UNDO.
DEFINE VAR F-CTOLIS AS DECIMAL NO-UNDO.
DEFINE VAR F-CTOTOT AS DECIMAL NO-UNDO.

SYSTEM-DIALOG GET-FILE FILL-IN-file
    FILTERS "Archivos Excel (*.xls)" "*.xls", "Todos (*.*)" "*.*"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

/* SEGUNDO IMPORTAMOS DESDE EL EXCEL */
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.

DEFINE VARIABLE cRange AS CHARACTER NO-UNDO.
DEFINE VARIABLE iCountLine AS INTEGER NO-UNDO.
DEFINE VARIABLE iTotalColumn AS INTEGER NO-UNDO.
DEFINE VARIABLE cValue1 AS CHARACTER NO-UNDO.
DEFINE VARIABLE cValue2 AS CHARACTER NO-UNDO.
DEFINE VARIABLE cValue3 AS CHARACTER NO-UNDO.
DEFINE VARIABLE cValue4 AS CHARACTER NO-UNDO.


CREATE "Excel.Application" chExcelApplication.

chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-file).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

x-mensaje = 'Importando Archivo Excel'.
/*VIEW FRAME f-mensaje.*/
DISPLAY x-mensaje WITH FRAME f-mensaje.

iCountLine = 1.     /* Saltamos el encabezado de los campos */
REPEAT:
    
    iCountLine = iCountLine + 1.
    cRange = "A" + TRIM(STRING(iCountLine)).
    cValue1 = chWorkSheet:Range(cRange):VALUE.
    /*IF cValue1 = "." OR cValue1 = ? THEN NEXT.    /* FIN DE DATOS */*/
    IF cValue1 = ? THEN NEXT.
    IF cValue1 = '.' THEN LEAVE.
    /* NroPagina */
    cRange = "D" + TRIM(STRING(iCountLine)).
    cValue2 = chWorkSheet:Range(cRange):VALUE.
    ASSIGN
        cValue2 = STRING(INTEGER (cValue2), '999999')
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN NEXT.    

    cRange = "H" + TRIM(STRING(iCountLine)).
    cValue3 = chWorkSheet:Range(cRange):VALUE.

    cRange = "I" + TRIM(STRING(iCountLine)).
    cValue4 = chWorkSheet:Range(cRange):VALUE.
    IF cValue4 = ? THEN cValue4 = STRING(0).

    /*IF (DEC(cValue4) > 0) THEN DO:*/
        FIND FIRST datos WHERE datos.codcia = s-codcia
            AND datos.codpro = cValue1
            AND datos.codmat = cValue2 NO-ERROR.
        IF NOT AVAIL datos THEN DO:
            FIND FIRST almcatvtad WHERE almcatvtad.codcia = s-codcia
                AND almcatvtad.codpro = cValue1
                AND almcatvtad.codmat = cValue2  NO-ERROR.
            IF AVAIL almcatvtad THEN DO:
                MESSAGE 'crea'.
                CREATE datos.
                BUFFER-COPY almcatvtad TO datos.
                ASSIGN 
                    datos.prealt[4] = DEC(cValue3).
            END.        
        END.
        ELSE 
            ASSIGN 
                datos.libre_d01 = DEC(cValue4)
                datos.impuni = (datos.libre_d01 * datos.prealt[4]) .
    /*END.*/
END.
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 
MESSAGE 'Termino Carga de Información'.
HIDE FRAME f-mensaje.


RUN Procesa-Handle IN lh_handle ('open').

RUN adm-open-query.
RUN Calcula_Total_Importe.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  RUN Calcula_Total_Importe.

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
    
  RUN Calcula_Total_Importe.

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
  {src/adm/template/snd-list.i "AlmCatVtaC"}
  {src/adm/template/snd-list.i "DATOS"}
  {src/adm/template/snd-list.i "Almmmatg"}

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
 
  IF DECIMAL(DATOS.Libre_d01:SCREEN-VALUE IN BROWSE {&browse-name}) = 0 THEN RETURN 'OK'.

  DEF VAR f-Canped AS DEC NO-UNDO.
   /* EMPAQUE */
  IF s-FlgEmpaque = YES AND Almmmatg.CanEmp > 0 THEN DO:
      f-CanPed = DECIMAL(DATOS.Libre_d01:SCREEN-VALUE IN BROWSE {&browse-name}).
      f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.CanEmp),0) * Almmmatg.CanEmp).
      IF f-CanPed <> DECIMAL(DATOS.Libre_d01:SCREEN-VALUE IN BROWSE {&browse-name}) THEN DO:
          MESSAGE 'Solo puede vender en empaques de' Almmmatg.CanEmp
              VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO DATOS.Libre_d01.
          RETURN "ADM-ERROR".
      END.
  END.

  /* MINIMO DE VENTA */
  IF s-FlgMinVenta = YES AND Almmmatg.DEC__03 > 0 THEN DO:
      f-CanPed = DECIMAL(Datos.Libre_d01:SCREEN-VALUE IN BROWSE {&browse-name}).
      IF f-CanPed < Almmmatg.DEC__03 THEN DO:
          MESSAGE 'Solo puede vender como mínimo' Almmmatg.DEC__03
              VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO Datos.Libre_d01.
          RETURN "ADM-ERROR".
      END.
  END.

  /* PRECIO UNITARIO */
  IF DECIMAL(almmmatg.PreAlt[4]) = 0 THEN DO:
       MESSAGE "Precio debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO Datos.Libre_d01.
       RETURN "ADM-ERROR".
  END.
    
  IF datos.undbas:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
      MESSAGE "Codigo de Unidad no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.

  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
      AND  Almmmatg.codmat = Datos.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE "Codigo de articulo no existe" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.

  /* RHC 26.09.05 MARGEN DE UTILIDAD 
  DEF VAR X-COSTO AS DEC NO-UNDO.
  DEF VAR X-MARGEN AS DEC NO-UNDO.
  DEF VAR X-LIMITE AS DE NO-UNDO.

  X-COSTO = 0.
  X-MARGEN = 0.
  IF s-CodMon = 1 THEN DO:
      IF Almmmatg.MonVta = 1 THEN 
          ASSIGN X-COSTO = (Almmmatg.Ctotot).
      ELSE
          ASSIGN X-COSTO = (Almmmatg.Ctotot) * s-Tpocmb .
  END.        
  IF s-CodMon = 2 THEN DO:
      IF Almmmatg.MonVta = 2 THEN
          ASSIGN X-COSTO = (Almmmatg.Ctotot).
      ELSE
          ASSIGN X-COSTO = (Almmmatg.Ctotot) / s-Tpocmb .
  END.      
  FIND TabGener WHERE Tabgener.codcia = s-codcia 
      AND Tabgener.clave = 'MML'
      AND Tabgener.codigo = Almmmatg.codfam NO-LOCK NO-ERROR.
  IF AVAILABLE TabGener THEN DO:
      X-MARGEN = DECIMAL(Datos.PreAlt[4]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
      X-MARGEN = ROUND( ((( X-MARGEN / X-COSTO ) - 1 ) * 100 ), 2 ).
      IF Almmmatg.chr__02 = 'P' 
          THEN X-LIMITE = TabGener.Parametro[2].
      ELSE X-LIMITE = TabGener.Parametro[1].
           IF X-MARGEN < X-LIMITE THEN DO:
               MESSAGE 'MARGEN DE UTILIDAD MUY BAJO' SKIP
                   'El margen es de' x-Margen '%, no debe ser menor a' x-Limite '%'
                   VIEW-AS ALERT-BOX WARNING.
               Datos.PreAlt[4]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING( X-COSTO * (1 + X-LIMITE / 100) ).
               RETURN 'ADM-ERROR'.
           END.
  END.    
  */
        
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

