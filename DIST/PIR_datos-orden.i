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

              
              
        ASSIGN {&wrkTORDENES}.campo-c[1] = faccpedi.coddoc
                {&wrkTORDENES}.campo-c[2] = faccpedi.nroped
                {&wrkTORDENES}.campo-d[1] = faccpedi.fchped
                {&wrkTORDENES}.campo-d[2] = faccpedi.fchent
                {&wrkTORDENES}.campo-c[9] = faccpedi.dircli
                {&wrkTORDENES}.campo-c[7] = faccpedi.codcli
                {&wrkTORDENES}.campo-c[8] = faccpedi.nomcli
                {&wrkTORDENES}.campo-c[5] = ""            /* Div Despacho */
                {&wrkTORDENES}.campo-c[6] = faccpedi.divdes
                {&wrkTORDENES}.campo-c[3] = faccpedi.coddiv
                {&wrkTORDENES}.campo-c[4] = ""            /* Div venta */
                {&wrkTORDENES}.campo-c[10] = ""           /* Distrio entrega */
                {&wrkTORDENES}.campo-c[29] = ""           /* uso interno */
                {&wrkTORDENES}.campo-c[30] = ""           /* uso interno */
                {&wrkTORDENES}.campo-c[13] = faccpedi.nroref
                {&wrkTORDENES}.campo-c[16] = faccpedi.codref
                {&wrkTORDENES}.campo-f[1] = faccpedi.acubon[8]  /* Importe */
                {&wrkTORDENES}.campo-i[1] = faccpedi.items
                {&wrkTORDENES}.campo-f[2] = faccpedi.peso
                {&wrkTORDENES}.campo-f[3] = faccpedi.volumen
                {&wrkTORDENES}.campo-i[2] = faccpedi.acubon[9]  /* Bultos */
                {&wrkTORDENES}.campo-c[14] = ""               /* Estado de la Orden */
                {&wrkTORDENES}.campo-c[12] = ""               /* Provincia */
                {&wrkTORDENES}.campo-c[15] = ""               /* Glosa */
                {&wrkTORDENES}.campo-c[11] = "NO"             /* Embalado especial */
                {&wrkTORDENES}.campo-c[17] = "NO"               /* Cliente Recoje */
        .

        ASSIGN {&wrkTORDENES}.campo-i[30] = {&wrkTORDENES}.campo-i[30] + faccpedi.items
                {&wrkTORDENES}.campo-i[29] = {&wrkTORDENES}.campo-i[29] + faccpedi.acubon[9]        /* Bultos */
                {&wrkTORDENES}.campo-f[30] = {&wrkTORDENES}.campo-f[30] + faccpedi.peso
                {&wrkTORDENES}.campo-f[29] = {&wrkTORDENES}.campo-f[29] + faccpedi.volumen
                {&wrkTORDENES}.campo-f[28] = {&wrkTORDENES}.campo-f[28] + faccpedi.acubon[8]        /* Monto */
            .
        
        RUN vta2/p-faccpedi-flgest(INPUT faccpedi.flgest,
                                    INPUT faccpedi.coddoc,
                                    OUTPUT x-estado).
        ASSIGN {&wrkTORDENES}.campo-c[14] = x-estado.
            
        /* Pedido */
        FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                    x-faccpedi.coddoc = faccpedi.codref AND
                                    x-faccpedi.nroped = faccpedi.nroref NO-LOCK NO-ERROR.
        IF AVAILABLE x-faccpedi THEN DO:
            ASSIGN {&wrkTORDENES}.campo-c[15] = x-faccpedi.glosa.
            IF x-faccpedi.embalaje_especial = YES THEN {&wrkTORDENES}.campo-c[11] = "SI".
            IF x-faccpedi.cliente_recoge = YES THEN {&wrkTORDENES}.campo-c[17] = "SI".
        END.

        FIND FIRST x-gn-divi WHERE x-gn-divi.codcia = s-codcia AND
                                    x-gn-divi.coddiv = faccpedi.coddiv NO-LOCK NO-ERROR.
        IF AVAILABLE x-gn-divi THEN DO:
            ASSIGN {&wrkTORDENES}.campo-c[4] = x-gn-divi.desdiv.

        END.
            
        FIND FIRST x-gn-divi WHERE x-gn-divi.codcia = s-codcia AND
                                    x-gn-divi.coddiv = faccpedi.divdes NO-LOCK NO-ERROR.
        
        IF AVAILABLE x-gn-divi THEN DO:
            ASSIGN {&wrkTORDENES}.campo-c[5] = x-gn-divi.desdiv.
        END.

    RUN logis/p-datos-sede-auxiliar (
      FacCPedi.Ubigeo[2],   /* ClfAux @CL @PV */
      FacCPedi.Ubigeo[3],   /* Auxiliar */
      FacCPedi.Ubigeo[1],   /* Sede */
      OUTPUT pUbigeo,
      OUTPUT pLongitud,
      OUTPUT pLatitud).

    FIND FIRST TabProvi WHERE TabProvi.CodDepto = SUBSTRING(pUbigeo,1,2)
      AND TabProvi.CodProvi = SUBSTRING(pUbigeo,3,2) NO-LOCK NO-ERROR.
    IF AVAILABLE TabProvi THEN DO:
        ASSIGN {&wrkTORDENES}.campo-c[12] = TabProvi.NomProvi.
    END.

    FIND FIRST TabDistr WHERE TabDistr.CodDepto = SUBSTRING(pUbigeo,1,2)
      AND TabDistr.CodProvi = SUBSTRING(pUbigeo,3,2)
      AND TabDistr.CodDistr = SUBSTRING(pUbigeo,5,2)
      NO-LOCK NO-ERROR.
    IF AVAILABLE TabDistr THEN DO:
        ASSIGN {&wrkTORDENES}.campo-c[10] = TabDistr.NomDistr.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


