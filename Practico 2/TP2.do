********************************************************************************
* Descripcion: Trabajo practico 2 de Econometria (MECA)
* 
* Autor: Alessio Bocco
********************************************************************************

********************************************************************************
* Paso 0: Limpieza de espacio de trabajo y configuracion general
clear all
set more off
set memory 100m
********************************************************************************

********************************************************************************
* Paso 1: Definicion de directorio de trabajo
cd "/Users/alessiobocco/Documents/Maestria/Maestria Austral/Econometría/Practicos/Econometria/Practico 2"
********************************************************************************

********************************************************************************
* Paso 2 Crear log 
log using "./log/TP2_Econometria", text replace
********************************************************************************

********************************************************************************
* Paso 3: Cargar datos necesarios
use "./data/HPRICE2.dta"

* Descripción de la base
describe
* descripcion de las variables
summarize 
********************************************************************************

********************************************************************************
* Paso 5: Ejercicio 2. Descripcion del dataset
correlate
********************************************************************************

********************************************************************************
* Paso 6: Ejercicio 3. Modelo de regresion
regress price nox rooms crime radial 
estimates store linlin
********************************************************************************

********************************************************************************
* Paso 7: Ejercicio 4. Modelo de regresion
gen rooms2 = rooms*rooms
regress price nox rooms crime radial c.rooms#c.rooms

margins, at(rooms = (0(1)10)) atmeans
marginsplot
graph export "./figuras/margin_plot.png", width(1000) replace
********************************************************************************

********************************************************************************
* Paso 8: Ejercicio 5. Modelo de regresion log-log
gen lrooms =  ln(rooms)
gen lcrime =  ln(crime)
gen lradial =  ln(radial)

regress lprice lnox lrooms lcrime lradial

estimates store loglog
********************************************************************************

********************************************************************************
* Paso 9: Ejercicio 6. Comparacion de modelos
estimates stats linlin loglog
* Se calcula la sumatoria de log(y)
egen sumatoria = total(lprice) 
* Calculo del AIC corregido
gen log_aic = 161.9195 + sumatoria * 2 
display log_aic
*******************************************************************************

********************************************************************************
* Paso 9: Ejercicio 8. Efecto de la contaminacion
generate contaminacion_nox = (nox > 6)

regress price nox rooms crime radial contaminacion_nox
graph box price, over(contaminacion_nox)
graph export "./figuras/boxplot_plot.png", width(1000) replace

regress price rooms crime radial contaminacion_nox
*******************************************************************************

********************************************************************************
* Paso 10: Cerrar log
log close
********************************************************************************

********************************************************************************
* Paso 11: Finalizar script
exit
********************************************************************************


