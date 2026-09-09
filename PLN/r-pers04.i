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
         HEIGHT             = 7.15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

        /*Documento*/
        FIND FIRST pl-tabla WHERE pl-tabla.codcia = cl-codcia
            AND pl-tabla.tabla = "03"
            AND pl-tabla.Codigo = pl-pers.tpodocid NO-LOCK NO-ERROR.
        IF AVAIL pl-tabla THEN cTipDoc = pl-tabla.nombre.
        ELSE cTipDoc = "".
        /*Nacionalidad*/
        FIND FIRST pl-tabla WHERE pl-tabla.codcia = cl-codcia
            AND pl-tabla.tabla  = "04"
            AND pl-tabla.Codigo = pl-pers.codnac NO-LOCK NO-ERROR.
        IF AVAIL pl-tabla THEN cNacio = pl-tabla.nombre.
        ELSE cNacio = "".
        /*Distrito*/
        FIND FIRST TabDistr WHERE TabDistr.CodDepto = STRING(SUBSTRING(PL-PERS.Ubigeo,1,2),"99")
            AND TabDistr.CodProvi = STRING(SUBSTRING(PL-PERS.Ubigeo,3,4),"99")
            AND TabDistr.CodDistr = string(SUBSTRING(PL-PERS.Ubigeo,5),"99") NO-LOCK NO-ERROR.
        IF AVAIL TabDistr THEN cDistri = TabDistr.NomDistr.
        ELSE cDistri = "".
        /*Provincia*/
        FIND FIRST TabProvi  WHERE TabProvi.CodDepto = STRING(SUBSTRING(PL-PERS.Ubigeo,1,2),"99")
            AND TabProvi.CodProvi = STRING(SUBSTRING(PL-PERS.Ubigeo,3,4),"99") NO-LOCK NO-ERROR.
        IF AVAIL TabProvi THEN cProvi = TabProvi.NomProvi.
        ELSE cProvi = "".
        /*Departamento*/
        FIND FIRST TabDepto  WHERE TabDepto.CodDepto = STRING(SUBSTRING(PL-PERS.Ubigeo,1,2),"99") NO-LOCK NO-ERROR.
        IF AVAIL TabDepto THEN cDepto = TabDepto.NomDepto.
        ELSE cDepto = "".

        IF pl-pers.sexper = "1" THEN cSexo = "Masculino".
        IF pl-pers.sexper = "2" THEN cSexo = "Femenino".

        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + pl-pers.nrodocid.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = cTipDoc.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.patper.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.matper.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.nomper.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.fecnac.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = "".
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = cSexo.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = cNacio.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.tipovia + " " + pl-pers.dirper.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = cDistri.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = cProvi.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = cDepto.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.telefo.
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.lmilit.


        DISPLAY
            "   Personal: " + PL-FLG-MES.codper @ FI-MENSAJE
            WITH FRAME F-PROCESO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


