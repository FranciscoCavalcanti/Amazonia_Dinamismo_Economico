******************************************************
**	 Importancia relativa de ocupacoes por setores	**
******************************************************

* call data 
use "$input_dir\_numero_ocupados_por_setor.dta", clear

gen id = cod_setor
sort Ano Trimestre cod_setor id

* generate variable of quartely date
	tostring Ano, replace
	tostring Trimestre, replace
	gen iten1 = Ano + "." + Trimestre
	gen  trim = quarterly(iten1, "YQ")
	drop iten*
		
* edit format
cap destring id, replace
tsset id trim, quarterly 
format %tqCCYY trim	

******************************************************************
**	media dos trimestres de 2019	**	
******************************************************************

keep if Ano == "2019"

collapse (mean) n_ocu_str, by (cod_setor Ano)

drop if cod_setor=="."
drop if cod_setor==""
sort cod_setor Ano

* reshape data: long to wide
reshape wide  n_ocu_str, j(cod_setor) i(Ano)  string

* format
format n_ocu_str* %16,0fc

* Retirar o "outros" dos grandes setores econômicos no Gráfico
* Deixar ainda mais agregado 

gen iten =  n_ocu_str7 + n_ocu_str9 + n_ocu_str10 + n_ocu_str11 + n_ocu_str12
replace n_ocu_str7 = iten 
keep  n_ocu_str1 n_ocu_str2 n_ocu_str3 n_ocu_str4 n_ocu_str5 n_ocu_str6 n_ocu_str7 n_ocu_str8 

*set scheme
set scheme amz2030  
			
graph pie n_ocu_str1 n_ocu_str2 n_ocu_str3 n_ocu_str4 n_ocu_str5 n_ocu_str6 n_ocu_str7 n_ocu_str8 	/*
		*/	,  title("", size(Medium large)) 	/*
		*/	graphregion(fcolor(white)) 	/*
		*/	pie(1, color(%75) explode) 	/*
		*/	pie(2, color(%75) explode) 	/*
		*/	pie(3, color(%75) explode) 	/*	
		*/	pie(4, color(%75) explode) 	/*
		*/	pie(5, color(%75) explode) 	/*
		*/	pie(6, color(%75) explode) 	/*
		*/	pie(7, color(%75) explode) 	/*
		*/	pie(8, color(%75) explode) 	/*
		*/	legend(on position(12) ring(1) order(1 2 3 4 5 6 7 8) cols(4) label(1 "Agropecuária") label(2 "Indústria geral")  label(3 "Construção") label(4 "Comércio") label(5 "Transporte") label(6 "Alimentação") label(7 "Serviços gerais") label(8 "Administração pública") size(small) forcesize symysize(3pt) symxsize(3pt) )	/*
		*/	plabel(_all percent, gap(8) size(Medium) format(%12.1f)  lstyle(p1solid) )  	/*
		*/  saving("$tmp_dir\_importancia_relativa_pizza", replace) 	
		
* save graph 
graph use "$tmp_dir\_importancia_relativa_pizza.gph"
erase "$tmp_dir\_importancia_relativa_pizza.gph"
graph export "$output_dir\_importancia_relativa_pizza.png", replace		