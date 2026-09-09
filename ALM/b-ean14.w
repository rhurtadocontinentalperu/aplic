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

DEF SHARED VAR s-codcia AS INT.

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
&Scoped-define INTERNAL-TABLES Almmmat1

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Almmmat1.codmat Almmmatg.UndStk ~
Almmmatg.TpoArt Almmmat1.Barras[1] Almmmat1.Equival[1] Almmmat1.Barras[2] ~
Almmmat1.Equival[2] Almmmat1.Barras[3] Almmmat1.Equival[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table Almmmat1.codmat ~
Almmmat1.Barras[1] Almmmat1.Equival[1] Almmmat1.Barras[2] ~
Almmmat1.Equival[2] Almmmat1.Barras[3] Almmmat1.Equival[3] 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}codmat ~{&FP2}codmat ~{&FP3}~
 ~{&FP1}Barras[1] ~{&FP2}Barras[1] ~{&FP3}~
 ~{&FP1}Equival[1] ~{&FP2}Equival[1] ~{&FP3}~
 ~{&FP1}Barras[2] ~{&FP2}Barras[2] ~{&FP3}~
 ~{&FP1}Equival[2] ~{&FP2}Equival[2] ~{&FP3}~
 ~{&FP1}Barras[3] ~{&FP2}Barras[3] ~{&FP3}~
 ~{&FP1}Equival[3] ~{&FP2}Equival[3] ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table Almmmat1
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table Almmmat1
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Almmmat1 WHERE ~{&KEY-PHRASE} ~
      AND Almmmat1.CodCia = s-codcia NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table Almmmat1
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Almmmat1


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
      Almmmat1 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Almmmat1.codmat COLUMN-LABEL "Codigo"
      Almmmatg.UndStk COLUMN-LABEL "Unidad"
      Almmmatg.TpoArt COLUMN-LABEL "Flag"
      Almmmat1.Barras[1] COLUMN-LABEL "EAN 14 - 1" FORMAT "X(14)"
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 1
      Almmmat1.Equival[1] COLUMN-LABEL "Equival" FORMAT ">>>9.9999"
      Almmmat1.Barras[2] COLUMN-LABEL "EAN 14 - 2" FORMAT "X(14)"
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 5
      Almmmat1.Equival[2] COLUMN-LABEL "Equival" FORMAT ">>>9.9999"
      Almmmat1.Barras[3] COLUMN-LABEL "EAN 14 - 3" FORMAT "X(14)"
            COLUMN-FGCOLOR 14 COLUMN-BGCOLOR 7
      Almmmat1.Equival[3] COLUMN-LABEL "Equival" FORMAT ">>>9.9999"
  ENABLE
      Almmmat1.codmat
      Almmmat1.Barras[1]
      Almmmat1.Equival[1]
      Almmmat1.Barras[2]
      Almmmat1.Equival[2]
      Almmmat1.Barras[3]
      Almmmat1.Equival[3]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 98 BY 12.69
         FONT 2.


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
   External Tables: INTEGRAL.Almmmatg
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
         HEIGHT             = 13.04
         WIDTH              = 99.86.
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

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main = 4.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.Almmmat1 OF INTEGRAL.Almmmatg"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "INTEGRAL.Almmmat1.CodCia = s-codcia"
     _FldNameList[1]   > INTEGRAL.Almmmat1.codmat
"Almmmat1.codmat" "Codigo" ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[2]   > INTEGRAL.Almmmatg.UndStk
"Almmmatg.UndStk" "Unidad" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > INTEGRAL.Almmmatg.TpoArt
"Almmmatg.TpoArt" "Flag" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   > INTEGRAL.Almmmat1.Barras[1]
"Almmmat1.Barras[1]" "EAN 14 - 1" "X(14)" "character" 1 15 ? ? ? ? yes ?
     _FldNameList[5]   > INTEGRAL.Almmmat1.Equival[1]
"Almmmat1.Equival[1]" "Equival" ">>>9.9999" "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[6]   > INTEGRAL.Almmmat1.Barras[2]
"Almmmat1.Barras[2]" "EAN 14 - 2" "X(14)" "character" 5 15 ? ? ? ? yes ?
     _FldNameList[7]   > INTEGRAL.Almmmat1.Equival[2]
"Almmmat1.Equival[2]" "Equival" ">>>9.9999" "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[8]   > INTEGRAL.Almmmat1.Barras[3]
"Almmmat1.Barras[3]" "EAN 14 - 3" "X(14)" "character" 7 14 ? ? ? ? yes ?
     _FldNameList[9]   > INTEGRAL.Almmmat1.Equival[3]
"Almmmat1.Equival[3]" "Equival" ">>>9.9999" "decimal" ? ? ? ? ? ? yes ?
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

{src/adm-vm/method/vmbrowser.i}
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


&Scoped-define SELF-NAME Almmmat1.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmat1.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF Almmmat1.codmat IN BROWSE br_table /* Codigo */
DO:
  ASSIGN
    SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE), '999999') 
    NO-ERROR.
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exportar B-table-Win 
PROCEDURE Exportar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Archivo AS CHAR INIT 'Barras14.txt' NO-UNDO.
  DEF VAR x-Rpta AS LOG NO-UNDO.
  
  SYSTEM-DIALOG GET-FILE x-Archivo 
    FILTERS 'Texto' '*.txt'
    INITIAL-FILTER 1 
    ASK-OVERWRITE CREATE-TEST-FILE 
    DEFAULT-EXTENSION 'txt' 
    RETURN-TO-START-DIR SAVE-AS 
    TITLE "Exportar a texto" 
    USE-FILENAME
    UPDATE x-Rpta.
  IF x-Rpta = NO THEN RETURN.
  
  OUTPUT TO VALUE(x-Archivo).
  DEF VAR x-linea AS CHAR FORMAT 'x(109)'.
  FOR EACH Almmmat1 NO-LOCK WHERE codcia = 1 AND Barras[1]  <> '',
        FIRST Almmmatg OF Almmmat1 NO-LOCK:
    x-Linea = STRING(Almmmat1.codmat,'x(7)') +
            STRING(Barras[1],'x(14)') +            
            STRING(undbas,'x(8)') +
            STRING(unda,'x(8)') +
            STRING(undb,'x(6)') +
            STRING(undc,'x(4)') +
            STRING(desmat,'x(50)') +
            STRING(desmar,'x(12)').
    display x-linea
            with stream-io no-box no-labels width 110.
  END.
  OUTPUT CLOSE.
  MESSAGE 'Exportacion terminada'.
    
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
  ASSIGN
    Almmmat1.CodCia = s-codcia.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime B-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DEF VAR x_Canti AS INT NO-UNDO.
  DEF VAR x_Rpta  AS LOG NO-UNDO.
  
  SYSTEM-DIALOG PRINTER-SETUP NUM-COPIES x_Canti UPDATE x_Rpta.
  IF x_Rpta = NO THEN RETURN.
  OUTPUT TO PRINTER.  
  PUT '^XA^LH000,012'.      /* Inicio de formato */
  PUT '^FO155,00'.          /* Coordenadas de origen campo1  DESPRO1 */
  PUT '^A0R,25,15'.
  PUT '^FD' + SUBSTR(Almmmatg.desmat,1,40).
  PUT '^FS'.                /* Fin de Campo1 */
  PUT '^FO130,00'.          /* Coordenadas de origen campo2  DESPRO2 */
  PUT '^A0R,25,15'.
  PUT '^FD' + SUBSTR(Almmmatg.desmat,1,26).
  PUT '^FS'.                /* Fin de Campo2 */
  PUT '^FO55,30'.           /* Coordenadas de origen barras  CODPRO */
  PUT '^BER,80'.            /* Codigo 128 */
  PUT '^FD' + Almmmat1.Barras[1].
  PUT '^FS'.                /* Fin de Campo2 */

  PUT '^LH210,012'.         /* Inicio de formato */
  PUT '^FO155,00'.          /* Coordenadas de origen campo1  DESPRO1 */
  PUT '^A0R,25,15'.
  PUT '^FD' + SUBSTR(Almmmatg.desmat,1,40).
  PUT '^FS'.                /* Fin de Campo1 */
  PUT '^FO130,00'.          /* Coordenadas de origen campo2  DESPRO2 */
  PUT '^A0R,25,15'.
  PUT '^FD' + SUBSTR(Almmmatg.desmat,1,26).
  PUT '^FS'.                /* Fin de Campo2 */
  PUT '^FO55,30'.           /* Coordenadas de origen barras  CODPRO */
  PUT '^BER,80'.            /* Codigo 128 */
  PUT '^FD' + Almmmat1.Barras[1].
  PUT '^FS'.                /* Fin de Campo2 */

  PUT '^LH420,12'.          /* Inicio de formato */
  PUT '^FO155,00'.          /* Coordenadas de origen campo1  DESPRO1 */
  PUT '^A0R,25,15'.
  PUT '^FD' + SUBSTR(Almmmatg.desmat,1,40).
  PUT '^FS'.                /* Fin de Campo1 */
  PUT '^FO130,00'.          /* Coordenadas de origen campo2  DESPRO2 */
  PUT '^A0R,25,15'.
  PUT '^FD' + SUBSTR(Almmmatg.desmat,1,26).
  PUT '^FS'.                /* Fin de Campo2 */
  PUT '^FO55,30'.           /* Coordenadas de origen barras  CODPRO */
  PUT '^BY2'.               /* Define tama¤o codigo barras */
  PUT '^BER,80'.            /* Codigo 128 */
  PUT '^FD' + Almmmat1.Barras[1].
  PUT '^FS'.                /* Fin de Campo2 */

  PUT '^LH630,012'.         /* Inicio de formato */
  PUT '^FO155,00'.          /* Coordenadas de origen campo1  DESPRO1 */
  PUT '^A0R,25,15'.
  PUT '^FD' + SUBSTR(Almmmatg.desmat,1,40).
  PUT '^FS'.                /* Fin de Campo1 */
  PUT '^FO130,00'.          /* Coordenadas de origen campo2  DESPRO2 */
  PUT '^A0R,25,15'.
  PUT '^FD' + SUBSTR(Almmmatg.desmat,1,26).
  PUT '^FS'.                /* Fin de Campo2 */
  PUT '^FO55,30'.           /* Coordenadas de origen barras  CODPRO */
  PUT '^BY2'.               /* Define tama¤o codigo barras */
  PUT '^BER,80'.            /* Codigo 128 */
  PUT '^FD' + Almmmat1.Barras[1].
  PUT '^FS'.                /* Fin de Campo2 */

  PUT '^PQ' + TRIM(STRING(x_canti)).    /*Cantidad a imprimir */
  PUT '^PR' + '2'.                      /*Velocidad de impresion Pulg/seg */
  PUT '^XZ'.                            /* Fin de formato */
  
  OUTPUT CLOSE.
  
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
  {src/adm/template/snd-list.i "Almmmat1"}

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
  DO WITH FRAME {&FRAME-NAME}:
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = Almmmat1.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        MESSAGE 'Código de Material NO registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    IF Almmmat1.Barras[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '' THEN DO:
        MESSAGE 'Ingrese el código de barras' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
  END.
  
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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


