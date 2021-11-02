********************************************************************************
* Descripcion: Trabajo practico 1 de Econometria (MECA)
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
cd "/Users/alessiobocco/Documents/Maestria/Maestria Austral/Econometría/Practicos/Econometria/Practico 1"
********************************************************************************

********************************************************************************
* Paso 2 Crear log 
log using "./log/TP1_Econometria", text replace
********************************************************************************

********************************************************************************
* Paso 3: Cargar datos necesarios
use "./data/TP1.dta"
* El dataset posee datos de gastos en alimentos en U$S y de ingreso semanal
* variable dependiente: gastoenalimentosyt
* variable independiente: ingresosemanalxt
describe gastoenalimentosyt ingresosemanalxt
********************************************************************************

********************************************************************************
* Paso 4: Ejercicio 1
*
* Histograma de gastoenalimentosyt
hist gastoenalimentosyt, ///
       title(Distribución del gasto en alimentos) xtitle(Gasto) ytitle(Densidad)
	   graph export "./figuras/histograma_gasto.png", width(400) replace
* Inspeccion de la variable
summarize gastoenalimentosyt, detail 
********************************************************************************

********************************************************************************
* Paso 5: Ejercicio 2
*
* Histograma de ingresosemanalxt
hist ingresosemanalxt, ///
       title(Distribución del ingreso semanal) xtitle(Ingreso) ytitle(Densidad)
	   graph export "./figuras/histograma_ingreso.png", width(400) replace
* Inspeccion de la variable
summarize ingresosemanalxt, detail 
********************************************************************************

********************************************************************************
* Paso 6: Ejercicio 3
*
* Diagrama de dispersión entre gastos e ingresos
graph twoway scatter gastoenalimentosyt ingresosemanalxt, ///
		title(Relación entre el ingreso semanal y el gasto en alimentos) xtitle(Ingreso) ytitle(Gasto)
		graph export "./figuras/dispersion_ingreso_gasto.png", width(400) replace
********************************************************************************

********************************************************************************
* Paso 7: Ejercicio 4
*
* Modelo de regresión por OLS entre gastos e ingresos
regress gastoenalimentosyt ingresosemanalxt
* beta_0 = 40.76756
* beta_1 = .1282886 
********************************************************************************

********************************************************************************
* Paso 8: Ejercicio 5
*
* Grafico de evaluacion de los residuos de la regresión
rvfplot
		graph export "./figuras/residuos_vs_valores_ajustados.png", width(400) replace
********************************************************************************

********************************************************************************
* Paso 9: Ejercicio 6
*
* Tests de heterocedaticidad
* Test de White
imtest, white
* Test de Breusch-Pagan
estat hettest
********************************************************************************

********************************************************************************
* Paso 10: Ejercicio 7
*
* Analizar salidas del modelo de regresión
********************************************************************************

********************************************************************************
* Paso 11: Ejercicio 8
*
* Calcular los residuos
generate gastos_precichos =  40.76756 + .1282886*ingresosemanalxt // Se pordía usar predict también
generate residuos = gastoenalimentosyt - gastos_precichos

* Suma de residuos
total(residuos)
* Normalidad de residuos 
swilk residuos
********************************************************************************

********************************************************************************
* Paso 12: Ejercicio 9
*
* Calcular de las elasticidad
* En una regresión log-log el termino beta_1 corresponde a la elasticidad 
* entre las variables
generate gasto_log = log(gastoenalimentosyt)
generate ingreso_log = log(ingresosemanalxt)
* Modelo de regresion
regress gasto_log ingreso_log
* Ante un aumento del 1% en los ingresos, el gasto aumentara 0.694%
* Los alimentos son un bien normal porque su elasticidad es positiva sin embargo,
* al ser menor a 1 se los clasificas como bienes necesarios
********************************************************************************

********************************************************************************
* Paso 13: Ejercicio 10
*
* Prediccion de un nivel de gasto para un valor determinado de ingreso de 750
regress gastoenalimentosyt ingresosemanalxt
* Prediccion con el modelo de regresion
adjust ingresosemanalxt=750
********************************************************************************

********************************************************************************
* Paso 14: Cerrar log
log close
********************************************************************************

********************************************************************************
* Paso 15: Finalizar script
exit
********************************************************************************
