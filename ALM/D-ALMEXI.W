&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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

/* Shared Variable Definitions ---                                       */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.
/* Local Variable Definitions ---                                       */
DEFINE VAR F-STKGEN  AS DECIMAL NO-UNDO.
DEFINE VAR F-STKALM  AS DECIMAL NO-UNDO.
DEFINE VAR F-VALCTO  AS DECIMAL NO-UNDO.
DEFINE VAR F-PRECTO  AS DECIMAL NO-UNDO.
DEFINE VAR C-MONEDA  AS CHARACTER FORMAT "X(20)" NO-UNDO.
DEFINE VAR S-SUBTIT  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VAR F-PESALM  AS DECIMAL NO-UNDO.
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE BUFFER B-Mate FOR Almmmate.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-48 RECT-46 RECT-56 RECT-47 RECT-55 ~
TipoStk F-CodFam F-SubFam DesdeC F-marca1 F-provee1 R-TpoRep T-Resumen ~
I-CodMon D-Corte HastaC F-marca2 F-provee2 R-Tipo Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS TipoStk F-CodFam F-SubFam DesdeC F-marca1 ~
F-provee1 R-TpoRep F-DesFam F-DesSub T-Resumen I-CodMon D-Corte HastaC ~
F-marca2 F-provee2 R-Tipo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE D-Corte AS DATE FORMAT "99/99/9999":U 
     LABEL "Al" 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .81 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(9)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-DesSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81 NO-UNDO.

DEFINE VARIABLE F-marca1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-marca2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-provee1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-provee2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-SubFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sub-linea" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .81 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(9)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE I-CodMon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 13.72 BY .81 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ambos", "",
"Activados", "A",
"Desactivados", "D"
     SIZE 12.86 BY 1.92 NO-UNDO.

DEFINE VARIABLE R-TpoRep AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "General", 1,
"Valorizado", 2,
"Corte de Fecha", 3
     SIZE 15 BY 2 NO-UNDO.

DEFINE VARIABLE TipoStk AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Solo Articulos con Stock", 1,
"Todos los Seleccionados", 2
     SIZE 43 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46 BY 3.12.

DEFINE RECTANGLE RECT-47
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46 BY 1.27.

DEFINE RECTANGLE RECT-48
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46 BY 2.62.

DEFINE RECTANGLE RECT-55
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46 BY .92.

DEFINE RECTANGLE RECT-56
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 13.72 BY 3.35.

DEFINE VARIABLE T-Resumen AS LOGICAL INITIAL no 
     LABEL "Resumido por Familia" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.29 BY .73 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     TipoStk AT ROW 6.88 COL 3.14 NO-LABEL
     F-CodFam AT ROW 1.27 COL 6.29 COLON-ALIGNED
     F-SubFam AT ROW 2.19 COL 6.29 COLON-ALIGNED
     DesdeC AT ROW 3.69 COL 7.72 COLON-ALIGNED
     F-marca1 AT ROW 4.54 COL 7.72 COLON-ALIGNED
     F-provee1 AT ROW 5.27 COL 7.72 COLON-ALIGNED
     R-TpoRep AT ROW 9.54 COL 9 NO-LABEL
     F-DesFam AT ROW 1.27 COL 12.14 COLON-ALIGNED NO-LABEL
     F-DesSub AT ROW 2.19 COL 12.14 COLON-ALIGNED NO-LABEL
     T-Resumen AT ROW 8.23 COL 14.72
     I-CodMon AT ROW 9.38 COL 28 NO-LABEL
     D-Corte AT ROW 10.62 COL 26 COLON-ALIGNED
     HastaC AT ROW 3.77 COL 32.72 COLON-ALIGNED
     F-marca2 AT ROW 4.54 COL 32.72 COLON-ALIGNED
     F-provee2 AT ROW 5.23 COL 32.72 COLON-ALIGNED
     R-Tipo AT ROW 2.69 COL 49.14 NO-LABEL
     Btn_OK AT ROW 6.08 COL 49.57
     Btn_Cancel AT ROW 8.65 COL 49.72
     RECT-48 AT ROW 9.15 COL 1
     RECT-46 AT ROW 3.38 COL 1.29
     RECT-56 AT ROW 1.62 COL 48.57
     "Estado" VIEW-AS TEXT
          SIZE 7.14 BY .69 AT ROW 1.81 COL 51.72
          FONT 1
     RECT-47 AT ROW 6.69 COL 1.14
     RECT-55 AT ROW 8.08 COL 1
     SPACE(16.28) SKIP(3.18)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "EXISTENCIAS POR ALMACEN".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
                                                                        */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-DesFam IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesSub IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* EXISTENCIAS POR ALMACEN */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN D-Corte DesdeC F-CodFam F-SubFam F-DesFam HastaC I-CodMon 
         TipoStk R-TpoRep T-Resumen R-Tipo
         F-marca1 F-marca2 F-provee1 F-provee2.
  RUN Imprime.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC D-Dialog
ON LEAVE OF DesdeC IN FRAME D-Dialog /* Articulo */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodFam D-Dialog
ON LEAVE OF F-CodFam IN FRAME D-Dialog /* Linea */
DO:
   ASSIGN F-CodFam.
   FIND Almtfami WHERE Almtfami.CodCia = S-CODCIA AND
        Almtfami.codfam = F-CodFam NO-LOCK NO-ERROR.
   IF AVAILABLE Almtfami THEN 
      DISPLAY Almtfami.desfam @ F-DesFam WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-marca1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-marca1 D-Dialog
ON LEAVE OF F-marca1 IN FRAME D-Dialog /* Marca */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND almtabla WHERE almtabla.Tabla = "MK" 
                  AND  almtabla.Codigo = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE almtabla THEN DO:
      MESSAGE "Codigo de Marca no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-marca2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-marca2 D-Dialog
ON LEAVE OF F-marca2 IN FRAME D-Dialog /* A */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND almtabla WHERE almtabla.Tabla = "MK" 
                  AND  almtabla.Codigo = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE almtabla THEN DO:
      MESSAGE "Codigo de Marca no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-provee1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-provee1 D-Dialog
ON LEAVE OF F-provee1 IN FRAME D-Dialog /* Proveedor */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA 
                AND  gn-prov.CodPro = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN do:
/*     DISPLAY gn-prov.NomPro @ FILL-IN-NomPro1 WITH FRAME {&FRAME-NAME}.*/
  END.
  ELSE DO:
      FIND gn-prov WHERE gn-prov.CodCia = 0 
                    AND  gn-prov.CodPro = SELF:SCREEN-VALUE 
                   NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-prov THEN DO:
           MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.
      END.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-provee2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-provee2 D-Dialog
ON LEAVE OF F-provee2 IN FRAME D-Dialog /* A */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA 
                AND  gn-prov.CodPro = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN do:
/*     DISPLAY gn-prov.NomPro @ FILL-IN-NomPro1 WITH FRAME {&FRAME-NAME}.*/
  END.
  ELSE DO:
      FIND gn-prov WHERE gn-prov.CodCia = 0 
                    AND  gn-prov.CodPro = SELF:SCREEN-VALUE 
                   NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-prov THEN DO:
           MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.
      END.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-SubFam D-Dialog
ON LEAVE OF F-SubFam IN FRAME D-Dialog /* Sub-linea */
DO:
   ASSIGN F-CodFam.
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   IF F-CodFam = "" THEN DO:
      SELF:SCREEN-VALUE = "".
      RETURN.
   END.
   FIND AlmSFami WHERE AlmSFami.CodCia = S-CODCIA AND
        AlmSFami.codfam = F-CodFam AND
        AlmSFami.subfam = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF AVAILABLE AlmSFami THEN 
      DISPLAY AlmSFami.dessub @ F-DesSub WITH FRAME {&FRAME-NAME}.
   ELSE DO:
      MESSAGE "Codigo de Sub-Familia no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC D-Dialog
ON LEAVE OF HastaC IN FRAME D-Dialog /* A */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.  
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-TpoRep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-TpoRep D-Dialog
ON VALUE-CHANGED OF R-TpoRep IN FRAME D-Dialog
DO:
   ASSIGN R-TpoRep.
   CASE R-TpoRep:
        WHEN 1 THEN ASSIGN I-CodMon:SENSITIVE = NO
                            D-Corte:SENSITIVE = NO.
        WHEN 2 THEN ASSIGN I-CodMon:SENSITIVE = YES.
        WHEN 3 THEN ASSIGN I-CodMon:SENSITIVE = YES
                            D-Corte:SENSITIVE = YES.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY TipoStk F-CodFam F-SubFam DesdeC F-marca1 F-provee1 R-TpoRep F-DesFam 
          F-DesSub T-Resumen I-CodMon D-Corte HastaC F-marca2 F-provee2 R-Tipo 
      WITH FRAME D-Dialog.
  ENABLE RECT-48 RECT-46 RECT-56 RECT-47 RECT-55 TipoStk F-CodFam F-SubFam 
         DesdeC F-marca1 F-provee1 R-TpoRep T-Resumen I-CodMon D-Corte HastaC 
         F-marca2 F-provee2 R-Tipo Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1 D-Dialog 
PROCEDURE Formato1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         SPACE(5)
         Almmmatg.codmat AT  7 COLUMN-LABEL "Codigo" FORMAT "X(9)"
         Almmmatg.DesMat AT 17 COLUMN-LABEL "Descripcion" FORMAT "X(55)"
         Almmmatg.UndStk AT 79 COLUMN-LABEL "Unidad"
         F-STKALM        AT 85 COLUMN-LABEL "Cantidad" FORMAT "->>,>>>,>>9.99"
         F-PESALM        FORMAT "->>>,>>>,>>9.99"
         HEADER
         {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6A} AT 6 FORMAT "X(50)" SKIP
         "EXISTENCIAS POR ALMACEN" AT 40 
         "Pagina : " TO 103 PAGE-NUMBER(REPORT) TO 113 FORMAT "ZZZZZ9" SKIP
         IF T-Resumen THEN "(POR FAMILIA)"  ELSE '' AT 48 FORMAT 'X(20)'
         " Fecha : " TO 103 TODAY TO 113 FORMAT "99/99/9999" SKIP
         S-DESALM AT 40 FORMAT "X(30)"
         "  Hora : " TO 103 STRING(TIME,"HH:MM:SS") TO 113 SKIP(1)
         S-SUBTIT AT 6 SKIP(1)
         "     -------------------------------------------------------------------------------------------------------------" SKIP
         "                                                                                                       P e s o   " SKIP
         "     Codigo   Descripcion                                                    Unidad      Cantidad       Kilos    " SKIP
         "     -------------------------------------------------------------------------------------------------------------" SKIP
  WITH WIDTH 160 NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO DOWN.

  FOR EACH Almmmate NO-LOCK WHERE Almmmate.CodCia = S-CODCIA 
                             AND  Almmmate.CodAlm = S-CODALM 
                             AND  (Almmmate.CodMat >= DesdeC  
                             AND   Almmmate.CodMat <= HastaC) , 
      EACH Almmmatg OF Almmmate WHERE Almmmatg.codfam BEGINS F-CodFam 
                                 AND  Almmmatg.subfam BEGINS F-SubFam 
                                 AND  (Almmmatg.CodMar >= F-marca1 
                                 AND   Almmmatg.CodMar <= F-marca2)
                                 AND  (Almmmatg.CodPr1 >= F-provee1
                                 AND   Almmmatg.CodPr1 <= F-provee2)
                                 AND  Almmmatg.TpoArt BEGINS R-Tipo 
                                NO-LOCK
      BREAK BY Almmmate.codcia BY Almmmatg.CodFam BY Almmmatg.Subfam BY Almmmatg.Ordlis:
      IF Almmmatg.FchCes <> ? THEN NEXT.
      DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      IF FIRST-OF(Almmmatg.CodFam) AND NOT T-Resumen THEN DO:
         FIND Almtfami WHERE 
              Almtfami.CodCia = Almmmate.CodCia AND
              Almtfami.codfam = Almmmatg.CodFam NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             DISPLAY STREAM REPORT 
                 Almtfami.codfam @ Almmmatg.codmat
                 Almtfami.desfam @ Almmmatg.DesMat WITH FRAME F-REPORTE.
             UNDERLINE STREAM REPORT Almmmatg.DesMat WITH FRAME F-REPORTE.
         END.
      END.
/*      IF FIRST-OF(Almmmatg.SubFam) THEN DO:
         FIND Almsfami WHERE 
              Almsfami.CodCia = Almmmatg.CodCia AND
              Almsfami.codfam = Almmmatg.CodFam AND
              Almsfami.subfam = Almmmatg.Subfam NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             DISPLAY STREAM REPORT 
                 Almsfami.subfam @ Almmmatg.codmat
                 AlmSFami.dessub @ Almmmatg.DesMat WITH FRAME F-REPORTE.
             DOWN 1 STREAM REPORT WITH FRAME F-REPORTE.
         END.
      END. */
      F-STKALM = Almmmate.StkAct.
      IF (TipoStk = 1 AND F-STKALM > 0) OR TipoStk = 2 THEN DO:
         F-PESALM = F-STKALM * Almmmatg.Pesmat.
         IF NOT T-Resumen THEN DO:
            DISPLAY STREAM REPORT 
                 Almmmatg.codFam
                 Almmmatg.codmat 
                 Almmmatg.DesMat 
                 Almmmatg.UndStk 
                 F-STKALM 
                 F-PESALM WHEN F-PESALM > 0 WITH FRAME F-REPORTE.
         END.
         ACCUMULATE F-STKALM (SUB-TOTAL BY Almmmatg.Subfam).
         ACCUMULATE F-STKALM (SUB-TOTAL BY Almmmatg.Codfam).
         ACCUMULATE F-STKALM (TOTAL).
         ACCUMULATE F-PESALM (SUB-TOTAL BY Almmmatg.Subfam).
         ACCUMULATE F-PESALM (SUB-TOTAL BY Almmmatg.Codfam).
         ACCUMULATE F-PESALM (TOTAL).
      END.
/*      IF LAST-OF(Almmmatg.SubFam) THEN DO:
         UNDERLINE STREAM REPORT F-STKALM WITH FRAME F-REPORTE.
         DISPLAY STREAM REPORT 
             '                    Total Sub-Familia  --> ' @ Almmmatg.desmat
             ACCUM SUB-TOTAL BY Almmmatg.subfam F-STKALM @ F-STKALM WITH FRAME F-REPORTE.
      END.*/
      IF LAST-OF(Almmmatg.CodFam) THEN DO:
         IF T-Resumen THEN DO:
            FIND Almtfami WHERE 
                 Almtfami.CodCia = Almmmate.CodCia AND
                 Almtfami.codfam = Almmmatg.CodFam NO-LOCK NO-ERROR.
            DISPLAY STREAM REPORT 
                    Almtfami.codfam @ Almmmatg.codmat
                    Almtfami.desfam @ Almmmatg.DesMat
                    ACCUM SUB-TOTAL BY Almmmatg.codfam F-STKALM @ F-STKALM 
                    ACCUM SUB-TOTAL BY Almmmatg.codfam F-PESALM @ F-PESALM  WITH FRAME F-REPORTE.
            END.
         ELSE DO:
            UNDERLINE STREAM REPORT F-STKALM F-PESALM WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
                '                    Total Familia      --> ' @ Almmmatg.desmat
                ACCUM SUB-TOTAL BY Almmmatg.codfam F-STKALM @ F-STKALM 
                ACCUM SUB-TOTAL BY Almmmatg.codfam F-PESALM @ F-PESALM WITH FRAME F-REPORTE.
         END.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.
      IF LAST-OF(Almmmate.Codcia) THEN DO:
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT F-STKALM F-PESALM WITH FRAME F-REPORTE.
         DISPLAY STREAM REPORT 
             '                    TOTAL GENERAL      --> ' @ Almmmatg.desmat
             ACCUM TOTAL F-STKALM @ F-STKALM 
             ACCUM TOTAL F-PESALM @ F-PESALM WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT F-STKALM F-PESALM WITH FRAME F-REPORTE.
      END.
  END.
  HIDE FRAME F-PROCESO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2 D-Dialog 
PROCEDURE Formato2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         Almmmatg.codmat COLUMN-LABEL "Codigo" FORMAT "X(9)" AT 2
         Almmmatg.DesMat COLUMN-LABEL "Descripcion" FORMAT "X(40)"
         Almmmatg.UndStk COLUMN-LABEL "Unid"
         F-STKALM  COLUMN-LABEL "Cantidad" FORMAT "->>,>>>,>>9.999"
         F-PESALM        FORMAT "->>>,>>>,>>9.99"
         F-PRECTO  COLUMN-LABEL "Precio!Unitario" FORMAT ">>>,>>9.99"
         F-VALCTO  COLUMN-LABEL "Importe!Total" FORMAT ">>>,>>>,>>9.99"
         HEADER
         {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6A} + {&Prn2} FORMAT "X(50)" SKIP
         "EXISTENCIAS POR ALMACEN VALORIZADAS A PRECIO PROMEDIO" AT 20  
         "Pagina :" TO 105 PAGE-NUMBER(REPORT) TO 126 FORMAT "ZZZZZ9" SKIP
         IF T-Resumen THEN "(POR FAMILIA)"  ELSE '' AT 44 FORMAT 'X(20)'
         "Fecha :" TO 105 TODAY TO 126 FORMAT "99/99/9999" SKIP
         S-DESALM AT 40 FORMAT "X(30)"
         "Hora :" TO 105 STRING(TIME,"HH:MM:SS") TO 126 SKIP(1)
         S-SUBTIT        "Moneda : " TO 70 C-MONEDA SKIP
         "-------------------------------------------------------------------------------------------------------------------" SKIP
         "                                                                               P E S O       Precio        Importe " SKIP
         "     Codigo   Descripcion                              Unid      Cantidad       Kilos       Unitario         Total " SKIP
         "-------------------------------------------------------------------------------------------------------------------" SKIP
  WITH WIDTH 160 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
  
  FOR EACH Almmmate NO-LOCK WHERE Almmmate.CodCia = S-CODCIA 
                             AND  Almmmate.CodAlm = S-CODALM 
                             AND  (Almmmate.CodMat >= DesdeC  
                             AND   Almmmate.CodMat <= HastaC) , 
      EACH Almmmatg OF Almmmate WHERE Almmmatg.codfam BEGINS F-CodFam 
                                 AND  Almmmatg.subfam BEGINS F-SubFam 
                                 AND  (Almmmatg.CodMar >= F-marca1 
                                 AND   Almmmatg.CodMar <= F-marca2)
                                 AND  (Almmmatg.CodPr1 >= F-provee1
                                 AND   Almmmatg.CodPr1 <= F-provee2)
                                 AND  Almmmatg.TpoArt BEGINS R-Tipo 
                                NO-LOCK
      BREAK BY Almmmate.CodCia BY Almmmatg.CodFam BY Almmmatg.Subfam BY Almmmatg.Ordlis:
      IF Almmmatg.FchCes <> ? THEN NEXT.
      DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      IF FIRST-OF(Almmmatg.CodFam) AND NOT T-Resumen THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = Almmmate.CodCia 
                        AND  Almtfami.codfam = Almmmatg.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             DISPLAY STREAM REPORT 
                 Almtfami.codfam @ Almmmatg.codmat
                 Almtfami.desfam @ Almmmatg.DesMat WITH FRAME F-REPORTE.
             UNDERLINE STREAM REPORT Almmmatg.DesMat WITH FRAME F-REPORTE.
         END.
      END.
/*      IF FIRST-OF(Almmmatg.SubFam) THEN DO:
         FIND Almsfami WHERE 
              Almsfami.CodCia = Almmmatg.CodCia AND
              Almsfami.codfam = Almmmatg.CodFam AND
              Almsfami.subfam = Almmmatg.Subfam NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             DISPLAY STREAM REPORT 
                 Almsfami.subfam @ Almmmatg.codmat
                 AlmSFami.dessub @ Almmmatg.DesMat WITH FRAME F-REPORTE.
             DOWN 1 STREAM REPORT WITH FRAME F-REPORTE.
         END.
      END. */
      F-STKALM = 0.
      FOR EACH B-mate NO-LOCK WHERE 
               B-mate.CodCia = S-CODCIA AND
               B-mate.codmat = Almmmatg.CodMat AND
               B-mate.StkAct > 0:
          F-STKALM = F-STKALM + B-Mate.StkAct.
      END.
      F-STKALM = Almmmate.StkAct.
      IF I-CodMon = 1 THEN F-VALCTO = Almmmatg.VCtMn1. 
      IF I-CodMon = 2 THEN F-VALCTO = Almmmatg.VCtMn2.
      IF (TipoStk = 1 AND F-STKALM > 0) OR TipoStk = 2 THEN DO:
         F-PRECTO = IF F-STKALM <> 0 THEN ROUND(F-VALCTO / F-STKALM,2) ELSE 0.
         F-VALCTO = ROUND(F-STKALM * F-PRECTO,2).
         F-PESALM = Almmmatg.Pesmat * F-STKALM.
         IF NOT T-Resumen THEN
            DISPLAY STREAM REPORT 
                 Almmmatg.codmat 
                 Almmmatg.DesMat 
                 Almmmatg.UndStk 
                 F-STKALM  
                 F-PESALM
                 F-PRECTO  
                 F-VALCTO WITH FRAME F-REPORTE.
         ACCUMULATE F-STKALM (SUB-TOTAL BY Almmmatg.Subfam).
         ACCUMULATE F-STKALM (SUB-TOTAL BY Almmmatg.Codfam).
         ACCUMULATE F-STKALM (TOTAL).
         ACCUMULATE F-PESALM (SUB-TOTAL BY Almmmatg.Subfam).
         ACCUMULATE F-PESALM (SUB-TOTAL BY Almmmatg.Codfam).
         ACCUMULATE F-PESALM (TOTAL).
         ACCUMULATE F-VALCTO (SUB-TOTAL BY Almmmatg.Subfam).
         ACCUMULATE F-VALCTO (SUB-TOTAL BY Almmmatg.Codfam).
         ACCUMULATE F-VALCTO (TOTAL).
      END.
/*      IF LAST-OF(Almmmatg.SubFam) THEN DO:
         UNDERLINE STREAM REPORT F-STKALM F-VALCTO WITH FRAME F-REPORTE.
         DISPLAY STREAM REPORT 
             '              Total Sub-Familia  --> ' @ Almmmatg.desmat
             ACCUM SUB-TOTAL BY Almmmatg.subfam F-STKALM @ F-STKALM 
             ACCUM SUB-TOTAL BY Almmmatg.subfam F-VALCTO @ F-VALCTO WITH FRAME F-REPORTE.
      END. */
      IF LAST-OF(Almmmatg.CodFam) THEN DO:
         IF T-Resumen THEN DO: 
            FIND Almtfami WHERE Almtfami.CodCia = Almmmate.CodCia AND
                 Almtfami.codfam = Almmmatg.CodFam NO-LOCK NO-ERROR.
            DISPLAY STREAM REPORT 
                 Almtfami.codfam @ Almmmatg.codmat
                 Almtfami.desfam @ Almmmatg.DesMat
                 ACCUM SUB-TOTAL BY Almmmatg.codfam F-STKALM @ F-STKALM 
                 ACCUM SUB-TOTAL BY Almmmatg.codfam F-PESALM @ F-PESALM 
                 ACCUM SUB-TOTAL BY Almmmatg.codfam F-VALCTO @ F-VALCTO  WITH FRAME F-REPORTE.
            END.
         ELSE DO:
            UNDERLINE STREAM REPORT F-STKALM F-PESALM F-VALCTO WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
                '              Total Familia      --> ' @ Almmmatg.desmat
                ACCUM SUB-TOTAL BY Almmmatg.codfam F-STKALM @ F-STKALM 
                ACCUM SUB-TOTAL BY Almmmatg.codfam F-PESALM @ F-PESALM 
                ACCUM SUB-TOTAL BY Almmmatg.codfam F-VALCTO @ F-VALCTO WITH FRAME F-REPORTE.
         END.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.
      IF LAST-OF(Almmmate.Codcia) THEN DO:
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT F-STKALM F-PESALM F-VALCTO WITH FRAME F-REPORTE.
         DISPLAY STREAM REPORT 
             '              TOTAL GENERAL      --> ' @ Almmmatg.desmat
             ACCUM TOTAL F-STKALM @ F-STKALM 
             ACCUM TOTAL F-PESALM @ F-PESALM 
             ACCUM TOTAL F-VALCTO @ F-VALCTO WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT F-STKALM F-PESALM F-VALCTO WITH FRAME F-REPORTE.
      END.
  END.
  HIDE FRAME F-PROCESO.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato3 D-Dialog 
PROCEDURE Formato3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         Almmmatg.codmat COLUMN-LABEL "Codigo" FORMAT "X(9)" AT 2
         Almmmatg.DesMat COLUMN-LABEL "Descripcion" FORMAT "X(40)"
         Almmmatg.UndStk COLUMN-LABEL "Unid"
         F-STKALM  COLUMN-LABEL "Cantidad" FORMAT "->>,>>>,>>9.999"
         F-PESALM        FORMAT ">>>>,>>>,>>9.99"
         F-PRECTO  COLUMN-LABEL "Precio!Unitario" FORMAT ">>>,>>9.99"
         F-VALCTO  COLUMN-LABEL "Importe!Total" FORMAT ">>>,>>>,>>9.99"
         HEADER
         {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6A} + {&Prn2} FORMAT "X(50)" SKIP
         "EXISTENCIAS POR ALMACEN VALORIZADAS A PRECIO PROMEDIO AL "  AT 20  D-Corte
         "Pagina :" TO 105 PAGE-NUMBER(REPORT) TO 126 FORMAT "ZZZZZ9" SKIP
         IF T-Resumen THEN "(POR FAMILIA)"  ELSE '' AT 52 FORMAT 'X(20)'
         "Fecha :" TO 105 TODAY TO 126 FORMAT "99/99/9999" SKIP
         S-DESALM AT 40 FORMAT "X(30)"
         "Hora :" TO 105 STRING(TIME,"HH:MM:SS") TO 126 SKIP(1)
         S-SUBTIT        "Moneda : " TO 70 C-MONEDA SKIP
         "-------------------------------------------------------------------------------------------------------------------" SKIP
         "                                                                               P E S O       Precio        Importe " SKIP
         "     Codigo   Descripcion                              Unid      Cantidad       Kilos       Unitario         Total " SKIP
         "-------------------------------------------------------------------------------------------------------------------" SKIP
  WITH WIDTH 160 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
  
  FOR EACH Almmmate NO-LOCK WHERE Almmmate.CodCia = S-CODCIA 
                             AND  Almmmate.CodAlm = S-CODALM 
                             AND  (Almmmate.CodMat >= DesdeC  
                             AND   Almmmate.CodMat <= HastaC) , 
      EACH Almmmatg OF Almmmate WHERE Almmmatg.codfam BEGINS F-CodFam 
                                 AND  Almmmatg.subfam BEGINS F-SubFam 
                                 AND  (Almmmatg.CodMar >= F-marca1 
                                 AND   Almmmatg.CodMar <= F-marca2)
                                 AND  (Almmmatg.CodPr1 >= F-provee1
                                 AND   Almmmatg.CodPr1 <= F-provee2)
                                 AND  Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
      BREAK BY Almmmate.CodCia BY Almmmatg.CodFam BY Almmmatg.Subfam BY Almmmatg.Ordlis:
      IF Almmmatg.FchCes <> ? THEN NEXT.
      DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      IF FIRST-OF(Almmmatg.CodFam) AND NOT T-Resumen THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = Almmmate.CodCia 
                        AND  Almtfami.codfam = Almmmatg.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             DISPLAY STREAM REPORT 
                 Almtfami.codfam @ Almmmatg.codmat
                 Almtfami.desfam @ Almmmatg.DesMat WITH FRAME F-REPORTE.
             UNDERLINE STREAM REPORT Almmmatg.DesMat WITH FRAME F-REPORTE.
         END.
      END.
/*      IF FIRST-OF(Almmmatg.SubFam) THEN DO:
         FIND Almsfami WHERE 
              Almsfami.CodCia = Almmmatg.CodCia AND
              Almsfami.codfam = Almmmatg.CodFam AND
              Almsfami.subfam = Almmmatg.Subfam NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             DISPLAY STREAM REPORT 
                 Almsfami.subfam @ Almmmatg.codmat
                 AlmSFami.dessub @ Almmmatg.DesMat WITH FRAME F-REPORTE.
             DOWN 1 STREAM REPORT WITH FRAME F-REPORTE.
         END.
      END. */
      /* UBICAMOS EL STOCK GENERAL A LA FECHA */
      FIND LAST Almdmov WHERE Almdmov.CodCia = S-CODCIA 
                         AND  Almdmov.CodMat = Almmmate.CodMat 
                         AND  Almdmov.FchDoc <= D-Corte 
                        USE-INDEX Almd02 NO-LOCK NO-ERROR.
      IF AVAILABLE Almdmov THEN F-STKALM = Almdmov.StkAct.
      ELSE F-STKALM = 0.
      IF AVAILABLE Almdmov AND I-CodMon = 1 THEN F-VALCTO = Almdmov.VctoMn1.
      IF AVAILABLE Almdmov AND I-CodMon = 2 THEN F-VALCTO = Almdmov.VctoMn2.
      /* UBICAMOS EL STOCK DE ALMACEN */
      FIND LAST Almdmov WHERE Almdmov.CodCia = S-CODCIA 
                         AND  Almdmov.CodAlm = Almmmate.CodAlm 
                         AND  Almdmov.CodMat = Almmmate.CodMat 
                         AND  Almdmov.FchDoc <= D-Corte 
                        USE-INDEX Almd03 NO-LOCK NO-ERROR.
      IF AVAILABLE Almdmov THEN F-STKALM = Almdmov.StkSub.
      ELSE F-STKALM = 0.
      IF (TipoStk = 1 AND F-STKALM > 0) OR TipoStk = 2 THEN DO:
         F-VALCTO = IF F-STKALM <> 0 THEN F-VALCTO ELSE 0.
         F-PRECTO = IF F-STKALM <> 0 THEN ROUND(F-VALCTO / F-STKALM,2) ELSE 0.
         F-VALCTO = ROUND(F-STKALM * F-PRECTO,2).
         F-PESALM = Almmmatg.Pesmat * F-STKALM.
         IF NOT T-Resumen THEN
            DISPLAY STREAM REPORT 
                 Almmmatg.codmat 
                 Almmmatg.DesMat 
                 Almmmatg.UndStk 
                 F-STKALM 
                 F-PESALM
                 F-PRECTO  
                 F-VALCTO WITH FRAME F-REPORTE.
         ACCUMULATE F-STKALM (SUB-TOTAL BY Almmmatg.Subfam).
         ACCUMULATE F-STKALM (SUB-TOTAL BY Almmmatg.Codfam).
         ACCUMULATE F-STKALM (TOTAL).
         ACCUMULATE F-PESALM (SUB-TOTAL BY Almmmatg.Subfam).
         ACCUMULATE F-PESALM (SUB-TOTAL BY Almmmatg.Codfam).
         ACCUMULATE F-PESALM (TOTAL).
         ACCUMULATE F-VALCTO (SUB-TOTAL BY Almmmatg.Subfam).
         ACCUMULATE F-VALCTO (SUB-TOTAL BY Almmmatg.Codfam).
         ACCUMULATE F-VALCTO (TOTAL).
      END.
/*      IF LAST-OF(Almmmatg.SubFam) THEN DO:
         UNDERLINE STREAM REPORT F-STKALM F-VALCTO WITH FRAME F-REPORTE.
         DISPLAY STREAM REPORT 
             '              Total Sub-Familia  --> ' @ Almmmatg.desmat
             ACCUM SUB-TOTAL BY Almmmatg.subfam F-STKALM @ F-STKALM 
             ACCUM SUB-TOTAL BY Almmmatg.subfam F-VALCTO @ F-VALCTO WITH FRAME F-REPORTE.
      END.*/
      IF LAST-OF(Almmmatg.CodFam) THEN DO:
         IF T-Resumen THEN DO:
            FIND Almtfami WHERE Almtfami.CodCia = Almmmate.CodCia 
                            AND Almtfami.codfam = Almmmatg.CodFam 
                           NO-LOCK NO-ERROR.
            DISPLAY STREAM REPORT 
                 Almtfami.codfam @ Almmmatg.codmat
                 Almtfami.desfam @ Almmmatg.DesMat
                 ACCUM SUB-TOTAL BY Almmmatg.codfam F-STKALM @ F-STKALM 
                 ACCUM SUB-TOTAL BY Almmmatg.codfam F-PESALM @ F-PESALM 
                 ACCUM SUB-TOTAL BY Almmmatg.codfam F-VALCTO @ F-VALCTO  WITH FRAME F-REPORTE.
            END.
         ELSE DO: 
            UNDERLINE STREAM REPORT F-STKALM F-PESALM F-VALCTO WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
                '              Total Familia      --> ' @ Almmmatg.desmat
                ACCUM SUB-TOTAL BY Almmmatg.codfam F-STKALM @ F-STKALM 
                ACCUM SUB-TOTAL BY Almmmatg.codfam F-PESALM @ F-PESALM 
                ACCUM SUB-TOTAL BY Almmmatg.codfam F-VALCTO @ F-VALCTO WITH FRAME F-REPORTE.
         END.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.
      IF LAST-OF(Almmmate.Codcia) THEN DO:
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT F-STKALM F-PESALM F-VALCTO WITH FRAME F-REPORTE.
         DISPLAY STREAM REPORT 
             '              TOTAL GENERAL      --> ' @ Almmmatg.desmat
             ACCUM TOTAL F-STKALM @ F-STKALM 
             ACCUM TOTAL F-PESALM @ F-PESALM 
             ACCUM TOTAL F-VALCTO @ F-VALCTO WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT F-STKALM F-PESALM F-VALCTO WITH FRAME F-REPORTE.
      END.
  END.
  HIDE FRAME F-PROCESO.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime D-Dialog 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.
   
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").
  
  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
  
  CASE s-salida-impresion:
        WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
        WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
        WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.
  
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn3} .
   
  IF I-CodMon = 1 THEN C-MONEDA = "NUEVOS SOLES".
  ELSE C-MONEDA = "DOLARES AMERICANOS".
  
  IF HastaC <> "" THEN S-SUBTIT = "Materiales del " + DesdeC + " al " + HastaC .
  ELSE S-SUBTIT = "".

  IF HastaC = "" THEN HastaC = "999999999".
  IF F-marca2 = "" THEN F-marca2 = "ZZZZZZZZZZZZZ".
  IF F-provee2 = "" THEN F-provee2 = "ZZZZZZZZZZZZZ".
  
  CASE R-TpoRep:
        WHEN 1 THEN RUN Formato1.
        WHEN 2 THEN RUN Formato2.
        WHEN 3 THEN RUN Formato3.
  END.
  
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.

  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/D-README.R(s-print-file). 
  END CASE. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  DO WITH FRAME {&FRAME-NAME}:
     D-Corte:SENSITIVE = NO.
     I-CodMon:SENSITIVE = NO.
     D-Corte = TODAY.
     R-Tipo = ''.
     DISPLAY D-Corte R-Tipo.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
PROCEDURE Procesa-Parametros :
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
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
        WHEN "F-Subfam" THEN ASSIGN input-var-1 = F-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        WHEN "F-marca1" OR WHEN "F-marca2" THEN ASSIGN input-var-1 = "MK".
        WHEN "" THEN ASSIGN input-var-1 = "".
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


