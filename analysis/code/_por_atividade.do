******************************************************
**	 Taxas de crescimento de ocupacoes por atividade	**
******************************************************

* call data 
use "$input_dir\_numero_ocupados_por_atividade.dta", clear
gen id = cod_atividade
sort Ano Trimestre 

* generate variable of quartely date
	tostring Ano, replace
	tostring Trimestre, replace
	gen iten1 = Ano + "." + Trimestre
	gen  trim = quarterly(iten1, "YQ")
	drop iten*
		
* edit format
destring id, replace
tsset id trim, quarterly 
format %tqCCYY trim	


******************************************************************
**	crescimento da media dos trimestres de 2012 a media 2019	**	
******************************************************************

* preserve
*preserve

keep if Ano == "2019" | Ano == "2012"

collapse (mean) n_de_ocupados_por_atividade, by (cod_atividade Ano)

drop if cod_atividade=="."
drop if cod_atividade==""
drop if cod_atividade=="0"

sort cod_atividade Ano

by cod_atividade, sort: gen tx_crescimento = (n_de_ocupados_por_atividade[_n]/n_de_ocupados_por_atividade[_n-1])*100 -100

collapse (mean) tx_crescimento, by (cod_atividade)
sort tx_crescimento

* edit to merge
gen lgth=length(cod_atividade)
gen apnd = "" if  lgth==5
replace apnd = "0" if  lgth==4
replace apnd = "00" if  lgth==3
replace apnd = "000" if  lgth==2
replace apnd = "0000" if  lgth==1
replace apnd = "00000" if  lgth==0
gen aux1 = apnd + cod_atividade
replace cod_atividade = aux1
cap drop aux1 apnd lgth 

* merge with auxiliar data base
merge 1:1 cod_atividade using "$input_dir\cod_atividade.dta"
drop _merge
compress
gsort -tx_crescimento

