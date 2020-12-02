#include "fileio.ch"

User Function ANEXOFL()

	Local cDirArq   := PARAMIXB[1]
	Local cArq      := PARAMIXB[2]
	Local aArquivos := PARAMIXB[3]
	Local cEncode64 := ""
	Local nArq      := 0
	Local nEof      := 0
	Local cBuffer   := ""
	Local cArquivo  := ""
	Local lRetorno  := .T.
	Local nCont     := 0
	Local aArea     := GetArea()
	Local aTemp		:= {}
	Local aCardData	:= {}
	Local aArquivo  := {}

	/*If MsgYesNo( "Deseja iniciar a solicitação de pagamento?", "Solicitação de Pagamento" )
		For nCont := 1 to Len(aArquivos)
		
			nArq := fOpen(aArquivos[nCont])
		
			if nArq > -1 // abriu arquivo com sucesso
				cBuffer:= Space(nEof:=Fseek(nArq,0,2))
			
				Fseek(nArq,0,0)                        // posiciona no inicio do arquivo
				fRead(nArq,@cBuffer,nEof)              // lê o arquivo (conteudo) e armazena em cBuffer
				fClose(nArq)                           // fecha o arquivo
			
				cArquivo := Encode64(cBuffer)           // Compacta o arquivo para transmissão WEB
				
				aAdd(aArquivo, {cArquivo, cArq, cArq})
			
				lRetorno := xEnvDados(cArquivo)
			
			else
				lRetorno := .F.
				MsgInfo("Arquivo Inválido!")
			endif
		
		Next nCont
	EndIf

	RestArea(aArea)*/

Return lRetorno

//----------------------------------------------------------------------------------

Static Function xEnvDados(cArquivo,cArq)

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
	aAdd(aCab, {"dtVencimento"           , NT3_DATA})
	aAdd(aCab, {"txtValor"               , STR(NT3_VALOR)})
	aAdd(aCab, {"txtCodPagamento"        , "BOL"})
	aAdd(aCab, {"txtTipoPagamento"       , "BOLETO"})
	aAdd(aCab, {"txtObs"                 , Alltrim(NT3_DESC)})
	aAdd(aCab, {"dtEmissao"              , NT3_DATA})
	
	aDados		:= {{aArquivo}, "admin", "UjbguSST", "solicitacaoPagamento", 5}

	lRet := U_CJURE04(aCab, aDados)

	RestArea( aArea )

Return lRet