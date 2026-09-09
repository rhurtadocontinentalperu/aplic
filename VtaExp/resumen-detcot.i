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


    t-Column = t-Column + 3.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = 'TOTAL CANCELADAS'.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = 'SOLES' .
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = 'DOLARES' .
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = 'TOTAL PENDIENTES' .
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = 'SOLES' .
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = 'DOLARES'.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = 'TOTAL ANULADAS' .
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = 'SOLES' .
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = 'DOLARES' .

    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = 'Total Bruto'.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[4] .
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = 'Total Bruto'.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[1].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[2].
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = 'Total Bruto'.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[5].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[6].

    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = 'Descuento'.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[4] .
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = 'Descuento'.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[1].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[2].
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = 'Descuento'.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[5].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[6].

    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = 'Valor de Venta'.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[4] .
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = 'Valor de Venta'.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[1].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[2].
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = 'Valor de Venta'.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[5].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[6].

    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = 'I.G.V'.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[4] .
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = 'I.G.V'.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[1].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[2].
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = 'I.G.V'.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[5].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[6].

    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = 'Precio de Venta'.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[4] .
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = 'Precio de Venta'.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[1].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[2].
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = 'Precio de Venta'.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[5].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[6].

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


