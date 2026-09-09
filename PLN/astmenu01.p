&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{BIN/S-GLOBAL.I}

DEFINE NEW SHARED VARIABLE  S-PERIODO    AS INTEGER FORMAT "9999" INIT 1996.
DEFINE NEW SHARED VARIABLE  s-NroMes     AS INTEGER FORMAT "99".
DEFINE NEW SHARED VARIABLE  s-NroSem     AS INTEGER FORMAT "9999".

DEFINE NEW SHARED VARIABLE  s-CodFam     AS CHAR.
DEFINE NEW SHARED VARIABLE  CB-MaxNivel  AS INTEGER.
DEFINE NEW SHARED VARIABLE  CB-Niveles   AS CHAR.
DEFINE NEW SHARED VARIABLE  xterm as char.

DEFINE VARIABLE P-LIST AS CHAR NO-UNDO.

RUN cbd/cb-m000.r(OUTPUT P-LIST).
IF P-LIST = "" THEN DO:
   MESSAGE "No existen periodos asignados para " skip
            "la empresa" s-codcia VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.
P-LIST = SUBSTRING ( P-LIST , 1, LENGTH(P-LIST) - 1 ).

FIND FacUsers WHERE FacUsers.CodCia = s-codcia AND
    FacUsers.Usuario = s-user-id
    NO-LOCK NO-ERROR.
IF s-user-id <> 'ADMIN' THEN DO:
    IF NOT AVAILABLE FacUsers OR LOOKUP(FacUsers.CodDiv, '00060,00061') = 0 THEN RETURN ERROR.
END.

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
         HEIGHT             = 4.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
  DEF VAR FILL-PERIODO-1 AS INT NO-UNDO.
  DEF VAR f-Mes AS INT NO-UNDO.
  DEF VAR FILL-NroSem AS INT NO-UNDO.

  FILL-PERIODO-1 = ?.
  FILL-PERIODO-1 = INTEGER(ENTRY(LOOKUP(STRING(YEAR(TODAY)),P-LIST) , P-LIST)).
  S-Periodo    = FILL-PERIODO-1.
  IF S-PERIODO = YEAR( TODAY ) THEN S-NROMES = MONTH ( TODAY).
  ELSE DO:
      IF S-PERIODO > YEAR(TODAY) THEN S-NROMES =  1.
      ELSE S-NROMES = 12.
  END.
  F-mes = S-NROMES.
  FIND FIRST CB-PERI WHERE CB-PERI.CodCia  = s-codcia AND
      CB-PERI.Periodo = S-PERIODO NO-LOCK NO-ERROR.
  IF AVAILABLE CB-PERI THEN DO:
      ASSIGN 
          s-NroMes     = CB-PERI.pl-NroMes
          s-NroSem     = CB-PERI.pl-NroSem
          F-Mes  = s-NroMes
          FILL-NroSem  = s-NroSem.
  END.

  ASSIGN
      s-Periodo = YEAR(TODAY)
      s-NroMes = MONTH(TODAY).

  RUN pln/wmarcacion.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


