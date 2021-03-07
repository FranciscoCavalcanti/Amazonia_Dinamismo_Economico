******************************************************
**	 Taxas de crescimento de massa de rendimentos por grupamentos de atividade	**
******************************************************

* call data 
use "$input_dir\_amz_jovem_numero_ocupados_por_atividade.dta", clear
gen id = cod_atividade
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

collapse (mean) massa_salarial, by (cod_atividade Ano)

* drop the lowest 5 percentile 
sum massa_salarial, detail
gen iten1 = `r(p5)' if Ano =="2012"
drop if iten1 >= massa_salarial & Ano =="2012"
drop iten*
* keep only observations that exist in 2019 and 2012
by cod_atividade, sort: gen leao1 =_n
by cod_atividade, sort: egen leao2 =max(leao1)
keep if leao2==2
drop leao*

drop if cod_atividade=="."
drop if cod_atividade==""
drop if cod_atividade=="0"

sort cod_atividade Ano

by cod_atividade, sort: gen tx_crescimento = (massa_salarial[_n]/massa_salarial[_n-1])*100 -100

collapse (mean) tx_crescimento, by (cod_atividade)
sort tx_crescimento

* edit to merge
gen lgth=length(cod_atividade)
gen apnd = "" if  lgth==5
replace apnd = "0" if  lgth==4
replace apnd = "00" if  lgth==3
replace apnd = "000" if  lgth==2
replace apnd = "0000" if  lgth==1
replace apnd = "00000" if  lgth==0
gen aux1 = apnd + cod_atividade
replace cod_atividade = aux1
cap drop aux1 apnd lgth 

* merge with auxiliar data base
merge 1:1 cod_atividade using "$input_dir\cod_atividade.dta"
drop _merge
compress

* drop vague names
do "$code_dir\_sub_code\_drop_vague_names.do"

gsort -tx_crescimento

drop if _n>20

* format
format tx_crescimento %16,2fc

// transforma data em matrix
mkmat tx_crescimento, matrix(A) rownames(cod_atividade)

* local notes
local ttitle "Taxas de crescimento de massa de rendimentos por grupamentos de atividade entre 2012 e 2019"
local tnotes "Fonte: com base nos dados da PNAD Contínua, IBGE"

#delim ;    
esttab matrix(A, fmt(%16,2fc)) using "$output_dir\amzjovemrkngtxmassaporatividade.tex", 
	replace 
	collabels("Tx. Cresc. (\%)")
    prehead(
        "\begin{table}[H]"
        "\centering"
		"\label{amzjovemrkngtxmassaporatividade}"
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
        00000 "Atividades mal definidas"
        01101 "Cultivo de arroz"
        01102 "Cultivo de milho"
        01103 "Cultivo de outros cereais"
        01104 "Cultivo de algodão"
        01105 "Cultivo de cana-de-açúcar"
        01106 "Cultivo de fumo"
        01107 "Cultivo de soja"
        01108 "Cultivo de mandioca"
        01109 "Cultivo de outras lavouras temporárias não especificadas anteriormente"
        01110 "Horticultura"
        01111 "Cultivo de flores e plantas ornamentais"
        01112 "Cultivo de frutas cítricas"
        01113 "Cultivo de café"
        01114 "Cultivo de cacau"
        01115 "Cultivo de uva"
        01116 "Cultivo de banana"
        01117 "Cultivo de outras plantas e frutas de lavoura permanente não especificadas anteriormente"
        01118 "Produção de sementes e mudas certificadas"
        01119 "Lavoura não especificada"
        01201 "Criação de bovinos"
        01202 "Criação de outros animais de grande porte não especificados anteriormente"
        01203 "Criação de caprinos e ovinos"
        01204 "Criação de suínos"
        01205 "Criação de aves"
        01206 "Apicultura"
        01207 "Sericicultura"
        01208 "Criação de outros animais não especificados anteriormente"
        01209 "Pecuária não especificada"
        01401 "Atividades de apoio à agricultura e pós-colheita"
        01402 "Atividades de apoio à pecuária"
        01500 "Caça e serviços relacionados"
        01999 "Agropecuária"
        02000 "Produção florestal"
        03001 "Pesca"
        03002 "Aqüicultura"
        05000 "Extração de carvão mineral"
        06000 "Extração de petróleo e gás natural"
        07001 "Extração de minérios de metais preciosos"
        07002 "Extração de minerais metálicos não especificados anteriormente"
        08001 "Extração de pedras, areia e argila"
        08002 "Extração de gemas (pedras preciosas e semi-preciosas)"
        08009 "Extração de minerais não metálicos não especificados anteriormente"
        09000 "Atividades de apoio à extração de minerais"
        10010 "Abate e fabricação de produtos de carne e pescado"
        10021 "Fabricação de conservas de frutas, legumes e outros vegetais"
        10022 "Fabricação de óleos vegetais e gorduras vegetais e animais"
        10030 "Laticínios"
        10091 "Moagem, fabricação de produtos amiláceos e de alimentos para animais"
        10092 "Fabricação e refino do açúcar"
        10093 "Torrefação e moagem de café"
        10099 "Fabricação de outros produtos alimentícios"
        11000 "Fabricação de bebidas"
        12000 "Processamento industrial e fabricação de produtos do fumo"
        13001 "Preparação de fibras, fiação e tecelagem"
        13002 "Fabricação de artefatos têxteis, exceto vestuário"
        14001 "Confecção de artigos do vestuário e acessórios, exceto sob medida"
        14002 "Confecção, sob medida, de artigos do vestuário"
        15011 "Curtimento e outras preparações de couro"
        15012 "Fabricação de artigos de viagem e de artefatos diversos de couro"
        15020 "Fabricação de calçados e partes para calçados, de qualquer material"
        16001 "Serrarias"
        16002 "Fabricação de produtos de madeira, cortiça e material trançado, exceto móveis"
        17001 "Fabricação de celulose, papel, cartolina e papel-cartão"
        17002 "Fabricação de embalagens e de produtos diversos de papel, cartolina, papel-cartão e papelão ondulado"
        18000 "Impressão e reprodução de gravações"
        19010 "Coquerias"
        19020 "Fabricação de produtos derivados do petróleo"
        19030 "Produção de biocombustíveis"
        20010 "Fabricação de tintas, vernizes, esmaltes, lacas e produtos afins"
        20020 "Fabricação de sabões, detergentes e produtos de limpeza"
        20090 "Fabricação de outros produtos químicos não especificados anteriormente"
        21000 "Fabricação de produtos farmoquimicos e farmacêuticos"
        22010 "Fabricação de produtos de borracha"
        22020 "Fabricação de produtos de material plástico"
        23010 "Fabricação de vidro e produtos de vidro"
        23091 "Fabricação de produtos cerâmicos"
        23099 "Fabricação de outros produtos de minerais não-metálicos não especificados anteriormente"
        24001 "Fabricação de produtos siderúrgicos"
        24002 "Metalurgia dos metais não-ferrosos"
        24003 "Fundição"
        25001 "Fabricação de produtos de metal, exceto máquinas e equipamentos"
        25002 "Forjaria, estamparia, metalurgia do pó e serviços de tratamento de metais"
        26010 "Fabricação de componentes eletrônicos"
        26020 "Fabricação de equipamentos de informática e periféricos"
        26030 "Fabricação de equipamentos de comunicação"
        26041 "Fabricação de aparelhos e instrumentos de medida, teste e controle"
        26042 "Fabricação de equipamentos e instrumentos ópticos, fotográficos e cinematográficos"
        27010 "Fabricação de eletrodomesticos"
        27090 "Fabricação de máquinas, aparelhos e materiais elétricos diversos, exceto eletrodomesticos"
        28000 "Fabricação de máquinas e equipamentos"
        29001 "Fabricação e montagem de veículos automotores"
        29002 "Fabricação de cabines, carrocerias, reboques e peças para veículos automotores"
        29003 "Reconstrução, em fábrica, de motores de veículos automotores"
        30010 "Construção de embarcações"
        30020 "Fabricação de veículos ferroviários"
        30030 "Fabricação de aeronaves"
        30090 "Fabricação de outros equipamentos de transporte não especificados anteriormente"
        31000 "Fabricação de móveis"
        32001 "Fabricação de artigos de joalheria, bijuteria e semelhantes"
        32002 "Fabricação de instrumentos musicais"
        32003 "Fabricação de artefatos para pesca e esporte e de brinquedos e jogos recreativos"
        32009 "Fabricação de produtos diversos"
        33001 "Manutenção e reparação de máquinas e equipamentos"
        33002 "Instalação de máquinas e equipamentos"
        35010 "Geração, transmissão e distribuição de energia elétrica"
        35021 "Produção e distribuição de combustíveis gasosos por redes urbanas"
        35022 "Produção e distribuição de vapor, água quente e ar condicionado"
        36000 "Captação, tratamento e distribuição de água"
        37000 "Esgoto e atividades relacionadas"
        38000 "Coleta, tratamento e disposição de resíduos; recuperação de materiais"
        39000 "Descontaminação e outros serviços de gestão de resíduos"
        41000 "Construção de edifícios"
        42000 "Construção de obras de infra-estrutura"
        43000 "Serviços especializados para construção"
        45010 "Comércio de veículos automotores"
        45020 "Manutenção e reparação de veículos automotores"
        45030 "Comércio de peças e acessórios para veículos automotores"
        45040 "Comércio, manutenção e reparação de motocicletas, peças e acessórios"
        48010 "Representantes comerciais e agentes do comércio, exceto de veículos automotores e motocicletas"
        48020 "Comércio de matérias-primas agrícolas e animais vivos"
        48030 "Comércio de produtos alimentícios, bebidas e fumo"
        48041 "Comércio de tecidos, artefatos de tecidos e armarinho"
        48042 "Comércio de artigos do vestuário, complementos, calçados e artigos de viagem"
        48050 "Comércio de madeira, material de construção, ferragens e ferramentas"
        48060 "Comércio de combustíveis para veículos automotores"
        48071 "Comércio de produtos farmaceuticos, médicos, ortopédicos, odontológicos e de cosméticos e perfumaria"
        48072 "Comércio de artigos de escritório e de papelaria; livros, jornais e outras publicações"
        48073 "Comércio de eletrodomésticos, móveis e outros artigos de residência"
        48074 "Comércio de equipamentos e produtos de tecnologias de informação e comunicação"
        48075 "Comércio de máquinas, aparelhos e equipamentos, exceto eletrodomésticos"
        48076 "Comércio de combustíveis sólidos, líquidos e gasosos, exceto para veículos automotores"
        48077 "Comércio de produtos usados"
        48078 "Comercio de residuos e sucatas"
        48079 "Comércio de produtos novos não especificados anteriormente"
        48080 "Supermercado e hipermercado"
        48090 "Lojas de departamento e outros comércios não especializados, sem predominância de produtos alimentícios"
        48100 "Comércio ambulante e feiras"
        49010 "Transporte ferroviário e metroferroviário"
        49030 "Transporte rodoviário de passageiros"
        49040 "Transporte rodoviário de carga"
        49090 "Outros transportes terrestres"
        50000 "Transporte Aquaviário"
        51000 "Transporte Aéreo"
        52010 "Armazenamento, carga e descarga"
        52020 "Atividades auxiliares dos transportes e atividades relacionadas à organização do transporte de carga"
        53001 "Atividades de Correio"
        53002 "Atividades de malote e de entrega"
        55000 "Alojamento"
        56011 "Restaurantes e outros estabelecimentos de serviços de alimentação e bebidas"
        56012 "Serviços de catering, bufê e outros serviços de comida preparada"
        56020 "Serviços ambulantes de alimentação"
        58000 "Edição e Edição integrada à impressão"
        59000 "Atividades cinematográficas, produção de vídeos e de programas de televisão, gravação de som e de música"
        60001 "Atividades de rádio"
        60002 "Atividades de televisão"
        61000 "Telecomunicações"
        62000 "Atividades dos serviços de tecnologia da informação"
        63000 "Atividades de prestação de serviços de informação"
        64000 "Serviços financeiros"
        65000 "Seguros e previdência privada"
        66001 "Atividades auxiliares dos serviços financeiros"
        66002 "Atividades auxiliares dos seguros, da previdência complementar e dos planos de saúde"
        68000 "Atividades imobiliárias"
        69000 "Atividades jurídicas, de contabilidade e de auditoria"
        70000 "Atividades de consultoria em gestão empresarial"
        71000 "Serviços de arquitetura e engenharia e atividades técnicas relacionadas; Testes e análises técnicas"
        72000 "Pesquisa e desenvolvimento científico"
        73010 "Publicidade"
        73020 "Pesquisas de mercado e opinião pública"
        74000 "Outras atividades profissionais, científicas e técnicas não especificadas anteriormente"
        75000 "Atividades veterinárias"
        77010 "Aluguel de objetos pessoais e domésticos"
        77020 "Aluguel de meios de transportes, maquinas e equipamentos"
        78000 "Seleção, agenciamento e locação de mão-de-obra"
        79000 "Agências de viagens, operadores turísticos e serviços de reservas"
        80000 "Atividades de vigilância, segurança, transporte de valores e investigação"
        81011 "Serviços de limpeza e de apoio a edifícios, exceto condomínios prediais"
        81012 "Condomínios prediais"
        81020 "Atividades paisagísticas"
        82001 "Serviços de escritório e apoio administrativo"
        82002 "Atividades de teleatendimento"
        82003 "Atividades de organização de eventos, exceto culturais e esportivos"
        82009 "Outras atividades de serviços prestados principalmente às empresas"
        84011 "Administração publica e regulação da política econômica e social - Federal"
        84012 "Administração publica e regulação da política econômica e social - Estadual"
        84013 "Administração publica e regulação da política econômica e social - Municipal"
        84014 "Defesa"
        84015 "Outros serviços coletivos prestados pela administração pública - Federal"
        84016 "Outros serviços coletivos prestados pela administração pública - Estadual"
        84017 "Outros serviços coletivos prestados pela administração pública - Municipal"
        84020 "Seguridade social obrigatória"
        85011 "Creche"
        85012 "Pré-escola e ensino fundamental"
        85013 "Ensino médio"
        85014 "Educação superior"
        85021 "Serviços auxiliares à educação"
        85029 "Outras atividades de ensino"
        86001 "Atividades de atendimento hospitalar"
        86002 "Atividades de atenção ambulatorial executadas por médicos e odontólogos"
        86003 "Atividades de serviços de complementação diagnóstica e terapêutica"
        86004 "Atividades de profissionais da área de saúde, exceto médicos e odontólogos"
        86009 "Atividades de atenção à saúde humana não especificadas anteriormente"
        87000 "Atividades de assistência à saude humana integradas com assistencia social, inclusive prestadas em residencias"
        88000 "Serviços de assistência social sem alojamento"
        90000 "Atividades artísticas, criativas e de espetáculos"
        91000 "Atividades ligadas ao patrimônio cultural e ambiental"
        92000 "Atividades de exploração de jogos de azar e apostas"
        93011 "Atividades esportivas"
        93012 "Atividades de condicionamento físico"
        93020 "Atividades de recreação e lazer"
        94010 "Atividades de organizações associativas patronais, empresariais e profissionais"
        94020 "Atividades de organizações sindicais"
        94091 "Atividades de organizações religiosas e filosóficas"
        94099 "Outras atividades associativas não especificadas anteriormente"
        95010 "Reparação e manutenção de equipamentos de informática e comunicação"
        95030 "Reparação e manutenção de objetos e equipamentos pessoais e domésticos"
        96010 "Lavanderias, tinturarias e toalheiros"
        96020 "Cabeleireiros e outras atividades de tratamento de beleza"
        96030 "Atividades funerárias e serviços relacionados"
        96090 "Outras atividades de serviços pessoais"
        97000 "Serviços domésticos"
        99000 "Organismos internacionais e outras instituições extraterritoriais"
    ) 
    ;
#delim cr

