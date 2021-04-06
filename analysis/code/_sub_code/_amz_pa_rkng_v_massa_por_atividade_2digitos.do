******************************************************
**	 Taxas de crescimento de massa de rendimentos por grupamentos de atividade	**
******************************************************

* call data 
use "$input_dir\_amz_pa_numero_ocupados_por_atividade_2digitos.dta", clear
gen id = cod_cnae2dig
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

collapse (mean) massa_salarial, by (cod_cnae2dig Ano)

* keep only observations that exist in 2019 and 2012
by cod_cnae2dig, sort: gen leao1 =_n
by cod_cnae2dig, sort: egen leao2 =max(leao1)
keep if leao2==2
drop leao*

drop if cod_cnae2dig=="."
drop if cod_cnae2dig==""
drop if cod_cnae2dig=="0"

sort cod_cnae2dig Ano

by cod_cnae2dig, sort: gen delta_v = (massa_salarial[_n] - massa_salarial[_n-1])

collapse (mean) delta_v, by (cod_cnae2dig)
sort delta_v

* merge with auxiliar data base
merge 1:1 cod_cnae2dig using "$input_dir\cod_cnae2dig.dta"
drop _merge
compress

* drop vague names
do "$code_dir\_sub_code\_drop_vague_names.do"

gsort -delta_v

drop if _n>20

* format
format delta_v %16,0fc

// transforma data em matrix
mkmat delta_v, matrix(A) rownames(cod_cnae2dig)

* local notes
local ttitle "Variação da massa de rendimentos por grupamentos de atividade entre 2012 e 2019"
local tnotes "Fonte: com base nos dados da PNAD Contínua, IBGE"

#delim ;    
esttab matrix(A, fmt(%16,2fc)) using "$output_dir\amzparkngvmassaporcnae2dig.tex", 
	replace 
	collabels("{R\\$}")
    prehead(
        "\begin{table}[H]"
        "\centering"
		"\label{amzparkngvmassaporcnae2dig}"
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
        00     "Atividades Mal Definidas"
        01     "Agricultura, Pecuária, Caça e Serviços Relacionados "
        02     "Produção Florestal"
        03     "Pesca e AqÜIcultura"
        05     "Extração De Carvão Mineral"
        06     "Extração De Petróleo e Gás Natural"
        07     "Extração De Minerais Metálicos"
        08     "Extração De Minerais Não-Metálicos"
        09     "Atividades De Apoio à Extração De Minerais"
        10     "Fabricação De Produtos Alimentícios "
        11     "Fabricação De Bebidas"
        12     "Fabricação De Produtos Do Fumo"
        13     "Fabricação De Produtos Têxteis"
        14     "Confecção De Artigos Do Vestuário e Acessórios"
        15     "Preparação De Couros e Fabricação De Artefatos De Couro, Artigos De Viagem e Calçados"
        16     "Fabricação De Produtos De Madeira"
        17     "Fabricação De Celulose, Papel e Produtos De Papel"
        18     "Impressão e Reprodução De Gravações"
        19     "Fabricação De Coque; Produtos Derivados De Petróleo e De Biocombustíveis"
        20     "Fabricação De Produtos Químicos"
        21     "Fabricação De Produtos Farmoquímicos e Farmacêuticos"
        22     "Fabricação De Produtos De Borracha e De Material Plástico   "
        23     "Fabricação De Produtos De Minerais Não-Metálicos"
        24     "Metalurgia"
        25     "Fabricação De Produtos De Metal, Exceto Máquinas e Equipamentos"
        26     "Fabricação De Equipamentos De InformáTica, Produtos Eletrônicos e ópticos"
        27     "Fabricação De Máquinas, Aparelhos e Materiais Elétricos "
        28     "Fabricação De Máquinas e Equipamentos"
        29     "Fabricação De Veículos Automotores, Reboques e Carrocerias"
        30     "Fabricação De Outros Equipamentos De Transporte, Exceto Veículos Automotores"
        31     "Fabricação De Móveis"
        32     "Fabricação De Produtos Diversos"
        33     "Manutenção, Reparação e Instalação De Máquinas e Equipamentos"
        35     "Eletricidade, Gás e Outras Utilidades"
        36     "Captação, Tratamento e Distribuição De Água"
        37     "Esgoto e Atividades Relacionadas"
        38     "Coleta, Tratamento e Disposição De Resíduos; Recuperação De Materiais"
        39     "Descontaminação e Outros Serviços De Gestão De Resíduos"
        41     "Construção e Incorporação De Edifícios"
        42     "Obras De Infra-Estrutura"
        43     "Serviços Especializados Para Construção"
        45     "Comércio e Reparação De Veículos Automotores e Motocicletas"
        48     "Comércio, Exceto De Veiculos Automotores e Motocicletas"
        49     "Transporte Terrestre"
        50     "Transporte Aquaviário"
        51     "Transporte Aéreo"
        52     "Armazenamento e Atividades Auxiliares Dos Transportes"
        53     "Correio e Outras Atividades De Entrega"
        55     "Alojamento"
        56     "Alimentação"
        58     "Edição e Edição Integrada a Impressão"
        59     "Atividades Cinematográficas, Produção De Vídeos e De Programas De Televisão; Gravação De Som e De Música"
        60     "Atividades De Rádio e De Televisão"
        61     "Telecomunicações"
        62     "Atividades Dos Serviços De Tecnologia Da Informação"
        63     "Atividades De Prestação De Serviços De Informação"
        64     "Atividades De Serviços Financeiros"
        65     "Seguros, Resseguros, Previdência Complementar e Planos De Saúde "
        66     "Atividades Auxiliares Dos Serviços Financeiros, Seguros, Previdência Complementar e Planos De Saúde"
        68     "Atividades Imobiliárias "
        69     "Atividades Jurídicas, De Contabilidade e De Auditoria"
        70     "Atividades De Consultoria Em Gestão Empresarial "
        71     "Serviços De Arquitetura e Engenharia; Testes e Análises Técnicas"
        72     "Pesquisa e Desenvolvimento CientíFico"
        73     "Publicidade e Pesquisas De Mercado"
        74     "Outras Atividades Profissionais, CientíFicas e Técnicas"
        75     "Atividades Veterinárias "
        77     "AluguéIs Não Imobiliários e Gestão De Ativos Intangíveis Não Financeiros"
        78     "Seleção, Agenciamento e Locação De Mão-De-Obra"
        79     "Agências De Viagens, Operadores Turísticos e Serviços De Reservas"
        80     "Atividades De Vigilância, Segurança e Investigação"
        81     "Serviços Para Edificios e Atividades Paisagisticas"
        82     "Serviços De Escritório, De Apoio Administrativo e Outros Serviços Prestados A Empresas"
        84     "Administração Pública, Defesa e Seguridade Social   "
        85     "Educação"
        86     "Atividades De Atenção à Saúde Humana"
        87     "Atividades De Atenção à Saúde Humana Integradas Com Assistência Social"
        88     "Serviços De Assistência Social Sem Alojamento"
        90     "Atividades Artísticas, Criativas e De EspetáCulos"
        91     "Atividades Ligadas Ao Patrimônio Cultural e Ambiental"
        92     "Atividades De Exploração De Jogos De Azar e Apostas"
        93     "Atividades Esportivas e De Recreação e Lazer"
        94     "Atividades De Organizações Associativas"
        95     "Reparação e Manutenção De Equipamentos De Informatica e Comunicação e De Objetos Pessoais e Domésticos"
        96     "Outras Atividades De Serviços Pessoais"
        97     "Serviços Domésticos "
        99     "Organismos Internacionais e Outras Instituições Extraterritoriais"
    ) 
    ;
#delim cr

