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
         HEIGHT             = 4.23
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* VER TAMBIEN alm/c-ingentransito.w */

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF OUTPUT PARAMETER pComprometido AS DEC.

DEF SHARED VAR s-codcia AS INT.

DEF TEMP-TABLE t-cocmp
    FIELD nrodoc LIKE lg-cocmp.nrodoc
    FIELD codcia LIKE lg-cocmp.codcia
    FIELD coddiv LIKE lg-cocmp.coddiv
    FIELD tpodoc LIKE lg-cocmp.tpodoc
    INDEX Llave00 AS PRIMARY UNIQUE codcia tpodoc coddiv nrodoc.
DEF TEMP-TABLE t-docmp
    FIELD codcia LIKE lg-docmp.codcia
    FIELD nrodoc LIKE lg-docmp.nrodoc
    FIELD codmat LIKE lg-docmp.codmat
    FIELD canpedi LIKE lg-docmp.canpedi
    FIELD canaten LIKE lg-docmp.canaten.

FOR EACH lg-docmp NO-LOCK WHERE lg-docmp.codcia = s-codcia
    AND lg-docmp.codmat = pCodMat
    AND lg-docmp.canpedi > lg-docmp.canaten
    AND lg-docmp.canaten >= 0,
    FIRST lg-cocmp WHERE LG-COCmp.CodCia = lg-docmp.codcia
    AND LG-COCmp.CodDiv = lg-docmp.coddiv
    AND LG-COCmp.TpoDoc = lg-docmp.tpodoc
    AND LG-COCmp.NroDoc = lg-docmp.nrodoc
    AND lg-cocmp.flgsit = 'P'
    AND LG-COCmp.CodAlm = pCodAlm:
    pComprometido = pComprometido + (lg-docmp.canpedi - lg-docmp.canaten).
END.

/* DEFINIMOS TEMPORALES DE TRABAJO PORQUE NO SE PUDE HACER DIRECTAMENTE CON LA BASE 
   ESTO SOLO PASA CON LA TABLA LG-COCMP */

/* Cargamos las cabeceras */
/*RUN Carga-Temporal.*/
/* Calculamos cantidad en tránsito */
/* FOR EACH lg-docmp OF t-cocmp NO-LOCK WHERE lg-docmp.codmat = pCodMat       */
/*     AND lg-docmp.canpedi > lg-docmp.canaten                                */
/*     AND lg-docmp.canaten >= 0:                                             */
/*     pComprometido = pComprometido + (lg-docmp.canpedi - lg-docmp.canaten). */
/* END.                                                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Carga-Temporal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal Procedure 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH lg-cocmp NO-LOCK WHERE lg-cocmp.codcia = s-codcia
    AND lg-cocmp.flgsit = 'P'
    AND LG-COCmp.CodAlm = pCodAlm:
    CREATE t-cocmp.
    BUFFER-COPY lg-cocmp TO t-cocmp.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

