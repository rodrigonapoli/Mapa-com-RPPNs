#Script para montar um mapa com numero de RPPNs no Brasil

library("readxl") #para ler o arquivo em excel
library("rgdal") #para ler o arquivo em OGD (banco de dados dos mapas)
library ("RColorBrewer") #cores
library ('leaflet') #para plotar os mapas

#abrindo o arquivo
dados <- read_excel("Dados/grafico.xlsx", sheet=1)

dados$Estado <- as.factor(dados$Estado )
dados$UF <- as.factor(dados$UF )


#abrindo o shapefile com os dados dos estados brasileiros
shp <- readOGR(dsn = "Dados/BR_UF_2022", layer = "BR_UF_2022", stringsAsFactors=FALSE, encoding="UTF-8")
summary (shp)

#criando o DF com shapefile para usar no mapa
rppn <- merge(shp,dados, by.x = "SIGLA_UF", by.y = "UF")  

#criando as informações para aparecer no pop-up do mapa interativo 
state_popup <- paste0("<strong>Estado: </strong>", 
                      rppn$NM_UF, 
                      "<br><strong>RPPNs: </strong>", 
                      rppn$Numero)

#definindo as cores do mapa
display.brewer.all() #palheta de cores
pal <- colorBin("OrRd",domain = rppn$Numero,n=1)

#Montando o mapa
leaflet(data = rppn) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(fillColor = ~pal(rppn$Numero), 
              fillOpacity = 0.5, 
              color = "black", 
              weight = 0.2, 
              popup = state_popup) %>%
  addLegend("bottomright", values = pal,
            title = "Número de RPPNs",
            pal = pal,
            labels = rppn$Numero)


