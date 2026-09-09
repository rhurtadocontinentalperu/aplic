&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MATG FOR Almmmatg.
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedi.



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
/*&SCOPED-DEFINE precio-venta-general pri/PrecioVentaMayorContado*/
/*&SCOPED-DEFINE precio-venta-general pri/PrecioVentaMayorContadoFlash.p*/
&SCOPED-DEFINE precio-venta-general web/PrecioFinalContadoMayorista.p

DEFINE SHARED VARIABLE s-acceso-semaforos AS LOG.

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE output-var-4 LIKE FacDPedi.PreUni.
DEFINE NEW SHARED VARIABLE output-var-5 LIKE FacDPedi.PorDto.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-CODCLI  AS CHAR.
DEFINE SHARED VARIABLE S-CODMON  AS INTEGER.
DEFINE SHARED VARIABLE S-CODALM  AS CHAR.
DEFINE SHARED VARIABLE S-CNDVTA  AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB  AS DEC.
DEFINE SHARED VARIABLE s-PorIgv LIKE Ccbcdocu.PorIgv.
DEFINE SHARED VARIABLE s-TpoPed   AS CHAR.
DEFINE SHARED VARIABLE s-nrodec AS INT.
DEFINE SHARED VARIABLE s-FlgSit AS CHAR.
DEFINE SHARED TEMP-TABLE T-DPEDI LIKE FacDPedi.
DEFINE SHARED VARIABLE s-adm-new-record AS CHAR.
DEFINE SHARED VARIABLE s-NroPed AS CHAR.
DEFINE SHARED VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE S-UNDBAS AS CHAR NO-UNDO.
DEFINE VARIABLE S-UNDVTA AS CHAR NO-UNDO.
DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE X-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE I-NroItm AS INTE NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE x-TipDto AS CHAR NO-UNDO.
DEFINE VARIABLE pCodAlm  AS CHAR NO-UNDO.
DEFINE VARIABLE x-DesMat AS CHAR NO-UNDO.
DEFINE VARIABLE x-DesMar AS CHAR NO-UNDO.
DEFINE VARIABLE x-adm-new-record AS CHAR.
DEFINE VARIABLE f-FleteUnitario AS DECI NO-UNDO.

DEFINE BUFFER B-ITEM FOR ITEM.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

/* PRODUCTOS POR ROTACION */
DEFINE SHARED VAR s-FlgRotacion LIKE gn-divi.flgrotacion.
DEFINE SHARED VAR s-FlgEmpaque  LIKE GN-DIVI.FlgEmpaque.
DEFINE SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEFINE SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEFINE SHARED VAR s-FlgTipoVenta LIKE GN-DIVI.FlgPreVta.

/* Articulo Impuesto a las bolsas plasticas ICBPER  */
DEFINE VAR x-articulo-ICBPER AS CHAR.

x-articulo-ICBPER = '099268'.

DEF VAR x-Semaforo AS CHAR NO-UNDO.

DEF VAR pForeground AS INT.
DEF VAR pBackground AS INT.
DEF VAR pMensaje AS CHAR NO-UNDO.

DEFINE VAR x-item-desde AS CHAR.
DEFINE VAR x-item-hasta AS CHAR.

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
&Scoped-define INTERNAL-TABLES ITEM B-MATG

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table x-Semaforo @ x-Semaforo ITEM.NroItm ~
ITEM.codmat fDesMat() @ x-DesMat fDesMar() @ x-DesMar ITEM.UndVta ~
ITEM.AlmDes ITEM.CanPed ITEM.PreBas ITEM.Libre_d02 ITEM.PreUni ~
ITEM.Por_Dsctos[1] ITEM.Por_Dsctos[2] ITEM.Por_Dsctos[3] ITEM.ImpDto ~
ITEM.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table ITEM.codmat ITEM.UndVta ~
ITEM.AlmDes ITEM.CanPed 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table ITEM
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table ITEM
&Scoped-define QUERY-STRING-br_table FOR EACH ITEM WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST B-MATG OF ITEM NO-LOCK ~
    BY ITEM.NroItm INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH ITEM WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST B-MATG OF ITEM NO-LOCK ~
    BY ITEM.NroItm INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table ITEM B-MATG
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ITEM
&Scoped-define SECOND-TABLE-IN-QUERY-br_table B-MATG


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-28 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Semaforo FILL-IN-ImpTot 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDesMar B-table-Win 
FUNCTION fDesMar RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDesMat B-table-Win 
FUNCTION fDesMat RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-ImpTot AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "TOTAL" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Semaforo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 181 BY 1.88
     BGCOLOR 1 FGCOLOR 15 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      ITEM, 
      B-MATG
    FIELDS() SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      x-Semaforo @ x-Semaforo COLUMN-LABEL "Sem." FORMAT "x(4)":U
      ITEM.NroItm COLUMN-LABEL "No" FORMAT ">>>9":U
      ITEM.codmat COLUMN-LABEL "Articulo" FORMAT "X(14)":U WIDTH 6
      fDesMat() @ x-DesMat COLUMN-LABEL "Descripción" FORMAT "x(100)":U
            WIDTH 62.43
      fDesMar() @ x-DesMar COLUMN-LABEL "Marca" FORMAT "x(20)":U
            WIDTH 10.43
      ITEM.UndVta COLUMN-LABEL "Unidad" FORMAT "x(10)":U WIDTH 8
      ITEM.AlmDes COLUMN-LABEL "Alm!Desp" FORMAT "x(5)":U WIDTH 4.43
      ITEM.CanPed COLUMN-LABEL "Cantidad!Aprobada" FORMAT ">>>,>>9.99":U
            WIDTH 7.29
      ITEM.PreBas COLUMN-LABEL "Precio!Peldaño Bruto" FORMAT ">>,>>9.9999":U
      ITEM.Libre_d02 COLUMN-LABEL "Flete!Unitario" FORMAT "->>>,>>9.9999":U
            WIDTH 6.29
      ITEM.PreUni COLUMN-LABEL "Precio Unitario!Calculado" FORMAT ">>,>>9.999999":U
            WIDTH 10.43
      ITEM.Por_Dsctos[1] COLUMN-LABEL "% Dscto.!Admins" FORMAT "->>9.9999":U
            WIDTH 7.14
      ITEM.Por_Dsctos[2] COLUMN-LABEL "% Dscto!Evento" FORMAT "->>9.9999":U
            WIDTH 6.72
      ITEM.Por_Dsctos[3] COLUMN-LABEL "% Dscto!Vol/Prom" FORMAT "->>9.9999":U
            WIDTH 7.43
      ITEM.ImpDto COLUMN-LABEL "Importe!Dcto." FORMAT "->>>,>>9.99":U
            WIDTH 7.72
      ITEM.ImpLin COLUMN-LABEL "Importe!con IGV" FORMAT ">,>>>,>>9.99":U
            WIDTH 4.43
  ENABLE
      ITEM.codmat
      ITEM.UndVta
      ITEM.AlmDes
      ITEM.CanPed
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SIZE 181 BY 13.73
         BGCOLOR 15 FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN-Semaforo AT ROW 15.27 COL 78 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     FILL-IN-ImpTot AT ROW 15.27 COL 167 COLON-ALIGNED WIDGET-ID 2
     RECT-28 AT ROW 14.73 COL 1 WIDGET-ID 16
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
   Temp-Tables and Buffers:
      TABLE: B-MATG B "?" ? INTEGRAL Almmmatg
      TABLE: ITEM T "SHARED" ? INTEGRAL FacDPedi
   END-TABLES.
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
         HEIGHT             = 15.77
         WIDTH              = 186.
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

/* SETTINGS FOR FILL-IN FILL-IN-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Semaforo IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.ITEM,B-MATG OF Temp-Tables.ITEM"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE"
     _TblOptList       = ", FIRST USED"
     _OrdList          = "Temp-Tables.ITEM.NroItm|yes"
     _FldNameList[1]   > "_<CALC>"
"x-Semaforo @ x-Semaforo" "Sem." "x(4)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ITEM.NroItm
"ITEM.NroItm" "No" ">>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ITEM.codmat
"ITEM.codmat" "Articulo" "X(14)" "character" ? ? ? ? ? ? yes ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fDesMat() @ x-DesMat" "Descripción" "x(100)" ? ? ? ? ? ? ? no ? no no "62.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fDesMar() @ x-DesMar" "Marca" "x(20)" ? ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ITEM.UndVta
"ITEM.UndVta" "Unidad" "x(10)" "character" ? ? ? ? ? ? yes ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ITEM.AlmDes
"ITEM.AlmDes" "Alm!Desp" "x(5)" "character" ? ? ? ? ? ? yes ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ITEM.CanPed
"ITEM.CanPed" "Cantidad!Aprobada" ">>>,>>9.99" "decimal" ? ? ? ? ? ? yes ? no no "7.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ITEM.PreBas
"ITEM.PreBas" "Precio!Peldaño Bruto" ">>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.ITEM.Libre_d02
"ITEM.Libre_d02" "Flete!Unitario" "->>>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "6.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.ITEM.PreUni
"ITEM.PreUni" "Precio Unitario!Calculado" ">>,>>9.999999" "decimal" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.ITEM.Por_Dsctos[1]
"ITEM.Por_Dsctos[1]" "% Dscto.!Admins" "->>9.9999" "decimal" ? ? ? ? ? ? no ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.ITEM.Por_Dsctos[2]
"ITEM.Por_Dsctos[2]" "% Dscto!Evento" "->>9.9999" "decimal" ? ? ? ? ? ? no ? no no "6.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.ITEM.Por_Dsctos[3]
"ITEM.Por_Dsctos[3]" "% Dscto!Vol/Prom" "->>9.9999" "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.ITEM.ImpDto
"ITEM.ImpDto" "Importe!Dcto." "->>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.ITEM.ImpLin
"ITEM.ImpLin" "Importe!con IGV" ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-DISPLAY OF br_table IN FRAME F-Main
DO:
    IF NOT AVAILABLE ITEM THEN RETURN.
    IF ITEM.Libre_c01 = '*' /*AND ITEM.CanPed <> ITEM.Libre_d01*/ THEN DO:
      ASSIGN
          x-DesMar:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11 
          x-DesMat:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
          ITEM.AlmDes:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
          ITEM.CanPed:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
          ITEM.codmat:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
          ITEM.ImpLin:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
          /*ITEM.Libre_d01:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11*/
          ITEM.Por_Dsctos[1]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
          ITEM.Por_Dsctos[2]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
          ITEM.Por_Dsctos[3]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
          ITEM.NroItm:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
          ITEM.PreUni:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
          ITEM.UndVta:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11.
      ASSIGN
          x-DesMar:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
          x-DesMat:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
          ITEM.AlmDes:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
          ITEM.CanPed:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
          ITEM.codmat:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
          ITEM.ImpLin:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
          /*ITEM.Libre_d01:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9*/
          ITEM.Por_Dsctos[1]:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
          ITEM.Por_Dsctos[2]:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
          ITEM.Por_Dsctos[3]:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
          ITEM.NroItm:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
          ITEM.PreUni:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
          ITEM.UndVta:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9.
    END.
    /* ******************************************************************************* */
    /* RHC SEMAFORO 14/11/2019 */
    /* ******************************************************************************* */
    DEF VAR pError AS CHAR NO-UNDO.
    DEF VAR pLimite AS DEC NO-UNDO.
    DEF VAR pMargen AS DEC NO-UNDO.

    DEFINE VAR hProc AS HANDLE NO-UNDO.
    RUN pri/pri-librerias PERSISTENT SET hProc.
    RUN PRI_Valida-Margen-Utilidad IN hProc (INPUT s-CodDiv,
                                             INPUT ITEM.CodMat,
                                             INPUT ITEM.UndVta,
                                             INPUT (ITEM.ImpLin / ITEM.CanPed),
                                             INPUT s-CodMon,
                                             OUTPUT pMargen,
                                             OUTPUT pLimite,
                                             OUTPUT pError).
    DELETE PROCEDURE hProc.
    IF RETURN-VALUE <> 'ADM-ERROR' THEN DO:
        RUN vtagn/p-semaforo (INPUT ITEM.CodMat,
                              INPUT s-CodDiv,
                              INPUT pMargen,
                              OUTPUT pForeground,
                              OUTPUT pBackground).
        ASSIGN
            x-Semaforo:BGCOLOR IN BROWSE {&BROWSE-NAME} = pBackground
            x-Semaforo:FGCOLOR IN BROWSE {&BROWSE-NAME} = pForeground.
    END.

/*     DEF VAR pError AS CHAR NO-UNDO.                                        */
/*     DEF VAR pLimite AS DEC NO-UNDO.                                        */
/*     DEF VAR pMargen AS DEC NO-UNDO.                                        */
/*     RUN vtagn/p-margen-utilidad-v2 (INPUT s-CodDiv,                        */
/*                                     INPUT ITEM.CodMat,                     */
/*                                     INPUT (ITEM.ImpLin / ITEM.CanPed),     */
/*                                     INPUT ITEM.UndVta,                     */
/*                                     INPUT s-CodMon,                        */
/*                                     INPUT s-TpoCmb,                        */
/*                                     NO,                                    */
/*                                     INPUT ITEM.AlmDes,                     */
/*                                     OUTPUT pMargen,                        */
/*                                     OUTPUT pLimite,                        */
/*                                     OUTPUT pError).                        */
/*     IF RETURN-VALUE = 'OK' THEN DO:                                        */
/*         IF (s-acceso-semaforos = NO AND B-MATG.CHR__02 = "T") OR           */
/*             s-acceso-semaforos = YES THEN DO:                              */
/*             RUN vtagn/p-semaforo (INPUT ITEM.CodMat,                       */
/*                                   INPUT s-CodDiv,                          */
/*                                   INPUT pMargen,                           */
/*                                   OUTPUT pForeground,                      */
/*                                   OUTPUT pBackground).                     */
/*             ASSIGN                                                         */
/*                 x-Semaforo:BGCOLOR IN BROWSE {&BROWSE-NAME} = pBackground  */
/*                 x-Semaforo:FGCOLOR IN BROWSE {&BROWSE-NAME} = pForeground. */
/*         END.                                                               */
/*     END.                                                                   */
    /* ******************************************************************************* */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
  DISPLAY I-NroItm @ ITEM.NroItm WITH BROWSE {&BROWSE-NAME}.
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


&Scoped-define SELF-NAME ITEM.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.codmat br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF ITEM.codmat IN BROWSE br_table /* Articulo */
DO:
  /* SOLO PASA POR AQUI CUANDO SE CREA UN NUEVO REGISTRO
  APROVECHAMOS PARA INICIALIZAR ALGUNOS VALORES */
/*     DISPLAY                                                                                          */
/*         ENTRY(1, s-CodAlm) WHEN ITEM.AlmDes:SCREEN-VALUE IN BROWSE {&browse-name} = "" @ ITEM.AlmDes */
/*         1 WHEN DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) = 0 @ ITEM.CanPed              */
/*         WITH BROWSE {&browse-name}.                                                                  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM.codmat IN BROWSE br_table /* Articulo */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    IF x-Adm-New-Record = "NO" AND SELF:SCREEN-VALUE = ITEM.CodMat THEN RETURN.

    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
    IF pCodMat = '' THEN DO:
        ASSIGN SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.        

    SELF:SCREEN-VALUE = pCodMat.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK.
    IF Almmmatg.Chr__01 = "" THEN DO:
       MESSAGE "Articulo " + pCodMat + " no tiene unidad de Oficina" VIEW-AS ALERT-BOX ERROR.
       ASSIGN SELF:SCREEN-VALUE = "".
       RETURN NO-APPLY.
    END.
    
    DISPLAY 
        Almmmatg.DesMat @ x-DesMat 
        Almmmatg.DesMar @ x-DesMar 
        Almmmatg.UndA       @ ITEM.UndVta
        WITH BROWSE {&BROWSE-NAME}.
    RUN {&precio-venta-general} (s-CodCia,
                                 s-CodDiv,
                                 s-CodCli,
                                 s-CodMon,
                                 s-TpoCmb,
                                 OUTPUT f-Factor,
                                 ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name},
                                 s-FlgSit,
                                 ITEM.undvta:SCREEN-VALUE IN BROWSE {&browse-name},
                                 DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}),
                                 s-NroDec,
                                 ITEM.almdes:SCREEN-VALUE IN BROWSE {&browse-name},   /* Necesario para REMATES */
                                 OUTPUT f-PreBas,
                                 OUTPUT f-PreVta,
                                 OUTPUT f-Dsctos,
                                 OUTPUT y-Dsctos,
                                 OUTPUT x-TipDto,
                                 OUTPUT f-FleteUnitario,
                                 OUTPUT pMensaje
                                   ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        ASSIGN SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
        

    DISPLAY 
        F-PREVTA            @ ITEM.PreUni 
        z-Dsctos            @ ITEM.Por_Dsctos[2]
        y-Dsctos            @ ITEM.Por_Dsctos[3]
        WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF ITEM.codmat IN BROWSE br_table /* Articulo */
OR f8 OF ITEM.codmat
DO:
/*     RUN vta2/c-listaprecios-conta ('Lista de Precios').         */
/*     IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2. */
    RUN vta2/d-listaprecios-contado.
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ITEM.UndVta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.UndVta br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF ITEM.UndVta IN BROWSE br_table /* Unidad */
DO:
    IF ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name} = '' THEN RETURN.
    /****    Selecciona las unidades de medida   ****/
    RUN web/d-uniabc (ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name},
                      s-codalm,
                      s-coddiv,
                      s-codcli,
                      s-tpocmb,
                      s-flgsit,
                      s-nrodec,
                      ITEM.almdes:SCREEN-VALUE IN BROWSE {&browse-name},
                      OUTPUT output-var-2
                      ).
    SELF:SCREEN-VALUE = output-var-2.
/*     RUN vtagn/c-uniabc ("Unidades de Venta",                               */
/*                         ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name}, */
/*                         s-CodAlm                                           */
/*                         ).                                                 */
/*     IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.            */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.UndVta br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM.UndVta IN BROWSE br_table /* Unidad */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
      AND Almmmatg.codmat = ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN RETURN.

  /* SOLO se aceptan unidades válidas de este producto */
  DEF VAR x-Unidades AS CHAR.

  x-Unidades = TRIM(Almmmatg.UndA).
  IF Almmmatg.UndB <> '' THEN x-Unidades = x-unidades + ',' + TRIM(Almmmatg.UndB).
  IF Almmmatg.UndC <> '' THEN x-Unidades = x-unidades + ',' + TRIM(Almmmatg.UndC).
  IF LOOKUP(SELF:SCREEN-VALUE, x-Unidades) = 0 THEN DO:
      MESSAGE 'Solo se acepta la siguiente lista de unidades:' SKIP
          x-Unidades
          VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
    RUN {&precio-venta-general} (s-CodCia,
                                 s-CodDiv,
                                 s-CodCli,
                                 s-CodMon,
                                 s-TpoCmb,
                                 OUTPUT f-Factor,
                                 ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name},
                                 s-FlgSit,
                                 ITEM.undvta:SCREEN-VALUE IN BROWSE {&browse-name},
                                 DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}),
                                 s-NroDec,
                                 ITEM.almdes:SCREEN-VALUE IN BROWSE {&browse-name},   /* Necesario para REMATES */
                                 OUTPUT f-PreBas,
                                 OUTPUT f-PreVta,
                                 OUTPUT f-Dsctos,
                                 OUTPUT y-Dsctos,
                                 OUTPUT x-TipDto,
                                 OUTPUT f-FleteUnitario,
                                 OUTPUT pMensaje
                                 ).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  DISPLAY 
      F-PREVTA @ ITEM.PreUni 
      z-Dsctos @ ITEM.Por_Dsctos[2]
      y-Dsctos @ ITEM.Por_Dsctos[3]
      WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.UndVta br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF ITEM.UndVta IN BROWSE br_table /* Unidad */
OR f8 OF ITEM.UndVta
DO:
    IF ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name} = '' THEN RETURN.
    /****    Selecciona las unidades de medida   ****/
    RUN vtagn/c-uniabc ("Unidades de Venta",
                        ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name},
                        s-CodAlm
                        ).
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ITEM.AlmDes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.AlmDes br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF ITEM.AlmDes IN BROWSE br_table /* Alm!Desp */
DO:
    IF SELF:SCREEN-VALUE = '' THEN self:SCREEN-VALUE = ENTRY(1, s-CodAlm).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.AlmDes br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM.AlmDes IN BROWSE br_table /* Alm!Desp */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND Almacen WHERE Almacen.CodCia = S-CodCia 
        AND Almacen.CodAlm = ITEM.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN DO:
       MESSAGE "Almacen no existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO ITEM.AlmDes IN BROWSE {&BROWSE-NAME}.
       RETURN NO-APPLY.
    END.
    IF LOOKUP(SELF:SCREEN-VALUE, s-codalm) = 0 THEN DO:
        MESSAGE 'SOLO se aceptan los siguientes almacenes:' SKIP
            s-codalm
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    RUN {&precio-venta-general} (s-CodCia,
                                 s-CodDiv,
                                 s-CodCli,
                                 s-CodMon,
                                 s-TpoCmb,
                                 OUTPUT f-Factor,
                                 ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name},
                                 s-FlgSit,
                                 ITEM.undvta:SCREEN-VALUE IN BROWSE {&browse-name},
                                 DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}),
                                 s-NroDec,
                                 ITEM.almdes:SCREEN-VALUE IN BROWSE {&browse-name},   /* Necesario para REMATES */
                                 OUTPUT f-PreBas,
                                 OUTPUT f-PreVta,
                                 OUTPUT f-Dsctos,
                                 OUTPUT y-Dsctos,
                                 OUTPUT x-TipDto,
                                 OUTPUT f-FleteUnitario,
                                 OUTPUT pMensaje
                                 ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    DISPLAY 
        F-PREVTA @ ITEM.PreUni 
        z-Dsctos @ ITEM.Por_Dsctos[2]
        y-Dsctos @ ITEM.Por_Dsctos[3]
        WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.AlmDes br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF ITEM.AlmDes IN BROWSE br_table /* Alm!Desp */
OR f8 OF ITEM.AlmDes
DO:
  ASSIGN
      input-var-1 = s-codalm
      input-var-2 = s-coddiv
      input-var-3 = ''.
  RUN vtagn/c-vtaalmdiv-01 ('Almacenes de Despacho').
  IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ITEM.CanPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.CanPed br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM.CanPed IN BROWSE br_table /* Cantidad!Aprobada */
DO:

    IF TRUE <> (x-item-desde > "") THEN DO:
        x-item-desde = STRING(TIME,"HH:MM:SS").
    END.

    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN RETURN.
    RUN {&precio-venta-general} (s-CodCia,
                                 s-CodDiv,
                                 s-CodCli,
                                 s-CodMon,
                                 s-TpoCmb,
                                 OUTPUT f-Factor,
                                 ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name},
                                 s-FlgSit,
                                 ITEM.undvta:SCREEN-VALUE IN BROWSE {&browse-name},
                                 DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}),
                                 s-NroDec,
                                 ITEM.almdes:SCREEN-VALUE IN BROWSE {&browse-name},   /* Necesario para REMATES */
                                 OUTPUT f-PreBas,
                                 OUTPUT f-PreVta,
                                 OUTPUT f-Dsctos,
                                 OUTPUT y-Dsctos,
                                 OUTPUT x-TipDto,
                                 OUTPUT f-FleteUnitario,
                                 OUTPUT pMensaje
                                 ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    DISPLAY 
        F-PREVTA @ ITEM.PreUni 
        z-Dsctos @ ITEM.Por_Dsctos[2]
        y-Dsctos @ ITEM.Por_Dsctos[3]
        WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ITEM.PreUni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.PreUni br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM.PreUni IN BROWSE br_table /* Precio Unitario!Calculado */
DO:
/*     /* Determinamos el PRECIO CORRECTO */                                         */
/*     IF NOT AVAILABLE Almmmatg THEN RETURN.                                        */
/*     ASSIGN                                                                        */
/*         x-CanPed = DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})         */
/*         s-UndVta = ITEM.UndVta:SCREEN-VALUE IN BROWSE {&browse-name}.             */
/*     RUN vta2/PrecioMayorista-Cred (                                               */
/*         s-TpoPed,                                                                 */
/*         s-CodDiv,                                                                 */
/*         s-CodCli,                                                                 */
/*         s-CodMon,                                                                 */
/*         INPUT-OUTPUT s-UndVta,                                                    */
/*         OUTPUT f-Factor,                                                          */
/*         Almmmatg.CodMat,                                                          */
/*         s-CndVta,                                                                 */
/*         x-CanPed,                                                                 */
/*         s-NroDec,                                                                 */
/*         OUTPUT f-PreBas,                                                          */
/*         OUTPUT f-PreVta,                                                          */
/*         OUTPUT f-Dsctos,                                                          */
/*         OUTPUT y-Dsctos,                                                          */
/*         OUTPUT z-Dsctos,                                                          */
/*         OUTPUT x-TipDto,                                                          */
/*         TRUE                                                                      */
/*         ).                                                                        */
/*     IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.                           */
/*     IF F-PREVTA > DEC(ITEM.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) THEN DO: */
/*        MESSAGE "No autorizado para bajar el precio unitario"                      */
/*            VIEW-AS ALERT-BOX ERROR.                                               */
/*        DISPLAY F-PREVTA @ ITEM.PreUni WITH BROWSE {&BROWSE-NAME}.                 */
/*        RETURN NO-APPLY.                                                           */
/*     END.                                                                          */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF ITEM.CanPed, ITEM.codmat, ITEM.UndVta, ITEM.PreUni, ITEM.AlmDes
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imp-Total B-table-Win 
PROCEDURE Imp-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    FILL-IN-ImpTot = 0.
FOR EACH B-ITEM:
    FILL-IN-ImpTot = FILL-IN-ImpTot + B-ITEM.ImpLin.
END.
DISPLAY FILL-IN-ImpTot WITH FRAME {&FRAME-NAME}.

DEF VAR pForeground AS INT.
DEF VAR pBackground AS INT.
/* ******************************************************************************* */
/* RHC SEMAFORO 14/11/2019 */
/* ******************************************************************************* */
/* DEF VAR pError AS CHAR NO-UNDO.                                    */
/* DEF VAR pLimite AS DEC NO-UNDO.                                    */
/* DEF VAR pMargen AS DEC NO-UNDO.                                    */
/* RUN vtagn/p-semaforo-total (INPUT s-CodDiv,                        */
/*                             INPUT s-CodMon,                        */
/*                             INPUT TABLE ITEM,                      */
/*                             OUTPUT pForeground,                    */
/*                             OUTPUT pBackground).                   */
/* ASSIGN                                                             */
/*     FILL-IN-Semaforo:BGCOLOR IN FRAME {&FRAME-NAME} = pBackground  */
/*     FILL-IN-Semaforo:FGCOLOR IN FRAME {&FRAME-NAME} = pForeground. */


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
  IF s-CodCli = '' THEN DO:
      MESSAGE 'Debe ingresar el CLIENTE' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  IF s-CndVta = '' THEN DO:
      MESSAGE 'Debe ingresar la CONDICION DE VENTA' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  I-NroItm = 0.  
  DEFINE VARIABLE N-ITMS AS INTEGER INIT 0 NO-UNDO.
  FOR EACH B-ITEM BY B-ITEM.NroItm:
      N-ITMS = N-ITMS + 1.
      I-NroItm = B-ITEM.NroItm.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      I-NroItm = I-NroItm + 1
      s-UndVta = ""
      x-Adm-New-Record = "YES".
  RUN Procesa-Handle IN lh_handle ('Disable-Head').
  APPLY 'ENTRY':U TO ITEM.codmat IN BROWSE {&browse-name}.

  x-item-desde = "".
  
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
  /* REASEGURAMOS EL FACTOR DE EQUIVALENCIA */
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND Almmmatg.codmat = ITEM.codmat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE 'Código' ITEM.codmat 'NO registrado en el Catálogo' SKIP
          'Grabación abortada'
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.CodMat IN BROWSE {&browse-name}.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND Almtconv.Codalter = ITEM.UndVta
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almtconv THEN DO:
      MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat
          'Unidad de venta:' ITEM.UndVta SKIP
          'Grabación abortada'
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.UndVta IN BROWSE {&browse-name}.
      UNDO, RETURN "ADM-ERROR".
  END.
  F-FACTOR = Almtconv.Equival.
  ASSIGN 
      ITEM.CodCia = S-CODCIA
      ITEM.Factor = F-FACTOR
      ITEM.NroItm = I-NroItm
      ITEM.PorDto = f-Dsctos
      ITEM.PreBas = F-PreBas 
      ITEM.PreVta[1] = F-PreVta     /* CONTROL DE PRECIO DE LISTA */
      ITEM.AftIgv = Almmmatg.AftIgv
      ITEM.AftIsc = Almmmatg.AftIsc
      ITEM.Libre_c04 = x-TipDto.
  ASSIGN 
      ITEM.PreUni = DEC(ITEM.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      ITEM.Por_Dsctos[1] = DEC(ITEM.Por_Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      ITEM.Por_Dsctos[2] = DEC(ITEM.Por_Dsctos[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      ITEM.Por_Dsctos[3] = DEC(ITEM.Por_Dsctos[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      ITEM.Libre_d02     = f-FleteUnitario.
  ASSIGN
      ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                    ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
  IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
      THEN ITEM.ImpDto = 0.
      ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
  /* ****************************************************************** */
  /* RHC 04/08/2015 Si existe f-FleteUnitario se recalcula el Descuento */
  /* RHC 04/05/2020 Nueva forma de calcular */
  /* ****************************************************************** */
  /* Ic - 28Set2018, si el flete debe considerarse, segun Karin Roden.... */
/*   RUN gn/factor-porcentual-flete-v2(INPUT s-CodDiv,               */
/*                                     INPUT ITEM.codmat,            */
/*                                     INPUT-OUTPUT f-FleteUnitario, */
/*                                     INPUT s-TpoPed,               */
/*                                     INPUT f-factor,               */
/*                                     INPUT s-CodMon).              */
/*   ASSIGN                                                          */
/*       ITEM.Libre_d02 = f-FleteUnitario.                           */
  IF f-FleteUnitario > 0 THEN DO:
      /* El flete afecta el monto final */
      IF ITEM.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
          ASSIGN
              ITEM.PreUni = ROUND(f-PreVta + f-FleteUnitario, s-NroDec)  /* Incrementamos el PreUni */
              ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni.
      END.
      ELSE DO:      /* CON descuento promocional o volumen */
          /* El flete afecta al precio unitario resultante */
          DEF VAR x-PreUniFin LIKE Facdpedi.PreUni NO-UNDO.
          DEF VAR x-PreUniTeo LIKE Facdpedi.PreUni NO-UNDO.

          x-PreUniFin = ITEM.ImpLin / ITEM.CanPed.          /* Valor resultante */
          x-PreUniFin = x-PreUniFin + f-FleteUnitario.      /* Unitario Afectado al Flete */

          x-PreUniTeo = x-PreUniFin / ( ( 1 - ITEM.Por_Dsctos[1] / 100 ) * ( 1 - ITEM.Por_Dsctos[2] / 100 ) * ( 1 - ITEM.Por_Dsctos[3] / 100 ) ).
          /*MESSAGE item.implin item.canped f-fleteunitario x-preunifin x-preuniteo.*/

          ASSIGN
              ITEM.PreUni = ROUND(x-PreUniTeo, s-NroDec).

/*           ASSIGN                                                                         */
/*               ITEM.ImpLin = ITEM.ImpLin + (ITEM.CanPed * f-FleteUnitario)                */
/*               ITEM.PreUni = ROUND( (ITEM.ImpLin + ITEM.ImpDto) / ITEM.CanPed, s-NroDec). */
      END.
      ASSIGN
          ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                        ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                        ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                        ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
      IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
          THEN ITEM.ImpDto = 0.
          ELSE ITEM.ImpDto = (ITEM.CanPed * ITEM.PreUni) - ITEM.ImpLin.
  END.
  /* ***************************************************************** */

  ASSIGN
      ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
      ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
  IF ITEM.AftIsc 
  THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
  ELSE ITEM.ImpIsc = 0.
  IF ITEM.AftIgv 
  THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
  ELSE ITEM.ImpIgv = 0.

  x-item-hasta = STRING(TIME,"HH:MM:SS").

  IF s-adm-new-record = 'YES' THEN DO:
    ASSIGN ITEM.desmatweb = x-item-desde + " - " + x-item-hasta.
  END.

  /* REPETIDOS (NOTA: LA TABLA ITEM NO DEBE ESTAR EN "NO-UNDO") */
  IF CAN-FIND(FIRST B-ITEM WHERE B-ITEM.codmat = ITEM.codmat
              AND ROWID(B-ITEM) <> ROWID(ITEM) NO-LOCK) THEN DO:
      MESSAGE 'Product YA registrado' VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  /* ********* */

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Enable-Head').

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Imp-Total.

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
  IF RETURN-VALUE = "NO" THEN APPLY 'ENTRY':U TO ITEM.CodMat IN BROWSE {&BROWSE-NAME}.
/*   RUN GET-ATTRIBUTE('ADM-NEW-RECORD').                         */
/*   IF RETURN-VALUE = 'YES' THEN DO:                             */
/*       ITEM.codmat:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.     */
/*   END.                                                         */
/*   ELSE DO:                                                     */
/*       ITEM.codmat:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.    */
/*       APPLY 'ENTRY':U TO ITEM.AlmDes IN BROWSE {&BROWSE-NAME}. */
/*   END.                                                         */

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
  RUN Imp-Total.
  
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
  DEF VAR x-adm-new-record AS CHAR.
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  x-adm-new-record = RETURN-VALUE.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Imp-Total.
  RUN Procesa-Handle IN lh_handle ('Enable-Head').
  IF x-adm-new-record = "YES" THEN RUN Procesa-Handle IN lh_handle ('Add-Record').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Precios B-table-Win 
PROCEDURE Recalcular-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       NO se recalcula si se ha migrado el EDI para el IBC (Supermercados)
------------------------------------------------------------------------------*/

FOR EACH ITEM WHERE ITEM.Libre_c05 <> "OF",     /* NO promociones */
    FIRST Almmmatg OF ITEM NO-LOCK:
    ASSIGN
        F-FACTOR = ITEM.Factor
        f-PreVta = ITEM.PreUni
        f-PreBas = ITEM.PreBas
        f-Dsctos = ITEM.PorDto
        z-Dsctos = ITEM.Por_Dsctos[2]
        y-Dsctos = ITEM.Por_Dsctos[3].
    RUN {&precio-venta-general} (s-CodCia,
                                 s-CodDiv,
                                 s-CodCli,
                                 s-CodMon,
                                 s-TpoCmb,
                                 OUTPUT f-Factor,
                                 ITEM.codmat,
                                 s-FlgSit,
                                 ITEM.undvta,
                                 ITEM.CanPed,
                                 s-NroDec,
                                 ITEM.almdes,   /* Necesario para REMATES */
                                 OUTPUT f-PreBas,
                                 OUTPUT f-PreVta,
                                 OUTPUT f-Dsctos,
                                 OUTPUT y-Dsctos,
                                 OUTPUT x-TipDto,
                                 OUTPUT f-FleteUnitario,
                                 OUTPUT pMensaje
                                 ).
    ASSIGN 
        ITEM.Factor = f-Factor
        ITEM.PreUni = F-PREVTA
        ITEM.PreBas = F-PreBas 
        ITEM.PreVta[1] = F-PreVta     /* CONTROL DE PRECIO DE LISTA */
        ITEM.PorDto = F-DSCTOS  /* Ambos descuentos afectan */
        ITEM.PorDto2 = 0        /* el precio unitario */
        ITEM.Por_Dsctos[2] = z-Dsctos
        ITEM.Por_Dsctos[3] = Y-DSCTOS 
        ITEM.AftIgv = Almmmatg.AftIgv
        ITEM.AftIsc = Almmmatg.AftIsc
        ITEM.ImpIsc = 0
        ITEM.ImpIgv = 0.
    ASSIGN
        ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                    ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
    IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
        THEN ITEM.ImpDto = 0.
    ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
  /* ****************************************************************** */
  /* RHC 04/08/2015 Si existe f-FleteUnitario se recalcula el Descuento */
  /* RHC 04/05/2020 Nueva forma de calcular */
  /* ****************************************************************** */
  /* Ic - 28Set2018, si el flete debe considerarse, segun Karin Roden.... */
/*   RUN gn/factor-porcentual-flete-v2(INPUT s-CodDiv,               */
/*                                     INPUT ITEM.codmat,            */
/*                                     INPUT-OUTPUT f-FleteUnitario, */
/*                                     INPUT s-TpoPed,               */
/*                                     INPUT f-factor,               */
/*                                     INPUT s-CodMon).              */
  ASSIGN 
      ITEM.Libre_d02 = f-FleteUnitario. 
    IF f-FleteUnitario > 0 THEN DO:
        /* El flete afecta el monto final */
        IF ITEM.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
            ASSIGN
                ITEM.PreUni = ROUND(f-PreVta + f-FleteUnitario, s-NroDec)  /* Incrementamos el PreUni */
                ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni.
        END.
        ELSE DO:      /* CON descuento promocional o volumen */
          /* El flete afecta al precio unitario resultante */
          DEF VAR x-PreUniFin LIKE Facdpedi.PreUni NO-UNDO.
          DEF VAR x-PreUniTeo LIKE Facdpedi.PreUni NO-UNDO.

          x-PreUniFin = ITEM.ImpLin / ITEM.CanPed.          /* Valor resultante */
          x-PreUniFin = x-PreUniFin + f-FleteUnitario.      /* Unitario Afectado al Flete */

          x-PreUniTeo = x-PreUniFin / ( ( 1 - ITEM.Por_Dsctos[1] / 100 ) * ( 1 - ITEM.Por_Dsctos[2] / 100 ) * ( 1 - ITEM.Por_Dsctos[3] / 100 ) ).

          ASSIGN
              ITEM.PreUni = ROUND(x-PreUniTeo, s-NroDec).

/*             ASSIGN                                                                         */
/*                 ITEM.ImpLin = ITEM.ImpLin + (ITEM.CanPed * f-FleteUnitario)                */
/*                 ITEM.PreUni = ROUND( (ITEM.ImpLin + ITEM.ImpDto) / ITEM.CanPed, s-NroDec). */
        END.
      ASSIGN
          ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                        ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                        ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                        ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
      IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
          THEN ITEM.ImpDto = 0.
          ELSE ITEM.ImpDto = (ITEM.CanPed * ITEM.PreUni) - ITEM.ImpLin.
    END.
    /* ***************************************************************** */
    ASSIGN
        ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
        ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
    IF ITEM.AftIsc THEN 
        ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
    ELSE ITEM.ImpIsc = 0.
    IF ITEM.AftIgv THEN  
        ITEM.ImpIgv = ITEM.ImpLin - ROUND(ITEM.ImpLin  / (1 + (s-PorIgv / 100)),4).
    ELSE ITEM.ImpIgv = 0.
END.
/*RUN dispatch IN THIS-PROCEDURE ('open-query':U).*/

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
  {src/adm/template/snd-list.i "ITEM"}
  {src/adm/template/snd-list.i "B-MATG"}

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

  /* *********************************************************************************** */
  /* PRODUCTO */  
  /* *********************************************************************************** */
  
  DEFINE VAR x-codmat2 AS CHAR.   
  
  x-codmat2 = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

  IF ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''
      OR INTEGER(ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
      MESSAGE "Codigo de Producto no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
      AND Almmmatg.codmat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE 'Código de producto ' + x-codmat2 + ' NO registrado' VIEW-AS ALERT-BOX ERROR.
      ASSIGN ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  IF Almmmatg.TpoArt = "D" THEN DO:
      MESSAGE 'Código de producto ' + x-codmat2 + ' DESACTIVADO' VIEW-AS ALERT-BOX ERROR.
      ASSIGN ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  IF ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = x-articulo-ICBPER THEN DO:
      MESSAGE 'Código de producto ' + x-codmat2 + ' pertenece a IMPUESTO A LAS BOLSAS PLASTICAS' VIEW-AS ALERT-BOX ERROR.
      ASSIGN ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.

  FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
      AND  Almmmate.CodAlm = ITEM.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      AND  Almmmate.codmat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmate THEN DO:
      MESSAGE "Articulo " + x-codmat2 + " no asignado al almacén " ITEM.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
           VIEW-AS ALERT-BOX ERROR.
      ASSIGN ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
      APPLY 'ENTRY':U TO ITEM.AlmDes.
      RETURN "ADM-ERROR".
  END.
  /* *********************************************************************************** */
  /* FAMILIA DE VENTAS */
  /* *********************************************************************************** */
  FIND Almtfami OF Almmmatg NO-LOCK NO-ERROR.
  IF AVAILABLE Almtfami AND 
      Almtfami.SwComercial = NO THEN DO:
      MESSAGE 'Línea NO autorizada para ventas' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  FIND Almsfami OF Almmmatg NO-LOCK NO-ERROR.
  IF AVAILABLE Almsfami AND 
      AlmSFami.SwDigesa = YES AND 
      Almmmatg.VtoDigesa <> ? AND 
      Almmmatg.VtoDigesa < TODAY THEN DO:
      MESSAGE 'Producto ' + x-codmat2 + ' con autorización de DIGESA VENCIDA' VIEW-AS ALERT-BOX ERROR.
      ASSIGN ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  /* RHC 21/08/2012 CONTROL POR TIPO DE PRODUCTO */
  /* 31/10/2022 Acuerdo Daniel Llican */
  /* Acuerdo Cesar Camus y Lucy Mesia, si el producto ya esta fisicamente 
  en tienda minorista porque impedir la venta? no validar y permitir la venta.
  */
/*   IF Almmmatg.TpoMrg = "1" AND s-FlgTipoVenta = NO THEN DO:                     */
/*       MESSAGE "No se puede vender este producto " + x-codmat2 + " al por menor" */
/*           VIEW-AS ALERT-BOX ERROR.                                              */
/*       ASSIGN ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.            */
/*       APPLY 'ENTRY':U TO ITEM.CodMat.                                           */
/*       RETURN 'ADM-ERROR'.                                                       */
/*   END.                                                                          */
/*   IF Almmmatg.TpoMrg = "2" AND s-FlgTipoVenta = YES THEN DO:                    */
/*       MESSAGE "No se puede vender este producto " + x-codmat2 + " al por mayor" */
/*           VIEW-AS ALERT-BOX ERROR.                                              */
/*       ASSIGN ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.            */
/*       APPLY 'ENTRY':U TO ITEM.CodMat.                                           */
/*       RETURN 'ADM-ERROR'.                                                       */
/*   END.                                                                          */
  /* *********************************************************************************** */
  /* CANTIDAD */
  /* *********************************************************************************** */
  IF DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <= 0 THEN DO:
       MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO ITEM.CanPed.
       RETURN "ADM-ERROR".
  END.

  /* IMPSTO BOLSA PLASTICA */
  IF ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = x-articulo-ICBPER THEN DO:
      MESSAGE "Articulo " + x-codmat2 + " no es de venta" VIEW-AS ALERT-BOX ERROR.
      ASSIGN ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
      APPLY 'ENTRY':U TO ITEM.codmat.
      RETURN "ADM-ERROR".
  END.

  /* *********************************************************************************** */
  /* UNIDAD */
  /* *********************************************************************************** */
  DEFINE VAR pCanPed AS DEC NO-UNDO.
  DEFINE VAR pMensaje AS CHAR NO-UNDO.
  DEFINE VAR hProc AS HANDLE NO-UNDO.

  RUN vtagn/ventas-library PERSISTENT SET hProc.

  pCanPed = DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
  RUN VTA_Valida-Cantidad IN hProc (INPUT Almmmatg.CodMat,
                                    INPUT ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                                    INPUT-OUTPUT pCanPed,
                                    OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(pCanPed).
      ASSIGN ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  
  /* *********************************************************************************** */
  /* PRECIO */
  /* *********************************************************************************** */
  /* FACTOR DE EQUIVALENCIA */
  FIND FIRST Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
      AND Almtconv.Codalter = ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK.
  F-FACTOR = Almtconv.Equival.
  IF DECIMAL(ITEM.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Precio debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO ITEM.PreUni.
       RETURN "ADM-ERROR".
  END.
  /* *********************************************************************************** */
  /* STOCK COMPROMETIDO */
  /* *********************************************************************************** */
  DEF VAR s-StkComprometido AS DEC NO-UNDO.
  DEF VAR x-StkAct AS DEC NO-UNDO.
  RUN gn/Stock-Comprometido-v2 (ITEM.CodMat:SCREEN-VALUE IN BROWSE {&browse-name}, 
                                ITEM.AlmDes:SCREEN-VALUE IN BROWSE {&browse-name}, 
                                YES,    /* Tomar en cuenta venta contado */
                                OUTPUT s-StkComprometido).
  IF s-adm-new-record = 'NO' THEN DO:
      FIND Facdpedi WHERE Facdpedi.codcia = s-codcia
          AND Facdpedi.coddoc = s-coddoc
          AND Facdpedi.nroped = s-nroped
          AND Facdpedi.codmat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&browse-name}
          NO-LOCK NO-ERROR.
      IF AVAILABLE Facdpedi THEN s-StkComprometido = s-StkComprometido - ( Facdpedi.CanPed * Facdpedi.Factor ).
  END.
  ASSIGN
      x-CanPed = DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) * f-Factor
      x-StkAct = Almmmate.StkAct.
  IF (x-StkAct - s-StkComprometido) < x-CanPed
      THEN DO:
        MESSAGE "No hay STOCK suficiente" SKIP(1)
                "       STOCK ACTUAL : " x-StkAct Almmmatg.undbas SKIP
                "  STOCK COMPROMETIDO: " s-StkComprometido Almmmatg.undbas SKIP
                "   STOCK DISPONIBLE : " (x-StkAct - s-StkComprometido) Almmmatg.undbas SKIP
                VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO ITEM.CanPed.
        RETURN "ADM-ERROR".
  END.
  /* *********************************************************************************** */
  /* *********************************************************************************** */
  /* *********************************************************************************** */
  /* RHC 09/11/2012 NO CONTINUAMOS SI ES UN ALMACEN DE REMATE */
  /* *********************************************************************************** */
  FIND Almacen WHERE Almacen.codcia = s-codcia
      AND Almacen.codalm = ITEM.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK.
  IF Almacen.Campo-C[3] = "Si" THEN RETURN "OK".
  /* *********************************************************************************** */
  /* *********************************************************************************** */
  /* *********************************************************************************** */
  /* EMPAQUE */
  /* *********************************************************************************** */
  DEF VAR pSugerido AS DEC NO-UNDO.
  DEF VAR pEmpaque AS DEC NO-UNDO.
  pCanPed = DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
  RUN vtagn/p-cantidad-sugerida-v2 (INPUT s-CodDiv,
                                    INPUT s-CodDiv,
                                    INPUT Almmmatg.codmat,
                                    INPUT pCanPed,
                                    INPUT ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                                    INPUT s-CodCli,
                                    OUTPUT pSugerido,
                                    OUTPUT pEmpaque,
                                    OUTPUT pMensaje).
  IF pMensaje > '' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(pSugerido).
      APPLY 'ENTRY':U TO ITEM.CanPed.
      RETURN "ADM-ERROR".
  END.

/*   RUN VTA_Valida-Empaque IN hProc (INPUT s-CodCli,                                          */
/*                                    INPUT Almmmatg.codmat,                                   */
/*                                    INPUT-OUTPUT pCanPed,                                    */
/*                                    INPUT f-Factor,                                          */
/*                                    INPUT s-TpoPed,                                          */
/*                                    OUTPUT pMensaje).                                        */
/*   IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                                    */
/*       MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.                                             */
/*       ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(pCanPed).                  */
/*       APPLY 'ENTRY':U TO ITEM.CanPed.                                                       */
/*       RETURN "ADM-ERROR".                                                                   */
/*   END.                                                                                      */
/*   /* *********************************************************************************** */ */
/*   /* MINIMO DE VENTA */                                                                     */
/*   /* *********************************************************************************** */ */
/*   RUN VTA_Valida-Minimo IN hProc (INPUT Almmmatg.codmat,                                    */
/*                                   INPUT-OUTPUT pCanPed,                                     */
/*                                   INPUT f-Factor,                                           */
/*                                   OUTPUT pMensaje).                                         */
/*   IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                                    */
/*       MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.                                             */
/*       ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(pCanPed).                  */
/*       APPLY 'ENTRY':U TO ITEM.CanPed.                                                       */
/*       RETURN "ADM-ERROR".                                                                   */
/*   END.                                                                                      */

  DELETE PROCEDURE hProc.
  /* *********************************************************************************** */
  /* RHC 13.12.2010 Margen de Utilidad */
  /* *********************************************************************************** */
  /* CONTRATO MARCO, REMATES, EXPOLIBRERIA, LISTA EXPRESS: NO TIENE MINIMO NI MARGEN DE UTILIDAD */
  IF LOOKUP(s-TpoPed, "M,R") > 0 THEN RETURN "OK".   

  /* 02/11/2022 Acuerdo Daniel Llican 
  DEF VAR pError AS CHAR NO-UNDO.
  DEF VAR X-MARGEN AS DEC NO-UNDO.
  DEF VAR X-LIMITE AS DEC NO-UNDO.
  DEF VAR x-PreUni AS DEC NO-UNDO.

  x-PreUni = DECIMAL ( ITEM.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ) *
      ( 1 - DECIMAL (ITEM.Por_Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ) / 100 ) *
      ( 1 - DECIMAL (ITEM.Por_Dsctos[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} )/ 100 ) *
      ( 1 - DECIMAL (ITEM.Por_Dsctos[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ) / 100 ) .

  RUN pri/pri-librerias PERSISTENT SET hProc.
  RUN PRI_Valida-Margen-Utilidad IN hProc (INPUT s-CodDiv,
                                           INPUT ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                                           INPUT ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                                           INPUT x-PreUni,
                                           INPUT s-CodMon,
                                           OUTPUT x-Margen,
                                           OUTPUT x-Limite,
                                           OUTPUT pError).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      /* Error crítico */
      MESSAGE pError VIEW-AS ALERT-BOX ERROR TITLE 'CONTROL DE MARGEN'.
      ASSIGN ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN 'ADM-ERROR'.
  END.
  DELETE PROCEDURE hProc.
  */

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
IF AVAILABLE ITEM THEN 
    ASSIGN
    i-nroitm = ITEM.NroItm
    f-Factor = ITEM.Factor
    f-PreBas = ITEM.PreBas
    f-PreVta = ITEM.PreUni
    s-UndVta = ITEM.UndVta
    x-TipDto = ITEM.Libre_c04
    x-Adm-New-Record = "NO"
    f-FleteUnitario = ITEM.Libre_d02.
RUN Procesa-Handle IN lh_handle ('Disable-Head').

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDesMar B-table-Win 
FUNCTION fDesMar RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

IF NOT AVAILABLE ITEM THEN RETURN "".   /* Function return value. */
FIND Almmmatg OF ITEM NO-LOCK NO-ERROR.
IF AVAILABLE Almmmatg THEN RETURN Almmmatg.DesMar.
RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDesMat B-table-Win 
FUNCTION fDesMat RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

IF NOT AVAILABLE ITEM THEN RETURN "".   /* Function return value. */
FIND Almmmatg OF ITEM NO-LOCK NO-ERROR.
IF AVAILABLE Almmmatg THEN RETURN Almmmatg.DesMat.
RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

