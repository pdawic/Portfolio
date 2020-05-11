import numpy as np
import pandas as pd
import csv
import folium
from folium.plugins import MarkerCluster
from folium.plugins import MiniMap

from folium import FeatureGroup, LayerControl, Marker

########## MAPA ##########
pozycjaGdansk = [54.346320, 18.649246]
Stations_map = folium.Map(location=pozycjaGdansk, zoom_start=10, tiles='OpenStreetMap')
minimap = MiniMap(toggle_display=True)
minimap.add_to(Stations_map)

########## Import wydziałów
wsad_wydzialy = 'LK.csv'

########## Generowanie pozycju wydzialow
with open(wsad_wydzialy, mode='r') as pozycjeLK:
    wydzialLocationsReader = csv.DictReader(pozycjeLK)
    for LKRow in wydzialLocationsReader:
        Latitude = float(LKRow['Latitude'])
        Longitude = float(LKRow['Longitude'])

        CoordinatesLK = [Latitude, Longitude]

        wydzialLK = (LKRow['Wydzial'])

        iconLK = folium.Icon(icon='home', icon_color='white', color='red')

        markerWydzialLK = folium.Marker(location=CoordinatesLK, popup=wydzialLK, icon=iconLK)

        Stations_map.add_child(markerWydzialLK)

########## Import i czyszczenie danych dotyczących stacji
wsad_stacje = pd.read_csv('GPS_Stacje_Petro.csv', sep=';', usecols=['convert_point', 'name', 'isActive'])

wsad_stacje=wsad_stacje[wsad_stacje['isActive'] == 'tak']

wsad_stacje['convert_point']=wsad_stacje['convert_point'] + wsad_stacje['name']


########## Zrobienie stringa pod slicera dla wspolrzednych
Wspolrzedne_stacji=[]
for wiersz in wsad_stacje['convert_point']:
    y=wiersz.replace('POINT (','').replace(')',' ').split(' ')
    Wspolrzedne_stacji.append(y)

wsad_stacje['convert_point']=Wspolrzedne_stacji

Stacje_cluster = MarkerCluster()
for element in wsad_stacje['convert_point']:
    latitude = float(element[1])
    longitude = float(element[0])
    coordinates = [latitude, longitude]
    Station_name = element[2]
    Station_marker = folium.Marker(location=coordinates, popup=Station_name)
    # Stations_map.add_child(Station_marker)
    Stacje_cluster.add_child(Station_marker)
Stations_map.add_child(Stacje_cluster)

########## Zaciagniecie danych o szlakach
wsad_railways=pd.read_csv('Railways.csv',sep=';',usecols=['id','Railways','lineNo'])

########## Wyczyszczenie kolumny Railways - FINAL
Railways=[]
for wiersz in wsad_railways['Railways']:
    y=wiersz.replace('LINESTRING (','').replace(')','').replace('MULTI(','').replace('(','') #pytanie co robi MULTILINESTRING w IN 7325?
    Railways.append(y)

wsad_railways['Railways'] = Railways

########## Pętla dzieląca na stringi
krotka = []
for wiersz in wsad_railways['Railways']:
    splited_string_wiersz = wiersz.split(', ')
    krotka.append(splited_string_wiersz)

wsad_railways['NoweWartosci'] = krotka

########## Pętla dzieląca tupla ne tuple stringów
wiersz_series=[]
for element in wsad_railways['NoweWartosci']:
    krotka0 = []
    for item in element:
        item = item.split(' ')
        krotka0.append(item)
    wiersz_series.append(krotka0)

wsad_railways['NoweWartosciFinal'] = wiersz_series

########## Pętle przekształacające tuple stringów na listę stringów, zamienia współrzędne miejscami
railway_points_list=[]
for element in wsad_railways['NoweWartosciFinal']:
    float_tuples_list = []
    for str_pair_tuple in element:
        # print("tu",str_pair_tuple ) # Sprawdzenie gdzie jest błąd w wartościach
        value_str_1, value_str_2 = str_pair_tuple
        float_pair_tuple = float(value_str_2), float(value_str_1)
        float_tuples_list.append(float_pair_tuple)
        element=float_tuples_list
    railway_points_list.append(element)

wsad_railways['railway_points_list'] = railway_points_list

########## add lines
folium.PolyLine(railway_points_list, color="blue", weight=2.5, opacity=1, popup=wsad_railways['lineNo']).add_to(Stations_map)

########## Save map
Stations_map.save('Stations_map.html')