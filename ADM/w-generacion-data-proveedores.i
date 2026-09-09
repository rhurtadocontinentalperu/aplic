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

DEFINE VAR lSitua AS CHAR.

lFileXls = lArchivoSalida.              /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */

IF optgrp-donde = 1 THEN DO:
    {lib\excel-open-file.i}
    iColumn = 1.

    cRange = "A1".
    chWorkSheet:Range(cRange):Value = "CODIGO".
    cRange = "B1".
    chWorkSheet:Range(cRange):Value = "NOMBRES / RAZON SOC.".
    cRange = "C1".
    chWorkSheet:Range(cRange):Value = "DIRECCION".
    cRange = "D1".
    chWorkSheet:Range(cRange):Value = "R.U.C.".
    cRange = "E1".
    chWorkSheet:Range(cRange):Value = "TIPO PROV".
    cRange = "F1".
    chWorkSheet:Range(cRange):Value = "FAX".
    cRange = "G1".
    chWorkSheet:Range(cRange):Value = "REFERENCIAS".
    cRange = "H1".
    chWorkSheet:Range(cRange):Value = "GIRO".
    cRange = "I1".
    chWorkSheet:Range(cRange):Value = "COND.COMPRA".
    cRange = "J1".
    chWorkSheet:Range(cRange):Value = "CONTACTOS".
    cRange = "K1".
    chWorkSheet:Range(cRange):Value = "REP. LEGAL".
    cRange = "L1".
    chWorkSheet:Range(cRange):Value = "TELEFONOS".
    cRange = "M1".
    chWorkSheet:Range(cRange):Value = "E-MAIL".
    cRange = "N1".
    chWorkSheet:Range(cRange):Value = "TIEMPO ENTRGA".
    cRange = "O1".
    chWorkSheet:Range(cRange):Value = "LOCAL".
    cRange = "P1".
    chWorkSheet:Range(cRange):Value = "CLASIFIC.".
    cRange = "Q1".
    chWorkSheet:Range(cRange):Value = "FECHA CREAC.".
    cRange = "R1".
    chWorkSheet:Range(cRange):Value = "AP. PATERNO".
    cRange = "S1".
    chWorkSheet:Range(cRange):Value = "AP. MATERNO".
    cRange = "T1".
    chWorkSheet:Range(cRange):Value = "NOMBRES".
    cRange = "U1".
    chWorkSheet:Range(cRange):Value = "Buen Contribuyente".
    cRange = "V1".
    chWorkSheet:Range(cRange):Value = "Agente Retenedor".
    cRange = "W1".
    chWorkSheet:Range(cRange):Value = "Agente Retenedor".
    cRange = "X1".
    chWorkSheet:Range(cRange):Value = "Situacion".
    
    iColumn = 2.
END.
ELSE DO:
          OUTPUT STREAM rpt_file_txt TO VALUE(lArchivoSalida).
          PUT STREAM rpt_file_txt
          "CODIGO|"
          "NOMBRES / RAZON SOC.|"
          "DIRECCION|"
          "R.U.C.|"
          "TIPO PROV|"
          "FAX|"
          "REFERENCIAS|"
          "GIRO|"
          "COND.COMPRA|"
          "CONTACTOS|"
          "REP. LEGAL|"
          "TELEFONOS|"
          "E-MAIL|"
          "TIEMPO ENTRGA|"
          "LOCAL|"
          "CLASIFIC.|"
          "FECHA CREAC.|"
          "AP. PATERNO|"
          "AP. MATERNO|"
          "NOMBRES|"
          "Buen Contribuyente|"
          "Agente Retenedor|"
          "Agente Retenedor|" SKIP.
END.

FOR EACH {&tabla} WHERE {&tabla}.codcia = 0 
    AND ((optgrp-cuales = 3)
    OR (optgrp-cuales = 1 AND {&tabla}.flgsit = 'A')
    OR (optgrp-cuales = 2 AND {&tabla}.flgsit <> 'A'))
    NO-LOCK:
    
    /*FILL-IN-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = {&tabla}.CodPro.*/
    
    IF optgrp-donde = 1 THEN DO:
        cRange = "A" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.CodPro.
        cRange = "B" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.NomPro.
        cRange = "C" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = {&tabla}.DirPro.
        cRange = "D" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.Ruc.                                            
        cRange = "E" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.TpoPro.
        cRange = "F" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.FaxPro.
        cRange = "G" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.Referencias.                                       
        cRange = "H" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.Girpro.
        cRange = "I" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.CndCmp.
        cRange = "J" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.Contactos[1] + " " + {&tabla}.Contactos[2] + " " + {&tabla}.Contactos[3].
        cRange = "K" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.RepLegal.
        cRange = "L" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.Telfnos[1] + " " + {&tabla}.Telfnos[2] + " " + {&tabla}.Telfnos[3].
        cRange = "M" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.E-Mail.
        cRange = "N" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + string({&tabla}.TpoEnt).
        cRange = "O" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.LocPro.
        cRange = "P" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = "'" + {&tabla}.clfpro.
        cRange = "Q" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = {&tabla}.Fching NO-ERROR.
        cRange = "R" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = {&tabla}.ApePat.
        cRange = "S" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = {&tabla}.ApeMat.
        cRange = "T" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = {&tabla}.Nombre.
        cRange = "U" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = {&tabla}.libre_c02.
        cRange = "V" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = {&tabla}.libre_c01.
        cRange = "W" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = {&tabla}.libre_c03.
        cRange = "X" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = IF({&tabla}.flgsit = 'C') THEN 'CESADO' ELSE 'ACTIVO'.

        iColumn = iColumn + 1.
    END.
    
    ELSE DO:
        PUT STREAM rpt_file_txt
            {&tabla}.CodPro "|"
            (REPLACE({&tabla}.NomPro, '|'," ")) "|"
            (REPLACE({&tabla}.DirPro, '|'," ")) "|"
            {&tabla}.Ruc "|"
            {&tabla}.TpoPro "|"
            {&tabla}.FaxPro "|"
            (REPLACE({&tabla}.Referencias, '|'," ")) "|"
            {&tabla}.Girpro "|"
            {&tabla}.CndCmp "|"
            (REPLACE({&tabla}.Contactos[1], '|'," ") + " " + REPLACE({&tabla}.Contactos[2], '|'," ") + " " + REPLACE({&tabla}.Contactos[3], '|'," ")) "|"
            (REPLACE({&tabla}.RepLegal, '|'," ")) "|"
            (REPLACE({&tabla}.Telfnos[1], '|'," ") + " " + REPLACE({&tabla}.Telfnos[2], '|'," ") + " " + REPLACE({&tabla}.Telfnos[3], '|'," ")) "|"
            (REPLACE({&tabla}.E-Mail, '|'," ")) "|"
            {&tabla}.TpoEnt "|"
            (REPLACE({&tabla}.LocPro, '|'," ")) "|"
            {&tabla}.clfpro "|"
            {&tabla}.Fching "|"
            (REPLACE({&tabla}.ApePat, '|'," ")) "|"
            (REPLACE({&tabla}.ApeMat, '|'," ")) "|"
            (REPLACE({&tabla}.Nombre, '|'," ")) "|"
            {&tabla}.libre_c02 "|"
            {&tabla}.libre_c01 "|"
            {&tabla}.libre_c03 "|" 
            (IF({&tabla}.flgsit = 'C') THEN 'CESADO' ELSE 'ACTIVO') SKIP.
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


