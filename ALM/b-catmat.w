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

DEF SHARED VAR s-codcia AS INT.

DEF STREAM REPORTE.

DEF SHARED VAR s-codfam AS CHAR.
DEF SHARED VAR s-Parametro AS CHAR.

DEF BUFFER b-matg FOR Almmmatg.
DEFINE BUFFER b-mat1 FOR almmmat1.

DEF VAR x-Familias AS CHAR.

x-Familias = ''.
FOR EACH Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia:
    CASE s-Parametro:
        WHEN '+' THEN DO:
            IF LOOKUP(Almtfami.codfam, s-codfam) = 0 THEN NEXT.
        END.
        WHEN '-' THEN DO:
            IF LOOKUP(Almtfami.codfam, s-codfam) > 0 THEN NEXT.
        END.
    END CASE.
    IF x-Familias = '' THEN x-Familias = TRIM(Almtfami.codfam).
    ELSE x-Familias = x-Familias + ',' + TRIM(Almtfami.codfam).
END.

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
&Scoped-define INTERNAL-TABLES almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table almmmatg.codmat almmmatg.DesMat ~
almmmatg.UndBas almmmatg.CodBrr almmmatg.DesMar 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table almmmatg.CodBrr 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table almmmatg
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table almmmatg
&Scoped-define QUERY-STRING-br_table FOR EACH almmmatg WHERE ~{&KEY-PHRASE} ~
      AND almmmatg.CodCia = s-codcia ~
 /*AND almmmatg.TpoArt <> "D"*/ ~
 AND LOOKUP(almmmatg.codfam, x-familias) > 0 NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH almmmatg WHERE ~{&KEY-PHRASE} ~
      AND almmmatg.CodCia = s-codcia ~
 /*AND almmmatg.TpoArt <> "D"*/ ~
 AND LOOKUP(almmmatg.codfam, x-familias) > 0 NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table almmmatg


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
      almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      almmmatg.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U WIDTH 7
      almmmatg.DesMat FORMAT "X(45)":U WIDTH 30.43
      almmmatg.UndBas COLUMN-LABEL "Unidad" FORMAT "X(6)":U WIDTH 9
      almmmatg.CodBrr COLUMN-LABEL "EAN 13" FORMAT "X(13)":U WIDTH 14.86
      almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U
  ENABLE
      almmmatg.CodBrr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 87 BY 15.96
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
         HEIGHT             = 16.19
         WIDTH              = 88.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}
{src/bin/_prns.i}

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
     _TblList          = "INTEGRAL.almmmatg"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "almmmatg.CodCia = s-codcia
 /*AND almmmatg.TpoArt <> ""D""*/
 AND LOOKUP(almmmatg.codfam, x-familias) > 0"
     _FldNameList[1]   > INTEGRAL.almmmatg.codmat
"almmmatg.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.almmmatg.DesMat
"almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "30.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.almmmatg.UndBas
"almmmatg.UndBas" "Unidad" "X(6)" "character" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.almmmatg.CodBrr
"almmmatg.CodBrr" "EAN 13" "X(13)" "character" ? ? ? ? ? ? yes ? no no "14.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.almmmatg.DesMar
"almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Barras B-table-Win 
PROCEDURE Imprime-Barras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER x-Tipo   AS INT.
  DEF INPUT PARAMETER x-Barras AS INT.
  DEF INPUT PARAMETER x-Copias AS INT.
  DEF INPUT PARAMETER x-Size   AS CHAR.
  
  DEF VAR rpta AS LOG.
  DEF VAR x-Desmat AS CHAR FORMAT 'x(90)'.
  
  FIND FIRST Almmmat1 OF Almmmatg NO-LOCK NO-ERROR.
  
  IF x-Tipo = 2 
  THEN DO:
    IF x-Barras = 1 AND Almmmatg.CodBrr = '' THEN RETURN.
    IF x-Barras = 1 AND LENGTH(TRIM(Almmmatg.codbrr)) <> 13 THEN RETURN.
    IF x-Barras > 1 THEN DO:
        IF NOT AVAILABLE Almmmat1 THEN RETURN.
        IF Almmmat1.Barras[x-Barras - 1] = '' THEN RETURN.
        /*IF LENGTH(TRIM(Barras[x-Barras - 1])) <> 14 THEN RETURN.*/
    END.
  END.
  
  SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
  IF rpta = NO THEN RETURN.
  OUTPUT STREAM REPORTE TO PRINTER.

  IF x-Barras = 1 THEN DO:          /* EAN 13 */
    PUT STREAM REPORTE '^XA^LH000,012'               SKIP.   /* Inicia formato */
    {alm/ean13.i}
  
    PUT STREAM REPORTE '^LH210,012'                  SKIP.   /* Inicia formato */
    {alm/ean13.i}
  
    PUT STREAM REPORTE '^LH420,012'                  SKIP.   /* Inicia formato */
    {alm/ean13.i}
    
    PUT STREAM REPORTE '^LH630,012'                  SKIP.   /* Inicia formato */
    {alm/ean13.i}
    
    PUT STREAM REPORTE '^PQ' + TRIM(STRING(x-Copias)) SKIP.  /* Cantidad a imprimir */
    PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
    PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */
  END.
  ELSE DO:                          /* EAN 14 */
      x-DesMat = TRIM(SUBSTRING(Almmmatg.Desmat,1,80)) + ' ' + 
                      SUBSTRING(Almmmatg.Desmar,1,26).

      IF x-Size = "Grande" THEN DO:          
          PUT STREAM REPORTE '^XA^LH000,012'                 SKIP.   /* Inicio de formato */
          PUT STREAM REPORTE '^FO60,15'                      SKIP.   /* Coordenadas de origen campo1 */
          PUT STREAM REPORTE '^A0N,25,15'                    SKIP.
          PUT STREAM REPORTE '^FD'.
          PUT STREAM REPORTE x-DesMat                        SKIP.
          PUT STREAM REPORTE '^FS'                           SKIP.   /* Fin de Campo1 */
          PUT STREAM REPORTE '^FO60,40'                      SKIP.   /* Coordenadas de origen barras */
          IF x-Tipo = 1 THEN DO:
              PUT STREAM REPORTE '^BCN,100,Y,N,N'            SKIP.   /* Codigo 128 */
              PUT STREAM REPORTE '^FD'.
              PUT STREAM REPORTE Almmmatg.Codmat FORMAT 'x(6)' SKIP.
              PUT STREAM REPORTE '^FS'                       SKIP.   /* Fin de Campo2 */
          END.
          ELSE DO:
              PUT STREAM REPORTE '^BY3^BCN,100,Y,N,N'        SKIP.   /* Codigo 128 */
              PUT STREAM REPORTE '^FD'.
              PUT STREAM REPORTE Barras[x-Barras - 1] FORMAT 'x(14)' SKIP.
              PUT STREAM REPORTE '^FS'                       SKIP.   /* Fin de Campo2 */
          END.
          PUT STREAM REPORTE '^PQ' + TRIM(STRING(x-Copias)) SKIP.  /* Cantidad a imprimir */
          PUT STREAM REPORTE '^PR' + '6'                   SKIP.   /* Velocidad de impresion Pulg/seg */
          PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */
      END.
      ELSE DO:
          PUT STREAM REPORTE '^XA^LH000,012'               SKIP.   /* Inicia formato */
          {alm/ean13-2.i}

          PUT STREAM REPORTE '^LH210,012'                  SKIP.   /* Inicia formato */
          {alm/ean13-2.i}

          PUT STREAM REPORTE '^LH420,012'                  SKIP.   /* Inicia formato */
          {alm/ean13-2.i}

          PUT STREAM REPORTE '^LH630,012'                  SKIP.   /* Inicia formato */
          {alm/ean13-2.i}

          PUT STREAM REPORTE '^PQ' + TRIM(STRING(x-Copias)) SKIP.  /* Cantidad a imprimir */
          PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
          PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */
      END.
  END.

  OUTPUT STREAM REPORTE CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Barras-2 B-table-Win 
PROCEDURE Imprime-Barras-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER x-Tipo   AS INT.
  DEF INPUT PARAMETER x-Barras AS INT.
  DEF INPUT PARAMETER x-Copias AS INT.
  DEF INPUT PARAMETER x-Size   AS CHAR.
  
  DEF VAR rpta AS LOG.
  DEF VAR x-Desmat AS CHAR FORMAT 'x(90)'.
  
  FIND FIRST Almmmat1 OF Almmmatg NO-LOCK NO-ERROR.
  
  IF x-Tipo = 2 THEN DO:
    IF x-Barras = 1 AND Almmmatg.CodBrr = '' THEN RETURN.
    IF x-Barras = 1 AND LENGTH(TRIM(Almmmatg.codbrr)) <> 13 THEN RETURN.
    IF x-Barras > 1 THEN DO:
        IF NOT AVAILABLE Almmmat1 THEN RETURN.
        IF Almmmat1.Barras[x-Barras - 1] = '' THEN RETURN.
        /*IF LENGTH(TRIM(Barras[x-Barras - 1])) <> 14 THEN RETURN.*/
    END.
  END.
  
  SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
  IF rpta = NO THEN RETURN.
  OUTPUT STREAM REPORTE TO PRINTER.

  IF x-Barras = 1 THEN DO:          /* EAN 13 NO interesa la variable x-Size */
    PUT STREAM REPORTE '^XA^LH000,012'               SKIP.   /* Inicia formato */
    {alm/ean13.i}
  
    PUT STREAM REPORTE '^LH210,012'                  SKIP.   /* Inicia formato */
    {alm/ean13.i}
  
    PUT STREAM REPORTE '^LH420,012'                  SKIP.   /* Inicia formato */
    {alm/ean13.i}
    
    PUT STREAM REPORTE '^LH630,012'                  SKIP.   /* Inicia formato */
    {alm/ean13.i}
    
    PUT STREAM REPORTE '^PQ' + TRIM(STRING(x-Copias)) SKIP.  /* Cantidad a imprimir */
    PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
    PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */
  END.
  ELSE DO:                          /* EAN 14 */
      /* Determinamos si es un EAN 13 */
      IF LENGTH(TRIM(Barras[x-Barras - 1])) = 13 THEN DO:
          PUT STREAM REPORTE '^XA^LH000,012'               SKIP.   /* Inicia formato */
          {alm/ean13-3.i}

          PUT STREAM REPORTE '^LH210,012'                  SKIP.   /* Inicia formato */
          {alm/ean13-3.i}

          PUT STREAM REPORTE '^LH420,012'                  SKIP.   /* Inicia formato */
          {alm/ean13-3.i}

          PUT STREAM REPORTE '^LH630,012'                  SKIP.   /* Inicia formato */
          {alm/ean13-3.i}

          PUT STREAM REPORTE '^PQ' + TRIM(STRING(x-Copias)) SKIP.  /* Cantidad a imprimir */
          PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
          PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */
      END.
      ELSE DO:
          /* Aca Imprime el EAN 14 */
          x-DesMat = TRIM(SUBSTRING(Almmmatg.Desmat,1,80)) + ' ' + 
                          SUBSTRING(Almmmatg.Desmar,1,26).

          IF x-Size = "Grande" THEN DO:          
              /* Formato EAN 14 Grande */
              /*
              x-DesMat = "CODIGO: " + STRING(Almmmatg.codmat, 'x(6)') + ' ' +
                  SUBSTRING( TRIM(SUBSTRING(Almmmatg.Desmat,1,80)) + ' ' + 
                             TRIM(Almmmatg.Desmar), 1, 98 ).
              */
              x-DesMat = SUBSTRING( TRIM(SUBSTRING(Almmmatg.Desmat,1,80)) + ' ' + 
                             TRIM(Almmmatg.Desmar), 1, 98 ).

              PUT STREAM REPORTE '^XA^LH000,012'                 SKIP.   /* Inicio de formato */
              {alm/ean13-1.i}
          END.
          ELSE DO:
              PUT STREAM REPORTE '^XA^LH000,012'               SKIP.   /* Inicia formato */
              {alm/ean13-2.i}

              PUT STREAM REPORTE '^LH210,012'                  SKIP.   /* Inicia formato */
              {alm/ean13-2.i}

              PUT STREAM REPORTE '^LH420,012'                  SKIP.   /* Inicia formato */
              {alm/ean13-2.i}

              PUT STREAM REPORTE '^LH630,012'                  SKIP.   /* Inicia formato */
              {alm/ean13-2.i}

              PUT STREAM REPORTE '^PQ' + TRIM(STRING(x-Copias)) SKIP.  /* Cantidad a imprimir */
              PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
              PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */
          END.
      END.
  END.

  OUTPUT STREAM REPORTE CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime-barras-rack B-table-Win 
PROCEDURE imprime-barras-rack :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER x-Tipo   AS INT.
  DEF INPUT PARAMETER x-Barras AS INT.
  DEF INPUT PARAMETER x-Copias AS INT.
  DEF INPUT PARAMETER x-Size   AS CHAR.
  
  DEF VAR rpta AS LOG.
  DEF VAR x-Desmat AS CHAR FORMAT 'x(90)'.


  IF x-barras = 1 THEN RETURN.
  
  FIND FIRST Almmmat1 OF Almmmatg NO-LOCK NO-ERROR.
  
  IF x-Tipo = 2 THEN DO:
    IF x-Barras = 1 AND Almmmatg.CodBrr = '' THEN RETURN.
    IF x-Barras = 1 AND LENGTH(TRIM(Almmmatg.codbrr)) <> 13 THEN RETURN.
    IF x-Barras > 1 THEN DO:
        IF NOT AVAILABLE Almmmat1 THEN RETURN.
        IF Almmmat1.Barras[x-Barras - 1] = '' THEN RETURN.
        /*IF LENGTH(TRIM(Barras[x-Barras - 1])) <> 14 THEN RETURN.*/
    END.
  END.
  
  SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
  IF rpta = NO THEN RETURN.
  OUTPUT STREAM REPORTE TO PRINTER.

  /* Aca Imprime el EAN 14 */

  x-DesMat = SUBSTRING( TRIM(SUBSTRING(Almmmatg.Desmat,1,80)) + ' ' + 
             TRIM(Almmmatg.Desmar), 1, 98 ).

  PUT STREAM REPORTE '^XA^LH000,012'                 SKIP.   /* Inicio de formato */
/*  {alm/ean13-1.i}*/

  /* Codigo Interno Vertical */
  PUT STREAM REPORTE '^FO60,15'                      SKIP.   /* Coordenadas de origen barras */
  PUT STREAM REPORTE '^AUR,15,10'                    SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE Almmmatg.Codmat FORMAT 'x(6)' SKIP.
  PUT STREAM REPORTE '^FS'                           SKIP.   /* Fin de Campo1 */

/* Codigo de Barras EAN14 */
  PUT STREAM REPORTE '^FO140,15'                      SKIP.   /* Coordenadas de origen barras */
  /*PUT STREAM REPORTE '^BY3^BCN,100,N,N,N'        SKIP.   /* Codigo 128 */*/
  PUT STREAM REPORTE '^BY3^BCN,100,N,N,N'        SKIP.   /* Codigo 128 */
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE Barras[x-Barras - 1] FORMAT 'x(14)' SKIP.
  PUT STREAM REPORTE '^FS'                       SKIP.   /* Fin de Campo2 */

  PUT STREAM REPORTE '^FO120,130'                      SKIP.   /* Coordenadas de origen campo1 */
  /*PUT STREAM REPORTE '^A0N,25,15'                    SKIP.*/
  PUT STREAM REPORTE '^ADN,30,15'                    SKIP.  
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE x-DesMat                        SKIP.
  PUT STREAM REPORTE '^FS'                           SKIP.   /* Fin de Campo1 */

  PUT STREAM REPORTE '^FS'                       SKIP.   /* Fin de Campo2 */
  PUT STREAM REPORTE '^PQ' + TRIM(STRING(x-Copias)) SKIP.  /* Cantidad a imprimir */
  PUT STREAM REPORTE '^PR' + '6'                   SKIP.   /* Velocidad de impresion Pulg/seg */
  PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */


  OUTPUT STREAM REPORTE CLOSE.


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
  DEF VAR pError AS CHAR NO-UNDO.

  RUN gn/verifica-ean-repetido ( 'EAN13',
                                 0,
                                 Almmmatg.codmat,
                                 Almmmatg.codbrr,
                                 OUTPUT pError).
  IF pError > '' THEN DO:
      MESSAGE pError VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO Almmmatg.codbrr IN BROWSE {&BROWSE-NAME}.
      UNDO, RETURN 'ADM-ERROR'.
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

  BUSCA:
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    RUN lkup/c-almmtg ("Catalogo").
    IF OUTPUT-VAR-1 <> ? THEN DO:
        /*
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
          IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
          */
         IF CAN-FIND({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK) THEN DO:
            REPOSITION {&BROWSE-NAME} TO ROWID OUTPUT-VAR-1 NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                MESSAGE 'Código fuera del filtro actual' VIEW-AS ALERT-BOX ERROR.
                LEAVE BUSCA.
            END.
            RUN dispatch IN THIS-PROCEDURE ('row-changed':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Parche B-table-Win 
PROCEDURE Parche :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER x-Tipo   AS INT.
  DEF INPUT PARAMETER x-Barras AS INT.
  DEF INPUT PARAMETER x-Copias AS INT.
  DEF INPUT PARAMETER x-Size   AS CHAR.
  
  DEF VAR rpta AS LOG.
  DEF VAR x-Desmat AS CHAR FORMAT 'x(90)'.
  
  FIND FIRST Almmmat1 OF Almmmatg NO-LOCK NO-ERROR.
  
  IF x-Tipo = 2 
  THEN DO:
    IF x-Barras = 1 AND Almmmatg.CodBrr = '' THEN RETURN.
    IF x-Barras = 1 AND LENGTH(TRIM(Almmmatg.codbrr)) <> 13 THEN RETURN.
    IF x-Barras > 1 THEN DO:
        IF NOT AVAILABLE Almmmat1 THEN RETURN.
        IF Almmmat1.Barras[x-Barras - 1] = '' THEN RETURN.
        /*IF LENGTH(TRIM(Barras[x-Barras - 1])) <> 14 THEN RETURN.*/
    END.
  END.
  
  SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
  IF rpta = NO THEN RETURN.
  OUTPUT STREAM REPORTE TO PRINTER.

  IF x-Barras = 1 THEN DO:          /* EAN 13 NO interesa la variable x-Size */
    PUT STREAM REPORTE '^XA^LH000,012'               SKIP.   /* Inicia formato */
    {alm/ean13xx.i}
  
    PUT STREAM REPORTE '^LH210,012'                  SKIP.   /* Inicia formato */
    {alm/ean13xx.i}
  
    PUT STREAM REPORTE '^LH420,012'                  SKIP.   /* Inicia formato */
    {alm/ean13xx.i}
    
    PUT STREAM REPORTE '^LH630,012'                  SKIP.   /* Inicia formato */
    {alm/ean13xx.i}
    
    PUT STREAM REPORTE '^PQ' + TRIM(STRING(x-Copias)) SKIP.  /* Cantidad a imprimir */
    PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
    PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */
  END.
  ELSE DO:                          /* EAN 14 */
      /* Determinamos si es un EAN 13 */
      IF LENGTH(TRIM(Barras[x-Barras - 1])) = 13 THEN DO:
          PUT STREAM REPORTE '^XA^LH000,012'               SKIP.   /* Inicia formato */
          {alm/ean13-3.i}

          PUT STREAM REPORTE '^LH210,012'                  SKIP.   /* Inicia formato */
          {alm/ean13-3.i}

          PUT STREAM REPORTE '^LH420,012'                  SKIP.   /* Inicia formato */
          {alm/ean13-3.i}

          PUT STREAM REPORTE '^LH630,012'                  SKIP.   /* Inicia formato */
          {alm/ean13-3.i}

          PUT STREAM REPORTE '^PQ' + TRIM(STRING(x-Copias)) SKIP.  /* Cantidad a imprimir */
          PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
          PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */
      END.
      ELSE DO:
          x-DesMat = TRIM(SUBSTRING(Almmmatg.Desmat,1,80)) + ' ' + 
                          SUBSTRING(Almmmatg.Desmar,1,26).

          IF x-Size = "Grande" THEN DO:          
              PUT STREAM REPORTE '^XA^LH000,012'                 SKIP.   /* Inicio de formato */
              {alm/ean13-1.i}
          END.
          ELSE DO:
              PUT STREAM REPORTE '^XA^LH000,012'               SKIP.   /* Inicia formato */
              {alm/ean13-2.i}

              PUT STREAM REPORTE '^LH210,012'                  SKIP.   /* Inicia formato */
              {alm/ean13-2.i}

              PUT STREAM REPORTE '^LH420,012'                  SKIP.   /* Inicia formato */
              {alm/ean13-2.i}

              PUT STREAM REPORTE '^LH630,012'                  SKIP.   /* Inicia formato */
              {alm/ean13-2.i}

              PUT STREAM REPORTE '^PQ' + TRIM(STRING(x-Copias)) SKIP.  /* Cantidad a imprimir */
              PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
              PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */
          END.


      END.
  END.

  OUTPUT STREAM REPORTE CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Parche2 B-table-Win 
PROCEDURE Parche2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER x-Tipo   AS INT.
  DEF INPUT PARAMETER x-Barras AS INT.
  DEF INPUT PARAMETER x-Copias AS INT.
  DEF INPUT PARAMETER x-Size   AS CHAR.
  
  DEF VAR rpta AS LOG.
  DEF VAR x-Desmat AS CHAR FORMAT 'x(90)'.
  
  FIND FIRST Almmmat1 OF Almmmatg NO-LOCK NO-ERROR.
  
  IF x-Tipo = 2 
  THEN DO:
    IF x-Barras = 1 AND Almmmatg.CodBrr = '' THEN RETURN.
    IF x-Barras = 1 AND LENGTH(TRIM(Almmmatg.codbrr)) <> 13 THEN RETURN.
    IF x-Barras > 1 THEN DO:
        IF NOT AVAILABLE Almmmat1 THEN RETURN.
        IF Almmmat1.Barras[x-Barras - 1] = '' THEN RETURN.
        /*IF LENGTH(TRIM(Barras[x-Barras - 1])) <> 14 THEN RETURN.*/
    END.
  END.
  
  SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
  IF rpta = NO THEN RETURN.
  OUTPUT STREAM REPORTE TO PRINTER.

  IF x-Barras = 1 THEN DO:          /* EAN 13 NO interesa la variable x-Size */
    PUT STREAM REPORTE '^XA^LH000,012'               SKIP.   /* Inicia formato */
    {alm/ean13x2.i}
  
    PUT STREAM REPORTE '^LH210,012'                  SKIP.   /* Inicia formato */
    {alm/ean13x2.i}
  
    PUT STREAM REPORTE '^LH420,012'                  SKIP.   /* Inicia formato */
    {alm/ean13x2.i}
    
    PUT STREAM REPORTE '^LH630,012'                  SKIP.   /* Inicia formato */
    {alm/ean13x2.i}
    
    PUT STREAM REPORTE '^PQ' + TRIM(STRING(x-Copias)) SKIP.  /* Cantidad a imprimir */
    PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
    PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */
  END.
  ELSE DO:                          /* EAN 14 */
      /* Determinamos si es un EAN 13 */
      IF LENGTH(TRIM(Barras[x-Barras - 1])) = 13 THEN DO:
          PUT STREAM REPORTE '^XA^LH000,012'               SKIP.   /* Inicia formato */
          {alm/ean13-3.i}

          PUT STREAM REPORTE '^LH210,012'                  SKIP.   /* Inicia formato */
          {alm/ean13-3.i}

          PUT STREAM REPORTE '^LH420,012'                  SKIP.   /* Inicia formato */
          {alm/ean13-3.i}

          PUT STREAM REPORTE '^LH630,012'                  SKIP.   /* Inicia formato */
          {alm/ean13-3.i}

          PUT STREAM REPORTE '^PQ' + TRIM(STRING(x-Copias)) SKIP.  /* Cantidad a imprimir */
          PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
          PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */
      END.
      ELSE DO:
          x-DesMat = TRIM(SUBSTRING(Almmmatg.Desmat,1,80)) + ' ' + 
                          SUBSTRING(Almmmatg.Desmar,1,26).

          IF x-Size = "Grande" THEN DO:          
              PUT STREAM REPORTE '^XA^LH000,012'                 SKIP.   /* Inicio de formato */
              {alm/ean13-1.i}
          END.
          ELSE DO:
              PUT STREAM REPORTE '^XA^LH000,012'               SKIP.   /* Inicia formato */
              {alm/ean13-2.i}

              PUT STREAM REPORTE '^LH210,012'                  SKIP.   /* Inicia formato */
              {alm/ean13-2.i}

              PUT STREAM REPORTE '^LH420,012'                  SKIP.   /* Inicia formato */
              {alm/ean13-2.i}

              PUT STREAM REPORTE '^LH630,012'                  SKIP.   /* Inicia formato */
              {alm/ean13-2.i}

              PUT STREAM REPORTE '^PQ' + TRIM(STRING(x-Copias)) SKIP.  /* Cantidad a imprimir */
              PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
              PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */
          END.


      END.
  END.

  OUTPUT STREAM REPORTE CLOSE.

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
  {src/adm/template/snd-list.i "almmmatg"}

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

DEF VAR x-Entero AS DEC.
DEFINE VAR lsec AS INT.

DEFINE VAR lCodsEan14 AS CHAR EXTENT 10.
DEFINE VAR lCodEan13 AS CHAR.

IF almmmatg.CodBrr:SCREEN-VALUE IN BROWSE {&browse-name} <> '' THEN DO:
    /* Ic - 19May2017, a pedido de Martin Salcedo de activo la validacion de 13 digitos */
    IF LENGTH(almmmatg.CodBrr:SCREEN-VALUE IN BROWSE {&browse-name}) <> 13 THEN DO:
        MESSAGE 'El código de barra EAN13 debe tener 13 caracteres'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY' TO almmmatg.CodBrr IN BROWSE {&browse-name}.
        RETURN 'ADM-ERROR'.
    END.
    /* Ic - 19May2017 */

    ASSIGN
        x-Entero = DECIMAL(almmmatg.CodBrr:SCREEN-VALUE IN BROWSE {&browse-name})
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Solo se aceptan valores numéricos' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY' TO almmmatg.CodBrr IN BROWSE {&browse-name}.
        RETURN 'ADM-ERROR'.
    END.

/*     FIND FIRST b-matg WHERE b-matg.codcia = Almmmatg.codcia                               */
/*                 AND b-matg.codbrr = almmmatg.CodBrr:SCREEN-VALUE IN BROWSE {&browse-name} */
/*                 AND b-matg.codmat <> Almmmatg.codmat                                      */
/*         NO-LOCK NO-ERROR.                                                                 */
/*     IF AVAILABLE b-matg THEN DO:                                                          */
/*         MESSAGE 'Código de barra YA registrado en el material' b-matg.codmat              */
/*             VIEW-AS ALERT-BOX WARNING.                                                    */
/*         APPLY 'ENTRY' TO almmmatg.CodBrr IN BROWSE {&browse-name}.                        */
/*         RETURN 'ADM-ERROR'.                                                               */
/*     END.                                                                                  */
/*     /* verificacion del digito verificador */                                             */
/*     DEF VAR X AS CHAR NO-UNDO.                                                            */
/*     DEF VAR Y AS CHAR NO-UNDO.                                                            */
/*     /* Ic - 19May2017, validar que el EAN13 no se repita en los EANs14 */                 */
/*     lCodEan13 = almmmatg.CodBrr:SCREEN-VALUE IN BROWSE {&browse-name}.                    */
/*                                                                                           */
/*     IF lCodEan13 <> '' THEN DO:                                                           */
/*         FIND FIRST b-mat1 WHERE b-mat1.codcia = s-codcia AND                              */
/*                                 b-mat1.codmat = Almmmatg.codmat                           */
/*                                 NO-LOCK NO-ERROR.                                         */
/*         IF AVAILABLE b-mat1 THEN DO:                                                      */
/*             lCodsEan14[1] = b-mat1.Barras[1].                                             */
/*             lCodsEan14[2] = b-mat1.Barras[2].                                             */
/*             lCodsEan14[3] = b-mat1.Barras[3].                                             */
/*             lCodsEan14[4] = b-mat1.Barras[4].                                             */
/*             lCodsEan14[5] = b-mat1.Barras[5].                                             */
/*             /* - */                                                                       */
/*             DO lsec = 1 TO 5:                                                             */
/*                 IF lCodsEan14[lsec] <> '' AND lCodEan13 = lCodsEan14[lsec] THEN DO:       */
/*                     MESSAGE 'Código de barra NO debe ser parte de los EANs14'             */
/*                         VIEW-AS ALERT-BOX WARNING.                                        */
/*                     APPLY 'ENTRY' TO almmmatg.CodBrr IN BROWSE {&browse-name}.            */
/*                     RETURN 'ADM-ERROR'.                                                   */
/*                 END.                                                                      */
/*             END.                                                                          */
/*         END.                                                                              */
/*     END.                                                                                  */
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
CASE s-Parametro:
    WHEN '+' THEN DO:
        IF LOOKUP(Almmmatg.codfam, s-codfam) = 0 THEN DO:
            MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.
    END.
    WHEN '-' THEN DO:
        IF LOOKUP(Almmmatg.codfam, s-codfam) > 0 THEN DO:
            MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.
    END.
END CASE.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

