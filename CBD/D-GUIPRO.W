&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog }late

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

/* Local Variable Definitions ---                                       */
DEFINE {&NEW} SHARED VAR S-CODCIA AS INTEGER.
DEFINE {&NEW} SHARED VAR PV-CODCIA AS INTEGER.
DEFINE {&NEW} SHARED VAR S-NOMCIA AS CHAR.
DEFINE {&NEW} SHARED VAR S-PERIODO AS INTEGER.
DEFINE {&NEW} SHARED VAR S-NROMES  AS INTEGER.
DEFINE {&NEW} SHARED VARIABLE s-user-id AS CHARACTER.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE NEW SHARED TEMP-TABLE ALMOV LIKE Almcmov.

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
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK F-Codalm F-codpro F-Fecha1 F-Fecha2 ~
B-Imprimir Btn_Cancel RECT-1 
&Scoped-Define DISPLAYED-OBJECTS F-Codalm F-desalm F-codpro F-despro ~
F-Fecha1 F-Fecha2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-guialm AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Imprimir 
     IMAGE-UP FILE "img\apx-fac":U
     LABEL "Button 3" 
     SIZE 12 BY 1.73.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\auditor":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.73
     BGCOLOR 8 .

DEFINE VARIABLE F-Codalm AS CHARACTER FORMAT "xxx":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 6.29 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-codpro AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-desalm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.57 BY .81 NO-UNDO.

DEFINE VARIABLE F-despro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-Fecha1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-Fecha2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 2.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Btn_OK AT ROW 12.5 COL 25.72
     F-Codalm AT ROW 1.69 COL 9.72 COLON-ALIGNED
     F-desalm AT ROW 1.69 COL 16.57 COLON-ALIGNED NO-LABEL
     F-codpro AT ROW 2.69 COL 9.86 COLON-ALIGNED
     F-despro AT ROW 2.69 COL 19.57 COLON-ALIGNED NO-LABEL
     F-Fecha1 AT ROW 1.69 COL 65.57 COLON-ALIGNED
     F-Fecha2 AT ROW 2.69 COL 65.57 COLON-ALIGNED
     B-Imprimir AT ROW 12.5 COL 39.86
     Btn_Cancel AT ROW 12.5 COL 54
     RECT-1 AT ROW 1.19 COL 1.57
     SPACE(0.28) SKIP(10.60)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "GUIAS PROVISIONADAS".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   NOT-VISIBLE FRAME-NAME Custom                                        */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-desalm IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-despro IN FRAME D-Dialog
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* GUIAS PROVISIONADAS */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Imprimir D-Dialog
ON CHOOSE OF B-Imprimir IN FRAME D-Dialog /* Button 3 */
DO:
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN
     F-Codalm F-codpro F-Fecha1 F-Fecha2.
  IF F-Fecha1 = ? THEN DO:
     APPLY 'ENTRY' TO F-Fecha1.
  END.
  IF F-Fecha2 = ? THEN DO:
     APPLY 'ENTRY' TO F-Fecha2.
  END.
  RUN Carga-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Codalm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Codalm D-Dialog
ON LEAVE OF F-Codalm IN FRAME D-Dialog /* Almacen */
DO:
  ASSIGN F-Codalm.
  IF F-Codalm <> '' THEN DO:
     FIND Almacen WHERE Almacen.codcia = s-codcia AND
          Almacen.Codalm = F-Codalm NO-LOCK NO-ERROR.
     IF NOT AVAILABLE Almacen THEN DO:
        MESSAGE 'Codigo de Almacen no existe' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.
     DISPLAY 
        Almacen.Descripcion @ F-desalm WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-codpro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-codpro D-Dialog
ON LEAVE OF F-codpro IN FRAME D-Dialog /* Proveedor */
DO:
  ASSIGN F-codpro.
  IF F-codpro <> '' THEN DO:
     FIND gn-prov WHERE gn-prov.codcia = pv-codcia AND 
          gn-prov.codpro = F-Codpro NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-prov THEN DO:
        MESSAGE 'Proveedor no existe' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.
     DISPLAY
        gn-prov.NomPro @ F-despro WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Fecha1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Fecha1 D-Dialog
ON LEAVE OF F-Fecha1 IN FRAME D-Dialog /* Desde */
DO:
  ASSIGN
    F-Fecha1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Fecha2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Fecha2 D-Dialog
ON LEAVE OF F-Fecha2 IN FRAME D-Dialog /* Hasta */
DO:
  ASSIGN F-Fecha2.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'cbd/b-guialm.r':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-guialm ).
       RUN set-position IN h_b-guialm ( 3.88 , 1.00 ) NO-ERROR.
       RUN set-size IN h_b-guialm ( 8.46 , 87.29 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-guialm ,
             Btn_Cancel:HANDLE , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-import AS DECIMAL NO-UNDO.
DEFINE VAR x-impor2 AS DECIMAL NO-UNDO.
DEFINE VAR x-afecto AS DECIMAL NO-UNDO.
DEFINE VAR x-exone  AS DECIMAL NO-UNDO.

FOR EACH ALMOV:
   DELETE ALMOV.
END.

FOR EACH Almacen WHERE Almacen.CodCia = s-codcia AND
  Almacen.Codalm BEGINS F-Codalm NO-LOCK:
  FOR EACH Almcmov NO-LOCK WHERE 
           Almcmov.codcia = s-codcia AND
           Almcmov.Codalm BEGINS Almacen.CodAlm AND
           (Almcmov.TipMov = "I" OR Almcmov.TipMov = "S") AND
           (Almcmov.CodMov = 20 OR Almcmov.CodMov = 25)  AND
           Almcmov.Fchdoc >= F-Fecha1 AND
           Almcmov.Fchdoc <= F-Fecha2 AND
           Almcmov.CodPro BEGINS F-codpro:
      IF Almcmov.FlgEst <> "A" AND Almcmov.FlgFac THEN DO:
        DISPLAY Almcmov.Codalm + '-' + Almcmov.Tipmov + STRING(Almcmov.Codmov, '99') + '-' +
             STRING(Almcmov.Nrodoc, '999999')
             @ Fi-Mensaje LABEL "Movimientos"
            FORMAT "X(16)" WITH FRAME F-Proceso.
/*        x-impor2 = 0.
        x-import = 0.
        x-afecto = 0.
        x-exone  = 0.
        FOR EACH Almdmov OF Almcmov NO-LOCK:
            IF Almcmov.codmon = 1 THEN DO:
               x-import = x-import + Almdmov.ImpMn1.
               FIND Almmmatg WHERE Almmmatg.CodCia = s-codcia AND 
                    Almmmatg.codmat = Almdmov.codmat NO-LOCK NO-ERROR.
               IF AVAILABLE Almmmatg THEN 
                  IF Almmmatg.AftIgv THEN x-afecto = x-afecto + Almdmov.ImpMn1.
                  ELSE x-exone = x-exone + Almdmov.ImpMn1.
               END.
            ELSE DO:
               x-impor2 = x-impor2 + Almdmov.ImpMn2.
               FIND Almmmatg WHERE Almmmatg.CodCia = s-codcia AND 
                    Almmmatg.codmat = Almdmov.codmat NO-LOCK NO-ERROR.
               IF AVAILABLE Almmmatg THEN
                  IF Almmmatg.AftIgv THEN x-afecto = x-afecto + Almdmov.ImpMn2.
                  ELSE x-exone = x-exone + Almdmov.ImpMn2.
            END.
        END. */

        CREATE ALMOV.
        RAW-TRANSFER Almcmov TO ALMOV.

/*        ASSIGN
           ALMOV.ImpIgv = x-exone
           ALMOV.ImpMn1 = x-import
           ALMOV.ImpMn2 = x-impor2. */
      END.
  END.
  
END.
HIDE FRAME F-Proceso.
RUN dispatch IN h_b-guialm ('open-query':U).   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY F-Codalm F-desalm F-codpro F-despro F-Fecha1 F-Fecha2 
      WITH FRAME D-Dialog.
  ENABLE Btn_OK F-Codalm F-codpro F-Fecha1 F-Fecha2 B-Imprimir Btn_Cancel 
         RECT-1 
      WITH FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato D-Dialog 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR I-nroitm  AS INTEGER NO-UNDO.
DEFINE VAR x-codmon  AS CHAR NO-UNDO FORMAT 'X(3)'.
DEFINE VAR x-codmov  AS CHAR NO-UNDO FORMAT 'X(5)'.
DEFINE VAR x-tipo    AS CHAR NO-UNDO FORMAT 'X'.

DEFINE FRAME F-Header
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN3} + {&PRN6B} FORMAT "X(45)" 
    "Fecha  : " AT 109 TODAY SKIP(1)
    {&PRN2} + {&PRN6A} + 'GUIAS PROVISIONADAS' + {&PRN3} + {&PRN6B} + {&PRND} AT 58 FORMAT 'X(50)' SKIP(1)
    "Desde : " F-Fecha1  "       Hasta : " F-Fecha2  SKIP
    "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
    "       GUIA        FECHA     TIP    NUMERO DE   ORDEN DE       TIPO DE              IMPORTE          IMPORTE        EXONERADO      EXONERADO  " SKIP
    "     REMISION     EMISION    MOV    DOCUMENTO    COMPRA         CAMBIO   MON           S/.             US$             S/.            US$     " SKIP
    "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200. 
  
DEFINE FRAME F-Detalle
    I-NroItm       AT 1   FORMAT ">>9" 
    ALMOV.NroRf2   AT 6
    ALMOV.FchDoc   AT 17
    x-CodMov       AT 29
    ALMOV.NroDoc   AT 36
    ALMOV.NroRf1   AT 47 
    ALMOV.TpoCmb   FORMAT '>>9.9999' AT 60
    x-codmon     FORMAT 'X(3)' AT 72
    ALMOV.ImpMn1 
    ALMOV.ImpMn2 
/*    ALMOV.ExoMn1
    ALMOV.ExoMn2 */
    x-tipo
    WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN. 

 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT TO PRINTER VALUE(s-port-name) PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
 PUT CONTROL {&PRN0} {&PRN5A} CHR(66) {&PRN3}.

I-NroItm = 0.
FOR EACH ALMOV BREAK BY ALMOV.Codcia BY ALMOV.CodAlm BY ALMOV.CodPro:
    VIEW FRAME F-Header.
    IF FIRST-OF(ALMOV.CodAlm) THEN  DO:
       FIND Almacen WHERE Almacen.CodCia = s-codcia AND
            Almacen.CodAlm = ALMOV.Codalm NO-LOCK NO-ERROR.
       IF AVAILABLE Almacen THEN DO:
          PUT {&PRN7A} + {&PRN6A} 'ALMACEN ' AT 10 ALMOV.CodAlm  ' '  CAPS(TRIM(Almacen.Descripcion)) {&PRN6B} + {&PRN7B} FORMAT 'X(50)'.
          DOWN(1) WITH FRAME F-Detalle.
       END.
       I-Nroitm = 0.
    END.
    IF FIRST-OF(ALMOV.CodPro) THEN  DO:
       FIND Gn-Prov WHERE gn-prov.CodCia = pv-codcia AND
            Gn-prov.CodPro = ALMOV.CodPro NO-LOCK NO-ERROR.
       IF AVAILABLE Gn-prov THEN DO:
          PUT {&PRN6A} 'Proveedor : ' AT 3 ALMOV.CodPro ' ' TRIM(gn-prov.NomPro) {&PRN6B} FORMAT 'X(40)'.
          DOWN(1)  WITH FRAME F-Detalle.
       END.
    END.
    I-Nroitm = I-Nroitm + 1.
    ACCUMULATE ALMOV.ImpMn1 (SUB-TOTAL BY ALMOV.Codalm BY ALMOV.CodPro).
    ACCUMULATE ALMOV.ImpMn2 (SUB-TOTAL BY ALMOV.Codalm BY ALMOV.CodPro).
/*
    ACCUMULATE ALMOV.ExoMn1 (SUB-TOTAL BY ALMOV.Codalm BY ALMOV.CodPro).
    ACCUMULATE ALMOV.ExoMn2 (SUB-TOTAL BY ALMOV.Codalm BY ALMOV.CodPro).
*/
    x-codmon = IF ALMOV.Codmon = 1 THEN 'S/.' ELSE 'US$'.
    x-codmov = ALMOV.TipMov + STRING(ALMOV.Codmov, '99').
    x-tipo   = IF ALMOV.NroFac <> ' ' THEN '*' ELSE ''.
    DISPLAY 
        I-NroItm       AT 1   FORMAT ">>9" 
        ALMOV.NroRf2
        ALMOV.FchDoc
        x-CodMov
        ALMOV.NroDoc
        ALMOV.NroRf1
        ALMOV.TpoCmb
        x-codmon
        ALMOV.ImpMn1 
        ALMOV.ImpMn2 
        x-tipo
        WITH FRAME F-Detalle.
    IF LAST-OF(ALMOV.CodPro) THEN DO:
        UNDERLINE 
            ALMOV.ImpMn1
            ALMOV.ImpMn2
            WITH FRAME F-Detalle.
        DISPLAY 
            '    TOTAL' @ ALMOV.NroDoc
            'PROVEEDOR:' @ ALMOV.NroRf1
            ACCUM SUB-TOTAL BY ALMOV.Codpro ALMOV.ImpMn1 @ ALMOV.ImpMn1
            ACCUM SUB-TOTAL BY ALMOV.Codpro ALMOV.ImpMn2 @ ALMOV.ImpMn2
            WITH FRAME F-Detalle.
    END.
    IF LAST-OF(ALMOV.CodAlm) THEN DO:
        UNDERLINE 
            ALMOV.ImpMn1
            ALMOV.ImpMn2
            WITH FRAME F-Detalle.
        DISPLAY 
            '    TOTAL' @ ALMOV.NroDoc
            'ALMACEN  :' @ ALMOV.NroRf1
            ACCUM SUB-TOTAL BY ALMOV.Codpro ALMOV.ImpMn1 @ ALMOV.ImpMn1
            ACCUM SUB-TOTAL BY ALMOV.Codpro ALMOV.ImpMn2 @ ALMOV.ImpMn2
            WITH FRAME F-Detalle.
        UNDERLINE 
            ALMOV.ImpMn1
            ALMOV.ImpMn2
            WITH FRAME F-Detalle.
        PAGE.
    END.
END.    
OUTPUT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir D-Dialog 
PROCEDURE Imprimir :
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
   
  RUN Formato.
  
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
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
PROCEDURE Recoge-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
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

