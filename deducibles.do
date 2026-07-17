clear all
set more off

use "C:\Users\ALEX\Downloads\Bases METRIA\enaho01a-2024-500.dta", clear

merge 1:1 conglome vivienda hogar codperso using "C:\Users\ALEX\Downloads\Bases METRIA\enaho01a-2024-300.dta"
 
tab _merge
keep if _merge == 3
drop _merge
//p208 años de la persona 
 keep if p208a >= 14 & p208a <= 65
lookfor ingreso
lookfor ocupado
//p501: trabajó la semana pasada.
//p502: no trabajó, pero tenía empleo.
//p503: hizo alguna actividad laboral menor o eventua
tab p501
tab p502
tab p503
//definir ocupados 
gen ocupado = (p501==1 | p502==1 | p503==1)
keep if ocupado == 1
*Según el diccionario de la Enaho-500, la variable i524a1 representa el ingreso total anual
drop if missing(i524a1) | i524a1 == 0 // Eliminamos todos los datos perdidos
//ingresos positivos 
keep if i524a1 > 0

//-------------------------------------------------------------------------------------
// CONSTRUCCIÓN DE VARIABLES

// 1. Variable mujer (dummy)
gen mujer = (p207 == 2) if p207 != .
label variable mujer "1 = Mujer, 0 = Hombre"

// 2. Variable sector privado (Dummy)

keep if p510 == 1 | p510 == 2 | p510 == 3 | p510 == 5 | p510 == 6
gen privado = .
replace privado = 0 if p510 == 1 | p510 == 2 | p510 == 3  // 0 = Sector Público (FF.AA., Admin y Empresa Pública)
replace privado = 1 if p510 == 5 | p510 == 6              // 1 = Sector Privado (Services y Patrono Privado)

label variable privado "1 = Sector Privado, 0 = Sector Público"
label define lbl_sector 0 "Sector Público" 1 "Sector Privado"
label values privado lbl_sector

// 3. Años de educación(Educ_Años)
// Usamos p301a (nivel educativo) y p301b (año/grado de estudios)
gen educ_años = .

// Sin nivel, Inicial o Básica Especial (Categorías 1, 2 y 12)
replace educ_años = 0 if p301a == 1 | p301a == 2 | p301a == 12

// Primaria Incompleta (Cat 3): Sumamos el último grado aprobado
replace educ_años = p301b if p301a == 3 & p301b != .

// Primaria Completa (Cat 4): 6 años fijos
replace educ_años = 6 if p301a == 4

// Secundaria Incompleta (Cat 5): 6 años de primaria + grados aprobados en secundaria
replace educ_años = 6 + p301b if p301a == 5 & p301b != .

// Secundaria Completa (Cat 6): 11 años fijos (6 prim + 5 secu)
replace educ_años = 11 if p301a == 6

// Superior No Universitaria Incompleta (Cat 7): 11 años + años técnicos
replace educ_años = 11 + p301b if p301a == 7 & p301b != .

// Superior No Universitaria Completa (Cat 8): Asumimos 3 años de carrera técnica
replace educ_años = 14 if p301a == 8

// Superior Universitaria Incompleta (Cat 9): 11 años + años en la universidad
replace educ_años = 11 + p301b if p301a == 9 & p301b != .

// Superior Universitaria Completa (Cat 10): 16 años fijos (11 + 5 de carrera)
replace educ_años = 16 if p301a == 10

// Maestría / Doctorado (Cat 11): 16 años de universidad + años de posgrado
replace educ_años = 16 + p301b if p301a == 11 & p301b != .

// Eliminamos a quienes no declararon educación (missings)
drop if educ_años == .
label variable educ_años "Años de educación formal acumulados"

// 4. Experiencia laboral potencial y experiencia potencial al cuadrado
//Edad (p208a) - Años de educación - 6 (representa la edad estimada a la que se inicia la etapa escolar)
gen exper = p208a - educ_años - 6
replace exper = 0 if exper < 0
gen exper2 = exper^2

label variable exper "Experiencia laboral potencial"
label variable exper2 "Experiencia potencial al cuadrado"

// 5. Logaritmo del salario por hora

* Primero, calculamos el salario por hora neto correcto:
* Dividimos el ingreso ANUAL (i524a1) entre las horas trabajadas al AÑO (semanales * 52)
gen sal_hora = i524a1 / (p513t * 52)
drop if sal_hora <= 0 | sal_hora == .
gen ln_salario = ln(sal_hora)

label variable ln_salario "Logaritmo natural del salario por hora"

// 6. Tabla de estadisticos descriptivos
sum ln_salario educ_años exper exper2 mujer privado
save "C:\Users\ALEX\Downloads\Bases METRIA\base_enaho_2024_lista_para_MCO.dta", replace
