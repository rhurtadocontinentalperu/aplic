&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
DEFINE SHARED VAR s-codcia AS INTEGER.
DEFINE SHARED VAR s-nomcia AS CHAR.
DEFINE VAR s-nomcta AS CHAR NO-UNDO.
DEFINE SHARED VAR x-tipo AS CHAR.
DEF SHARED VAR cb-codcia AS INT.
DEF VAR s-Tabla AS CHAR NO-UNDO.
CASE x-Tipo:
    WHEN "N/C" THEN
        ASSIGN
        s-Tabla = "66".
    WHEN "N/D" THEN
        ASSIGN
        s-Tabla = "67".
END CASE.

/* Parametros de Impresion ---                                       */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "".
GET-KEY-VALUE SECTION "Startup" KEY "Base" VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb\rbccb.prl".

DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Concepto de Notas".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "O".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.


/* Local Variable Definitions ---                                       */
DEF VAR SUBTIT AS CHAR.

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
&Scoped-define INTERNAL-TABLES CcbTabla

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbTabla.Libre_L02 ~
CcbTabla.Reservado CcbTabla.Libre_d01 CcbTabla.Codigo CcbTabla.Nombre ~
CcbTabla.Codcta CcbTabla.Libre_c01 s-nomcta @ s-nomcta CcbTabla.Afecto ~
CcbTabla.Libre_L01 CcbTabla.Libre_c02 CcbTabla.Libre_d02 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table CcbTabla.Libre_L02 ~
CcbTabla.Reservado CcbTabla.Libre_d01 CcbTabla.Codigo CcbTabla.Nombre ~
CcbTabla.Codcta CcbTabla.Libre_c01 CcbTabla.Afecto CcbTabla.Libre_L01 ~
CcbTabla.Libre_c02 CcbTabla.Libre_d02 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table CcbTabla
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table CcbTabla
&Scoped-define QUERY-STRING-br_table FOR EACH CcbTabla WHERE ~{&KEY-PHRASE} ~
      AND CcbTabla.CodCia = s-codcia ~
 AND CcbTabla.Tabla = x-tipo NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbTabla WHERE ~{&KEY-PHRASE} ~
      AND CcbTabla.CodCia = s-codcia ~
 AND CcbTabla.Tabla = x-tipo NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table CcbTabla
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbTabla


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
      CcbTabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbTabla.Libre_L02 COLUMN-LABEL "Estado" FORMAT "Activo/Inactivo":U
            WIDTH 6 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "Yes","No" 
                      DROP-DOWN-LIST 
      CcbTabla.Reservado COLUMN-LABEL "Automatico" FORMAT "yes/no":U
            VIEW-AS TOGGLE-BOX
      CcbTabla.Libre_d01 COLUMN-LABEL "Tipo!Envio" FORMAT "9":U
            WIDTH 7.29 VIEW-AS COMBO-BOX INNER-LINES 3
                      LIST-ITEM-PAIRS "Detallada", 0,
                                      "Resumen",1,
                                      "Resumen por Linea",2
                      DROP-DOWN-LIST 
      CcbTabla.Codigo COLUMN-LABEL " Codigo" FORMAT "x(10)":U
      CcbTabla.Nombre FORMAT "x(50)":U WIDTH 39.72
      CcbTabla.Codcta FORMAT "x(10)":U
      CcbTabla.Libre_c01 COLUMN-LABEL "SUNAT" FORMAT "x(5)":U
      s-nomcta @ s-nomcta COLUMN-LABEL "Descripcion" FORMAT "x(40)":U
            WIDTH 26.86
      CcbTabla.Afecto COLUMN-LABEL "Afecto IGV" FORMAT "Si/No":U
            VIEW-AS TOGGLE-BOX
      CcbTabla.Libre_L01 COLUMN-LABEL "Afecta!Estadisticas!de ventas" FORMAT "Si/No":U
            WIDTH 9.86 VIEW-AS TOGGLE-BOX
      CcbTabla.Libre_c02 COLUMN-LABEL "Afecta!Costo ventas" FORMAT "x(5)":U
            VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "SI","SI",
                                      "NO","NO"
                      DROP-DOWN-LIST 
      CcbTabla.Libre_d02 COLUMN-LABEL "WinToWin" FORMAT "9":U WIDTH 7.86
            VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "No", 0,
                                      "Si", 1
                      DROP-DOWN-LIST 
  ENABLE
      CcbTabla.Libre_L02
      CcbTabla.Reservado
      CcbTabla.Libre_d01
      CcbTabla.Codigo HELP "Codigo de auxiliar"
      CcbTabla.Nombre
      CcbTabla.Codcta
      CcbTabla.Libre_c01
      CcbTabla.Afecto
      CcbTabla.Libre_L01
      CcbTabla.Libre_c02
      CcbTabla.Libre_d02
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 152 BY 19.42
         FONT 4 FIT-LAST-COLUMN.


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
         HEIGHT             = 19.88
         WIDTH              = 153.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

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
     _TblList          = "INTEGRAL.CcbTabla"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "integral.CcbTabla.CodCia = s-codcia
 AND integral.CcbTabla.Tabla = x-tipo"
     _FldNameList[1]   > integral.CcbTabla.Libre_L02
"Libre_L02" "Estado" "Activo/Inactivo" "logical" ? ? ? ? ? ? yes ? no no "6" yes no no "U" "" "" "DROP-DOWN-LIST" "," "Yes,No" ? 5 no 0 no no
     _FldNameList[2]   > INTEGRAL.CcbTabla.Reservado
"Reservado" "Automatico" ? "logical" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[3]   > INTEGRAL.CcbTabla.Libre_d01
"Libre_d01" "Tipo!Envio" "9" "decimal" ? ? ? ? ? ? yes ? no no "7.29" yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "Detallada, 0,Resumen,1,Resumen por Linea,2" 3 no 0 no no
     _FldNameList[4]   > integral.CcbTabla.Codigo
"Codigo" " Codigo" ? "character" ? ? ? ? ? ? yes "Codigo de auxiliar" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > integral.CcbTabla.Nombre
"Nombre" ? "x(50)" "character" ? ? ? ? ? ? yes ? no no "39.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > integral.CcbTabla.Codcta
"Codcta" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.CcbTabla.Libre_c01
"Libre_c01" "SUNAT" "x(5)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"s-nomcta @ s-nomcta" "Descripcion" "x(40)" ? ? ? ? ? ? ? no ? no no "26.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > integral.CcbTabla.Afecto
"Afecto" "Afecto IGV" "Si/No" "logical" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[10]   > integral.CcbTabla.Libre_L01
"Libre_L01" "Afecta!Estadisticas!de ventas" ? "logical" ? ? ? ? ? ? yes ? no no "9.86" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[11]   > INTEGRAL.CcbTabla.Libre_c02
"Libre_c02" "Afecta!Costo ventas" "x(5)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "SI,SI,NO,NO" 5 no 0 no no
     _FldNameList[12]   > INTEGRAL.CcbTabla.Libre_d02
"Libre_d02" "WinToWin" "9" "decimal" ? ? ? ? ? ? yes ? no no "7.86" yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "No, 0,Si, 1" 5 no 0 no no
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


ON FIND OF CcbTabla 
DO:
   FIND pl-tabla WHERE pl-tabla.codcia = 0
       AND pl-tabla.tabla = s-tabla
       AND pl-tabla.codigo = CcbTabla.Libre_c01
       NO-LOCK NO-ERROR.
   IF AVAILABLE pl-tabla THEN s-nomcta = PL-TABLA.Nombre.
   ELSE s-nomcta = ''.
/*    FIND CB-Ctas WHERE CB-Ctas.Codcia = cb-codcia        */
/*        AND CB-Ctas.CodCta = ccbtabla.Codcta             */
/*         NO-LOCK NO-ERROR.                               */
/*    IF AVAILABLE CB-Ctas THEN s-nomcta = CB-CTAS.Nomcta. */
/*    ELSE s-nomcta = ''.                                  */
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
         
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
  ASSIGN CcbTabla.CodCia = s-codcia
         CcbTabla.Tabla  = x-tipo.

  DEF VAR pEvento AS CHAR NO-UNDO.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN pEvento = "CREATE".
  ELSE pEvento = "UPDATE".
  RUN lib/logtabla ('CCBTABLA',
                    STRING(Ccbtabla.codcia,'999') + '|' +   /* CodCia */
                    Ccbtabla.Tabla + '|' +                  /* Tabla */
                    CcbTabla.Codigo + '|' +                 /* Codigo */
                    STRING(CcbTabla.Nombre) + '|' +         /* Nombre */
                    CcbTabla.Codcta + '|' +                 /* CodCta */
                    STRING(CcbTabla.Afecto) + '|' +         /* Afecto a IGV */
                    STRING(CcbTabla.Libre_L02) + '|' +      /* Estado */
                    STRING(CcbTabla.Reservado) + '|' +      /* Automático */
                    STRING(Libre_d01,'9')                   /* Tipo Envío */
                    , pEvento).


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR pEvento AS CHAR NO-UNDO.

  pEvento = "DELETE".
  RUN lib/logtabla ('CCBTABLA',
                    STRING(Ccbtabla.codcia,'999') + '|' +   /* CodCia */
                    Ccbtabla.Tabla + '|' +                  /* Tabla */
                    CcbTabla.Codigo + '|' +                 /* Codigo */
                    STRING(CcbTabla.Nombre) + '|' +         /* Nombre */
                    CcbTabla.Codcta + '|' +                 /* CodCta */
                    STRING(CcbTabla.Afecto) + '|' +         /* Afecto a IGV */
                    STRING(CcbTabla.Libre_L02) + '|' +      /* Estado */
                    STRING(CcbTabla.Reservado) + '|' +      /* Automático */
                    STRING(Libre_d01,'9')                   /* Tipo Envío */
                    , pEvento).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields B-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN CcbTabla.Codigo:READ-ONLY IN BROWSE {&browse-name} = NO.
  ELSE CcbTabla.Codigo:READ-ONLY IN BROWSE {&browse-name} = YES.

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

/*MLR* 09/11/07 ***
    IF X-TIPO = "N/C" THEN
    SUBTIT = "NOTAS DE CREDITO".
    IF X-TIPO = "N/D" THEN
    SUBTIT = "NOTAS DE DEBITO".

    RB-FILTER = "CCBTABLA.CodCia = " + STRING(s-codcia) +
                " AND CCBTABLA.Tabla  = '" + x-tipo + "'".

    RB-OTHER-PARAMETERS = "GsNomCia = " + S-NOMCIA +
                         "~nsubtit = " + subtit. 


    RUN lib\_imprime.r(RB-REPORT-LIBRARY, RB-REPORT-NAME,
        RB-INCLUDE-RECORDS, RB-FILTER, RB-OTHER-PARAMETERS).                            
* ***/

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
        WHEN "Libre_c01" THEN DO:
            CASE x-Tipo:
                WHEN "N/C" THEN
                    ASSIGN
                    input-var-1 = "66"
                    input-var-2 = ""
                    input-var-3 = "".
                WHEN "N/D" THEN
                    ASSIGN
                    input-var-1 = "67"
                    input-var-2 = ""
                    input-var-3 = "".
            END CASE.
        END.
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
  {src/adm/template/snd-list.i "CcbTabla"}

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

DEFINE VAR lTipo AS CHAR.
DEFINE VAR lCodSunat AS CHAR.

lTipo = IF (x-Tipo = 'N/C') THEN "66" ELSE "67". 

IF ccbtabla.libre_c01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} <> '' THEN DO:
    lCodSunat = ccbtabla.libre_c01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    FIND FIRST pl-tabla WHERE pl-tabla.codcia = 0 AND 
                                pl-tabla.tabla = lTipo AND 
                                pl-tabla.codigo = lCodSunat 
                                NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-tabla THEN DO:
        MESSAGE "Codigo SUNAT no existe".
        RETURN "ADM-ERROR".
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

