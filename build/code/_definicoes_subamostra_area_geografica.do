***************************************************
** Definição de Área Geográfica					***
***************************************************

if "$sub_amostra_area_geografica" == "Amazônia Legal"   {
    keep if UF == 11 	/* 	Rondônia
	*/ 	| UF == 12 	/* Acre
	*/ 	| UF == 13 	/* Amazonas
	*/ 	| UF == 14 	/* Roraima
	*/ 	| UF == 15 	/* Pará
	*/ 	| UF == 16 	/* Amapá
	*/ 	| UF == 17 	/* Tocantins
	*/ 	| UF == 51 	/* Mato Grosso
	*/ 	| (UF == 21 & V1023 == 4) 	// Maranhão & Resto da UF (Unidade da Federação, excluindo a região metropolitana e a RIDE)
	
	local area = "amazonia_legal"
}
else if "$sub_amostra_area_geografica" == "Amazônia Legal Rural"   {
    keep if UF == 11 	/* 	Rondônia
	*/ 	| UF == 12 	/* Acre
	*/ 	| UF == 13 	/* Amazonas
	*/ 	| UF == 14 	/* Roraima
	*/ 	| UF == 15 	/* Pará
	*/ 	| UF == 16 	/* Amapá
	*/ 	| UF == 17 	/* Tocantins
	*/ 	| UF == 51 	/* Mato Grosso
	*/ 	| (UF == 21 & V1023 == 4) 	// Maranhão & Resto da UF (Unidade da Federação, excluindo a região metropolitana e a RIDE)

	gen domicilio_rural = 0
	replace domicilio_rural = 1 if V1022 ==2 // 2 Rural
	keep if domicilio_rural==1
	cap drop domicilio_rural
}
else if "$sub_amostra_area_geografica" == "Amazônia Legal Urbana"   {
    keep if UF == 11 	/* 	Rondônia
	*/ 	| UF == 12 	/* Acre
	*/ 	| UF == 13 	/* Amazonas
	*/ 	| UF == 14 	/* Roraima
	*/ 	| UF == 15 	/* Pará
	*/ 	| UF == 16 	/* Amapá
	*/ 	| UF == 17 	/* Tocantins
	*/ 	| UF == 51 	/* Mato Grosso
	*/ 	| (UF == 21 & V1023 == 4) 	// Maranhão & Resto da UF (Unidade da Federação, excluindo a região metropolitana e a RIDE)

	gen domicilio_urbano = 0
	replace domicilio_urbano = 1 if V1022 ==1 // 1 Urbana
	keep if domicilio_urbano==1
	cap drop domicilio_urbano
}	
else if "$sub_amostra_area_geografica" == "Amazônia Legal Metropolitana"   {
    keep if UF == 11 	/* 	Rondônia
	*/ 	| UF == 12 	/* Acre
	*/ 	| UF == 13 	/* Amazonas
	*/ 	| UF == 14 	/* Roraima
	*/ 	| UF == 15 	/* Pará
	*/ 	| UF == 16 	/* Amapá
	*/ 	| UF == 17 	/* Tocantins
	*/ 	| UF == 51 	/* Mato Grosso
	*/ 	| (UF == 21 & V1023 == 4) 	// Maranhão & Resto da UF (Unidade da Federação, excluindo a região metropolitana e a RIDE)

	gen tempvar1 = 0
	replace tempvar1 = 1 if (V1023 == 1 | V1023 == 2)
	keep if tempvar1==1
	drop tempvar1
}	
else if "$sub_amostra_area_geografica" == "Resto do Brasil"   {
    drop if UF == 11 	/* 	Rondônia
	*/ 	| UF == 12 	/* Acre
	*/ 	| UF == 13 	/* Amazonas
	*/ 	| UF == 14 	/* Roraima
	*/ 	| UF == 15 	/* Pará
	*/ 	| UF == 16 	/* Amapá
	*/ 	| UF == 17 	/* Tocantins
	*/ 	| UF == 51 	/* Mato Grosso
	*/ 	| (UF == 21 & V1023 == 4) 	// Maranhão & Resto da UF (Unidade da Federação, excluindo a região metropolitana e a RIDE)

	local area = "resto_brasil"
}
else if "$sub_amostra_area_geografica" == "Mato Grosso"   {
    keep if UF == 51 	// Mato Grosso

	local area = "mato_grosso"
}	
else if "$sub_amostra_area_geografica" == "Acre"   {
    keep if UF == 12 	// Acre

	local area = "acre"
}
else if "$sub_amostra_area_geografica" == "Amazonas"   {
    keep if UF == 13 	// Amazonas

	local area = "amazonas"
}
else if "$sub_amostra_area_geografica" == "Amapa"   {
    keep if UF == 16 	// Amapa

	local area = "amapa"
}
else if "$sub_amostra_area_geografica" == "Roraima"   {
    keep if UF == 14 	// Roraima

	local area = "roraima"
}
else if "$sub_amostra_area_geografica" == "Rondonia"   {
    keep if UF == 11 	// Rondonia

	local area = "rondonia"
}
else if "$sub_amostra_area_geografica" == "Tocantins"   {
    keep if UF == 17 	// Tocantins

	local area = "tocantins"
}
else if "$sub_amostra_area_geografica" == "Pará"   {
    keep if UF == 15 	// Pará

	local area = "para"
}		
else if "$sub_amostra_area_geografica" == "Maranhao"   {
    keep if (UF == 21 & V1023 == 4) 	// Maranhão & Resto da UF (Unidade da Federação, excluindo a região metropolitana e a RIDE)

	local area = "maranha"
}			
else if "$sub_amostra_area_geografica" == "Manaus"   {
    keep if UF == 13 & (V1023 == 1 | V1023 == 2) 	// Amazonas & Capital | Resto da RM (Região Metropolitana, excluindo a capital)

	local area = "manaus"
}
else if "$sub_amostra_area_geografica" == "Belem"   {
    keep if UF == 15 & (V1023 == 1 | V1023 == 2) 	// Amazonas & Capital | Resto da RM (Região Metropolitana, excluindo a capital)

	local area = "belem"
}
