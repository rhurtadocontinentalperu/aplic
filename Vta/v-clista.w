&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
DEFINE SHARED VAR s-CodCia  AS INT.
DEFINE SHARED VAR s-NomCia  AS CHAR.
DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VAR s-User-Id AS CHAR.

DEFINE VAR s-Copia-Registro AS LOG.
DEFINE TEMP-TABLE T-DACTI LIKE VtaDList.

DEFINE VARIABLE F-PREUSSA AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUSSB AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUSSC AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUSSD AS DECIMAL NO-UNDO.

DEFINE VARIABLE F-PRESOLA AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRESOLB AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRESOLC AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRESOLD AS DECIMAL NO-UNDO.

DEFINE VARIABLE mensaje AS CHARACTER.

DEF SHARED VAR s-coddiv AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES VtaCList
&Scoped-define FIRST-EXTERNAL-TABLE VtaCList


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaCList.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS VtaCList.CodActi VtaCList.DesActi 
&Scoped-define ENABLED-TABLES VtaCList
&Scoped-define FIRST-ENABLED-TABLE VtaCList
&Scoped-Define DISPLAYED-FIELDS VtaCList.CodActi VtaCList.FchActi ~
VtaCList.DesActi VtaCList.Usuario 
&Scoped-define DISPLAYED-TABLES VtaCList
&Scoped-define FIRST-DISPLAYED-TABLE VtaCList


/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     VtaCList.CodActi AT ROW 1.19 COL 15 COLON-ALIGNED
          LABEL "Codigo de Actividad"
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     VtaCList.FchActi AT ROW 1.19 COL 74 COLON-ALIGNED
          LABEL "Fecha de Creacion"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     VtaCList.DesActi AT ROW 2.15 COL 15 COLON-ALIGNED
          LABEL "Descripcion"
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .81
     VtaCList.Usuario AT ROW 2.15 COL 74 COLON-ALIGNED
          LABEL "Ultimo Usuario"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.VtaCList
   Allow: Basic,DB-Fields
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 4.15
         WIDTH              = 94.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN VtaCList.CodActi IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCList.DesActi IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCList.FchActi IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN VtaCList.Usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME VtaCList.CodActi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCList.CodActi V-table-Win
ON LEAVE OF VtaCList.CodActi IN FRAME F-Main /* Codigo de Actividad */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "VtaCList"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaCList"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-1 V-table-Win 
PROCEDURE Formato-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE1
               Almmmatg.codmat  FORMAT "X(6)"
               Almmmatg.DesMat  FORMAT "X(40)"
               Almmmatg.TipArt  FORMAT "X(1)"
               Almmmatg.DesMar  FORMAT "X(10)"
               Almmmatg.UndBas  FORMAT "X(8)"
               Almmmatg.MonVta  FORMAT "9"
               F-PRESOLA        FORMAT ">>>,>>9.9999"
               Almmmatg.UndA    FORMAT "X(8)"
               F-PRESOLB        FORMAT ">>>,>>9.9999"
               Almmmatg.UndB    FORMAT "X(8)"
               F-PRESOLC        FORMAT ">>>,>>9.9999"
               Almmmatg.UndC    FORMAT "X(8)"
               F-PRESOLD        FORMAT ">>>,>>9.9999"
               Almmmatg.Chr__01 FORMAT "X(8)"
              WITH WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         /*{&Prn2} + {&Prn7A} + {&Prn6A} +*/ S-NOMCIA /*+ {&Prn7B} + {&Prn6A} + {&Prn3}*/ FORMAT "X(50)" AT 1 SKIP
         "LISTADO DE PRECIOS" AT 62
         "Pagina :" TO 125 PAGE-NUMBER(REPORT) TO 137 FORMAT "ZZZZZ9" SKIP
         "Fecha  :" TO 125 TODAY TO 137 FORMAT "99/99/9999" SKIP
         "Hora   :" TO 125 STRING(TIME,"HH:MM") TO 137 SKIP
         mensaje FORMAT "X(28)" SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                          PREC. VTA. (A)        PREC. VTA. (B)         PREC. VTA. (C)      PREC. VTA. OFIC." SKIP
        "Codigo D  E  S  C  R  I  P  C  I  O  N          R MARCA      U.B.  MONEDA        S/. UM.              S/.  UM.              S/.   UM.             S/.  UM. " SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        
      WITH PAGE-TOP WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  FOR EACH VtaDList OF VtaCList NO-LOCK,
        EACH Almmmatg OF VtaDList NO-LOCK
                            BREAK BY Almmmatg.CodFam
                                    BY Almmmatg.SubFam
                                    BY Almmmatg.CodMar
                                    BY Almmmatg.TipArt
                                    BY Almmmatg.CodMat:
      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(Almmmatg.CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = Almmmatg.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT "FAMILIA : " Almtfami.codfam '    ' Almtfami.desfam SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
      IF FIRST-OF(Almmmatg.SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = s-CodCia 
                        AND  Almsfami.codfam = Almmmatg.CodFam 
                        AND  Almsfami.subfam = Almmmatg.Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             PUT STREAM REPORT "SUB-FAMILIA : " Almsfami.subfam '   ' AlmSFami.dessub SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
  IF Almmmatg.MonVta = 1 THEN DO:
    F-PRESOLA = Almmmatg.Prevta[2].
    F-PRESOLB = Almmmatg.Prevta[3].
    F-PRESOLC = Almmmatg.Prevta[4].
    F-PRESOLD = IF s-coddiv = '00015' THEN Almmmatg.PreAlt[4] ELSE Almmmatg.PreOfi.

    F-PREUSSA = Almmmatg.Prevta[2] / Almmmatg.TpoCmb.
    F-PREUSSB = Almmmatg.Prevta[3] / Almmmatg.TpoCmb.
    F-PREUSSC = Almmmatg.Prevta[4] / Almmmatg.TpoCmb.
    F-PREUSSD = IF s-coddiv = '00015' THEN Almmmatg.PreAlt[4] / Almmmatg.TpoCmb ELSE Almmmatg.PreOfi / Almmmatg.TpoCmb.
  END.
  ELSE DO:
    F-PREUSSA = Almmmatg.Prevta[2].
    F-PREUSSB = Almmmatg.Prevta[3].
    F-PREUSSC = Almmmatg.Prevta[4].
    F-PREUSSD = IF s-coddiv = '00015' THEN Almmmatg.PreAlt[4] ELSE Almmmatg.PreOfi.

    F-PRESOLA = Almmmatg.Prevta[2] * Almmmatg.TpoCmb.
    F-PRESOLB = Almmmatg.Prevta[3] * Almmmatg.TpoCmb.
    F-PRESOLC = Almmmatg.Prevta[4] * Almmmatg.TpoCmb.
    F-PRESOLD = IF s-coddiv = '00015' THEN Almmmatg.PreAlt[4] * Almmmatg.TpoCmb ELSE Almmmatg.PreOfi * Almmmatg.TpoCmb.
  END.
         
      DISPLAY STREAM REPORT 
               Almmmatg.codmat
               Almmmatg.DesMat
               Almmmatg.TipArt
               Almmmatg.DesMar
               Almmmatg.UndBas
               Almmmatg.MonVta
               F-PRESOLA    WHEN F-PRESOLA <> 0
               Almmmatg.UndA    WHEN Almmmatg.UndA <> ""
               F-PRESOLB    WHEN F-PRESOLB <> 0 
               Almmmatg.UndB    WHEN Almmmatg.UndB <> "" 
               F-PRESOLC    WHEN F-PRESOLC <> 0
               Almmmatg.UndC    WHEN Almmmatg.UndC <> ""
               F-PRESOLD    WHEN F-PRESOLD <> 0
               Almmmatg.Chr__01 WHEN Almmmatg.Chr__01 <> ""
               WITH FRAME F-REPORTE1.
      DOWN STREAM REPORT WITH FRAME F-REPORTE1.
       
  END.
  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-2 V-table-Win 
PROCEDURE Formato-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE2
               Almmmatg.codmat  FORMAT "X(6)"
               Almmmatg.DesMat  FORMAT "X(40)"
               Almmmatg.TipArt  FORMAT "X(1)"
               Almmmatg.DesMar  FORMAT "X(10)"
               Almmmatg.UndBas  FORMAT "X(8)"
               Almmmatg.MonVta  FORMAT "9"
               F-PREUSSA        FORMAT ">>>,>>9.9999"
               Almmmatg.UndA    FORMAT "X(8)"
               F-PREUSSB        FORMAT ">>>,>>9.9999"
               Almmmatg.UndB    FORMAT "X(8)"
               F-PREUSSC        FORMAT ">>>,>>9.9999"
               Almmmatg.UndC    FORMAT "X(8)"
               F-PREUSSD        FORMAT ">>>,>>9.9999"
               Almmmatg.Chr__01 FORMAT "X(8)"
              WITH WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         /*{&Prn2} + {&Prn7A} + {&Prn6A} +*/ S-NOMCIA /*+ {&Prn7B} + {&Prn6A} + {&Prn3}*/ FORMAT "X(50)" AT 1 SKIP
         "LISTADO DE PRECIOS" AT 62
         "Pagina :" TO 125 PAGE-NUMBER(REPORT) TO 137 FORMAT "ZZZZZ9" SKIP
         "Fecha  :" TO 125 TODAY TO 137 FORMAT "99/99/9999" SKIP
         "Hora   :" TO 125 STRING(TIME,"HH:MM") TO 137 SKIP
         mensaje FORMAT "X(28)" SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                          PREC. VTA. (A)        PREC. VTA. (B)         PREC. VTA. (C)      PREC. VTA. OFIC." SKIP
        "Codigo D  E  S  C  R  I  P  C  I  O  N          R MARCA      U.B.  MONEDA       USS. UM.             USS.  UM.             USS.   UM.            USS.  UM. " SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
      WITH PAGE-TOP WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  FOR EACH VtaDList OF VtaCList NO-LOCK,
        EACH Almmmatg OF VtaDList NO-LOCK
                            BREAK BY Almmmatg.CodFam
                                    BY Almmmatg.SubFam
                                    BY Almmmatg.CodMar
                                    BY Almmmatg.TipArt
                                    BY Almmmatg.CodMat:

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(Almmmatg.CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = Almmmatg.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT "FAMILIA : " Almtfami.codfam '    ' Almtfami.desfam SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
      IF FIRST-OF(Almmmatg.SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = s-CodCia 
                        AND  Almsfami.codfam = Almmmatg.CodFam 
                        AND  Almsfami.subfam = Almmmatg.Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             PUT STREAM REPORT "SUB-FAMILIA : " Almsfami.subfam '   ' AlmSFami.dessub SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
  IF Almmmatg.MonVta = 1 THEN DO:
    F-PRESOLA = Almmmatg.Prevta[2].
    F-PRESOLB = Almmmatg.Prevta[3].
    F-PRESOLC = Almmmatg.Prevta[4].
    F-PRESOLD = IF s-coddiv = '00015' THEN Almmmatg.PreAlt[4] ELSE Almmmatg.PreOfi.

    F-PREUSSA = Almmmatg.Prevta[2] / Almmmatg.TpoCmb.
    F-PREUSSB = Almmmatg.Prevta[3] / Almmmatg.TpoCmb.
    F-PREUSSC = Almmmatg.Prevta[4] / Almmmatg.TpoCmb.
    F-PREUSSD = IF s-coddiv = '00015' THEN Almmmatg.PreAlt[4] / Almmmatg.TpoCmb ELSE Almmmatg.PreOfi / Almmmatg.TpoCmb.
  END.
  ELSE DO:
    F-PREUSSA = Almmmatg.Prevta[2].
    F-PREUSSB = Almmmatg.Prevta[3].
    F-PREUSSC = Almmmatg.Prevta[4].
    F-PREUSSD = IF s-coddiv = '00015' THEN Almmmatg.PreAlt[4] ELSE Almmmatg.PreOfi.

    F-PRESOLA = Almmmatg.Prevta[2] * Almmmatg.TpoCmb.
    F-PRESOLB = Almmmatg.Prevta[3] * Almmmatg.TpoCmb.
    F-PRESOLC = Almmmatg.Prevta[4] * Almmmatg.TpoCmb.
    F-PRESOLD = IF s-coddiv = '00015' THEN Almmmatg.PreAlt[4] * Almmmatg.TpoCmb ELSE Almmmatg.PreOfi * Almmmatg.TpoCmb.
  END.
         
      DISPLAY STREAM REPORT 
               Almmmatg.codmat
               Almmmatg.DesMat
               Almmmatg.TipArt
               Almmmatg.DesMar
               Almmmatg.UndBas
               Almmmatg.MonVta
               F-PREUSSA    WHEN F-PREUSSA <> 0
               Almmmatg.UndA    WHEN Almmmatg.UndA <> ""
               F-PREUSSB    WHEN F-PREUSSB <> 0
               Almmmatg.UndB    WHEN Almmmatg.UndB <> "" 
               F-PREUSSC    WHEN F-PREUSSC <> 0
               Almmmatg.UndC    WHEN Almmmatg.UndC <> ""
               F-PREUSSD    WHEN F-PREUSSD <> 0
               Almmmatg.Chr__01 WHEN Almmmatg.Chr__01 <> ""
               WITH FRAME F-REPORTE2.
      DOWN STREAM REPORT WITH FRAME F-REPORTE2.
       
  END.
  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-3 V-table-Win 
PROCEDURE Formato-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE FRAME F-REPORTE
               Almmmatg.codmat  FORMAT "X(6)"
               Almmmatg.DesMat  FORMAT "X(40)"
               Almmmatg.TipArt  FORMAT "X(1)"
               Almmmatg.DesMar  FORMAT "X(10)"
               Almmmatg.UndBas  FORMAT "X(8)"
               Almmmatg.MonVta  FORMAT "9"
               F-PRESOLA        FORMAT ">>>,>>9.9999"
               F-PREUSSA        FORMAT ">>>,>>9.9999"
               Almmmatg.UndA    FORMAT "X(8)"
               F-PRESOLB        FORMAT ">>>,>>9.9999"
               F-PREUSSB        FORMAT ">>>,>>9.9999"
               Almmmatg.UndB    FORMAT "X(8)"
               F-PRESOLC        FORMAT ">>>,>>9.9999"
               F-PREUSSC        FORMAT ">>>,>>9.9999"
               Almmmatg.UndC    FORMAT "X(8)"
               F-PRESOLD        FORMAT ">>>,>>9.9999"
               F-PREUSSD        FORMAT ">>>,>>9.9999"
               Almmmatg.Chr__01 FORMAT "X(8)"
              WITH WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         /*{&Prn2} + {&Prn7A} + {&Prn6A} +*/ S-NOMCIA /*+ {&Prn7B} + {&Prn6A} + {&Prn3}*/ FORMAT "X(50)" AT 1 SKIP
         "LISTADO DE PRECIOS" AT 62
         "Pagina :" TO 125 PAGE-NUMBER(REPORT) TO 137 FORMAT "ZZZZZ9" SKIP
         "Fecha  :" TO 125 TODAY TO 137 FORMAT "99/99/9999" SKIP
         "Hora   :" TO 125 STRING(TIME,"HH:MM") TO 137 SKIP
         mensaje FORMAT "X(28)" SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                 PRECIO DE VTA. (A)                PRECIO DE VTA. (B)                 PRECIO DE VTA. (C)                 PRECIO DE VTA. OFICINA" SKIP
        "Codigo D  E  S  C  R  I  P  C  I  O  N          R MARCA      U.B.  MONEDA        S/.        USS$. UM.              S/.         USS$. UM.              S/.         USS$.  UM.             S/.          US$.  UM." SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
      WITH PAGE-TOP WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  FOR EACH VtaDList OF VtaCList NO-LOCK,
        EACH Almmmatg OF VtaDList NO-LOCK
                            BREAK BY Almmmatg.CodFam
                                    BY Almmmatg.SubFam
                                    BY Almmmatg.CodMar
                                    BY Almmmatg.TipArt
                                    BY Almmmatg.CodMat:

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(Almmmatg.CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = Almmmatg.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT "FAMILIA : " Almtfami.codfam '    ' Almtfami.desfam SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
      IF FIRST-OF(Almmmatg.SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = s-CodCia 
                        AND  Almsfami.codfam = Almmmatg.CodFam 
                        AND  Almsfami.subfam = Almmmatg.Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             PUT STREAM REPORT "SUB-FAMILIA : " Almsfami.subfam '   ' AlmSFami.dessub SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
  IF Almmmatg.MonVta = 1 THEN DO:
    F-PRESOLA = Almmmatg.Prevta[2].
    F-PRESOLB = Almmmatg.Prevta[3].
    F-PRESOLC = Almmmatg.Prevta[4].
    F-PRESOLD = IF s-coddiv = '00015' THEN Almmmatg.PreAlt[4] ELSE Almmmatg.PreOfi.

    F-PREUSSA = Almmmatg.Prevta[2] / Almmmatg.TpoCmb.
    F-PREUSSB = Almmmatg.Prevta[3] / Almmmatg.TpoCmb.
    F-PREUSSC = Almmmatg.Prevta[4] / Almmmatg.TpoCmb.
    F-PREUSSD = IF s-coddiv = '00015' THEN Almmmatg.PreAlt[4] / Almmmatg.TpoCmb ELSE Almmmatg.PreOfi / Almmmatg.TpoCmb.
  END.
  ELSE DO:
    F-PREUSSA = Almmmatg.Prevta[2].
    F-PREUSSB = Almmmatg.Prevta[3].
    F-PREUSSC = Almmmatg.Prevta[4].
    F-PREUSSD = IF s-coddiv = '00015' THEN Almmmatg.PreAlt[4] ELSE Almmmatg.PreOfi.

    F-PRESOLA = Almmmatg.Prevta[2] * Almmmatg.TpoCmb.
    F-PRESOLB = Almmmatg.Prevta[3] * Almmmatg.TpoCmb.
    F-PRESOLC = Almmmatg.Prevta[4] * Almmmatg.TpoCmb.
    F-PRESOLD = IF s-coddiv = '00015' THEN Almmmatg.PreAlt[4] * Almmmatg.TpoCmb ELSE Almmmatg.PreOfi * Almmmatg.TpoCmb.
  END.
         
      DISPLAY STREAM REPORT 
               Almmmatg.codmat
               Almmmatg.DesMat
               Almmmatg.TipArt
               Almmmatg.DesMar
               Almmmatg.UndBas
               Almmmatg.MonVta
               F-PRESOLA    WHEN F-PRESOLA <> 0
               F-PREUSSA    WHEN F-PREUSSA <> 0
               Almmmatg.UndA    WHEN Almmmatg.UndA <> ""
               F-PRESOLB    WHEN F-PRESOLB <> 0
               F-PREUSSB    WHEN F-PREUSSB <> 0
               Almmmatg.UndB    WHEN Almmmatg.UndB <> "" 
               F-PRESOLC    WHEN F-PRESOLC <> 0
               F-PREUSSC    WHEN F-PREUSSC <> 0
               Almmmatg.UndC    WHEN Almmmatg.UndC <> ""
               F-PRESOLD    WHEN F-PRESOLD <> 0
               F-PREUSSD    WHEN F-PREUSSD <> 0
               Almmmatg.Chr__01 WHEN Almmmatg.Chr__01 <> ""
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.
       
  END.
  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina-2').
  s-Copia-Registro = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES'
  THEN VtaCList.FchActi = TODAY.
  ASSIGN
    VtaCList.codcia  = s-codcia
    VtaCList.Usuario = s-user-id.
  /* En caso de copia */
  IF s-Copia-Registro = YES
  THEN DO:
    FOR EACH T-DACTI:
        CREATE VtaDList.
        BUFFER-COPY T-DACTI TO VtaDList
            ASSIGN
                VtaDList.codcia  = VtaCList.codcia
                VtaDList.codacti = VtaCList.codacti.
        DELETE T-DACTI.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina-1').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FOR EACH T-DACTI:
    DELETE T-DACTI.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */       
  FOR EACH VtaDList OF VtaCList NO-LOCK:
    CREATE T-DACTI.
    BUFFER-COPY VtaDList TO T-DACTI.
  END.
  s-Copia-Registro = YES.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR RPTA AS CHAR NO-UNDO.
  
  RPTA = "ERROR".        
  RUN ALM/D-CLAVE ('111111',OUTPUT RPTA). 
  IF RPTA = "ERROR" THEN DO:
      MESSAGE "No tiene Autorizacion Para Anular"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      RETURN 'ADM-ERROR'.
  END.

  FIND FIRST VtaDList OF VtaCList NO-LOCK NO-ERROR.
  IF AVAILABLE VtaDList
  THEN DO:
    MESSAGE "CUIDADO!!!" SKIP "Usted va a borrar TODA la actividad" SKIP
        "Desea continuar?" VIEW-AS ALERT-BOX WARNING
        BUTTONS YES-NO UPDATE rpta-1 AS LOG.
    IF rpta-1 = NO THEN RETURN 'ADM-ERROR'.
  END.
  FOR EACH VtaDList OF VtaCList:
    DELETE VtaDList.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
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
  IF RETURN-VALUE = 'NO'
  THEN DO WITH FRAME {&FRAME-NAME}: 
    ASSIGN  
        VtaCList.CodActi:SENSITIVE = NO.
    APPLY 'ENTRY':U TO VtaCList.DesActi.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.
    DEFINE VARIABLE nCodMon AS INTEGER NO-UNDO.
    
    IF NOT AVAILABLE VTaCList THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    RUN vta/d-clista (OUTPUT nCodMon).
    IF nCodMon = 0 THEN RETURN.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    CASE nCodMon:
        WHEN 1 THEN mensaje = "EXPRESADO EN SOLES".
        WHEN 2 THEN mensaje = "EXPRESADO EN DOLARES".
        WHEN 3 THEN mensaje = "EXPRESADO EN SOLES/DOLARES".
    END CASE.

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        CASE nCodMon:
            WHEN 1 THEN RUN Formato-1.
            WHEN 2 THEN RUN Formato-2.
            WHEN 3 THEN RUN Formato-3.
        END CASE.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
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
  RUN Procesa-Handle IN lh_Handle ('Pagina-1').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
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
        WHEN "" THEN .
    END CASE.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "VtaCList"}

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

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    IF VtaCList.CodActi:SCREEN-VALUE = ''
    THEN DO:
        MESSAGE 'Ingrese un código de actividad' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO VtaCList.CodActi.
        RETURN 'ADM-ERROR'.
    END.
  END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/
  RUN Procesa-Handle IN lh_Handle ('Pagina-2').

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

