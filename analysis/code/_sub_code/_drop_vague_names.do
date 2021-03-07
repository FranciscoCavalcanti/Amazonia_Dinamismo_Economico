* drop vague names
cap gen vague_names = 0
cap replace vague_names = regexm(titulo, "não especificad") | /*
	*/ regexm(titulo, "não classificad") 	
cap drop if vague_names==1
cap drop vague_names
