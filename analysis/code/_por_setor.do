******************************************************
**	 Taxas de crescimento de ocupacoes por setores	**
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
**	crescimento da media dos trimestres de 2012 a media 2019	**	
******************************************************************

* preserve
*preserve

keep if Ano == "2019" | Ano == "2012"

collapse (mean) n_de_ocupados_por_setor, by (cod_setor Ano)

drop if cod_setor=="."

sort cod_setor Ano

by cod_setor, sort: gen tx_crescimento = (n_de_ocupados_por_setor[_n]/n_de_ocupados_por_setor[_n-1])*100 -100

collapse (mean) tx_crescimento, by (cod_setor)
gsort -tx_crescimento


gen cod_setor_label = ""

replace	cod_setor_label = "Agricultura, pecuária, produção florestal, pesca e aquicultura"  if cod_setor == "1"
replace	cod_setor_label = "Indústria geral" if cod_setor == "2"
replace	cod_setor_label = "Construção" if cod_setor == "3"
replace	cod_setor_label = "Comércio, reparação de veículos automotores e motocicletas" if cod_setor == "4"
replace	cod_setor_label = "Transporte, armazenagem e correio"  if cod_setor == "5"
replace	cod_setor_label = "Alojamento e alimentação"  if cod_setor == "6"
replace	cod_setor_label = "Informação, comunicação e atividades financeiras, imobiliárias, profissionais e administrativas" if cod_setor == "7"
replace cod_setor_label = "Administração pública, defesa e seguridade social" if cod_setor == "8"
replace cod_setor_label = "Educação, saúde humana e serviços sociais" if cod_setor == "9"
replace cod_setor_label = "Outros Serviços" if cod_setor == "10"
replace cod_setor_label = "Serviços domésticos" if cod_setor == "11"
replace cod_setor_label = "Atividades mal definidas" if cod_setor == "12"

* format
format tx_crescimento %16,2fc

*gen iten1 = string(tx_crescimento, "%8.2f") + "%"
*cap drop tx_crescimento
*rename iten1 tx_crescimento

* drop irrelevant variables
* cap drop cod_setor
destring cod_setor, replace
destring tx_crescimento, replace

// transforma data em matrix
mkmat tx_crescimento, matrix(A) rownames(cod_setor_label)

* local notes
local ttitle "Número total de \textbf{formal} por setor de Indústria da Transformação - 2019"
local tnotes "Valores correspondem a média entre os trimestres da PNAD Contínua 2019"


#delim ;    
esttab matrix(A, fmt(%16,0fc)) using "$output_dir\_retrato_emprego_setor_sgap_trans_table_n_de_formal.tex", 
	replace 
	collabels("Atividade" "Taxas de crescimento de ocupações por grandes atividades")
    prehead(
        "\begin{table}[H]"
        "\centering"
		"\label{_retrato_emprego_setor_gstr_table}"
        "\begin{threeparttable}"
        "\caption{`ttitle'}"
        "\begin{tabular}{l*{@span}{r}}"
        "\midrule \midrule"
    )
    postfoot(
        "\bottomrule"
        "\end{tabular}"    
        "\begin{tablenotes}"
        "\scriptsize{Nota: `tnotes'}"
        "\end{tablenotes}"
        "\end{threeparttable}"
        "\end{table}"
    )    
	label
    unstack 
	noobs 
	nonumber 
	nomtitle 
    ;
#delim cr
