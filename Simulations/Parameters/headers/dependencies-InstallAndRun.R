# This script downloads and installs automatically the required packages to run the simulations
# Warning: This step can take several minutes
# Obs.: fieldLength should be a global variable, remember to state it at begining of file (!!)

# Author: Israel Vasconcelos
# Federal University of Alagoas
# Sep, 2015

usePackage <- function(p)  {
	if (!is.element(p, installed.packages()[,1]))
		install.packages(p, dep = TRUE, repos='http://cran.us.r-project.org')
	
	suppressMessages(require(p, character.only = TRUE))
}

p <- c("spatstat","RandomFields","igraph","geoR","Hmisc","plotrix","ads","spdep","deldir","hash")

for(i in p)
	usePackage(i)

###########################################################################################

mygrf <- function(kappa,phi,mean,var,nugget,fieldLength=100)
{
	fl=fieldLength
	cov.pars = c(var,phi)
	cov.model = "matern"
	nsim = 1
	assign("setRF", geoR2RF(cov.model = cov.model, cov.pars = cov.pars, nugget = nugget, kappa = kappa ), pos = 1)
	return(matrix(grf(nx=fl,ny=fl,n=fl^2,xlims=c(0,fl-1),ylims=c(0,fl-1), nugget=nugget,mean=mean,cov.pars=cov.pars,kappa=kappa,grid="reg")$data,ncol=fl))

}

readDataVoronoi <- function(sensores, campo, fieldLenght=100) {
	if(missing(sensores)) stop('Falta sensores')
	if(missing(campo)) stop('Falta o campo gaussiano')
	data <- hash()

  # Matriz que registra a região onde cada sensor é responsável no diagrama de Voronoi.
	saux <- matrix(nrow = fieldLenght, ncol = fieldLenght)
	quant <- 1
	for(i in 1:fieldLenght){
	  for(j in 1:fieldLenght){
	    dist = 9999999;
	    for(s in 1:sensores$n){
	      x <- trunc(sensores$x[s])
	      y <- trunc(sensores$y[s])
        	aux = sqrt((i-x)^2 + (j-y)^2)
		if(aux < dist){
          		saux[i,j] <- s
          		dist = aux
		}
	    }
	  }

	cat('\r',format(paste("Building Voronoi Diagram: ",round(i*100/fieldLenght,2), "%", sep='')))
	flush.console() 
	}
  
  # Atribuição dos valores do conjunto de dados para cada sensor.
	for(s in 1:sensores$n){
    # Contagem da # de elementos que cada sensor é responsável.
		data_ <- matrix(nrow=0,ncol=3) 
    		count = 0
		it = 0
    		for(i in 1:fieldLenght) {
	    		for(j in 1:fieldLenght) {
				      it = it + 1
	      			if(saux[i,j] == s){
          					data_ <- rbind(data_, c(i,j,campo[i,j]))
	      			}
			}
		}
	#print(data_)
	  data[s] <- as.geodata(data_)
	}

	return(data)
}

read.tcsv = function(file, header=TRUE, sep=",", ...) { # Remeber: First element of each line is the node ID

  n = max(count.fields(file, sep=sep), na.rm=TRUE)
  x = readLines(file)

  .splitvar = function(x, sep, n) {
    var = unlist(strsplit(x, split=sep))
    length(var) = n
    return(var)
  }

  x = do.call(cbind, lapply(x, .splitvar, sep=sep, n=n))
  x = apply(x, 1, paste, collapse=sep) 
  out = read.csv(text=x,sep=sep,check.names=FALSE,header=header, ...) # obs.: enable check.names if some bug happen
  return(out)

}

unvectorize_xy <- function(index,fieldLength)
{
	x = index %% fieldLength

	if (is.na(x))
		warning("NA Detected!")

	if (x == 0)
		x=fieldLength

	y = (index - x)/fieldLength + 1

	return(c(x,y))
}

#################################################################################################
## Israel (03/2014) ##
## Contamina uma area (2*r+1)² com decaimento linear a em relação ao ponto contaminado
contaminate <- function(m,eta,x,y,r) { # m = campo, x/y = coordenada inicial, eta = escala de contaminacao, r = alcance

    if(r == 0)
        stop("Param. range invalido")

    m_cont <- matrix(1, nrow=dim(m)[1], ncol=dim(m)[2]) #matriz de contaminacao
    cont = eta
    fator_multiplicador <- seq(from=eta, to=1, length=r) #Escalas de multiplicação em funcao da distancia
    r=r+1 #Corrigindo o parametro de alcance. No loop abaixo só é possível ir até r-1, se r=dist -> cont=0.

    for(i in 0:(r-1)) { #Varrer matriz

        for(j in 0:(r-1)) {
           
            dist = max(i,j)

            if(dist != 0)
                cont = fator_multiplicador[dist]

            if(x+i <= dim(m)[1] && y+j <= dim(m)[2]) #Varredura a direita e para baixo
                m_cont[x+i, y+j] <- cont

            if(x+i <= dim(m)[1] && y-j > 0) #Varredura a direita e para cima
                m_cont[x+i, y-j] <- cont

            if(x-i > 0 && y+j <= dim(m)[2]) #Varredura a esquerda e para baixo
                m_cont[x-i, y+j] <- cont
           
            if( x-i > 0 && y-j > 0) #Varredura a esquerda e para cima
                m_cont[x-i, y-j] <- cont
        }
    }

    return(m*m_cont)
}

#################################################################################################

meanFilter <- function(field, window=4) {

	newField <- field

	for(i in seq(from=0,to=(ncol(field)-1),by=window)) 
		for(j in seq(from=0,to=(nrow(field)-1),by=window)) 
			newField[i+(1:window),j+(1:window)] <- mean(newField[i+(1:window),j+(1:window)])

	return(newField)

}
