******************************************************
**	 Taxas de crescimento de ocupacoes por ocupacao	**
******************************************************

* call data 
use "$input_dir\_numero_ocupados_por_ocupacao.dta", clear
gen id = cod_ocupacao
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

collapse (mean) n_de_ocupados_por_ocupacao, by (cod_ocupacao Ano)

drop if cod_ocupacao=="."
drop if cod_ocupacao==""
drop if cod_ocupacao=="0"

sort cod_ocupacao Ano

by cod_ocupacao, sort: gen tx_crescimento = (n_de_ocupados_por_ocupacao[_n]/n_de_ocupados_por_ocupacao[_n-1])*100 -100

collapse (mean) tx_crescimento, by (cod_ocupacao)
sort tx_crescimento

* edit to merge
gen lgth=length(cod_ocupacao)
gen apnd = "" if  lgth==4
replace apnd = "0" if  lgth==3
replace apnd = "00" if  lgth==2
replace apnd = "000" if  lgth==1
replace apnd = "0000" if  lgth==0

gen aux1 = apnd + cod_ocupacao
replace cod_ocupacao = aux1
cap drop aux1 apnd lgth 

* merge with auxiliar data base
merge 1:1 cod_ocupacao using "$input_dir\cod_ocupacao.dta"
drop _merge
compress
gsort -tx_crescimento

