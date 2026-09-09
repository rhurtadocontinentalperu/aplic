&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
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
DEFINE VAR F-FACTOR   AS INTEGER INIT 1.
DEFINE VAR F-MrgUti   AS DECI INIT 0.
DEFINE VAR F-Prevta   AS DECI INIT 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES Almmmatg
&Scoped-define FIRST-EXTERNAL-TABLE Almmmatg


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almmmatg.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almmmatc almtabla

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Almmmatc.CodCom almtabla.Nombre ~
Almmmatc.Prevta[1] Almmmatc.FchIng[1] Almmmatg.MrgUti-A Almmmatc.MrgUti-A ~
Almmmatg.UndA Almmmatc.Prevta[2] Almmmatc.FchIng[2] Almmmatg.MrgUti-B ~
Almmmatc.MrgUti-B Almmmatg.UndB Almmmatc.Prevta[3] Almmmatc.FchIng[3] ~
Almmmatg.MrgUti-C Almmmatc.MrgUti-C Almmmatg.UndC 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table Almmmatc.CodCom ~
Almmmatc.Prevta[1] Almmmatc.FchIng[1] Almmmatc.Prevta[2] Almmmatc.FchIng[2] ~
Almmmatc.Prevta[3] Almmmatc.FchIng[3] 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}CodCom ~{&FP2}CodCom ~{&FP3}~
 ~{&FP1}Prevta[1] ~{&FP2}Prevta[1] ~{&FP3}~
 ~{&FP1}FchIng[1] ~{&FP2}FchIng[1] ~{&FP3}~
 ~{&FP1}Prevta[2] ~{&FP2}Prevta[2] ~{&FP3}~
 ~{&FP1}FchIng[2] ~{&FP2}FchIng[2] ~{&FP3}~
 ~{&FP1}Prevta[3] ~{&FP2}Prevta[3] ~{&FP3}~
 ~{&FP1}FchIng[3] ~{&FP2}FchIng[3] ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table Almmmatc
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table Almmmatc
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Almmmatc WHERE Almmmatc.CodCia = Almmmatg.CodCia ~
  AND Almmmatc.codmat = Almmmatg.codmat ~
      AND Almmmatc.CodCia = Almmmatg.CodCia ~
  AND Almmmatc.codmat = Almmmatg.codmat NO-LOCK, ~
      EACH almtabla WHERE almtabla.Tabla = "CO" ~
      AND almtabla.Tabla = "CO" AND almtabla.Codigo = almmmatc.Codcom NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table Almmmatc almtabla
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Almmmatc


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
      Almmmatc, 
      almtabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Almmmatc.CodCom
      almtabla.Nombre FORMAT "x(30)"
      Almmmatc.Prevta[1] COLUMN-LABEL "Precio Venta!A" COLUMN-BGCOLOR 11
      Almmmatc.FchIng[1] COLUMN-LABEL "Fec Ingreso!A" COLUMN-BGCOLOR 11
      Almmmatg.MrgUti-A COLUMN-LABEL "Margen A" COLUMN-BGCOLOR 11
      Almmmatc.MrgUti-A COLUMN-LABEL "Margen A!Competencia" COLUMN-BGCOLOR 11
      Almmmatg.UndA COLUMN-BGCOLOR 11
      Almmmatc.Prevta[2] COLUMN-LABEL "Precio Venta!B" COLUMN-BGCOLOR 13
      Almmmatc.FchIng[2] COLUMN-LABEL "Fec Ingreso!B" COLUMN-BGCOLOR 13
      Almmmatg.MrgUti-B COLUMN-LABEL "Margen B" COLUMN-BGCOLOR 13
      Almmmatc.MrgUti-B COLUMN-LABEL "Margen B!Competencia" COLUMN-BGCOLOR 13
      Almmmatg.UndB COLUMN-BGCOLOR 13
      Almmmatc.Prevta[3] COLUMN-LABEL "Precio Venta!C" COLUMN-BGCOLOR 9
      Almmmatc.FchIng[3] COLUMN-LABEL "Fec Ingreso!C" COLUMN-BGCOLOR 9
      Almmmatg.MrgUti-C COLUMN-BGCOLOR 9
      Almmmatc.MrgUti-C COLUMN-LABEL "Margen C!Competencia" COLUMN-BGCOLOR 9
      Almmmatg.UndC COLUMN-BGCOLOR 9
  ENABLE
      Almmmatc.CodCom
      Almmmatc.Prevta[1]
      Almmmatc.FchIng[1]
      Almmmatc.Prevta[2]
      Almmmatc.FchIng[2]
      Almmmatc.Prevta[3]
      Almmmatc.FchIng[3]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 71.86 BY 6.73
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: integral.Almmmatg
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 6.77
         WIDTH              = 71.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.Almmmatc WHERE integral.Almmmatg ...,integral.almtabla WHERE integral.Almmmatc ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _JoinCode[1]      = "integral.Almmmatc.CodCia = integral.Almmmatg.CodCia
  AND integral.Almmmatc.codmat = integral.Almmmatg.codmat"
     _Where[1]         = "integral.Almmmatc.CodCia = integral.Almmmatg.CodCia
  AND integral.Almmmatc.codmat = integral.Almmmatg.codmat"
     _JoinCode[2]      = "integral.almtabla.Tabla = ""CO"""
     _Where[2]         = "integral.almtabla.Tabla = ""CO"" AND integral.almtabla.Codigo = integral.almmmatc.Codcom"
     _FldNameList[1]   > integral.Almmmatc.CodCom
"Almmmatc.CodCom" ? ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[2]   > integral.almtabla.Nombre
"almtabla.Nombre" ? "x(30)" "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > integral.Almmmatc.Prevta[1]
"Almmmatc.Prevta[1]" "Precio Venta!A" ? "decimal" 11 ? ? ? ? ? yes ?
     _FldNameList[4]   > integral.Almmmatc.FchIng[1]
"Almmmatc.FchIng[1]" "Fec Ingreso!A" ? "date" 11 ? ? ? ? ? yes ?
     _FldNameList[5]   > integral.Almmmatg.MrgUti-A
"Almmmatg.MrgUti-A" "Margen A" ? "decimal" 11 ? ? ? ? ? no ?
     _FldNameList[6]   > integral.Almmmatc.MrgUti-A
"Almmmatc.MrgUti-A" "Margen A!Competencia" ? "decimal" 11 ? ? ? ? ? no ?
     _FldNameList[7]   > integral.Almmmatg.UndA
"Almmmatg.UndA" ? ? "character" 11 ? ? ? ? ? no ?
     _FldNameList[8]   > integral.Almmmatc.Prevta[2]
"Almmmatc.Prevta[2]" "Precio Venta!B" ? "decimal" 13 ? ? ? ? ? yes ?
     _FldNameList[9]   > integral.Almmmatc.FchIng[2]
"Almmmatc.FchIng[2]" "Fec Ingreso!B" ? "date" 13 ? ? ? ? ? yes ?
     _FldNameList[10]   > integral.Almmmatg.MrgUti-B
"Almmmatg.MrgUti-B" "Margen B" ? "decimal" 13 ? ? ? ? ? no ?
     _FldNameList[11]   > integral.Almmmatc.MrgUti-B
"Almmmatc.MrgUti-B" "Margen B!Competencia" ? "decimal" 13 ? ? ? ? ? no ?
     _FldNameList[12]   > integral.Almmmatg.UndB
"Almmmatg.UndB" ? ? "character" 13 ? ? ? ? ? no ?
     _FldNameList[13]   > integral.Almmmatc.Prevta[3]
"Almmmatc.Prevta[3]" "Precio Venta!C" ? "decimal" 9 ? ? ? ? ? yes ?
     _FldNameList[14]   > integral.Almmmatc.FchIng[3]
"Almmmatc.FchIng[3]" "Fec Ingreso!C" ? "date" 9 ? ? ? ? ? yes ?
     _FldNameList[15]   > integral.Almmmatg.MrgUti-C
"Almmmatg.MrgUti-C" ? ? "decimal" 9 ? ? ? ? ? no ?
     _FldNameList[16]   > integral.Almmmatc.MrgUti-C
"Almmmatc.MrgUti-C" "Margen C!Competencia" ? "decimal" 9 ? ? ? ? ? no ?
     _FldNameList[17]   > integral.Almmmatg.UndC
"Almmmatg.UndC" ? ? "character" 9 ? ? ? ? ? no ?
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
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


&Scoped-define SELF-NAME Almmmatc.Prevta[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatc.Prevta[1] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF Almmmatc.Prevta[1] IN BROWSE br_table /* Precio Venta!A */
DO: 
    ASSIGN F-Prevta = DECI(SELF:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) .    
    F-FACTOR = 1.
    /****   Busca el Factor de conversion   ****/
    IF Almmmatg.UndA <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                       AND  Almtconv.Codalter = Almmmatg.UndA
                      NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
           MESSAGE "Codigo de unidad no exixte" VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.
        END.
        F-FACTOR = Almtconv.Equival.
        F-MrgUti = ROUND(((((F-PreVta / F-FACTOR)  / Almmmatg.Ctotot) - 1) * 100), 6).
        IF F-prevta = 0 THEN F-MrgUti = 0 .
    END.
    DISPLAY F-MrgUti @ Almmmatc.MrgUti-A 
            WITH BROWSE {&BROWSE-NAME}.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatc.Prevta[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatc.Prevta[2] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF Almmmatc.Prevta[2] IN BROWSE br_table /* Precio Venta!B */
DO:
    ASSIGN F-Prevta = DECI(SELF:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) .    
    F-FACTOR = 1.
    /****   Busca el Factor de conversion   ****/
    IF Almmmatg.UndB <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                       AND  Almtconv.Codalter = Almmmatg.UndB
                      NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
           MESSAGE "Codigo de unidad no exixte" VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.
        END.
        F-FACTOR = Almtconv.Equival.
        F-MrgUti = ROUND(((((F-PreVta / F-FACTOR)  / Almmmatg.Ctotot) - 1) * 100), 6).
        IF F-prevta = 0 THEN F-MrgUti = 0 .
    END.
    DISPLAY F-MrgUti @ Almmmatc.MrgUti-B
            WITH BROWSE {&BROWSE-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatc.Prevta[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatc.Prevta[3] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF Almmmatc.Prevta[3] IN BROWSE br_table /* Precio Venta!C */
DO:
    ASSIGN F-Prevta = DECI(SELF:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) .    
    F-FACTOR = 1.
    /****   Busca el Factor de conversion   ****/
    IF Almmmatg.UndC <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                       AND  Almtconv.Codalter = Almmmatg.UndC
                      NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
           MESSAGE "Codigo de unidad no exixte" VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.
        END.
        F-FACTOR = Almtconv.Equival.
        F-MrgUti = ROUND(((((F-PreVta / F-FACTOR)  / Almmmatg.Ctotot) - 1) * 100), 6).
        IF F-prevta = 0 THEN F-MrgUti = 0 .
    END.
    DISPLAY F-MrgUti @ Almmmatc.MrgUti-C
            WITH BROWSE {&BROWSE-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


ON "RETURN":U OF Almmmatc.codcom, Almmmatc.Prevta[1], Almmmatc.FchIng[1], Almmmatc.Prevta[2], Almmmatc.FchIng[2], Almmmatc.Prevta[3], Almmmatc.FchIng[3], Almmmatc.MrgUti-C 
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "Almmmatg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almmmatg"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    IF AVAIL Almmmatg THEN DO:
        ASSIGN
            Almmmatc.CodCia = Almmmatg.CodCia 
            Almmmatc.codmat = Almmmatg.codmat.
          ASSIGN    
            Almmmatc.FchIng[1] = DATE(Almmmatc.FchIng[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
            Almmmatc.FchIng[2] = DATE(Almmmatc.FchIng[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
            Almmmatc.FchIng[3] = DATE(Almmmatc.FchIng[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
            Almmmatc.MrgUti-A  = DECI(Almmmatc.MrgUti-A:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
            Almmmatc.MrgUti-B  = DECI(Almmmatc.MrgUti-B:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
            Almmmatc.MrgUti-C  = DECI(Almmmatc.MrgUti-C:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
            Almmmatc.Prevta[1] = DECI(Almmmatc.Prevta[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
            Almmmatc.Prevta[2] = DECI(Almmmatc.Prevta[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
            Almmmatc.Prevta[3] = DECI(Almmmatc.Prevta[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
    END.

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
        WHEN "Codcom"  THEN ASSIGN input-var-1 = "CO".
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "Almmmatc"}
  {src/adm/template/snd-list.i "almtabla"}

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
  Notes:  EN CASO DE ERROR RETORNAR : RETURN "ADM-ERROR"
------------------------------------------------------------------------------*/
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Consistenciar la modificacion de la fila
  Parameters:  Retornar "ADM-ERROR" en caso de bloquear la modificacion
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE Almmmatc THEN RETURN "ADM-ERROR".

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


