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

keep if group == "Amazônia Legal"
keep if nova_agregacao == 2 | nova_agregacao == 3 | nova_agregacao == 16 | nova_agregacao == 18

collapse (sum) n_ocu_cod,  by(trim)

* normalize in 100
sort trim 
gen iten1= n_ocu_cod[_n ==1]
egen iten2=  mean(iten1)
gen iten3=  ((n_ocu_cod)/ iten2)*100
gen normalized_n_ocu = iten3
cap drop iten*

* import deforestation data from PRODES (by hand)
** see here: http://www.obt.inpe.br/OBT/assuntos/programas/amazonia/prodes
generate var4 = 4571 in 4
replace var4 = 5891 in 8
replace var4 = 5012 in 12
replace var4 = 6207 in 16
replace var4 = 7893 in 20
replace var4 = 6947 in 24
replace var4 = 7536 in 28
replace var4 = 10129 in 32

*set scheme
set scheme amz2030  

graph twoway ( line normalized_n_ocu trim, yaxis(1) lwidth(thick) )	/*
		*/	( line var4 trim, yaxis(2) lwidth(thick) ), 	/*
		*/ 	title("", size(Medium)) 	/*
		*/	graphregion(fcolor(white)) 	/* 
		*/ 	ytitle("", axis(1)) 	/*
		*/ 	ytitle("", axis(2)) 	/*
		*/ 	xtitle("")	/*	
		*/	ylabel(#9, axis(1)  angle(0) grid ) 		/*
		*/	ylabel(#9, axis(2)  angle(0) ) 		/*
		*/ 	 	/*		lwidth(thick)
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/ 	legend(on cols(2) label(1 "Agropecuária")  label(2 "Taxa de desmatamento por km2 (PRODES)")  size(Small) forcesize symysize(2pt) symxsize(2pt) ) 	/*
		*/ 	xlabel(#8, angle(45)) 	/*
		*/  saving("$tmp_dir\_graph_1", replace) 
		
graph use "$tmp_dir\_graph_1.gph"		
erase "$tmp_dir\_graph_1.gph"
graph export "$output_dir\_graph_1.png", replace	

restore

****** ****** ****** ****** ****** ****** ****** ****** ****** 
****** GRAFICO DESAGREGADO 1
****** ****** ****** ****** ****** ****** ****** ****** ****** 
preserve
* reshape data: long to wide
keep normalized_n_ocu nova_agregacao group uniquely_identify trim
*reshape wide normalized_n_ocu ,  i(trim) j(uniquely_identify)

* format
*format normalized_n_ocu* %16,0fc

* Deixar ainda mais agregado 

keep if group == "Amazônia Legal"
keep if nova_agregacao == 2 | nova_agregacao == 3 | nova_agregacao == 16 | nova_agregacao == 18

display trim[33]
drop if trim >= 240

*set scheme
set scheme amz2030  

graph twoway line normalized_n_ocu trim  if nova_agregacao==2, lwidth(thick) /*
		*/ 	title("", size(Medium)) 	/*
		*/	graphregion(fcolor(white)) 	/*
		*/ 	ytitle("") 	/*
		*/ 	xtitle("")	/*	
		*/	ylabel(#9, grid angle(0) ) 		/*
		*/ 	lwidth(thick) 	/*		
		*/	yscale( axis(1) range() lstyle(none) )	/* how y axis looks
		*/ 	legend(on cols(2) label(1 "Agricultores elementares") size(Small) forcesize symysize(2pt) symxsize(2pt) ) 	/*
		*/ 	xlabel(#8, angle(45)) 	/*
		*/  saving("$tmp_dir\_graph_21", replace) 
				
graph use "$tmp_dir\_graph_21.gph"		
erase "$tmp_dir\_graph_21.gph"
graph export "$output_dir\_graph_21.png", replace					


****** ****** ****** ****** ****** ****** ****** ****** ****** 
****** GRAFICO DESAGREGADO 2
****** ****** ****** ****** ****** ****** ****** ****** ****** 

graph twoway line normalized_n_ocu trim  if nova_agregacao==2, lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==3, lwidth(thick)  /*
		*/ 	title("", size(Medium)) 	/*
		*/	graphregion(fcolor(white)) 	/*
		*/ 	ytitle("") 	/*
		*/ 	xtitle("")	/*	
		*/	ylabel(#9, grid angle(0) ) 		/*
		*/ 	lwidth(thick) 	/*		
		*/	yscale( axis(1) range() lstyle(none) )	/* how y axis looks
		*/ 	legend(on cols(2) label(1 "Agricultores elementares") label(2 "Agricultores qualificados") size(Small) forcesize symysize(2pt) symxsize(2pt) ) 	/*
		*/ 	xlabel(#8, angle(45)) 	/*
		*/  saving("$tmp_dir\_graph_22", replace) 
				
graph use "$tmp_dir\_graph_22.gph"		
erase "$tmp_dir\_graph_22.gph"
graph export "$output_dir\_graph_22.png", replace					

****** ****** ****** ****** ****** ****** ****** ****** ****** 
****** GRAFICO DESAGREGADO 3
****** ****** ****** ****** ****** ****** ****** ****** ******

graph twoway line normalized_n_ocu trim  if nova_agregacao==2, lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==3, lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==16, lwidth(thick) /*
		*/ 	title("", size(Medium)) 	/*
		*/	graphregion(fcolor(white)) 	/*
		*/ 	ytitle("") 	/*
		*/ 	xtitle("")	/*	
		*/	ylabel(#9, grid angle(0) ) 		/*
		*/ 	lwidth(thick) 	/*		
		*/	yscale( axis(1) range() lstyle(none) )	/* how y axis looks
		*/ 	legend(on cols(2) label(1 "Agricultores elementares") label(2 "Agricultores qualificados")  label(3 "Pecuaristas e criadores de animais") size(Small) forcesize symysize(2pt) symxsize(2pt) ) 	/*
		*/ 	xlabel(#8, angle(45)) 	/*
		*/  saving("$tmp_dir\_graph_23", replace) 
				
graph use "$tmp_dir\_graph_23.gph"		
erase "$tmp_dir\_graph_23.gph"
graph export "$output_dir\_graph_23.png", replace					
		
****** ****** ****** ****** ****** ****** ****** ****** ****** 
****** GRAFICO DESAGREGADO 4
****** ****** ****** ****** ****** ****** ****** ****** ****** 

graph twoway line normalized_n_ocu trim  if nova_agregacao==2, lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==3, lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==16, lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim if nova_agregacao==18, lwidth(thick)	/*
		*/ 	title("", size(Medium)) 	/*
		*/	graphregion(fcolor(white)) 	/*
		*/ 	ytitle("") 	/*
		*/ 	xtitle("")	/*	
		*/	ylabel(#9, grid angle(0) ) 		/*
		*/ 	lwidth(thick) 	/*		
		*/	yscale( axis(1) range() lstyle(none) )	/* how y axis looks
		*/ 	legend(on cols(2) label(1 "Agricultores elementares") label(2 "Agricultores qualificados")  label(3 "Pecuaristas e criadores de animais") label(4 "Produtores florestais") size(Small) forcesize symysize(2pt) symxsize(2pt) ) 	/*
		*/ 	xlabel(#8, angle(45)) 	/*
		*/  saving("$tmp_dir\_graph_24", replace) 
				
graph use "$tmp_dir\_graph_24.gph"		
erase "$tmp_dir\_graph_24.gph"
graph export "$output_dir\_graph_24.png", replace					
		
restore		

****** ****** ****** ****** ****** ****** ****** ****** ****** 
****** GRAFICO DESAGREGADO POR ESTADO
****** ****** ****** ****** ****** ****** ****** ****** ****** 
preserve


* reshape data: long to wide
keep normalized_n_ocu nova_agregacao group uniquely_identify trim
*reshape wide normalized_n_ocu ,  i(trim) j(uniquely_identify)

* format
*format normalized_n_ocu* %16,0fc

* Deixar ainda mais agregado 

drop if group == "Amazônia Legal"
keep if nova_agregacao == 2 | nova_agregacao == 3 | nova_agregacao == 16 | nova_agregacao == 18

*set scheme
set scheme amz2030  

graph twoway line normalized_n_ocu trim  if nova_agregacao==2 & group =="Acre", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==2 & group =="Amapá", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==2 & group =="Amazônia", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==2 & group =="Maranhão", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==2 & group =="Mato Grosso", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==2 & group =="Pará", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==2 & group =="Rondônia", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==2 & group =="Roraima", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==2 & group =="Tocantins", lwidth(thick)	/*
		*/ 	title("", size(Medium)) 	/*
		*/	graphregion(fcolor(white)) 	/*
		*/ 	ytitle("") 	/*
		*/ 	xtitle("")	/*	
		*/	ylabel(#9, grid angle(0) ) 		/*
		*/ 	lwidth(thick) 	/*		
		*/	yscale( axis(1) range() lstyle(none) )	/* how y axis looks
		*/ 	legend(on cols(5) label(1 "Acre") label(2 "Amapá")  label(3 "Amazônia") label(4 "Maranhão") label(5 "Mato Grosso") label(6 "Pará") label(7 "Rondônia") label(8 "Roraima") label(9 "Tocantins") size(Small) forcesize symysize(2pt) symxsize(2pt) ) 	/*
		*/ 	xlabel(#8, angle(45)) 	/*
		*/  saving("$tmp_dir\_graph_31", replace) 
		
graph use "$tmp_dir\_graph_31.gph"		
erase "$tmp_dir\_graph_31.gph"
graph export "$output_dir\_graph_31.png", replace		
		
		

graph twoway line normalized_n_ocu trim  if nova_agregacao==3 & group =="Acre", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==3 & group =="Amapá", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==3 & group =="Amazônia", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==3 & group =="Maranhão", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==3 & group =="Mato Grosso", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==3 & group =="Pará", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==3 & group =="Rondônia", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==3 & group =="Roraima", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==3 & group =="Tocantins", lwidth(thick)	/*
		*/ 	title("", size(Medium)) 	/*
		*/	graphregion(fcolor(white)) 	/*
		*/ 	ytitle("") 	/*
		*/ 	xtitle("")	/*	
		*/	ylabel(#9, grid angle(0) ) 		/*
		*/ 	lwidth(thick) 	/*		
		*/	yscale( axis(1) range() lstyle(none) )	/* how y axis looks
		*/ 	legend(on cols(5) label(1 "Acre") label(2 "Amapá")  label(3 "Amazônia") label(4 "Maranhão") label(5 "Mato Grosso") label(6 "Pará") label(7 "Rondônia") label(8 "Roraima") label(9 "Tocantins") size(Small) forcesize symysize(2pt) symxsize(2pt) ) 	/*
		*/ 	xlabel(#8, angle(45)) 	/*
		*/  saving("$tmp_dir\_graph_32", replace) 
		
graph use "$tmp_dir\_graph_32.gph"		
erase "$tmp_dir\_graph_32.gph"
graph export "$output_dir\_graph_32.png", replace		
		
		
graph twoway line normalized_n_ocu trim  if nova_agregacao==16 & group =="Acre", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==16 & group =="Amapá", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==16 & group =="Amazônia", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==16 & group =="Maranhão", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==16 & group =="Mato Grosso", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==16 & group =="Pará", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==16 & group =="Rondônia", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==16 & group =="Roraima", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==16 & group =="Tocantins", lwidth(thick)	/*
		*/ 	title("", size(Medium)) 	/*
		*/	graphregion(fcolor(white)) 	/*
		*/ 	ytitle("") 	/*
		*/ 	xtitle("")	/*	
		*/	ylabel(#9, grid angle(0) ) 		/*
		*/ 	lwidth(thick) 	/*		
		*/	yscale( axis(1) range() lstyle(none) )	/* how y axis looks
		*/ 	legend(on cols(5) label(1 "Acre") label(2 "Amapá")  label(3 "Amazônia") label(4 "Maranhão") label(5 "Mato Grosso") label(6 "Pará") label(7 "Rondônia") label(8 "Roraima") label(9 "Tocantins") size(Small) forcesize symysize(2pt) symxsize(2pt) ) 	/*
		*/ 	xlabel(#8, angle(45)) 	/*
		*/  saving("$tmp_dir\_graph_33", replace) 	
		
graph use "$tmp_dir\_graph_33.gph"		
erase "$tmp_dir\_graph_33.gph"
graph export "$output_dir\_graph_33.png", replace		
		
graph twoway line normalized_n_ocu trim  if nova_agregacao==18 & group =="Acre", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==18 & group =="Amapá", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==18 & group =="Amazônia", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==18 & group =="Maranhão", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==18 & group =="Mato Grosso", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==18 & group =="Pará", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==18 & group =="Rondônia", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==18 & group =="Roraima", lwidth(thick) || /*
		*/ 	line normalized_n_ocu trim  if nova_agregacao==18 & group =="Tocantins", lwidth(thick)	/*
		*/ 	title("", size(Medium)) 	/*
		*/	graphregion(fcolor(white)) 	/*
		*/ 	ytitle("") 	/*
		*/ 	xtitle("")	/*	
		*/	ylabel(#9, grid angle(0) ) 		/*
		*/ 	lwidth(thick) 	/*		
		*/	yscale( axis(1) range() lstyle(none) )	/* how y axis looks
		*/ 	legend(on cols(5) label(1 "Acre") label(2 "Amapá")  label(3 "Amazônia") label(4 "Maranhão") label(5 "Mato Grosso") label(6 "Pará") label(7 "Rondônia") label(8 "Roraima") label(9 "Tocantins") size(Small) forcesize symysize(2pt) symxsize(2pt) ) 	/*
		*/ 	xlabel(#8, angle(45)) 	/*
		*/  saving("$tmp_dir\_graph_34", replace) 
		
graph use "$tmp_dir\_graph_34.gph"		
erase "$tmp_dir\_graph_34.gph"
graph export "$output_dir\_graph_34.png", replace		
		
restore