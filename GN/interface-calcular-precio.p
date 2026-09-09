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

DEFINE VAR x-parametros AS CHAR.    /* Los parametros */

x-parametros = TRIM(SESSION:PARAMETER).

IF TRUE <> (x-parametros > "") THEN DO:
    /* No envio parametros */
    RETURN.
END.

DEFINE VAR x-token AS CHAR.
DEFINE VAR x-tpoped AS CHAR.
DEFINE VAR x-coddiv AS CHAR.
DEFINE VAR x-codcli AS CHAR.
DEFINE VAR x-codmon AS INT.
DEFINE VAR x-codmat AS CHAR.
DEFINE VAR x-fmapgo AS CHAR.
DEFINE VAR x-cant AS DEC.

DEFINE VAR x-nro-dec  AS INT INIT 4.
DEFINE VAR x-prebas AS DEC INIT  0.
DEFINE VAR x-prevta AS DEC INIT 0.
DEFINE VAR f-dsctos AS DEC INIT 0.
DEFINE VAR x-dsctos AS DEC INIT 0.
DEFINE VAR x-undvta AS CHAR INIT "".
DEFINE VAR x-tipdto AS CHAR INIT "".
DEFINE VAR x-flete-unitario AS DEC INIT 0.
DEFINE VAR x-factor AS DEC INIT 1.

/* */
DEFINE NEW GLOBAL SHARED VARIABLE s-task-no  AS INT.
DEFINE NEW GLOBAL SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE NEW GLOBAL SHARED VARIABLE S-CODCIA   AS INTEGER INIT 001.
DEFINE NEW GLOBAL SHARED VARIABLE S-NOMCIA   AS CHAR INIT "CONTINENTAL S.A.C".
DEFINE NEW GLOBAL SHARED VARIABLE S-USER-ID  AS CHAR INIT "ADMIN".
DEFINE NEW GLOBAL SHARED VARIABLE S-CODDIV   AS CHAR INIT "00001".
DEFINE NEW GLOBAL SHARED VARIABLE s-Tabla    AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE s-Rowid    AS ROWID.
DEFINE new global SHARED VARIABLE   CB-CODCIA   AS INTEGER    init 0.
DEFINE new global SHARED VARIABLE   PV-CODCIA   AS INTEGER    init 0.
DEFINE new global SHARED VARIABLE   CL-CODCIA   AS INTEGER    init 0 .

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/*
IF pTipoPedido = 'E' THEN DO:
    CREATE w-report.
    ASSIGN w-report.task-no = pTaskNo
            w-report.llave-C = pClaveAcceso
            w-report.campo-c[1] = pCodMat
            w-report.campo-c[2] = STRING(TODAY,"99/99/9999")
            w-report.campo-c[3] = STRING(TIME,"HH:MM:SS")
    .
END.
*/
/*
DEFINE VARIABLE cOldPropath AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDLCPath AS CHARACTER NO-UNDO.
DEFINE VARIABLE i AS INTEGER NO-UNDO.

/*GET-KEY-VALUE SECTION "Startup":U KEY "DLC":U VALUE cDLCPath.*/
GET-KEY-VALUE SECTION "Startup":U KEY "PROPATH":U VALUE cDLCPath.

/*MESSAGE cDLCPath.*/

cOldPropath = PROPATH.
PROPATH = cDLCPath.

MESSAGE cDLCPath VIEW-AS ALERT-BOX.

ETIME(TRUE).
*/
RUN calcular-precio-evento.

QUIT.

/*MESSAGE ETIME VIEW-AS ALERT-BOX.*/

/*PROPATH = cOldPropath.*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-calcular-precio-evento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcular-precio-evento Procedure 
PROCEDURE calcular-precio-evento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NUM-ENTRIES(x-parametros,",") < 8 THEN DO:
    /* Parametros imcompletos */
    CREATE INTERFACE_pg.
        ASSIGN  INTERFACE_pg.codcia = 1
                INTERFACE_pg.llave_c1 = x-token
                INTERFACE_pg.libre_c10 = "ERROR"
                INTERFACE_pg.libre_c11 = "PARAMETROS INCOMPLETOS"
                INTERFACE_pg.libre_c12 = x-parametros
                INTERFACE_pg.fcrea = TODAY
                INTERFACE_pg.hcrea = STRING(TIME,"HH:MM:SS")
    .
    RETURN.
END.

DEFINE VAR x-codcia AS INT INIT 1.

x-token = TRIM(ENTRY(1,x-parametros,",")).
x-tpoped = TRIM(ENTRY(2,x-parametros,",")).
x-coddiv = TRIM(ENTRY(3,x-parametros,",")).
x-codcli = TRIM(ENTRY(4,x-parametros,",")).
x-codmon = INTEGER(TRIM(ENTRY(5,x-parametros,","))).
x-codmat = TRIM(ENTRY(6,x-parametros,",")).
x-fmapgo = TRIM(ENTRY(7,x-parametros,",")).
x-cant = DEC(TRIM(ENTRY(8,x-parametros,","))).

x-nro-dec = 4.
x-prebas = 0.
x-prevta = 0.
f-dsctos = 0.
x-dsctos = 0.
x-undvta = "".
x-tipdto = "".
x-flete-unitario = 0.
x-factor = 1.

/*precio-de-venta-eventos.r*/
RUN vta2/precio-de-venta-eventos.r(INPUT x-tpoped, INPUT x-coddiv, INPUT x-codcli,
                                   INPUT x-codmon, INPUT-OUTPUT x-undvta, OUTPUT x-factor, 
                                   INPUT x-codmat, INPUT x-fmapgo,
                                   INPUT x-cant, INPUT x-nro-dec, OUTPUT x-prebas,
                                   OUTPUT x-prevta, OUTPUT f-dsctos, OUTPUT x-dsctos,
                                   OUTPUT x-tipdto, INPUT "", 
                                   OUTPUT x-flete-unitario, INPUT NO).

IF RETURN-VALUE = "ADM-ERROR" THEN DO:
    CREATE INTERFACE_pg.
        ASSIGN  INTERFACE_pg.codcia = x-codcia
                INTERFACE_pg.llave_c1 = x-token
                INTERFACE_pg.libre_c01 = x-codmat       /* 2 */
                INTERFACE_pg.libre_f01 = x-prebas       /* 3 */
                INTERFACE_pg.libre_f02 = x-prevta       /* 0 */
                INTERFACE_pg.libre_f03 = f-dsctos       /* 5    z-dsctos */
                INTERFACE_pg.libre_f04 = x-dsctos       /* 6    y-dsctos*/
                INTERFACE_pg.libre_f05 = x-flete-unitario   /* 9 */
                INTERFACE_pg.libre_f06 = x-factor       /* 10 */
                INTERFACE_pg.libre_c02 = x-tipdto       /* 8 */
                INTERFACE_pg.libre_c03 = x-undvta       /* 11 */
                INTERFACE_pg.libre_c10 = "ERROR"
                INTERFACE_pg.libre_c11 = "PRECIO DE VENTA EVENTOS"
                INTERFACE_pg.fcrea = TODAY
                INTERFACE_pg.hcrea = STRING(TIME,"HH:MM:SS")
    .
    RETURN "ADM-ERROR".
END.
    
RUN gn/factor-porcentual-flete-v2(INPUT x-coddiv, 
                                  INPUT x-codmat, 
                                  INPUT-OUTPUT x-Flete-Unitario, 
                                  INPUT x-tpoped, 
                                  INPUT x-factor, 
                                  INPUT x-codmon).

IF RETURN-VALUE = "ADM-ERROR" THEN DO:
    CREATE INTERFACE_pg.
        ASSIGN  INTERFACE_pg.codcia = x-codcia
                INTERFACE_pg.llave_c1 = x-token
                INTERFACE_pg.libre_c01 = x-codmat       /* 2 */
                INTERFACE_pg.libre_f01 = x-prebas       /* 3 */
                INTERFACE_pg.libre_f02 = x-prevta       /* 0 */
                INTERFACE_pg.libre_f03 = f-dsctos       /* 5 */
                INTERFACE_pg.libre_f04 = x-dsctos       /* 6  y-dsctos*/
                INTERFACE_pg.libre_f05 = x-flete-unitario   /* 9 */
                INTERFACE_pg.libre_f06 = x-factor       /* 10 */
                INTERFACE_pg.libre_c02 = x-tipdto       /* 8 */
                INTERFACE_pg.libre_c03 = x-undvta       /* 11 */
                INTERFACE_pg.libre_c10 = "ERROR"
                INTERFACE_pg.libre_c11 = "FACTOR PORCENTUAL FLETE"
                INTERFACE_pg.fcrea = TODAY
                INTERFACE_pg.hcrea = STRING(TIME,"HH:MM:SS")
    .
    RETURN "ADM-ERROR".
END.

/*

        Almmmatg.DesMat @ x-DesMat 
        Almmmatg.DesMar @ x-DesMar 
        s-UndVta @ ITEM.UndVta 
        F-PREVTA @ ITEM.PreUni 
        z-Dsctos @ ITEM.Por_Dsctos[2]
        y-Dsctos @ ITEM.Por_Dsctos[3]


  ASSIGN
      ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                    ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
  IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
      THEN ITEM.ImpDto = 0.
      ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
      
  /* RHC 04/08/2015 Si existe f-FleteUnitario se recalcula el Descuento */
  IF f-FleteUnitario > 0 THEN DO:

      /* Ic - 28Set2018, si el flete debe considerarse, segun Karin Roden.... */
      /*RUN gn/factor-porcentual-flete(INPUT ITEM.codmat, INPUT-OUTPUT f-FleteUnitario, INPUT s-TpoPed, INPUT f-factor, INPUT s-CodMon).*/

      RUN gn/factor-porcentual-flete-v2(INPUT pcoddiv, INPUT ITEM.codmat, INPUT-OUTPUT f-FleteUnitario, INPUT s-TpoPed, INPUT f-factor, INPUT s-CodMon).

      ASSIGN ITEM.Libre_d02 = f-FleteUnitario.

      /*MESSAGE f-FleteUnitario.*/

      /* El flete afecta el monto final */
      IF ITEM.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
          ASSIGN
              ITEM.PreUni = ROUND(ITEM.PreUni + f-FleteUnitario, s-NroDec)  /* Incrementamos el PreUni */
              ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni.
      END.
      ELSE DO:      /* CON descuento promocional o volumen */
          ASSIGN
              ITEM.ImpLin = ITEM.ImpLin + (ITEM.CanPed * f-FleteUnitario)
              ITEM.PreUni = ROUND( (ITEM.ImpLin + ITEM.ImpDto) / ITEM.CanPed, s-NroDec).
      END.
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

*/

DEFINE VAR x-ImpLin AS DEC.
DEFINE VAR x-ImpDto AS DEC INIT 0.

x-ImpLin = ROUND ( x-cant * x-prevta * 
                    ( 1 - f-dsctos / 100 ) *
                    ( 1 - x-dsctos / 100 ), 2 ).
    
IF f-dsctos = 0 AND x-dsctos = 0 THEN DO:
  x-ImpDto = 0.
END.
ELSE DO:
  x-ImpDto = (x-Cant * x-prevta) - x-ImpLin.
END.

/* RHC 04/08/2015 Si existe f-FleteUnitario se recalcula el Descuento */
IF x-flete-unitario > 0 THEN DO:

  /* El flete afecta el monto final */
  IF x-ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
          x-prevta = ROUND(x-prevta + x-Flete-Unitario, x-nro-dec).  /* Incrementamos el PreUni */
          x-ImpLin = x-Cant * x-prevta.
  END.
  ELSE DO:      /* CON descuento promocional o volumen */
          x-ImpLin = x-ImpLin + (x-cant * x-Flete-Unitario).
          x-prevta = ROUND( (x-ImpLin + x-ImpDto) / x-Cant, x-nro-dec).
  END.
END.

/* Grabar la tabla */
CREATE INTERFACE_pg.
    ASSIGN  INTERFACE_pg.codcia = x-codcia
            INTERFACE_pg.llave_c1 = x-token
            INTERFACE_pg.libre_c01 = x-codmat       /* 2 */
            INTERFACE_pg.libre_f01 = x-prebas       /* 3 */
            INTERFACE_pg.libre_f02 = x-prevta       /* 0 */
            INTERFACE_pg.libre_f03 = f-dsctos       /* 5 */
            INTERFACE_pg.libre_f04 = x-dsctos       /* 6  y-dsctos*/
            INTERFACE_pg.libre_f05 = x-flete-unitario   /* 9 */
            INTERFACE_pg.libre_f06 = x-factor       /* 10 */
            INTERFACE_pg.libre_f07 = x-prevta       /* Precio Unitario Final*/
            INTERFACE_pg.libre_f08 = x-implin       /* Importe total de linea */
            INTERFACE_pg.libre_f09 = x-impdto       /* Importe Dsctos */
            INTERFACE_pg.libre_c02 = x-tipdto       /* 8 */
            INTERFACE_pg.libre_c03 = x-undvta       /* 11 */
            INTERFACE_pg.fcrea = TODAY
            INTERFACE_pg.hcrea = STRING(TIME,"HH:MM:SS")
.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

