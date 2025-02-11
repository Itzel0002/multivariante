#ANALISIS FACTORIAL

#Se instalan las paqueteria
install.packages("datos")
library(datos)

#1.- Lectura de la matriz de datos
C<-data.frame(datos::mtautos)
C<-as.data.frame(mtautos)

#2.- Quitar los espacios de los nombres
colnames(C)[1]="Life.Exp"
colnames(C)[11]= "HS.Grad"

#3.- Separa n (estados) y p (variables)
n<-dim(C)[1]
p<-dim(C)[11]

#4.- Generacion de un scater plot para la
# visualizaci�n de variables originales
pairs(C, col="pink", pch=19, main="matriz original")

# Transformaci�n de alguna varibles
#1.- Aplicamos logaritmo para las columnas 1,3 y 8
C[,1]<-log(C[,1])
colnames(C)[1]<-"Log-Population"
C[,3]<-log(C[,3])
colnames(C)[3]<-"Log-Illiteracy"
C[,8]<-log(C[,8])
colnames(C)[8]<-"Log-Area"

# Grafico scater para la visualizacion de la 
# matriz original con 3 variables que se incluyeron
pairs(C,col="red", pch=19, main="Matriz original")

# Nota: Como las variables tiene diferentes unidades
# de medida, se va a implementar la matriz de
# correlaciones para estimar la matriz de carga

# Reduccion de la dimensionalidad 
# An�lisis Factorial de componentes principales (PCFA)

#1.- Calcular la matriz de medias y de correlaciones
# Matriz de medias
mu<-colMeans(C)
mu

#Matriz de correlaciones
R<-cor(C)
R

# 2.- Reducci�n de la dimensionalidad mediante
# An�lisis factorial de componentes principales (PCFA).

# 1.- Calcular los valores y vectores propios.
eR<-eigen(R)

# 2.- Valores propios
eigen.val<-eR$values
eigen.val

# 3.- Vectores propios
eigen.vec<-eR$vectors
eigen.vec

# 4.- Calcular la proporcion de variabilidad
prop.var<-eigen.val/sum(eigen.val)
prop.var

# 5.- Calcular la proporcion de variabilidad acumulada
prop.var.acum<-cumsum(eigen.val)/sum(eigen.val)
prop.var.acum

# Estimacion de la matriz de carga

# Nota: se estima la matriz de carga usando los 
# autovalores y autovectores.
# se aplica la rotaci�n varimax

# Primera estimaci�n de Lamda mayuscula
# se calcula multiplicando la matriz de los 
# 3 primeros autovectores por la matriz diagonal
# formada por la raiz cuadrada de los primeros
# 3 autovalores.

L.est.1<-eigen.vec[,1:3] %*% diag(sqrt(eigen.val[1:3]))
L.est.1

# Rotaci�n varimax
L.est.1.var<-varimax(L.est.1)
L.est.1.var


# Estimaci�n de la matriz de los errores
#1.- Estimaci�n de la matriz de perturbaciones
Psi.est.1<-diag(diag(R-as.matrix(L.est.1.var$loadings)%*% t(as.matrix(L.est.1.var$loadings))))
Psi.est.1

# 2.- Se utiliza el m�todo An�lisis de factor principal (PFA)
# para estimaci�n de autovalores y autovectores
RP<-R-Psi.est.1
RP


# Calculo de la matriz de autovalores y autovectores
eRP<-eigen(RP)

# Autovalores
eigen.val.RP<-eRP$values
eigen.val.RP

# Autovectores
eigen.vec.RP<-eRP$vectors
eigen.val.RP

# Proporcion de variabilidad
prop.var.RP<-eigen.val.RP/ sum(eigen.val.RP)
prop.var.RP

# Proporcion de variabilidad acumulada
prop.var.RP.acum<-cumsum(eigen.val.RP)/ sum(eigen.val.RP)
prop.var.RP.acum

# Estimaci�n de la matriz de cargas
# con rotaci�n varimax
L.est.2<-eigen.vec.RP[,1:3] %*% diag(sqrt(eigen.val.RP[1:3]))
L.est.2

# Rotacion varimax
L.est.2.var<-varimax(L.est.2)


# Estimaci�n de la matriz de covarianzas de los errores.
Psi.est.2<-diag(diag(R-as.matrix(L.est.2.var$loadings)%*% t(as.matrix(L.est.2.var$loadings))))
Psi.est.2

# Obtencion de los scores de ambos m�todos

# PCFA
FS.est.1<-scale(C)%*% as.matrix(L.est.1.var$loadings)
FS.est.1


# PFA
FS.est.2<-scale(C)%*% as.matrix (L.est.2.var$loadings)
FS.est.2


# graficamos ambos scores
par(mfrow=c(2,1))

# Factor I y II
pl1<-plot(FS.est.1[,1], FS.est.1[,2], xlab="primer factor",
          ylab="segundo factor", main="scores con factor I y II con PCFA",
          pch=19, col="blue")
text(FS.est.1[,1], FS.est.1[,2], labels = rownames(C), pos=4, col="green")

# Factor I y III
pl2<-plot(FS.est.1[,1], FS.est.1[,3], xlab="Primer factor",
          ylab="Tercer factor", main="scores con factor I y III con PCFA",
          pch=19, col="blue")
text(FS.est.1[,1], FS.est.1[,3], labels = rownames(C), pos=4, col="red")

# Factor II y III
pl3<-plot(FS.est.1[,2], FS.est.1[,3], xlab="Segundo factor",
          ylab="Tercer factor", main="scores con factor II y III con PCFA",
          pch=19, col="blue")
text(FS.est.1[,2], FS.est.1[,3], labels = rownames(C), pos=4, col="black")