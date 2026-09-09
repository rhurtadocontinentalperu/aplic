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
         HEIGHT             = 3
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
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-FLG-MES.nroafp.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-PERS.NroDocId.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-FLG-MES.FchIniCont. 
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-FLG-MES.FchFinCont.
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-FLG-MES.Campo-c[4].
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-PERS.telefo.
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-PERS.lmilit.
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-FLG-MES.cnpago.
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-FLG-MES.nrodpt.

        /*Profesion */
        cRange = "T" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-PERS.profesion.


        DISPLAY
            "   Personal: " + PL-FLG-MES.codper @ FI-MENSAJE
            WITH FRAME F-PROCESO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


