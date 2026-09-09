&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME    W-maestro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-maestro 
/*------------------------------------------------------------------------

  File: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:  VALMIESA - DEPARTAMENTO DE TECNOLOGIA

  Created: 10/25/93 - 11:42 am

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/*~ MAESTRO V1.00 FOR MS-WINDOWS ~*/
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE {&NEW} SHARED VARIABLE  s-codcia AS INTEGER INITIAL 1.
DEFINE VARIABLE Y-codcia                AS INTEGER INITIAL 0.
DEFINE VARIABLE X-NROREF LIKE integral.Bcoconci.Nroref.

FIND integral.empresas WHERE integral.empresas.codcia = s-codcia.
IF NOT integral.empresas.campo-codcbd THEN y-codcia = s-codcia.

FIND integral.cb-cfga WHERE cb-cfga.CodCia = Y-CodCia AND CodCfg = 1
    NO-LOCK NO-ERROR.        

IF NOT AVAIL integral.cb-cfga THEN DO:
    BELL.
    MESSAGE "NO SE HA CONFIGURADO EL SISTEMA CONTABLE"
        VIEW-AS ALERT-BOX.
    RETURN.
END.

IF integral.cb-cfga.ctacredito = "" THEN DO: 
    BELL.
    MESSAGE "NO SE HA CONFIGURADO LAS CUENTAS DE CREDITO" 
        VIEW-AS ALERT-BOX.
    RETURN.
END.

DEFINE {&NEW} SHARED VARIABLE cb-niveles AS CHARACTER INITIAL "2,3,5".
DEFINE {&NEW} SHARED VARIABLE s-periodo AS INTEGER INITIAL 1995.
DEFINE {&NEW} SHARED VARIABLE s-NroMes AS INTEGER INITIAL 2.
DEFINE VARIABLE RECID-stack AS RECID NO-UNDO.
DEFINE VARIABLE RECID-tmp   AS RECID NO-UNDO.
DEFINE VARIABLE x-nivel     AS CHARACTER.
DEFINE VARIABLE x-ctacre    AS CHARACTER INITIAL "".
DEFINE VARIABLE x-maxnivel  AS INTEGER.
DEFINE VARIABLE x-debe      AS DECIMAL.
DEFINE VARIABLE x-haber     AS DECIMAL.
DEFINE VARIABLE pto         AS LOGICAL.

x-maxnivel = INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles)).
pto        = SESSION:SET-WAIT-STATE("").
   
/*   C A M B I O S   E N    L O S   P R E - P R O C E S A D O R E S */

/* Solo muestra los registros que cumplan con la condici¢n : */
&Scoped-define RECORD-SCOPE integral.cb-ctas.CodCia = Y-CodCia AND ~
    integral.cb-ctas.Codcta BEGINS integral.cb-cfga.ctacredito AND ~
    LENGTH ( integral.cb-ctas.Codcta ) = x-maxnivel

/* Como Buscar un Registro en la Tabla ( Para Crear, modificar, anular etc.) */
&Scoped-define SEARCH-KEY integral.cb-ctas.Codcta = integral.cb-ctas.Codcta:SCREEN-VALUE IN FRAME F-maestro

/*
/* Campos Ocultos que deben ser asignados en cada modificaci¢n */
&Scoped-define ASSIGN-ADD integral.cb-ctas.CodCia = Y-CodCia

/* Campos que no pueden ser modificados */
&Scoped-define NO-MODIFY integral.cb-ctas.Codcta integral.cb-ctas.activo integral.cb-ctas.nomcta
*/

/* Programa donde relaizara la Consulta */
&Scoped-define q-modelo cbd/q-ctas3.w ( Y-CodCia, "10", OUTPUT RECID-stack )

/* Campos por los cuales se puede hacer Busquedas */
&Scoped-define Query-Field integral.cb-ctas.Codcta integral.cb-ctas.nomcta

DEFINE BUTTON B-aceptar AUTO-GO 
     LABEL "&Aceptar" 
     SIZE 10 BY 1.

DEFINE BUTTON B-cancelar AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE R-ctacredito
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 44 BY 6.5
     BGCOLOR 8 .

DEFINE RECTANGLE R-ctacredito2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 44 BY 2
     BGCOLOR 8 .

DEFINE FRAME F-ctacredito
     integral.bcoconci.Fchref AT ROW 1.5 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY 1
     integral.bcoconci.Nroref AT ROW 3 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY 1
     integral.bcoconci.TpoMov AT ROW 4.5 COL 22 COLON-ALIGNED HELP
          "Tipo de Movimiento Haber / Debe"
          LABEL "Tipo de Movimiento"
          VIEW-AS FILL-IN 
          SIZE 3.43 BY 1
     integral.bcoconci.Importe AT ROW 6 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY 1
     B-aceptar AT ROW 8 COL 8
     B-cancelar AT ROW 8 COL 28
     R-ctacredito AT ROW 1 COL 1
     R-ctacredito2 AT ROW 7.5 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         TITLE "Movimiento de cuenta" ROW 3 CENTERED.


ON "CHOOSE" OF B-ACEPTAR
DO:
    X-NROREF =  integral.Bcoconci.nroref. /* Nro.Antes del Input */

    IF CAN-FIND ( integral.Bcoconci WHERE 
                  integral.Bcoconci.codcia  = Bcoconci.codcia  AND 
                  integral.Bcoconci.periodo = Bcoconci.periodo AND 
                  integral.Bcoconci.Nromes  = Bcoconci.nromes  AND
                  integral.Bcoconci.Codcta  = Bcoconci.codcta  AND
                  integral.Bcoconci.Nroref  = Bcoconci.nroref:SCREEN-VALUE IN FRAME F-Ctacredito ) 
        THEN DO:
                BELL.
                MESSAGE "Nro.de Referencia " + integral.Bcoconci.Nroref:SCREEN-VALUE IN FRAME F-Ctacredito + " !! Ya Ingresado - Revise !! " VIEW-AS ALERT-BOX ERROR.
                APPLY "ENTRY" TO integral.Bcoconci.Nroref.
                RETURN NO-APPLY. 
        END.

    IF integral.Bcoconci.flgori = "B" AND 
        NOT CAN-FIND ( integral.cbdbanco 
            WHERE integral.cbdbanco.codcia  = Bcoconci.codcia  AND 
                  integral.cbdbanco.periodo = Bcoconci.periodo AND 
                  integral.cbdbanco.Nromes  = Bcoconci.nromes  AND
                  integral.cbdbanco.Codcta  = Bcoconci.codcta  AND
                  integral.cbdbanco.Nroref  = x-nroref ) 
       THEN DO:
            BELL.
            MESSAGE "Nro.de Referencia " + x-nroref + " No existe en Maestro CBDBANCO - Revise !! " VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO integral.Bcoconci.Nroref.
            RETURN NO-APPLY. 
       END.
              
    IF integral.Bcoconci.flgori = "L" AND  
        NOT CAN-FIND ( integral.cb-dmov 
            WHERE integral.cb-dmov.codcia  = Bcoconci.codcia  AND
                  integral.cb-dmov.periodo = Bcoconci.periodo AND 
                  integral.cb-dmov.Nromes  = Bcoconci.nromes  AND
                  integral.cb-dmov.Codcta  = Bcoconci.codcta  AND
                  integral.cb-dmov.Nroref  = x-nroref ) 
       THEN DO:
           BELL.
           MESSAGE "Nro.de Referencia " + x-nroref + " No existe en Maestro cb-dmov - Revise !! " VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO integral.Bcoconci.Nroref.
           RETURN NO-APPLY. 
       END.
    
    
    IF integral.Bcoconci.flgori = "B" 
    THEN DO:
        FIND integral.cbdbanco 
            WHERE integral.cbdbanco.codcia  = Bcoconci.codcia  AND 
                  integral.cbdbanco.periodo = Bcoconci.periodo AND 
                  integral.cbdbanco.Nromes  = Bcoconci.nromes  AND
                  integral.cbdbanco.Codcta  = Bcoconci.codcta  AND
                  integral.cbdbanco.Nroref  = X-Nroref.
        IF AVAIL integral.cbdbanco THEN  
            ASSIGN  integral.cbdbanco.Nroref = 
                    integral.Bcoconci.Nroref:SCREEN-VALUE IN FRAME F-ctacredito.
    END.   
  
    IF integral.Bcoconci.flgori = "L" 
    THEN DO:
        FIND integral.cb-dmov WHERE 
                integral.cb-dmov.codcia  = Bcoconci.codcia  AND 
                integral.cb-dmov.periodo = Bcoconci.periodo AND 
                integral.cb-dmov.Nromes  = Bcoconci.nromes  AND
                integral.cb-dmov.Codcta  = Bcoconci.codcta  AND
                integral.cb-dmov.Nroref  = X-Nroref.
        IF AVAIL integral.cb-dmov THEN  
            ASSIGN  integral.cb-dmov.Nroref = 
                    integral.Bcoconci.Nroref:SCREEN-VALUE IN FRAME F-ctacredito.
    END.   



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ********************  Preprocessor Definitions  ******************** */

/* Name of first Frame and/or Browse (alphabetically)                   */
&Scoped-define FRAME-NAME  F-ctrl-frame
&Scoped-define BROWSE-NAME BRW-credito

/* Custom List Definitions                                              */
&Scoped-define LIST-1 
&Scoped-define LIST-2 
&Scoped-define LIST-3 

/* Definitions for BROWSE BRW-credito                                   */
&Scoped-define FIELDS-IN-QUERY-BRW-credito integral.bcoconci.Fchref ~
integral.bcoconci.Nroref integral.bcoconci.TpoMov ~
(IF (integral.bcoconci.tpomov) THEN (integral.bcoconci.Importe) ELSE (0)) ~
(IF (NOT integral.bcoconci.TpoMov) THEN (integral.bcoconci.Importe) ELSE (0)) 
&Scoped-define OPEN-QUERY-BRW-credito OPEN QUERY BRW-credito FOR EACH integral.bcoconci WHERE TRUE /* Join to integral.cb-ctas incomplete */ ~
      AND integral.bcoconci.Codcia = s-codcia ~
 AND integral.bcoconci.Codcta = integral.cb-ctas.Codcta:SCREEN-VALUE IN FRAME F-MAESTRO ~
 AND integral.bcoconci.Periodo = s-periodo ~
 AND integral.bcoconci.Flgest = "" ~
  NO-LOCK ~
    BY integral.bcoconci.Fchref ~
       BY integral.bcoconci.Nroref ~
        BY integral.bcoconci.TpoMov.
&Scoped-define FIRST-TABLE-IN-QUERY-BRW-credito integral.bcoconci
&Scoped-define TABLES-IN-QUERY-BRW-credito integral.bcoconci 

/* Definitions for FRAME F-ctrl-frame                                   */
&Scoped-define FIELDS-IN-QUERY-F-ctrl-frame 
&Scoped-define ENABLED-FIELDS-IN-QUERY-F-ctrl-frame 

/* Definitions for FRAME F-maestro                                      */
&Scoped-define FIELDS-IN-QUERY-F-maestro integral.cb-ctas.Codmon ~
integral.cb-ctas.Codcta integral.cb-ctas.Nomcta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-F-maestro ~
integral.cb-ctas.Codmon integral.cb-ctas.Codcta integral.cb-ctas.Nomcta 
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-maestro ~
    ~{&OPEN-QUERY-BRW-credito}
&Scoped-define OPEN-QUERY-F-maestro OPEN QUERY F-maestro FOR EACH integral.cb-ctas ~
      WHERE integral.cb-ctas.CodCia = y-Codcia ~
 AND LENGTH(integral.cb-ctas.Codcta ) = X-Maxnivel ~
 AND integral.cb-ctas.Codcta BEGINS integral.cb-cfga.Ctacredito SHARE-LOCK.
&Scoped-define FIRST-TABLE-IN-QUERY-F-maestro integral.cb-ctas
&Scoped-define TABLES-IN-QUERY-F-maestro integral.cb-ctas 

/* Definitions for FRAME F-search                                       */
&Scoped-define FIELDS-IN-QUERY-F-search 
&Scoped-define ENABLED-FIELDS-IN-QUERY-F-search 

/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-maestro AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-add 
     LABEL "&Crear" 
     SIZE 9 BY 1.

DEFINE BUTTON B-browse 
     IMAGE-UP FILE "IMG/pvbrow"
     IMAGE-DOWN FILE "IMG/pvbrowd"
     IMAGE-INSENSITIVE FILE "IMG/pvbrowx"
     LABEL "&Consulta" 
     SIZE 5.72 BY 1.5.

DEFINE BUTTON B-delete 
     LABEL "&Eliminar":L 
     SIZE 9 BY 1
     font 4.

DEFINE BUTTON B-exit 
     LABEL "&Salir":L 
     SIZE 7 BY 1
     font 4.

DEFINE BUTTON B-first 
     IMAGE-UP FILE "IMG/pvfirst"
     IMAGE-DOWN FILE "IMG/pvfirstd"
     IMAGE-INSENSITIVE FILE "IMG/pvfirstx"
     LABEL "<<":L 
     SIZE 5 BY 1
     font 4.

DEFINE BUTTON B-last 
     IMAGE-UP FILE "IMG/pvlast"
     IMAGE-DOWN FILE "IMG/pvlastd"
     IMAGE-INSENSITIVE FILE "IMG/pvlastx"
     LABEL ">>":L 
     SIZE 4.57 BY 1
     font 4.

DEFINE BUTTON B-next 
     IMAGE-UP FILE "IMG/pvforw"
     IMAGE-DOWN FILE "IMG/pvforwd"
     IMAGE-INSENSITIVE FILE "IMG/pvforwx"
     LABEL ">":L 
     SIZE 5 BY 1
     font 4.

DEFINE BUTTON B-prev 
     IMAGE-UP FILE "IMG/pvback"
     IMAGE-DOWN FILE "IMG/pvbackd"
     IMAGE-INSENSITIVE FILE "IMG/pvbackx"
     LABEL "<":L 
     SIZE 5 BY 1
     font 4.

DEFINE BUTTON B-query 
     LABEL "&Buscar":L 
     SIZE 7.57 BY 1
     font 4.

DEFINE BUTTON B-update 
     LABEL "&Modificar":L 
     SIZE 9 BY 1
     font 4.

DEFINE RECTANGLE R-consulta
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 10 BY 2
     BGCOLOR 8 .

DEFINE RECTANGLE R-exit
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 11.57 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-modify
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 33 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-navigaate
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 26 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-query
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 10 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE VARIABLE x-Saldoi AS DECIMAL FORMAT "->>>>>>,>>9.99":U INITIAL 0 
     LABEL "Saldo Inicial" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-totabono AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-totcargo AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE R-maestro1
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90.86 BY 3.5
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-maestro2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90.86 BY 10.12
     BGCOLOR 8 FGCOLOR 15 .

DEFINE BUTTON B-Cancel-3 
     LABEL "&Cancelar":L 
     SIZE 9 BY 1
     font 4.

DEFINE BUTTON B-ok-3 AUTO-GO 
     LABEL "&Aceptar":L 
     SIZE 9 BY 1
     font 4.

DEFINE RECTANGLE R-navigaate-4
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90.57 BY 2
     BGCOLOR 8 FGCOLOR 15 .


/* Query definitions                                                    */
DEFINE QUERY BRW-credito FOR integral.bcoconci SCROLLING.
DEFINE QUERY F-maestro FOR integral.cb-ctas SCROLLING.

/* Browse definitions                                                   */
DEFINE BROWSE BRW-credito QUERY BRW-credito NO-LOCK DISPLAY 
      integral.bcoconci.Fchref COLUMN-LABEL "    Fecha!"
      integral.bcoconci.Nroref COLUMN-LABEL "Nro.de Ref.!"
      integral.bcoconci.TpoMov
&ANALYZE-SUSPEND
      (IF (integral.bcoconci.tpomov) THEN (integral.bcoconci.Importe) ELSE (0)) COLUMN-LABEL "Cargos" FORMAT "ZZ,ZZZ,ZZZ,ZZ9.99"
&ANALYZE-RESUME
&ANALYZE-SUSPEND
      (IF (NOT integral.bcoconci.TpoMov) THEN (integral.bcoconci.Importe) ELSE (0)) COLUMN-LABEL "Abonos" FORMAT "ZZ,ZZZ,ZZZ,ZZ9.99"
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 47.43 BY 8
         BGCOLOR 15 font 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-maestro
     integral.cb-ctas.Codmon AT ROW 1.38 COL 66 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Soles", 1,
"D¢lares", 2
          SIZE 10 BY 1.5
     integral.cb-ctas.Codcta AT ROW 1.77 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 15 
     integral.cb-ctas.Nomcta AT ROW 3 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 52 BY .81
          BGCOLOR 15 
     BRW-credito AT ROW 5 COL 16
     x-Saldoi AT ROW 5.5 COL 72 COLON-ALIGNED
     x-totabono AT ROW 13.31 COL 31.57 COLON-ALIGNED NO-LABEL
     x-totcargo AT ROW 13.31 COL 45 COLON-ALIGNED NO-LABEL
     R-maestro1 AT ROW 1 COL 1
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 1.5 COL 58
     R-maestro2 AT ROW 4.5 COL 1
     "Totales -->" VIEW-AS TEXT
          SIZE 12 BY 1 AT ROW 13.19 COL 21
          FONT 1
    WITH 1 DOWN NO-BOX OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 90.86 BY 13.62
         BGCOLOR 8 FGCOLOR 0 font 4.

DEFINE FRAME F-search
     B-ok-3 AT ROW 1.54 COL 24.29
     B-Cancel-3 AT ROW 1.54 COL 57.57
     R-navigaate-4 AT ROW 1 COL 1
    WITH 1 DOWN OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 14.61
         SIZE 90.86 BY 2.08
         BGCOLOR 8 FGCOLOR 0 .

DEFINE FRAME F-ctrl-frame
     B-browse AT ROW 1.27 COL 72
     B-query AT ROW 1.5 COL 2
     B-add AT ROW 1.5 COL 14
     B-update AT ROW 1.5 COL 24
     B-delete AT ROW 1.5 COL 34
     B-first AT ROW 1.5 COL 46
     B-prev AT ROW 1.5 COL 52
     B-next AT ROW 1.5 COL 58
     B-last AT ROW 1.5 COL 64
     B-exit AT ROW 1.5 COL 82
     R-query AT ROW 1 COL 1
     R-modify AT ROW 1 COL 11
     R-navigaate AT ROW 1 COL 44
     R-consulta AT ROW 1 COL 70
     R-exit AT ROW 1 COL 80
    WITH 1 DOWN OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 14.61
         SIZE 90.86 BY 2.08
         BGCOLOR 8 FGCOLOR 0 font 4.

 

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-maestro ASSIGN
         HIDDEN             = YES
         TITLE              = "Modifica y/o Consulta CONCILIACION"
         COLUMN             = 1.14
         ROW                = 1
         HEIGHT             = 15.73
         WIDTH              = 90.86
         MAX-HEIGHT         = 18.46
         MAX-WIDTH          = 91.43
         VIRTUAL-HEIGHT     = 18.46
         VIRTUAL-WIDTH      = 91.43
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = 8
         FGCOLOR            = 0
         THREE-D            = yes
         FONT               = 8
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT W-maestro:LOAD-ICON("IMG/valmiesa") THEN
    MESSAGE "Unable to load icon: IMG/valmiesa"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR FRAME F-ctrl-frame
   UNDERLINE                                                            */
/* SETTINGS FOR BUTTON B-delete IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-exit IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-first IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-last IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-next IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-prev IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-query IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-update IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR FRAME F-maestro
   UNDERLINE                                                            */
/* SETTINGS FOR FILL-IN x-totabono IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-totcargo IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME F-search
   NOT-VISIBLE UNDERLINE                                                */
ASSIGN 
       FRAME F-search:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON B-Cancel-3 IN FRAME F-search
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-ok-3 IN FRAME F-search
   NO-DISPLAY                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-maestro)
THEN W-maestro:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BRW-credito
/* Query rebuild information for BROWSE BRW-credito
     _TblList          = "integral.bcoconci WHERE integral.cb-ctas <external> ..."
     _Options          = "NO-LOCK"
     _OrdList          = "integral.bcoconci.Fchref|yes,integral.bcoconci.Nroref|yes,integral.bcoconci.TpoMov|yes"
     _JoinCode[1]      = ?
     _Where[1]         = "integral.bcoconci.Codcia = s-codcia
 AND integral.bcoconci.Codcta = integral.cb-ctas.Codcta:SCREEN-VALUE IN FRAME F-MAESTRO
 AND integral.bcoconci.Periodo = s-periodo
 AND integral.bcoconci.Flgest = """"
 "
     _FldNameList[1]   = integral.bcoconci.Fchref
     _FldLabelList[1]  = "    Fecha!"
     _FldNameList[2]   = integral.bcoconci.Nroref
     _FldLabelList[2]  = "Nro.de Ref.!"
     _FldNameList[3]   = integral.bcoconci.TpoMov
     _FldNameList[4]   = "(IF (integral.bcoconci.tpomov) THEN (integral.bcoconci.Importe) ELSE (0))"
     _FldLabelList[4]  = "Cargos"
     _FldFormatList[4] = "ZZ,ZZZ,ZZZ,ZZ9.99"
     _FldNameList[5]   = "(IF (NOT integral.bcoconci.TpoMov) THEN (integral.bcoconci.Importe) ELSE (0))"
     _FldLabelList[5]  = "Abonos"
     _FldFormatList[5] = "ZZ,ZZZ,ZZZ,ZZ9.99"
     _Query            is OPENED
*/  /* BROWSE BRW-credito */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-maestro
/* Query rebuild information for FRAME F-maestro
     _TblList          = "integral.cb-ctas"
     _Options          = "SHARE-LOCK"
     _OrdList          = ""
     _JoinCode[1]      = ?
     _Where[1]         = "integral.cb-ctas.CodCia = y-Codcia
 AND LENGTH(integral.cb-ctas.Codcta ) = X-Maxnivel
 AND integral.cb-ctas.Codcta BEGINS integral.cb-cfga.Ctacredito"
     _Query            is OPENED
*/  /* FRAME F-maestro */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-add W-maestro
ON CHOOSE OF B-add IN FRAME F-ctrl-frame /* Crear */
DO:
    MESSAGE "Para Creaci¢n ingrese a M¢dulo de Movimientos de Cuentas de Cr‚dito" VIEW-AS ALERT-BOX ERROR.
    RETURN.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-browse W-maestro
ON CHOOSE OF B-browse IN FRAME F-ctrl-frame /* Consulta */
DO:
    RUN {&q-modelo} .
    IF RECID-stack <> 0
    THEN DO:
        FIND {&TABLES-IN-QUERY-F-maestro}
             WHERE RECID( {&TABLES-IN-QUERY-F-maestro} ) = RECID-stack
              NO-LOCK  NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
         ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
         BUTTONS OK.
     END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-search
&Scoped-define SELF-NAME B-Cancel-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Cancel-3 W-maestro
ON CHOOSE OF B-Cancel-3 IN FRAME F-search /* Cancelar */
DO:
     FIND PREV {&FIRST-TABLE-IN-QUERY-F-maestro} 
     &IF "{&RECORD-SCOPE}" <> "" &THEN
          WHERE {&RECORD-SCOPE}
      &ENDIF  
     NO-LOCK NO-ERROR.
     IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN 
     FIND FIRST {&FIRST-TABLE-IN-QUERY-F-maestro}
     &IF "{&RECORD-SCOPE}" <> "" &THEN
          WHERE {&RECORD-SCOPE}
      &ENDIF  
      NO-LOCK NO-ERROR.
     IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN  RUN Pintado.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define SELF-NAME B-delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-delete W-maestro
ON CHOOSE OF B-delete IN FRAME F-ctrl-frame /* Eliminar */
DO:
    RECID-tmp = 0.
    IF AVAIL integral.cbdbanco THEN RECID-tmp = RECID ( integral.cbdbanco ).
    DO TRANSACTION ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        FIND integral.cbdbanco WHERE RECID-Tmp = RECID( integral.cbdbanco )
            EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL integral.cbdbanco THEN DO:
            MESSAGE "Eliminar movimiento"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE selection AS LOGICAL.
            IF selection THEN DO:
                DELETE integral.cbdbanco.
                {&OPEN-QUERY-BRW-credito}
                 RUN calcula.
                 
                {&OPEN-QUERY-BRW-credito}
               
            END.
            ELSE
                FIND integral.cbdbanco
                    WHERE RECID-Tmp = RECID( integral.cbdbanco )
                        NO-LOCK NO-ERROR.
        END.
        ELSE MESSAGE "No existen movimientos." VIEW-AS ALERT-BOX ERROR
        BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-exit W-maestro
ON CHOOSE OF B-exit IN FRAME F-ctrl-frame /* Salir */
DO:
     APPLY  "CLOSE" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-first
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-first W-maestro
ON CHOOSE OF B-first IN FRAME F-ctrl-frame /* << */
DO:
    FIND FIRST {&TABLES-IN-QUERY-F-maestro}
        &IF "{&RECORD-SCOPE}" <> "" &THEN
            WHERE {&RECORD-SCOPE}
        &ENDIF
        NO-LOCK NO-ERROR.
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
    ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
        BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-last
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-last W-maestro
ON CHOOSE OF B-last IN FRAME F-ctrl-frame /* >> */
DO:

     FIND LAST {&FIRST-TABLE-IN-QUERY-F-maestro}
     &IF "{&RECORD-SCOPE}" <> "" &THEN
          WHERE {&RECORD-SCOPE}
      &ENDIF  
      NO-LOCK  NO-ERROR.
     
     IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
     ELSE MESSAGE "No exiten Registros." VIEW-AS ALERT-BOX ERROR
             BUTTONS OK.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-next
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-next W-maestro
ON CHOOSE OF B-next IN FRAME F-ctrl-frame /* > */
DO: 
     FIND NEXT {&FIRST-TABLE-IN-QUERY-F-maestro}  
     &IF "{&RECORD-SCOPE}" <> "" &THEN
          WHERE {&RECORD-SCOPE}
     &ENDIF
     NO-LOCK  NO-ERROR.
     IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN 
     FIND FIRST {&FIRST-TABLE-IN-QUERY-F-maestro} 
     &IF "{&RECORD-SCOPE}" <> "" &THEN
          WHERE {&RECORD-SCOPE}
     &ENDIF  
     NO-LOCK NO-ERROR.
     IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
     ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
             BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-search
&Scoped-define SELF-NAME B-ok-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-ok-3 W-maestro
ON CHOOSE OF B-ok-3 IN FRAME F-search /* Aceptar */
DO:
    IF cb-ctas.codcta:SCREEN-VALUE IN FRAME F-maestro <> "" THEN DO:
         FIND FIRST  {&FIRST-TABLE-IN-QUERY-F-maestro}
              WHERE 
                  &IF "{&RECORD-SCOPE}" <> "" &THEN
                      {&RECORD-SCOPE} AND
                  &ENDIF
                  cb-ctas.codcta = cb-ctas.codcta:SCREEN-VALUE IN FRAME F-maestro
                   NO-LOCK NO-ERROR.
         ASSIGN integral.cb-ctas.Nomcta:SCREEN-VALUE = "".
    END.

    IF integral.cb-ctas.Nomcta:SCREEN-VALUE IN FRAME F-maestro <> "" THEN DO:
         FIND FIRST  {&FIRST-TABLE-IN-QUERY-F-maestro}
              WHERE 
                  &IF "{&RECORD-SCOPE}" <> "" &THEN
                      {&RECORD-SCOPE} AND
                  &ENDIF
                  integral.cb-ctas.Nomcta BEGINS integral.cb-ctas.Nomcta:SCREEN-VALUE IN FRAME F-maestro
                   NO-LOCK NO-ERROR.
         ASSIGN integral.cb-ctas.codcta:SCREEN-VALUE = "".
    END.
   
     IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
         APPLY "CHOOSE" TO B-Browse IN FRAME F-ctrl-frame.
        IF RECID-stack <> 0
        THEN RETURN.
     END.
         
     IF NOT AVAIL  {&FIRST-TABLE-IN-QUERY-F-maestro}  THEN DO:
         FIND FIRST  {&FIRST-TABLE-IN-QUERY-F-maestro}
         &IF "{&RECORD-SCOPE}" <> "" &THEN
              WHERE {&RECORD-SCOPE}
          &ENDIF  
          NO-LOCK NO-ERROR.
     END.
     
      IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN  RUN Pintado.
      ELSE DO:
           CLEAR FRAME F-maestro.
           MESSAGE  "Registro no Existente." VIEW-AS ALERT-BOX ERROR BUTTONS OK. 
     END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define SELF-NAME B-prev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-prev W-maestro
ON CHOOSE OF B-prev IN FRAME F-ctrl-frame /* < */
DO:
     FIND PREV {&FIRST-TABLE-IN-QUERY-F-maestro}
     &IF "{&RECORD-SCOPE}" <> "" &THEN
          WHERE {&RECORD-SCOPE}
     &ENDIF  
     NO-LOCK  NO-ERROR.
     IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN 
     FIND LAST {&FIRST-TABLE-IN-QUERY-F-maestro} 
     &IF "{&RECORD-SCOPE}" <> "" &THEN
          WHERE {&RECORD-SCOPE}
     &ENDIF  
     NO-LOCK NO-ERROR.
     IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
     ELSE MESSAGE "No Existen Registros" VIEW-AS ALERT-BOX ERROR
             BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-query
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-query W-maestro
ON CHOOSE OF B-query IN FRAME F-ctrl-frame /* Buscar */
DO:
    FIND FIRST {&FIRST-TABLE-IN-QUERY-F-maestro}
        &IF "{&RECORD-SCOPE}" <> "" &THEN
            WHERE {&RECORD-SCOPE}
        &ENDIF
        NO-LOCK NO-ERROR.
    IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
        MESSAGE  "No exiten Registros." VIEW-AS ALERT-BOX ERROR
        BUTTONS OK.
        RETURN.
    END.
    CLEAR FRAME F-maestro.
    FRAME F-ctrl-frame:VISIBLE = FALSE.
    FRAME F-search:VISIBLE = TRUE.
    BRW-credito:SENSITIVE = FALSE.
    ENABLE {&QUERY-field} WITH FRAME F-maestro.
    WAIT-FOR "CHOOSE" OF b-ok-3 IN FRAME f-search
        OR CHOOSE OF b-cancel-3 IN FRAME f-search.
    DISABLE {&QUERY-field} WITH FRAME F-maestro.
    FRAME f-search:VISIBLE = FALSE.
    BRW-credito:SENSITIVE = TRUE.
    FRAME f-ctrl-frame:VISIBLE = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-update
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-update W-maestro
ON CHOOSE OF B-update IN FRAME F-ctrl-frame /* Modificar */
DO:
DEFINE VARIABLE X-NROREF LIKE integral.Bcoconci.Nroref.
    RECID-stack = 0.
    IF AVAIL integral.Bcoconci THEN RECID-stack = RECID( integral.Bcoconci ).
    DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        FIND integral.Bcoconci WHERE RECID ( integral.Bcoconci ) = RECID-stack
            EXCLUSIVE NO-ERROR.
        IF AVAIL integral.Bcoconci THEN DO:
            DISPLAY integral.Bcoconci.Fchref
                   integral.Bcoconci.Nroref
                   integral.Bcoconci.Tpomov
                   integral.Bcoconci.importe  WITH FRAME F-ctacredito.
            UPDATE integral.Bcoconci.Nroref 
            b-aceptar b-cancelar WITH FRAME F-ctacredito.
            {&OPEN-QUERY-BRW-credito}
            RUN calcula.            
        END.
        ELSE MESSAGE "Registro de movimiento no existe"
            VIEW-AS ALERT-BOX ERROR.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-maestro 


/* ***************************  Main Block  *************************** */

/* Send messages to alert boxes because there is no message area.       */
ASSIGN CURRENT-WINDOW             = {&WINDOW-NAME}
       SESSION:SYSTEM-ALERT-BOXES = (CURRENT-WINDOW:MESSAGE-AREA = NO).
 
ON CLOSE OF THIS-PROCEDURE
      RUN disable_UI.
        
ON "WINDOW-CLOSE" OF {&WINDOW-NAME}  DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

ON "ENDKEY", END-ERROR OF B-add, B-browse, B-Cancel-3, 
        B-delete, B-exit, B-first, B-last, B-next, B-ok-3, B-prev, 
        B-query, B-update, FRAME F-maestro
DO: 
    IF FRAME F-search:VISIBLE = TRUE THEN APPLY "CHOOSE" TO B-cancel-3.
    IF FRAME F-ctrl-frame:VISIBLE = TRUE 
    THEN APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

ON "GO" OF FRAME F-maestro, FRAME F-search
DO: 
    IF FRAME F-search:VISIBLE = TRUE THEN APPLY "CHOOSE" TO B-ok-3.
    RETURN NO-APPLY.
END.

ON DELETE-CHARACTER OF  B-query, B-add, B-update, B-delete, 
            B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-delete.
    RETURN NO-APPLY.    
END.

ON END OF  B-query, B-add, B-update, B-delete, 
           B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-last.
    RETURN NO-APPLY.    
END.

ON F8 OF  B-query, B-add, B-update, B-delete, 
          B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-browse.
    RETURN NO-APPLY.    
END.

ON HOME OF  B-query, B-add, B-update, B-delete, 
            B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-first.
    RETURN NO-APPLY.    
END.

ON INSERT-MODE OF  B-query, B-add, B-update, B-delete, 
            B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-add.
    RETURN NO-APPLY.    
END.

ON PAGE-DOWN OF  B-query, B-add, B-update, B-delete, 
            B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-next.
    RETURN NO-APPLY.  
END.

ON PAGE-UP OF  B-query, B-add, B-update, B-delete, 
            B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-prev.
    RETURN NO-APPLY.  
END.

ON RETURN OF  B-query, B-add, B-update, B-delete, 
            B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-update.
    RETURN NO-APPLY.    
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

MAIN-BLOCK:
DO ON ERROR UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    ASSIGN
    FRAME f-search:VISIBLE = FALSE
    FRAME F-ctrl-frame:VISIBLE = TRUE.

    RUN enable_UI.

    FIND LAST {&FIRST-TABLE-IN-QUERY-F-maestro}
    &IF "{&RECORD-SCOPE}" <> "" &THEN
         WHERE {&RECORD-SCOPE}
    &ENDIF
    NO-LOCK  NO-ERROR.
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
    ELSE CLEAR FRAME F-maestro.

    DISABLE {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
    IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
    
    
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcula W-maestro 
PROCEDURE calcula :
ASSIGN
    x-saldoi   = 0
    x-totabono = 0
    x-totcargo = 0.

GET FIRST BRW-credito NO-LOCK.

IF AVAIL integral.bcoconci THEN
    x-saldoi = integral.bcoconci.sdoini.

DO WHILE AVAIL ( integral.bcoconci ):
    IF integral.bcoconci.tpomov THEN
        x-totabono = x-totabono + integral.bcoconci.importe.
    ELSE
        x-totcargo = x-totcargo + integral.bcoconci.importe.
    GET NEXT BRW-credito NO-LOCK.
END.

DISPLAY  x-saldoi x-totabono x-totcargo WITH FRAME F-maestro.

GET FIRST BRW-credito NO-LOCK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-maestro _DEFAULT-DISABLE
PROCEDURE disable_UI :
/* --------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
   -------------------------------------------------------------------- */
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U THEN DELETE WIDGET W-maestro.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-maestro _DEFAULT-ENABLE
PROCEDURE enable_UI :
/* --------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
   -------------------------------------------------------------------- */

  {&OPEN-QUERY-F-maestro}
  GET FIRST F-maestro.
  DISPLAY x-Saldoi x-totabono x-totcargo 
      WITH FRAME F-maestro IN WINDOW W-maestro.
  IF AVAILABLE integral.cb-ctas THEN 
    DISPLAY integral.cb-ctas.Codmon integral.cb-ctas.Codcta 
          integral.cb-ctas.Nomcta 
      WITH FRAME F-maestro IN WINDOW W-maestro.
  ENABLE R-maestro1 integral.cb-ctas.Codmon integral.cb-ctas.Codcta 
         integral.cb-ctas.Nomcta R-maestro2 BRW-credito x-Saldoi 
      WITH FRAME F-maestro IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-maestro}
  ENABLE R-query R-modify R-navigaate R-consulta R-exit B-browse B-query B-add 
         B-update B-delete B-first B-prev B-next B-last B-exit 
      WITH FRAME F-ctrl-frame IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-ctrl-frame}
  ENABLE R-navigaate-4 B-ok-3 B-Cancel-3 
      WITH FRAME F-search IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-search}
  VIEW W-maestro.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pintado W-maestro 
PROCEDURE pintado :
DISPLAY {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
    {&OPEN-BROWSERS-IN-QUERY-F-maestro}
    RUN calcula.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE BROWSE-NAME
&UNDEFINE FRAME-NAME
&UNDEFINE WINDOW-NAME
