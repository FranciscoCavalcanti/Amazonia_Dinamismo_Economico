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
**	Numero absoluto entre trimestres de 2012 a 2020				**	
******************************************************************

drop if cod_setor=="."
sort cod_setor trim

* reshape data: long to wide
keep n_ocu_str id trim
reshape wide n_ocu_str,  i(trim) j(id)

* format
format n_ocu_str* %16,0fc

*set scheme
set scheme amz2030  
			
	graph twoway line n_ocu_str1 n_ocu_str2 n_ocu_str3 n_ocu_str4 n_ocu_str5 n_ocu_str6 n_ocu_str7 n_ocu_str8 n_ocu_str9 n_ocu_str10 n_ocu_str11 n_ocu_str12 trim  /*
		*/ 	,  title("", size(Medium)) 	/*
		*/	graphregion(fcolor(white)) 	/*
		*/ 	ytitle("") 	/*
		*/ 	xtitle("")	/*	
		*/	ylabel(#9, angle(0) ) 		/*
		*/ 	lwidth(thick thick thick thick thick thick thick thick thick thick thick thick) 	/*		
		*/	yscale( axis(1) range(0) lstyle(none) )	/* how y axis looks
		*/ 	legend(on cols(4) label(1 "Agropecuária") label(2 "Indústria geral")  label(3 "Construção") label(4 "Comércio") label(5 "Transporte") label(6 "Alimentação") label(7 "Informação") label(8 "Administração pública") label(9 "Serviços sociais") label(10 "Demais Serviços") label(11 "Serviços domésticos") label(12 "Outros") size(small) forcesize symysize(2pt) symxsize(2pt) ) 	/*
		*/ 	xlabel(#8, grid angle(45)) 	/*
		*/  saving("$tmp_dir\_importancia_relativa", replace) 	
		
		
* save graph 
graph use "$tmp_dir\_importancia_relativa.gph"
erase "$tmp_dir\_importancia_relativa.gph"
graph export "$output_dir\_importancia_relativa.png", replace		