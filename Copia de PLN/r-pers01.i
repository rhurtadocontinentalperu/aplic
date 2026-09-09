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
         HEIGHT             = 5.96
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

        
        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + pl-flg-mes.codper.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.patper.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.matper.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.nomper.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-flg-mes.cargo.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-flg-mes.seccion.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.titulo.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-FLG-MES.fecing.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-FLG-MES.ccosto.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-FLG-MES.vcontr.
        FIND PL-MOV-MES OF PL-FLG-MES WHERE
            PL-MOV-MES.codcal = 0 AND
            PL-MOV-MES.CodMov = 101
            NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-MES THEN DO:
            cRange = "K" + cColumn.
            chWorkSheet:Range(cRange):Value = PL-MOV-MES.valcal-mes.
        END.
        FIND PL-MOV-MES OF PL-FLG-MES WHERE
            PL-MOV-MES.codcal = 0 AND
            PL-MOV-MES.CodMov = 103
            NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-MES THEN DO:
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = PL-MOV-MES.valcal-mes.
        END.
        FIND PL-MOV-MES OF PL-FLG-MES WHERE
            PL-MOV-MES.codcal = 0 AND
            PL-MOV-MES.CodMov = 117
            NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-MES THEN DO:
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = PL-MOV-MES.valcal-mes.
        END.
        FIND PL-MOV-MES OF PL-FLG-MES WHERE
            PL-MOV-MES.codcal = 0 AND
            PL-MOV-MES.CodMov = 020
            NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-MES THEN DO:
            cRange = "N" + cColumn.
            chWorkSheet:Range(cRange):Value = PL-MOV-MES.valcal-mes.
        END.
        FIND PL-MOV-MES OF PL-FLG-MES WHERE
            PL-MOV-MES.codcal = 0 AND
            PL-MOV-MES.CodMov = 134
            NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-MES THEN DO:
            cRange = "O" + cColumn.
            chWorkSheet:Range(cRange):Value = PL-MOV-MES.valcal-mes.
        END.
        FIND PL-MOV-MES OF PL-FLG-MES WHERE
            PL-MOV-MES.codcal = 0 AND
            PL-MOV-MES.CodMov = 146
            NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-MES THEN DO:
            cRange = "P" + cColumn.
            chWorkSheet:Range(cRange):Value = PL-MOV-MES.valcal-mes.
        END.
        FIND PL-MOV-MES OF PL-FLG-MES WHERE
            PL-MOV-MES.codcal = 0 AND
            PL-MOV-MES.CodMov = 111
            NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-MES THEN DO:
            cRange = "Q" + cColumn.
            chWorkSheet:Range(cRange):Value = PL-MOV-MES.valcal-mes.
        END.
        FIND PL-MOV-MES OF PL-FLG-MES WHERE
            PL-MOV-MES.codcal = 0 AND
            PL-MOV-MES.CodMov = 112
            NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-MES THEN DO:
            cRange = "R" + cColumn.
            chWorkSheet:Range(cRange):Value = PL-MOV-MES.valcal-mes.
        END.
        FIND PL-MOV-MES OF PL-FLG-MES WHERE
            PL-MOV-MES.codcal = 0 AND
            PL-MOV-MES.CodMov = 116
            NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-MES THEN DO:
            cRange = "S" + cColumn.
            chWorkSheet:Range(cRange):Value = PL-MOV-MES.valcal-mes.
        END.
        FIND PL-MOV-MES OF PL-FLG-MES WHERE
            PL-MOV-MES.codcal = 0 AND
            PL-MOV-MES.CodMov = 130
            NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-MES THEN DO:
            cRange = "T" + cColumn.
            chWorkSheet:Range(cRange):Value = PL-MOV-MES.valcal-mes.
        END.
        FIND PL-MOV-MES OF PL-FLG-MES WHERE
            PL-MOV-MES.codcal = 0 AND
            PL-MOV-MES.CodMov = 104
            NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-MES THEN DO:
            cRange = "U" + cColumn.
            chWorkSheet:Range(cRange):Value = PL-MOV-MES.valcal-mes.
        END.
        cRange = "V" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-FLG-MES.nroafp.
        cRange = "W" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-PERS.NroDocId.
        cRange = "X" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-FLG-MES.FchIniCont. 
        cRange = "Y" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-FLG-MES.FchFinCont.
        cRange = "Z" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-FLG-MES.Campo-c[4].
        cRange = "AA" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-PERS.telefo.
        cRange = "AB" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-PERS.lmilit.
        cRange = "AC" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-FLG-MES.cnpago.
        cRange = "AD" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-FLG-MES.nrodpt.

        /*Profesion */
        cRange = "AE" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-PERS.profesion.
        cRange = "AF" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-PERS.sexper.
        cRange = "AG" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-PERS.fecnac.

        /* Domicilio */
        FIND PL-TABLA WHERE pl-tabla.codcia = 0 
            AND pl-tabla.tabla = '05' 
            AND pl-tabla.codigo = PL-PERS.TipoVia
            NO-LOCK NO-ERROR.
        cRange = "AH" + cColumn.
        IF AVAILABLE pl-tabla THEN
            chWorkSheet:Range(cRange):Value = TRIM(pl-tabla.nombre) + ' ' + PL-PERS.dirper.
        ELSE chWorkSheet:Range(cRange):Value = PL-PERS.dirper.
        cRange = "AI" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-PERS.distri.
        cRange = "AJ" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-PERS.dirnumero.
        cRange = "AK" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-PERS.dirinterior.
        /* EPS */
        FIND pl-tabla WHERE
            pl-tabla.codcia = 0 AND
            pl-tabla.tabla = '14' AND
            pl-tabla.codigo = PL-FLG-MES.CodEPS NO-LOCK NO-ERROR.
        IF AVAILABLE pl-tabla THEN DO:
            cRange = "AL" + cColumn.
            chWorkSheet:Range(cRange):Value = PL-TABLA.Nombre.
        END.
        cRange = "AM" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-FLG-MES.CodDiv.
        FIND gn-divi WHERE gn-divi.codcia = s-codcia
            AND gn-divi.coddiv = PL-FLG-MES.CodDiv
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-divi THEN chWorkSheet:Range(cRange):Value = GN-DIVI.DesDiv.
        cRange = "AN" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-FLG-MES.Clase.
        cRange = "AO" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-FLG-MES.CTS.
        cRange = "AP" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-FLG-MES.NroDpt-CTS.
        /* Medidas */
        iColUniforme = 81.
        FOR EACH pl-tabla NO-LOCK WHERE pl-tabla.codcia = 0 AND pl-tabla.tabla = "UNIF":
            FIND PL-Pers-Unif OF PL-PERS WHERE PL-Pers-Unif.Codcia = s-codcia 
                AND PL-Pers-Unif.CodUnif = PL-TABLA.Codigo NO-LOCK NO-ERROR.
            IF AVAILABLE pl-pers-unif THEN DO:
                cRange = "A" + CHR(iColUniforme) + cColumn.
                chWorkSheet:Range(cRange):Value = PL-Pers-Unif.TallaUnif.
            END.
            iColUniforme = iColUniforme + 1.
        END.
/*         FOR EACH PL-Pers-Unif OF PL-PERS                                */
/*             WHERE PL-Pers-Unif.Codcia = s-codcia NO-LOCK,               */
/*             FIRST PL-TABLA WHERE PL-TABLA.Codigo = PL-Pers-Unif.CodUnif */
/*             AND PL-TABLA.CodCia = 0                                     */
/*             AND PL-TABLA.Tabla = "UNIF" NO-LOCK:                        */
/*             cRange = "A" + CHR(iColUniforme) + cColumn.                 */
/*             chWorkSheet:Range(cRange):Value = PL-TABLA.Nombre.          */
/*             iColUniforme = iColUniforme + 1.                            */
/*             cRange = "A" + CHR(iColUniforme) + cColumn.                 */
/*             chWorkSheet:Range(cRange):Value = PL-Pers-Unif.TallaUnif.   */
/*             iColUniforme = iColUniforme + 1.                            */
/*         END.                                                            */


        DISPLAY
            "   Personal: " + PL-FLG-MES.codper @ FI-MENSAJE
            WITH FRAME F-PROCESO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


