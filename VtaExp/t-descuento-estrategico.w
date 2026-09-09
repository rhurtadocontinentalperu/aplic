&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE PEDI LIKE FacDPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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

DEFINE BUFFER B-PEDI FOR PEDI.

&SCOPED-DEFINE Condicion ( PEDI.Libre_c05 <> 'OF' )

&SCOPED-DEFINE Condicion2 ( B-PEDI.Libre_c05 <> 'OF' )

DEF VAR s-PorIgv AS DEC.
DEF VAR s-CodMon AS INT.
DEF VAR s-TpoCmb AS DEC.
DEF VAR s-NroDec AS INT.

/* Para forzar la evaluación del margen de utilidad */
DEF NEW SHARED VAR s-coddiv AS CHAR INIT ''.


DEF SHARED VAR lh_handle AS HANDLE.

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
&Scoped-define INTERNAL-TABLES PEDI Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table PEDI.codmat Almmmatg.DesMat ~
PEDI.CanPed PEDI.UndVta PEDI.PreUni PEDI.Por_Dsctos[1] PEDI.Por_Dsctos[3] ~
PEDI.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table PEDI.Por_Dsctos[1] 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table PEDI
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table PEDI
&Scoped-define QUERY-STRING-br_table FOR EACH PEDI WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      EACH Almmmatg OF PEDI NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH PEDI WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      EACH Almmmatg OF PEDI NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table PEDI Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table PEDI
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-ImpTot 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fComision B-table-Win 
FUNCTION fComision RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-ImpTot AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "IMPORTE TOTAL" 
     VIEW-AS FILL-IN 
     SIZE 18.72 BY .81
     BGCOLOR 1 FGCOLOR 15 FONT 5 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      PEDI, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      PEDI.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U WIDTH 7.43
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 60.43
      PEDI.CanPed FORMAT ">,>>>,>>9.99":U WIDTH 7.43
      PEDI.UndVta FORMAT "x(8)":U WIDTH 6.43
      PEDI.PreUni FORMAT ">,>>>,>>9.999999":U WIDTH 10.43
      PEDI.Por_Dsctos[1] COLUMN-LABEL "% Dscto!Estratégico" FORMAT "->,>>9.999999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      PEDI.Por_Dsctos[3] COLUMN-LABEL "% Dscto!PROM-VOL" FORMAT "->,>>9.999999":U
            WIDTH 8.43
      PEDI.ImpLin FORMAT "->>,>>>,>>9.99":U WIDTH 7.14
  ENABLE
      PEDI.Por_Dsctos[1]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 134 BY 16.42
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN-ImpTot AT ROW 17.69 COL 100 COLON-ALIGNED WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: PEDI T "?" ? INTEGRAL FacDPedi
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
         HEIGHT             = 18
         WIDTH              = 136.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

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
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.PEDI,INTEGRAL.Almmmatg OF Temp-Tables.PEDI"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > Temp-Tables.PEDI.codmat
"PEDI.codmat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "60.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.PEDI.CanPed
"PEDI.CanPed" ? ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.PEDI.UndVta
"PEDI.UndVta" ? ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.PEDI.PreUni
"PEDI.PreUni" ? ? "decimal" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.PEDI.Por_Dsctos[1]
"PEDI.Por_Dsctos[1]" "% Dscto!Estratégico" ? "decimal" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.PEDI.Por_Dsctos[3]
"PEDI.Por_Dsctos[3]" "% Dscto!PROM-VOL" ? "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.PEDI.ImpLin
"PEDI.ImpLin" ? ? "decimal" ? ? ? ? ? ? no ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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

ON 'RETURN':U OF PEDI.Por_Dsctos[1]
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcular-Detalle B-table-Win 
PROCEDURE Calcular-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER FILL-IN-PorDto AS DEC.
DEF INPUT PARAMETER s-NroDec AS INT.
DEF INPUT PARAMETER s-PorIgv AS DEC.

DEF VAR pError AS CHAR NO-UNDO.
DEF VAR X-MARGEN AS DEC NO-UNDO.
DEF VAR X-LIMITE AS DEC NO-UNDO.
DEF VAR x-PreUni AS DEC NO-UNDO.

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN pri/pri-librerias PERSISTENT SET hProc.

FOR EACH PEDI WHERE {&Condicion}, FIRST Almmmatg OF PEDI NO-LOCK:
    /* Validamos Margen de Utilidad */
    x-PreUni = PEDI.PreUni *
/*         ( 1 - PEDI.Por_Dsctos[1] / 100 ) * */
        ( 1 - FILL-IN-PorDto / 100 ) *      /* OJO */
        ( 1 - PEDI.Por_Dsctos[2] / 100 ) * 
        ( 1 - PEDI.Por_Dsctos[3] / 100 ) .

    /* 31/01/2023: Nueva rutina de margen */
    RUN PRI_Valida-Margen-Utilidad IN hProc (INPUT s-CodDiv,
                                             INPUT PEDI.CodMat,
                                             INPUT PEDI.UndVta,
                                             INPUT x-PreUni,
                                             INPUT s-CodMon,
                                             OUTPUT x-Margen,
                                             OUTPUT x-Limite,
                                             OUTPUT pError).
    IF RETURN-VALUE = 'ADM-ERROR' OR pError > '' THEN NEXT.
/*     RUN vtagn/p-margen-utilidad (                                          */
/*         PEDI.CodMat,      /* Producto */                                   */
/*         x-PreUni,  /* Precio de venta unitario */                          */
/*         PEDI.UndVta,                                                       */
/*         s-CodMon,       /* Moneda de venta */                              */
/*         s-TpoCmb,       /* Tipo de cambio */                               */
/*         NO,            /* Muestra el error */                              */
/*         "",                                                                */
/*         OUTPUT x-Margen,        /* Margen de utilidad */                   */
/*         OUTPUT x-Limite,        /* Margen mínimo de utilidad */            */
/*         OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */ */
/*         ).                                                                 */
/*     IF pError = "ADM-ERROR" THEN NEXT.                                     */
    /* **************************** */
    ASSIGN
        PEDI.PreUni = PEDI.PreUni - PEDI.Libre_d02.
    ASSIGN
        PEDI.Por_Dscto[1] = FILL-IN-PorDto.
    ASSIGN
        PEDI.ImpLin = ROUND ( PEDI.CanPed * PEDI.PreUni *       /* OJO */
                    ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                    ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                    ( 1 - PEDI.Por_Dsctos[3] / 100 ), 2 ).
    IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
        THEN PEDI.ImpDto = 0.
        ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin. /* OJO */
    /* RHC 04/08/2015 Si existe PEDI.Libre_d02 se recalcula el Descuento */
    IF PEDI.Libre_d02 > 0 THEN DO:
        /* El flete afecta el monto final */
        IF PEDI.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
            ASSIGN
                PEDI.PreUni = ROUND(PEDI.PreUni + PEDI.Libre_d02, s-NroDec)  /* Incrementamos el PreUni */
                PEDI.ImpLin = PEDI.CanPed * PEDI.PreUni.
        END.
        ELSE DO:      /* CON descuento promocional o volumen */
            ASSIGN
                PEDI.ImpLin = PEDI.ImpLin + (PEDI.CanPed * PEDI.Libre_d02)
                PEDI.PreUni = ROUND( (PEDI.ImpLin + PEDI.ImpDto) / PEDI.CanPed, s-NroDec).
        END.
    END.
    /* ***************************************************************** */
    ASSIGN
        PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
        PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
    IF PEDI.AftIsc 
    THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
    ELSE PEDI.ImpIsc = 0.
    IF PEDI.AftIgv 
    THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
    ELSE PEDI.ImpIgv = 0.
END.
DELETE PROCEDURE hProc.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle B-table-Win 
PROCEDURE Carga-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER TABLE FOR PEDI.
DEF INPUT PARAMETER pPorIgv AS DEC.
DEF INPUT PARAMETER pCodMon AS INT.
DEF INPUT PARAMETER pTpoCmb AS DEC.
DEF INPUT PARAMETER pNroDec AS INT.

s-PorIgv = pPorIgv.
s-CodMon = pCodMon.
s-TpoCmb = pTpoCmb.
s-NroDec = pNroDec.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar-y-Salir B-table-Win 
PROCEDURE Grabar-y-Salir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.

DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR I-NPEDI AS INTEGER NO-UNDO INIT 0.
DEF VAR x-Articulo-ICBPer AS CHAR INIT '099268'.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR' :
    {lib/lock-genericov3.i ~
        &Tabla="Faccpedi" ~
        &Condicion="ROWID(Faccpedi) = pRowid" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    /* Verificamos Información */
    IF FacCPedi.FlgEst <> "P" THEN DO:
        MESSAGE 'La COT ya no se puede aplicar el descuento' VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    FIND FIRST Facdpedi OF Faccpedi WHERE Facdpedi.CanAte > 0 NO-LOCK NO-ERROR.
    IF AVAILABLE Facdpedi THEN DO:
        MESSAGE 'La COT ya no se puede aplicar el descuento' VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* Elimimamos detalle */
    REPEAT:
        FIND FIRST Facdpedi OF Faccpedi NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Facdpedi THEN LEAVE.
        FIND FIRST Facdpedi OF Faccpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje"}
            MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        DELETE Facdpedi.
    END.
    /* Regrabamos */
    FOR EACH PEDI WHERE BY PEDI.NroItm:
        I-NPEDI = I-NPEDI + 1.
        CREATE FacDPedi.
        BUFFER-COPY PEDI 
            TO FacDPedi
            ASSIGN
            FacDPedi.CodCia = FacCPedi.CodCia
            FacDPedi.CodDiv = FacCPedi.CodDiv
            FacDPedi.coddoc = FacCPedi.coddoc
            FacDPedi.NroPed = FacCPedi.NroPed
            FacDPedi.FchPed = FacCPedi.FchPed
            FacDPedi.Hora   = FacCPedi.Hora 
            FacDPedi.FlgEst = FacCPedi.FlgEst
            FacDPedi.NroItm = I-NPEDI.
    END.
    /* Totales */
    /*{vta2/graba-totales-cotizacion-cred.i}*/
    /* ****************************************************************************************** */
    /* ****************************************************************************************** */
    {vtagn/totales-cotizacion-sunat.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
    /* ****************************************************************************************** */
    /* Importes SUNAT */
    /* ****************************************************************************************** */
    DEF VAR hProc AS HANDLE NO-UNDO.
    RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
    RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                 INPUT Faccpedi.CodDoc,
                                 INPUT Faccpedi.NroPed,
                                 OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
    DELETE PROCEDURE hProc.
    /* ****************************************************************************************** */
    /* ****************************************************************************************** */
    /* RHC 20/07/2017 Comisiones */
    FOR EACH Facdpedi OF Faccpedi EXCLUSIVE-LOCK:
        /* Grabamos la Comisión del Vendedor */
        FacDPedi.Libre_d04 = fComision().
    END.
END.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
RETURN 'OK'.

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
DEF BUFFER B-MATG FOR Almmmatg.
FOR EACH B-PEDI WHERE {&Condicion2},
    FIRST B-MATG OF B-PEDI NO-LOCK:
    FILL-IN-ImpTot = FILL-IN-ImpTot + B-PEDI.ImpLin.
END.
DISPLAY FILL-IN-ImpTot WITH FRAME {&FRAME-NAME}.

RUN Pinta-Saldo IN lh_handle (FILL-IN-ImpTot).

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
  /*{vta2/calcula-linea-detalle.i &Tabla="PEDI"}*/
  ASSIGN
      PEDI.PreUni = PEDI.PreUni - PEDI.Libre_d02.               /* OJO */
  ASSIGN
      PEDI.ImpLin = ROUND ( PEDI.CanPed * PEDI.PreUni *       /* OJO */
                  ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                  ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                  ( 1 - PEDI.Por_Dsctos[3] / 100 ), 2 ).
  IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
      THEN PEDI.ImpDto = 0.
      ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin. /* OJO */
  /* RHC 04/08/2015 Si existe PEDI.Libre_d02 se recalcula el Descuento */
  IF PEDI.Libre_d02 > 0 THEN DO:
      /* El flete afecta el monto final */
      IF PEDI.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
          ASSIGN
              PEDI.PreUni = ROUND(PEDI.PreUni + PEDI.Libre_d02, s-NroDec)  /* Incrementamos el PreUni */
              PEDI.ImpLin = PEDI.CanPed * PEDI.PreUni.
      END.
      ELSE DO:      /* CON descuento promocional o volumen */
          ASSIGN
              PEDI.ImpLin = PEDI.ImpLin + (PEDI.CanPed * PEDI.Libre_d02)
              PEDI.PreUni = ROUND( (PEDI.ImpLin + PEDI.ImpDto) / PEDI.CanPed, s-NroDec).
      END.
  END.
  /* ***************************************************************** */
  ASSIGN
      PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
      PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
  IF PEDI.AftIsc 
  THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
  ELSE PEDI.ImpIsc = 0.
  IF PEDI.AftIgv 
  THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
  ELSE PEDI.ImpIgv = 0.


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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields B-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Procesa-Handle IN lh_handle ("Enable-Buttons").

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

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
  RUN Procesa-Handle IN lh_handle ("Disable-Buttons").

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

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
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Imp-Total.

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
  {src/adm/template/snd-list.i "PEDI"}
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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR pError AS CHAR NO-UNDO.
  DEF VAR X-MARGEN AS DEC NO-UNDO.
  DEF VAR X-LIMITE AS DEC NO-UNDO.
  DEF VAR x-PreUni AS DEC NO-UNDO.

  DEFINE VAR hProc AS HANDLE NO-UNDO.

  RUN pri/pri-librerias PERSISTENT SET hProc.

  x-PreUni = DECIMAL ( PEDI.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ) *
      ( 1 - DECIMAL (PEDI.Por_Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ) / 100 ) *
      ( 1 - PEDI.Por_Dsctos[2]/ 100 ) *
      ( 1 - PEDI.Por_Dsctos[3] / 100 ) .
  /* 31/01/2023: Nueva rutina de margen */
  RUN PRI_Valida-Margen-Utilidad IN hProc (INPUT s-CodDiv,
                                           INPUT PEDI.CodMat,
                                           INPUT PEDI.UndVta,
                                           INPUT x-PreUni,
                                           INPUT s-CodMon,
                                           OUTPUT x-Margen,
                                           OUTPUT x-Limite,
                                           OUTPUT pError).
  DELETE PROCEDURE hProc.

/*   RUN vtagn/p-margen-utilidad (                                              */
/*       PEDI.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},      /* Producto */ */
/*       x-PreUni,  /* Precio de venta unitario */                              */
/*       PEDI.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},                     */
/*       s-CodMon,       /* Moneda de venta */                                  */
/*       s-TpoCmb,       /* Tipo de cambio */                                   */
/*       NO,            /* Muestra el error */                                  */
/*       "",                                                                    */
/*       OUTPUT x-Margen,        /* Margen de utilidad */                       */
/*       OUTPUT x-Limite,        /* Margen mínimo de utilidad */                */
/*       OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */     */
/*       ).                                                                     */
/*   IF pError = "ADM-ERROR" THEN DO:                                           */
  IF RETURN-VALUE = 'ADM-ERROR' OR pError > "" THEN DO:
      MESSAGE "Margen de Utilidad muy bajo" SKIP
          "Margen de utilidad =" x-Margen SKIP
          "Margen mínimo de utilidad =" x-Limite SKIP
          "Continuamos con la grabación?" VIEW-AS ALERT-BOX QUESTION
          BUTTONS YES-NO UPDATE rpta AS LOG.
      IF rpta = NO THEN DO:
          APPLY 'ENTRY':U TO PEDI.Por_Dsctos[1].
          RETURN 'ADM-ERROR'.
      END.
  END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fComision B-table-Win 
FUNCTION fComision RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-ImpComision AS DEC INIT 0 NO-UNDO.

  RUN vtagn/p-comision-por-producto (
      INPUT FacCPedi.FchPed,
      INPUT FacCPedi.CodDiv,
      INPUT FacCPedi.CodVen,
      INPUT FacCPedi.FmaPgo,
      INPUT FacDPedi.CodMat,
      INPUT FacDPedi.CanPed,
      INPUT (FacDPedi.ImpLin - FacDPedi.ImpIgv),
      INPUT FacCPedi.CodMon,
      OUTPUT x-ImpComision)
      .
  RETURN x-ImpComision.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

