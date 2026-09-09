&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : p-bgro_d.p
    Purpose     : Avisa que una O/D esta lista para hacer la G/R

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF VAR s-CodCia AS INT INIT 001 NO-UNDO.
s-CodCia = INTEGER(SESSION:PARAMETER).

DEF TEMP-TABLE T-CMOV LIKE AlmCMov.
DEF TEMP-TABLE T-DMOV LIKE AlmDMov.

DEF VAR s-CodAlm AS CHAR INIT '11' NO-UNDO.
DEF VAR s-TipMov AS CHAR INIT 'I'.
DEF VAR s-Titulo AS CHAR INIT 'CIA. NO IDENTIFICADA' NO-UNDO FORMAT 'x(50)'.

CASE s-CodCia:
    WHEN 001 THEN s-CodAlm = '11'.
    WHEN 003 THEN s-CodAlm = '100'.
END CASE.    
FIND GN-CIAS WHERE GN-CIAS.CodCia = s-CodCia NO-LOCK NO-ERROR.
IF AVAILABLE GN-CIAS THEN s-Titulo = TRIM(GN-CIAS.NomCia) + 
                                    ': INGRESO AL ALMACEN '.

DEFINE BUFFER B-MATG FOR AlmMMatg.
DEFINE BUFFER B-DMOV FOR AlmDMov.

DEFINE QUERY QUERY-1 FOR T-DMOV /*FIELDS (CodMat CodUnd CanDes)*/ ,
                        b-matg /*FIELDS (DesMat TipArt)*/ .

DEFINE BROWSE BROWSE-1 QUERY QUERY-1
    DISPLAY T-DMOV.codmat desmat codund candes WITH 12 DOWN.
DEFINE BUTTON btn-exit LABEL 'Cerrar'.
    
DEF VAR x-Mensaje AS CHAR VIEW-AS EDITOR INNER-CHARS 50 INNER-LINES 5.
DEFINE FRAME f-Mensaje
    SKIP(1)
    x-Mensaje AT 5 BGCOLOR 11 FGCOLOR 0 FONT 1 SKIP(1) 
    BROWSE-1 SKIP(1)
    /*
    "Presione F10 para cerrar esta ventana..." /*FGCOLOR 15*/ SKIP
    */
    btn-exit SKIP(1)
    WITH AT COLUMN 1 ROW 1 NO-LABELS OVERLAY
        TITLE s-Titulo
        WIDTH 100
        VIEW-AS DIALOG-BOX /*BGCOLOR 1*/.

/* loop buscando informacion nueva */
PRINCIPAL:
REPEAT:
    FOR EACH AlmCMov USE-INDEX ALMC04 WHERE codcia = s-codcia
            AND codalm = s-codalm
            AND tipmov = s-tipmov
            AND (codmov = 03 OR codmov = 02)
            AND fchdoc = TODAY
            AND flgest <> 'A'
            NO-LOCK,
            EACH AlmDMov OF AlmCMov NO-LOCK,
            FIRST AlmMMatg OF AlmDMov WHERE almmmatg.tipart = 'A' NO-LOCK:
        FIND T-CMOV OF AlmCMov NO-LOCK NO-ERROR.
        IF NOT AVAILABLE T-CMOV
        THEN DO:
            /* Cargamos detalle */
            RUN Carga-Detalle.
            /* AVISO AL USUARIO */
            ASSIGN
                x-Mensaje = 'INGRESO A ALMACEN ' + s-codalm + ': ' +
                            CAPS(almcmov.tipmov) + ' - ' +
                            STRING(almcmov.codmov, '99') + ' - ' +
                            STRING(almcmov.nroser, '999') + '-' +
                            STRING(almcmov.nrodoc, '999999').
            OPEN QUERY QUERY-1 FOR EACH T-DMOV, FIRST b-matg OF T-DMOV WHERE b-matg.tipart = 'A'.
            DISPLAY x-Mensaje BROWSE-1 WITH FRAME f-Mensaje.
            /*
            READKEY.
            REPEAT WHILE LASTKEY <> KEYCODE("F10"):
                READKEY.
            END.
            */
            ENABLE BROWSE-1 btn-exit WITH FRAME F-Mensaje.
            WAIT-FOR CHOOSE OF btn-exit.
            HIDE FRAME f-Mensaje.
            CREATE T-CMOV.
            RAW-TRANSFER AlmCMov TO T-CMOV.
        END.
    END.
END.
QUIT.

PROCEDURE Carga-Detalle:
/* ******************** */
FOR EACH T-DMOV:
   DELETE T-DMOV.
END.

FOR EACH B-DMOV OF Almcmov NO-LOCK:
   CREATE T-DMOV.
   BUFFER-COPY B-DMOV TO T-DMOV.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


