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
keep n_de_ocupados_por_setor id trim
reshape wide n_de_ocupados_por_setor,  i(trim) j(id)

*set scheme
set scheme amz2030  
			
	graph twoway line n_de_ocupados_por_setor1 n_de_ocupados_por_setor2 n_de_ocupados_por_setor3 n_de_ocupados_por_setor4 n_de_ocupados_por_setor5 n_de_ocupados_por_setor6 n_de_ocupados_por_setor7 n_de_ocupados_por_setor8 n_de_ocupados_por_setor9 n_de_ocupados_por_setor10 n_de_ocupados_por_setor11 n_de_ocupados_por_setor12 trim  /*
		*/ 	,  title("", size(Medium)) 	/*
		*/	graphregion(fcolor(white)) 	/*
		*/ 	ytitle("") 	/*
		*/ 	xtitle("")	/*	
		*/	ylabel(#9, angle(0) ) 		/*
		*/ 	lwidth(thick thick thick thick thick thick thick thick thick thick thick thick) 	/*		
		*/	yscale( axis(1) range(0) lstyle(none) )	/* how y axis looks
		*/ 	legend(on cols(4) label(1 "Agropecuária") label(2 "Indústria geral")  label(3 "Construção") label(4 "Comércio") label(5 "Transporte, armazenagem e correio") label(6 "Alojamento e alimentação") label(7 "Informação e atividades financeiras") label(8 "Administração pública") label(9 "Serviços sociais") label(10 "Outros Serviços") label(11 "Serviços domésticos") label(12 "Atividades mal definidas") size(vsmall) forcesize symysize(3pt) symxsize(3pt) ) 	/*
		*/ 	xlabel(#8, grid angle(45)) 	/*
		*/  saving("$tmp_dir\importancia_relativa", replace) 	
		
		
* save graph 
graph use "$tmp_dir\importancia_relativa.gph"
erase "$tmp_dir\importancia_relativa.gph"
graph export "$output_dir\importancia_relativa.png", replace		