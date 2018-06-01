

library(reshape2)
library(dplyr)
datos       <-
  read.table("../data/Tabla.txt", sep = "\t", header = TRUE)
datos$Linea <- paste0(datos$Linea, "__", datos$repe)
lineas      <- levels(as.factor(datos$Linea))
snps        <- names(datos)[c(4:length(datos))]
datos2       <- datos[, c("Linea", snps)]
datos2       <- melt(datos2)
datos3      <- datos[, c("Linea", "Virus")]
datos       <- merge(datos3, datos2, by = "Linea")
datos$value <- as.factor(datos$value)
names(datos) <- c("Linea", "Virus", "Snp", "Valor")
ejes        <- names(datos)