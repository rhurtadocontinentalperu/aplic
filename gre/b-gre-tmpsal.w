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

/* Local Variable Definitions --- */
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE SHARED VAR S-CODCIA  AS INTEGER. 
DEFINE SHARED VAR S-CODALM  AS CHAR. 
DEFINE VARIABLE F-Equivale AS DECIMAL NO-UNDO.
DEFINE VARIABLE S-Unidad   AS CHAR NO-UNDO.

DEFINE VARIABLE S-UndStk   AS CHAR NO-UNDO.
DEFINE VARIABLE S-CODART   AS CHAR NO-UNDO.
DEFINE SHARED TEMP-TABLE ITEM-gre LIKE gre_detail.
DEFINE BUFFER DMOV       FOR  ITEM-gre.
DEFINE VARIABLE S-UndBas   AS CHAR NO-UNDO.

DEFINE VAR stkdes LIKE Almmmate.StkAct.
DEFINE VAR SW AS LOGICAL.

DEFINE BUFFER B-Almmmate FOR Almmmate.
DEFINE BUFFER X-Almmmatg FOR Almmmatg.

DEFINE SHARED VARIABLE C-CODALM  AS CHAR.
DEFINE SHARED VARIABLE ORDTRB    AS CHAR.
DEFINE SHARED VAR s-AlmDes LIKE  Almcmov.AlmDes.    /* Almacen destino */

DEFINE SHARED VAR lh_handle AS HANDLE.

DEF VAR s-local-new-record AS CHAR INIT 'NO'.

DEFINE VAR lMueveStock AS LOG INIT NO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ITEM-gre Almmmate Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ITEM-gre.codmat Almmmate.DesMat Almmmatg.DesMar ITEM-gre.CodUnd ITEM-gre.CanDes ITEM-gre.peso_unitario ITEM-gre.peso_total_item /* Almmmate.Stkact stkdes */   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table ITEM-gre.codmat ~
   ITEM-gre.CanDes   
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table ITEM-gre
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table ITEM-gre
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH ITEM-gre WHERE ~{&KEY-PHRASE} NO-LOCK, ~
             FIRST Almmmate WHERE Almmmate.codcia = 1 AND almmmate.codmat = ITEM-gre.codmat NO-LOCK, ~
             FIRST Almmmatg OF Almmmate NO-LOCK
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH ITEM-gre WHERE ~{&KEY-PHRASE} NO-LOCK, ~
             FIRST Almmmate WHERE Almmmate.codcia = 1 AND almmmate.codmat = ITEM-gre.codmat NO-LOCK, ~
             FIRST Almmmatg OF Almmmate NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table ITEM-gre Almmmate Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ITEM-gre
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmate
&Scoped-define THIRD-TABLE-IN-QUERY-br_table Almmmatg


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
      ITEM-gre, 
      Almmmate, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      ITEM-gre.codmat COLUMN-LABEL "Codigo!Articulo" FORMAT "x(14)" WIDTH 6.43
      Almmmate.DesMat FORMAT "X(47)" COLUMN-LABEL "D E S C R I P C I O N"
      Almmmatg.DesMar FORMAT "X(15)" COLUMN-LABEL "MARCA"
      ITEM-gre.CodUnd FORMAT 'x(7)' COLUMN-LABEL "U.M." WIDTH 5.43
      ITEM-gre.CanDes       FORMAT "(Z,ZZZ,ZZ9.99)" COLUMN-LABEL "Cantidad" WIDTH 8.43
      ITEM-gre.peso_unitario FORMAT "(Z,ZZZ,ZZ9.9999)" COLUMN-LABEL "Peso!Unit." WIDTH 8.43
      ITEM-gre.peso_total_item FORMAT "(Z,ZZZ,ZZ9.99)" COLUMN-LABEL "Peso Total!Item"  WIDTH 8.43
    /*
      Almmmate.Stkact   FORMAT '(ZZ,ZZZ,ZZ9.999)' WIDTH 8.43
      stkdes            FORMAT "(Z,ZZZ,ZZ9.99)" COLUMN-LABEL "Stock!Pedido" WIDTH 8.43
      */
  ENABLE
      ITEM-gre.codmat      
      ITEM-gre.CanDes
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 92 BY 12.5
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.04 COL 1
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
         HEIGHT             = 12.69
         WIDTH              = 93.43.
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
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM

OPEN QUERY {&SELF-NAME} FOR EACH ITEM-gre WHERE ~{&KEY-PHRASE} NO-LOCK,
      FIRST Almmmate WHERE Almmmate.codcia = 1 AND almmmate.codmat = ITEM-gre.codmat NO-LOCK,
      FIRST Almmmatg OF Almmmate NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE"
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
  /* Display de Datos Adicionales */
  /*
  DO WITH FRAME {&FRAME-NAME}:
     ITEM.CodUnd:READ-ONLY = YES.
  END. 
  */
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


/* ***************************  DEFINICION DE TRIGGER  *************************** */

ON "RETURN":U OF ITEM-gre.CodMat, ITEM-gre.CodUnd, ITEM-gre.CanDes
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

ON "MOUSE-SELECT-DBLCLICK":U OF ITEM-gre.Codmat
DO:
    input-var-1 = S-CODALM.
    input-var-2 = ITEM-gre.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    FIND Almtfami WHERE Almtfami.codcia = S-CODCIA AND
         Almtfami.codfam = input-var-2  NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtfami THEN input-var-2 = ''.
    RUN lkup\c-artalm.r ('Articulos por Almacen').
    IF output-var-1 <> ? THEN
       ITEM-gre.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = output-var-2.
END.

ON "LEAVE":U OF ITEM-gre.CodMat 
DO:
    IF s-local-new-record = 'NO' THEN RETURN.
    DEF VAR s-Ok AS LOG.

   IF ITEM-gre.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN RETURN.

   DEF VAR pCodMat AS CHAR NO-UNDO.
   pCodMat = SELF:SCREEN-VALUE.
   RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
   IF pCodMat = '' THEN RETURN NO-APPLY.
   SELF:SCREEN-VALUE = pCodMat.
   s-CodArt = pCodMat.
   /*S-CODART = STRING(INTEGER(ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}),"999999").*/
   /*ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = S-CODART.*/
   FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
                  AND  Almmmate.CodAlm = S-CODALM 
                  AND  Almmmate.CodMat = S-CODART 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almmmate THEN DO:
      MESSAGE "Material no asignado a este Almacen" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO ITEM-gre.CodMat.
      RETURN NO-APPLY.   
   END.

  /**** Busca el stock del almacen despacho  ****/
  stkdes = 0.
  SW = FALSE.
  IF S-CODALM = "11" OR S-CODALM = "83" THEN DO:
    IF S-CODALM = "11" AND C-CODALM = "83" THEN SW = TRUE. 
    ELSE 
    IF S-CODALM = "83" AND C-CODALM <> "11" THEN SW = TRUE.
  END.

  IF SW THEN DO:
      FIND B-Almmmate WHERE B-Almmmate.CodCia = S-CODCIA 
                       AND  B-Almmmate.codmat = SELF:SCREEN-VALUE 
                       AND  B-Almmmate.CodAlm = C-CODALM 
                      NO-LOCK NO-ERROR.
      IF AVAILABLE B-Almmmate THEN stkdes = B-Almmmate.StkAct.
  END.
   
   /*DISPLAY Almmmate.StkAct @ Almmmate.StkAct WITH BROWSE {&BROWSE-NAME}.*/
   FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                  AND  Almmmatg.CodMat = S-CODART 
                 NO-LOCK NO-ERROR.
   IF AVAILABLE Almmmatg THEN DO:

      /* Ic - 26Set2018, correo sr juan ponte/harold segura, no permitir articulos sin pesos ni volumenes */
      FIND FIRST almtfami OF almmmatg NO-LOCK NO-ERROR.
      IF AVAILABLE almtfami AND almtfami.swcomercial = YES THEN DO:
          IF almmmatg.pesmat <= 0 OR almmmatg.libre_d02 <= 0  THEN DO:
              MESSAGE "Articulo NO tiene Peso y/o Volumen" VIEW-AS ALERT-BOX ERROR.
              APPLY "ENTRY" TO ITEM-gre.CodMat.
              RETURN NO-APPLY.
          END.
      END.

      IF Almmmatg.TpoArt <> "A" THEN DO:
         MESSAGE "Articulo no Activo" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO ITEM-gre.CodMat.
         RETURN NO-APPLY.
      END.
   
      ASSIGN S-UndBas   = Almmmatg.UndBas.
      ASSIGN S-UndStk   = Almmmatg.UndStk.
      DISPLAY Almmmatg.DesMat @ Almmmate.DesMat 
              Almmmatg.DesMar @ Almmmatg.DesMar
              WITH BROWSE {&BROWSE-NAME}.
      DISPLAY Almmmatg.UndStk @ ITEM-gre.CodUnd WITH BROWSE {&BROWSE-NAME}.
      F-Equivale = 1.
   END.      
   ELSE DO:
        MESSAGE "Articulo no registrado"
                VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO ITEM-gre.CodMat.
        RETURN NO-APPLY.
   END.

   FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
                  AND  Almtconv.Codalter = Almmmatg.UndStk
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almtconv THEN DO:
      MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   F-Equivale = Almtconv.Equival /* / Almmmatg.FacEqu*/.
   /*
   /*RUN lkup/c-uniofi ('Unidades de Venta', almmmate.codmat, OUTPUT s-Ok).*/
   RUN gn/c-uniofi ('Unidades de Venta', almmmate.codmat, OUTPUT s-Ok).
   IF s-Ok = NO THEN DO:
    SELF:SCREEN-VALUE = ''.
    RETURN NO-APPLY.
   END.
   */
END.

ON "LEAVE":U OF ITEM-gre.CodUnd
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                  AND  Almmmatg.codmat = S-CODART 
                  NO-LOCK NO-ERROR.
   FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
                  AND  Almtconv.Codalter = SELF:SCREEN-VALUE
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almtconv THEN DO:
      MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   F-Equivale = Almtconv.Equival /* / Almmmatg.FacEqu*/.
END.

ON "LEAVE":U OF ITEM-gre.CanDes
DO:
    ASSIGN
        s-CodArt = ITEM-gre.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    FIND FIRST Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
        AND Almmmatg.codmat = S-CODART NO-LOCK NO-ERROR.
    ASSIGN 
        S-UndBas   = Almmmatg.UndBas
        S-UndStk   = ITEM-gre.CodUnd:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    FIND FIRST Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
        AND Almtconv.Codalter = S-UNDSTK NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
/*         RETURN NO-APPLY.*/
    END.
    ASSIGN
        F-Equivale = Almtconv.Equival.
/*     IF (Almtconv.CodUnid = "Und" OR Almtconv.CodUnid = "UNI" )                                                                          */
/*             AND Almtconv.Equival = 1 THEN DO:                                                                                           */
/*        IF DECIMAL(ITEM.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <> INT(ITEM.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) THEN DO: */
/*           MESSAGE " Venta en Unidades, Cantidad " SKIP                                                                                  */
/*                   " no debe Tener Decimales. " VIEW-AS ALERT-BOX ERROR.                                                                 */
/*           RETURN NO-APPLY.                                                                                                              */
/*        END.                                                                                                                             */
/*     END.                                                                                                                                */
END.



/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
0&ENDIF

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importar-desde-excel B-table-Win 
PROCEDURE importar-desde-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
  IF s-AlmDes = '' THEN DO:
      MESSAGE 'Debe ingresar primero al ALMACEN DESTINO'
          VIEW-AS ALERT-BOX WARNING.
      RETURN "ADM-ERROR".
  END.
*/
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.

/* SOLICITAR EL ARCHIVO DE EXCEL */
DEF VAR pFileName AS CHAR NO-UNDO.
DEF VAR pLogical  AS LOG NO-UNDO.

SYSTEM-DIALOG GET-FILE pFileName
    FILTERS "*.xls *.xlsx" "*.xls,*.xlsx"
    RETURN-TO-START-DIR
    TITLE "Seleccione el archivo Excel"
    UPDATE pLogical.
IF plogical = NO THEN RETURN.
IF SEARCH(pFileName) = ? THEN DO:
    MESSAGE 'Archivo no existe' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

/* Datos a recuperar */
DEFINE VARIABLE cCampo1 AS CHAR NO-UNDO.
DEFINE VARIABLE cCampo2 AS DECIMAL   NO-UNDO.
DEFINE VARIABLE iNumLinea AS INTEGER NO-UNDO.
DEFINE VARIABLE iError AS INTEGER NO-UNDO.
DEFINE VARIABLE cError AS CHARACTER NO-UNDO.
DEFINE VARIABLE lProcesar AS LOGICAL NO-UNDO.

DEFINE VAR dPeso AS DEC.

iError = 1.
cError = "Error indeterminado, no se ha importado".

    CREATE "Excel.Application" chExcelApplication.

    chWorkbook = chExcelApplication:Workbooks:OPEN(pFileName) NO-ERROR.
    /* Seleccionamos la 1ra. hoja solamente */
    chWorkSheet = chExcelApplication:Sheets:ITEM(1) NO-ERROR.
    /* Comprobamos que las hojas no esten en blanco */
    IF (chWorkSheet:Cells(1,1):VALUE = ? OR chWorkSheet:Cells(1,1):VALUE = '') THEN DO:
        iError = 2.
        cError = "El Excel está en blanco".
        lProcesar = FALSE.
    END.
    ELSE DO:
        iNumLinea = 1.
        lProcesar = TRUE.
        BLOQUE:
        REPEAT WHILE lProcesar:
            /* Aumentar la linea */
            iNumLinea = iNumLinea + 1.
            /* ***************** */
            ASSIGN
                cCampo1 = STRING (chWorkSheet:Cells(iNumLinea,1):VALUE, '999999')
                cCampo2 = DECIMAL (chWorkSheet:Cells(iNumLinea,2):VALUE).
            IF cCampo1 = ? OR cCampo1 = "" THEN DO:
                lProcesar = FALSE.
                iNumLinea = iNumLinea - 2.
            END.
            ELSE DO:
                /* PROCESAR INFORMACION */
                FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia
                    AND Almmmatg.codmat = cCampo1
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE Almmmatg THEN DO:
                    MESSAGE "Material " + cCampo1 + " NO registrado en el catálogo"
                        VIEW-AS ALERT-BOX WARNING.
                    NEXT BLOQUE.
                END.
                
                IF s-almdes > "" THEN DO:
                    FIND almmmate WHERE almmmate.codcia = s-codcia
                        AND Almmmate.codalm = s-almdes
                        AND almmmate.codmat = cCampo1
                        NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE Almmmate THEN DO:
                        MESSAGE 'Código ' + cCampo1 + ' NO asignado al almacén ' + s-almdes
                            VIEW-AS ALERT-BOX WARNING.
                        NEXT BLOQUE.
                    END.
                END.
                FIND almmmate WHERE almmmate.codcia = s-codcia
                    AND Almmmate.codalm = s-codalm
                    AND almmmate.codmat = cCampo1
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE Almmmate THEN DO:
                    MESSAGE 'Código ' + cCampo1 + ' NO asignado al almacén ' +  s-codalm
                        VIEW-AS ALERT-BOX WARNING.
                    NEXT BLOQUE.
                END.
                FIND FIRST ITEM-gre WHERE ITEM-gre.codmat = cCampo1 NO-LOCK NO-ERROR.
                IF AVAILABLE ITEM-gre THEN DO:
                    MESSAGE "Material " + cCampo1 + " YA registrado"
                        VIEW-AS ALERT-BOX WARNING.
                    NEXT BLOQUE.
                END.
                CREATE ITEM-gre.
                ASSIGN 
                    ITEM-gre.CodMat = CAPS(cCampo1)
                    ITEM-gre.CanDes = cCampo2
                    ITEM-gre.Factor = 1
                    /*ITEM-gre.CodCia = S-CODCIA */
                    ITEM-gre.CodAlm = S-CODALM
                    /*ITEM-gre.TipMov = s-TipMov*/
                    ITEM-gre.CodUnd = Almmmatg.UndBas
                    ITEM-gre.peso_unitario = Almmmatg.pesmat
                    ITEM-gre.peso_total_item = (ITEM-gre.CanDes * ITEM-gre.Factor) * Almmmatg.pesmat NO-ERROR.
            END.
        END.
        /* Todo Correcto */
        iError = 0.
        cError = "Lineas Procesadas: " + STRING(iNumLinea).
    END.
    chWorkBook:CLOSE(FALSE,,) NO-ERROR. /* cierra archivo sin grabar cambios */
    chExcelApplication:QUIT NO-ERROR.
    RELEASE OBJECT chWorkSheet no-error.
    RELEASE OBJECT chWorkBook no-error.
    RELEASE OBJECT chExcelApplication no-error.
    chExcelApplication = ?.
    chWorkBook = ?.
    chWorkSheet = ?.

/* Limpieza final */
dPeso = 0.
FOR EACH ITEM-gre, FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND
    Almmmatg.codmat = ITEM-gre.codmat:
    IF ITEM-gre.CanDes <= 0 OR ITEM-gre.CanDes = ? THEN DO:
        DELETE ITEM-gre.
        NEXT.
    END.
    FIND FIRST Unidades WHERE Unidades.Codunid = Almmmatg.UndBas NO-LOCK NO-ERROR.
    IF AVAILABLE Unidades AND Unidades.Libre_l02 = YES THEN DO:
        IF ITEM-gre.CanDes <> INTEGER(ITEM-gre.CanDes) THEN DO:
            DELETE ITEM-gre.
            NEXT.
        END.
    END.
    dPeso = dPeso + ITEM-gre.peso_total_item.
END.

RUN actualiza-peso IN lh_handle.

MESSAGE cError. 
RUN dispatch IN THIS-PROCEDURE ('open-query').


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
  /*
  IF ORDTRB <> "" THEN DO:
    MESSAGE "NO AUTORIZADO PARA ADICIONAR ITEMS ....."  VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
   
  /* Code placed here will execute AFTER standard behavior.    */
  s-local-new-record = 'YES'.

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
  ASSIGN ITEM-gre.Factor = F-Equivale
         /*ITEM.CodCia = S-CODCIA */
         ITEM-gre.CODALM = S-CODALM
         ITEM-gre.CodUnd = ITEM-gre.CodUnd:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = ITEM-gre.CodMat:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmatg THEN DO:

      ASSIGN ITEM-gre.peso_unitario = almmmatg.pesmat
            ITEM-gre.peso_total_item = (DEC(ITEM-gre.Candes:SCREEN-VALUE) * F-Equivale) * almmmatg.pesmat.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record B-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  s-local-new-record = 'NO'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

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
  IF RETURN-VALUE = 'YES' 
  THEN DO:
      ITEM-gre.codmat:READ-ONLY IN BROWSE {&browse-name} = NO.
      /*APPLY 'ENTRY':U TO ITEM.codmat IN BROWSE {&browse-name}.*/
  END.
  ELSE DO:
      ITEM-gre.codmat:READ-ONLY IN BROWSE {&browse-name} = YES.
      APPLY 'ENTRY':U TO ITEM-gre.candes IN BROWSE {&browse-name}.
  END.

  RUN mueve-stock IN lh_handle(OUTPUT lMueveStock).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update B-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  RUN actualiza-peso IN lh_handle.

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
        WHEN "CodMat" THEN ASSIGN input-var-1 = S-CodAlm.
        WHEN "CodUnd" THEN ASSIGN input-var-1 = S-UndBas.
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
  {src/adm/template/snd-list.i "ITEM-gre"}
  {src/adm/template/snd-list.i "Almmmate"}
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
  
  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
     
  END.
  
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
    DEF VAR s-Ok AS LOG.
    DEF VAR s-StkDis AS DEC.

IF ITEM-gre.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
   MESSAGE "Codigo de articulo en blanco" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY" TO ITEM-gre.CodMat.
   RETURN "ADM-ERROR".   
END.
IF DECIMAL(ITEM-gre.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <= 0 THEN DO:
   MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY" TO ITEM-gre.CanDes.
   RETURN "ADM-ERROR".   
END.
IF ITEM-gre.CodUnd:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
   MESSAGE "Codigo de Unidad no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY" TO ITEM-gre.CodUnd.
   RETURN "ADM-ERROR".
END.
FIND FIRST DMOV WHERE /*DMOV.Codcia  = S-CODCIA AND*/
     DMOV.CodAlm = S-CODALM AND
     DMOV.CodMat = ITEM-gre.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
     NO-LOCK NO-ERROR.
IF AVAILABLE DMOV AND ROWID(DMOV) <> ROWID(ITEM-gre) THEN DO:
   MESSAGE "Codigo ya esta registrado" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY" TO ITEM-gre.CodMat.
   RETURN "ADM-ERROR".   
END. 

FIND FIRST Almmmate WHERE Almmmate.CodCia = S-CodCia AND
     Almmmate.CodAlm = S-CodAlm AND
     Almmmate.CodMat = ITEM-gre.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmate /*OR 
   (Almmmate.StkAct - DECIMAL(ITEM-gre.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) ) < 0*/ THEN DO:
   /* 
   IF NOT AVAILABLE Almmmate THEN 
      MESSAGE "Articulo no esta asignado al almacen " S-CodAlm VIEW-AS ALERT-BOX ERROR.   
   ELSE MESSAGE "No hay Stock en almacen " S-CodAlm VIEW-AS ALERT-BOX ERROR.
   */
   MESSAGE "Articulo no esta asignado al almacen " S-CodAlm VIEW-AS ALERT-BOX ERROR.   
   APPLY "ENTRY" TO ITEM-gre.CanDes.
   RETURN "ADM-ERROR".   
END. 

IF lMueveStock THEN DO:

   IF (Almmmate.StkAct - DECIMAL(ITEM-gre.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) ) < 0 THEN DO:
        MESSAGE "No hay Stock en almacen " S-CodAlm VIEW-AS ALERT-BOX INFORMATION.
        APPLY "ENTRY" TO ITEM-gre.CanDes.
        RETURN "ADM-ERROR".   
   END.

    /* RHC 11.01.10 nueva rutina */
    DEF VAR pComprometido AS DEC.
    RUN gn/stock-comprometido (Almmmate.codmat, Almmmate.codalm, OUTPUT pComprometido).
    /* CONSISTENCIA NORMAL */
    IF DECIMAL(ITEM-gre.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) *  f-Equivale > (Almmmate.stkact - pComprometido)
        THEN DO:
        MESSAGE 'NO se puede sacar mas de' (Almmmate.stkact - pComprometido)
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO ITEM-gre.CanDes.
        RETURN "ADM-ERROR".
    END.
END.

   FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                  AND  Almmmatg.CodMat = ITEM-gre.CodMat:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF AVAILABLE Almmmatg THEN DO:

      /* Ic - 26Set2018, correo sr juan ponte/harold segura, no permitir articulos sin pesos ni volumenes */
      /* Para GRE se retira 
      FIND FIRST almtfami OF almmmatg NO-LOCK NO-ERROR.
      IF AVAILABLE almtfami AND almtfami.swcomercial = YES THEN DO:
          IF almmmatg.pesmat <= 0 OR almmmatg.libre_d02 <= 0  THEN DO:
              MESSAGE "Articulo NO tiene Peso y/o Volumen" VIEW-AS ALERT-BOX ERROR.
              APPLY "ENTRY" TO ITEM-gre.CodMat.
              RETURN "ADM-ERROR".
          END.
      END.
      */
       IF almmmatg.pesmat <= 0 OR almmmatg.libre_d02 <= 0  THEN DO:
           MESSAGE "Articulo NO tiene Peso y/o Volumen" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO ITEM-gre.CodMat.
           RETURN "ADM-ERROR".
       END.

      IF Almmmatg.TpoArt <> "A" THEN DO:
         MESSAGE "Articulo no Activo" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO ITEM-gre.CodMat.
         RETURN "ADM-ERROR".
      END.
   
      ASSIGN S-UndBas   = Almmmatg.UndBas.
      ASSIGN S-UndStk   = Almmmatg.UndStk.
      F-Equivale = 1.
   END.      
   ELSE DO:
        MESSAGE "Articulo no registrado".
        APPLY "ENTRY" TO ITEM-gre.CodMat.
        RETURN "ADM-ERROR".   
   END.


RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-UpDate B-table-Win 
PROCEDURE Valida-UpDate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* MESSAGE 'Acceso denegado' SKIP              */
/*     'Elimine la linea y vuelva a digitarla' */
/*     VIEW-AS ALERT-BOX ERROR.                */
/* RETURN 'ADM-ERROR'.                         */

ASSIGN F-Equivale = ITEM-gre.Factor.
FIND FIRST Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
     Almmmatg.codmat = ITEM-gre.codmat NO-LOCK NO-ERROR.
ASSIGN S-UndBas = Almmmatg.UndBas.
s-local-new-record = 'NO'.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

