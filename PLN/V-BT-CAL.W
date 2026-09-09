&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

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

DEFINE VARIABLE imprime-rem   AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE imprime-des   AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE imprime-apo   AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE imprime-otr   AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE ok-wait-state AS LOGICAL NO-UNDO.

DEFINE BUFFER b-PL-CALC FOR integral.PL-CALC.

DEFINE STREAM strm-arch-s.
DEFINE STREAM strm-arch-m.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES integral.PL-CALC
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-CALC


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-CALC.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn-check Btn-program Btn-print 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-Btn-print 
       MENU-ITEM m_Remuneraciones LABEL "&Remuneraciones"
              TOGGLE-BOX
       MENU-ITEM m_Descuentos   LABEL "&Descuentos"   
              TOGGLE-BOX
       MENU-ITEM m_Aportes      LABEL "&Aportes"      
              TOGGLE-BOX
       MENU-ITEM m_Otros        LABEL "&Otros"        
              TOGGLE-BOX.


/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-check 
     LABEL "&Verificar Sintaxis" 
     SIZE 14 BY 1.

DEFINE BUTTON Btn-print 
     LABEL "&Imprimir Fórmulas" 
     SIZE 13.86 BY .92
     FONT 4.

DEFINE BUTTON Btn-program 
     LABEL "&Generar Programa" 
     SIZE 14 BY 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn-check AT ROW 1 COL 1
     Btn-program AT ROW 3.23 COL 1
     Btn-print AT ROW 5.27 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.PL-CALC
   Allow: Basic,DB-Fields
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 6.15
         WIDTH              = 18.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       Btn-print:POPUP-MENU IN FRAME F-Main       = MENU POPUP-MENU-Btn-print:HANDLE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Btn-check
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-check V-table-Win
ON CHOOSE OF Btn-check IN FRAME F-Main /* Verificar Sintaxis */
DO:
    FIND FIRST PL-PLAN WHERE PL-PLAN.codpln = PL-CALC.codpln NO-ERROR.
    IF AVAILABLE PL-PLAN THEN DO:
        IF PL-PLAN.tippln = YES THEN RUN _chequea_sintaxis-mes.       
        IF PL-PLAN.tippln = NO  THEN RUN _chequea_sintaxis-sem. 
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-print V-table-Win
ON CHOOSE OF Btn-print IN FRAME F-Main /* Imprimir Fórmulas */
DO:     
    FIND FIRST PL-PLAN WHERE PL-PLAN.codpln = PL-CALC.codpln NO-LOCK NO-ERROR.
    IF AVAILABLE PL-PLAN THEN DO:
        RUN _imprime-formulas.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-program
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-program V-table-Win
ON CHOOSE OF Btn-program IN FRAME F-Main /* Generar Programa */
DO:
    FIND FIRST PL-PLAN WHERE PL-PLAN.codpln = PL-CALC.codpln NO-LOCK NO-ERROR.
    IF AVAILABLE PL-PLAN THEN DO:
        IF PL-PLAN.tippln = YES THEN RUN _genera-programa-mes.       
        IF PL-PLAN.tippln = NO  THEN RUN _genera-programa-sem. 
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Aportes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Aportes V-table-Win
ON VALUE-CHANGED OF MENU-ITEM m_Aportes /* Aportes */
DO:
    IF imprime-apo THEN imprime-apo = FALSE.
    ELSE imprime-apo = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Descuentos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Descuentos V-table-Win
ON VALUE-CHANGED OF MENU-ITEM m_Descuentos /* Descuentos */
DO:
    IF imprime-des THEN imprime-des = FALSE.
    ELSE imprime-des = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Otros
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Otros V-table-Win
ON VALUE-CHANGED OF MENU-ITEM m_Otros /* Otros */
DO:
    IF imprime-otr THEN imprime-otr = FALSE.
    ELSE imprime-otr = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Remuneraciones
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Remuneraciones V-table-Win
ON VALUE-CHANGED OF MENU-ITEM m_Remuneraciones /* Remuneraciones */
DO:
    IF imprime-rem THEN imprime-rem = FALSE.
    ELSE imprime-rem = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "integral.PL-CALC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "integral.PL-CALC"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Interpreta V-table-Win 
PROCEDURE Interpreta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TEXT-PROC AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER TIPO-PROC AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER CODI-PROC AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER DESC-PROC AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER EDITOR-2  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER ERROR-2   AS LOGICAL   NO-UNDO.
    DEFINE OUTPUT PARAMETER ERROR-MSG AS CHARACTER NO-UNDO.

    DEFINE VARIABLE ERROR-NUM AS INTEGER   NO-UNDO.
    DEFINE VARIABLE ERROR-POS AS INTEGER   NO-UNDO.


    DEFINE VARIABLE LIN-FIN    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE PRE-ASG    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE CHR-IN     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE NUM-VAR    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE SEL-VAR    AS CHARACTER EXTENT 3 NO-UNDO.
    DEFINE VARIABLE WRD-ASSIGN AS CHARACTER NO-UNDO.
    DEFINE VARIABLE Tipo       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i          AS INTEGER   NO-UNDO.
    DEFINE VARIABLE y          AS INTEGER   NO-UNDO.    
    DEFINE VARIABLE LEN-TEXT   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE TEMP-FILE  AS CHARACTER NO-UNDO.

    PRE-ASG = CHR(47) + "*--------------------------------------------------------" + CHR(10).
    PRE-ASG = PRE-ASG + STRING(CODI-PROC) + " " + DESC-PROC + CHR(10).
    PRE-ASG = PRE-ASG + "--------------------------------------------------------*" + CHR(47) + CHR(10).     

    IF TIPO-PROC = "PROCEDURE"
    THEN PRE-ASG = PRE-ASG + "PROCEDURE P-" + STRING(CODI-PROC) + CHR(10) + CHR(10).
    
    ASSIGN Tipo      = 0
           Editor-2  = ""
           ERROR-NUM = 0
           LEN-TEXT  = LENGTH(Text-PROC)
           CHR-IN    = "".
           LIN-FIN   = "".
    lazo:       
    DO i = 1 TO LEN-TEXT:
        CHR-IN = SUBSTR(Text-PROC, i, 1).
        /* ************ inicio de macros ************** */
        
        IF tipo = 0 
        THEN
            CASE CHR-IN:
                WHEN "^"       THEN /* Conceptos */
                    DO:
                        ASSIGN tipo  = 1
                               WRD-ASSIGN = "".
                        next lazo.
                    END.
                WHEN "$"        THEN /* Conceptos Acumulados */
                    DO:
                        ASSIGN tipo  = 2
                               WRD-ASSIGN = "".
                        next lazo.
                    END.
                WHEN "@"        THEN /* Funciones */
                    DO:
                        ASSIGN tipo  = 3
                               WRD-ASSIGN = "".
                        next lazo.
                    END.
            END CASE.

        /* ************ fin de macros ************** */
        IF tipo > 0 AND ( INDEX( " .=*+/><" + CHR(10), CHR-IN ) > 0  OR
            i = LEN-TEXT )
        THEN DO:
            IF i = LEN-TEXT  AND  INDEX( " .=*+/><" + CHR(10), CHR-IN ) = 0
            THEN WRD-ASSIGN = WRD-ASSIGN + CHR-IN.
            
            /* Verificando que el concepto sea numerico */

            DO y = 1 TO LENGTH( WRD-ASSIGN ):
                IF INDEX( "0123456789-" , SUBSTR( WRD-ASSIGN , y , 1)) = 0
                THEN ASSIGN ERROR-NUM = 1
                            ERROR-MSG = "Inv lido car cter " + SUBSTR( WRD-ASSIGN , y , 1) + "en el concepto ingresado".
            END.
            
            IF WRD-ASSIGN = "" 
            THEN ASSIGN ERROR-NUM = 1
                        ERROR-MSG = "falta ingresar el concepto".
            
            IF INDEX( WRD-ASSIGN, "-" ) <> R-INDEX( WRD-ASSIGN, "-" )
            THEN ASSIGN ERROR-NUM = 1
                        ERROR-MSG = "Inv lida forma de expresar una suma de conceptos".

            IF ERROR-NUM > 0 
            THEN DO:
                ERROR-POS = i - LENGTH( WRD-ASSIGN ).
                Tipo      = 0.
                LEAVE lazo.
            END.    

            /* Eliminando ceros de la izquierda */
            DO WHILE WRD-ASSIGN BEGINS "0":
                WRD-ASSIGN = SUBSTR( WRD-ASSIGN, 2).
            END.
            DO WHILE INDEX( WRD-ASSIGN, "-0") > 0:
                SUBSTR( WRD-ASSIGN, INDEX( WRD-ASSIGN, "-0"), 2 ) = "-".
            END.

            IF WRD-ASSIGN BEGINS "-" OR 
               SUBSTR( WRD-ASSIGN, LENGTH(WRD-ASSIGN), 1) = "-" 
            THEN ASSIGN ERROR-NUM = 1
                        ERROR-MSG = "Inv lida forma de expresar una suma de conceptos".
            
           
            NUM-VAR = LOOKUP( SEL-VAR[Tipo], WRD-ASSIGN ).
            IF NUM-VAR = 0
            THEN DO:
                 NUM-VAR = NUM-ENTRIES( SEL-VAR[Tipo] ) + 1.
                 IF SEL-VAR[Tipo] = ""
                 THEN SEL-VAR[Tipo] = WRD-ASSIGN.
                 ELSE SEL-VAR[Tipo] = SEL-VAR[Tipo] + "," + WRD-ASSIGN.
            END.
        
            EDITOR-2 = EDITOR-2 + "v" + STRING(Tipo) + "[" + STRING( NUM-VAR ) + "]".
            Tipo     = 0.
            
            IF i = LEN-TEXT  AND  INDEX( " .=*+/><" + CHR(10), CHR-IN ) = 0
            THEN LEAVE lazo.
        END.

        IF tipo = 0
        THEN EDITOR-2   = EDITOR-2 + CHR-IN.
        ELSE WRD-ASSIGN = WRD-ASSIGN + CHR-IN.
        LIN-FIN = IF INDEX( " ." + CHR(10), CHR-IN ) > 0 THEN LIN-FIN + CHR-IN ELSE "".
    END.    

    /* Eliminamos l¡neas vacias */
    IF LENGTH( LIN-FIN ) > 0
    THEN EDITOR-2 = SUBSTR( EDITOR-2, 1, LENGTH(EDITOR-2) - LENGTH( LIN-FIN )).
    
    IF tipo > 0 
    THEN ASSIGN ERROR-NUM = 1
                ERROR-MSG = "falta ingresar el concepto"
                ERROR-POS = i - 1.


    IF ERROR-NUM > 0
    THEN EDITOR-2 = "VAL-RET = 0. /" + "* Error de Formula *" + "/" + CHR(10). 
    ELSE DO i = 1 TO 3:
        IF SEL-VAR[ i ] <> "" THEN PRE-ASG = PRE-ASG + "RUN PRE-ASG-" + STRING( i ) + "( " + CHR(34) + SEL-VAR[ i ] + CHR(34) + " )." + CHR(10).
    END.
    
    /* Compilando para verificar errores */
    TEMP-FILE = SESSION:TEMP-DIRECTORY + "Errores.pln".
    OUTPUT TO VALUE( TEMP-FILE ).
    PUT UNFORMATTED "DEFINE VARIABLE V1 AS DECIMAL EXTENT 10 NO-UNDO." SKIP.
    PUT UNFORMATTED "DEFINE VARIABLE V2 AS DECIMAL EXTENT 10 NO-UNDO." SKIP.
    PUT UNFORMATTED "DEFINE VARIABLE V3 AS DECIMAL EXTENT 10 NO-UNDO." SKIP.
    PUT UNFORMATTED "DEFINE VARIABLE VAL-RET AS DECIMAL NO-UNDO." SKIP.
    PUT UNFORMATTED EDITOR-2.
    PUT UNFORMATTED ".".
    OUTPUT CLOSE.
    COMPILE VALUE( TEMP-FILE).
    IF COMPILER:ERROR
    THEN  DO:
          ASSIGN ERROR-NUM = ERROR-STATUS:NUM-MESSAGES 
                 ERROR-MSG = ERROR-STATUS:GET-MESSAGE( ERROR-NUM )
                 ERROR-POS = 1.
          MESSAGE COMPILER:ERROR-ROW SKIP
                  COMPILER:ERROR-COLUMN.
    END.             
    EDITOR-2 = PRE-ASG + EDITOR-2 + "." + CHR(10).
       
    IF TIPO-PROC = "PROCEDURE"
    THEN EDITOR-2 = EDITOR-2 + "END PROCEDURE." + CHR(10) + CHR(10).
    ELSE EDITOR-2 = EDITOR-2 + "RUN GRABA( " + STRING( CODI-PROC ) + " )." + CHR(10) + CHR(10).
    
    ERROR-2 = ( ERROR-NUM > 0 ).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "integral.PL-CALC"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
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
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _chequea_sintaxis-mes V-table-Win 
PROCEDURE _chequea_sintaxis-mes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE S-errores AS CHARACTER.
OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
FIND B-PL-CALC WHERE ROWID(integral.PL-CALC) = ROWID(B-PL-CALC).

  RUN PLN/p-ck2-fm.p ( 
      "",
      B-PL-CALC.Main-Block-Cal-IN,
      0,
      "MAIN-BLOCK",
    OUTPUT B-PL-CALC.Main-Block-Cal-OK ,
    OUTPUT B-PL-CALC.ERROR-MSG-CaL      ).

  B-PL-CALC.ERROR-Cal = ( B-PL-CALC.ERROR-MSG-Cal <> "" ).

  IF B-PL-CALC.ERROR-MSG-Cal <> ""
  THEN S-ERRORES = S-ERRORES + "PROCEDIMIENTO " +
       " con error en su formula" + chr(10).

FOR EACH integral.PL-BOLE EXCLUSIVE-LOCK WHERE
    integral.PL-BOLE.codpln = B-PL-CALC.codPln AND
    integral.PL-BOLE.codcal = B-PL-CALC.CodCal :
  IF NOT B-PL-CALC.ERROR-Cal
  THEN DO:
      RUN PLN/p-ck2-fm.p ( 
          B-PL-CALC.Main-Block-Cal-OK,
          integral.PL-BOLE.FORMULA-MOV-IN,
          integral.PL-BOLE.CODMOV,
          integral.PL-BOLE.TPOBOL,
        OUTPUT integral.PL-BOLE.FORMULA-MOV-OK,
        OUTPUT integral.PL-BOLE.ERROR-MSG-MOV      ).

      integral.PL-BOLE.ERROR-MOV = ( integral.PL-BOLE.ERROR-MSG-MOV <> "" ).

      IF integral.PL-BOLE.ERROR-MSG-MOV <> ""
      THEN S-ERRORES = S-ERRORES + "CONCEPTO " +
           STRING(integral.PL-BOLE.codMOV, "999") +
           " con error en su formula" + chr(10).
    END.
    ELSE integral.PL-BOLE.ERROR-MOV = YES.
END.

IF S-ERRORES <> ""
THEN MESSAGE S-ERRORES VIEW-AS ALERT-BOX ERROR TITLE "Errores encontrados".
OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _chequea_sintaxis-sem V-table-Win 
PROCEDURE _chequea_sintaxis-sem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE S-errores AS CHARACTER.
OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
FIND B-PL-CALC WHERE ROWID(integral.PL-CALC) = ROWID(B-PL-CALC).

  RUN PLN/p-chk-fm.p ( 
      "",
      B-PL-CALC.Main-Block-Cal-IN,
      0,
      "MAIN-BLOCK",
    OUTPUT B-PL-CALC.Main-Block-Cal-OK ,
    OUTPUT B-PL-CALC.ERROR-MSG-CaL      ).

  B-PL-CALC.ERROR-Cal = ( B-PL-CALC.ERROR-MSG-Cal <> "" ).

  IF B-PL-CALC.ERROR-MSG-Cal <> ""
  THEN S-ERRORES = S-ERRORES + "PROCEDIMIENTO " +
       " con error en su formula" + chr(10).

FOR EACH integral.PL-BOLE EXCLUSIVE-LOCK WHERE
    integral.PL-BOLE.codpln = B-PL-CALC.codPln AND
    integral.PL-BOLE.codcal = B-PL-CALC.CodCal :
  IF NOT B-PL-CALC.ERROR-Cal
  THEN DO:
      RUN PLN/p-chk-fm.p ( 
          B-PL-CALC.Main-Block-Cal-OK,
          integral.PL-BOLE.FORMULA-MOV-IN,
          integral.PL-BOLE.CODMOV,
          integral.PL-BOLE.TPOBOL,
        OUTPUT integral.PL-BOLE.FORMULA-MOV-OK,
        OUTPUT integral.PL-BOLE.ERROR-MSG-MOV      ).

      integral.PL-BOLE.ERROR-MOV = ( integral.PL-BOLE.ERROR-MSG-MOV <> "" ).

      IF integral.PL-BOLE.ERROR-MSG-MOV <> ""
      THEN S-ERRORES = S-ERRORES + "CONCEPTO " +
           STRING(integral.PL-BOLE.codMOV, "999") +
           " con error en su formula" + chr(10).
    END.
    ELSE integral.PL-BOLE.ERROR-MOV = YES.
END.

IF S-ERRORES <> ""
THEN MESSAGE S-ERRORES VIEW-AS ALERT-BOX ERROR TITLE "Errores encontrados".
OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _genera-programa-mes V-table-Win 
PROCEDURE _genera-programa-mes :
/*------------------------------------------------------------------------------
    Generador de programas de c lculo
------------------------------------------------------------------------------*/

DEFINE VARIABLE Nom-Archivo-Cal AS CHARACTER NO-UNDO.
DEFINE VARIABLE CABECERA        AS CHARACTER NO-UNDO.
DEFINE VARIABLE SET-OK          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE DIRECTORIO      AS CHARACTER NO-UNDO.

GET-KEY-VALUE SECTION "Planillas" KEY "Directorio de Programas" VALUE DIRECTORIO.

ASSIGN
    Nom-Archivo-Cal = DIRECTORIO + "G-C" +  STRING(PL-CALC.CodPln, "99") +
    STRING(PL-CALC.CodCal, "999") + ".P"
    SET-OK = SESSION:SET-WAIT-STATE("GENERAL").

OUTPUT STREAM strm-arch-m TO VALUE( Nom-Archivo-Cal ) NO-MAP NO-CONVERT.

RUN pln/p-ck2-df.p(PL-CALC.CodPln, PL-CALC.CodCal, PL-CALC.CodMov, OUTPUT CABECERA).

PUT STREAM strm-arch-m UNFORMATTED CABECERA SKIP.
PUT STREAM strm-arch-m UNFORMATTED "" SKIP.
PUT STREAM strm-arch-m UNFORMATTED PL-CALC.Main-Block-Cal-OK SKIP.
PUT STREAM strm-arch-m UNFORMATTED "" SKIP.
FOR EACH PL-BOLE NO-LOCK WHERE
    PL-BOLE.codpln = PL-CALC.codPln AND
    PL-BOLE.codcal = PL-CALC.CodCal
    BY PL-BOLE.Prioridad
    BY PL-BOLE.nroitm :
    FIND PL-CONC WHERE PL-CONC.CodMov = PL-BOLE.codMov NO-LOCK NO-ERROR.
    IF AVAILABLE PL-CONC THEN
        PUT STREAM strm-arch-m UNFORMATTED "/* " PL-CONC.CodMov " " PL-CONC.DesMov " */ " SKIP.
    ELSE PUT STREAM strm-arch-m UNFORMATTED "/* Concepto no hallado */" SKIP.
    PUT STREAM strm-arch-m UNFORMATTED "ASSIGN VAR = 0." SKIP.
    PUT STREAM strm-arch-m UNFORMATTED PL-BOLE.FORMULA-MOV-OK SKIP.
    PUT STREAM strm-arch-m UNFORMATTED "RUN @GRABA(" + STRING(PL-BOLE.CodMov) + ",'" + STRING(PL-BOLE.TpoBol) + "')." SKIP.
    PUT STREAM strm-arch-m UNFORMATTED "" SKIP(1).
END.

PUT STREAM strm-arch-m UNFORMATTED "PROCEDURE @GRABA." SKIP.
PUT STREAM strm-arch-m UNFORMATTED "/*--------------*/" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "" SKIP(1).
PUT STREAM strm-arch-m UNFORMATTED "DEFINE INPUT PARAMETER s-CodMov AS INTEGER   NO-UNDO." SKIP.
PUT STREAM strm-arch-m UNFORMATTED "DEFINE INPUT PARAMETER s-TipBol AS CHARACTER NO-UNDO." SKIP.
PUT STREAM strm-arch-m UNFORMATTED "" SKIP(1).
PUT STREAM strm-arch-m UNFORMATTED "FIND FIRST PL-MOV-MES WHERE" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "    PL-MOV-MES.CodCia  = PL-FLG-MES.CodCia AND" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "    PL-MOV-MES.Periodo = PL-FLG-MES.Periodo AND" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "    PL-MOV-MES.NroMes  = PL-FLG-MES.NroMes AND" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "    PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln AND" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "    PL-MOV-MES.CodCal  = s-CodCal AND" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "    PL-MOV-MES.CodMov  = s-CodMov NO-ERROR." SKIP.
PUT STREAM strm-arch-m UNFORMATTED "IF NOT AVAILABLE PL-MOV-MES THEN DO:" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "    IF VAR = 0 THEN RETURN." SKIP.
PUT STREAM strm-arch-m UNFORMATTED "    CREATE PL-MOV-MES." SKIP.
PUT STREAM strm-arch-m UNFORMATTED "    ASSIGN" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "        PL-MOV-MES.CodCia  = PL-FLG-MES.CodCia" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "        PL-MOV-MES.Periodo = PL-FLG-MES.Periodo" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "        PL-MOV-MES.NroMes  = PL-FLG-MES.NroMes" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "        PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "        PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "        PL-MOV-MES.CodCal  = s-CodCal" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "        PL-MOV-MES.CodMov  = s-CodMov." SKIP.
PUT STREAM strm-arch-m UNFORMATTED "END." SKIP.
PUT STREAM strm-arch-m UNFORMATTED "ASSIGN" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "    PL-MOV-MES.ValCal-MES  = ROUND(VAR, 2)" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "    PL-MOV-MES.Fch-Ult-Cal = TODAY" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "    PL-MOV-MES.Hra-Ult-Cal = STRING(TIME,'HH:MM')." SKIP.
PUT STREAM strm-arch-m UNFORMATTED "" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "IF s-TipBol = 'Remuneraciones' THEN" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "    ASSIGN" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "        NETO = NETO + PL-MOV-MES.ValCal-MES" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "        TOTAL-REMUNERACION = TOTAL-REMUNERACION + PL-MOV-MES.ValCal-MES." SKIP.
PUT STREAM strm-arch-m UNFORMATTED "" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "IF s-TipBol = 'Descuentos' THEN" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "    ASSIGN" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "        NETO = NETO - PL-MOV-MES.ValCal-MES" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "        TOTAL-DESCUENTO = TOTAL-DESCUENTO + PL-MOV-MES.ValCal-MES." SKIP.
PUT STREAM strm-arch-m UNFORMATTED "" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "IF s-TipBol = 'Aportes' THEN" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "    ASSIGN TOTAL-APORTE = TOTAL-APORTE + PL-MOV-MES.ValCal-MES." SKIP.
PUT STREAM strm-arch-m UNFORMATTED "" SKIP.
PUT STREAM strm-arch-m UNFORMATTED "END PROCEDURE." SKIP.

OUTPUT STREAM strm-arch-m CLOSE.

ASSIGN SET-OK = SESSION:SET-WAIT-STATE("").

COMPILE VALUE( Nom-Archivo-Cal ) SAVE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _genera-programa-sem V-table-Win 
PROCEDURE _genera-programa-sem :
/*------------------------------------------------------------------------------
    Generador de programas de c lculo
------------------------------------------------------------------------------*/

DEFINE VARIABLE Nom-Archivo-Cal AS CHARACTER NO-UNDO.
DEFINE VARIABLE CABECERA        AS CHARACTER NO-UNDO.
DEFINE VARIABLE SET-OK          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE DIRECTORIO      AS CHARACTER NO-UNDO.

GET-KEY-VALUE SECTION "Planillas" KEY "Directorio de Programas" VALUE DIRECTORIO.

ASSIGN
    Nom-Archivo-Cal = DIRECTORIO + "G-C" + STRING(PL-CALC.CodPln, "99") +
    STRING(PL-CALC.CodCal, "999") + ".P"
    SET-OK = SESSION:SET-WAIT-STATE("GENERAL").

OUTPUT STREAM strm-arch-s TO VALUE( Nom-Archivo-Cal ) NO-MAP NO-CONVERT.

RUN pln/p-chk-df.p(PL-CALC.CodPln, PL-CALC.CodCal, PL-CALC.CodMov, OUTPUT CABECERA).

PUT STREAM strm-arch-s UNFORMATTED CABECERA SKIP.
PUT STREAM strm-arch-s UNFORMATTED "" SKIP.
PUT STREAM strm-arch-s UNFORMATTED PL-CALC.Main-Block-Cal-OK SKIP.
PUT STREAM strm-arch-s UNFORMATTED "" SKIP.
FOR EACH PL-BOLE NO-LOCK WHERE
    PL-BOLE.codpln = PL-CALC.codPln AND
    PL-BOLE.codcal = PL-CALC.CodCal
    BY PL-BOLE.Prioridad
    BY PL-BOLE.nroitm :
    FIND PL-CONC WHERE PL-CONC.CodMov = PL-BOLE.codMov NO-LOCK NO-ERROR.
    IF AVAILABLE PL-CONC THEN
        PUT STREAM strm-arch-s UNFORMATTED "/* " PL-CONC.CodMov " " PL-CONC.DesMov " */ " SKIP.
    ELSE PUT STREAM strm-arch-s UNFORMATTED "/* Concepto no hallado */" SKIP.
    PUT STREAM strm-arch-s UNFORMATTED "ASSIGN VAR = 0." SKIP.
    PUT STREAM strm-arch-s UNFORMATTED PL-BOLE.FORMULA-MOV-OK SKIP.
    PUT STREAM strm-arch-s UNFORMATTED "RUN @GRABA(" + STRING(PL-BOLE.CodMov) + ",'" + STRING(PL-BOLE.TpoBol) + "')." SKIP.
    PUT STREAM strm-arch-s UNFORMATTED "" SKIP(1).
END.

PUT STREAM strm-arch-s UNFORMATTED "PROCEDURE @GRABA." SKIP.
PUT STREAM strm-arch-s UNFORMATTED "/*--------------*/" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "" SKIP(1).
PUT STREAM strm-arch-s UNFORMATTED "DEFINE INPUT PARAMETER s-CodMov AS INTEGER   NO-UNDO." SKIP.
PUT STREAM strm-arch-s UNFORMATTED "DEFINE INPUT PARAMETER s-TipBol AS CHARACTER NO-UNDO." SKIP.
PUT STREAM strm-arch-s UNFORMATTED "" SKIP(1).
PUT STREAM strm-arch-s UNFORMATTED "FIND FIRST PL-MOV-SEM WHERE" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "    PL-MOV-SEM.CodCia  = PL-FLG-SEM.CodCia AND" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "    PL-MOV-SEM.Periodo = PL-FLG-SEM.Periodo AND" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "    PL-MOV-SEM.NroSem  = PL-FLG-SEM.NroSem AND" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "    PL-MOV-SEM.CodPln  = PL-FLG-SEM.CodPln AND" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "    PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer AND" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "    PL-MOV-SEM.CodCal  = s-CodCal AND" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "    PL-MOV-SEM.CodMov  = s-CodMov NO-ERROR." SKIP.
PUT STREAM strm-arch-s UNFORMATTED "IF NOT AVAILABLE PL-MOV-SEM THEN DO:" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "    IF VAR = 0 THEN RETURN." SKIP.
PUT STREAM strm-arch-s UNFORMATTED "    CREATE PL-MOV-SEM." SKIP.
PUT STREAM strm-arch-s UNFORMATTED "    ASSIGN" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "        PL-MOV-SEM.CodCia  = PL-FLG-SEM.CodCia" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "        PL-MOV-SEM.Periodo = PL-FLG-SEM.Periodo" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "        PL-MOV-SEM.NroSem  = PL-FLG-SEM.NroSem" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "        PL-MOV-SEM.CodPln  = PL-FLG-SEM.CodPln" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "        PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "        PL-MOV-SEM.CodCal  = s-CodCal" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "        PL-MOV-SEM.CodMov  = s-CodMov." SKIP.
PUT STREAM strm-arch-s UNFORMATTED "END." SKIP.
PUT STREAM strm-arch-s UNFORMATTED "ASSIGN" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "    PL-MOV-SEM.ValCal-Sem  = ROUND(VAR, 2)" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "    PL-MOV-SEM.Fch-Ult-Cal = TODAY" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "    PL-MOV-SEM.Hra-Ult-Cal = STRING(TIME,'HH:MM')." SKIP.
PUT STREAM strm-arch-s UNFORMATTED "" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "IF s-TipBol = 'Remuneraciones' THEN" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "    ASSIGN" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "        NETO = NETO + PL-MOV-SEM.ValCal-SEM" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "        TOTAL-REMUNERACION = TOTAL-REMUNERACION + PL-MOV-SEM.ValCal-SEM." SKIP.
PUT STREAM strm-arch-s UNFORMATTED "" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "IF s-TipBol = 'Descuentos' THEN" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "    ASSIGN" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "        NETO = NETO - PL-MOV-SEM.ValCal-SEM" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "        TOTAL-DESCUENTO = TOTAL-DESCUENTO + PL-MOV-SEM.ValCal-SEM." SKIP.
PUT STREAM strm-arch-s UNFORMATTED "" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "IF s-TipBol = 'Aportes' THEN" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "    ASSIGN TOTAL-APORTE = TOTAL-APORTE + PL-MOV-SEM.ValCal-SEM." SKIP.
PUT STREAM strm-arch-s UNFORMATTED "" SKIP.
PUT STREAM strm-arch-s UNFORMATTED "END PROCEDURE." SKIP.

OUTPUT STREAM strm-arch-s CLOSE.

ASSIGN SET-OK = SESSION:SET-WAIT-STATE("").

COMPILE VALUE( Nom-Archivo-Cal ) SAVE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _imprime-formulas V-table-Win 
PROCEDURE _imprime-formulas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

OUTPUT STREAM strm-arch-m TO PRINTER PAGED PAGE-SIZE 66.

PUT STREAM strm-arch-m CONTROL "~033P~033E". /* LETRA NORMAL + NEGRITA */

DEFINE VARIABLE i        AS INTEGER.
DEFINE VARIABLE linea    AS CHARACTER FORMAT "x(100)".
DEFINE VARIABLE concepto AS CHARACTER FORMAT "x(100)".

PUT STREAM strm-arch-m CONTROL CHR(14). /* LETRA GRANDE */
PUT STREAM strm-arch-m SPACE(11) "LISTADO DE FORMULAS" SKIP.
PUT STREAM strm-arch-m CONTROL CHR(14).
PUT STREAM strm-arch-m SPACE(11) "-------------------" SKIP(1).
PUT STREAM strm-arch-m CONTROL CHR(14).
PUT STREAM strm-arch-m "CALCULO: " PL-CALC.codcal " " PL-CALC.descal SKIP(1).

PUT STREAM strm-arch-m CONTROL CHR(27) "~033F".

DO i = 1 TO NUM-ENTRIES(PL-CALC.Main-Block-Cal-IN, CHR(10)):
    linea = ENTRY(i,PL-CALC.Main-Block-Cal-IN, CHR(10)).
    PUT STREAM strm-arch-m linea SKIP.
    IF LINE-COUNTER( strm-arch-m ) > 62 THEN PAGE STREAM strm-arch-m.
END.

PUT STREAM strm-arch-m SKIP(1).

IF LINE-COUNTER( strm-arch-m ) > 62 THEN PAGE STREAM strm-arch-m.

FOR EACH PL-BOLE WHERE
    PL-BOLE.codpln = PL-CALC.codpln AND
    PL-BOLE.codcal = PL-CALC.codcal NO-LOCK:
    
    IF imprime-rem OR imprime-des OR imprime-apo OR imprime-otr THEN
       CASE PL-BOLE.TpoBol:
           WHEN "Remuneraciones" THEN IF NOT imprime-rem THEN NEXT.
           WHEN "Descuentos" THEN IF NOT imprime-des THEN NEXT.
           WHEN "Aportes" THEN IF NOT imprime-apo THEN NEXT.
           WHEN "Otros" THEN IF NOT imprime-otr THEN NEXT.
       END CASE.

    FIND PL-CONC WHERE PL-CONC.codmov = PL-BOLE.codmov NO-LOCK NO-ERROR.
    IF AVAILABLE PL-CONC THEN concepto = PL-CONC.desmov.
    ELSE concepto = "".

    PUT STREAM strm-arch-m CONTROL "~033E".
    PUT STREAM strm-arch-m PL-BOLE.codmov " " concepto SKIP.
  /*PUT STREAM strm-arch-m UNFORMATTED "--- " FILL("-", LENGTH(concepto)) SKIP.*/
    PUT STREAM strm-arch-m CONTROL CHR(27) "~033F".

    IF LINE-COUNTER( strm-arch-m ) > 62 THEN PAGE STREAM strm-arch-m.

    DO i = 1 TO NUM-ENTRIES(PL-BOLE.FORMULA-MOV-IN, CHR(10)):
        linea = ENTRY(i,PL-BOLE.FORMULA-MOV-IN,CHR(10)).
        PUT STREAM strm-arch-m '    ' linea SKIP.
        IF LINE-COUNTER( strm-arch-m ) > 62 THEN PAGE STREAM strm-arch-m.
    END.

    PUT STREAM strm-arch-m SKIP(1).

    IF LINE-COUNTER( strm-arch-m ) > 62 THEN PAGE STREAM strm-arch-m.

END.

OUTPUT STREAM strm-arch-m CLOSE.

OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


