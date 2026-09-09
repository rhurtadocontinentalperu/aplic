TRIGGER PROCEDURE FOR DELETE OF AlmDMov.

/* RHC 13/05/2017 Ya no se usa
DEF VAR xRaw AS RAW NO-UNDO.
RAW-TRANSFER Almdmov TO xRaw.
RUN orange\exporta-almacenes ('Almdmov',xRaw,"D").
*/

/* Stock Comprometido */
/* 10/10/2024 */
/* RUN web/p-ctrl-sku-disp-riqra (INPUT "Almdmov",                         */
/*                                INPUT (Almdmov.CodAlm + ":" +            */
/*                                       Almdmov.TipMov + ":" +            */
/*                                       STRING(Almdmov.CodMov) + ":" +    */
/*                                       STRING(Almdmov.NroSer) + ":" +    */
/*                                       STRING(Almdmov.NroDoc) + ":" +    */
/*                                       Almdmov.CodMat),                  */
/*                                INPUT (Almdmov.CanDes * Almdmov.Factor), */
/*                                INPUT 0,                                 */
/*                                "D"                                      */
/*                                ).                                       */

