&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-interface-comprobantes-oo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-interface-comprobantes-oo 
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

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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

DEFINE SHARED VAR s-codcia AS INT.

DEFINE TEMP-TABLE tt-header
    FIELDS  codcia      AS INT     FORMAT '>9'   COLUMN-LABEL "Cia"
    FIELDS  coddoc      AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Codigo"
    FIELDS  nrodoc      AS CHAR     FORMAT 'x(15)'   COLUMN-LABEL "Numero"
    FIELDS  fchdoc      AS DATE        COLUMN-LABEL "Fecha"
    FIELDS  codcli      AS CHAR     FORMAT 'x(11)'   COLUMN-LABEL "Cliente"
    FIELDS  nomcli      AS CHAR     FORMAT 'x(80)'   COLUMN-LABEL "Nombre"
    FIELDS  dircli      AS CHAR     FORMAT 'x(120)'   COLUMN-LABEL "Direccion"
    FIELDS  ruc      AS CHAR     FORMAT 'x(11)'   COLUMN-LABEL "RUC"
    FIELDS  codped      AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "CodPed"
    FIELDS  nroped      AS CHAR     FORMAT 'x(15)'   COLUMN-LABEL "Pedido"
    FIELDS  nroord      AS CHAR     FORMAT 'x(15)'   COLUMN-LABEL "Orden de Compra"
    FIELDS  impbrt      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "Importe Bruto"
    FIELDS  impexo      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "Importe Exonerado"
    FIELDS  porigv      AS DEC     FORMAT '->,>>9.9999'   COLUMN-LABEL "%I.G.V."
    FIELDS  impigv      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "Importe I.G.V."
    FIELDS  impdto      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "Importe descuento"
    FIELDS  imptot      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "Importe Total"
    FIELDS  flgest      AS CHAR     FORMAT 'x(1)'   COLUMN-LABEL "Estado"
    FIELDS  monvta      AS INT     FORMAT '>9'   COLUMN-LABEL "Moneda"
    FIELDS  tpocmb      AS DEC     FORMAT '->>9.9999'   COLUMN-LABEL "Tipo Cambio"
    FIELDS  codalm      AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Almacen"
    FIELDS  lugent      AS CHAR     FORMAT 'x(120)'   COLUMN-LABEL "Lugar entrega"
    FIELDS  tipdoc      AS CHAR     FORMAT 'x(25)'   COLUMN-LABEL "Tipo documento"
    FIELDS  codmov      AS INT     FORMAT '>>9'   COLUMN-LABEL "Codigo Movimiento"
    FIELDS  codven      AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Vendedor"
    FIELDS  impisc      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "importe ISC"
    FIELDS  impvta      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "Importe valor venta"
    FIELDS  impfle      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "Importe flete"
    FIELDS  fchcan      AS DATE        COLUMN-LABEL "Fecha cancelacion"
    FIELDS  observ      AS CHAR     FORMAT 'x(120)'   COLUMN-LABEL "Observaciones"
    FIELDS  codref      AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Codigo Ref"
    FIELDS  nroref      AS CHAR     FORMAT 'x(15)'   COLUMN-LABEL "Nro Ref"
    FIELDS  fchvto      AS DATE     COLUMN-LABEL "Fecha vencimiento"
    FIELDS  coddiv      AS CHAR     FORMAT 'x(6)'   COLUMN-LABEL "Division"
    FIELDS  fmapgo      AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Condicion de venta"
    FIELDS  tpovta      AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Tipo venta"
    FIELDS  divori      AS CHAR     FORMAT 'x(6)'   COLUMN-LABEL "Division Origen".

DEFINE TEMP-TABLE tt-detail
    FIELDS  codcia      AS INT     FORMAT '>9'   COLUMN-LABEL "Cia"
    FIELDS  coddoc      AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Codigo"
    FIELDS  nrodoc      AS CHAR     FORMAT 'x(15)'   COLUMN-LABEL "Numero"
    FIELDS  nroitm      AS INT     FORMAT '>>>9'   COLUMN-LABEL "No.Item"
    FIELDS  undvta      AS CHAR     FORMAT 'x(6)'   COLUMN-LABEL "Unidad"
    FIELDS  codmat      AS CHAR     FORMAT 'x(8)'   COLUMN-LABEL "Codigo Articulo"
    FIELDS  preuni      AS DEC     FORMAT '->>>,>>9.9999'   COLUMN-LABEL "Precio unitario"
    FIELDS  impdto      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "Importe Descuento"
    FIELDS  implin      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "importe"
    FIELDS  candes      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "Cantidad"
    FIELDS  factor      AS DEC     FORMAT '->,>>>,>>9.9999'   COLUMN-LABEL "Factor"
    FIELDS  aftigv      AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Afecto IGV"
    FIELDS  aftisc      AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Afecto ISC"
    FIELDS  impigv      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "Importe IGV"
    FIELDS  impisc      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "Importe ISC"
    FIELDS  pordto1     AS DEC     FORMAT '->,>>9.9999'   COLUMN-LABEL "%Dscto 1"
    FIELDS  pordto2     AS DEC     FORMAT '->,>>9.9999'   COLUMN-LABEL "%Dscto 2"
    FIELDS  pordto3     AS DEC     FORMAT '->,>>9.9999'   COLUMN-LABEL "%Dscto 3".

/* Conexion base de datos */
RUN gn/conecta-oointerface.r.
  IF ERROR-STATUS:ERROR THEN RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rsTipoCmpte BUTTON-2 txtYear txtMes 
&Scoped-Define DISPLAYED-OBJECTS rsTipoCmpte txtYear txtMes txtmsg 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-interface-comprobantes-oo AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtMes AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 3.43 BY 1 NO-UNDO.

DEFINE VARIABLE txtmsg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 73 BY 1 NO-UNDO.

DEFINE VARIABLE txtYear AS INTEGER FORMAT ">,>>9":U INITIAL 0 
     LABEL "Año" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE rsTipoCmpte AS CHARACTER INITIAL "X" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Factura", "FAC",
"Boleta", "BOL",
"Nota de Credito", "N/C",
"Nota de Debito", "N/D",
"Todos", "X"
     SIZE 75 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     rsTipoCmpte AT ROW 1.15 COL 1.86 NO-LABEL WIDGET-ID 2
     BUTTON-2 AT ROW 2.15 COL 52 WIDGET-ID 14
     txtYear AT ROW 2.19 COL 7 COLON-ALIGNED WIDGET-ID 8
     txtMes AT ROW 2.19 COL 20.14 COLON-ALIGNED WIDGET-ID 10
     txtmsg AT ROW 3.38 COL 2.43 NO-LABEL WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 75.86 BY 3.62 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-interface-comprobantes-oo ASSIGN
         HIDDEN             = YES
         TITLE              = "Interface comprobanes a OO"
         HEIGHT             = 3.62
         WIDTH              = 75.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 113.43
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 113.43
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-interface-comprobantes-oo 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-interface-comprobantes-oo
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN txtmsg IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-interface-comprobantes-oo)
THEN w-interface-comprobantes-oo:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-interface-comprobantes-oo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-interface-comprobantes-oo w-interface-comprobantes-oo
ON END-ERROR OF w-interface-comprobantes-oo /* Interface comprobanes a OO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-interface-comprobantes-oo w-interface-comprobantes-oo
ON WINDOW-CLOSE OF w-interface-comprobantes-oo /* Interface comprobanes a OO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.

  IF CONNECTED('oointerface') THEN DISCONNECT 'oointerface' NO-ERROR.

  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 w-interface-comprobantes-oo
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Procesar */
DO:

        MESSAGE 'Seguro de Procesar?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

 ASSIGN rsTipoCmpte txtYear Txtmes.  

  RUN cargar-info.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-interface-comprobantes-oo 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-interface-comprobantes-oo  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-interface-comprobantes-oo  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-info w-interface-comprobantes-oo 
PROCEDURE cargar-info :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-fecha-del AS DATE.
DEFINE VAR x-fecha-al AS DATE.
DEFINE VAR x-fecha AS DATE.
DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-doctos AS CHAR.
DEFINE VAR x-sec AS INT.
DEFINE VAR x-sec1 AS INT.

SESSION:SET-WAIT-STATE('GENERAL').

x-fecha-del = DATE(txtMes,1,txtYear).

/* Ultimo del mes */
x-fecha = x-fecha-del.
x-fecha-al = x-fecha - DAY(x-fecha) + 1.
x-fecha-al = ADD-INTERVAL(x-fecha-al,1,'month') - 1.

/**/
x-doctos = rsTipoCmpte.
IF rsTipoCmpte = 'X' THEN x-doctos = "FAC,BOL,N/D,N/C".

DEFINE BUFFER b-oocdocum FOR oocdocum.
DEFINE BUFFER b-ooddocum FOR ooddocum.

DEFINE VAR lRowIdHdr AS ROWID.
DEFINE VAR lRowIdDtl AS ROWID.

/* Eliminar los anteriores */
/*REPEAT x-fecha = x-fecha-del  TO x-fecha-al:*/
LoopBorrar:
REPEAT x-sec = 0  TO 40:
    x-fecha = x-fecha-del + x-sec.
    IF MONTH(x-fecha) <> MONTH(x-fecha-al) THEN LEAVE LoopBorrar.
    txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Eliminando " + STRING(x-fecha,"99/99/9999").
    REPEAT x-sec1 = 1 TO NUM-ENTRIES(x-doctos,","):
        x-coddoc = ENTRY(x-sec1,x-doctos,",").
        FOR EACH oocdocum WHERE oocdocum.codcia = s-codcia AND 
                                oocdocum.fchdoc = x-fecha AND
                                oocdocum.coddoc = x-coddoc NO-LOCK:
            lRowIdHdr = ROWID(oocdocum).
            /*txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Eliminando " + STRING(x-fecha,"99/99/9999") + " Coddoc : " + x-coddoc.*/
            FOR EACH ooddocum WHERE ooddocum.codcia = oocdocum.codcia AND 
                                    ooddocum.coddiv = oocdocum.coddiv AND
                                    ooddocum.coddoc = oocdocum.coddoc AND
                                    ooddocum.nrodoc = oocdocum.nrodoc NO-LOCK:
                /*txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Eliminando " + STRING(x-fecha,"99/99/9999") + " Coddoc : " + x-coddoc + "  Nrodoc : " + oocdocum.nrodoc.*/
                lRowIdDtl = ROWID(ooddocum).
                FIND FIRST b-ooddocum WHERE ROWID(b-ooddocum) = lRowIdDtl NO-ERROR.
                IF AVAILABLE b-ooddocum THEN DO:
                    DELETE b-ooddocum.
                END.
            END.
            /* Cabecera */
            FIND FIRST b-oocdocum WHERE ROWID(b-oocdocum) = lRowIdHdr NO-ERROR.
            IF AVAILABLE b-oocdocum THEN DO:
                DELETE b-oocdocum.
            END.
        END.
    END.
END.

RELEASE b-oocdocum.
RELEASE b-ooddocum.

/* -- */
/*REPEAT x-fecha = x-fecha-del  TO x-fecha-al:*/

LoopInsertar:
REPEAT x-sec = 0  TO 40:
    x-fecha = x-fecha-del + x-sec.
    IF MONTH(x-fecha) <> MONTH(x-fecha-al) THEN LEAVE LoopInsertar.
    
    REPEAT x-sec1 = 1 TO NUM-ENTRIES(x-doctos,","):
        x-coddoc = ENTRY(x-sec1,x-doctos,",").

        txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Procesando " + x-coddoc + " " + STRING(x-fecha,"99/99/9999").
        
        FOR EACH ccbcdocu USE-INDEX llave13 WHERE ccbcdocu.codcia = s-codcia AND 
                                ccbcdocu.fchdoc = x-fecha AND 
                                ccbcdocu.coddoc = x-coddoc AND 
                                ccbcdocu.flgest <> 'B' NO-LOCK:
             
            /*txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Procesando " + STRING(x-fecha,"99/99/9999") + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc.*/
                .
            CREATE oointerface.oocdocum.
            BUFFER-COPY ccbcdocu TO oocdocum.

            FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
                    CREATE oointerface.ooddocum.
                    BUFFER-COPY ccbddocu TO ooddocum.
                    ASSIGN 
                        ooddocum.por_dsctos1 = ccbddocu.por_dsctos[1]
                        ooddocum.por_dsctos2 = ccbddocu.por_dsctos[2]
                        ooddocum.por_dsctos3 = ccbddocu.por_dsctos[3].
            END.
        END.
    END.
END.

SESSION:SET-WAIT-STATE('').

MESSAGE "Proceso concluido!".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-interface-comprobantes-oo  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-interface-comprobantes-oo)
  THEN DELETE WIDGET w-interface-comprobantes-oo.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-interface-comprobantes-oo  _DEFAULT-ENABLE
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
  DISPLAY rsTipoCmpte txtYear txtMes txtmsg 
      WITH FRAME F-Main IN WINDOW w-interface-comprobantes-oo.
  ENABLE rsTipoCmpte BUTTON-2 txtYear txtMes 
      WITH FRAME F-Main IN WINDOW w-interface-comprobantes-oo.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW w-interface-comprobantes-oo.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportar-comprobantes w-interface-comprobantes-oo 
PROCEDURE exportar-comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-fecha-del AS DATE.
DEFINE VAR x-fecha-al AS DATE.
DEFINE VAR x-fecha AS DATE.
DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-doctos AS CHAR.
DEFINE VAR x-sec AS INT.
DEFINE VAR x-sec1 AS INT.

DEFINE VAR x-archivo AS CHAR INIT "".
DEFINE VAR x-ruta AS CHAR INIT "".
DEFINE VAR rpta AS LOG.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Excel (*.xlsx)' '*.xlsx'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.xlsx'
    RETURN-TO-START-DIR
    SAVE-AS
    TITLE 'Exportar a Excel'
    UPDATE rpta.
IF rpta = NO OR x-Archivo = '' THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').

x-ruta = SUBSTRING(x-archivo,1,R-INDEX(x-archivo,"\")).
x-archivo = SUBSTRING(x-archivo,R-INDEX(x-archivo,"\") + 1).

x-fecha-del = DATE(txtMes,1,txtYear).

/* Ultimo del mes */
x-fecha = x-fecha-del.
x-fecha-al = x-fecha - DAY(x-fecha) + 1.
x-fecha-al = ADD-INTERVAL(x-fecha-al,1,'month') - 1.

/**/
x-doctos = rsTipoCmpte.
IF rsTipoCmpte = 'X' THEN x-doctos = "FAC,BOL,N/D,N/C".

EMPTY TEMP-TABLE tt-header.
EMPTY TEMP-TABLE tt-detail.

REPEAT x-fecha = x-fecha-del  TO x-fecha-al:

    REPEAT x-sec1 = 1 TO NUM-ENTRIES(x-doctos,","):
        x-coddoc = ENTRY(x-sec1,x-doctos,",").
        
        /*MESSAGE s-codcia x-coddoc x-fecha.*/

        FOR EACH ccbcdocu USE-INDEX llave13 WHERE ccbcdocu.codcia = s-codcia AND 
                                ccbcdocu.fchdoc = x-fecha AND 
                                ccbcdocu.coddoc = x-coddoc AND 
                                ccbcdocu.flgest <> 'B' NO-LOCK:
             .
            CREATE tt-header.

            ASSIGN tt-header.codcia = ccbcdocu.codcia
                    tt-header.coddoc = ccbcdocu.coddoc
                    tt-header.nrodoc = ccbcdocu.nrodoc
                    tt-header.fchdoc = ccbcdocu.fchdoc
                    tt-header.codcli = ccbcdocu.codcli
                    tt-header.nomcli = ccbcdocu.nomcli
                    tt-header.dircli = ccbcdocu.dircli
                    tt-header.ruc = ccbcdocu.ruc
                    tt-header.codped = ccbcdocu.codped
                    tt-header.nroped = ccbcdocu.nroped
                    tt-header.nroord = ccbcdocu.nroord
                    tt-header.impbrt = ccbcdocu.impbrt
                    tt-header.impexo = ccbcdocu.impexo
                    tt-header.porigv = ccbcdocu.porigv
                    tt-header.impigv = ccbcdocu.impigv
                    tt-header.impdto = ccbcdocu.impdto
                    tt-header.imptot = ccbcdocu.imptot
                    tt-header.flgest = ccbcdocu.flgest
                    tt-header.monvta = ccbcdocu.codmon
                    tt-header.tpocmb = ccbcdocu.tpocmb
                    tt-header.codalm = ccbcdocu.codalm
                    tt-header.lugent = ccbcdocu.lugent
                    tt-header.tipdoc = ccbcdocu.tipo
                    tt-header.codmov = ccbcdocu.codmov
                    tt-header.codven = ccbcdocu.codven
                    tt-header.impisc = ccbcdocu.impisc
                    tt-header.impvta = ccbcdocu.impvta
                    tt-header.impfle = ccbcdocu.impfle
                    tt-header.fchcan = ccbcdocu.fchcan
                    tt-header.observ = ccbcdocu.glosa
                    tt-header.codref = ccbcdocu.codref
                    tt-header.nroref = ccbcdocu.nroref
                    tt-header.fchvto = ccbcdocu.fchvto
                    tt-header.coddiv = ccbcdocu.coddiv
                    tt-header.fmapgo = ccbcdocu.fmapgo
                    tt-header.tpovta = ccbcdocu.tpofac
                    tt-header.divori = ccbcdocu.divori.

            FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
                    CREATE tt-detail.
                        ASSIGN tt-detail.codcia = ccbddocu.codcia
                                tt-detail.coddoc = ccbddocu.coddoc
                                tt-detail.nrodoc = ccbddocu.nrodoc
                                tt-detail.nroitm = ccbddocu.nroitm
                                tt-detail.undvta = ccbddocu.undvta
                                tt-detail.codmat = ccbddocu.codmat
                                tt-detail.preuni = ccbddocu.preuni
                                tt-detail.impdto = ccbddocu.impdto
                                tt-detail.implin = ccbddocu.implin
                                tt-detail.candes = ccbddocu.candes
                                tt-detail.factor = ccbddocu.factor
                                tt-detail.aftigv = IF (ccbddocu.aftigv = YES) THEN "SI" ELSE "NO"
                                tt-detail.aftisc = IF (ccbddocu.aftisc = YES) THEN "SI" ELSE "NO"
                                tt-detail.impigv = ccbddocu.impigv
                                tt-detail.impisc = ccbddocu.impisc
                                tt-detail.pordto1 = ccbddocu.por_dsctos[1]
                                tt-detail.pordto2 = ccbddocu.por_dsctos[2]
                                tt-detail.pordto3 = ccbddocu.por_dsctos[3].

            END.

        END.
    END.
END.

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

/* Header */
c-xls-file = x-ruta + "header_" + x-archivo.

run pi-crea-archivo-csv IN hProc (input  buffer tt-header:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-header:handle,
                        input  c-csv-file,
                        output c-xls-file) .

/* Detail */
c-xls-file = x-ruta + "detail_" + x-archivo.

run pi-crea-archivo-csv IN hProc (input  buffer tt-detail:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-detail:handle,
                        input  c-csv-file,
                        output c-xls-file) .


DELETE PROCEDURE hProc.

SESSION:SET-WAIT-STATE('').

MESSAGE "Proceso Terminado".

END PROCEDURE.

/*
DEFINE VAR s-codcia AS INT.

DEFINE TEMP-TABLE tt-header
    FIELDS  codcia      AS INT     FORMAT '>9'   COLUMN-LABEL "Cia"
    FIELDS  coddoc      AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Codigo"
    FIELDS  nrodoc      AS CHAR     FORMAT 'x(15)'   COLUMN-LABEL "Numero"
    FIELDS  fchdoc      AS DATE        COLUMN-LABEL "Fecha"
    FIELDS  codcli      AS CHAR     FORMAT 'x(11)'   COLUMN-LABEL "Cliente"
    FIELDS  nomcli      AS CHAR     FORMAT 'x(80)'   COLUMN-LABEL "Nombre"
    FIELDS  dircli      AS CHAR     FORMAT 'x(120)'   COLUMN-LABEL "Direccion"
    FIELDS  ruc      AS CHAR     FORMAT 'x(11)'   COLUMN-LABEL "RUC"
    FIELDS  codped      AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "CodPed"
    FIELDS  nroped      AS CHAR     FORMAT 'x(15)'   COLUMN-LABEL "Pedido"
    FIELDS  nroord      AS CHAR     FORMAT 'x(15)'   COLUMN-LABEL "Orden de Compra"
    FIELDS  impbrt      AS DEC     FORMAT '->,>>>,>>9,99'   COLUMN-LABEL "Importe Bruto"
    FIELDS  impexo      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "Importe Exonerado"
    FIELDS  porigv      AS DEC     FORMAT '->,>>9.9999'   COLUMN-LABEL "%I.G.V."
    FIELDS  impigv      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "Importe I.G.V."
    FIELDS  impdto      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "Importe descuento"
    FIELDS  imptot      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "Importe Total"
    FIELDS  flgest      AS CHAR     FORMAT 'x(1)'   COLUMN-LABEL "Estado"
    FIELDS  monvta      AS INT     FORMAT '>9'   COLUMN-LABEL "Moneda"
    FIELDS  tpocmb      AS DEC     FORMAT '->>9.9999'   COLUMN-LABEL "Tipo Cambio"
    FIELDS  codalm      AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Almacen"
    FIELDS  lugent      AS CHAR     FORMAT 'x(120)'   COLUMN-LABEL "Lugar entrega"
    FIELDS  tipdoc      AS CHAR     FORMAT 'x(25)'   COLUMN-LABEL "Tipo documento"
    FIELDS  codmov      AS INT     FORMAT '>>9'   COLUMN-LABEL "Codigo Movimiento"
    FIELDS  codven      AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Vendedor"
    FIELDS  impisc      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "importe ISC"
    FIELDS  impvta      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "Importe valor venta"
    FIELDS  impfle      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "Importe flete"
    FIELDS  fchcan      AS DATE        COLUMN-LABEL "Fecha cancelacion"
    FIELDS  observ      AS CHAR     FORMAT 'x(120)'   COLUMN-LABEL "Observaciones"
    FIELDS  codref      AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Codigo Ref"
    FIELDS  nroref      AS CHAR     FORMAT 'x(15)'   COLUMN-LABEL "Nro Ref"
    FIELDS  fchvto      AS DATE     COLUMN-LABEL "Fecha vencimiento"
    FIELDS  coddiv      AS CHAR     FORMAT 'x(6)'   COLUMN-LABEL "Division"
    FIELDS  fmapgo      AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Condicion de venta"
    FIELDS  tpovta      AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Tipo venta"
    FIELDS  divori      AS CHAR     FORMAT 'x(6)'   COLUMN-LABEL "Division Origen".

DEFINE TEMP-TABLE tt-detail
    FIELDS  codcia      AS INT     FORMAT '>9'   COLUMN-LABEL "Cia"
    FIELDS  coddoc      AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Codigo"
    FIELDS  nrodoc      AS CHAR     FORMAT 'x(15)'   COLUMN-LABEL "Numero"
    FIELDS  nroitm      AS INT     FORMAT '>>>9'   COLUMN-LABEL "No.Item"
    FIELDS  undvta      AS CHAR     FORMAT 'x(6)'   COLUMN-LABEL "Unidad"
    FIELDS  codmat      AS CHAR     FORMAT 'x(8)'   COLUMN-LABEL "Codigo Articulo"
    FIELDS  preuni      AS DEC     FORMAT '->>>,>>9.9999'   COLUMN-LABEL "Precio unitario"
    FIELDS  impdto      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "Importe Descuento"
    FIELDS  implin      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "importe"
    FIELDS  candes      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "Cantidad"
    FIELDS  factor      AS DEC     FORMAT '->,>>>,>>9.9999'   COLUMN-LABEL "Factor"
    FIELDS  aftigv      AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Afecto IGV"
    FIELDS  aftisc      AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Afecto ISC"
    FIELDS  impigv      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "Importe IGV"
    FIELDS  impisc      AS DEC     FORMAT '->,>>>,>>9.99'   COLUMN-LABEL "Importe ISC"
    FIELDS  pordto1     AS DEC     FORMAT '>,>>9.9999'   COLUMN-LABEL "%Dscto 1"
    FIELDS  pordto2     AS DEC     FORMAT '>,>>9.9999'   COLUMN-LABEL "%Dscto 2"
    FIELDS  pordto3     AS DEC     FORMAT '>,>>9.9999'   COLUMN-LABEL "%Dscto 3".

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-interface-comprobantes-oo 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-interface-comprobantes-oo 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  txtYear:SCREEN-VALUE IN FRAM {&FRAME-NAME} = STRING(YEAR(TODAY),"9999").
  txtMes:SCREEN-VALUE IN FRAM {&FRAME-NAME} = STRING(MONTH(TODAY),"99").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-interface-comprobantes-oo  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-interface-comprobantes-oo 
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

