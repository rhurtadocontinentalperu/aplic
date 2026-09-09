&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

lFileXls = lArchivoSalida.              /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */

IF optgrp-donde = 1 THEN DO:
    {lib\excel-open-file.i}

    iColumn = 1.

    cRange = "A1".
    chWorkSheet:Range(cRange):Value = "CODIGO".
    cRange = "B1".
    chWorkSheet:Range(cRange):Value = "NOMBRE/RAZON".
    cRange = "C1".
    chWorkSheet:Range(cRange):Value = "DIRECCION".
    cRange = "D1".
    chWorkSheet:Range(cRange):Value = "DIRECCION ENTREGA".
    cRange = "E1".
    chWorkSheet:Range(cRange):Value = "CONTACTO".
    cRange = "F1".
    chWorkSheet:Range(cRange):Value = "RUC".
    cRange = "G1".
    chWorkSheet:Range(cRange):Value = "FAX".
    cRange = "H1".
    chWorkSheet:Range(cRange):Value = "REFERENCIAS".
    cRange = "I1".
    chWorkSheet:Range(cRange):Value = "GIRO".
    cRange = "J1".
    chWorkSheet:Range(cRange):Value = "VENDEDOR".
    cRange = "K1".
    chWorkSheet:Range(cRange):Value = "COND.VENTA".
    cRange = "L1".
    chWorkSheet:Range(cRange):Value = "TELEFONOS".
    cRange = "M1".
    chWorkSheet:Range(cRange):Value = "DIVISION".
    cRange = "N1".
    chWorkSheet:Range(cRange):Value = "CANAL".
    cRange = "O1".
    chWorkSheet:Range(cRange):Value = "NRO TARJETA".
    cRange = "P1".
    chWorkSheet:Range(cRange):Value = "COD. UNICO".
    cRange = "Q1".
    chWorkSheet:Range(cRange):Value = "D.N.I.".
    cRange = "R1".
    chWorkSheet:Range(cRange):Value = "AP. PATERNO".
    cRange = "S1".
    chWorkSheet:Range(cRange):Value = "AP. MATERNO".
    cRange = "T1".
    chWorkSheet:Range(cRange):Value = "NOMBRES".
    cRange = "U1".
    chWorkSheet:Range(cRange):Value = "CodDepto".
    cRange = "V1".
    chWorkSheet:Range(cRange):Value = "Nombre Depto".
    cRange = "W1".
    chWorkSheet:Range(cRange):Value = "CodProv".
    cRange = "X1".
    chWorkSheet:Range(cRange):Value = "Nombre Provincia".
    cRange = "Y1".
    chWorkSheet:Range(cRange):Value = "CodDistrito".
    cRange = "Z1".
    chWorkSheet:Range(cRange):Value = "Nombre Distrito".
    cRange = "AA1".
    chWorkSheet:Range(cRange):Value = "Clasif. Prod.Propios".
    cRange = "AB1".
    chWorkSheet:Range(cRange):Value = "Clasif. Prod.Terceros".
    cRange = "AC1".
    chWorkSheet:Range(cRange):Value = "Exceptuada Percepcion".
    cRange = "AD1".
    chWorkSheet:Range(cRange):Value = "Agente Retenedor".
    cRange = "AE1".
    chWorkSheet:Range(cRange):Value = "Agente Perceptor".
    cRange = "AF1".
    chWorkSheet:Range(cRange):Value = "Situacion".
    cRange = "AG1".
    chWorkSheet:Range(cRange):Value = "e-Mail".
    cRange = "AH1".
    chWorkSheet:Range(cRange):Value = "e-Mail Fac.Electronica".

    iColumn = 2.
END.
ELSE DO:
    PUT STREAM rpt_file_txt
        "CODIGO|"
        "NOMBRE/RAZON|"
        "DIRECCION|"
        "DIRECCION ENTREGA|"
        "CONTACTO|"
        "RUC|"
        "FAX|"
        "REFERENCIAS|"
        "GIRO|"
        "VENDEDOR|"
        "COND.VENTA|"
        "TELEFONOS|"
        "DIVISION|"
        "CANAL|"
        "NRO TARJETA|"
        "COD. UNICO|"
        "D.N.I.|"
        "AP. PATERNO|"
        "AP. MATERNO|"
        "NOMBRES|"
        "CodDepto|"
        "Nombre Depto|"
        "CodProv|"
        "Nombre Provincia|"
        "CodDistrito|"
        "Nombre Distrito|"
        "Clasif. Prod.Propios|"
        "Clasif. Prod.Terceros|"
        "Exceptuada Percepcion|"
        "Agente Retenedor|"
        "Agente Perceptor|"
        "Situacion|"
        "e-Mail|"
        "e-Mail Fac.Electronica" SKIP.
END.

FOR EACH {&tabla} WHERE {&tabla}.codcia = 0 
    AND ((optgrp-cuales = 3)
    OR (optgrp-cuales = 1 AND {&tabla}.flgsit = 'A')
    OR (optgrp-cuales = 2 AND {&tabla}.flgsit <> 'A'))
    NO-LOCK:

    FIND FIRST vtatabla WHERE vtatabla.codcia = 1 AND vtatabla.tabla = 'CLNOPER' 
                AND vtatabla.llave_c1 = {&tabla}.Ruc NO-LOCK NO-ERROR.

    FIND FIRST TABdepto WHERE TABdepto.coddepto = {&tabla}.coddep NO-LOCK NO-ERROR.
    FIND FIRST TABProvi WHERE TABProvi.coddepto = {&tabla}.coddep 
                        AND TABProvi.codprovi = {&tabla}.codprov NO-LOCK NO-ERROR.
    FIND FIRST TABdistr WHERE TABdistr.coddepto = {&tabla}.coddep 
                        AND TABdistr.codprovi = {&tabla}.codprov 
                        AND coddistr = {&tabla}.coddist  NO-LOCK NO-ERROR.

    IF optgrp-donde = 1 THEN DO:
        cRange = "A" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.CodCli.
        cRange = "B" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.NomCli.
        cRange = "C" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = {&tabla}.DirCli.
        cRange = "D" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = {&tabla}.DirEnt.                                            
        cRange = "E" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = {&tabla}.Contac.
        cRange = "F" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.Ruc.
        cRange = "G" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.FaxCli.                                       
        cRange = "H" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = {&tabla}.Referencias.
        cRange = "I" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.GirCli.
        cRange = "J" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.CodVen.
        cRange = "K" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.CndVta.
        cRange = "L" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.Telfnos[1] + " " + {&tabla}.Telfnos[2] + " " + {&tabla}.Telfnos[3].
        cRange = "M" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.CodDiv.
        cRange = "N" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.Canal.
        cRange = "O" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.NroCard.
        cRange = "P" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.CodUnico.
        cRange = "Q" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.DNI.
        cRange = "R" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = {&tabla}.ApePat.
        cRange = "S" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = {&tabla}.ApeMat.
        cRange = "T" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = {&tabla}.Nombre.

        cRange = "U" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.coddep.
        cRange = "V" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = IF(AVAILABLE tabdepto) THEN tabdepto.nomdepto ELSE "" .
        cRange = "W" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.codprov.
        cRange = "X" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = IF(AVAILABLE tabprovi) THEN tabprovi.nomprovi ELSE "".
        cRange = "Y" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.coddist.
        cRange = "Z" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = IF(AVAILABLE tabdistr) THEN tabdistr.nomdistr ELSE "".
        cRange = "AA" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.clfcli.
        cRange = "AB" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.clfcli2.

        IF AVAILABLE vtatabla THEN DO:
            cRange = "AC" + STRING(iColumn).
            chWorkSheet:Range(cRange):Value = "Si".
            cRange = "AD" + STRING(iColumn).
            chWorkSheet:Range(cRange):Value = "".
            cRange = "AE" + STRING(iColumn).
            chWorkSheet:Range(cRange):Value = "".
        END.
        ELSE DO:
            cRange = "AC" + STRING(iColumn).
            chWorkSheet:Range(cRange):Value = "No".
            cRange = "AD" + STRING(iColumn).
            chWorkSheet:Range(cRange):Value = {&tabla}.rucold.
            cRange = "AE" + STRING(iColumn).
            chWorkSheet:Range(cRange):Value = IF ({&tabla}.libre_l01 = YES) THEN "Si" ELSE "No".
        END.
        cRange = "AF" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = IF ({&tabla}.flgsit = "A") THEN "ACTIVO" ELSE 
                IF ({&tabla}.flgsit = "I") THEN "INACTIVO" ELSE "CESADO".

        cRange = "AG" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = {&tabla}.e-mail.
        cRange = "AH" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = {&tabla}.transporte[4].


        iColumn = iColumn + 1.

    END.
    ELSE DO:
        PUT STREAM rpt_file_txt
            {&tabla}.CodCli "|"
            {&tabla}.NomCli "|"
            {&tabla}.DirCli "|"
            {&tabla}.DirEnt "|"
            {&tabla}.Contac "|"
            {&tabla}.Ruc "|"
            {&tabla}.FaxCli "|"
            {&tabla}.Referencias "|"
            {&tabla}.GirCli "|"
            {&tabla}.CodVen "|"
            {&tabla}.CndVta "|"
            {&tabla}.Telfnos[1] + " " + {&tabla}.Telfnos[2] + " " + {&tabla}.Telfnos[3] "|"
            {&tabla}.CodDiv "|"
            {&tabla}.Canal "|"
            {&tabla}.NroCard "|"
            {&tabla}.CodUnico "|"
            {&tabla}.DNI "|"
            {&tabla}.ApePat "|"
            {&tabla}.ApeMat "|"
            {&tabla}.Nombre "|"
            {&tabla}.coddep "|"
            (IF(AVAILABLE tabdepto) THEN tabdepto.nomdepto ELSE "") "|"
            {&tabla}.codprov "|"
            (IF(AVAILABLE tabprovi) THEN tabprovi.nomprovi ELSE "") "|"
            {&tabla}.coddist "|"
            (IF(AVAILABLE tabdistr) THEN tabdistr.nomdistr  ELSE "") "|"
            {&tabla}.clfcli "|"
            {&tabla}.clfcli2 "|"
            if(AVAILABLE vtatabla) THEN "Si|" ELSE "No|"
            (if(AVAILABLE vtatabla) THEN "" ELSE {&tabla}.rucold) "|"
            (if(AVAILABLE vtatabla) THEN "" ELSE (IF ({&tabla}.libre_l01 = YES) THEN "Si" ELSE "No")) "|"
            IF ({&tabla}.flgsit = "A") THEN "ACTIVO|" ELSE 
                IF ({&tabla}.flgsit = "I") THEN "INACTIVO|" ELSE "CESADO|"
            {&tabla}.e-mail "|"
            {&tabla}.transporte[4] SKIP.
    END.
END.

IF optgrp-donde = 1 THEN DO:
    {lib\excel-close-file.i}
END.
ELSE DO:
          OUTPUT STREAM rpt_file_txt CLOSE.
          MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


