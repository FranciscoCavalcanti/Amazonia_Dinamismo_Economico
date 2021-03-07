//////////////////////////////////////////////
//	Importancia relativa
//////////////////////////////////////////////

do "$code_dir\_sub_code\_amz_mt_importancia_relativa.do"

//////////////////////////////////////////////////////
//	Rankings de crescimento de absoluto de ocupações
//////////////////////////////////////////////////////

//	Por grandes setores econômicos 
* run do file
do "$code_dir\_sub_code\_amz_mt_rkng_n_ocu_por_setor.do"

//	Por setores atividade econônmica (CNAE)
* run do file
do "$code_dir\_sub_code\_amz_mt_rkng_n_ocu_por_atividade.do"

//	Por setores tipo de ocupação (COD)
* run do file
do "$code_dir\_sub_code\_amz_mt_rkng_n_ocu_por_ocupacao.do"

//////////////////////////////////////////////////
//	Rankings de taxa de crescimento de ocupações 
//////////////////////////////////////////////////

//	Por grandes setores econômicos 
* run do file
do "$code_dir\_sub_code\_amz_mt_rkng_tx_ocu_por_setor.do"

//	Por setores atividade econônmica (CNAE)
* run do file
do "$code_dir\_sub_code\_amz_mt_rkng_tx_ocu_por_atividade.do"

//	Por setores tipo de ocupação (COD)
* run do file
do "$code_dir\_sub_code\_amz_mt_rkng_tx_ocu_por_ocupacao.do"

//////////////////////////////////////////////////
//	Rankings de taxa de crescimento de salários 
//////////////////////////////////////////////////

//	Por grandes setores econômicos 
* run do file
do "$code_dir\_sub_code\_amz_mt_rkng_tx_renda_por_setor.do"

//	Por setores atividade econônmica (CNAE)
* run do file
do "$code_dir\_sub_code\_amz_mt_rkng_tx_renda_por_atividade.do"

//	Por setores tipo de ocupação (COD)
* run do file
do "$code_dir\_sub_code\_amz_mt_rkng_tx_renda_por_ocupacao.do"

//////////////////////////////////////////////////
//	Rankings de taxa de crescimento da massa salarial 
//////////////////////////////////////////////////

//	Por grandes setores econômicos 
* run do file
do "$code_dir\_sub_code\_amz_mt_rkng_tx_massa_por_setor.do"

//	Por setores atividade econônmica (CNAE)
* run do file
do "$code_dir\_sub_code\_amz_mt_rkng_tx_massa_por_atividade.do"

//	Por setores tipo de ocupação (COD)
* run do file
do "$code_dir\_sub_code\_amz_mt_rkng_tx_massa_por_ocupacao.do"