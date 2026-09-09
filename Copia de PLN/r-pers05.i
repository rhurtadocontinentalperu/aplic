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


        FIND FIRST pl-tabla WHERE pl-tabla.codcia = cl-codcia
            AND pl-tabla.tabla = "10"
            AND pl-tabla.Codigo = pl-flg-mes.ocupacion NO-LOCK NO-ERROR.
        IF AVAIL pl-tabla THEN cOcupa = pl-tabla.nombre.
        ELSE cOcupa = "".

        FIND FIRST pl-tabla WHERE pl-tabla.codcia = cl-codcia
            AND pl-tabla.tabla = "12"
            AND pl-tabla.Codigo = pl-flg-mes.tpocontra NO-LOCK NO-ERROR.
        IF AVAIL pl-tabla THEN cTipCon = pl-tabla.nombre.
        ELSE cTipCon = "".

        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + pl-pers.codper.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.patper. 
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.matper. 
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.nomper.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-flg-mes.fecing.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = cTipCon.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = PL-FLG-MES.Seccion.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = cOcupa.

        DISPLAY
            "   Personal: " + PL-FLG-MES.codper @ x-mensaje
            WITH FRAME {&FRAME-NAME}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


