  FIELD NroItm LIKE CcbDDocu.NroItm LABEL "No" COLUMN-LABEL "No"~
  FIELD codmat LIKE CcbDDocu.codmat FORMAT "X(8)" LABEL "Articulo" COLUMN-LABEL "Articulo"~
  FIELD DesMat LIKE Almmmatg.DesMat VALIDATE  FORMAT "X(100)"~
  FIELD DesMar LIKE Almmmatg.DesMar VALIDATE  LABEL "Marca" COLUMN-LABEL "Marca"~
  FIELD UndVta LIKE CcbDDocu.UndVta COLUMN-LABEL "Unidad"~
  FIELD CanDes LIKE CcbDDocu.CanDes~
  FIELD ImpLin LIKE CcbDDocu.ImpLin LABEL "Importe!con IGV" COLUMN-LABEL "Importe!con IGV"
