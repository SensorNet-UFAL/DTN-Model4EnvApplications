source("dependencies-InstallAndRun.R")
source("auxiliarFunctions.R")

inhibit = 4 # Default value to inhibittion radius

	numNodes=50
	fieldLenght=100
	seed = 1 #sample(100,1)
	event = 0

set.seed(1)
field = round(mygrf(kappa=0.5,phi=35,mean=25,var=64,nugget=0, fieldLength=fieldLenght),2)
#field = meanFilter(field,window=5)
#field = as.matrix(blur(as.im(field),sigma=4))

f1=meanFilter(field,window=5)

f2=f1
f2=as.matrix(blur(as.im(f2),sigma=4))


GerarFigura("f1",f1)

