******************************************************
**	 Taxas de crescimento de massa de rendimentos por ocupacao  **
******************************************************

* call data 
use "$input_dir\_amz_to_numero_ocupados_por_ocupacao_2digitos.dta", clear
gen id = cod_cod2dig
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

collapse (mean) massa_salarial, by (cod_cod2dig Ano)

* keep only observations that exist in 2019 and 2012
by cod_cod2dig, sort: gen leao1 =_n
by cod_cod2dig, sort: egen leao2 =max(leao1)
keep if leao2==2
drop leao*

drop if cod_cod2dig=="."
drop if cod_cod2dig==""
drop if cod_cod2dig=="0"

sort cod_cod2dig Ano

by cod_cod2dig, sort: gen delta_v = (massa_salarial[_n] - massa_salarial[_n-1])

collapse (mean) delta_v, by (cod_cod2dig)
sort delta_v

* merge with auxiliar data base
merge 1:1 cod_cod2dig using "$input_dir\cod_cod2dig.dta"
drop _merge
compress

* drop vague names
do "$code_dir\_sub_code\_drop_vague_names.do"

gsort -delta_v

drop if _n>20

* format
format delta_v %16,0fc

// transforma data em matrix
mkmat delta_v, matrix(A) rownames(cod_cod2dig)

* local notes
local ttitle "Variação da massa de rendimentos por tipo de ocupação entre 2012 e 2019"
local tnotes "Fonte: com base nos dados da PNAD Contínua, IBGE"

#delim ;    
esttab matrix(A, fmt(%16,2fc)) using "$output_dir\amztorkngvmassaporcod2dig.tex", 
	replace 
	collabels("{R\\$}")
    prehead(
        "\begin{table}[H]"
        "\centering"
		"\label{amztorkngvmassaporcod2dig}"
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
        coeflabels(
            01  "Oficiais Das Forças Armadas"
            02  "Graduados e Praças Das Forças Armadas"
            04  "Policiais Militares"
            05  "Bombeiros Militares"
            11  "Diretores Executivos, Dirigentes da Administração Pública e Membros do Poder Executivo e Legislativo"
            12  "Dirigentes Administrativos e Comerciais"
            13  "Dirigentes e Gerentes de Produção e Operação"
            14  "Gerentes de Hotéis, Restaurantes, Comércios e Outros Serviços"
            21  "Gerentes de Hotéis, Restaurantes, Comércios e Outros Serviços"
            22  "Profissionais da Saúde"
            23  "Profissionais do Ensino"
            24  "Especialistas em Organização da Administração Pública e de Empresas"
            25  "Profissionais de Tecnologias da Informação e Comunicações"
            26  "Profissionais  em Direito, em Ciências Sociais e Culturais"
            31  "Profissionais de Nível Médio Das Ciências e da Engenharia"
            32  "Profissionais de Nível Médio da Saúde e Afins"
            33  "Profissionais de Nível Médio em Operações Financeiras e Administrativas"
            34  "Profissionais de Nível Médio de Serviços Jurídicos, Sociais, Culturais e Afins"
            35  "TéCnicos de Nível Médio da Tecnologia da Informação e Das Comunicações"
            41  "Escriturários"
            42  "Trabalhadores de Atendimento Direto Ao Público"
            43  "Trabalhadores de Cálculos Numéricos e Encarregados do Registro de Materiais"
            44  "Outros Trabalhadores de Apoio Administrativo "
            51  "Trabalhadores Dos Serviços Pessoais"
            52  "Vendedores"
            53  "Trabalhadores Dos Cuidados Pessoais"
            54  "Trabalhadores Dos Serviços de Proteção e Segurança"
            61  "Agricultores e Trabalhadores Qualificados da Agropecuária"
            62  "Trabalhadores Florestais Qualificados, Pescadores e Caçadores"
            71  "Trabalhadores Qualificados e Operários da Construção Exclusive Eletricistas"
            72  "Trabalhadores Qualificados e Operários da Metalurgia, da Construção Mecânica e Afins "
            73  "Artesãos e Operários Das Artes Gráficas"
            74  "Trabalhadores Especializados em Eletricidade e Eletrônica"
            75  "Operários e Oficiais de Processamento de Alimentos, da Madeira, da Confecção e Afins "
            81  "Operadores de Instalações Fixas e Máquinas"
            82  "Montadores"
            83  "Condutores de Veículos e Operadores de Equipamentos Móveis Pesados"
            91  "Trabalhadores Domésticos e Outros Trabalhadores de Limpeza de Interior de Edifícios"
            92  "Trabalhadores Elementares da Agropecuária, da Pesca e Florestais "
            93  "Trabalhadores Elementares da Mineração, da Construção, da Indústria de Transformação e do Transporte "
            94  "Ajudantes de Preparação de Alimentos "
            95  "Trabalhadores Ambulantes Dos Serviços e Afins"
            96  "Coletores de Lixo e Outras Ocupações Elementares"
    ) 
    ;
#delim cr

