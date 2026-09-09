&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

DEFINE VARIABLE s-task-no   AS INT.
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR pv-codcia AS INT.

DEFINE TEMP-TABLE tt-clientes
    FIELDS codcli LIKE gn-clie.codcli.

DEFINE BUFFER b-report FOR w-report.

DEFINE TEMP-TABLE ttPrecios
    FIELD   tcodprov    AS  CHAR    COLUMN-LABEL "Cod.Prov"
    FIELD   tnomprov    AS  CHAR    COLUMN-LABEL "Nombre del proveedor"
    FIELD   tsec    AS  CHAR    COLUMN-LABEL "Sec"
    FIELD   tcodmat AS  CHAR    COLUMN-LABEL "Cod"
    FIELD   tdesmat AS  CHAR    COLUMN-LABEL "Descripcion"
    FIELD   tmarca  AS  CHAR    COLUMN-LABEL "Marca"
    FIELD   tumed   AS  CHAR    COLUMN-LABEL "U.M."
    FIELD   tminvta AS  DEC     COLUMN-LABEL "Min.Vta"
    FIELD   tpreferia   AS  CHAR    COLUMN-LABEL "Precio Feria"
    FIELD   trbtconti   AS  CHAR    COLUMN-LABEL "Rebate contipunto"
    FIELD   tobserva    AS  CHAR    COLUMN-LABEL "Observaciones".

/* */

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
&Scoped-Define ENABLED-OBJECTS RECT-1 COMBO-BOX-Division fill-in-campana ~
txt-codpro BUTTON-2 BUTTON-1 BUTTON-5 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Division fill-in-campana ~
txt-codpro txt-nompro txt-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "TXT" 
     SIZE 15 BY 1.62
     BGCOLOR 2 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Button 2" 
     SIZE 15 BY 1.62.

DEFINE BUTTON BUTTON-5 
     LABEL "PDF" 
     SIZE 15 BY 1.62
     BGCOLOR 12 .

DEFINE VARIABLE COMBO-BOX-Division AS CHARACTER FORMAT "X(256)":U 
     LABEL "Lista Precio" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 55 BY 1 NO-UNDO.

DEFINE VARIABLE fill-in-campana AS INTEGER FORMAT ">,>>9":U INITIAL 0 
     LABEL "Año de campaña" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE txt-codpro AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 74 BY 1 NO-UNDO.

DEFINE VARIABLE txt-nompro AS CHARACTER FORMAT "X(256)":U INITIAL "< Todos los Proveedores >" 
     VIEW-AS FILL-IN 
     SIZE 52 BY 1
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.57 BY 9.12.

DEFINE VARIABLE tg-todos AS LOGICAL INITIAL no 
     LABEL "Todos" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Division AT ROW 2.5 COL 12.14 COLON-ALIGNED WIDGET-ID 32
     fill-in-campana AT ROW 3.54 COL 17 COLON-ALIGNED WIDGET-ID 76
     txt-codpro AT ROW 4.69 COL 12 COLON-ALIGNED WIDGET-ID 4
     txt-nompro AT ROW 4.69 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     tg-todos AT ROW 6.04 COL 14 WIDGET-ID 12
     txt-mensaje AT ROW 6.85 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     BUTTON-2 AT ROW 7.92 COL 67 WIDGET-ID 8
     BUTTON-1 AT ROW 7.96 COL 48 WIDGET-ID 6
     BUTTON-5 AT ROW 8 COL 32.29 WIDGET-ID 34
     "(Solo para proposito de titulo del reporte)" VIEW-AS TEXT
          SIZE 37 BY .62 AT ROW 3.77 COL 29.43 WIDGET-ID 78
          FGCOLOR 9 FONT 6
     "Listado de Precios del Catálogo Pre Venta" VIEW-AS TEXT
          SIZE 43 BY .81 AT ROW 1.27 COL 24 WIDGET-ID 14
          FONT 6
     RECT-1 AT ROW 1.12 COL 1.43 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 87 BY 9.31 WIDGET-ID 100.


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
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Listado Precios Catalogos"
         HEIGHT             = 9.31
         WIDTH              = 87
         MAX-HEIGHT         = 9.31
         MAX-WIDTH          = 87
         VIRTUAL-HEIGHT     = 9.31
         VIRTUAL-WIDTH      = 87
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR TOGGLE-BOX tg-todos IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       tg-todos:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN txt-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-nompro IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Listado Precios Catalogos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Listado Precios Catalogos */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* TXT */
DO:
    ASSIGN txt-codpro COMBO-BOX-Division.

    IF TRUE <> (txt-codpro > "") THEN DO:
            MESSAGE 'Seguro de procesar todos los Proveedores' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
            IF rpta = NO THEN RETURN NO-APPLY.
    END.

    RUN enviar-excel. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* PDF */
DO:
    ASSIGN txt-codpro COMBO-BOX-Division fill-in-campana.

    IF fill-in-campana < YEAR(TODAY) THEN DO:
        MESSAGE "Año de la campaña no debe ser menor al año actual" VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

    IF TRUE <> (txt-codpro > "") THEN DO:
            MESSAGE 'Seguro de procesar todos los Proveedores' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
            IF rpta = NO THEN RETURN NO-APPLY.
    END.
  
    RUN imprimir.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Division W-Win
ON VALUE-CHANGED OF COMBO-BOX-Division IN FRAME F-Main /* Lista Precio */
DO:
  ASSIGN {&self-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-codpro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-codpro W-Win
ON LEAVE OF txt-codpro IN FRAME F-Main /* Proveedor */
DO:

    txt-nompro:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "< Todos los Proveedores >".

    FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = txt-codpro:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
    IF AVAIL gn-prov THEN DISPLAY gn-prov.nompro @ txt-nompro  WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal W-Win 
PROCEDURE carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iInt    AS INTEGER     NO-UNDO INIT 1.
    DEFINE VARIABLE cDesMar AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cNomCli AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cDesPag AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cImagen AS CHAR NO-UNDO.
    DEFINE VARIABLE cImagenConti AS CHAR NO-UNDO.

    DEFINE VAR dPrecioSoles AS DEC INIT 0.
    DEFINE VAR dDescuento AS DEC INIT 0.
    DEFINE VAR dPrecioNeto AS DEC DECIMALS 6 INIT 0.
    DEFINE VAR cDsctoExpo AS CHAR.

    /* Factor Flete */
    DEF VAR s-undvta AS CHAR NO-UNDO.
    DEF VAR f-factor AS DEC NO-UNDO.
    DEF VAR f-prebas AS DEC NO-UNDO.
    DEF VAR f-prevta AS DEC NO-UNDO.
    DEF VAR f-dsctos AS DEC NO-UNDO.
    DEF VAR y-dsctos AS DEC NO-UNDO.
    DEF VAR z-dsctos AS DEC NO-UNDO.
    DEF VAR x-tipdto AS CHAR NO-UNDO.
    DEF VAR f-fleteunitario AS DEC NO-UNDO.
    DEF VAR x-impdto AS DEC NO-UNDO.

    DEF VAR pMensaje AS CHAR NO-UNDO.
    /* ************ */

    EMPTY TEMP-TABLE ttPrecios.

    REPEAT:
        s-task-no = RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK)
        THEN LEAVE.
    END.

    SESSION:SET-WAIT-STATE("GENERAL").

    CREATE ttPrecios.
        ASSIGN ttPrecios.tsec = ""
                ttPrecios.tcodmat = ""
                ttPrecios.tdesmat = "Lista de Precios : " + combo-box-division:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                ttPrecios.tmarca = ""
                ttPrecios.tumed = ""
                ttPrecios.tminvta = 0
                ttPrecios.tpreferia = ""
                ttPrecios.trbtconti = ""
                ttPrecios.tobserva = "".

        CREATE ttPrecios.
            ASSIGN ttPrecios.tsec = ""
                    ttPrecios.tcodmat = ""
                    ttPrecios.tdesmat = txt-codpro:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " " + 
                                        txt-nompro:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                    ttPrecios.tmarca = ""
                    ttPrecios.tumed = ""
                    ttPrecios.tminvta = 0
                    ttPrecios.tpreferia = ""
                    ttPrecios.trbtconti = ""
                    ttPrecios.tobserva = "".

    cImagen = SEARCH("\test\" + TRIM(txt-codpro) + ".jpg").       
    IF cImagen = ?  THEN cImagen = SEARCH("\test\" + TRIM(txt-codpro) + ".bmp").
    IF cImagen = ?  THEN cImagen = SEARCH("d:\test\" + TRIM(txt-codpro) + ".JPG").
    IF cImagen = ?  THEN cImagen = SEARCH("c:\test\" + TRIM(txt-codpro) + ".bmp").
    
    FOR EACH almcatvtac WHERE almcatvtac.codcia = s-codcia
        AND almcatvtac.coddiv = COMBO-BOX-Division
        AND (txt-codpro = "" OR almcatvtac.codpro = txt-codpro) NO-LOCK,
        EACH almcatvtad WHERE almcatvtad.codcia = s-codcia
            AND almcatvtad.coddiv = almcatvtac.coddiv
            AND almcatvtad.codpro = almcatvtac.codpro
            AND almcatvtad.nropag = almcatvtac.nropag NO-LOCK:
        /* No debe imprimir el dscto x expo, solo se imprime el dscto del proveedor */
        cDsctoExpo = IF Almcatvtad.Libre_c01 = "SI" THEN "SI" ELSE "NO".
        /*
        */
        FIND FIRST w-report WHERE task-no = s-task-no
            AND w-report.llave-c = almcatvtac.codpro
            AND w-report.Campo-C[1]= almcatvtac.codpro 
            AND w-report.Campo-C[2] = STRING(almcatvtac.nropag,"999")
            AND w-report.Campo-C[4] = STRING(almcatvtad.nrosec,"999") NO-LOCK NO-ERROR.
        IF NOT AVAIL w-report THEN DO:
            cImagen = TRIM(SEARCH("\test\" + TRIM(almcatvtac.codpro) + ".jpg")).       
            IF cImagen = "" OR cImagen = ?  THEN cImagen = SEARCH("\test\" + TRIM(almcatvtac.codpro) + ".bmp").
            IF cImagen = "" OR cImagen = ?  THEN cImagen = SEARCH("d:\test\" + TRIM(almcatvtac.codpro) + ".JPG").
            IF cImagen = "" OR cImagen = ?  THEN cImagen = SEARCH("c:\test\" + TRIM(almcatvtac.codpro) + ".bmp").

            FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
                AND almmmatg.codmat = almcatvtad.codmat NO-LOCK NO-ERROR.
            IF AVAIL almmmatg THEN cDesMar = almmmatg.desmar.
            ELSE cDesMar = ''.

            cDesPag = almcatvtac.despag.

            dPrecioSoles = 0.
            dDescuento = 0.
            f-fleteunitario = 0.
            /* **************************************************************** */
            /* RHC 08/01/2016 Aplicamos Factor Flete ************************** */
            /* **************************************************************** */
            RUN web/preciofinalcreditomayorista.p (
                 "E",       /* Expolibreria */
                 COMBO-BOX-Division,
                 "SYS00000001",
                 1,
                 INPUT-OUTPUT s-UndVta,
                 OUTPUT f-Factor,
                 almcatvtad.codmat,
                 "000",     /* Contado */
                 1,
                 4,
                 OUTPUT f-PreBas,
                 OUTPUT f-PreVta,       /* OJO */
                 OUTPUT f-Dsctos,
                 OUTPUT y-Dsctos,
                 OUTPUT z-Dsctos,
                 OUTPUT x-TipDto,
                 "",                    /* Clasificacion de cliente */
                 OUTPUT f-FleteUnitario,
                 "",
                 NO,
                 OUTPUT pMensaje).
            IF RETURN-VALUE <> 'ADM-ERROR' THEN dPrecioSoles = f-PreVta + f-FleteUnitario.
            dPrecioNeto = ROUND( dPrecioSoles * ( 1 - dDescuento / 100 ), 4).
            /* **************************************************************** */
            /* **************************************************************** */
            cImagenConti = SEARCH(".\test\logo-expo.JPG").
            CREATE w-report.
            ASSIGN 
                task-no = s-task-no
                llave-c = almcatvtac.codpro     /*'11111111111'*/
                w-report.Campo-C[1] = almcatvtac.codpro
                w-report.Campo-C[2] = AlmCatVtaD.Libre_C04  /*STRING(almcatvtac.nropag,"999")*/
                w-report.Campo-C[3] = STRING(almcatvtac.nropag,"999") /*cDesPag*/
                w-report.Campo-C[4] = STRING(almcatvtad.nrosec,"999")
                w-report.Campo-C[5] = almcatvtad.codmat
                w-report.Campo-C[6] = AlmCatVtaD.DesMat 
                w-report.Campo-C[7] = AlmCatVtaD.UndBas
                w-report.Campo-C[8] = cDesMar
                w-report.Campo-C[9] = AlmCatVtaD.Libre_C04 + " " + AlmCatVtaD.Libre_C05
                w-report.Campo-C[10] = cNomCli
                w-report.Campo-C[11] = cImagen
                w-report.Campo-c[12] = cImagenConti
                w-report.Campo-F[1] = AlmCatVtaD.libre_d02   /*AlmCatVtaD.CanEmp */
                w-report.Campo-F[2] = AlmCatVtaD.libre_d03.  /*AlmCatVtaD.Libre_d05.*/
                w-report.Campo-F[3] = dPrecioSoles.

                w-report.Campo-F[4] = ROUND(dDescuento,0).  /*IF cDsctoExpo = 'SI' THEN 0 ELSE dDescuento.*/
                w-report.Campo-F[5] = dPrecioNeto.
                w-report.Campo-c[21] = STRING(dPrecioSoles,">>,>>9.9999").
                w-report.Campo-c[20] = STRING(dPrecioNeto,">>,>>9.9999").

                ASSIGN w-report.Campo-c[21] = w-report.Campo-c[20]
                        w-report.Campo-c[22] = ""
                        w-report.Campo-c[23] = "".

                FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                            vtatabla.tabla = "LPEVENTO" + COMBO-BOX-Division AND
                                            vtatabla.llave_c1 = almcatvtad.codmat AND
                                            vtatabla.llave_c2 = "" AND
                                            vtatabla.llave_c3 = "" NO-LOCK NO-ERROR.

                IF NOT AVAILABLE vtatabla THEN DO:
                    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                                vtatabla.tabla = "LPEVENTO" + COMBO-BOX-Division AND
                                                vtatabla.llave_c1 = almmmatg.codfam AND
                                                vtatabla.llave_c2 = almmmatg.subfam AND
                                                vtatabla.llave_c3 = "" NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE vtatabla THEN DO:
                        FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                                    vtatabla.tabla = "LPEVENTO" + COMBO-BOX-Division AND
                                                    vtatabla.llave_c1 = almmmatg.codfam AND
                                                    vtatabla.llave_c2 = "" AND
                                                    vtatabla.llave_c3 = "" NO-LOCK NO-ERROR.
                    END.
                END.
                
                IF AVAILABLE vtatabla THEN DO:
                    ASSIGN w-report.Campo-c[22] = "Ayuda a cuantificar la compra".
                    IF AVAILABLE vtalistamay AND vtalistamay.DtoVOLR[1] > 0 THEN DO:
                        /* Dscto por volumen */
                        ASSIGN w-report.Campo-c[23] = "Precio por escala".
                    END.
                    ELSE DO:
                        /**/
                        dPrecioNeto = dPrecioNeto * ( 1 - (vtatabla.valor[1] / 100)).
                    END.
                END.
            /**/
            CREATE ttPrecios.
                ASSIGN  ttPrecios.tcodprov = w-report.campo-c[1]
                        ttPrecios.tsec = w-report.campo-c[4]
                        ttPrecios.tcodmat = w-report.campo-c[5]
                        ttPrecios.tdesmat = w-report.campo-c[6]
                        ttPrecios.tmarca = w-report.campo-c[8]
                        ttPrecios.tumed = w-report.campo-c[7]
                        ttPrecios.tminvta = w-report.campo-f[1]
                        ttPrecios.tpreferia = w-report.campo-c[20]
                        ttPrecios.trbtconti = w-report.campo-c[22]
                        ttPrecios.tobserva = w-report.campo-c[23].

                FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia
                    AND gn-prov.codpro = w-report.Campo-C[1] NO-LOCK NO-ERROR.

                IF AVAIL gn-prov THEN DO:
                    ASSIGN  ttPrecios.tnomprov = gn-prov.nompro.
                END.
            DISPLAY "****  Carga Catalogo  ****" @ txt-Mensaje WITH FRAME {&FRAME-NAME}.
        END.
    END.

SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY COMBO-BOX-Division fill-in-campana txt-codpro txt-nompro txt-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 COMBO-BOX-Division fill-in-campana txt-codpro BUTTON-2 BUTTON-1 
         BUTTON-5 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviar-excel W-Win 
PROCEDURE enviar-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-archivo AS CHAR.
DEFINE VAR rpta AS LOG.

        SYSTEM-DIALOG GET-FILE x-Archivo
            FILTERS 'TXTs (*.txt)' '*.txt'
            ASK-OVERWRITE
            CREATE-TEST-FILE
            DEFAULT-EXTENSION '.txt'
            RETURN-TO-START-DIR
            SAVE-AS
            TITLE 'Exportar a TXT'
            UPDATE rpta.
        IF rpta = NO OR x-Archivo = '' THEN DO:
            MESSAGE "Ud. cancelo el proceso." SKIP
                    "no se graba ningun archivo"
                VIEW-AS ALERT-BOX INFORMATION.
            RETURN.
        END.                        


RUN carga-temporal.

   FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE 'NO hay registros para imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.


DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = x-archivo.

run pi-crea-archivo-csv IN hProc (input  buffer ttPrecios:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

/*
run pi-crea-archivo-xls  IN hProc (input  buffer ttPrecios:handle,
                        input  c-csv-file,
                        output c-xls-file) .
*/

DELETE PROCEDURE hProc.


FOR EACH w-report WHERE w-report.task-no = s-task-no:
    DELETE w-report.
END.

RELEASE w-report NO-ERROR.

MESSAGE "Se genero el siguiente archivo" SKIP
        c-xls-file SKIP
        "La separacion de campos se uso el punto y coma (;)"
        VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera_Excel-NO_SIRVE W-Win 
PROCEDURE Genera_Excel-NO_SIRVE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 3.

DEFINE VARIABLE cCodPro AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dPrecioSoles AS DECIMAL NO-UNDO.
DEFINE VARIABLE dDsctoSoles AS DECIMAL NO-UNDO.
DEFINE VARIABLE cNomPro AS CHARACTER   NO-UNDO.

DEFINE VAR sListaPecio AS CHAR.
DEFINE VAR cDsctoExpo AS CHAR.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */


/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 10.
chWorkSheet:Columns("B"):ColumnWidth = 40.
chWorkSheet:Columns("C"):ColumnWidth = 10.
chWorkSheet:Columns("D"):ColumnWidth = 40.
chWorkSheet:Columns("E"):ColumnWidth = 25.
chWorkSheet:Columns("F"):ColumnWidth = 10.
chWorkSheet:Columns("G"):ColumnWidth = 20.

chWorkSheet:Range("D2"):Value = "Listado de Precios de Catalogo de Materiales (EN SOLES)".
/*
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Proveedor".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Nombre o Razon Social".

cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Nº Pag".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Nº Sec".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "CodMat".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Marca".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Unidades".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Precio Base".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "% Dscto".
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "Precio Final".

*/

sListaPecio = COMBO-BOX-division.

IF tg-todos THEN cCodPro = ''. ELSE cCodPro = txt-codpro.

FOR EACH almcatvtac WHERE almcatvtac.codcia = s-codcia
    AND almcatvtac.coddiv = sListaPecio /*s-coddiv*/
    AND almcatvtac.codpro BEGINS cCodPro NO-LOCK,
    EACH almcatvtad WHERE almcatvtad.codcia = almcatvtac.codcia
        AND almcatvtad.coddiv = almcatvtac.coddiv
        AND almcatvtad.codpro = almcatvtac.codpro
        AND almcatvtad.nropag = almcatvtac.nropag NO-LOCK,
        FIRST almmmatg WHERE almmmatg.codcia = s-codcia
            AND almmmatg.codmat = almcatvtad.codmat NO-LOCK
    BREAK BY almcatvtac.codpro BY almcatvtac.nropag BY almcatvtad.nrosec:

    FIND FIRST vtalistamay WHERE vtalistamay.codcia = s-codcia
        AND VtaListaMay.CodDiv = sListaPecio /*s-coddiv*/
        AND VtaListaMay.codmat = almcatvtad.codmat NO-LOCK NO-ERROR.
    IF AVAIL vtalistamay THEN DO: 
        IF vtalistamay.monvta = 2 THEN dPrecioSoles = vtalistamay.tpocmb * vtalistamay.preofi.
        ELSE dPrecioSoles = vtalistamay.preofi.
    END.
    ELSE dPrecioSoles = 0.    

    /* No debe imprimir el dscto x expo, solo se imprime el dscto del proveedor */
    cDsctoExpo = IF(almcatvtad.libre_c01 = ?) THEN '' ELSE TRIM(almcatvtad.libre_c01).

    FIND FIRST gn-prov  WHERE INTEGRAL.gn-prov.CodCia = pv-codcia
        AND INTEGRAL.gn-prov.CodPro = TRIM(almcatvtac.codpro) NO-LOCK NO-ERROR.
    IF AVAIL gn-prov THEN cnomPro = gn-prov.nompro.
   
    IF FIRST-OF(almcatvtac.codpro) THEN DO:
        /*
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + almcatvtac.codpro.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = cNomPro.
        */
        t-column = t-column + 1.
        cColumn = STRING(t-Column).

        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "(" + almcatvtac.codpro + ") " + cNomPro.
        /*
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = "Nº Pag".
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "Nº Sec".
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = "CodMat".
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = "Descripcion".
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = "Marca".
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = "Unidades".
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = "Precio Base".
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = "% Dscto".
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = "Precio Final".
        */
        t-column = t-column + 2.
        cColumn = STRING(t-Column).

        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "Nº Pag".
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "Nº Sec".
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = "CodMat".
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "Descripcion".
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = "Marca".
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = "Unidades".
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = "Precio Base".
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = "% Dscto".
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = "Precio Final".        
    END.
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
        
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + STRING(almcatvtac.nropag,'9999').
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + STRING(almcatvtad.nrosec,'9999').
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + almcatvtad.codmat.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.undbas.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = dPrecioSoles.
    


    IF AVAILABLE VtaListaMay THEN DO:
        cRange = "H" + cColumn.
        dDsctoSoles = VtaListaMay.PromDto.
        chWorkSheet:Range(cRange):Value = IF(cDsctoExpo <> '') THEN 0 ELSE dDsctoSoles.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = dPrecioSoles * ( 1 - dDsctoSoles / 100 ).
    END.
    IF LAST-OF(almcatvtac.codpro) THEN  t-column = t-column + 2.

    DISPLAY almcatvtad.codmat + ' - ' + almmmatg.desmat @ txt-mensaje 
        WITH FRAME {&FRAME-NAME}.
END.

DISPLAY '' @ txt-mensaje WITH FRAME {&FRAME-NAME}.

MESSAGE 'Proceso Completado'
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
chExcelApplication:Visible = TRUE.


/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir W-Win 
PROCEDURE imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN Carga-Temporal.

    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE 'NO hay registros para imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
        
    DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
    DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
    DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
    DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
    DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */
    
    GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'vta/rbvta.prl'.
    RB-REPORT-NAME = 'Imprime Catalogo Ventas Precios'.
    RB-INCLUDE-RECORDS = "O".
    RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
    
    RB-OTHER-PARAMETERS = "pYearCampana = " + "LISTA DE PRECIOS CAMPAÑA " + STRING(fill-in-campana).
    
    RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                       RB-REPORT-NAME,
                       RB-INCLUDE-RECORDS,
                       RB-FILTER,
                       RB-OTHER-PARAMETERS).

    
    FOR EACH w-report WHERE w-report.task-no = s-task-no:
        DELETE w-report.
    END.

    RELEASE w-report NO-ERROR.

    RUN lib/logtabla ("EXPOLIBRERIA",
                      COMBO-BOX-Division + "," + txt-codpro,
                      "IMPRIMELISTA").


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-Division:DELETE(1).
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND GN-DIVI.VentaMayorista = 2
          BREAK BY gn-divi.codcia:
          COMBO-BOX-Division:ADD-LAST( GN-DIVI.CodDiv + ' - ' + GN-DIVI.DesDiv, GN-DIVI.CodDiv ).
/*           IF FIRST-OF(gn-divi.codcia) THEN COMBO-BOX-Division = gn-divi.coddiv. */
      END.
      COMBO-BOX-Division = s-coddiv.
  END.
  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FILL-in-campana:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(YEAR(TODAY),"9999").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
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
    DEFINE VAR OUTPUT-var-1 AS ROWID.


    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
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

