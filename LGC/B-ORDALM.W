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

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VARIABLE C-NroReq    AS CHAR NO-UNDO.
DEFINE VARIABLE C-Telf1 LIKE gn-prov.Telfnos[1]   NO-UNDO.
DEFINE VARIABLE C-Telf2 LIKE gn-prov.Telfnos[2]   NO-UNDO.
DEFINE VARIABLE C-Conta LIKE gn-prov.Contactos[2] NO-UNDO.

/* Shared Variable Definitions ---                                       */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODALM AS CHAR.

DEFINE BUFFER C-COMPRA FOR LG-COCmp.


/* Preprocesadores para condiciones */
&SCOPED-DEFINE CONDICION ( LG-COCmp.CodCia = S-CODCIA AND ~
                           LOOKUP(LG-COCmp.FlgSit,S-SITOC) > 0 AND ~
                           ((LG-COCmp.FchDoc >= DesdeF AND ~
                           LG-COCmp.FchDoc <= HastaF) OR ~
                           (DesdeF = ? AND HastaF = ?)) AND ~
                           LG-COCmp.CodAlm = S-CODALM )

&SCOPED-DEFINE CODIGO LG-COCmp.NroDoc 

/* Preprocesadores para cada campo filtro */
&SCOPED-DEFINE FILTRO1 ( LG-COCmp.NomPro BEGINS FILL-IN-filtro )
&SCOPED-DEFINE FILTRO2 ( INDEX ( LG-COCmp.NomPro , FILL-IN-filtro ) <> 0 )

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES LG-COCmp

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table-2                                    */
&Scoped-define FIELDS-IN-QUERY-br_table-2 LG-COCmp.NroDoc LG-COCmp.FchEnt ~
LG-COCmp.FchVto LG-COCmp.FchAte ~
(IF LG-COCmp.FlgSit = 'T' THEN (LG-COCmp.FchAte - LG-COCmp.FchEnt)   ELSE IF LG-COCmp.FlgSit = 'A' THEN 0   ELSE (LG-COCmp.FchVto - TODAY)  ) @ LG-COCmp.SerReq ~
ENTRY ( LOOKUP (LG-COCmp.FlgSit,'A,P,T,V,G') ,'Anulado,Pendiente,Aten.Total,Vencidas, ') @ LG-COCmp.Userid-com ~
LG-COCmp.NomPro C-Telf1 @ C-Telf1 C-Telf2 @ C-Telf2 C-Conta @ C-Conta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table-2 
&Scoped-define QUERY-STRING-br_table-2 FOR EACH LG-COCmp WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK ~
    BY LG-COCmp.CodCia ~
       BY LG-COCmp.NroDoc DESCENDING ~
        BY LG-COCmp.FlgSit ~
         BY LG-COCmp.FchEnt DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table-2 OPEN QUERY br_table-2 FOR EACH LG-COCmp WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK ~
    BY LG-COCmp.CodCia ~
       BY LG-COCmp.NroDoc DESCENDING ~
        BY LG-COCmp.FlgSit ~
         BY LG-COCmp.FchEnt DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table-2 LG-COCmp
&Scoped-define FIRST-TABLE-IN-QUERY-br_table-2 LG-COCmp


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS CB-FlgSit FILL-IN-codigo CMB-filtro ~
FILL-IN-filtro DesdeF HastaF br_table-2 
&Scoped-Define DISPLAYED-OBJECTS CB-FlgSit S-SITOC FILL-IN-codigo ~
CMB-filtro FILL-IN-filtro DesdeF HastaF 

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
Nombres que inicien con|y||integral.LG-COCmp.NomPro
Nombres que contengan|y||integral.LG-COCmp.NomPro
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "Nombres que inicien con,Nombres que contengan",
     Keys-Supplied = ':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
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
Numero O/C|y||integral.LG-COCmp.CodCia|yes,integral.LG-COCmp.NroDoc|no
Proveedor|||integral.LG-COCmp.NomPro|yes,integral.LG-COCmp.NroDoc|no
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "Numero O/C,Proveedor",
     Sort-Case = Numero O/C':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/* This SmartObject is a valid SortBy-Target. */
&IF '{&user-supported-links}':U ne '':U &THEN
  &Scoped-define user-supported-links {&user-supported-links},SortBy-Target
&ELSE
  &Scoped-define user-supported-links SortBy-Target
&ENDIF

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE CB-FlgSit AS CHARACTER FORMAT "X(256)":U INITIAL "Pendientes" 
     LABEL "Sit" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Pendientes","Aten.Total","Anulados","Vencidas" 
     DROP-DOWN-LIST
     SIZE 11.57 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE CMB-filtro AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 21.29 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-codigo AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "No.Orden" 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-filtro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.43 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE S-SITOC AS CHARACTER FORMAT "X(256)":U INITIAL "P" 
     LABEL "Sit" 
     VIEW-AS FILL-IN 
     SIZE 3.29 BY .81
     BGCOLOR 15 FGCOLOR 1 FONT 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table-2 FOR 
      LG-COCmp SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table-2 B-table-Win _STRUCTURED
  QUERY br_table-2 NO-LOCK DISPLAY
      LG-COCmp.NroDoc COLUMN-LABEL "No. O/C" FORMAT "999999":U
      LG-COCmp.FchEnt COLUMN-LABEL "Fch.Entrega" FORMAT "99/99/9999":U
      LG-COCmp.FchVto COLUMN-LABEL "F.Vencimiento" FORMAT "99/99/9999":U
      LG-COCmp.FchAte COLUMN-LABEL "F.  Atencion" FORMAT "99/99/9999":U
      (IF LG-COCmp.FlgSit = 'T' THEN (LG-COCmp.FchAte - LG-COCmp.FchEnt) 
 ELSE IF LG-COCmp.FlgSit = 'A' THEN 0 
 ELSE (LG-COCmp.FchVto - TODAY)  ) @ LG-COCmp.SerReq COLUMN-LABEL "Dias" FORMAT "->>>9":U
      ENTRY ( LOOKUP (LG-COCmp.FlgSit,'A,P,T,V,G') ,'Anulado,Pendiente,Aten.Total,Vencidas, ') @ LG-COCmp.Userid-com COLUMN-LABEL "Status" FORMAT "X(10)":U
      LG-COCmp.NomPro FORMAT "X(40)":U
      C-Telf1 @ C-Telf1 COLUMN-LABEL "Telefono 1" FORMAT "X(10)":U
      C-Telf2 @ C-Telf2 COLUMN-LABEL "Telefono 2" FORMAT "X(10)":U
      C-Conta @ C-Conta COLUMN-LABEL "Contacto" FORMAT "X(20)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 80 BY 5.92
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CB-FlgSit AT ROW 1.27 COL 7 COLON-ALIGNED
     S-SITOC AT ROW 1.27 COL 7 COLON-ALIGNED
     FILL-IN-codigo AT ROW 1.27 COL 27.29 COLON-ALIGNED
     CMB-filtro AT ROW 1.27 COL 36.43 NO-LABEL
     FILL-IN-filtro AT ROW 1.27 COL 57.72 NO-LABEL
     DesdeF AT ROW 2.35 COL 7 COLON-ALIGNED WIDGET-ID 2
     HastaF AT ROW 2.35 COL 27.29 COLON-ALIGNED WIDGET-ID 4
     br_table-2 AT ROW 3.69 COL 4
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
         HEIGHT             = 9.12
         WIDTH              = 86.
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
/* BROWSE-TAB br_table-2 HastaF F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table-2:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 3.

/* SETTINGS FOR COMBO-BOX CMB-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN S-SITOC IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       S-SITOC:HIDDEN IN FRAME F-Main           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table-2
/* Query rebuild information for BROWSE br_table-2
     _TblList          = "integral.LG-COCmp"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE"
     _OrdList          = "integral.LG-COCmp.CodCia|yes,integral.LG-COCmp.NroDoc|no,integral.LG-COCmp.FlgSit|yes,integral.LG-COCmp.FchEnt|no"
     _Where[1]         = "{&CONDICION}"
     _FldNameList[1]   > integral.LG-COCmp.NroDoc
"LG-COCmp.NroDoc" "No. O/C" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.LG-COCmp.FchEnt
"LG-COCmp.FchEnt" "Fch.Entrega" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.LG-COCmp.FchVto
"LG-COCmp.FchVto" "F.Vencimiento" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.LG-COCmp.FchAte
"LG-COCmp.FchAte" "F.  Atencion" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"(IF LG-COCmp.FlgSit = 'T' THEN (LG-COCmp.FchAte - LG-COCmp.FchEnt) 
 ELSE IF LG-COCmp.FlgSit = 'A' THEN 0 
 ELSE (LG-COCmp.FchVto - TODAY)  ) @ LG-COCmp.SerReq" "Dias" "->>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"ENTRY ( LOOKUP (LG-COCmp.FlgSit,'A,P,T,V,G') ,'Anulado,Pendiente,Aten.Total,Vencidas, ') @ LG-COCmp.Userid-com" "Status" "X(10)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = integral.LG-COCmp.NomPro
     _FldNameList[8]   > "_<CALC>"
"C-Telf1 @ C-Telf1" "Telefono 1" "X(10)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"C-Telf2 @ C-Telf2" "Telefono 2" "X(10)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"C-Conta @ C-Conta" "Contacto" "X(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table-2
&Scoped-define SELF-NAME br_table-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table-2 B-table-Win
ON ROW-ENTRY OF br_table-2 IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table-2 B-table-Win
ON ROW-LEAVE OF br_table-2 IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table-2 B-table-Win
ON VALUE-CHANGED OF br_table-2 IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CB-FlgSit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CB-FlgSit B-table-Win
ON VALUE-CHANGED OF CB-FlgSit IN FRAME F-Main /* Sit */
DO:
   ASSIGN CB-FlgSit.
   /*S-SITOC = (ENTRY(LOOKUP(CB-FlgSit,CB-FlgSit:LIST-ITEMS),",P,T,A,V")).*/   
   CASE CB-FlgSit:
       WHEN "Todos" THEN s-sitoc = "G,P,T,A,V".
       WHEN "Pendientes" THEN s-sitoc = "G,P".
       WHEN "Aten.Total" THEN s-sitoc = "T".
       WHEN "Anulados"   THEN s-sitoc = "A".
       WHEN "Vencidos"   THEN s-sitoc = "V".
   END CASE.
   
   RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CMB-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CMB-filtro B-table-Win
ON VALUE-CHANGED OF CMB-filtro IN FRAME F-Main
DO:
    IF CMB-filtro = CMB-filtro:SCREEN-VALUE AND
        FILL-IN-filtro = FILL-IN-filtro:SCREEN-VALUE THEN RETURN.
    ASSIGN
        FILL-IN-filtro
        CMB-filtro.
    IF CMB-filtro = "Todos" THEN RUN set-attribute-list('Key-Name=?').
    ELSE RUN set-attribute-list('Key-Name=' + CMB-filtro).
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeF B-table-Win
ON LEAVE OF DesdeF IN FRAME F-Main /* Desde */
DO:
   ASSIGN DesdeF
       HastaF.
     IF DesdeF = ?  THEN DesdeF = 01/01/1900.
     IF HastaF = ?  THEN HastaF = 12/31/3000.

   RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codigo B-table-Win
ON LEAVE OF FILL-IN-codigo IN FRAME F-Main /* No.Orden */
DO:
    IF INPUT FILL-IN-codigo = 0 THEN RETURN.
    &IF "{&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}" &THEN
        FIND FIRST {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
            {&CONDICION} AND
            ( {&CODIGO} = INPUT FILL-IN-codigo )
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            BELL.
            MESSAGE "Registro no encontrado" VIEW-AS ALERT-BOX ERROR.
            SELF:SCREEN-VALUE = "".
            RETURN.
        END.
        REPOSITION {&BROWSE-NAME} TO ROWID ROWID( {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} ) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE
                "Registro no se encuentra en el filtro actual" SKIP
                "       Deshacer la actual selección ?       "
                VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO TITLE "Pregunta"
                UPDATE answ AS LOGICAL.
            IF answ THEN DO:
                ASSIGN
                    FILL-IN-filtro:SCREEN-VALUE = ""
                    CMB-filtro:SCREEN-VALUE = CMB-filtro:ENTRY(1).
                APPLY "VALUE-CHANGED" TO CMB-filtro.
                RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
                REPOSITION {&BROWSE-NAME} TO ROWID ROWID( {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} ) NO-ERROR.
            END.
        END.
        ASSIGN SELF:SCREEN-VALUE = "".
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-filtro B-table-Win
ON LEAVE OF FILL-IN-filtro IN FRAME F-Main
DO:
    APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaF B-table-Win
ON LEAVE OF HastaF IN FRAME F-Main /* Hasta */
DO:
   ASSIGN HastaF.
   IF HastaF = ?  THEN HastaF = 01/01/3000.

   RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


ON FIND OF LG-COCmp
DO:
    ASSIGN C-Telf1 = ""
           C-Telf2 = ""
           C-Conta = "".
    FIND gn-prov WHERE
         gn-prov.CodCia = PV-CODCIA AND
         gn-prov.CodPro = LG-COCmp.CodPro NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN 
       ASSIGN C-Telf1 = gn-prov.Telfnos[1]
              C-Telf2 = gn-prov.Telfnos[2]
              C-Conta = gn-prov.Contactos[2].
END.
/* ***************************  Main Block  *************************** */
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR key-value AS CHAR NO-UNDO.

  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'Nombres que inicien con':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro1} )
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Numero O/C':U THEN DO:
           &Scope SORTBY-PHRASE BY LG-COCmp.CodCia BY LG-COCmp.NroDoc DESCENDING
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Proveedor':U THEN DO:
           &Scope SORTBY-PHRASE BY LG-COCmp.NomPro BY LG-COCmp.NroDoc DESCENDING
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* Nombres que inicien con */
    WHEN 'Nombres que contengan':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro2} )
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Numero O/C':U THEN DO:
           &Scope SORTBY-PHRASE BY LG-COCmp.CodCia BY LG-COCmp.NroDoc DESCENDING
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Proveedor':U THEN DO:
           &Scope SORTBY-PHRASE BY LG-COCmp.NomPro BY LG-COCmp.NroDoc DESCENDING
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* Nombres que contengan */
    OTHERWISE DO:
       &Scope KEY-PHRASE TRUE
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Numero O/C':U THEN DO:
           &Scope SORTBY-PHRASE BY LG-COCmp.CodCia BY LG-COCmp.NroDoc DESCENDING
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Proveedor':U THEN DO:
           &Scope SORTBY-PHRASE BY LG-COCmp.NomPro BY LG-COCmp.NroDoc DESCENDING
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* OTHERWISE...*/
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel B-table-Win 
PROCEDURE Excel :
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE key-value               AS CHAR NO-UNDO.
DEFINE VARIABLE iOpcion                 AS INT   NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN CB-FlgSit.
   CASE CB-FlgSit:
       WHEN "Todos" THEN s-sitoc = "G,P,T,A,V".
       WHEN "Pendientes" THEN s-sitoc = "G,P".
       WHEN "Aten.Total" THEN s-sitoc = "T".
       WHEN "Anulados"   THEN s-sitoc = "A".
       WHEN "Vencidos"   THEN s-sitoc = "V".
   END CASE.   
END.
SESSION:SET-WAIT-STATE('GENERAL').

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "ORDEN".
cRange = "B" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "F.ENTREGA".
cRange = "C" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "F.VENCIMIENTO".
cRange = "D" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "F.ATENCION".
cRange = "E" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "DIAS".
cRange = "F" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "STATUS".
cRange = "G" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "PROVEEDOR".
cRange = "H" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "TELF 1".
cRange = "I" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "TELF 2".
cRange = "J" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "CONTACTO".
cRange = "K" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "CODIGO".
cRange = "L" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "DESCRIPCION".
cRange = "M" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "MARCA".
cRange = "N" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "UNIDAD".
cRange = "O" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "SOLICITADA".
cRange = "P" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "ATENDIDA".
cRange = "Q" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "POR ATENDER".

  
/*Revisando Filtro*/
/* Look up the current key-value. */
RUN get-attribute ('Key-Value':U).
key-value = RETURN-VALUE.

/* Find the current record using the current Key-Name. */
RUN get-attribute ('Key-Name':U).
CASE RETURN-VALUE:
    WHEN 'Nombres que inicien con':U THEN iOpcion = 2.
    WHEN 'Nombres que contengan':U THEN iOpcion = 3.
    OTHERWISE DO:
       iOpcion = 1.
    END. /* OTHERWISE...*/
  END CASE.

FOR EACH Lg-cocmp NO-LOCK WHERE {&CONDICION},
    EACH Lg-docmp OF Lg-cocmp NO-LOCK,
    FIRST Almmmatg OF Lg-docmp NO-LOCK:
    IF Cb-FlgSit = 'Pendientes' THEN DO:
        IF CanPed <= CanAte THEN NEXT.
    END.

    IF FILL-IN-filtro <> "" THEN DO:
        CASE iOpcion:
            WHEN 2 THEN IF NOT LG-COCmp.NomPro BEGINS FILL-IN-filtro THEN NEXT.
            WHEN 3 THEN IF INDEX ( LG-COCmp.NomPro , FILL-IN-filtro ) = 0 THEN NEXT.
        END CASE.                
    END.

    t-column = t-column + 1.                                                                                                                               
    cColumn = STRING(t-Column).                                                                                        
    cRange = "A" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + STRING(lg-cocmp.nrodoc, '999999').
    cRange = "B" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = fchent.
    cRange = "C" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = fchvto.
    cRange = "D" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = fchate.
    cRange = "E" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = (IF LG-COCmp.FlgSit = 'T' 
                                       THEN (LG-COCmp.FchAte - LG-COCmp.FchEnt) 
                                        ELSE IF LG-COCmp.FlgSit = 'A' 
                                            THEN 0 
                                            ELSE (LG-COCmp.FchVto - TODAY)  ).
    cRange = "F" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = ENTRY ( LOOKUP (LG-COCmp.FlgSit,'A,P,T,V,G') ,'Anulado,Pendiente,Aten.Total,Vencidas, ').
    cRange = "G" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = nompro.
    cRange = "H" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + c-Telf1.
    cRange = "I" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = "'" + c-Telf2.
    cRange = "J" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = c-Conta.
    cRange = "K" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = "'" + Lg-docmp.codmat.
    cRange = "L" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = desmat.
    cRange = "M" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = desmar.
    cRange = "N" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = Lg-docmp.undcmp.
    cRange = "O" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = canped.
    cRange = "P" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = canate.
    cRange = "Q" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = canped - canate.
END.
HIDE FRAME F-Proceso NO-PAUSE.

/* launch Excel so it is visible to the user */
SESSION:SET-WAIT-STATE('').

chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
    RUN get-attribute ('Keys-Accepted').

    IF RETURN-VALUE <> "" AND RETURN-VALUE <> ? THEN
        ASSIGN
            CMB-filtro:LIST-ITEMS IN FRAME {&FRAME-NAME} =
            CMB-filtro:LIST-ITEMS + "," + RETURN-VALUE
            CMB-filtro:SCREEN-VALUE =  ENTRY(2,CMB-filtro:LIST-ITEMS)
            CMB-filtro =  ENTRY(2,CMB-filtro:LIST-ITEMS)
            /*DesdeF = 01/01/1900
            HastaF = 12/31/3000*/   .
            
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    /* Code placed here will execute AFTER standard behavior.    */
    
    ASSIGN
        output-var-1 = ?
        output-var-2 = ?
        output-var-3 = ?.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "LG-COCmp"}

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

