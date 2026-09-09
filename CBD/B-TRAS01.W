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

DEFINE SHARED VAR S-TRASLADO AS CHAR.

DEFINE VAR F-CAB AS CHAR INIT "".
DEFINE VAR F-DET AS CHAR INIT "".
DEFINE VAR X-MENSAJE AS integer format "999999".

DEFINE FRAME F-AUXILIAR
X-MENSAJE LABEL "Registros Procesados"
WITH TITLE "Espere un momento por favor" CENTERED
     VIEW-AS DIALOG-BOX NO-LABELS.

DEFINE TEMP-TABLE T-KEY
FIELD CODCIA   LIKE CB-CMOV.CODCIA
FIELD PERIODO  LIKE CB-CMOV.PERIODO
FIELD NROMES   LIKE CB-CMOV.NROMES
FIELD CODOPE   LIKE CB-CMOV.CODOPE
FIELD NROAST   LIKE CB-CMOV.NROAST
FIELD NRODOC   LIKE CB-CMOV.NROAST
INDEX IDX01 CODCIA PERIODO NROMES CODOPE NROAST.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-tras

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table cb-tras.NROTRA cb-tras.Destral ~
cb-tras.mes1 cb-tras.mes2 cb-tras.nroreg cb-tras.flgest cb-tras.TIPO 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table cb-tras.Destral ~
cb-tras.mes1 cb-tras.mes2 cb-tras.flgest 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}Destral ~{&FP2}Destral ~{&FP3}~
 ~{&FP1}mes1 ~{&FP2}mes1 ~{&FP3}~
 ~{&FP1}mes2 ~{&FP2}mes2 ~{&FP3}~
 ~{&FP1}flgest ~{&FP2}flgest ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table cb-tras
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table cb-tras
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH cb-tras ~
      WHERE cb-tras.TIPO = S-TRASLADO NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table cb-tras
&Scoped-define FIRST-TABLE-IN-QUERY-br_table cb-tras


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-18 br_table f-file Aceptar B-Output 
&Scoped-Define DISPLAYED-OBJECTS f-file 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON Aceptar 
     LABEL "Procesar Traslado" 
     SIZE 32 BY .85
     FONT 0.

DEFINE BUTTON B-Output 
     LABEL "Archivos...":L 
     SIZE 10 BY .81
     FONT 4.

DEFINE BUTTON BUTTON-1 
     LABEL "Anular lo Trasladado" 
     SIZE 32 BY .85
     FONT 0.

DEFINE VARIABLE f-file AS CHARACTER FORMAT "X(256)":U 
     LABEL "Archivo Destino" 
     VIEW-AS FILL-IN 
     SIZE 47.14 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 76 BY 10.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      cb-tras SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      cb-tras.NROTRA
      cb-tras.Destral
      cb-tras.mes1 COLUMN-LABEL "Mes Inicio"
      cb-tras.mes2 COLUMN-LABEL "Mes Fin.."
      cb-tras.nroreg COLUMN-LABEL "Nro!Registros" FORMAT "zz,zzz"
      cb-tras.flgest COLUMN-LABEL "E"
      cb-tras.TIPO COLUMN-LABEL "T"
  ENABLE
      cb-tras.Destral
      cb-tras.mes1
      cb-tras.mes2
      cb-tras.flgest
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 74.86 BY 7.81
         BGCOLOR 15 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.12 COL 1.43
     BUTTON-1 AT ROW 9.96 COL 2.72
     f-file AT ROW 8.96 COL 11 COLON-ALIGNED
     Aceptar AT ROW 9.96 COL 43.86
     B-Output AT ROW 8.96 COL 60.43
     RECT-18 AT ROW 1.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4.


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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 10.04
         WIDTH              = 76.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table RECT-18 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.cb-tras"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "cb-tras.TIPO = S-TRASLADO"
     _FldNameList[1]   = integral.cb-tras.NROTRA
     _FldNameList[2]   > integral.cb-tras.Destral
"Destral" ? ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[3]   > integral.cb-tras.mes1
"mes1" "Mes Inicio" ? "integer" ? ? ? ? ? ? yes ?
     _FldNameList[4]   > integral.cb-tras.mes2
"mes2" "Mes Fin.." ? "integer" ? ? ? ? ? ? yes ?
     _FldNameList[5]   > integral.cb-tras.nroreg
"nroreg" "Nro!Registros" "zz,zzz" "integer" ? ? ? ? ? ? no ?
     _FldNameList[6]   > integral.cb-tras.flgest
"flgest" "E" ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[7]   > integral.cb-tras.TIPO
"TIPO" "T" ? "character" ? ? ? ? ? ? no ?
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Aceptar B-table-Win
ON CHOOSE OF Aceptar IN FRAME F-Main /* Procesar Traslado */
DO:
   ASSIGN F-FILE
          F-CAB = ""
          F-DET = "".

   MESSAGE "Verifique la informaci¢n solicitada" skip
           "Esta seguro de continuar"
           view-as alert-box informa buttons yes-no
           update xsigue as logical.
           if not xsigue then return no-apply.


   IF NOT AVAIL cb-tras THEN DO:
      MESSAGE "No esta disponible ning£n registro de traslado"
      VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   IF LOOKUP(cb-tras.FLGEST,"A,T") > 0  THEN DO:
      MESSAGE "Traslado no puede ser procesado"
      VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   IF F-FILE = "" THEN DO:
      MESSAGE "Nombre de Archivo no valido"
      VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.

   CASE S-TRASLADO :

        WHEN "E" THEN DO:

                      IF cb-tras.MES1 > cb-tras.MES2 THEN DO:
                         MESSAGE "Rango de Meses no valido"
                         VIEW-AS ALERT-BOX.
                         RETURN NO-APPLY.
                      END.
                      IF cb-tras.MES1 =   ? OR
                         cb-tras.MES2 =   ? THEN DO:
                         MESSAGE "MEses no validas"
                         VIEW-AS ALERT-BOX.
                         RETURN NO-APPLY.
                      END.
                      IF LENGTH(F-file) < 3
                      THEN DO:
                         MESSAGE "Nombre de Archivo Nro 1 de destino" SKIP
                                 "No valido"
                         VIEW-AS ALERT-BOX ERROR.
                         RETURN NO-APPLY.
                      END.
                      IF substring(f-file,length(f-file) - 1, 2) <> ".1"
                      THEN DO:
                         MESSAGE "Nombre de Archivo Nro 1 debe " SKIP
                                 "terminar en  .1 "
                         VIEW-AS ALERT-BOX ERROR.
                         RETURN NO-APPLY.
                      END.
                      f-cab = f-file.
                      F-DET = SUBSTRING(F-CAB , 1 , LENGTH(F-CAB) - 1 ) + "2".


                      RUN EXPORTA.

                      END.


        WHEN "I" THEN DO:
                      FILE-INFO:FILE-NAME = F-FILE.
                      IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
                         MESSAGE "Archivo Nro 1 de origen" SKIP
                                 F-FILE  "No existe"
                         VIEW-AS ALERT-BOX ERROR.
                         RETURN NO-APPLY.
                      END.
                      F-CAB = FILE-INFO:FULL-PATHNAME.
                      IF LENGTH(F-CAB) < 3 or
                         INDEX(F-CAB, ".") = 0
                      THEN DO:
                         MESSAGE "Nombre de Archivo Nro 1 de origen" SKIP
                                 "No valido"
                         VIEW-AS ALERT-BOX ERROR.
                         RETURN NO-APPLY.
                      END.
                      FILE-INFO:FILE-NAME = SUBSTRING(F-CAB , 1 , LENGTH(F-CAB) - 1 ) + "2".
                      F-DET = SUBSTRING(F-CAB , 1 , LENGTH(F-CAB) - 1 ) + "2".
                      IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
                         MESSAGE "Archivo Nro 2 de origen" SKIP
                                 F-DET  "No existe"
                         VIEW-AS ALERT-BOX ERROR.
                         RETURN NO-APPLY.
                      END.
                      F-DET = FILE-INFO:FULL-PATHNAME.


                      RUN IMPORTA.


                 END.
   END CASE.
   MESSAGE
           "PROCESO COMPLETO" SKIP
           "EJECUTE EL PROGRAMA DE REGENERACION "
           "DE SALDOS POR CADA COMPA¥IA"
   VIEW-AS ALERT-BOX INFORMA.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Output
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Output B-table-Win
ON CHOOSE OF B-Output IN FRAME F-Main /* Archivos... */
DO:
def var name    as char    no-undo.
def var bPicked as logical no-undo.
        system-dialog get-file
            name
            filters           "*.*" "*.*"  /* Filter                */
            default-extension "*.txt"        /* default-extensions     */
            title             "Seleccione archivo"
            must-exist
            update bPicked.
        if bPicked then
        f-file:screen-value = name.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  IF AVAIL cb-tras AND cb-tras.FLGEST = "T" THEN RETURN NO-APPLY.
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
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
  DO WITH FRAME {&FRAME-NAME} :
     F-FILE = "".
     DISPLAY F-FILE.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Anular lo Trasladado */
DO :

 IF NOT AVAIL cb-tras THEN RETURN.
 IF cb-tras.FLGEST <> "T" THEN DO:
    MESSAGE "Traslado no puede ser anulado"
    VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
 END.

  Message "Esta opci¢n anular  los registros" skip
          "importados" skip
          "Esta seguro "
          view-as alert-box question buttons yes-no
          update rpta as logical.
  if not rpta then return.
  run anula.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-file
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-file B-table-Win
ON ENTRY OF f-file IN FRAME F-Main /* Archivo Destino */
DO:
  IF NOT AVAIL cb-tras THEN RETURN.
  IF cb-tras.FLGEST = "A" THEN RETURN.
  SELF:SCREEN-VALUE = "CB" + STRING(cb-tras.NROTRA,"999999") + ".1".

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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ANULA B-table-Win 
PROCEDURE ANULA :
DEF VAR T-ROWID AS ROWID.
DEF VAR X AS LOGICAL.
X = SESSION:SET-WAIT-STATE("GENERAL").

T-ROWID = ROWID(cb-tras).
FIND cb-tras WHERE ROWID(cb-tras) = T-ROWID.
FOR EACH CB-CMOV WHERE CB-CMOV.NROTRA = STRING(cb-tras.NROTRA,"999999") :
    FOR EACH CB-DMOV WHERE CB-DMOV.CODCIA  = CB-CMOV.CODCIA  AND
                           CB-DMOV.PERIODO = CB-CMOV.PERIODO AND
                           CB-DMOV.NROMES  = CB-CMOV.NROMES  AND
                           CB-DMOV.CODOPE  = CB-CMOV.CODOPE  AND
                           CB-DMOV.NROAST  = CB-CMOV.NROAST :
              DELETE CB-DMOV.
     END.
    DELETE CB-CMOV.
END.

ASSIGN cb-tras.FLGEST = "A".
X = SESSION:SET-WAIT-STATE("").
RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE configura B-table-Win 
PROCEDURE configura :
DO WITH FRAME {&FRAME-NAME} :
   f-file = "".
   CASE S-TRASLADO :

        WHEN "E" THEN do:
                       f-file:LABEL = "Archivo Destino".
                       BUTTON-1:sensitive = no.
                      end.
        WHEN "I" THEN do:
                       f-file:LABEL = "Archivo Origen".
                        BUTTON-1:sensitive = yes.
                      end.

   END CASE.
   DISPLAY F-FILE.

END.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exporta B-table-Win 
PROCEDURE exporta :
def var x as logical.
DEF VAR I AS INTEGER INIT 0.
I = 0.
deF var t-rowid as rowid.
t-rowid = rowid(cb-tras).


x = session:set-wait-state("GENERAL").
FOR EACH T-KEY :
   DELETE T-KEY.
END.

DO TRANSACTION ON ERROR  UNDO, LEAVE
               ON ENDKEY UNDO, LEAVE
               ON STOP   UNDO, LEAVE:



FIND cb-tras WHERE ROWID(cb-tras) = T-ROWID.

OUTPUT TO VALUE(F-CAB).
FOR EACH CB-CMOV EXCLUSIVE WHERE CB-CMOV.NROMES >= cb-tras.MES1 AND
                                 CB-CMOV.NROMES <= cb-tras.MES2 AND
                                 CB-CMOV.CODCIA <> 999 :
    CREATE T-KEY.
    ASSIGN T-KEY.CODCIA  = CB-CMOV.CODCIA
           T-KEY.PERIODO = CB-CMOV.PERIODO
           T-KEY.NROMES  = CB-CMOV.NROMES
           T-KEY.CODOPE  = CB-CMOV.CODOPE
           T-KEY.NROAST  = CB-CMOV.NROAST.
    I = I + 1.
    EXPORT CB-CMOV.



END.
OUTPUT CLOSE.

OUTPUT TO VALUE(F-DET).
FOR EACH T-KEY :

    FOR EACH CB-DMOV EXCLUSIVE WHERE CB-DMOV.CODCIA   = T-KEY.CODCIA  AND
                                     CB-DMOV.PERIODO  = T-KEY.PERIODO AND
                                     CB-DMOV.NROMES   = T-KEY.NROMES  AND
                                     CB-DMOV.CODOPE   = T-KEY.CODOPE  AND
                                     CB-DMOV.NROAST   = T-KEY.NROAST  AND
                                     CB-DMOV.TPOITM  <> "A" :
        EXPORT CB-DMOV.

     END.


END.
OUTPUT CLOSE.
ASSIGN cb-tras.FLGEST = "T"
       cb-tras.NROREG = I.

END. /* FIN DE LA TRANSACCION */
x = session:set-wait-state("").
RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importa B-table-Win 
PROCEDURE importa :
def var x as logical.
DEF VAR I AS INTEGER INIT 0.
DEF VAR X-NROAST AS INTEGER.

I = 0.
x = session:set-wait-state("GENERAL").
deF var t-rowid as rowid.
t-rowid = rowid(cb-tras).

FOR EACH T-KEY :
   DELETE T-KEY.
END.


PROCESO:
DO TRANSACTION ON ERROR  UNDO, LEAVE 
               ON ENDKEY UNDO, LEAVE
               ON STOP   UNDO, LEAVE:
FIND cb-tras WHERE ROWID(cb-tras)  = T-ROWID.

INPUT FROM  VALUE(F-CAB).
REPEAT :
    X-NROAST = ?.
    CREATE CB-CMOV.
    IMPORT CB-CMOV.
    CREATE T-KEY.
    ASSIGN T-KEY.CODCIA   = CB-CMOV.CODCIA 
           T-KEY.PERIODO  = CB-CMOV.PERIODO
           T-KEY.NROMES   = CB-CMOV.NROMES
           T-KEY.CODOPE   = CB-CMOV.CODOPE
           T-KEY.NROAST   = CB-CMOV.NROAST .
     RUN CBD/CBDNAST.P (0 ,
                       CB-CMOV.codcia  ,
                       CB-CMOV.periodo ,
                       CB-CMOV.nromes  , 
                       CB-CMOV.codope  ,
                       OUTPUT X-NROAST  ).
     IF X-NROAST = ? THEN DO:
        MESSAGE "Error en la generaci¢n de correlativo"
        VIEW-AS ALERT-BOX ERROR.
        UNDO PROCESO, RETURN ERROR.
     END.                  
     ASSIGN CB-CMOV.NROTRA = STRING(cb-tras.NROTRA,"999999")
            CB-CMOV.NROAST = STRING(X-NROAST      ,"999999").     
     ASSIGN T-KEY.NRODOC   = CB-CMOV.NROAST.       
     I = I + 1.
END.
INPUT CLOSE.

INPUT FROM  VALUE(F-DET).
REPEAT :
    CREATE CB-DMOV.
    IMPORT CB-DMOV.
    FIND T-KEY WHERE T-KEY.CODCIA  = CB-DMOV.CODCIA  AND
                     T-KEY.PERIODO = CB-DMOV.PERIODO AND
                     T-KEY.NROMES  = CB-DMOV.NROMES  AND
                     T-KEY.CODOPE  = CB-DMOV.CODOPE  AND
                     T-KEY.NROAST  = CB-DMOV.NROAST
                     NO-LOCK NO-ERROR.
    IF NOT AVAIL T-KEY THEN DO:
       MESSAGE "Comprobante sin cabecera" skip
               "La informaci¢n no es consistente"
               VIEW-AS ALERT-BOX ERROR.
       UNDO PROCESO, RETURN ERROR.         
    END.                 
    ASSIGN CB-DMOV.NROAST = T-KEY.NRODOC.
 
END.
INPUT CLOSE.
ASSIGN cb-tras.FLGEST = "T"
       cb-tras.NROREG = I.
END.
x = session:set-wait-state("").
RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record B-table-Win 
PROCEDURE local-assign-record :
RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
ASSIGN cb-tras.TIPO   = S-TRASLADO.
 RUN get-attribute ('ADM-NEW-RECORD').
 IF RETURN-VALUE = 'YES' THEN
     ASSIGN cb-tras.NroTra = NEXT-VALUE(CBD-TRASL) .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
SESSION:DATE-FORMAT = "DMY".
RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
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
  {src/adm/template/snd-list.i "cb-tras"}

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


