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

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tempo.codper.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.nomper.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[1].
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[2].
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[3].
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[5].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[6].
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[7].
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[8].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[9].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[10].
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[11].
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[12].
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[13].
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[14].
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[16].
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[17].
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[18].
    cRange = "U" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[15].
    /*Liquidaciones*/
    cRange = "V" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[21].
    cRange = "W" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[22].
    cRange = "X" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[23].
    cRange = "Y" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[24].
    cRange = "Z" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[25].
    cRange = "AA" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[26].
    cRange = "AB" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[27].
    cRange = "AC" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[28].
    cRange = "AD" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[29].
    cRange = "AE" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[30].
    cRange = "AF" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[31].
    cRange = "AG" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[32].
    cRange = "AH" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[33].
    cRange = "AI" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[34].
    cRange = "AJ" + cColumn.
    chWorkSheet:Range(cRange):Value = tempo.ValCal[35].

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


