&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE DATOS NO-UNDO LIKE AlmCatVtaD.
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
DEFINE VARIABLE dCanMat AS DEC.
DEFINE VARIABLE lBTF3     AS LOG INIT NO.

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
Almmmatg.DesMar Almmmatg.UndBas DATOS.Libre_d02 DATOS.NroSec ~
DATOS.Libre_d01 DATOS.Libre_d05 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table DATOS.Libre_d02 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table DATOS
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table DATOS
&Scoped-define QUERY-STRING-br_table FOR EACH DATOS WHERE DATOS.CodCia = AlmCatVtaC.CodCia ~
  AND DATOS.CodDiv = AlmCatVtaC.CodDiv ~
  AND DATOS.NroPag = AlmCatVtaC.NroPag ~
  AND DATOS.CodPro = AlmCatVtaC.CodPro NO-LOCK, ~
      EACH Almmmatg WHERE Almmmatg.CodCia = DATOS.CodCia ~
  AND Almmmatg.codmat = DATOS.codmat NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH DATOS WHERE DATOS.CodCia = AlmCatVtaC.CodCia ~
  AND DATOS.CodDiv = AlmCatVtaC.CodDiv ~
  AND DATOS.NroPag = AlmCatVtaC.NroPag ~
  AND DATOS.CodPro = AlmCatVtaC.CodPro NO-LOCK, ~
      EACH Almmmatg WHERE Almmmatg.CodCia = DATOS.CodCia ~
  AND Almmmatg.codmat = DATOS.codmat NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table DATOS Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table DATOS
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table BUTTON-5 

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
DEFINE BUTTON BUTTON-5 AUTO-END-KEY 
     IMAGE-UP FILE "img/save.bmp":U
     LABEL "Button 5" 
     SIZE 10 BY 2.15.

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
      Almmmatg.DesMat FORMAT "X(60)":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(15)":U
      Almmmatg.UndBas COLUMN-LABEL "Und Bas" FORMAT "X(4)":U
      DATOS.Libre_d02 COLUMN-LABEL "Cantidad" FORMAT "->,>>>,>>9.9999":U
      DATOS.NroSec FORMAT "9999":U WIDTH 8
      DATOS.Libre_d01 FORMAT "->>>,>>>,>>9.99<<<":U
      DATOS.Libre_d05 COLUMN-LABEL "Color" FORMAT ">9":U
  ENABLE
      DATOS.Libre_d02
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 95 BY 13.46
         FONT 4
         TITLE "Detalle Articulos por Pagina".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     BUTTON-5 AT ROW 2.88 COL 97 WIDGET-ID 8
     "GRABAR" VIEW-AS TEXT
          SIZE 9 BY .62 AT ROW 5.35 COL 98.29 WIDGET-ID 10
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
      TABLE: DATOS T "?" NO-UNDO INTEGRAL AlmCatVtaD
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
         HEIGHT             = 13.62
         WIDTH              = 107.14.
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

ASSIGN 
       DATOS.Libre_d01:VISIBLE IN BROWSE br_table = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.DATOS WHERE INTEGRAL.AlmCatVtaC <external> ...,INTEGRAL.Almmmatg WHERE Temp-Tables.DATOS ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _JoinCode[1]      = "Temp-Tables.DATOS.CodCia = AlmCatVtaC.CodCia
  AND Temp-Tables.DATOS.CodDiv = AlmCatVtaC.CodDiv
  AND Temp-Tables.DATOS.NroPag = AlmCatVtaC.NroPag
  AND Temp-Tables.DATOS.CodPro = AlmCatVtaC.CodPro"
     _JoinCode[2]      = "INTEGRAL.Almmmatg.CodCia = Temp-Tables.DATOS.CodCia
  AND INTEGRAL.Almmmatg.codmat = Temp-Tables.DATOS.codmat"
     _FldNameList[1]   > Temp-Tables.DATOS.codmat
"DATOS.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.UndBas
"Almmmatg.UndBas" "Und Bas" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.DATOS.Libre_d02
"DATOS.Libre_d02" "Cantidad" "->,>>>,>>9.9999" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.DATOS.NroSec
"DATOS.NroSec" ? ? "integer" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.DATOS.Libre_d01
"DATOS.Libre_d01" ? ? "decimal" ? ? ? ? ? ? no ? no no ? no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.DATOS.Libre_d05
"DATOS.Libre_d05" "Color" ">9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-DISPLAY OF br_table IN FRAME F-Main /* Detalle Articulos por Pagina */
DO:
    DATOS.lIBRE_D02:BGCOLOR IN BROWSE {&BROWSE-NAME} = INT(datos.libre_d05).    
    DATOS.lIBRE_D02:BGCOLOR IN BROWSE {&BROWSE-NAME} = INT(datos.libre_d05).    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&Scoped-define SELF-NAME DATOS.Libre_d02
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DATOS.Libre_d02 br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF DATOS.Libre_d02 IN BROWSE br_table /* Cantidad */
DO:
    DATOS.NROSEC:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    DATOS.CODMAT:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    ALMMMATG.DESMAT:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    ALMMMATG.DESMAR:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    ALMMMATG.UNDBAS:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.
    DATOS.lIBRE_D01:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.  
    DATOS.lIBRE_D02:BGCOLOR IN BROWSE {&BROWSE-NAME} = 8.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DATOS.Libre_d02 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF DATOS.Libre_d02 IN BROWSE br_table /* Cantidad */
DO:
    IF DEC(Datos.Libre_d02:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <> datos.libre_D03
        THEN DO: 
        datos.libre_d05 = 6.
        DISPLAY 6 @ datos.libre_d05 WITH BROWSE {&BROWSE-name}.
        DATOS.lIBRE_D02:BGCOLOR IN BROWSE {&BROWSE-NAME} = INT(datos.libre_d05).
    END.
    ELSE DO: 
        datos.libre_d05 = ?.
        DISPLAY ? @ datos.libre_d05 WITH BROWSE {&BROWSE-name}.
        DATOS.lIBRE_D02:BGCOLOR IN BROWSE {&BROWSE-NAME} = INT(datos.libre_d05).
    END.
  

    DATOS.NROSEC:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    DATOS.CODMAT:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    ALMMMATG.DESMAT:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    ALMMMATG.DESMAR:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    ALMMMATG.UNDBAS:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
    /*DATOS.Libre_d02:BGCOLOR IN BROWSE {&BROWSE-NAME} = 15.*/
    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 B-table-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO: 
    /*DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR'
        ON STOP UNDO, RETURN 'ADM-ERROR':             */
        RUN Graba-Datos.    
    /*END.    */
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

DO WITH FRAME {&FRAME-NAME}:
    /*Carga Catalogo*/
    FOR EACH almcatvtad WHERE almcatvtad.codcia = s-codcia 
        AND almcatvtad.coddiv = s-coddiv NO-LOCK:
        CREATE DATOS.
        BUFFER-COPY AlmCatVtaD TO DATOS.
        ASSIGN datos.libre_d05 = ?. /*Datos que habian ingresado*/
    END.

    /*Busca Históricos*/
    FOR EACH PEDI2 WHERE PEDI2.codcia = s-codcia
        AND PEDI2.codped = "PET"
        AND PEDI2.nroped = s-nrocot NO-LOCK:
        FIND FIRST datos WHERE datos.codcia = s-codcia
            AND datos.coddiv = s-coddiv
            AND datos.codmat = PEDI2.codmat NO-ERROR.
        IF AVAIL datos THEN DO:
            ASSIGN
                datos.libre_d01 = PEDI2.CanPed     /*Datos en blanco*/
                datos.libre_d02 = PEDI2.Libre_d02
                datos.libre_d03 = PEDI2.CanPed. /*Datos que habian ingresado*/
        END.        
    END.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Datos B-table-Win 
PROCEDURE Graba-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lchoice1 AS LOGICAL NO-UNDO INIT NO.
    DEFINE VARIABLE choice2  AS LOGICAL     NO-UNDO.

    /*Busca Diferencias*/
    FOR EACH datos WHERE datos.codcia = s-codcia
        AND datos.coddiv = s-coddiv NO-LOCK:
        lchoice1 = NO.
        FIND FIRST pedi2 WHERE pedi2.codcia = s-codcia
            AND pedi2.codped = "PET"
            AND pedi2.nroped = s-nrocot
            AND pedi2.codmat = datos.codmat NO-ERROR.
        IF NOT AVAIL pedi2 AND datos.libre_d02 <> 0 THEN DO: 
            MESSAGE "   EXISTE DIFERENCIAS CON EL PRIMER INGRESO   " SKIP
                    "¿DESEA GRABAR LA INFORMACION DE ESTE ARTICULO?"
                    VIEW-AS ALERT-BOX QUESTION  BUTTONS YES-NO
                        TITLE "" UPDATE choice2.
            LEAVE.
        END.
        ELSE IF datos.libre_d02 <> datos.libre_d01 THEN DO: 
            MESSAGE "   EXISTE DIFERENCIAS CON EL PRIMER INGRESO   " SKIP            
                    "¿DESEA GRABAR LA INFORMACION DE ESTE ARTICULO?"
                    VIEW-AS ALERT-BOX QUESTION  BUTTONS YES-NO
                        TITLE "" UPDATE choice2 .
            LEAVE.
        END.   
        ELSE choice2 = YES.
    END.

    IF choice2 THEN DO:
        /*Borra Info*/
        FOR EACH pedi2:
            DELETE pedi2.
        END.
        
        FOR EACH datos WHERE datos.codcia = s-codcia                                                                                                                                          
            AND datos.coddiv = s-coddiv NO-LOCK:                                                                                                                                       
            FIND FIRST pedi2 WHERE pedi2.codcia = s-codcia                                  
                AND pedi2.codped = "PET"                                                    
                AND pedi2.nroped = s-nrocot                                                 
                AND pedi2.codmat = datos.codmat NO-ERROR.                                   
            IF NOT AVAIL pedi2 THEN DO:                                                     
                /*IF datos.libre_d01 <> 0 AND datos.libre_d02 = 0 THEN DO: */ 
                    CREATE PEDI2.                                                                  
                    ASSIGN                                                                                     
                        PEDI2.CodCia = s-codcia                                                                
                        PEDI2.CodDiv = s-coddiv                                                                
                        PEDI2.CodMat = datos.codmat                                                            
                        PEDI2.CodPed = "PET"                                                                   
                        PEDI2.NroPed = s-nrocot                                                                
                        PEDI2.Libre_c01 = STRING(datos.nropag,"9999")                                          
                        PEDI2.Libre_c02 = STRING(datos.nrosec,"9999")                                          
                        PEDI2.Libre_c03 = datos.codpro
                        PEDI2.Libre_d01 = datos.libre_d01
                        PEDI2.CanPed    = datos.libre_d02
                        PEDI2.Libre_d02 = datos.libre_d02.                                          
                /*END.*/
            END. /*if not avail .... */                                                            
            ELSE                                                                                                                                                                                 
                ASSIGN        
                    PEDI2.Libre_d01 = datos.libre_d01
                    PEDI2.Libre_d02 = datos.libre_d02
                    PEDI2.CanPed    = datos.libre_d02 .
        END. /*for each ...*/                                                                                                                                                          
        MESSAGE 'La información fue grabada correctamente'.                                                                                                                            
    END. /*if choice2 .... */                                                                                                                                                          
    ELSE RETURN 'ADM-ERROR'.


 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 


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

