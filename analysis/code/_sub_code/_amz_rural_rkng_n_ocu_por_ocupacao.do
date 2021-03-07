******************************************************
**	 Rankings de variação absoluta de ocupações	**
******************************************************

* call data 
use "$input_dir\_amz_rural_numero_ocupados_por_ocupacao.dta", clear

gen id = cod_ocupacao
sort Ano Trimestre cod_ocupacao id

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

collapse (mean) n_ocu_cod, by (cod_ocupacao Ano)

* drop the lowest 5 percentile 
sum n_ocu_cod, detail
gen iten1 = `r(p5)' if Ano =="2012"
drop if iten1 >= n_ocu_cod & Ano =="2012"
drop iten*
* keep only observations that exist in 2019 and 2012
by cod_ocupacao, sort: gen leao1 =_n
by cod_ocupacao, sort: egen leao2 =max(leao1)
keep if leao2==2
drop leao*

drop if cod_ocupacao=="."
drop if cod_ocupacao==""
drop if cod_ocupacao=="0"

sort cod_ocupacao Ano

by cod_ocupacao, sort: gen delta_n = (n_ocu_cod[_n] - n_ocu_cod[_n-1])

collapse (mean) delta_n, by (cod_ocupacao)

* edit to merge
gen lgth=length(cod_ocupacao)
gen apnd = "" if  lgth==4
replace apnd = "0" if  lgth==3
replace apnd = "00" if  lgth==2
replace apnd = "000" if  lgth==1
replace apnd = "0000" if  lgth==0

gen aux1 = apnd + cod_ocupacao
replace cod_ocupacao = aux1
cap drop aux1 apnd lgth 

* merge with auxiliar data base
merge 1:1 cod_ocupacao using "$input_dir\cod_ocupacao.dta"
drop _merge
compress

* drop vague names
do "$code_dir\_sub_code\_drop_vague_names.do"

gsort -delta_n

drop if _n>20

* format
format delta_n %16,0fc

*gen iten1 = string(tx_crescimento, "%8.2f") + "%"
*cap drop tx_crescimento
*rename iten1 delta_n

* drop irrelevant variables
* cap drop cod_ocupacao
tostring cod_ocupacao, replace
destring delta_n, replace

// transforma data em matrix
mkmat delta_n, matrix(A) rownames(cod_ocupacao)

* local notes
local ttitle "Variação absoluta do número de ocupações por tipo de ocupação entre 2012 e 2019"
local tnotes "Fonte: com base nos dados da PNAD Contínua, IBGE"


#delim ;    
esttab matrix(A, fmt(%16,0fc)) using "$output_dir\amzruralrkngnocuporocupacao.tex", 
	replace 
	collabels("Variação")
    prehead(
        "\begin{table}[H]"
        "\centering"
		"\label{amzruralrkngnocuporocupacao}"
		"\scalebox{0.60}{"
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
        0110 "Oficiais das forças armadas"
        0210 "Graduados e praças das forças armadas"
        0411 "Oficiais de polícia militar"
        0412 "Graduados e praças da polícia militar"
        0511 "Oficiais de bombeiro militar"
        0512 "Graduados e praças do corpo de bombeiros"
        1111 "Legisladores"
        1112 "Dirigentes superiores da administração pública"
        1113 "Chefes de pequenas populações"
        1114 "Dirigentes de organizações que apresentam um interesse especial"
        1120 "Diretores gerais e gerentes gerais"
        1211 "Dirigentes financeiros"
        1212 "Dirigentes de recursos humanos"
        1213 "Dirigentes de políticas e planejamento"
        1219 "Dirigentes de administração e de serviços não classificados anteriormente"
        1221 "Dirigentes de vendas e  comercialização"
        1222 "Dirigentes de publicidade e relações públicas"
        1223 "Dirigentes de pesquisa e desenvolvimento"
        1311 "Dirigentes de produção agropecuária e silvicultura"
        1312 "Dirigentes de produção da aquicultura e pesca"
        1321 "Dirigentes de indústria de transformação"
        1322 "Dirigentes de explorações de mineração"
        1323 "Dirigentes de empresas de construção"
        1324 "Dirigentes de empresas de abastecimento, distribuição e afins"
        1330 "Dirigentes de serviços de tecnologia da informação e comunicações"
        1341 "Dirigentes de serviços de cuidados infantis"
        1342 "Dirigentes de serviços de saúde"
        1343 "Dirigentes de serviços de cuidado a pessoas idosas"
        1344 "Dirigentes de serviços de bem-estar social"
        1345 "Dirigentes de serviços de educação"
        1346 "Gerentes de sucursais de bancos, de serviços financeiros e de seguros"
        1349 "Dirigentes e gerentes de serviços profissionais não classificados anteriormente"
        1411 "Gerentes de hotéis"
        1412 "Gerentes de restaurantes"
        1420 "Gerentes de comércios atacadistas e varejistas"
        1431 "Gerentes de centros esportivos,  de diversão e culturais"
        1439 "Gerentes de serviços não classificados anteriormente"
        2111 "Físicos e astrônomos"
        2112 "Meteorologistas"
        2113 "Químicos"
        2114 "Geólogos e geofísicos"
        2120 "Matemáticos, atuários e estatísticos"
        2131 "Biólogos, botânicos, zoólogos e afins"
        2132 "Agrônomos e afins"
        2133 "Profissionais da proteção do meio ambiente"
        2141 "Engenheiros industriais e de produção"
        2142 "Engenheiros civis"
        2143 "Engenheiros de meio ambiente"
        2144 "Engenheiros mecânicos"
        2145 "Engenheiros químicos"
        2146 "Engenheiros de minas, metalúrgicos e afins"
        2149 "Engenheiros não classificados anteriormente"
        2151 "Engenheiros eletricistas"
        2152 "Engenheiros eletrônicos"
        2153 "Engenheiros em telecomunicações"
        2161 "Arquitetos de edificações"
        2162 "Arquitetos paisagistas"
        2163 "Desenhistas de produtos e  vestuário"
        2164 "Urbanistas e engenheiros de trânsito"
        2165 "Cartógrafos e agrimensores"
        2166 "Desenhistas gráficos e de multimídia"
        2211 "Médicos gerais"
        2212 "Médicos especialistas"
        2221 "Profissionais de enfermagem"
        2222 "Profissionais de partos"
        2230 "Profissionais da medicina tradicional e alternativa"
        2240 "Paramédicos"
        2250 "Veterinários"
        2261 "Dentistas"
        2262 "Farmacêuticos"
        2263 "Profissionais da saúde e da higiene laboral e ambiental"
        2264 "Fisioterapeutas"
        2265 "Dietistas e nutricionistas"
        2266 "Fonoaudiólogos e logopedistas"
        2267 "Optometristas"
        2269 "Profissionais da saúde não classificados anteriormente"
        2310 "Professores de universidades e do ensino superior"
        2320 "Professores de formação profissional"
        2330 "Professores do ensino médio"
        2341 "Professores do ensino fundamental"
        2342 "Professores do ensino pré-escolar"
        2351 "Especialistas em métodos pedagógicos"
        2352 "Educadores para necessidades especiais"
        2353 "Outros professores de idiomas"
        2354 "Outros professores de música"
        2355 "Outros professores de artes"
        2356 "Instrutores em tecnologias da informação"
        2359 "Profissionais de ensino não classificados anteriormente"
        2411 "Contadores"
        2412 "Assessores financeiros e em investimentos"
        2413 "Analistas financeiros"
        2421 "Analistas de gestão e administração"
        2422 "Especialistas em políticas de administração"
        2423 "Especialistas em políticas e serviços de pessoal e afins"
        2424 "Especialistas em formação de pessoal"
        2431 "Profissionais da publicidade e da comercialização"
        2432 "Profissionais de relações públicas"
        2433 "Profissionais de vendas técnicas e médicas (exclusive tic)"
        2434 "Profissionais de vendas de tecnologia da informação e comunicações"
        2511 "Analistas de sistemas"
        2512 "Desenvolvedores de programas e aplicativos (software)"
        2513 "Desenvolvedores de páginas de internet (web) e multimídia"
        2514 "Programadores de aplicações"
        2519 "Desenvolvedores e analistas de programas e aplicativos (software) e multimídia não classificados anteriormente"
        2521 "Desenhistas e administradores de bases de dados"
        2522 "Administradores de sistemas"
        2523 "Profissionais em rede de computadores"
        2529 "Especialistas em base de dados e em redes de computadores não classificados anteriormente"
        2611 "Advogados e juristas"
        2612 "Juízes"
        2619 "Profissionais em direito não classificados anteriormente"
        2621 "Arquivologistas e curadores de museus"
        2622 "Bibliotecários, documentaristas e afins"
        2631 "Economistas"
        2632 "Sociólogos, antropólogos e afins"
        2633 "Filósofos, historiadores e especialistas em ciência política"
        2634 "Psicólogos"
        2635 "Assistentes sociais"
        2636 "Ministros de cultos religiosos, missionários e afins"
        2641 "Escritores"
        2642 "Jornalistas"
        2643 "Tradutores, intérpretes e linguistas"
        2651 "Artistas plásticos"
        2652 "Músicos, cantores e compositores"
        2653 "Bailarinos e coreógrafos"
        2654 "Diretores de cinema, de teatro e afins"
        2655 "Atores"
        2656 "Locutores de rádio, televisão e outros meios de comunicação"
        2659 "Artistas criativos e interpretativos não classificados anteriormente"
        3111 "Técnicos em ciências físicas e químicas"
        3112 "Técnicos em engenharia civil"
        3113 "Eletrotécnicos"
        3114 "Técnicos em eletrônica"
        3115 "Técnicos em engenharia mecânica"
        3116 "Técnicos em química industrial"
        3117 "Técnicos em engenharia de minas e metalurgia"
        3118 "Desenhistas e projetistas técnicos"
        3119 "Técnicos em ciências físicas e da engenharia não classificados anteriormente"
        3121 "Supervisores da mineração"
        3122 "Supervisores de indústrias de transformação"
        3123 "Supervisores da construção"
        3131 "Operadores de instalações de produção de energia"
        3132 "Operadores de incineradores, instalações de tratamento de água e afins"
        3133 "Controladores de instalações de processamento de produtos químicos"
        3134 "Operadores de instalações de refino de petróleo e gás natural"
        3135 "Controladores de processos de produção de metais"
        3139 "Técnicos em controle de processos não classificados anteriormente"
        3141 "Técnicos e profissionais de nível médio em ciências biológicas (exclusive da medicina)"
        3142 "Técnicos agropecuários"
        3143 "Técnicos florestais"
        3151 "Oficiais maquinistas em navegação"
        3152 "Capitães, oficiais de coberta e práticos"
        3153 "Pilotos de aviação e afins"
        3154 "Controladores de tráfego aéreo"
        3155 "Técnicos em segurança aeronáutica"
        3211 "Técnicos em aparelhos de diagnóstico e tratamento médico"
        3212 "Técnicos de laboratórios médicos"
        3213 "Técnicos e assistentes farmacêuticos"
        3214 "Técnicos de próteses médicas e dentárias"
        3221 "Profissionais de nível médio de enfermagem"
        3222 "Profissionais de nível médio de partos"
        3230 "Profissionais de nível médio de medicina tradicional e alternativa"
        3240 "Técnicos e assistentes veterinários"
        3251 "Dentistas auxiliares e ajudantes de odontologia"
        3252 "Técnicos em documentação sanitária"
        3253 "Trabalhadores comunitários da saúde"
        3254 "Técnicos em optometria e ópticos"
        3255 "Técnicos e assistentes fisioterapeutas"
        3256 "assistentes de medicina"
        3257 "Inspetores de saúde laboral, ambiental e afins"
        3258 "Ajudantes de ambulâncias"
        3259 "Profissionais de nível médio da saúde não classificados anteriormente"
        3311 "Agentes e corretores de bolsa, câmbio e outros serviços financeiros"
        3312 "Agentes de empréstimos e financiamento"
        3313 "Contabilistas e guarda livros"
        3314 "Profissionais de nível médio de serviços estatísticos, matemáticos e afins"
        3315 "Avaliadores"
        3321 "Agentes de seguros"
        3322 "Representantes comerciais"
        3323 "Agentes de compras"
        3324 "Corretores de comercialização"
        3331 "Despachantes aduaneiros"
        3332 "Organizadores de conferências e eventos"
        3333 "Agentes de emprego e agenciadores de mão de obra"
        3334 "Agentes imobiliários"
        3339 "Agentes de serviços comerciais não classificados anteriormente"
        3341 "Supervisores de secretaria"
        3342 "Secretários jurídicos"
        3343 "Secretários executivos e administrativos"
        3344 "Secretários de medicina"
        3351 "Agentes aduaneiros e inspetores de fronteiras"
        3352 "Agentes da administração tributária"
        3353 "Agentes de serviços de seguridade social"
        3354 "Agentes de serviços de expedição de licenças e permissões"
        3355 "Inspetores de polícia e detetives"
        3359 "Agentes da administração pública para aplicação da lei e afins não classificados anteriormente"
        3411 "Profissionais de nível médio do direito e serviços legais e afins"
        3412 "Trabalhadores e assistentes sociais de nível médio"
        3413 "Auxiliares leigos de religião"
        3421 "Atletas e esportistas"
        3422 "Treinadores, instrutores e árbitros de atividades esportivas"
        3423 "Instrutores de educação física e atividades recreativas"
        3431 "Fotógrafos"
        3432 "Desenhistas e decoradores de interiores"
        3433 "Técnicos em galerias de arte, museus e bibliotecas"
        3434 "Chefes de cozinha"
        3435 "Outros profissionais de nível médio em atividades culturais e artísticas"
        3511 "Técnicos em operações de tecnologia da informação e das comunicações"
        3512 "Técnicos em assistência ao usuário de tecnologia da informação e das comunicações"
        3513 "Técnicos de redes e sistemas de computadores"
        3514 "Técnicos da web"
        3521 "Técnicos de radiodifusão e gravação audiovisual"
        3522 "Técnicos de engenharia de telecomunicações"
        4110 "Escriturários gerais"
        4120 "Secretários (geral)"
        4131 "Operadores de máquinas de processamento de texto e mecanógrafos"
        4132 "Operadores de entrada de dados"
        4211 "Caixas de banco e afins"
        4212 "Coletores de apostas e de jogos"
        4213 "Trabalhadores em escritórios de empréstimos e penhor"
        4214 "Cobradores e afins"
        4221 "Trabalhadores de agências de viagem"
        4222 "Trabalhadores de centrais de atendimento"
        4223 "Telefonistas"
        4224 "Recepcionistas de hotéis"
        4225 "Trabalhadores dos serviços de informações"
        4226 "Recepcionistas em geral"
        4227 "Entrevistadores de pesquisas de mercado"
        4229 "Trabalhadores de serviços de informação ao cliente não classificados anteriormente"
        4311 "Trabalhadores de contabilidade e cálculo de custos"
        4312 "Trabalhadores de serviços estatísticos, financeiros e de seguros"
        4313 "Trabalhadores encarregados de folha de pagamento"
        4321 "Trabalhadores de controle de abastecimento e estoques"
        4322 "Trabalhadores de serviços de apoio à produção"
        4323 "Trabalhadores de serviços de transporte"
        4411 "Trabalhadores de bibliotecas"
        4412 "Trabalhadores de serviços de correios"
        4413 "Codificadores de dados, revisores de provas de impressão e afins"
        4414 "Outros escreventes"
        4415 "Trabalhadores de arquivos"
        4416 "Trabalhadores do serviço de pessoal"
        4419 "Trabalhadores de apoio administrativo não classificados anteriormente"
        5111 "Auxiliares de serviço de bordo"
        5112 "Fiscais e cobradores de transportes públicos"
        5113 "Guias de turismo"
        5120 "Cozinheiros"
        5131 "Garçons"
        5132 "atendentes de bar"
        5141 "Cabeleireiros"
        5142 "Especialistas em tratamento de beleza e afins"
        5151 "Supervisores de manutenção e limpeza de edifícios em escritórios, hotéis e estabelecimentos"
        5152 "Governantas e mordomos domésticos"
        5153 "Porteiros e zeladores"
        5161 "Astrólogos, adivinhos e afins"
        5162 "Acompanhantes e criados particulares"
        5163 "Trabalhadores de funerárias e embalsamadores"
        5164 "Cuidadores de animais"
        5165 "Instrutores de autoescola"
        5168 "Trabalhadores do sexo"
        5169 "Trabalhadores de serviços pessoais não classificados anteriormente"
        5211 "Vendedores de quiosques e postos de mercados"
        5212 "Vendedores ambulantes de serviços de alimentação"
        5221 "Comerciantes de lojas"
        5222 "Supervisores de lojas"
        5223 "Balconistas e vendedores de lojas"
        5230 "Caixas e expedidores de bilhetes"
        5241 "Modelos de moda, arte e publicidade"
        5242 "Demonstradores de lojas"
        5243 "Vendedores a domicilio"
        5244 "Vendedores por telefone"
        5245 "Frentistas de posto de gasolina"
        5246 "Balconistas dos serviços de alimentação"
        5249 "Vendedores não classificados anteriormente"
        5311 "Cuidadores de crianças"
        5312 "Ajudantes de professores"
        5321 "Trabalhadores de cuidados pessoais em instituições"
        5322 "Trabalhadores de cuidados pessoais a domicílios"
        5329 "Trabalhadores de cuidados pessoais nos serviços de saúde não classificados anteriormente"
        5411 "Bombeiros"
        5412 "Policiais"
        5413 "Guardiões de presídios"
        5414 "Guardas de segurança"
        5419 "Trabalhadores dos serviços de proteção e segurança não classificados anteriormente"
        6111 "Agricultores e trabalhadores qualificados em atividades da agricultura (exclusive hortas, viveiros e jardins)"
        6112 "Agricultores e trabalhadores qualificados no cultivo de hortas, viveiros e jardins"
        6114 "Agricultores e trabalhadores qualificados de cultivos mistos"
        6121 "Criadores de gado e trabalhadores qualificados da criação de gado"
        6122 "Avicultores e trabalhadores qualificados da avicultura"
        6123 "Apicultores, sericicultores e trabalhadores qualificados da apicultura e sericicultura"
        6129 "Outros criadores e trabalhadores qualificados da pecuária não classificados anteriormente"
        6130 "Produtores e trabalhadores qualificados de exploração agropecuária mista"
        6210 "Trabalhadores florestais qualificados e afins"
        6221 "Trabalhadores da aquicultura"
        6224 "Caçadores"
        6225 "Pescadores"
        7111 "Construtores de casas"
        7112 "Pedreiros"
        7113 "Canteiros, cortadores e gravadores de pedras"
        7114 "Trabalhadores em cimento e concreto armado"
        7115 "Carpinteiros"
        7119 "Outros trabalhadores qualificados e operários da construção não classificados anteriormente"
        7121 "Telhadores"
        7122 "Aplicadores de revestimentos cerâmicos, pastilhas, pedras e madeiras"
        7123 "Gesseiros"
        7124 "Instaladores de material isolante térmico e acústico"
        7125 "Vidraceiros"
        7126 "Bombeiros e encanadores"
        7127 "Mecânicos-instaladores de sistemas de refrigeração e climatização"
        7131 "Pintores e empapeladores"
        7132 "Lustradores"
        7133 "Limpadores de fachadas"
        7211 "Moldadores de metal e macheiros"
        7212 "Soldadores e oxicortadores"
        7213 "Chapistas e caldeireiros"
        7214 "Montadores de estruturas metálicas"
        7215 "Aparelhadores e emendadores de cabos"
        7221 "Ferreiros e forjadores"
        7222 "Ferramenteiros e afins"
        7223 "Reguladores e operadores de máquinas-ferramentas"
        7224 "Polidores de metais e afiadores de ferramentas"
        7231 "Mecânicos e reparadores de veículos a motor"
        7232 "Mecânicos e reparadores de motores de avião"
        7233 "Mecânicos e reparadores de máquinas agrícolas e industriais"
        7234 "Reparadores de bicicletas e afins"
        7311 "Mecânicos e reparadores de instrumentos de precisão"
        7312 "Confeccionadores e afinadores de instrumentos musicais"
        7313 "Joalheiros e lapidadores de gemas, artesãos de metais preciosos e semipreciosos"
        7314 "Ceramistas e afins (preparação e fabricação)"
        7315 "Cortadores, polidores, jateadores e gravadores de vidros e afins"
        7316 "Redatores de cartazes, pintores decorativos e gravadores"
        7317 "Artesãos de pedra, madeira, vime e materiais semelhantes"
        7318 "Artesãos de tecidos, couros e materiais semelhantes"
        7319 "Artesãos não classificados anteriormente"
        7321 "Trabalhadores da pré-impressão gráfica"
        7322 "Impressores"
        7323 "Encadernadores e afins"
        7411 "Eletricistas de obras e afins"
        7412 "Mecânicos e ajustadores eletricistas"
        7413 "Instaladores e reparadores de linhas elétricas"
        7421 "Mecânicos e reparadores em eletrônica"
        7422 "Instaladores e reparadores em tecnologias da informação e comunicações"
        7511 "Magarefes e afins"
        7512 "Padeiros, confeiteiros e afins"
        7513 "Trabalhadores da pasteurização do leite e fabricação de laticínios e afins"
        7514 "Trabalhadores da conservação de frutas, legumes e similares"
        7515 "Trabalhadores da degustação e classificação de alimentos e bebidas"
        7516 "Trabalhadores qualificados da preparação do fumo e seus produtos"
        7521 "Trabalhadores de tratamento e preparação da madeira"
        7522 "Marceneiros e afins"
        7523 "Operadores de máquinas de lavrar madeira"
        7531 "Alfaiates, modistas, chapeleiros e peleteiros"
        7532 "Trabalhadores qualificados da preparação da confecção de roupas"
        7533 "Costureiros, bordadeiros e afins"
        7534 "Tapeceiros, colchoeiros e afins"
        7535 "Trabalhadores qualificados do tratamento de couros e peles"
        7536 "Sapateiros e afins"
        7541 "Trabalhadores subaquáticos"
        7542 "Dinamitadores e detonadores"
        7543 "Classificadores e provadores de produtos (exceto de bebidas e alimentos)"
        7544 "Fumigadores e outros controladores de pragas e ervas daninhas"
        7549 "Outros trabalhadores qualificados e operários da indústria e do artesanato não classificados anteriormente"
        8111 "Mineiros e operadores de máquinas e de instalações em minas e pedreiras"
        8112 "Operadores de instalações de processamento de minerais e rochas"
        8113 "Perfuradores e sondadores de poços e afins"
        8114 "Operadores de máquinas para fabricar cimento, pedras e outros produtos minerais"
        8121 "Operadores de instalações de processamento de metais"
        8122 "Operadores de máquinas polidoras, galvanizadoras e recobridoras de metais"
        8131 "Operadores de instalações e máquinas de produtos químicos"
        8132 "Operadores de máquinas para fabricar produtos fotográficos"
        8141 "Operadores de máquinas para fabricar produtos de borracha"
        8142 "Operadores de máquinas para fabricar produtos de material plástico"
        8143 "Operadores de máquinas para fabricar produtos de papel"
        8151 "Operadores de máquinas de preparação de fibras, fiação e bobinamento de fios"
        8152 "Operadores de teares e outras máquinas de tecelagem"
        8153 "Operadores de máquinas de costura"
        8154 "Operadores de máquinas de branqueamento, tingimento e limpeza de tecidos"
        8155 "Operadores de máquinas de processamento de couros e peles"
        8156 "Operadores de máquinas para fabricação de calçados e afins"
        8157 "Operadores de máquinas de lavar, tingir e passar roupas"
        8159 "Operadores de máquinas para fabricar produtos têxteis e artigos de couro e pele não classificados anteriormente"
        8160 "Operadores de máquinas para elaborar alimentos e produtos afins"
        8171 "Operadores de instalações para a preparação de pasta de papel e papel"
        8172 "Operadores de instalações para processamento de madeira"
        8181 "Operadores de instalações de vidraria e cerâmica"
        8182 "Operadores de máquinas de vapor e caldeiras"
        8183 "Operadores de máquinas de embalagem, engarrafamento e etiquetagem"
        8189 "Operadores de máquinas e de instalações fixas não classificados anteriormente"
        8211 "Mecânicos montadores de maquinaria mecânica"
        8212 "Montadores de equipamentos elétricos e eletrônicos"
        8219 "Montadores não classificados anteriormente"
        8311 "Maquinistas de locomotivas"
        8312 "Guarda-freios e agentes de manobras"
        8321 "Condutores de motocicletas"
        8322 "Condutores de automóveis, taxis e caminhonetes"
        8331 "Condutores de ônibus e bondes"
        8332 "Condutores de caminhões pesados"
        8341 "Operadores de máquinas agrícolas e florestais móveis"
        8342 "Operadores de máquinas de movimentação de terras e afins"
        8343 "Operadores de guindastes, gruas, aparatos de elevação e afins"
        8344 "Operadores de empilhadeiras"
        8350 "Marinheiros de coberta e afins"
        9111 "Trabalhadores dos serviços domésticos em geral"
        9112 "Trabalhadores de limpeza de interior de edifícios, escritórios, hotéis e outros estabelecimentos"
        9121 "Lavadeiros de roupas e passadeiros manuais"
        9122 "Lavadores de veículos"
        9123 "Limpadores de janelas"
        9129 "Outros trabalhadores de limpeza"
        9211 "Trabalhadores elementares da agricultura"
        9212 "Trabalhadores elementares da pecuária"
        9213 "Trabalhadores elementares da agropecuária"
        9214 "Trabalhadores elementares da jardinagem e horticultura"
        9215 "Trabalhadores florestais elementares"
        9216 "Trabalhadores elementares da pesca e aquicultura"
        9311 "Trabalhadores elementares de minas e pedreiras"
        9312 "Trabalhadores elementares de obras públicas e da manutenção de estradas, represas e similares"
        9313 "Trabalhadores elementares da construção de edifícios"
        9321 "empacotadores manuais"
        9329 "Trabalhadores elementares da indústria de transformação não classificados anteriormente"
        9331 "Condutores de veículos acionados a pedal ou a braços"
        9332 "Condutores de veículos e máquinas de tração animal"
        9333 "Carregadores"
        9334 "Repositores de prateleiras"
        9411 "Preparadores de comidas rápidas"
        9412 "Ajudantes de cozinha"
        9510 "Trabalhadores ambulantes dos serviços e afins"
        9520 "Vendedores ambulantes (exclusive de serviços de alimentação)"
        9611 "Coletores de lixo e material reciclável"
        9612 "Classificadores de resíduos"
        9613 "Varredores e afins"
        9621 "Mensageiros, carregadores de bagagens e entregadores de encomendas"
        9622 "Pessoas que realizam várias tarefas"
        9623 "Coletores de dinheiro em máquinas automáticas de venda e leitores de medidores"
        9624 "Carregadores de água e coletores de lenha"
        9629 "Outras ocupações elementares não classificadas anteriormente"
    ) 
    ;
#delim cr
