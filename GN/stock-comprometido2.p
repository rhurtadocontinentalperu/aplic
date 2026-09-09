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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF OUTPUT PARAMETER pComprometido AS DEC.

/* CALCULO DEL STOCK COMPROMETIDO */
DEF SHARED VAR s-codcia AS INT.

FOR EACH FacDPedi WHERE FacDPedi.CodCia = s-codcia 
                   AND  FacDPedi.almdes = pcodalm
                   AND  FacDPedi.codmat = pcodmat 
                   AND  LOOKUP(FacDPedi.CodDoc,'PED') > 0 
                   AND  LOOKUP(FacDPedi.FlgEst, 'P,X,') > 0:
    FIND FIRST FacCPedi OF FacDPedi WHERE FacCPedi.codcia = FacDPedi.CodCia
                                     AND  FacCPedi.CodAlm = FacDPedi.almdes
                                     AND  Faccpedi.FlgEst = "P"
                                     AND  Faccpedi.TpoPed = "1"
                                    NO-LOCK NO-ERROR.
    IF NOT AVAIL Faccpedi THEN NEXT.
    pcomprometido = pcomprometido + FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).

END.

/*********   Barremos las O/D que son parciales y totales    ****************/
FOR EACH FacDPedi WHERE FacDPedi.CodCia = s-codcia
                   AND  FacDPedi.almdes = pcodalm
                   AND  FacDPedi.codmat = pcodmat 
                   AND  LOOKUP(FacDPedi.CodDoc,'O/D') > 0 
                   AND  LOOKUP(FacDPedi.FlgEst, 'P,X,') > 0:
    FIND FIRST FacCPedi OF FacDPedi WHERE FacCPedi.codcia = FacDPedi.CodCia
                                     AND  FacCPedi.CodAlm = pcodalm 
                                     AND  Faccpedi.FlgEst = "P"
                                    NO-LOCK NO-ERROR.
    IF NOT AVAIL FacCPedi THEN NEXT.
    pcomprometido = pcomprometido + FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).    
END.

/*******************************************************/

/* Segundo barremos los pedidos de mostrador de acuerdo a la vigencia */
DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.
FIND FacCfgGn WHERE faccfggn.codcia = s-codcia NO-LOCK.
TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
          (FacCfgGn.Hora-Res * 3600) + 
          (FacCfgGn.Minu-Res * 60).
FOR EACH Facdpedm WHERE Facdpedm.CodCia = s-codcia 
                   AND  Facdpedm.AlmDes = pcodalm
                   AND  Facdpedm.codmat = pcodmat 
                   AND  Facdpedm.FlgEst = "P" :
    FIND FIRST Faccpedm OF Facdpedm WHERE Faccpedm.CodCia = Facdpedm.CodCia 
                                     AND  Faccpedm.CodAlm = pcodalm 
                                     AND  Faccpedm.FlgEst = "P"  
                                    NO-LOCK NO-ERROR. 
    IF NOT AVAIL Faccpedm THEN NEXT.
    
    TimeNow = (TODAY - FacCPedm.FchPed) * 24 * 3600.
    TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(FacCPedm.Hora, 1, 2)) * 3600) +
              (INTEGER(SUBSTRING(FacCPedm.Hora, 4, 2)) * 60) ).
    IF TimeOut > 0 THEN DO:
        IF TimeNow <= TimeOut   /* Dentro de la valides */
        THEN DO:
            /* cantidad en reservacion */
            pcomprometido = pcomprometido + FacDPedm.Factor * FacDPedm.CanPed.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


