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
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR cb-codcia AS INTE.

/* Datos necesarios */
DEF INPUT PARAMETER pCodPer AS CHAR.
DEF INPUT PARAMETER pCodPln AS INTE.
DEF INPUT PARAMETER s-Periodo AS INTE.
DEF INPUT PARAMETER s-nroMes AS INTE.
DEF INPUT PARAMETER f-fecini AS DATE.
DEF INPUT PARAMETER f-fecfin AS DATE.

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR pNomPlantilla AS CHAR.
DEF VAR cNomPlantilla AS CHAR NO-UNDO.
DEF VAR cPlantilla AS CHAR NO-UNDO.
DEF VAR pFolderInput AS CHAR.
DEF VAR pFolderOutput AS CHAR.

FIND TabGener WHERE TabGener.CodCia = s-codcia AND 
    TabGener.Clave = "PLANILLAS" AND
    TabGener.Codigo = "CONTRATO" NO-LOCK NO-ERROR.
IF NOT AVAILABLE TabGener THEN DO:
    pMensaje = "NO están configurados los parámetros para la gerenación de contratos".
    RETURN 'ADM-ERROR'.
END.
pNomPlantilla   = TabGener.Libre_c01.
pFolderInput    = TabGener.Libre_c05.
pFolderOutput   = TabGener.Libre_c04.

/* El pFolderInput debe terminar con un \ o / */
IF SUBSTRING(pFolderInput, LENGTH(pFolderInput),1) <> '\' AND 
    SUBSTRING(pFolderInput, LENGTH(pFolderInput),1) <> '/'
    THEN pFolderInput = TRIM(pFolderInput) + '\'.

cNomPlantilla = pFolderInput + pNomPlantilla.
/* IF s-user-id = 'ADMIN' THEN DO:                                       */
/*     cNomPlantilla = 'D:\newsie\on_in_co\Plantillas\' + pNomPlantilla. */
/* END.                                                                  */

/* Buscamos la plantilla dentro de los programas */
ASSIGN
    cPlantilla = SEARCH(cNomPlantilla).
IF cPlantilla = ? THEN DO:
    pMensaje = 'No se encontró la plantilla ' + cNomPlantilla.
    RETURN 'ADM-ERROR'.
END.

DEF VAR x_codmov AS INTEGER INIT 101.

/* CONSISTENCIAS */
FIND Pl-pers WHERE Pl-Pers.Codper = pCodPer NO-LOCK NO-ERROR.
IF NOT AVAILABLE Pl-pers THEN DO:
    pMensaje = 'Personal no registrado'.
    RETURN 'ADM-ERROR'.
END.

FIND PL-FLG-MES WHERE PL-FLG-MES.CodCia = s-CodCia
    AND PL-FLG-MES.Periodo = s-Periodo
    AND PL-FLG-MES.codpln = pCodPln
    AND PL-FLG-MES.NroMes = s-NroMes
    AND PL-FLG-MES.CodPer = pCodPer
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE PL-FLG-MES THEN DO:
    pMensaje = 'Personal no registra movimientos este mes'.
    RETURN 'ADM-ERROR'.
END.
IF PL-FLG-MES.ccosto = "" THEN DO:
    pMensaje = "Centro de Costo no Registrado".
    RETURN 'ADM-ERROR'.
END.
FIND LAST pl-mov-mes WHERE pl-mov-mes.codcia = s-codcia AND
    pl-mov-mes.codper = pl-pers.codper AND
    pl-mov-mes.Codcal = 00 AND
    pl-mov-mes.CodMov = x_codmov
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE pl-mov-mes THEN DO:
    pMensaje = "Código de Personal " + pl-flg-mes.codper + CHR(10) +
        "no tiene conceptos asignados ....verifique".
    RETURN 'ADM-ERROR'.
END.
FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia
    AND cb-auxi.CLFAUX = "CCO"
    AND cb-auxi.CodAUX = PL-FLG-MES.ccosto
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-auxi THEN
   FIND cb-auxi WHERE cb-auxi.CodCia = s-codcia
    AND cb-auxi.CLFAUX = "CCO"
    AND cb-auxi.CodAUX = PL-FLG-MES.ccosto
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-auxi
    THEN DO:
    pMensaje = "Centro de Costo no Registrado".
    RETURN 'ADM-ERROR'.
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
         HEIGHT             = 4.77
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF VAR x-Anos AS DEC.
DEF VAR x-Meses AS DEC.
DEF VAR x-Dias AS DEC.

RUN pln/p-tserv (f-fecini, f-fecfin + 1, OUTPUT x-Anos, OUTPUT x-Meses, OUTPUT x-Dias).

DEF VAR x_archivo AS CHAR.
DEF VAR x_edad AS INTEGER.
DEF VAR x-enletras AS CHAR.
DEF VAR x_codmon AS INTEGER INIT 1.
DEF VAR x-fecini AS DATE INIT 01/01/2003.
DEF VAR x-fecfin AS DATE INIT 12/31/2003.
DEF VAR x_vigcon AS CHAR .
DEF VAR x_fecini AS CHAR .
DEF VAR x_fecfin AS CHAR .
DEF VAR x_fecemi AS CHAR .
DEF VAR x_sueper AS CHAR .
DEf VAR x_secper AS CHAR .
DEF VAR x-distrito AS CHAR.

DEFINE VAR x-replegal AS CHAR INIT "".
DEFINE VAR x-docreplegal AS CHAR INIT "".

DEF VAR I AS INTEGER.

x-fecini = f-fecini.
x-fecfin = f-fecfin.

DEF VAR x_meses AS CHAR INIT "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre".
DEF VAR x-ubigeo AS CHAR NO-UNDO.
DEF VAR x-tipovia AS CHAR NO-UNDO.
DEF VAR x-cargos AS CHAR FORMAT 'x(50)' NO-UNDO.

DEF VAR Word AS COM-HANDLE.

DO:
    RUN bin/_numero(pl-mov-mes.valcal, 2, 1, OUTPUT X-EnLetras).
    X-EnLetras = X-EnLetras + (IF x_codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").
    x_edad = INTEGER((TODAY - pl-pers.FecNac) / 365).
    x_fecini = STRING(DAY(x-fecini)) + " de " + ENTRY(MONTH(x-fecini),x_meses) + " del " + STRING(YEAR(x-fecini)).
    x_fecfin = STRING(DAY(x-fecfin)) + " de " + ENTRY(MONTH(x-fecfin),x_meses) + " del " + STRING(YEAR(x-fecfin)).
    x_fecemi = STRING(DAY(x-fecini)) + " dias del mes de " + ENTRY(MONTH(x-fecini),x_meses) + " del " + STRING(YEAR(x-fecini)).
    x_vigcon = STRING((ROUND(((x-fecfin - x-fecini) / 30) ,0) + 1) ,"99") + "meses". 
    x_sueper = STRING(Pl-mov-mes.valcal,">>>>9.99") + "(" + x-enletras + ")".
    x_secper = cb-auxi.Nomaux.
    /* RHC 04.08.04 */
    x_VigCon = ''.
    IF x-Anos > 0
        THEN x_VigCon = STRING(x-Anos, '99') + ' año(s) '.
    IF x-Meses > 0
        THEN x_VigCon = x_VigCon + STRING(x-Meses, '99') + ' mes(es) '.
    IF x-Dias > 0
        THEN x_VigCon = x_VigCon + STRING(x-Dias, '99') + ' dia(s) '.

    /* Provincia */
    FIND TabProvi WHERE
        TabProvi.CodDepto = SUBSTRING(PL-PERS.ubigeo,1,2) AND
        TabProvi.CodProvi = SUBSTRING(PL-PERS.ubigeo,3,2)
        NO-LOCK NO-ERROR.
    IF AVAILABLE TabProvi THEN x-ubigeo = TabProvi.NomProvi.    
    /* Tipo Via*/
    FIND FIRST PL-TABLA WHERE
        pl-tabla.codcia = 0 AND
        pl-tabla.tabla = '05' AND
        pl-tabla.codigo = pl-pers.tipovia NO-LOCK NO-ERROR.
    IF AVAIL pl-tabla THEN x-tipovia = PL-TABLA.Nombre.
    ELSE x-tipovia = "".
    /* Distrito */
    FIND TabDistr WHERE
        TabDistr.CodDepto = SUBSTRING(PL-PERS.ubigeo,1,2) AND
        TabDistr.CodProvi = SUBSTRING(PL-PERS.ubigeo,3,2) AND
        TabDistr.CodDistr = SUBSTRING(PL-PERS.ubigeo,5,2) NO-LOCK NO-ERROR.
    IF NOT AVAILABLE TabDistr THEN x-distrito = "".
    ELSE x-distrito = TabDistr.NomDistr.
    /* Cargos */
    x-Cargos = Pl-flg-mes.cargos.
    /* Representante legal */
    ASSIGN
        x-replegal = TabGener.LlaveIni
        x-docreplegal = TabGener.LlaveFin.

    CREATE "Word.Application" Word.
    Word:Documents:OPEN(cPlantilla).
    RUN Remplazo(INPUT "CODPER", INPUT (pl-pers.codper), INPUT 0).
    RUN Remplazo(INPUT "REPLEG", INPUT (x-replegal), INPUT 0).
    RUN Remplazo(INPUT "DOCREP_LEG", INPUT (x-docreplegal), INPUT 0).

    RUN Remplazo(INPUT "NOMPER", INPUT (trim(pl-pers.nomper) + " " + trim(pl-pers.patper) + " " + trim(pl-pers.matper)), INPUT 1).     
    RUN Remplazo(INPUT "DIRPER", INPUT (trim(x-TipoVia) + " " + trim(pl-pers.dirper) + " " + trim(x-distrito) + "-" + trim(x-ubigeo) ), INPUT 0).
    RUN Remplazo(INPUT "DNIPER", INPUT (pl-pers.NroDocId), INPUT 0).
    RUN Remplazo(INPUT "CARPER01", INPUT TRIM(x-Cargos), INPUT 0).
    RUN Remplazo(INPUT "SUEPER" ,INPUT (x_sueper), INPUT 0).
    RUN Remplazo(INPUT "FECINI" ,INPUT (x_fecini), INPUT 0).
    RUN Remplazo(INPUT "FECFIN" ,INPUT (x_fecfin), INPUT 0).
    RUN Remplazo(INPUT "FECEMI" ,INPUT (x_fecemi), INPUT 0).
    RUN Remplazo(INPUT "VIGCON" ,INPUT (x_vigcon), INPUT 0).
    RUN Remplazo(INPUT "SECC" ,INPUT pl-flg-mes.seccion, INPUT 0). 

    /* 11/02/2023 A.Quiroz segundo parrafo configurable */
    IF AVAILABLE TabGener THEN DO:
        RUN Remplazo(INPUT "CONFIGP2a" ,INPUT TabGener.Libre_c02, INPUT 0). 
        RUN Remplazo(INPUT "CONFIGP2b" ,INPUT TabGener.Libre_c03, INPUT 0). 
    END.

    /* Debe terminar en \ */
    IF R-INDEX(pFolderOutput,'\') <> LENGTH(pFolderOutput) THEN pFolderOutput = pFolderOutput + "\".

    x_archivo = pFolderOutput + "contratoCONTI" + pl-pers.codper.
    /*Word:ChangeFileOpenDirectory(pFolderOutput).*/
    Word:ActiveDocument:SaveAs(x_archivo).
    Word:Quit().

    RELEASE OBJECT Word NO-ERROR.

END.
RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Remplazo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Remplazo Procedure 
PROCEDURE Remplazo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER campo AS CHARACTER.
DEFINE INPUT PARAMETER registro AS CHARACTER.
DEFINE INPUT PARAMETER mayuscula AS LOGICAL.
DEFINE VAR cBuffer AS CHARACTER.
/*
Word:Selection:Goto(-1 BY-VARIANT-POINTER,,,campo BY-VARIANT-POINTER).
Word:Selection:Select().
IF mayuscula = TRUE THEN cBuffer = CAPS(registro).
ELSE cBuffer = registro.
Word:Selection:Typetext(cBuffer).
*/

 /*
 Define Input Parameter busca As Char.
 Define Input Parameter cambia As Char.
 */
 Word:Selection:Find:ClearFormatting.
 Word:Selection:Find:Text = campo.
 Word:Selection:Find:Replacement:Text = Registro.
 Word:Selection:Find:Forward = True.
 Word:Selection:Find:Format = False.
 /*Word:Selection:Find:Execute.*/
 Word:Selection:find:Execute(,,,,,,,,,,2).
 /*Word:Selection:TypeText(registro).*/

 /*
 chWordApplication:Selection:find:text = "Old".
 chWordApplication:Selection:find:replacement:text = "New".

chWordApplication:Selection:find:Execute(,,,,,,,,,,2).
   */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

