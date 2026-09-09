&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CLIE FOR gn-clie.



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
DEFINE INPUT-OUTPUT PARAMETER S-CODCLI AS CHAR.
/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VARIABLE S-CODCIA  AS INT.
DEFINE SHARED VARIABLE CL-CODCIA  AS INT.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.

DEF VAR cEvento AS CHAR INIT "CREATE" NO-UNDO.

DEF VAR pBajaSunat AS LOG NO-UNDO.
DEF VAR pName AS CHAR NO-UNDO.
DEF VAR pAddress AS CHAR NO-UNDO.
DEF VAR pUbigeo AS CHAR NO-UNDO.
DEF VAR pResultado AS CHAR NO-UNDO.
DEF VAR pError AS CHAR NO-UNDO.
DEF VAR pDateInscription AS DATE NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS F-DNICli f-ApePat f-ApeMat f-Nombre F-DirCli ~
F-Telfnos f-Transporte RADIO-SET-Retenedor RADIO-SET-Percepcion F-GirCli ~
F-CodDept F-CodProv F-CodDist f-vende Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-Libre_C01 F-RucCli F-DNICli ~
F-CodCli f-ApePat f-ApeMat f-Nombre F-NomCli F-DirCli F-Telfnos ~
f-Transporte RADIO-SET-Retenedor RADIO-SET-Percepcion F-GirCli F-CodDept ~
F-CodProv F-CodDist f-vende f-condvta F-giro FILL-IN-DEP FILL-IN-PROV ~
FILL-IN-DIS f-nomven f-descond f-DateInscription 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEsAlfabetico D-Dialog 
FUNCTION getEsAlfabetico RETURNS LOGICAL
  ( INPUT pCaracter AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetSoloLetras D-Dialog 
FUNCTION GetSoloLetras RETURNS LOGICAL
  ( INPUT pTexto AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE f-ApeMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Apellido Materno" 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81
     BGCOLOR 11 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-ApePat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Apellido Paterno" 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81
     BGCOLOR 11 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE F-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 14 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE F-CodDept AS CHARACTER FORMAT "X(2)" 
     LABEL "Departamento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81.

DEFINE VARIABLE F-CodDist AS CHARACTER FORMAT "X(2)" 
     LABEL "Distrito" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81.

DEFINE VARIABLE F-CodProv AS CHARACTER FORMAT "X(2)" 
     LABEL "Provincias" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81.

DEFINE VARIABLE f-condvta AS CHARACTER FORMAT "XXX":U 
     LABEL "Condicion Vta." 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE f-DateInscription AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Inscripción SUNAT" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE f-descond AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE F-DirCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Direccion" 
     VIEW-AS FILL-IN 
     SIZE 71 BY .81 NO-UNDO.

DEFINE VARIABLE F-DNICli AS CHARACTER FORMAT "x(11)" 
     LABEL "DNI" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81.

DEFINE VARIABLE F-GirCli AS CHARACTER FORMAT "X(4)" 
     LABEL "Giro" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81.

DEFINE VARIABLE F-giro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE f-Nombre AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 71 BY .81
     BGCOLOR 11 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE F-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre/Razón Social" 
     VIEW-AS FILL-IN 
     SIZE 71 BY .81
     BGCOLOR 15 FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE f-nomven AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE F-RucCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "RUC" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE VARIABLE F-Telfnos AS CHARACTER FORMAT "X(13)":U 
     LABEL "Telefono" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE f-Transporte AS CHARACTER FORMAT "X(150)":U 
     LABEL "e-mail Fact. Electrónica" 
     VIEW-AS FILL-IN 
     SIZE 51 BY .81 NO-UNDO.

DEFINE VARIABLE f-vende AS CHARACTER FORMAT "XXX":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DEP AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DIS AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-PROV AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Libre_C01 AS CHARACTER INITIAL "N" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Jurídica", "J",
"Natural", "N",
"Extranjera", "E"
     SIZE 51 BY .81
     BGCOLOR 14 FGCOLOR 0 FONT 11 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Percepcion AS LOGICAL 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Si", yes,
"No", no
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Retenedor AS CHARACTER INITIAL "No" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Si", "Si",
"No", "No"
     SIZE 12 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     RADIO-SET-Libre_C01 AT ROW 1.19 COL 20 NO-LABEL WIDGET-ID 34
     F-RucCli AT ROW 2.08 COL 18 COLON-ALIGNED
     F-DNICli AT ROW 2.88 COL 18 COLON-ALIGNED HELP
          "DNI DEL (Cliente)"
     F-CodCli AT ROW 3.69 COL 18 COLON-ALIGNED
     f-ApePat AT ROW 4.5 COL 18 COLON-ALIGNED WIDGET-ID 2
     f-ApeMat AT ROW 5.31 COL 18 COLON-ALIGNED WIDGET-ID 4
     f-Nombre AT ROW 6.12 COL 18 COLON-ALIGNED WIDGET-ID 6
     F-NomCli AT ROW 6.92 COL 18 COLON-ALIGNED
     F-DirCli AT ROW 7.73 COL 18 COLON-ALIGNED
     F-Telfnos AT ROW 8.54 COL 18 COLON-ALIGNED
     f-Transporte AT ROW 9.35 COL 18 COLON-ALIGNED WIDGET-ID 44
     RADIO-SET-Retenedor AT ROW 10.42 COL 20 NO-LABEL WIDGET-ID 12
     RADIO-SET-Percepcion AT ROW 11.19 COL 20 NO-LABEL WIDGET-ID 18
     F-GirCli AT ROW 12.04 COL 18 COLON-ALIGNED
     F-CodDept AT ROW 12.85 COL 18 COLON-ALIGNED
     F-CodProv AT ROW 13.65 COL 18 COLON-ALIGNED
     F-CodDist AT ROW 14.46 COL 18 COLON-ALIGNED
     f-vende AT ROW 15.27 COL 18 COLON-ALIGNED
     f-condvta AT ROW 16.08 COL 18 COLON-ALIGNED
     F-giro AT ROW 12.04 COL 25 COLON-ALIGNED NO-LABEL
     FILL-IN-DEP AT ROW 12.85 COL 25 COLON-ALIGNED NO-LABEL
     FILL-IN-PROV AT ROW 13.65 COL 25 COLON-ALIGNED NO-LABEL
     FILL-IN-DIS AT ROW 14.46 COL 25 COLON-ALIGNED NO-LABEL
     f-nomven AT ROW 15.27 COL 25 COLON-ALIGNED NO-LABEL
     f-descond AT ROW 16.08 COL 25 COLON-ALIGNED NO-LABEL
     f-DateInscription AT ROW 2.88 COL 59 COLON-ALIGNED WIDGET-ID 42
     Btn_OK AT ROW 1.54 COL 83
     Btn_Cancel AT ROW 3.15 COL 83
     "Agente de Percepción:" VIEW-AS TEXT
          SIZE 16 BY .5 AT ROW 11.23 COL 4 WIDGET-ID 30
     "Persona:" VIEW-AS TEXT
          SIZE 15 BY .81 AT ROW 1.19 COL 5 WIDGET-ID 38
          FONT 11
     "<<< VERIFICAR ESTOS DATOS EN SUNAT <<<" VIEW-AS TEXT
          SIZE 40 BY .5 AT ROW 10.5 COL 33 WIDGET-ID 32
          BGCOLOR 10 FGCOLOR 1 FONT 6
     "Agente Retenedor:" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 10.42 COL 7 WIDGET-ID 16
     SPACE(76.42) SKIP(6.53)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Registro de Clientes".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CLIE B "?" ? INTEGRAL gn-clie
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME L-To-R,COLUMNS                                            */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-CodCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-condvta IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       f-condvta:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN f-DateInscription IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-descond IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-giro IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-nomven IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-RucCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DEP IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DIS IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-PROV IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET RADIO-SET-Libre_C01 IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Registro de Clientes */
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

   DO WITH FRAME {&FRAME-NAME}:
       f-ApePat:SCREEN-VALUE = TRIM(f-ApePat:SCREEN-VALUE).
       f-ApeMat:SCREEN-VALUE = TRIM(f-ApeMat:SCREEN-VALUE).
       f-Nombre:SCREEN-VALUE = TRIM(f-Nombre:SCREEN-VALUE).
       f-NomCli:SCREEN-VALUE = TRIM(f-NomCli:SCREEN-VALUE).
   END.

   ASSIGN 
       RADIO-SET-Libre_C01
       F-CodCli 
       F-CodDept 
       F-CodDist 
       F-CodProv 
       F-DirCli 
       F-NomCli 
       F-RucCli
       F-DNICli 
       F-Telfnos
       F-Vende 
       F-CondVta
       f-ApePat
       f-ApeMat
       f-Nombre
       f-DateInscription
       RADIO-SET-Percepcion 
       RADIO-SET-Retenedor
       f-GirCli
       fill-in-dep
       fill-in-prov
       fill-in-dis
       f-Transporte
       .

/* 15/05/2023 Campos que no pueden estar en blanco */
DO WITH FRAME {&FRAME-NAME}:
    IF TRUE <> (f-Transporte:SCREEN-VALUE > '') THEN DO:
            MESSAGE 'El e-mail para Facturacion Electronica esta vacio' SKIP
                '¿Esta seguro de dejarlo VACIO?'
             VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta2 AS LOG.
            IF rpta2 = NO THEN RETURN NO-APPLY.
    END.
END.


   IF TRUE <> (F-CodCli > "") THEN DO:
      MESSAGE "Codigo de Cliente en blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-CodCli.
      RETURN NO-APPLY.
   END.
   IF LENGTH(TRIM(F-CodCli)) <> 11 THEN DO:
      MESSAGE "Codigo de Cliente debe ser de 11 digitos" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-CodCli.
      RETURN NO-APPLY.
   END.
   IF TRUE <> (F-NomCli > "") THEN DO:
      MESSAGE "Nombre de Cliente en blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-NomCli.
      RETURN NO-APPLY.
   END.

   FIND FIRST gn-clie WHERE gn-clie.CodCia = CL-CODCIA
     AND  gn-clie.CodCli = F-CodCli NO-LOCK NO-ERROR.
   IF AVAILABLE gn-clie THEN DO:
       MESSAGE 'Codigo de Cliente YA EXISTE' VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO F-DNICli.
       RETURN NO-APPLY.
   END.

   /* Direccion Vacio */
   IF TRUE <> (f-DirCli > "") THEN DO:
        f-DirCli:SCREEN-VALUE = TRIM(CAPS(fill-in-dep)) + " - " + 
                    TRIM(CAPS(fill-in-prov)) + " - " + 
                    TRIM(CAPS(fill-in-dis)).
        ASSIGN f-dircli.
   END.

    DEF VAR pResultado AS CHAR.
    CASE TRUE:
        WHEN RADIO-SET-Libre_C01:SCREEN-VALUE = "J" THEN DO:
            IF LENGTH(F-RucCli:SCREEN-VALUE) <> 11 OR LOOKUP(SUBSTRING(F-RucCli:SCREEN-VALUE,1,2), '20') = 0 THEN DO:
                MESSAGE 'Debe tener 11 dígitos y comenzar con 20' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO F-RucCli.
                RETURN NO-APPLY.
            END.
            /* dígito verificador */
            RUN lib/_ValRuc (F-RucCli:SCREEN-VALUE, OUTPUT pResultado).
            IF pResultado = 'ERROR' THEN DO:
                MESSAGE 'Código MAL registrado' VIEW-AS ALERT-BOX WARNING.
                APPLY 'ENTRY':U TO F-RucCli.
                RETURN NO-APPLY.
            END.
            /* el e-mail es obligatorio */
            IF TRUE <> (f-Transporte > '') THEN DO:
                MESSAGE 'El e-mail para la facturación electrónica es obligatorio'
                    VIEW-AS ALERT-BOX WARNING.
                APPLY 'ENTRY':U TO f-Transporte.
                RETURN NO-APPLY.
            END.
        END.
        WHEN RADIO-SET-Libre_C01:SCREEN-VALUE = "N" THEN DO:
            IF F-RucCli:SCREEN-VALUE > '' THEN DO:
                IF LENGTH(F-RucCli:SCREEN-VALUE) <> 11 OR LOOKUP(SUBSTRING(F-RucCli:SCREEN-VALUE,1,2), '10,15') = 0 THEN DO:
                    MESSAGE 'Debe tener 11 dígitos y comenzar con 10 o 15' VIEW-AS ALERT-BOX ERROR.
                    APPLY 'ENTRY':U TO F-RucCli.
                    RETURN NO-APPLY.
                END.
                /* dígito verificador */
                RUN lib/_ValRuc (F-RucCli:SCREEN-VALUE, OUTPUT pResultado).
                IF pResultado = 'ERROR' THEN DO:
                    MESSAGE 'Código MAL registrado' VIEW-AS ALERT-BOX WARNING.
                    APPLY 'ENTRY':U TO F-RucCli.
                    RETURN NO-APPLY.
                END.
            END.
            IF TRUE <> (F-DNICli:SCREEN-VALUE > '') OR LENGTH(F-DNICli:SCREEN-VALUE) <> 8 THEN DO:
                MESSAGE 'Ingrese un DNI válido de 8 caracteres' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO F-DNICli.
                RETURN NO-APPLY.
            END.
        END.
        WHEN RADIO-SET-Libre_C01:SCREEN-VALUE = "E" THEN DO:
            /* 03/07/2023 Carnet de Extranjería actualmente 9 dígitos Gianella Chirinos S.Leon */
            IF F-RucCli:SCREEN-VALUE > '' THEN DO:
                IF LENGTH(F-RucCli:SCREEN-VALUE) <> 11 OR LOOKUP(SUBSTRING(F-RucCli:SCREEN-VALUE,1,2), '17') = 0 THEN DO:
                    MESSAGE 'Debe tener 11 dígitos y comenzar con 17' VIEW-AS ALERT-BOX ERROR.
                    APPLY 'ENTRY':U TO F-RucCli.
                    RETURN NO-APPLY.
                END.
                /* dígito verificador */
                RUN lib/_ValRuc (F-RucCli:SCREEN-VALUE, OUTPUT pResultado).
                IF pResultado = 'ERROR' THEN DO:
                    MESSAGE 'Código MAL registrado' VIEW-AS ALERT-BOX WARNING.
                    APPLY 'ENTRY':U TO F-RucCli.
                    RETURN NO-APPLY.
                END.
            END.
            IF TRUE <> (F-DNICli:SCREEN-VALUE > '') THEN DO:
                MESSAGE 'Ingrese un DNI válido' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO F-DNICli.
                RETURN NO-APPLY.
            END.
        END.
    END CASE.
    IF F-RucCli > '' THEN DO:
        DEF VAR x-requiere-validacion-sunat AS LOG INIT NO NO-UNDO.

        RUN requiere-validar-con-sunat(INPUT 'RUC', OUTPUT x-requiere-validacion-sunat).
        pBajaSunat = NO.
        IF x-requiere-validacion-sunat = YES THEN DO:
            /* Verificamos Información SUNAT */
            RUN gn/datos-sunat-clientes.r (
                INPUT F-RucCli,
                OUTPUT pBajaSunat,
                OUTPUT pName,
                OUTPUT pAddress,
                OUTPUT pUbigeo,
                OUTPUT pDateInscription,
                OUTPUT pError ).
            IF pError > '' THEN pBajaSunat = NO.
        END.
        IF pBajaSunat = YES THEN DO:
            MESSAGE 'El RUC está de baja en SUNAT' VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
    END.

    /* Validar los emails */
    DEF VAR x-Nro-EMails AS INT NO-UNDO.
    DEF VAR x-Item AS INT NO-UNDO.
    IF f-Transporte > '' THEN DO:
        x-Nro-EMails = NUM-ENTRIES(f-Transporte,';').
        DO x-Item = 1 TO x-Nro-EMails:
            RUN gn/valida-email (ENTRY(x-Item,f-Transporte,';'), 
                                 OUTPUT pError).
            IF pError > '' THEN DO:
                MESSAGE 'e-mail mal registrado' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO f-Transporte.
                RETURN NO-APPLY.
            END.
        END.
    END.

    FIND FIRST gn-ven WHERE gn-ven.codcia = s-codcia
        AND gn-ven.CodVen = F-vende NO-LOCK NO-ERROR.
    IF NOT AVAILABLE GN-VEN
    THEN DO:
        MESSAGE 'Codigo del Vendedor no Registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO F-Vende.
        RETURN NO-APPLY.
    END.

    FIND FIRST Tabdistr WHERE Tabdistr.CodDepto = F-CodDept 
        AND Tabdistr.Codprovi = F-CodProv
        AND Tabdistr.Coddistr = F-CodDist NO-LOCK NO-ERROR.
    IF NOT AVAILABLE TabDistr
    THEN DO:
        MESSAGE 'Codigo de Distrito no Registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO F-CodDept.
        RETURN NO-APPLY.
    END.

    /* Mostramos los clientes con ruc similares */
    DEF VAR x-Mensaje AS CHAR NO-UNDO.
    IF f-RucCli:SCREEN-VALUE <> '' THEN DO:
        x-Mensaje = ''.
        FOR EACH b-clie NO-LOCK WHERE b-clie.codcia = cl-codcia AND
            b-clie.ruc = f-RucCli:SCREEN-VALUE:
            x-Mensaje = x-Mensaje + (IF x-Mensaje <> '' THEN CHR(10) ELSE '') +
                b-clie.codcli + ' ' + b-clie.nomcli.
        END.
        IF x-Mensaje <> '' THEN DO:
            MESSAGE 'Los siguientes clientes tienen el mismo RUC:' SKIP
                x-Mensaje SKIP(1)
                'Continuamos?'
                VIEW-AS ALERT-BOX WARNING
                BUTTONS YES-NO UPDATE rpta AS LOG.
            IF rpta = NO THEN RETURN NO-APPLY.
            cEvento = "CREATE*".
        END.
    END.

    /* Validar Razon Social y Nombres */
    CASE TRUE:
        WHEN RADIO-SET-Libre_C01:SCREEN-VALUE = "J" THEN DO:
            IF LENGTH(TRIM(f-nomcli:SCREEN-VALUE)) < 5  THEN DO:
                MESSAGE 'Ingrese la razon social correctamente' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO F-nombre.
                RETURN NO-APPLY.
            END.
        END.
        OTHERWISE DO:
            IF LENGTH(TRIM(f-ApePat:SCREEN-VALUE)) < 2  THEN DO:
                MESSAGE 'Ingrese el apellido paterno correctamente' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO F-apepat.
                RETURN NO-APPLY.
            END.
            IF LENGTH(TRIM(f-nombre:SCREEN-VALUE)) < 2  THEN DO:
                MESSAGE 'Ingrese el nombre correctamente' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO F-nombre.
                RETURN NO-APPLY.
            END.
        END.
    END CASE.

    /**/
    DEFINE VAR hProc AS HANDLE NO-UNDO.         /* Handle Libreria */
    DEFINE VAR x-retval AS CHAR.

    RUN gn\master-library.r PERSISTENT SET hProc.

    /**/
    IF LOOKUP(RADIO-SET-Libre_C01:SCREEN-VALUE, "N,E") > 0 THEN DO:        /* Apellido Paterno */        
        x-retval = "".
        RUN VALIDA_AP_PATERNO IN hProc (INPUT f-ApePat, OUTPUT x-RetVal).
        IF x-RetVal <> "OK" THEN DO:

            DELETE PROCEDURE hProc.

            MESSAGE x-retval VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO F-apepat.
                RETURN NO-APPLY.
        END.
        x-retval = "".
        RUN VALIDA_NOMBRE IN hProc (INPUT f-Nombre, OUTPUT x-RetVal).
        IF x-RetVal <> "OK" THEN DO:

            DELETE PROCEDURE hProc.

            MESSAGE x-retval VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO F-nombre.
                RETURN NO-APPLY.
        END.
    END.
    ELSE DO:
        /*  NO VALIDA POR QUE LA RAZON SOCIAL LO TRAE DE LA SUNAT y NO ES EDITABLE
        x-retval = "".
        RUN VALIDA_RAZON_SOCIAL IN hProc (INPUT f-NomCli, OUTPUT x-RetVal).
        IF x-RetVal <> "OK" THEN DO:

            DELETE PROCEDURE hProc.

            MESSAGE x-retval VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO F-nomcli.
                RETURN NO-APPLY.
        END.
        */
    END.
    DELETE PROCEDURE hProc.                     /* Release Libreria */

    /**/
    RUN Crea-Cliente.

    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-ApeMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-ApeMat D-Dialog
ON LEAVE OF f-ApeMat IN FRAME D-Dialog /* Apellido Materno */
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    f-nomcli:SCREEN-VALUE = TRIM (f-apepat:SCREEN-VALUE) + " " +
        TRIM (f-apemat:SCREEN-VALUE) + ", " +
        f-nombre:SCREEN-VALUE.
    IF f-apepat:SCREEN-VALUE = '' AND f-apemat:SCREEN-VALUE = '' 
    THEN f-nomcli:SCREEN-VALUE = f-nombre:SCREEN-VALUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-ApePat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-ApePat D-Dialog
ON LEAVE OF f-ApePat IN FRAME D-Dialog /* Apellido Paterno */
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    f-nomcli:SCREEN-VALUE = TRIM (f-apepat:SCREEN-VALUE) + " " +
        TRIM (f-apemat:SCREEN-VALUE) + ", " +
        f-nombre:SCREEN-VALUE.
    IF f-apepat:SCREEN-VALUE = '' AND f-apemat:SCREEN-VALUE = '' 
    THEN f-nomcli:SCREEN-VALUE = f-nombre:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodCli D-Dialog
ON LEAVE OF F-CodCli IN FRAME D-Dialog /* Codigo */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  ASSIGN
      SELF:SCREEN-VALUE = STRING(DECIMAL(SELF:SCREEN-VALUE), '99999999999') NO-ERROR.
  FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
      AND  gn-clie.CodCli = SELF:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie THEN DO:
     MESSAGE "Codigo ya existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  F-RucCli:SCREEN-VALUE = SUBSTRING(SELF:SCREEN-VALUE,1,11).
  /* dígito verificador en caso de que se un número de ruc */
  DEF VAR pResultado AS CHAR.
  IF LOOKUP(SUBSTRING(SELF:SCREEN-VALUE,1,2), '10,20,15,17') > 0 THEN DO:
      RUN lib/_ValRuc (SELF:SCREEN-VALUE, OUTPUT pResultado).
      IF pResultado = 'ERROR' THEN DO:
          MESSAGE 'Código MAL registrado' VIEW-AS ALERT-BOX WARNING.
          RETURN NO-APPLY.
      END.
      IF F-RucCli:SCREEN-VALUE = '' THEN F-RucCli:SCREEN-VALUE = SELF:SCREEN-VALUE.
  END.
/*   IF SUBSTRING(SELF:SCREEN-VALUE,1,2) = "20" */
/*       THEN ASSIGN                            */
/*       f-ApeMat:SENSITIVE = NO                */
/*       f-ApePat:SENSITIVE = NO                */
/*       f-Nombre:SENSITIVE = YES               */
/*       f-ApeMat:SCREEN-VALUE = ''             */
/*       f-ApePat:SCREEN-VALUE = ''.            */
/*   ELSE ASSIGN                                */
/*       f-ApeMat:SENSITIVE = YES               */
/*       f-ApePat:SENSITIVE = YES               */
/*       f-Nombre:SENSITIVE = YES.              */
  APPLY 'LEAVE':U TO f-ApePat.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodDept
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodDept D-Dialog
ON LEAVE OF F-CodDept IN FRAME D-Dialog /* Departamento */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
     FIND  TabDepto WHERE TabDepto.CodDepto = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE TabDepto THEN
        Fill-in-dep:screen-value = TabDepto.NomDepto.
     ELSE 
        Fill-in-dep:screen-value = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodDist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodDist D-Dialog
ON LEAVE OF F-CodDist IN FRAME D-Dialog /* Distrito */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
     FIND Tabdistr WHERE Tabdistr.CodDepto = F-CodDept:SCREEN-VALUE AND
                       Tabdistr.Codprovi = F-CodProv:SCREEN-VALUE AND
                       Tabdistr.Coddistr = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE Tabdistr THEN 
        Fill-in-dis:screen-value = Tabdistr.Nomdistr .
     ELSE
        Fill-in-dis:screen-value = "".
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodProv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodProv D-Dialog
ON LEAVE OF F-CodProv IN FRAME D-Dialog /* Provincias */
DO:
   IF SELF:SCREEN-VALUE <> "" THEN DO:
      FIND Tabprovi WHERE Tabprovi.CodDepto = F-CodDept:SCREEN-VALUE AND
           Tabprovi.Codprovi = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE Tabprovi THEN 
         fill-in-prov:screen-value = Tabprovi.Nomprovi.
      ELSE
         fill-in-prov:screen-value = "".
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-condvta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-condvta D-Dialog
ON LEAVE OF f-condvta IN FRAME D-Dialog /* Condicion Vta. */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
  /*   
  gn-ConVt.Codig 
  gn-ConVt.Nombr 
  gn-ConVt.TipVta 
  gn-ConVt.TotDias 
  gn-ConVt.Vencmtos
  */   
  FIND gn-ConVt WHERE gn-ConVt.Codig = F-condvta:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ConVt THEN 
        F-descond:screen-value = gn-ConVt.Nombr.
     ELSE
        F-descond:screen-value = "".
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DNICli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DNICli D-Dialog
ON LEAVE OF F-DNICli IN FRAME D-Dialog /* DNI */
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.

    DEF VAR x-Integer AS INT NO-UNDO.
    /* Dígito Verificador */
    ASSIGN 
        x-Integer = INTEGER(SELF:SCREEN-VALUE) NO-ERROR.
    IF ERROR-STATUS:ERROR = YES OR LENGTH(SELF:SCREEN-VALUE) < 8 THEN DO:
        MESSAGE 'Debe tener 8 caracteres numéricos como mínimo' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    /**/
    DEFINE VAR x-valor AS INT.

    x-valor = INT(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF TRUE <> (F-RucCli:SCREEN-VALUE > '') THEN DO:
        /* Solo en caso de no tener un RUC  registrado en SUNAT, es decir, que sea una persona sin negocio */
        IF LENGTH(SELF:SCREEN-VALUE) = 8 
            THEN RADIO-SET-Libre_C01:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'N'.
            ELSE RADIO-SET-Libre_C01:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'E'.
    END.
    APPLY 'VALUE-CHANGED':U TO RADIO-SET-Libre_C01.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-GirCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-GirCli D-Dialog
ON LEAVE OF F-GirCli IN FRAME D-Dialog /* Giro */
DO:
  ASSIGN F-GirCli.
  IF F-GirCli <> "" THEN DO:
  FIND Almtabla WHERE Almtabla.Tabla = "GN" AND 
                      Almtabla.Codigo = F-GirCli NO-LOCK NO-ERROR.
    IF AVAILABLE Almtabla THEN 
        F-giro:screen-value = Almtabla.Nombre.
    ELSE
        F-giro:screen-value = "".
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-Nombre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-Nombre D-Dialog
ON LEAVE OF f-Nombre IN FRAME D-Dialog /* Nombre */
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    f-nomcli:SCREEN-VALUE = TRIM (f-apepat:SCREEN-VALUE) + " " +
        TRIM (f-apemat:SCREEN-VALUE) + ", " +
        f-nombre:SCREEN-VALUE.
    IF f-apepat:SCREEN-VALUE = '' AND f-apemat:SCREEN-VALUE = '' 
    THEN f-nomcli:SCREEN-VALUE = f-nombre:SCREEN-VALUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-NomCli D-Dialog
ON LEAVE OF F-NomCli IN FRAME D-Dialog /* Nombre/Razón Social */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-RucCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-RucCli D-Dialog
ON LEAVE OF F-RucCli IN FRAME D-Dialog /* RUC */
DO:
    DEFINE VAR x-manual AS LOG INIT NO.
    DEFINE VAR x-requiere-validacion-sunat AS LOG.

    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.

    RUN requiere-validar-con-sunat(INPUT 'RUC', OUTPUT x-requiere-validacion-sunat).
    pBajaSunat = NO.
    IF x-requiere-validacion-sunat = YES THEN DO:
        /* Verificamos Información SUNAT */
        RUN gn/datos-sunat-clientes.r (
            INPUT SELF:SCREEN-VALUE,
            OUTPUT pBajaSunat,
            OUTPUT pName,
            OUTPUT pAddress,
            OUTPUT pUbigeo,
            OUTPUT pDateInscription,
            OUTPUT pError ).
        IF pError > '' THEN DO:
            pBajaSunat = NO.
            x-manual = YES.
        END.
    END.
    ELSE x-manual = YES.
    IF x-manual = NO THEN DO:
        DISPLAY 
            pName @ f-Nombre
            pName @ f-NomCli
            pAddress @ f-DirCli
            WITH FRAME {&FRAME-NAME}.
        DISPLAY
            SUBSTRING(pUbigeo,1,2) @  F-CodDept
            SUBSTRING(pUbigeo,3,2) @  F-CodProv
            SUBSTRING(pUbigeo,5,2) @  F-CodDist
            pDateInscription @ f-DateInscription
            WITH FRAME {&FRAME-NAME}.
        IF x-manual = NO THEN DO:
            APPLY 'LEAVE':U TO F-CodDept.
            APPLY 'LEAVE':U TO F-CodProv.
            APPLY 'LEAVE':U TO F-CodDist.
            DISABLE F-CodDept F-CodProv F-CodDist WITH FRAME {&FRAME-NAME}.
        END.
        /* ****************************************************************************************** */
        /* Hay o no hay data de sunat? */
        /* ****************************************************************************************** */
        IF TRUE <> (F-CodDept > '') OR
            TRUE <> (F-CodProv > '') OR
            TRUE <> (F-CodDist > '')
            THEN ENABLE F-CodDept F-CodProv F-CodDist WITH FRAME {&FRAME-NAME}.
        IF TRIM(pAddress) = "-" THEN ENABLE f-DirCli WITH FRAME {&FRAME-NAME}.
        /* ****************************************************************************************** */
        /* ****************************************************************************************** */
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-vende
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-vende D-Dialog
ON LEAVE OF f-vende IN FRAME D-Dialog /* Vendedor */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO:
     FIND gn-ven WHERE gn-ven.CodVen = F-vende:SCREEN-VALUE AND
                       gn-ven.PtoVta = S-CODDIV NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN 
        F-nomven:screen-value = gn-ven.NomVen.
     ELSE
        F-nomven:screen-value = "".
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-Libre_C01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-Libre_C01 D-Dialog
ON VALUE-CHANGED OF RADIO-SET-Libre_C01 IN FRAME D-Dialog
DO:

    RUN habilitar-campos(INPUT SELF:SCREEN-VALUE).
    
    /* Armamos el código del cliente */
/*     CASE TRUE:                                                                                                              */
/*         WHEN f-RucCli:SCREEN-VALUE > '' THEN f-CodCli:SCREEN-VALUE = f-RucCli:SCREEN-VALUE.                                 */
/*         WHEN f-DniCli:SCREEN-VALUE > '' THEN f-CodCli:SCREEN-VALUE = STRING(INTEGER(f-DniCli:SCREEN-VALUE), '99999999999'). */
/*     END CASE.                                                                                                               */
    APPLY 'LEAVE':U TO f-ApePat.
    /*APPLY 'LEAVE':U TO f-RucCli.*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Cliente D-Dialog 
PROCEDURE Crea-Cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON STOP UNDO, RETURN "ADM-ERROR":U ON ERROR UNDO, RETURN "ADM-ERROR":U
   WITH FRAME {&FRAME-NAME}:
   CREATE gn-clie.
   ASSIGN 
       gn-clie.CodCia     = cl-codcia
       gn-clie.CodCli     = F-CodCli 
       gn-clie.NomCli     = F-NomCli 
       gn-clie.DirCli     = F-DirCli 
       gn-clie.Ruc        = F-RucCli 
       gn-clie.DNI        = F-DNICli
       gn-clie.Telfnos[1] = F-Telfnos
       gn-clie.clfCli     = "C" 
       gn-clie.CodDept    = F-CodDept 
       gn-clie.CodProv    = F-CodProv 
       gn-clie.CodDist    = F-CodDist 
       gn-clie.CodPais    = "01" 
       gn-clie.CodVen     = F-vende
       gn-clie.CndVta     = F-CondVta
       gn-clie.Fching     = TODAY 
       gn-clie.usuario    = S-USER-ID 
       gn-clie.TpoCli     = "1"
       gn-clie.CodDiv     = S-CODDIV
       gn-clie.apepat = f-apepat
       gn-clie.apemat = f-apemat
       gn-clie.Nombre = f-nombre
       gn-clie.Rucold = RADIO-SET-Retenedor
       gn-clie.Libre_L01 = RADIO-SET-Percepcion
       gn-clie.Libre_C01 = RADIO-SET-Libre_C01
       gn-clie.GirCli = f-GirCli
       gn-clie.Libre_F01 = f-DateInscription
       NO-ERROR
       .
   IF ERROR-STATUS:ERROR = YES THEN DO:
       RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
       UNDO, RETURN "ADM-ERROR".
   END.

   /* 15/05/2023 */
   ASSIGN
       gn-clie.Transporte[4] = f-Transporte.


    /* RHC 07.03.05 valores de linea de credito por defecto */
    ASSIGN
        gn-clie.FlgSit = 'A'    /* Activo */
        gn-clie.FlagAut = 'A'   /* Autorizado */
        gn-clie.ClfCli = 'C'.   /* Regular / Malo */
        
   S-CODCLI = gn-clie.CodCli.
   RUN lib/logtabla ("gn-clie", STRING(gn-clie.codcia, '999') + '|' +
                            STRING(gn-clie.codcli, 'x(11)'), cEvento).
END.
RETURN 'OK'.

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
  DISPLAY RADIO-SET-Libre_C01 F-RucCli F-DNICli F-CodCli f-ApePat f-ApeMat 
          f-Nombre F-NomCli F-DirCli F-Telfnos f-Transporte RADIO-SET-Retenedor 
          RADIO-SET-Percepcion F-GirCli F-CodDept F-CodProv F-CodDist f-vende 
          f-condvta F-giro FILL-IN-DEP FILL-IN-PROV FILL-IN-DIS f-nomven 
          f-descond f-DateInscription 
      WITH FRAME D-Dialog.
  ENABLE F-DNICli f-ApePat f-ApeMat f-Nombre F-DirCli F-Telfnos f-Transporte 
         RADIO-SET-Retenedor RADIO-SET-Percepcion F-GirCli F-CodDept F-CodProv 
         F-CodDist f-vende Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habilitar-campos D-Dialog 
PROCEDURE habilitar-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pTipoPersona AS CHAR.

DO WITH FRAME {&FRAME-NAME} :
    IF pTipoPersona = "J"
        THEN ASSIGN
        f-ApeMat:SENSITIVE = NO
        f-ApePat:SENSITIVE = NO
        f-Nombre:SENSITIVE = NO
        f-NomCli:SENSITIVE = YES
        /*f-DirCli:SENSITIVE = NO*/
        f-DNICli:SENSITIVE = NO
        f-ApeMat:SCREEN-VALUE = ''
        f-ApePat:SCREEN-VALUE = ''.
    ELSE ASSIGN
        f-DirCli:SENSITIVE = YES
        f-ApeMat:SENSITIVE = YES
        f-ApePat:SENSITIVE = YES
        f-Nombre:SENSITIVE = YES
        f-NomCli:SENSITIVE = NO.

END.

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
  DEFINE VAR x-valor AS INT64.
  DEFINE VAR x-dni AS CHAR.

  ASSIGN 
      x-valor = INT64(TRIM(S-CODCLI))
      NO-ERROR.

  CASE TRUE:
      WHEN LOOKUP(SUBSTRING(S-CODCLI,1,2), '10,15,17,20') > 0 AND
          LENGTH(s-CodCli) = 11 THEN DO:
          F-RucCli = s-CodCli.
          CASE SUBSTRING(S-CODCLI,1,2):
              WHEN "20" THEN RADIO-SET-Libre_C01  = "J".
              WHEN "10" OR WHEN "15" THEN RADIO-SET-Libre_C01  = "N".
              WHEN "17" THEN RADIO-SET-Libre_C01  = "E".
          END CASE.
          F-RucCli = s-CodCli.
      END.
  END CASE.
  F-CodCli = s-CodCli.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN habilitar-campos(INPUT RADIO-SET-Libre_C01).
  APPLY 'LEAVE':U TO F-RucCli IN FRAME {&FRAME-NAME}.
  S-CODCLI = "".
  
  RETURN NO-APPLY.

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
        WHEN "F-CodCli" THEN DO:
            IF output-var-2 <> ? THEN DO:
                F-CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = output-var-2.
                F-NomCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = output-var-3.
            END.
        END.
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
    DO WITH FRAME {&FRAME-NAME}:
       ASSIGN F-CodDept F-CodProv F-CodDist.
       CASE HANDLE-CAMPO:name:
            WHEN "F-GirCli"  THEN ASSIGN input-var-1 = "GN".
            WHEN "F-CodProv" THEN ASSIGN input-var-1 = F-CodDept.
            WHEN "F-CodDist" THEN ASSIGN input-var-1 = F-CodDept
                                         input-var-2 = F-CodProv.
            WHEN "F-CodCli"  THEN ASSIGN input-var-1 = SUBSTRING(F-CodCli:SCREEN-VALUE,1,8).
         /* ASSIGN input-para-1 = ""
                   input-para-2 = ""
                   input-para-3 = "". */
       END CASE.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE requiere-validar-con-sunat D-Dialog 
PROCEDURE requiere-validar-con-sunat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCampo AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pRetVal AS LOG NO-UNDO.

pRetVal = YES.

FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
                            factabla.tabla = 'VALIDAR_SUNAT' AND
                            factabla.codigo = pCampo NO-LOCK NO-ERROR.
IF AVAILABLE factabla THEN pRetVal = factabla.campo-l[1].


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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEsAlfabetico D-Dialog 
FUNCTION getEsAlfabetico RETURNS LOGICAL
  ( INPUT pCaracter AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR x-alfabetico AS CHAR.
    DEFINE VAR x-retval AS LOG INIT NO.

    x-alfabetico = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZabcdefghijklmnñopqrstuvwxyz ".
    IF INDEX(x-alfabetico,pCaracter) > 0 THEN x-retval = YES.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetSoloLetras D-Dialog 
FUNCTION GetSoloLetras RETURNS LOGICAL
  ( INPUT pTexto AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR x-caracter AS CHAR.
    DEFINE VAR x-retval AS LOG INIT YES.
    DEFINE VAR x-sec AS INT.

    VALIDACION:
    REPEAT x-sec = 1 TO LENGTH(pTexto):
        x-caracter = SUBSTRING(pTexto,x-sec,1).
        x-retval = getEsAlfabetico(x-caracter).
        IF x-retval = NO THEN DO:
            LEAVE VALIDACION.
        END.
    END.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

