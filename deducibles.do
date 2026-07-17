clear all
set more off

*------------------------------------------------------------
* 0. RUTAS DEL PROYECTO
*------------------------------------------------------------

global root "C:\Users\Yamilet\Documents\INTRODUCCION A LA ECONOMETRIA\TRABAJO ECONOMETRIA"
global base "$root\Base Lista"
global do "$root\Do"
global tablas "$root\Tabla_Resultados"
global outputs "$root\Outputs"

cd "$root"

log using "$outputs\log_modelo_diagnostico.txt", text replace

*------------------------------------------------------------
* 1. ABRIR BASE FINAL LIMPIA
*------------------------------------------------------------

use "$base\base_enaho_2024_lista_para_MCO.dta", clear

* Revisar variables principales
describe ln_salario educ_años exper exper2 mujer privado
summarize ln_salario educ_años exper exper2 mujer privado

*------------------------------------------------------------
* 2. RENOMBRAR EDUCACIÓN PARA EVITAR PROBLEMAS CON LA Ñ
*------------------------------------------------------------

capture rename educ_años educ_anios
label variable educ_anios "Años de educación formal acumulados"

* Verificar que quedó bien
describe ln_salario educ_anios exper exper2 mujer privado
summarize ln_salario educ_anios exper exper2 mujer privado

*------------------------------------------------------------
* 3. MODELO MCO CONVENCIONAL
*------------------------------------------------------------

regress ln_salario educ_anios exper exper2 mujer privado

* Guardar estimación convencional
estimates store MCO_simple

* Instalar outreg2 si no está instalado
capture ssc install outreg2, replace

* Exportar primera columna: MCO convencional
outreg2 using "$tablas\Tabla_Resultados_MCO.doc", replace word ///
ctitle("MCO convencional") dec(4) se ///
addnote("Errores estándar entre paréntesis.", ///
"Variable dependiente: logaritmo natural del salario por hora.")

*------------------------------------------------------------
* 3.1. TEST DE ESPECIFICACIÓN (RESET DE RAMSEY)
*------------------------------------------------------------
estat ovtest

*------------------------------------------------------------
* 4. DIAGNÓSTICO DE MULTICOLINEALIDAD
*------------------------------------------------------------

vif

*------------------------------------------------------------
* 5. TEST DE BREUSCH-PAGAN PARA HETEROCEDASTICIDAD
*------------------------------------------------------------

estat hettest, rhs

*------------------------------------------------------------
* 6. TEST DE WHITE PARA HETEROCEDASTICIDAD
*------------------------------------------------------------

estat imtest, white

*------------------------------------------------------------
* 7. MODELO MCO CON ERRORES ESTÁNDAR ROBUSTOS
*------------------------------------------------------------

regress ln_salario educ_anios exper exper2 mujer privado, vce(robust)

* Guardar estimación robusta
estimates store MCO_robusto

* Exportar segunda columna: MCO robusto
outreg2 using "$tablas\Tabla_Resultados_MCO.doc", append word ///
ctitle("MCO robusto") dec(4) se ///
addnote("Errores estándar entre paréntesis.", ///
"La columna MCO robusto utiliza errores estándar robustos a heterocedasticidad.", ///
"*** p<0.01, ** p<0.05, * p<0.1")

*------------------------------------------------------------
* 8. GUARDAR BASE CON VARIABLE RENOMBRADA
*------------------------------------------------------------

save "$base\base_enaho_2024_lista_para_MCO_final.dta", replace

log close
