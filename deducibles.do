
* Diseño experimental--> deducibles vehiculares


clear all
set more off
cd "D:\2026_I\1_Behavioral\TB2"

use base.dta
* Etiquetas
label define tr 0 "Control" 1 "Saliencia" 2 "Des-sesgo"
label values tratamiento tr

label define gen 0 "Mujer" 1 "Hombre"
label values genero gen

label define ded 1 "Deducible alto" 2 "Deducible medio" 3 "Deducible bajo"
label values deducible ded

label define freq 1 "1-2 días/sem" 2 "3-4 días/sem" 3 "5-6 días/sem" 4 "Diario"
label values frecuencia_manejo freq

* 1. Verificar asignación experimental
tab tratamiento

* 2. Balance de covariables basales por grupo
tabstat edad experiencia_manejo overplacement_base riesgo_percibido_base, by(tratamiento) stat(mean sd n)
tab tratamiento genero, row
tab tratamiento accidente_previo, row
tab tratamiento frecuencia_manejo, row

* 3. Distribución de elección del deducible
tab tratamiento deducible, row
tab tratamiento deducible_alto, row

* 4. Comparación simple de medias para deducible alto
reg deducible_alto i.tratamiento, vce(robust)
margins tratamiento

* 5. Modelo principal: ordered logit
ologit deducible i.tratamiento edad genero experiencia_manejo frecuencia_manejo accidente_previo overplacement_base, vce(robust)

* 6. Efectos marginales por categoría de deducible
margins tratamiento, predict(outcome(1))
margins tratamiento, predict(outcome(2))
margins tratamiento, predict(outcome(3))

* 7. Asociación exploratoria entre overplacement inicial y deducible alto
logit deducible_alto c.overplacement_base edad genero experiencia_manejo frecuencia_manejo accidente_previo, vce(robust)
margins, dydx(overplacement_base)

* 8. Manipulation check: efecto del tratamiento sobre overplacement post
reg overplacement_post i.tratamiento overplacement_base edad genero experiencia_manejo accidente_previo, vce(robust)

* 9. Manipulation check: efecto del tratamiento sobre riesgo percibido post
reg riesgo_percibido_post i.tratamiento riesgo_percibido_base edad genero experiencia_manejo accidente_previo, vce(robust)

*******************************************************
* Nota metodológica:
* La identificación causal proviene de la asignación aleatoria
* de los tratamientos. El modelo ologit estima el efecto
* sobre una variable dependiente ordinal.
*******************************************************