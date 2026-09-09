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
         HEIGHT             = 4.85
         WIDTH              = 33.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = iInt.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + pl-flg-mes.codper.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-FLG-MES.nroafp.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + PL-PERS.NroDocId.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.patper.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.matper.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.nomper.
        
        IF pl-flg-mes.vcontr <> ? THEN DO:
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = 2.
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = pl-flg-mes.vcontr.
        END.            
        ELSE DO:
            IF (MONTH(pl-flg-mes.FecIng) = iMes
                AND YEAR(pl-flg-mes.FecIng) = YEAR(TODAY)) THEN DO:
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = 1.
                cRange = "I" + cColumn.
                chWorkSheet:Range(cRange):Value = pl-flg-mes.FecIng.
            END.
            ELSE DO:
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = 0.
            END.            
        END.

        FIND FIRST PL-MOV-MES WHERE
            PL-MOV-MES.codcia  = pl-flg-mes.codcia AND
            PL-MOV-MES.periodo = pl-flg-mes.periodo AND
            PL-MOV-MES.nromes  = pl-flg-mes.nromes AND
            PL-MOV-MES.codpln = pl-flg-mes.codpln AND
            PL-MOV-MES.codcal = 001 AND
            PL-MOV-MES.codper = pl-flg-mes.codper AND 
            PL-MOV-MES.codmov = 404 NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-MES THEN DO:
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):Value = PL-MOV-MES.valcal-mes.
        END.

        dMonto = 0.
        FIND FIRST PL-MOV-MES WHERE
            PL-MOV-MES.codcia  = pl-flg-mes.codcia AND
            PL-MOV-MES.periodo = pl-flg-mes.periodo AND
            PL-MOV-MES.nromes  = pl-flg-mes.nromes AND
            PL-MOV-MES.codpln = pl-flg-mes.codpln AND
            PL-MOV-MES.codcal = 008 AND
            PL-MOV-MES.codper = pl-flg-mes.codper AND
            PL-MOV-MES.codmov = 431 NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-MES THEN dMonto = dMonto + PL-MOV-MES.valcal-mes.

        FIND FIRST PL-MOV-MES WHERE
            PL-MOV-MES.codcia  = pl-flg-mes.codcia AND
            PL-MOV-MES.periodo = pl-flg-mes.periodo AND
            PL-MOV-MES.nromes  = pl-flg-mes.nromes AND
            PL-MOV-MES.codpln = pl-flg-mes.codpln AND
            PL-MOV-MES.codcal = 008 AND
            PL-MOV-MES.codper = pl-flg-mes.codper AND
            PL-MOV-MES.codmov = 114 NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-MES THEN dMonto = dMonto + PL-MOV-MES.valcal-mes.

        FIND FIRST PL-MOV-MES WHERE
            PL-MOV-MES.codcia  = pl-flg-mes.codcia AND
            PL-MOV-MES.periodo = pl-flg-mes.periodo AND
            PL-MOV-MES.nromes  = pl-flg-mes.nromes AND
            PL-MOV-MES.codpln = pl-flg-mes.codpln AND
            PL-MOV-MES.codcal = 008 AND
            PL-MOV-MES.codper = pl-flg-mes.codper AND
            PL-MOV-MES.codmov = 611 NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-MES THEN dMonto = dMonto + PL-MOV-MES.valcal-mes.        
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = dMonto.

        dMonto = 0.
        FIND FIRST PL-MOV-MES WHERE
            PL-MOV-MES.codcia  = pl-flg-mes.codcia AND
            PL-MOV-MES.periodo = pl-flg-mes.periodo AND
            PL-MOV-MES.nromes  = pl-flg-mes.nromes AND
            PL-MOV-MES.codpln = pl-flg-mes.codpln AND
            PL-MOV-MES.codcal = 005 AND
            PL-MOV-MES.codper = pl-flg-mes.codper AND
            PL-MOV-MES.codmov = 431 NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-MES THEN dMonto = PL-MOV-MES.valcal-mes.
/*         FIND FIRST PL-MOV-MES WHERE                                           */
/*             PL-MOV-MES.codcia  = pl-flg-mes.codcia AND                        */
/*             PL-MOV-MES.periodo = pl-flg-mes.periodo AND                       */
/*             PL-MOV-MES.nromes  = pl-flg-mes.nromes AND                        */
/*             PL-MOV-MES.codpln = pl-flg-mes.codpln AND                         */
/*             PL-MOV-MES.codcal = 005 AND                                       */
/*             PL-MOV-MES.codper = pl-flg-mes.codper AND                         */
/*             PL-MOV-MES.codmov = 139 NO-LOCK NO-ERROR.                         */
/*         IF AVAILABLE PL-MOV-MES THEN dMonto = dMonto + PL-MOV-MES.valcal-mes. */

        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = dMonto.

        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = 0.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = 0.
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = 0.

        FIND PL-AFPS WHERE PL-AFPS.CodAfp = PL-FLG-MES.CodAfp
            NO-LOCK NO-ERROR.
        IF AVAILABLE PL-AFPS THEN DO:
            cRange = "P" + cColumn.
            chWorkSheet:Range(cRange):Value = STRING(pl-flg-mes.codafp) + ' ' + pl-afps.desafp.
        END.

        DISPLAY
            "   Personal: " + PL-FLG-MES.codper @ FI-MENSAJE
            WITH FRAME F-PROCESO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


