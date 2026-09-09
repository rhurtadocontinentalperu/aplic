  FIELD codfam LIKE Almmmatg.codfam VALIDATE  LABEL "Código!Familia" COLUMN-LABEL "Código!Familia"~
  FIELD codmat LIKE Almmmate.codmat VALIDATE  LABEL "Codigo!Articulo"~
  FIELD DesMat LIKE Almmmatg.DesMat VALIDATE  FORMAT "X(60)"~
  FIELD DesMar LIKE Almmmatg.DesMar VALIDATE  FORMAT "X(20)" LABEL "Marca" COLUMN-LABEL "Marca"~
  FIELD UndStk LIKE Almmmatg.UndStk VALIDATE  LABEL "Unidad" COLUMN-LABEL "Unidad"~
  FIELD StkAct LIKE Almmmate.StkAct VALIDATE ~
  FIELD CodUbi LIKE Almmmate.CodUbi VALIDATE  FORMAT "x(8)" LABEL "Zona o!Ubicación" COLUMN-LABEL "Zona o!Ubicación"~
  FIELD FchIng LIKE Almmmatg.FchIng VALIDATE ~
  FIELD Pesmat LIKE Almmmatg.Pesmat VALIDATE  LABEL "Peso!Kg" COLUMN-LABEL "Peso!Kg"
