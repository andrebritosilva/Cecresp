#include 'protheus.ch'
#INCLUDE "TBICONN.CH"

user function CJURE04(aCab, aDados)

	Local cEcmUrl		:= "http://cecresp-centraldasco7430.fluig.cloudtotvs.com.br/webdesk/" //TRIM(SuperGetMv("MV_ECMURL",.F.,""))
	Local cEcmKey		:= "CECRESP_KEY" //TRIM(SuperGetMv("CI_FLGKEY",.F.,"CECRESP_KEY"))			// cConsumerKey
	Local cEcmSecret	:= "CECRESP_KEY_SECRET" //TRIM(SuperGetMv("CI_FLGSEC",.F.,"CECRESP_KEY_SECRET"))	// cConsumerSecret
	Local cAccesTok		:= "3440ba87-e339-47a3-a155-9107316f05fc" //TRIM(SuperGetMv("CI_FLGTOK",.F.,"3440ba87-e339-47a3-a155-9107316f05fc"))			//Access token
	Local cTokenSec		:= "5242c723-788e-4024-836c-9806623b47d2611de4c2-6ce9-459f-9a28-b8504a53dd20" //TRIM(SuperGetMv("CI_FLGTSE",.F.,"5242c723-788e-4024-836c-9806623b47d2611de4c2-6ce9-459f-9a28-b8504a53dd20"))	//Token secret

	Local oCltFluig     

	Local cJson 		:= ""
	Local cRet          := ""
	Local oJson         := Nil
	local nI			:= 1
	local nJ			:= 1
	local cFields		:= ""
	local cValues		:= ""
	local nReserv		:= 10
	
	default aDados		:= {"dGVzdGUNCnRlc3RhbmRv", "admin", "UjbguSST", "solicitacaoPagamento", 5, "teste", "teste.txt"}
	
/*	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"
	
	aAdd(aCab, {"processoId", "0"})
	aAdd(aCab, {"txtNome"   , "nome teste"})
	aAdd(aCab, {"txtCodFornecedor", "000001"})
	aAdd(aCab, {"txtLoja", "01"})
	aAdd(aCab, {"txtFornecedor", "TOTVS"})
	aAdd(aCab, {"txtCodFilial", "200501"})
	aAdd(aCab, {"txtCodEmpresa", "01"})
	aAdd(aCab, {"txtNomEmpresa", "SICOOB CENTRAL CECRESP"})
	aAdd(aCab, {"txtFilial", "CECRESP - MATRIZ"})
	aAdd(aCab, {"txtCodCentroCusto", "0011002"})
	aAdd(aCab, {"txtCentroCusto", "UNIDADE JURIDICA"})
	aAdd(aCab, {"txtCodDocumento", "23101100"})
	aAdd(aCab, {"txtTipoDocumento", "FORUM JURIDICO"})
	aAdd(aCab, {"dtVencimento", "17/07/2019"})
	aAdd(aCab, {"txtValor", "127"})
	aAdd(aCab, {"txtCodPagamento", "BOL"})
	aAdd(aCab, {"txtTipoPagamento", "BOLETO"})
	aAdd(aCab, {"txtObs", "OBSERVACAO"})
	aAdd(aCab, {"dtEmissao", "10/07/2019"})
*/

	
	oCltFluig     := FWoAuth1Fluig():New(cEcmKey,cEcmSecret,cEcmUrl,cEcmUrl)

	cEcmUrl:= STRTRAN(cEcmUrl,"/webdesk/","")
	cEcmUrl:= STRTRAN(cEcmUrl,"/WEBDESK/","")
	
	for nI := 1 to nReserv
	
		cfields += '"fields' + cValtoChar(nI) + '"'
		
		if nI > len(aDados)
		
			cValues += '"value' + cValtoChar(nI) + '"'
		
		else
		
			if valtype(aDados[nI]) == "C"
		
				cValues += '"' + aDados[nI] + '"'
				
			elseif valtype(aDados[nI]) == "N"
			
				cValues += '"' + cValtoChar(aDados[nI]) + '"'
			
			endif
		
		endif

		cFields += ","
		cValues += ","
	
	next
	
	nI := 1
	
	nI += nReserv
	
	for nJ := 1 to Len(aCab)
		
		cfields += '"fields' + cValtoChar(nI) + '", '
		cValues += '"' + aCab[nJ, 1] + '", '
		
		nI++
		
		cfields += '"fields' + cValtoChar(nI) + '"'
		cValues += '"' + aCab[nJ, 2] + '"'
	
		if !(nJ == len(aCab))
	
			cfields += ', '
			cValues += ', '
		
		endif
		
		nI++ 
	
	next

	cJson += "{" + CRLF
	cJson += '"datasetId" : "ds_startProcess",' + CRLF
	cJson += '"filterFields" : [' + cFields + '],' + CRLF
	cJson += '"resultFields" : [' + cValues + '],' + CRLF
	cJson += '"limit" : "50"' + CRLF
	cJson += "}" + CRLF

	oCltFluig:SetToken(cAccesTok) 			//Access token
	oCltFluig:SetSecretToken(cTokenSec) 	//Token secret

	cRet := oCltFluig:Post(cEcmUrl + "/api/public/ecm/dataset/search",,cJson )

	If FWJsonDeserialize(cRet, @oJson)	

		If VALTYPE(oJson:CONTENT[1]:RETORNO) == "C"

			If oJson:CONTENT[1]:RETORNO == "OK"

				Conout("CCFGE03 =========> " + oJson:CONTENT[1]:RETORNO)

			Else

				Conout("CCFGE03 =========> " + oJson:CONTENT[1]:RETORNO)

			EndIf

		EndIf

	Else

		Conout("CCFGE03 =========> Falha no retorno Json")

	EndIf

return lRet
