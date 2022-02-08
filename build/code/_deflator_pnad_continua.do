//////////////////////////////////////////////
//	
//	Deflator da pnad continua
//	
//////////////////////////////////////////////

* call data deflator_PNADC_2021_trimestral_070809
import excel "$input_pnadcdoc\deflator_PNADC_2021_trimestral_070809.xls", sheet("deflator") firstrow allstring clear

* clean data
cap gen Trimestre = ""

replace Trimestre = "1" if trim == "01-02-03"
replace Trimestre = "1" if trim == "02-03-04"
replace Trimestre = "1" if trim == "03-04-05"

replace Trimestre = "2" if trim == "04-05-06"
replace Trimestre = "2" if trim == "05-06-07"
replace Trimestre = "2" if trim == "06-07-08"

replace Trimestre = "3" if trim == "07-08-09"
replace Trimestre = "3" if trim == "08-09-10"
replace Trimestre = "3" if trim == "09-10-11"

replace Trimestre = "4" if trim == "10-11-12"
replace Trimestre = "4" if trim == "11-12-01"
replace Trimestre = "4" if trim == "12-01-02"

gen deflator_habitual = Habitual
gen deflator_efetivo = Efetivo

cap destring deflator_habitual, replace
cap destring deflator_efetivo, replace

*
collapse (mean) deflator_habitual deflator_efetivo, by(Ano Trimestre UF)

cap destring Ano, replace
cap destring UF, replace

* save in the output directory
compress
save "$output_dir\_deflator_pnad_continua.dta", replace