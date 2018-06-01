library(titanic)

datos           <- titanic_train
clase           <- levels(as.factor(datos$Pclass))
sobrevivientes  <- levels(as.factor(datos$Survived))
ejes            <- names(datos)