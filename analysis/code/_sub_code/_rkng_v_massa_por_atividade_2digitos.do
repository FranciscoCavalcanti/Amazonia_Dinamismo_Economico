******************************************************
**	 Taxas de crescimento de massa de rendimentos por grupamentos de atividade	**
******************************************************

* call data 
use "$input_dir\_numero_ocupados_por_atividade_2digitos.dta", clear
encode titulo, generate(id)
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

collapse (mean) massa_salarial, by (titulo Ano)

* keep only observations that exist in 2019 and 2012
by titulo, sort: gen leao1 =_n
by titulo, sort: egen leao2 =max(leao1)
keep if leao2==2
drop leao*

drop if titulo=="."
drop if titulo==""
drop if titulo=="0"

sort titulo Ano

by titulo, sort: gen delta_v = (massa_salarial[_n] - massa_salarial[_n-1])

collapse (mean) delta_v, by (titulo)
sort delta_v

* merge with auxiliar data base
merge 1:1 cod_cnae2dig using "$input_dir\cod_cnae2dig.dta"
drop _merge
compress

* drop vague names
do "$code_dir\_sub_code\_drop_vague_names.do"

gsort -delta_v


* format
format delta_v %16,0fc

// transforma data em matrix
encode titulo, generate(nova_agregacao)
mkmat delta_v, matrix(A) rownames(nova_agregacao)

* local notes
local ttitle "Variação da massa de rendimentos por grupamentos de atividade entre 2012 e 2019"
local tnotes "Fonte: com base nos dados da PNAD Contínua, IBGE"

#delim ;    
esttab matrix(A, fmt(%16,2fc)) using "$output_dir\rkngvmassaporcnae2dig.tex", 
	replace 
	collabels("{R\\$}")
    prehead(
        "\begin{table}[H]"
        "\centering"
		"\label{rkngvmassaporcnae2dig}"
		"\scalebox{0.70}{"
        "\begin{threeparttable}"
        "\caption{`ttitle'}"		
        "\begin{tabular}{l*{@span}{r}}"
        "\midrule \midrule"
    )
    postfoot(
        "\bottomrule"
        "\end{tabular}"		
        "\begin{tablenotes}"
        "\item \scriptsize{`tnotes'}"
        "\end{tablenotes}"
        "\end{threeparttable}"
		"}"
        "\end{table}"
    )    
	label
    unstack 
	noobs 
	nonumber 
	nomtitle
	coeflabels(   /* run the follwing code:  label list nova_agregacao */
           1 "Administração pública, defesa e seguridade social"
           2 "Agricultura"
           3 "Alimentação"
           4 "Alimentos, bebidas e fumo"
           5 "Artes, cultura, esportes e recreação"
           6 "Atividades profissionais, científicas e técnicas"
           7 "Automóveis e equipamentos de transporte"
           8 "Comércio"
           9 "Construção"
          10 "Educação"
          11 "Eletricidade, gás, água e esgoto"
          12 "Eletrônicos, máquinas e equipamentos"
          13 "Eletrônicos, máquinas e equipamentos "
          14 "Estadia e turismo"
          15 "Extração mineral e de carvão, petróleo e gás"
          16 "Madeira, celulose e papel"
          17 "Móveis"
          18 "Organizações religiosas, sindicais e patronais"
          19 "Outros"
          20 "Pecuária"
          21 "Pesca e aquicultura"
          22 "Produtos de metal, minerais não-metálicos e metalurgia"
          23 "Produção florestal"
          24 "Químicos, farmacêuticos, borracha e plástico"
          25 "Saúde e assistência social"
          26 "Segurança e edifícios"
          27 "Serviços de escritório"
          28 "Serviços de informação e comunicação"
          29 "Serviços domésticos"
          30 "Serviços financeiros e de seguros"
          31 "Serviços pessoais (cabelereiros, lavanderias, etc.)"
          32 "Terceirização de mão-de-obra"
          33 "Transporte e correio"
          34 "Têxtil, vestuário, couro e calçados"
		  )
    ;
#delim cr

