# An�lisis factorial matriz psych
#Descarga de paquetes y librer�as 

install.packages("psych")

library(psych)

install.packages("polycor")

library(polycor)

install.packages("ggcorrplot")

library(ggcorrplot)

# Extracci�n de datos.
x<-Garcia

# Exploraci�n de la matriz.
dim(x)

# Tipo de variables.
str(x)

#Nombre de las variables
colnames(x)

# Creaci�n de una nueva matriz de datos donde se incluyen las variables 1 a la 25 y las primeras 200 observaciones.
x1<-Garcia[1:100,1:4]

# Matriz de correlaciones
R<-hetcor(x1)$correlations

# Gr�fico de correlaciones
ggcorrplot(R, type = "lower", hc.order=TRUE)

#Factorizaci�n de la matriz de correlaciones

#Se utiliza la prueba de esfericidad de Bartlett.

p_Bartlett<-cortest.bartlett(R)


#Visualizaci�n del p-valor

p_Bartlett$p.value

#Ho: Las variables est�n correlacionadas.
#Ha: Las variables no est�n correlacionadas.

#No rechazo Ho, ya que las variables est�n correlacionadas.

# Criterio Kaiser-Meyer-Olkin
#Me permite identificar si los datos que voy a analizar son adecuados para un an�lisis factorial.

#0.00 a 0.49 No adecuados
#0.50 a 0.59 Poco adecuados
#0.60 a 0.69 Aceptables
#0.70 a 0.89 Buenos
#0.90 a 1.00 Excelentes 

KMO(R)

# Extracci�n de factores 

#minres: minimo residuo
#mle: max verosimilitud
#paf: ejes principales
#alpha: alfa
#minchi: m�nimos cuadrados
#minrak: rango m�nimo

modelo1<-fa(R,nfactor=3,rotate = "none",fm="mle")

modelo2<-fa(R,nfactor=3,rotate = "none",fm="minres")

#Extraer el resultado de la comunidalidades, , ah� se encuentra la proporci�n de varianza explicada. Se interpreta de tal forma que n�mero cercanos a 1, el factor explica mejor la  variable.

C1<-sort(modelo1$communality, decreasing = TRUE)

C2<-sort(modelo2$communality, decreasing = TRUE)

head(cbind(C1,C2))

#Extracci�n de unidades
#La unicidad es el cuadro del coeficiente del factor �nico, y se expresa como la porci�n de la varianza explicada por el factor �nico. Es decir, no puede ser explicada por otros factores.

u1<-sort(modelo1$uniquenesses, decreasing = TRUE)

u2<-sort(modelo2$uniquenesses, decreasing = TRUE)

head(cbind(u1,u2))

scree(R)


# Rotaci�n de la matriz

install.packages("GPArotation")
library(GPArotation)


rot<-c("None", "Varimax", "Quartimax", "Promax")
bi_mod<-function(tipo){
  biplot.psych(fa(x1, nfactors = 2,  
                  fm= "minres", rotate=tipo),
               main = paste("Biplot con rotaci�n", tipo),
               col=c(2,3,4), pch=c(21,18), group=Garcia[,"protest"])
}
sapply(rot,bi_mod)

# Interpretaci�n 
#Para esto se utiliza el fr�fico de �rbol.

modelo_varimax<-fa(R,nfactor=4,
                   rotate = "varimax",
                   fm="minres")

fa.diagram(modelo_varimax)

#Visualizaci�n de la matriz de carga rotada.

print(modelo_varimax$loadings, cut=0)