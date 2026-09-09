&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS q-tables 
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

  Description: from QUERY.W - Template For Query objects in the ADM

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

DEFINE SHARED VAR s-codcliente AS CHAR.
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VAR cl-codcia AS INT.

/* Local Variable Definitions ---                                       */
DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.
DEFINE VAR x-codcli AS CHAR.
DEFINE SHARED VAR x-tipo AS CHAR.

&SCOPED-DEFINE CONDICION ( ~
            INTEGRAL.ccbcdocu.CodCia = s-codcia AND ~
            INTEGRAL.ccbcdocu.CodDoc = x-coddoc AND ~
            integral.ccbcdocu.nrodoc = x-nrodoc AND ~
            INTEGRAL.ccbcdocu.flgest <> 'A' )

DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartQuery
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,Navigation-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME FRAME-B
&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gn-clie

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for QUERY Query-Main                                     */
&Scoped-define QUERY-STRING-Query-Main FOR EACH gn-clie WHERE ~{&KEY-PHRASE} ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gn-clie WHERE ~{&KEY-PHRASE} ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-Query-Main gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gn-clie


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 FILL-IN-CodCli COMBO-BOX-coddoc ~
FILL-IN-serie FILL-IN-numero BUTTON-6 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-ruc FILL-IN-dircli FILL-IN-CodCli ~
COMBO-BOX-coddoc FILL-IN_NomCli FILL-IN-dni FILL-IN-serie FILL-IN-numero ~
FILL-IN-cond-vta FILL-IN-des-cond-vta FILL-IN-fchdoc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" q-tables _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&QUERY-NAME
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" q-tables _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&QUERY-NAME
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
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/b-buscar.ico":U
     LABEL "Button 1" 
     SIZE 4 BY 1.12.

DEFINE BUTTON BUTTON-6 
     LABEL "Aceptar" 
     SIZE 12 BY .92.

DEFINE VARIABLE COMBO-BOX-coddoc AS CHARACTER FORMAT "X(50)":U INITIAL "FAC" 
     LABEL "Tipo documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Factura","FAC"
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-cond-vta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cond.Vta" 
     VIEW-AS FILL-IN 
     SIZE 4.43 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-des-cond-vta AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 32.72 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-dircli AS CHARACTER FORMAT "X(100)":U 
     LABEL "Direccion" 
     VIEW-AS FILL-IN 
     SIZE 53.29 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-dni AS CHARACTER FORMAT "X(10)":U 
     LABEL "D.N.I." 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-fchdoc AS DATE FORMAT "99/99/9999":U 
     LABEL "F.Emision" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-numero AS INTEGER FORMAT "99999999":U INITIAL 0 
     LABEL "Numero" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .73 NO-UNDO.

DEFINE VARIABLE FILL-IN-ruc AS CHARACTER FORMAT "X(13)":U 
     LABEL "R.U.C." 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-serie AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 4.29 BY .77 NO-UNDO.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "x(250)" 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81
     BGCOLOR 15 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gn-clie SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME FRAME-B
     BUTTON-1 AT ROW 1.12 COL 2.14 WIDGET-ID 66
     FILL-IN-ruc AT ROW 3.15 COL 7.43 COLON-ALIGNED WIDGET-ID 68
     FILL-IN-dircli AT ROW 4.04 COL 7.29 COLON-ALIGNED WIDGET-ID 72
     FILL-IN-CodCli AT ROW 1.23 COL 10.29 COLON-ALIGNED WIDGET-ID 64
     COMBO-BOX-coddoc AT ROW 2.19 COL 11.43 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_NomCli AT ROW 1.23 COL 25.86 NO-LABEL WIDGET-ID 26
     FILL-IN-dni AT ROW 3.15 COL 26.86 COLON-ALIGNED WIDGET-ID 74
     FILL-IN-serie AT ROW 2.15 COL 32.72 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-numero AT ROW 2.15 COL 44.14 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-cond-vta AT ROW 3.15 COL 46.57 COLON-ALIGNED WIDGET-ID 76
     FILL-IN-des-cond-vta AT ROW 3.12 COL 51.29 COLON-ALIGNED NO-LABEL WIDGET-ID 78
     BUTTON-6 AT ROW 2.15 COL 58 WIDGET-ID 10
     FILL-IN-fchdoc AT ROW 4.04 COL 68.72 COLON-ALIGNED WIDGET-ID 80
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85.57 BY 4.35
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartQuery
   Allow: Basic,Query
   Frames: 1
   Add Fields to: NEITHER
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
  CREATE WINDOW q-tables ASSIGN
         HEIGHT             = 4.35
         WIDTH              = 85.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB q-tables 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmquery.i}
{src/adm/method/query.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW q-tables
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME FRAME-B
   FRAME-NAME L-To-R,COLUMNS                                            */
/* SETTINGS FOR FILL-IN FILL-IN-cond-vta IN FRAME FRAME-B
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-des-cond-vta IN FRAME FRAME-B
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-dircli IN FRAME FRAME-B
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-dni IN FRAME FRAME-B
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-fchdoc IN FRAME FRAME-B
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ruc IN FRAME FRAME-B
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME FRAME-B
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main
/* Query rebuild information for QUERY Query-Main
     _TblList          = "INTEGRAL.gn-clie"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "gn-clie.CodCia = cl-codcia"
     _Design-Parent    is WINDOW q-tables @ ( 2.08 , 80.14 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 q-tables
ON CHOOSE OF BUTTON-1 IN FRAME FRAME-B /* Button 1 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('qbusca':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 q-tables
ON CHOOSE OF BUTTON-6 IN FRAME FRAME-B /* Aceptar */
DO:
    IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE "Elija un cliente por favor" VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

    DEFINE VAR x-dias-antiguedad-doc AS INT.
    DEFINE VAR x-dias-validos AS INT.

    ASSIGN combo-box-coddoc fill-in-serie fill-in-numero.

    x-coddoc = combo-box-coddoc.
    x-nrodoc = STRING(fill-in-serie,"999") + STRING(fill-in-numero,"99999999").
    x-codcli = gn-clie.codcli.

    x-dias-validos = 365.

    fill-in-des-cond-vta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    fill-in-cond-vta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    fill-in-fchdoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                              ccbcdocu.coddoc = x-coddoc AND 
                              ccbcdocu.nrodoc = x-nrodoc AND 
                              ccbcdocu.codcli = x-codcli NO-LOCK NO-ERROR.

    IF AVAILABLE ccbcdocu THEN DO:

        /* Validar si la condicion de venta del documento de referencia permite generar N/C */
        FIND FIRST gn-convt WHERE gn-convt.codig = ccbcdocu.fmapgo NO-LOCK NO-ERROR.
        IF gn-convt.libre_c01 <> 'SI' THEN DO:
            MESSAGE "La condicion de venta del documento" SKIP
                    "que va servir de referencia para la N/C" SKIP
                    "no esta habilitado para generar Notas de Credito"
                    VIEW-AS ALERT-BOX INFORMATION.
            RETURN NO-APPLY.
        END.

        /* antigueda del documento */

        DEFINE VAR hProc AS HANDLE NO-UNDO.         /* Handle Libreria */

        RUN ccb\libreria-ccb.r PERSISTENT SET hProc.

        /* x-tipo : Concepto */
        RUN antiguedad-cmpte-referenciado IN hProc (INPUT x-tipo, OUTPUT x-dias-validos).

        DELETE PROCEDURE hProc.                     /* Release Libreria */

        x-dias-antiguedad-doc = TODAY - ccbcdocu.fchdoc.

        /*IF x-dias-validos > 0 THEN DO:*/
            IF x-dias-antiguedad-doc > x-dias-validos  THEN DO:
                MESSAGE "El comprobante al que se esta usando como referencia" SKIP
                        "es demasiado antiguo, tiene " + STRING(x-dias-antiguedad-doc) + " dias de emitido" SKIP
                        "como maximo de antigueda es " + STRING(x-dias-validos) + " dias"
                        "Imposible generar la PRE-NOTA" 
                        VIEW-AS ALERT-BOX INFORMATION.

                RETURN NO-APPLY.

            END.
        /*END.*/

        output-var-1 = ROWID(ccbcdocu).

        fill-in-des-cond-vta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
        fill-in-cond-vta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ccbcdocu.fmapgo.
        fill-in-fchdoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ccbcdocu.fchdoc,"99/99/9999").

        FIND FIRST gn-convt WHERE gn-convt.codig = ccbcdocu.fmapgo NO-LOCK NO-ERROR.
        IF AVAILABLE gn-convt THEN DO:
            fill-in-des-cond-vta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-convt.nombr.
        END.
        
        /*IF ccbcdocu.sdoact <= 0 THEN DO:*/
            /* Verificamos que el documento referenciado no tenga aplicaciones de nota de credito */
            DEFINE VAR x-amortizacion-nc AS DEC.
            DEFINE VAR x-impte-cmpte AS DEC.

            /*x-impte-cmpte = ccbcdocu.imptot.*/
            x-impte-cmpte = ccbcdocu.TotalPrecioVenta.

            /* Ic - 15Dic2021 - Verificamos si tiene A/C para sacar le importe real del comprobante */
            IF ccbcdocu.imptot2 > 0 THEN DO:
                FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = s-codcia AND
                                                FELogComprobantes.coddoc = x-coddoc AND
                                                FELogComprobantes.nrodoc = x-nrodoc NO-LOCK NO-ERROR.
                IF AVAILABLE FELogComprobantes THEN DO:
                    IF NUM-ENTRIES(FELogComprobantes.dataQR,"|") > 5 THEN DO:
                        IF x-impte-cmpte <= 0 THEN x-impte-cmpte = DEC(TRIM(ENTRY(6,FELogComprobantes.dataQR,"|"))).
                    END.
                END.
            END.

            IF ccbcdocu.codmon = 2 THEN x-impte-cmpte = x-impte-cmpte * ccbcdocu.tpocmb.

            DEFINE VAR x-hProc AS HANDLE NO-UNDO.         /* Handle Libreria */

            RUN ccb\libreria-ccb.r PERSISTENT SET x-hProc.

            /* Procedimientos */
            RUN amortizaciones-con-nc IN x-hProc (INPUT x-coddoc, INPUT x-nrodoc, OUTPUT x-amortizacion-nc).        

            DELETE PROCEDURE x-hProc.                     /* Release Libreria */

            IF x-amortizacion-nc >= x-impte-cmpte THEN DO:
                MESSAGE "El comprobante al que se esta usando como referencia" SKIP
                        "a sido amortizado con notas de credito" SKIP
                        "Imposible generar la PRE-NOTA" 
                        VIEW-AS ALERT-BOX INFORMATION.
                RETURN NO-APPLY.
            END.
        /*END.*/

    END.
    ELSE DO:
        output-var-1 = ?.
        MESSAGE "Documento no existe" VIEW-AS ALERT-BOX INFORMATION.
    END.
    
    RUN Procesa-Handle IN lh_Handle (INPUT 'items', INPUT output-var-1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli q-tables
ON LEAVE OF FILL-IN-CodCli IN FRAME FRAME-B /* Cliente */
OR RETURN OF FILL-IN-CodCli
DO:
  ASSIGN {&self-name}.
  RUN Ubica-Registro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK q-tables 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available q-tables  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI q-tables  _DEFAULT-DISABLE
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
  HIDE FRAME FRAME-B.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize q-tables 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME} :
      combo-box-coddoc:SCREEN-VALUE = 'FAC'.
      fill-in-serie:SCREEN-VALUE = '000'.
      fill-in-numero:SCREEN-VALUE = '00000000'.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-qbusca q-tables 
PROCEDURE local-qbusca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'qbusca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
      RUN lkup/c-client ("Clientes").
      IF OUTPUT-VAR-1 <> ? THEN DO:
           FIND {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} WHERE
                ROWID({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}) = OUTPUT-VAR-1
                NO-LOCK NO-ERROR.
           IF AVAIL {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} THEN DO:
               FILL-IN-CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}.codcli.
               FILL-IN_NomCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}.nomcli.
               FILL-IN-dirCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}.dircli.
               FILL-IN-ruc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}.ruc.
               FILL-IN-dni:SCREEN-VALUE IN FRAME {&FRAME-NAME} = {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}.dni.

               REPOSITION {&QUERY-NAME}  TO ROWID OUTPUT-VAR-1 NO-ERROR.
               IF NOT ERROR-STATUS:ERROR THEN RUN dispatch IN THIS-PROCEDURE ('get-next':U).
           END.
           output-var-1 = ?.
      END.
      RUN Procesa-Handle IN lh_Handle (INPUT 'items', INPUT output-var-1).
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records q-tables  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "gn-clie"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed q-tables 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/qstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ubica-registro q-tables 
PROCEDURE ubica-registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = FILL-IN-CodCli
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie THEN output-var-1 = ROWID(gn-clie).
ELSE output-var-1 = ?.
IF OUTPUT-VAR-1 <> ? THEN DO:

    COMBO-BOX-coddoc:DELETE(COMBO-BOX-coddoc:LIST-ITEM-PAIRS) IN FRAME {&FRAME-NAME}.

   FIND FIRST {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} WHERE
        ROWID({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
   IF AVAIL {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} THEN DO:
      REPOSITION {&QUERY-NAME}  TO ROWID OUTPUT-VAR-1 NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN DO:
          RUN dispatch IN THIS-PROCEDURE ('get-next':U).
          DISPLAY gn-clie.nomcli @ FILL-IN_NomCli WITH FRAME {&FRAME-NAME}.
          DISPLAY gn-clie.ruc @ FILL-IN-ruc WITH FRAME {&FRAME-NAME}.
          DISPLAY gn-clie.dni @ FILL-IN-dni WITH FRAME {&FRAME-NAME}.
          DISPLAY gn-clie.dircli @ FILL-IN-dircli WITH FRAME {&FRAME-NAME}.
          DISPLAY gn-clie.dircli @ FILL-IN-dircli WITH FRAME {&FRAME-NAME}.
      END.

      FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                    x-ccbcdocu.codcli = FILL-IN-CodCli AND
                                    x-ccbcdocu.flgest = 'C' AND
                                    x-ccbcdocu.coddoc = 'FAC' NO-LOCK NO-ERROR.
      IF NOT AVAILABLE x-ccbcdocu THEN DO:
          FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                        x-ccbcdocu.codcli = FILL-IN-CodCli AND
                                        x-ccbcdocu.flgest = 'P' AND
                                        x-ccbcdocu.coddoc = 'FAC' NO-LOCK NO-ERROR.
          IF NOT AVAILABLE x-ccbcdocu THEN DO:
              COMBO-BOX-coddoc:ADD-LAST("Boleta", "BOL").
              ASSIGN COMBO-BOX-coddoc:SCREEN-VALUE = "BOL".
          END.
          ELSE DO:
              COMBO-BOX-coddoc:ADD-LAST("Factura", "FAC").
              ASSIGN COMBO-BOX-coddoc:SCREEN-VALUE = "FAC".
          END.
      END.
      ELSE DO:
        COMBO-BOX-coddoc:ADD-LAST("Factura", "FAC").
        ASSIGN COMBO-BOX-coddoc:SCREEN-VALUE = "FAC".
      END.

   END.
   output-var-1 = ?.   
END.

RUN Procesa-Handle IN lh_Handle (INPUT 'items', INPUT output-var-1).


END PROCEDURE.

/*
        COMBO-BOX-SubFam:DELETE(COMBO-BOX-SubFam:LIST-ITEMS).
            COMBO-BOX-SubFam:ADD-LAST('Todos').
            COMBO-BOX-SubFam:SCREEN-VALUE = 'Todos'

COMBO-BOX-procesos:DELETE(COMBO-BOX-procesos:LIST-ITEM-PAIRS).
COMBO-BOX-procesos:ADD-LAST(factabla.nombre, factabla.codigo).

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

