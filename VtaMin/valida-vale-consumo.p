&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Validar el Ticket y determinar el proveedor

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER x-CodBarra AS CHAR.
DEF OUTPUT PARAMETER pProveedor AS CHAR.
DEF OUTPUT PARAMETER pProducto AS CHAR.
DEF OUTPUT PARAMETER pFchVto AS DATE.
DEF OUTPUT PARAMETER pNroTck AS CHAR.
DEF OUTPUT PARAMETER pValor AS DEC.
DEF OUTPUT PARAMETER pEncarte AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR.

DEF SHARED VAR s-codcia AS INT.

ASSIGN
    pProveedor = ''
    pMensaje = 'ADM-ERROR'.

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
         HEIGHT             = 3.62
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Barremos el control de vales de consumo, solo los activos */
DEF VAR x-Producto AS CHAR NO-UNDO.
DEF VAR x-Digito AS INT NO-UNDO.
DEF VAR x-Valor AS DEC NO-UNDO.
DEF VAR x-Ano AS CHAR NO-UNDO.
DEF VAR x-Mes AS CHAR NO-UNDO.
DEF VAR x-Dia AS CHAR NO-UNDO.
DEF VAR x-FchVto AS DATE FORMAT '99/99/9999' NO-UNDO.

FOR EACH Vtactickets NO-LOCK WHERE Vtactickets.codcia = s-codcia
    AND TODAY >= VtaCTickets.FchIni
    AND TODAY <= VtaCTickets.FchFin:
    /* 1ro la longitud del codigo de barra */
    IF LENGTH(x-CodBarra) <> VtaCTickets.Longitud THEN NEXT.
    /* 2do Verificamos que coincida el producto */
    x-Producto = SUBSTRING(x-CodBarra, INTEGER(SUBSTRING(VtaCTickets.Pos_Producto,1,2)), INTEGER(SUBSTRING(VtaCTickets.Pos_Producto,3,2))).
    IF VtaCTickets.Producto <> x-Producto THEN NEXT.
    /* 3ro digito verificador si fuera el caso */
    IF VtaCTickets.Pos_Verif1 <> '9999' AND VtaCTickets.Prog_Verif1 <> '' THEN DO:
        RUN VALUE (VtaCTickets.Prog_Verif1) (x-CodBarra, OUTPUT x-Digito).
        IF x-Digito = -1 THEN NEXT.
        IF INTEGER ( SUBSTRING(x-CodBarra, INTEGER(SUBSTRING(VtaCTickets.Pos_Verif1,1,2)), INTEGER(SUBSTRING(VtaCTickets.Pos_Verif1,3,2))) ) <> x-Digito 
            THEN NEXT.
    END.
    /* 4to importe */
    ASSIGN
        x-Valor = DECIMAL (SUBSTRING(x-CodBarra, INTEGER(SUBSTRING(VtaCTickets.Pos_Valor,1,2)), INTEGER(SUBSTRING(VtaCTickets.Pos_Valor,3,2))) ) / 100
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN NEXT.
    IF x-Valor <= 0 THEN NEXT.
    /* 5to fecha de vencimiento */
    IF VtaCTickets.Pos_DayVcto <> '9999' AND VtaCTickets.Pos_MonthVcto <> '9999' AND VtaCTickets.Pos_YearVcto <> '9999' 
        THEN DO:
        ASSIGN
            x-Dia = SUBSTRING(x-CodBarra, INTEGER(SUBSTRING(VtaCTickets.Pos_DayVcto,1,2)), INTEGER(SUBSTRING(VtaCTickets.Pos_DayVcto,3,2)))
            x-Mes = SUBSTRING(x-CodBarra, INTEGER(SUBSTRING(VtaCTickets.Pos_MonthVcto,1,2)), INTEGER(SUBSTRING(VtaCTickets.Pos_MonthVcto,3,2)))
            x-Ano = SUBSTRING(x-CodBarra, INTEGER(SUBSTRING(VtaCTickets.Pos_YearVcto,1,2)), INTEGER(SUBSTRING(VtaCTickets.Pos_YearVcto,3,2)))
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN NEXT.
        IF LENGTH(x-Ano) = 2 THEN x-Ano = '20' + x-Ano.
        ASSIGN
            x-FchVto = DATE (INTEGER(x-Mes), INTEGER(x-Dia), INTEGER(x-Ano))
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN NEXT.
        IF TODAY > x-FchVto THEN NEXT.
    END.
    /* TODO BIEN, TICKET VALIDO */
    ASSIGN
        pProveedor = VtaCTickets.CodPro
        pProducto = VtaCTickets.Producto
        pFchVto = x-FchVto
        pNroTck = SUBSTRING(x-CodBarra, INTEGER(SUBSTRING(VtaCTickets.Pos_NroTck,1,2)), INTEGER(SUBSTRING(VtaCTickets.Pos_NroTck,3,2)))
        pValor = x-Valor
        pEncarte =  VtaCTickets.Libre_c01
        pMensaje = 'OK'.
    LEAVE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


