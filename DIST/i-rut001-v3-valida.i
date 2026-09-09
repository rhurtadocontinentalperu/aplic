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
/* Programas dist/v-rut001-v3.w y dist/v-rut001-v31.w 
*/

DEFINE VAR lFechaIng AS DATE.
DEFINE VAR lFechaSal AS DATE.

DO WITH FRAME {&FRAME-NAME}:
    /* 08 Jul 2013 - Ic */
    ASSIGN txtHora txtMinuto.
    ASSIGN txtCodPro txtDTrans txtSerie txtNro.
    IF INPUT di-rutaC.libre_l01 = YES THEN DO:
      IF txtHora < 0 OR txtHora > 23 THEN DO:
          MESSAGE 'Hora Incorrecta..(00..23)' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO txtHora.
          RETURN 'ADM-ERROR'.
      END.
      
      IF txtMinuto < 0 OR txtMinuto > 59 THEN DO:
          MESSAGE 'Minutos Incorrecto..(00..59)' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO txtMinuto.
          RETURN 'ADM-ERROR'.
      END.

      IF txtHora = 0 OR txtHora = 0 THEN DO: 
          MESSAGE 'Hora/Minuto Incorrecto..' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO txtHora.
          RETURN 'ADM-ERROR'.
      END.
      IF DECIMAL(DI-RutaC.KmtIni:SCREEN-VALUE) <= 0 THEN DO:
          MESSAGE 'Debe ingresar el kilometraje de salida' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO di-rutac.kmtini.
          RETURN 'ADM-ERROR'.
      END.
    END.
    /* El transportista no es continental */
    /*IF txtCodPro <> '10003814' THEN DO:*/
        IF txtSerie <= 0 THEN DO:
            MESSAGE 'Ingrese la serie de Guia del Transportista..' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY' TO txtSerie.
            RETURN 'ADM-ERROR'.
        END.
        IF txtNro <= 0 THEN DO:
            MESSAGE 'Ingrese el nro de Guia del Transportista..' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY' TO txtNro.
            RETURN 'ADM-ERROR'.
        END.
    /*END.          */
    /* *********************************************************************************** */
    /* Consistencia de Guias de Transportista */
    /* *********************************************************************************** */
    DEF BUFFER B-RutaC FOR DI-RutaC.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO' THEN DO:
        FIND FIRST B-RutaC WHERE B-RutaC.codcia = s-codcia 
            AND B-RutaC.codpro = txtCodPro
            AND B-RutaC.GuiaTransportista = STRING(txtSerie, '999') + "-" + STRING(txtNro , '99999999')
            AND B-RutaC.CodDoc = "H/R"
            AND B-RutaC.NroDoc <> Di-RutaC.NroDoc
            AND B-RutaC.FlgEst <> 'A'
            NO-LOCK NO-ERROR.
    END.
    ELSE DO:
        FIND FIRST B-RutaC WHERE B-RutaC.codcia = s-codcia 
            AND B-RutaC.codpro = txtCodPro
            AND B-RutaC.GuiaTransportista = STRING(txtSerie, '999') + "-" + STRING(txtNro , '99999999')
            AND B-RutaC.CodDoc = "H/R"
            AND B-RutaC.FlgEst <> 'A'
            NO-LOCK NO-ERROR.
    END.
    IF AVAILABLE B-RutaC THEN DO:
        MESSAGE 'Guia del Transportista YA fue registrada en la H/R Nro.' B-RutaC.NroDoc
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO txtSerie.
        RETURN 'ADM-ERROR'.
    END.


    /* *********************************************************************************** */
    /* *********************************************************************************** */

    lFechaIng = DATE(DI-RutaC.FchDoc:SCREEN-VALUE).
    lFechaSal = DATE(DI-RutaC.FchSal:SCREEN-VALUE).
    IF INPUT DI-RutaC.FchSal = ? THEN DO:
        MESSAGE 'Fecha de salida esta Vacia' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO di-rutac.FchSal.
        RETURN 'ADM-ERROR'.
    END.
    IF INPUT DI-RutaC.FchSal < lFechaIng /*TODAY*/ THEN DO:
          MESSAGE 'Fecha de salida errada' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO di-rutac.FchSal.
          RETURN 'ADM-ERROR'.
    END.
      /* 
        10Jul2017, correo de Carlos Lalangui/Felix Perez
            restricción solicitada es por 48 horas útiles, 
            considerando el día sábado como útil.
            
        03Oct2017, Fernan Oblitas/Harold Segura 3 dias
       */
      IF lFechaSal > (lFechaIng + 3) THEN DO:
          MESSAGE 'Fecha de salida no debe sobre pasar las 48 Horas' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO di-rutac.FchSal.
          RETURN 'ADM-ERROR'.
      END.

      FIND gn-vehic WHERE gn-vehic.codcia = s-codcia
          AND gn-vehic.placa = DI-RutaC.CodVeh:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-vehic THEN DO:
          MESSAGE 'Debe ingresar la placa del vehiculo' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO di-rutac.codveh.
          RETURN 'ADM-ERROR'.
      END.
      IF INTEGRAL.DI-RutaC.responsable:SCREEN-VALUE = '' THEN DO:
          MESSAGE 'Debe ingresar el responsable' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO di-rutac.responsable.
          RETURN 'ADM-ERROR'.
      END.
      
      IF INTEGRAL.DI-RutaC.ayudante-1:SCREEN-VALUE = '' THEN DO:
          MESSAGE 'Debe ingresar el primer ayudante' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO di-rutac.ayudante-1.
          RETURN 'ADM-ERROR'.
      END.
      IF INTEGRAL.DI-RutaC.ayudante-2:SCREEN-VALUE = '' THEN DO:
          MESSAGE 'Debe ingresar el segundo ayudante' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY' TO di-rutac.ayudante-2.
          RETURN 'ADM-ERROR'.
      END.

/*       FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'VEHICULO' AND */
/*                         vtatabla.llave_c1 = txtCodPro:SCREEN-VALUE AND                         */
/*                         vtatabla.llave_c2 = DI-RutaC.COdveh:SCREEN-VALUE NO-LOCK NO-ERROR.     */
/*       IF NOT AVAILABLE vtatabla THEN DO:                                                       */
/*           MESSAGE 'Placa/Transportista NO existe' VIEW-AS ALERT-BOX ERROR.                     */
/*           APPLY 'ENTRY' TO di-rutac.codveh.                                                    */
/*           RETURN 'ADM-ERROR'.                                                                  */
/*       END.                                                                                     */

      IF DI-RutaC.responsable:SCREEN-VALUE <> '' THEN DO:
          FIND pl-pers WHERE pl-pers.codper = DI-RutaC.responsable:SCREEN-VALUE
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE pl-pers THEN DO:
              MESSAGE "Codigo del Responsable no registrado"
                  VIEW-AS ALERT-BOX ERROR.
              APPLY "ENTRY" TO DI-RutaC.responsable.
              RETURN 'ADM-ERROR'.
          END.
      END.
      IF DI-RutaC.ayudante-1:SCREEN-VALUE <> '' THEN DO:
          FIND pl-pers WHERE pl-pers.codper = DI-RutaC.ayudante-1:SCREEN-VALUE
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE pl-pers THEN DO:
              MESSAGE "Codigo del Primer Ayudante no registrado"
                  VIEW-AS ALERT-BOX ERROR.
              APPLY "ENTRY" TO DI-RutaC.ayudante-1.
              RETURN 'ADM-ERROR'.
          END.
      END.
      IF DI-RutaC.ayudante-2:SCREEN-VALUE <> '' THEN DO:
          FIND pl-pers WHERE pl-pers.codper = DI-RutaC.ayudante-2:SCREEN-VALUE
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE pl-pers THEN DO:
              MESSAGE "Codigo del Segundo Ayudante no registrado"
                  VIEW-AS ALERT-BOX ERROR.
              APPLY "ENTRY" TO DI-RutaC.ayudante-2.
              RETURN 'ADM-ERROR'.
          END.
      END.
END.

  txtConductor:SCREEN-VALUE = "".
  IF DI-RutaC.libre_c01:SCREEN-VALUE = '' THEN DO:
      MESSAGE 'Debe ingresar la LICENCIA de conducir' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY' TO di-rutac.libre_c01.
      RETURN 'ADM-ERROR'.
  END.

  FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'BREVETE' AND
      vtatabla.llave_c1 = DI-RutaC.libre_c01:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE vtatabla THEN DO:
      MESSAGE 'Nro de Licencia NO existe' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY' TO di-rutac.libre_c01.
      RETURN 'ADM-ERROR'.
  END.
  
  txtConductor:SCREEN-VALUE = vtatabla.libre_C01 + " " + vtatabla.libre_C02 + " " + vtatabla.libre_C03.

  RETURN "OK".

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
         HEIGHT             = 3.96
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


