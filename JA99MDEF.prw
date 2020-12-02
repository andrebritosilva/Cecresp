#INCLUDE "PROTHEUS.ch"

User Function JA99MDEF()

Local aRotina := {}

aAdd(aRotina,{ "Fluig", "U_XFlJA99()", 0 , 2, 0, .F.})

Return aRotina

//--------------------------------------------------------------------------------------------------------------

User Function XFlJA99()

Local aArea    := GetArea()
Local cChave   := Alltrim(NT3_FILIAL) + Alltrim(NT3_CAJURI) + Alltrim(NT3_COD)
Local cQuery   := ""
Local cArqTrb  := GetNextAlias()
Local cDestino := MsDocPath()
Local nArq     := 0
Local cBuffer  := ""
Local nEof     := 0
Local cArquivo := 0
Local cArq     := ""
Local aArquivo := {}

cDestino := cDestino + "\"
/*DbSelectArea( "NUM" )
DbSetOrder(3)

If NUM->( DbSeek(xFilial("NT3") + 'NT3' + cChave) )
	Alert("Deu certo")
EndIf*/
	
cQuery := "SELECT R_E_C_N_O_, * FROM "
cQuery += RetSqlName("NUM") + " NUM "
cQuery += " WHERE "
cQuery += " NUM_FILIAL = '" + Alltrim(NT3_FILIAL) + "' "
cQuery += " AND NUM_ENTIDA = 'NT3' "
cQuery += " AND NUM_CENTID = '" + cChave + "' "
cQuery += " AND D_E_L_E_T_ = ' ' "
	
cQuery := ChangeQuery(cQuery) 
 
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqTrb,.T.,.T.)

(cArqTrb)->(dbGoTop())

Do While (cArqTrb)->(!Eof())
	
	NUM->(DbGoto((cArqTrb)->R_E_C_N_O_))
	
	nArq := fOpen(cDestino + NUM_NUMERO)
	cArq := Alltrim(NUM_DOC) + Alltrim(NUM_EXTEN) 
	
	if nArq > -1 // abriu arquivo com sucesso
		cBuffer:= Space(nEof:= Fseek(nArq,0,2))
	
		Fseek(nArq,0,0)                        // posiciona no inicio do arquivo
		fRead(nArq,@cBuffer,nEof)              // lê o arquivo (conteudo) e armazena em cBuffer
		fClose(nArq)                           // fecha o arquivo
	
		cArquivo := Encode64(cBuffer)           // Compacta o arquivo para transmissão WEB
		
		aAdd(aArquivo, {cArquivo, cArq, cArq})
	
	else
		lRetorno := .F.
		MsgInfo("Arquivo Inválido!")
	endif
	
	(cArqTrb)->(DbSkip())
		
EndDo

lRetorno := xEnvDados(cArquivo, aArquivo)

RestArea( aArea )

Return 

//----------------------------------------------------------------------------------

Static Function xEnvDados(cArquivo,aArquivo)

	Local aArea    := GetArea()
	Local aCab     := {}
	Local aDados   := {}
	Local lRet     := .F.
    Local cNomeEmp := FWCompanyName()
    Local cCodEmp  := FWCodEmp()
    Local cFilNome := FWFilialName()
    
    DbSelectArea( "NT3" )
	DbSetOrder(1)
	
	aAdd(aCab, {"processoId"             , "0" })//Ver como será gerado o ID
	aAdd(aCab, {"txtNome"                , "nome teste"})//Nome solicitante - pessoa logada
	aAdd(aCab, {"txtCodFornecedor"       , "000001"})
	aAdd(aCab, {"txtLoja"                , "01"})
	aAdd(aCab, {"txtFornecedor"          , "TOTVS"})
	aAdd(aCab, {"txtCodFilial"           , xFilial("SE1")})
	aAdd(aCab, {"txtCodEmpresa"          , Alltrim(cCodEmp)})
	aAdd(aCab, {"txtNomEmpresa"          , Alltrim(cNomeEmp)})
	aAdd(aCab, {"txtFilial"              , Alltrim(cFilNome)})
	aAdd(aCab, {"txtCodCentroCusto"      , "0011002"})
	aAdd(aCab, {"txtCentroCusto"         , "UNIDADE JURIDICA"})
	aAdd(aCab, {"txtCodDocumento"        , Alltrim(NT3_CAJURI) })
	aAdd(aCab, {"txtTipoDocumento"       , Alltrim(NT3_CTPDES)})
	aAdd(aCab, {"dtVencimento"           , Dtoc(NT3_DATA)})
	aAdd(aCab, {"txtValor"               , STR(NT3_VALOR)})
	aAdd(aCab, {"txtCodPagamento"        , "BOL"})
	aAdd(aCab, {"txtTipoPagamento"       , "BOLETO"})
	aAdd(aCab, {"txtObs"                 , Alltrim(NT3_DESC)})
	aAdd(aCab, {"dtEmissao"              , Dtoc(NT3_DATA)})
	
	aDados		:= {{aArquivo}, "admin", "UjbguSST", "solicitacaoPagamento", 5}

	lRet := U_CJURE04(aCab, aDados)

	RestArea( aArea )

Return lRet