# This script downloads and installs automatically the required packages to run the simulations
# Warning: This step can take several minutes

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

readDataVoronoi <- function(sensores, campo) {
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

	cat('\r',format(paste("Building Voronoi Diagram: ",round(i*100/fieldLenght,digits=2), " %", "  ", sep='')))
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

read.tcsv = function(file, header=TRUE, sep=",", ...) {

  n = max(count.fields(file, sep=sep), na.rm=TRUE)
  x = readLines(file)

  .splitvar = function(x, sep, n) {
    var = unlist(strsplit(x, split=sep))
    length(var) = n
    return(var)
  }

  x = do.call(cbind, lapply(x, .splitvar, sep=sep, n=n))
  x = apply(x, 1, paste, collapse=sep) 
  out = read.csv(text=x, sep=sep, header=header, ...)
  return(out)

}

unvectorize_xy <- function(index,fieldLength)
{
	x = index %% fieldLength
	if (x == 0)
		x=fieldLength

	y = (index - x)/fieldLength + 1

	return(c(x,y))
}
