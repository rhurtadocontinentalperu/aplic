&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE IMAGE IMAGE-1 FILENAME "IMG\Coti.ico" SIZE 12 BY 1.5.
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

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 6.62
         WIDTH              = 45.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* 22/02/2024: Sugerencia de Soporte Técnico */
DEF SHARED VAR s-codcia AS INTE.
DEF VAR x-Ruta AS CHAR NO-UNDO.

DEFINE VAR cIPorigen AS CHAR.
DEFINE VAR cIPdestino AS CHAR.
DEFINE VAR cOtrosDatos AS CHAR.

cIPorigen = "192.168.100.251".

RUN lib/redireccionar-ip(cIPorigen, cOtrosDatos, OUTPUT cIPdestino).

/*x-Ruta = "\\192.168.100.251\Fotos_Ate\".*/
x-Ruta = "\\" + cIPdestino + "\Fotos_Ate\".

FIND FIRST VtaTabla WHERE Vtatabla.codcia = s-codcia AND
    Vtatabla.tabla = "CFG_RRHH_Fotos"
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaTabla AND VtaTabla.Libre_c01 > "" THEN DO:
    x-Ruta = TRIM(VtaTabla.Libre_c01).
    /* Debe terminar en \ */
    IF R-INDEX(x-Ruta,'\') <> LENGTH(x-Ruta) THEN x-Ruta = x-Ruta + "\".
END.

DEF BUFFER b-Pl-Pers FOR Pl-Pers.

FOR EACH pl-pers NO-LOCK:
    {lib/lock-genericov3.i ~
        &Tabla="b-pl-pers" ~
        &Alcance="FIRST" ~
        &Condicion="ROWID(b-pl-pers) = ROWID(pl-pers)" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="UNDO, NEXT"}
    FI-Mensaje = "Código: " + PL-PERS.CodPer.
    DISPLAY FI-Mensaje WITH FRAME F-Proceso.
    b-pl-pers.codbar = x-Ruta + TRIM(b-pl-pers.codper) + ".bmp".
    RELEASE b-pl-pers.
END.
HIDE FRAME F-Proceso.
MESSAGE "Proceso Terminado" VIEW-AS ALERT-BOX INFORMA.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


