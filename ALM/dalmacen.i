  FIELD CodAlm LIKE Almacen.CodAlm VALIDATE ~
  FIELD Descripcion LIKE Almacen.Descripcion VALIDATE ~
  FIELD AutMov LIKE Almacen.AutMov VALIDATE ~
  FIELD TdoArt LIKE Almacen.TdoArt VALIDATE ~
  FIELD CorrIng LIKE Almacen.CorrIng VALIDATE  FORMAT "9999999"~
  FIELD CorrSal LIKE Almacen.CorrSal VALIDATE  FORMAT "9999999"~
  FIELD Clave LIKE Almacen.Clave VALIDATE ~
  FIELD flgrep LIKE Almacen.flgrep VALIDATE ~
  FIELD CodCia LIKE Almacen.CodCia VALIDATE ~
  FIELD AlmCsg LIKE Almacen.AlmCsg VALIDATE  LABEL "Almacén de Consignación"~
  FIELD Campo-C1 LIKE Almacen.Campo-C[1] VALIDATE  LABEL "Clasificación"~
  FIELD Campo-C2 LIKE Almacen.Campo-C[2] VALIDATE ~
  FIELD Campo-C3 LIKE Almacen.Campo-C[3] VALIDATE ~
  FIELD Campo-C4 LIKE Almacen.Campo-C[4] VALIDATE ~
  FIELD Campo-C5 LIKE Almacen.Campo-C[5] VALIDATE  LABEL "Localización"~
  FIELD Campo-C6 LIKE Almacen.Campo-C[6] VALIDATE ~
  FIELD Campo-C7 LIKE Almacen.Campo-C[7] VALIDATE ~
  FIELD Campo-C8 LIKE Almacen.Campo-C[8] VALIDATE ~
  FIELD Campo-C9 LIKE Almacen.Campo-C[9] VALIDATE ~
  FIELD Campo-C10 LIKE Almacen.Campo-C[10] VALIDATE  LABEL "Tpo Servicio"~
  FIELD CodCli LIKE Almacen.CodCli VALIDATE  LABEL "RUC"~
  FIELD CodDiv LIKE Almacen.CodDiv VALIDATE  FORMAT "x(5)" LABEL "Local"~
  FIELD DirAlm LIKE Almacen.DirAlm VALIDATE ~
  FIELD EncAlm LIKE Almacen.EncAlm VALIDATE  LABEL "Encargado"~
  FIELD HorRec LIKE Almacen.HorRec VALIDATE ~
  FIELD TelAlm LIKE Almacen.TelAlm VALIDATE  LABEL "Teléfono"~
  FIELD TpoCsg LIKE Almacen.TpoCsg VALIDATE  LABEL "Tipo Csg."~
  FIELD Campo-Log1 LIKE Almacen.Campo-Log[1] VALIDATE 
