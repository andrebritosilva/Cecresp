#Include "PROTHEUS.CH"

User Function CVALDATE()

Local aArea     := GetArea()
Local nDias     := 0
Local dDtAtu    := STOD("")
Local dDtIni  := dDataBase
Local dDtFin  := DaySum( dDtIni , 3 ) //Soma Dias em Uma Data
 
//Enquanto a data atual for menor ou igual a data final
dDtAtu := dDtIni
While dDtAtu <= dDtFin
    //Se a data atual for uma data Válida
    If dDtAtu == DataValida(dDtAtu) 
        nDias++
    EndIf
     
    dDtAtu := DaySum(dDtAtu, 1)
EndDo
 
RestArea(aArea)

Return dDtAtu
