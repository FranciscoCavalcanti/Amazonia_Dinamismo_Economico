******************************************************
**   Tabela com varias colunas por ocupacao agregada **
******************************************************

* call data 
use "$input_dir\_numero_ocupados_por_ocupacao_2digitos.dta", clear
gen group = "Amazônia Legal"
append using "$input_dir\_amz_ac_numero_ocupados_por_ocupacao_2digitos.dta"
replace group = "Acre" if group == ""
append using "$input_dir\_amz_am_numero_ocupados_por_ocupacao_2digitos.dta"
replace group = "Amazônia" if group == ""
append using "$input_dir\_amz_ap_numero_ocupados_por_ocupacao_2digitos.dta"
replace group = "Amapá" if group == ""
append using "$input_dir\_amz_ma_numero_ocupados_por_ocupacao_2digitos.dta"
replace group = "Maranhão" if group == ""
append using "$input_dir\_amz_mt_numero_ocupados_por_ocupacao_2digitos.dta"
replace group = "Mato Grosso" if group == ""
append using "$input_dir\_amz_pa_numero_ocupados_por_ocupacao_2digitos.dta"
replace group = "Pará" if group == ""
append using "$input_dir\_amz_ro_numero_ocupados_por_ocupacao_2digitos.dta"
replace group = "Rondônia" if group == ""
append using "$input_dir\_amz_rr_numero_ocupados_por_ocupacao_2digitos.dta"
replace group = "Roraima" if group == ""
append using "$input_dir\_amz_to_numero_ocupados_por_ocupacao_2digitos.dta"
replace group = "Tocantins" if group == ""

encode titulo, generate(nova_agregacao)
sort Ano Trimestre 

* generate variable of quartely date
	tostring Ano, replace
	tostring Trimestre, replace
	gen iten1 = Ano + "." + Trimestre
	gen  trim = quarterly(iten1, "YQ")
	drop iten*
		
* edit format
destring nova_agregacao, replace
format %tqCCYY trim	

drop if trim >= 240

******************************************************************
**	Numero absoluto entre trimestres de 2012 a 2020				**	
******************************************************************

drop if titulo==""

* normalize in 100
sort group titulo trim 
by group nova_agregacao, sort: gen iten1= n_ocu_cod[_n ==1]
by group nova_agregacao, sort: egen iten2=  mean(iten1)
by group nova_agregacao, sort: gen iten3=  ((n_ocu_cod)/ iten2)*100
gen normalized_n_ocu = iten3
cap drop iten*

* generate variable that uniquely identify the observations
tostring nova_agregacao, gen(iten1)
gen iten2 = group + "-"+ iten1
encode iten2, gen(iten3)
gen uniquely_identify = iten3
cap drop iten*

****** ****** ****** ****** ****** ****** ****** ****** ****** 
****** GRAFICO AGRREGADO
****** ****** ****** ****** ****** ****** ****** ****** ****** 
preserve


* Vendedores
keep if nova_agregacao == 11 /* Domésticos
	*/	| nova_agregacao == 14 /* Operários da construção, metalurgia e indústria
	*/	| nova_agregacao == 24 	/* Serviços e cuidados pessoais
	*/	| nova_agregacao == 29 	/* Vendedores
	*/ 
	
collapse (sum) n_ocu_cod,  by(trim)

* normalize in 100
sort trim 
gen iten1= n_ocu_cod[_n ==1]
egen iten2=  mean(iten1)
gen iten3=  ((n_ocu_cod)/ iten2)*100
gen normalized_n_ocu = iten3
cap drop iten*

*set scheme
set scheme amz2030  

graph twoway line normalized_n_ocu trim , lwidth(thick)	/*
		*/ 	title("", size(Medium)) 	/*
		*/	graphregion(fcolor(white)) 	/*
		*/ 	ytitle("") 	/*
		*/ 	xtitle("")	/*	
		*/	ylabel(#9, grid angle(0) ) 		/*
		*/ 	lwidth(thick) 	/*		
		*/	yscale(axis(1) range(60 160) lstyle(none) )	/* how y axis looks
		*/ 	legend(on cols(1) label(1 "Maiores ocupações") size(Small) forcesize symysize(2pt) symxsize(2pt) ) 	/*
		*/ 	xlabel(#8, angle(45)) 	/*
		*/  saving("$tmp_dir\_graph_vendedores", replace) 
		
graph use "$tmp_dir\_graph_vendedores.gph"		
erase "$tmp_dir\_graph_vendedores.gph"
graph export "$output_dir\_graph_vendedores.png", replace	

restore

****** ****** ****** ****** ****** ****** ****** ****** ****** 
****** GRAFICO DESAGREGADO
****** ****** ****** ****** ****** ****** ****** ****** ****** 
preserve

* format
*format normalized_n_ocu* %16,0fc

* Deixar ainda mais agregado 
* Vendedores
keep if nova_agregacao == 11 /* Domésticos
	*/	| nova_agregacao == 24 	/* Serviços e cuidados pessoais
	*/	| nova_agregacao == 29 	/* Vendedores
	*/ 
	

collapse (sum) n_ocu_cod,  by(trim nova_agregacao)

* normalize in 100
sort nova_agregacao trim 
by nova_agregacao, sort: gen iten1= n_ocu_cod[_n ==1]
by nova_agregacao, sort: egen iten2=  mean(iten1)
by nova_agregacao, sort: gen iten3=  ((n_ocu_cod)/ iten2)*100
gen normalized_n_ocu = iten3
cap drop iten*

* reshape data: long to wide
*reshape wide normalized_n_ocu ,  i(trim) j(uniquely_identify)	
	
display trim[33]
drop if trim >= 240

*set scheme
set scheme amz2030  

graph twoway line normalized_n_ocu trim  if nova_agregacao==11, lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==24, lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==29, lwidth(thick)	/*
		*/ 	title("", size(Medium)) 	/*
		*/	graphregion(fcolor(white)) 	/*
		*/ 	ytitle("") 	/*
		*/ 	xtitle("")	/*	
		*/	ylabel(#9, grid angle(0) ) 		/*
		*/ 	lwidth(thick) 	/*		
		*/	yscale( axis(1) range(90 170) lstyle(none) )	/* how y axis looks
		*/ 	legend(on cols(3) label(1 "Domésticos") label(2 "Serviços e cuidados pessoais") label(3 "Vendedores") size(small) forcesize symysize(2pt) symxsize(2pt) ) 	/*
		*/ 	xlabel(#9, angle(45)) 	/*
		*/  saving("$tmp_dir\_graph_vendedores_desagregado", replace) 
				
graph use "$tmp_dir\_graph_vendedores_desagregado.gph"		
erase "$tmp_dir\_graph_vendedores_desagregado.gph"
graph export "$output_dir\_graph_vendedores_desagregado.png", replace					
		
restore		
