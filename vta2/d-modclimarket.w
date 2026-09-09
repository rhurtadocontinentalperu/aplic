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
DEFINE INPUT PARAMETER S-CODCLI AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VARIABLE S-CODCIA  AS INT.
DEFINE SHARED VARIABLE CL-CODCIA  AS INT.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.

DEF VAR cEvento AS CHAR INIT "UPDATE" NO-UNDO.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = s-CodCli
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie THEN RETURN ERROR.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK.
IF GN-DIVI.Campo-Log[3] = NO THEN RETURN ERROR.     /* NO autorizado */

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
&Scoped-Define ENABLED-OBJECTS RADIO-SET-Libre_C01 f-ApePat f-ApeMat ~
f-Nombre F-DirCli F-RucCli F-DNICli RADIO-SET-Retenedor ~
RADIO-SET-Percepcion F-GirCli F-CodDept F-CodProv F-CodDist f-vende ~
F-TlfCli Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-CodCli RADIO-SET-Libre_C01 f-ApePat ~
f-ApeMat f-Nombre F-NomCli F-DirCli F-RucCli F-DNICli RADIO-SET-Retenedor ~
RADIO-SET-Percepcion F-GirCli F-CodDept F-CodProv F-CodDist f-vende ~
f-condvta F-giro FILL-IN-DEP FILL-IN-PROV FILL-IN-DIS f-nomven f-descond ~
F-TlfCli 

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
     SIZE 19 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE F-CodDept AS CHARACTER FORMAT "X(2)" 
     LABEL "Departamento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81.

DEFINE VARIABLE F-CodDist AS CHARACTER FORMAT "X(2)" 
     LABEL "Distrito" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81.

DEFINE VARIABLE F-CodProv AS CHARACTER FORMAT "X(2)" 
     LABEL "Provincias" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81.

DEFINE VARIABLE f-condvta AS CHARACTER FORMAT "XXX":U 
     LABEL "Condicion Vta." 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .81 NO-UNDO.

DEFINE VARIABLE f-descond AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-DirCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Direccion" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81 NO-UNDO.

DEFINE VARIABLE F-DNICli AS CHARACTER FORMAT "x(8)" 
     LABEL "DNI" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81.

DEFINE VARIABLE F-GirCli AS CHARACTER FORMAT "X(4)" 
     LABEL "Giro Empr." 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .81.

DEFINE VARIABLE F-giro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28.86 BY .81 NO-UNDO.

DEFINE VARIABLE f-Nombre AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre/Razón Social" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81
     BGCOLOR 11 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE F-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81
     BGCOLOR 15 FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE f-nomven AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-RucCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "RUC" 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-TlfCli AS CHARACTER FORMAT "X(13)":U 
     LABEL "Telefono" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE f-vende AS CHARACTER FORMAT "XXX":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DEP AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DIS AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-PROV AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28.86 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Libre_C01 AS CHARACTER INITIAL "J" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Jurídica", "J",
"Natural", "N"
     SIZE 17 BY .81 NO-UNDO.

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
     F-CodCli AT ROW 1.19 COL 18 COLON-ALIGNED
     RADIO-SET-Libre_C01 AT ROW 2.15 COL 20 NO-LABEL WIDGET-ID 34
     f-ApePat AT ROW 2.96 COL 18 COLON-ALIGNED WIDGET-ID 2
     f-ApeMat AT ROW 3.77 COL 18 COLON-ALIGNED WIDGET-ID 4
     f-Nombre AT ROW 4.58 COL 18 COLON-ALIGNED WIDGET-ID 6
     F-NomCli AT ROW 5.46 COL 18 COLON-ALIGNED
     F-DirCli AT ROW 6.27 COL 18 COLON-ALIGNED
     F-RucCli AT ROW 7.08 COL 18 COLON-ALIGNED
     F-DNICli AT ROW 7.92 COL 18 COLON-ALIGNED HELP
          "DNI DEL (Cliente)"
     RADIO-SET-Retenedor AT ROW 8.81 COL 20 NO-LABEL WIDGET-ID 12
     RADIO-SET-Percepcion AT ROW 9.77 COL 20 NO-LABEL WIDGET-ID 18
     F-GirCli AT ROW 10.73 COL 18 COLON-ALIGNED
     F-CodDept AT ROW 11.5 COL 18 COLON-ALIGNED
     F-CodProv AT ROW 12.31 COL 18 COLON-ALIGNED
     F-CodDist AT ROW 13.12 COL 18 COLON-ALIGNED
     f-vende AT ROW 13.92 COL 18 COLON-ALIGNED
     f-condvta AT ROW 14.73 COL 18 COLON-ALIGNED
     F-giro AT ROW 10.73 COL 24.43 COLON-ALIGNED NO-LABEL
     FILL-IN-DEP AT ROW 11.5 COL 24.43 COLON-ALIGNED NO-LABEL
     FILL-IN-PROV AT ROW 12.31 COL 24.43 COLON-ALIGNED NO-LABEL
     FILL-IN-DIS AT ROW 13.12 COL 24.43 COLON-ALIGNED NO-LABEL
     f-nomven AT ROW 13.92 COL 24.43 COLON-ALIGNED NO-LABEL
     f-descond AT ROW 14.77 COL 24.43 COLON-ALIGNED NO-LABEL
     F-TlfCli AT ROW 7.12 COL 42 COLON-ALIGNED
     Btn_OK AT ROW 1.27 COL 71
     Btn_Cancel AT ROW 2.88 COL 71
     "Agente de Percepción:" VIEW-AS TEXT
          SIZE 16 BY .5 AT ROW 9.85 COL 4 WIDGET-ID 30
     "Agente Retenedor:" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 9 COL 7 WIDGET-ID 16
     "<<< VERIFICAR ESTOS DATOS EN SUNAT <<<" VIEW-AS TEXT
          SIZE 40 BY .5 AT ROW 8.5 COL 33 WIDGET-ID 32
          BGCOLOR 10 FGCOLOR 1 FONT 6
     "Persona:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 2.35 COL 13 WIDGET-ID 38
     SPACE(67.13) SKIP(13.06)
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

/* SETTINGS FOR FILL-IN f-descond IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-giro IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-nomven IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DEP IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DIS IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-PROV IN FRAME D-Dialog
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
       F-TlfCli 
       F-Vende 
       F-CondVta
       f-ApePat
       f-ApeMat
       f-Nombre
       RADIO-SET-Percepcion 
       RADIO-SET-Retenedor.
   IF F-CodCli = "" THEN DO:
      MESSAGE "Codigo de Cliente en blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-CodCli.
      RETURN NO-APPLY.
   END.
   IF LENGTH(TRIM(F-CodCli)) <> 11
   THEN DO:
      MESSAGE "Codigo de Cliente debe ser de 11 digitos" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-CodCli.
      RETURN NO-APPLY.
   END.
   IF F-NomCli = "" THEN DO:
      MESSAGE "Nombre de Cliente en blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-NomCli.
      RETURN NO-APPLY.
   END.
   IF LOOKUP(SUBSTRING(f-CodCli,1,2), '10,15,20,17') > 0 AND f-RucCli = '' THEN DO:
       MESSAGE 'Debe ingresar el RUC del cliente' VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO F-RucCli.
       RETURN NO-APPLY.
   END.

    FIND gn-ven WHERE gn-ven.codcia = s-codcia
        AND gn-ven.CodVen = F-vende NO-LOCK NO-ERROR.
    IF NOT AVAILABLE GN-VEN
    THEN DO:
        MESSAGE 'Codigo del Vendedor no Registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO F-Vende.
        RETURN NO-APPLY.
    END.

    FIND Tabdistr WHERE Tabdistr.CodDepto = F-CodDept 
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
    IF f-RucCli <> '' THEN DO:
        x-Mensaje = ''.
        FOR EACH b-clie NO-LOCK WHERE b-clie.codcia = cl-codcia
            AND b-clie.codcli <> F-CodCli
            AND b-clie.ruc = f-ruccli:
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
    RUN Crea-Cliente.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-ApeMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-ApeMat D-Dialog
ON LEAVE OF f-ApeMat IN FRAME D-Dialog /* Apellido Materno */
DO:
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


&Scoped-define SELF-NAME F-GirCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-GirCli D-Dialog
ON LEAVE OF F-GirCli IN FRAME D-Dialog /* Giro Empr. */
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
ON LEAVE OF f-Nombre IN FRAME D-Dialog /* Nombre/Razón Social */
DO:
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
ON LEAVE OF F-NomCli IN FRAME D-Dialog /* Nombre */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-RucCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-RucCli D-Dialog
ON LEAVE OF F-RucCli IN FRAME D-Dialog /* RUC */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    IF LENGTH(SELF:SCREEN-VALUE) < 11 OR LOOKUP(SUBSTRING(SELF:SCREEN-VALUE,1,2), '10,20,15,17') = 0 THEN DO:
        MESSAGE 'Debe tener 11 dígitos y comenzar con 20, 10, 15 ó 17' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    /* dígito verificador */
    DEF VAR pResultado AS CHAR.
    RUN lib/_ValRuc (SELF:SCREEN-VALUE, OUTPUT pResultado).
    IF pResultado = 'ERROR' THEN DO:
        MESSAGE 'Código MAL registrado' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
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
    IF SELF:SCREEN-VALUE <> "N" 
        THEN ASSIGN
        f-ApeMat:SENSITIVE = NO
        f-ApePat:SENSITIVE = NO
        f-Nombre:SENSITIVE = YES
        f-ApeMat:SCREEN-VALUE = ''
        f-ApePat:SCREEN-VALUE = ''.
    ELSE ASSIGN
        f-ApeMat:SENSITIVE = YES
        f-ApePat:SENSITIVE = YES
        f-Nombre:SENSITIVE = YES.
    APPLY 'LEAVE':U TO f-ApePat.
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
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = F-CodCli
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
        UNDO, RETURN 'ADM-ERROR'.
    END.
    cEvento = "UPDATE".
    ASSIGN 
        gn-clie.NomCli     = F-NomCli 
        gn-clie.DirCli     = F-DirCli 
        gn-clie.Ruc        = F-RucCli 
        gn-clie.DNI        = F-DNICli
        gn-clie.Telfnos[1] = F-TlfCli 
        gn-clie.CodDept    = F-CodDept 
        gn-clie.CodDist    = F-CodDist 
        gn-clie.CodVen     = F-vende
        gn-clie.CndVta     = F-CondVta
        gn-clie.CodProv    = F-CodProv 
        gn-clie.usuario    = S-USER-ID 
        gn-clie.CodDiv     = S-CODDIV
        gn-clie.apepat = f-apepat
        gn-clie.apemat = f-apemat
        gn-clie.Nombre = f-nombre
        gn-clie.Rucold = RADIO-SET-Retenedor
        gn-clie.Libre_L01 = RADIO-SET-Percepcion
        gn-clie.Libre_C01 = RADIO-SET-Libre_C01
        gn-clie.GirCli =  F-GirCli.
   RUN lib/logtabla ("gn-clie", STRING(gn-clie.codcia, '999') + '|' +
                            STRING(gn-clie.codcli, 'x(11)'), cEvento).
END.

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
  DISPLAY F-CodCli RADIO-SET-Libre_C01 f-ApePat f-ApeMat f-Nombre F-NomCli 
          F-DirCli F-RucCli F-DNICli RADIO-SET-Retenedor RADIO-SET-Percepcion 
          F-GirCli F-CodDept F-CodProv F-CodDist f-vende f-condvta F-giro 
          FILL-IN-DEP FILL-IN-PROV FILL-IN-DIS f-nomven f-descond F-TlfCli 
      WITH FRAME D-Dialog.
  ENABLE RADIO-SET-Libre_C01 f-ApePat f-ApeMat f-Nombre F-DirCli F-RucCli 
         F-DNICli RADIO-SET-Retenedor RADIO-SET-Percepcion F-GirCli F-CodDept 
         F-CodProv F-CodDist f-vende F-TlfCli Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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
      DISPLAY S-CODCLI @ F-CodCli.
      FIND gn-clie WHERE gn-clie.codcia = cl-codcia
          AND gn-clie.codcli = s-CodCli
          NO-LOCK NO-ERROR.
      /* En caso haya información en el maestro de clientes */
      IF AVAILABLE gn-clie THEN DO:
          ASSIGN
              f-ApePat:SCREEN-VALUE = gn-clie.apepat
              F-CodCli:SCREEN-VALUE = gn-clie.codcli
              F-CodDept:SCREEN-VALUE = gn-clie.coddept
              F-CodDist:SCREEN-VALUE = gn-clie.coddist
              F-CodProv:SCREEN-VALUE = gn-clie.codprov
              f-condvta:SCREEN-VALUE = gn-clie.CndVta
              F-DirCli:SCREEN-VALUE = gn-clie.dircli
              F-DNICli:SCREEN-VALUE = gn-clie.dni
              F-GirCli:SCREEN-VALUE = gn-clie.gircli
              f-Nombre:SCREEN-VALUE = gn-clie.nombre
              F-NomCli:SCREEN-VALUE = gn-clie.nomcli
              F-RucCli:SCREEN-VALUE = gn-clie.ruc
              F-TlfCli:SCREEN-VALUE = gn-clie.Telfnos[1]
              f-vende:SCREEN-VALUE = gn-clie.codven.
          ASSIGN
              RADIO-SET-Libre_C01:SCREEN-VALUE = gn-clie.libre_c01
              RADIO-SET-Retenedor:SCREEN-VALUE = gn-clie.Rucold
              RADIO-SET-Percepcion:SCREEN-VALUE = (IF gn-clie.Libre_L01 = YES THEN 'Si' ELSE 'No').
          APPLY 'LEAVE':U TO F-GirCli.
          APPLY 'LEAVE':U TO F-CodDept.
          APPLY 'LEAVE':U TO F-CodProv.
          APPLY 'LEAVE':U TO F-CodDist.
          APPLY 'LEAVE':U TO F-Vende.
      END.
      APPLY 'VALUE-CHANGED':U TO RADIO-SET-Libre_C01.
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

