import pandas as pd
import os
import glob
from matplotlib import pyplot as plt

# zawęzanie okna¶
# nazwa funkcji: limiter(DF,name,main_category,category,goal_usd,duration,country,currency)

# argumenty (input):
# DF - data frame do ucięcia
# name - nazwa kampanii
# main category - wiadomo
# category - wiadomo
# goal - wnioskowana kwota, przeliczona na dolary
# duration - czas trwania kampanii
# country - wiadomo
# currency - wiadomo

# output: DF_limited

# założenia

# na podstawie wprowadzonych danych funkcja ma za zadanie ograniczyć rozmiar dataframe'u do projektów, które są "podobne" do ocenianego przez apkę
# TYMCZASOWO - funkcja będzie zawężać pełny data frame, otwarty tutaj, docelowo będzie korzystać z data frame otwartego przez inny kawałek apki
# TYMCZASOWO - koszyki dla wnioskowanej kwoty, czasu trwania kampanii i krajów powyznaczam "jakoś" na podstawie notebooka z analizami, doszlifuję je w dalszym etapie w razie potrzeby
# SPECJALNA WARTOŚĆ DLA INPUTÓW: 'not considered', stosowana gdy nie chcemy za bardzo zawężać
# do zrobienia:
# zakodowanie koszyków zakresów goal - na podstawie wyników od NU/PA

##### alternatywnie - zamiast koszykowania automatyczny wybór

# dodatki / pomysły:
# napisanie generatora losowych danych testowych? - BS?
# słowa kluczowe - przeszukanie datasetu pod kątem słów najczęściej występujących w nazwach projektów (np. w danej kategorii), które odniosły sukces i ewentualne uwzględnienie takich słów, jeśli występują w naszej nazwie?
# podejście alternatywne - sprawdzenie najczęściej występujących w nazwach słów i określenie "skuteczności" projektów zawierających dane słowo? (temu pomysłowi brakuje czegoś..)
# przygotowanie odpowiedniego inputu - PA?
# po outpucie, ewentualny powrót z rozszerzeniem na kategorie lub waluty (lub inne - do dodania bez problemu) - MZ?



file_path = (glob.glob(os.path.join(os.path.abspath(''), '**', '*kickstarter_filtered*.tsv'), recursive=True))

DF = pd.read_csv(file_path[0], header = 0, sep='\t')


#koszykownik dla zadanego goal

def basket_goal(goal):
    if goal <= 500:
        goal_min = 0
        goal_max = 600
    elif goal <= 1000:
        goal_min = 300
        goal_max = 1200
    elif goal <= 2000:
        goal_min = 800
        goal_max = 2500
    elif goal <= 4000:
        goal_min = 1500
        goal_max = 5000
    elif goal <= 10000:
        goal_min = 4000
        goal_max = 12000
    elif goal <= 20000:
        goal_min = 8000
        goal_max = 25000
    elif goal <= 40000:
        goal_min = 16000
        goal_max = 50000
    elif goal < 100000:
        goal_min = 30000
        goal_max = 120000
    else:
        goal_min = 80000
        goal_max = 20000000000
    return[goal_min, goal_max]



# kosztkowanie w zależności od zadanego czasu trwania

def basket_dur(dur):
    if dur < 30:
        dur_min = 0
        dur_max = 29
    elif dur == 30:
        dur_min = 30
        dur_max = 30
    else:
        dur_min = 31
        dur_max = 100
    return[dur_min, dur_max]


# koszykowanie w zależności od wybranego kraju


europe_list = [  # 'Australia',
                'Austria',
                'France',
                'Switzerland',
                'Belgium',
                'Denmark',
                # 'Canada',
                # 'Singapore',
                # 'New Zealand',
                # 'Hong Kong',
                'Sweden',
                'Germany',
                'Ireland',
                'Luxembourg',
                # 'Japan',
                'Netherlands',
                'Italy',
                'Great Britain (UK)',
                'Spain',
                # 'United States',
                # 'Mexico',
                'Norway']
other_country_list = ['Australia',
                      # 'Austria',
                      # 'France',
                      # 'Switzerland',
                      # 'Belgium',
                      # 'Denmark',
                      'Canada',
                      'Singapore',
                      'New Zealand',
                      'Hong Kong',
                      # 'Sweden',
                      # 'Germany',
                      # 'Ireland',
                      # 'Luxembourg',
                      'Japan',
                      # 'Netherlands',
                      # 'Italy',
                      # 'Great Britain (UK)',
                      # 'Spain',
                      # 'United States',
                      'Mexico',
                      # 'Norway',
                      'Other'
                      ]



def basket_country(country):
    if country == 'United States':
        return ['United States']
    elif country in europe_list:
        return europe_list
    elif country in other_country_list:
        return other_country_list
    else:
        return other_country_list

# poniżej niepotrzebne badziewie - koszykownik dla kategorii

# koszykownik dla kategorii - niepotrzebny
#
# def basket_cat(mcat,cat):
#     if mcat == 'Art':
#         if cat in ['Sculpture',
#                  'Conceptual Art',
#                  'Illustration',
#                  'Public Art',
#                  'Mixed Media',
#                  'Video Art',
#                  'Art',
#                  'Installations',
#                  'Ceramics',
#                  'Textiles',
#                  'Painting',
#                  'Digital Art',
#                  'Performance Art']:
#             return(['Sculpture',
#                  'Conceptual Art',
#                  'Illustration',
#                  'Public Art',
#                  'Mixed Media',
#                  'Video Art',
#                  'Art',
#                  'Installations',
#                  'Ceramics',
#                  'Textiles',
#                  'Painting',
#                  'Digital Art',
#                  'Performance Art'])
#     elif mcat == 'Comics':
#         if cat in ['Comic Books',
#                  'Events',
#                  'Anthologies',
#                  'Graphic Novels',
#                  'Comics',
#                  'Webcomics']:
#             return(['Comic Books',
#                  'Events',
#                  'Anthologies',
#                  'Graphic Novels',
#                  'Comics',
#                  'Webcomics'])
#     elif mcat == 'Crafts':
#         if cat in ['Weaving',
#                  'Letterpress',
#                  'Crochet',
#                  'Candles',
#                  'Taxidermy',
#                  #'Crafts',
#                  'Knitting',
#                  'Embroidery',
#                  'Pottery',
#                  'Glass',
#                  'Quilts',
#                  'Printing',
#                  'DIY',
#                  'Stationery',
#                  'Woodworking']:
#             return(['Weaving',
#                  'Letterpress',
#                  'Crochet',
#                  'Candles',
#                  'Taxidermy',
#                  #'Crafts',
#                  'Knitting',
#                  'Embroidery',
#                  'Pottery',
#                  'Glass',
#                  'Quilts',
#                  'Printing',
#                  'DIY',
#                  'Stationery',
#                  'Woodworking'])
#         elif cat in ['Crafts']:
#             return(['Crafts'])
#     elif mcat == 'Dance':
#         if cat in ['Dance', 'Spaces', 'Residencies', 'Workshops', 'Performances']:
#             return(['Dance', 'Spaces', 'Residencies', 'Workshops', 'Performances'])
#     elif mcat == 'Design':
#         if cat in ['Graphic Design',
#                  'Product Design',
#                  'Civic Design',
#                  'Interactive Design',
#                  'Architecture',
#                  'Typography',
#                  'Design']:
#             return(['Graphic Design',
#                  'Product Design',
#                  'Civic Design',
#                  'Interactive Design',
#                  'Architecture',
#                  'Typography',
#                  'Design'])
#     elif mcat == 'Fashion':
#         if cat in ['Couture',
#                  'Childrenswear',
#                  'Footwear',
#                  'Fashion',
#                  'Accessories',
#                  'Jewelry',
#                  'Apparel',
#                  'Ready-to-wear',
#                  'Pet Fashion']:
#             return(['Couture',
#                  'Childrenswear',
#                  'Footwear',
#                  'Fashion',
#                  'Accessories',
#                  'Jewelry',
#                  'Apparel',
#                  'Ready-to-wear',
#                  'Pet Fashion'])
#     elif mcat == 'Film & Video':
#         if cat in ['Television',
#                  'Horror',
#                  'Film & Video',
#                  'Science Fiction',
#                  'Music Videos',
#                  'Documentary',
#                  'Family',
#                  'Animation',
#                  'Fantasy',
#                  'Experimental',
#                  'Movie Theaters',
#                  'Comedy',
#                  'Webseries',
#                  'Festivals',
#                  'Romance',
#                  'Drama',
#                  'Shorts',
#                  'Narrative Film',
#                  'Thrillers',
#                  'Action']:
#             return(['Television',
#                  'Horror',
#                  'Film & Video',
#                  'Science Fiction',
#                  'Music Videos',
#                  'Documentary',
#                  'Family',
#                  'Animation',
#                  'Fantasy',
#                  'Experimental',
#                  'Movie Theaters',
#                  'Comedy',
#                  'Webseries',
#                  'Festivals',
#                  'Romance',
#                  'Drama',
#                  'Shorts',
#                  'Narrative Film',
#                  'Thrillers',
#                  'Action'])
#     elif mcat == 'Food':
#         if cat in ['Spaces',
#                  'Vegan',
#                  'Drinks',
#                  'Restaurants',
#                  'Food',
#                  'Events',
#                  'Farms',
#                  'Cookbooks',
#                  "Farmer's Markets",
#                  'Food Trucks',
#                  'Community Gardens',
#                  'Small Batch',
#                  'Bacon']:
#             return(['Spaces',
#                  'Vegan',
#                  'Drinks',
#                  'Restaurants',
#                  'Food',
#                  'Events',
#                  'Farms',
#                  'Cookbooks',
#                  "Farmer's Markets",
#                  'Food Trucks',
#                  'Community Gardens',
#                  'Small Batch',
#                  'Bacon'])
#     elif mcat == 'Games':
#         if cat in ['Playing Cards',
#                  'Puzzles',
#                  'Games',
#                  'Mobile Games',
#                  'Gaming Hardware',
#                  'Video Games',
#                  'Tabletop Games',
#                  'Live Games']:
#             return(['Playing Cards',
#                  'Puzzles',
#                  'Games',
#                  'Mobile Games',
#                  'Gaming Hardware',
#                  'Video Games',
#                  'Tabletop Games',
#                  'Live Games'])
#     elif mcat == 'Journalism':
#         if cat in ['Print', 'Video', 'Journalism', 'Web', 'Photo', 'Audio']:
#             return(['Print', 'Video', 'Journalism', 'Web', 'Photo', 'Audio'])
#     elif mcat == 'Music':
#         if cat in ['Classical Music',
#                  'Faith',
#                  'Chiptune',
#                  'Blues',
#                  'Indie Rock',
#                  'Pop',
#                  'Kids',
#                  'Hip-Hop',
#                  'World Music',
#                  'Jazz',
#                  'Latin',
#                  'Metal',
#                  'Comedy',
#                  'Country & Folk',
#                  'R&B',
#                  'Rock',
#                  'Music',
#                  'Punk',
#                  'Electronic Music']:
#             return(['Classical Music',
#                  'Faith',
#                  'Chiptune',
#                  'Blues',
#                  'Indie Rock',
#                  'Pop',
#                  'Kids',
#                  'Hip-Hop',
#                  'World Music',
#                  'Jazz',
#                  'Latin',
#                  'Metal',
#                  'Comedy',
#                  'Country & Folk',
#                  'R&B',
#                  'Rock',
#                  'Music',
#                  'Punk',
#                  'Electronic Music'])
#     elif mcat == 'Photography':
#         if cat in ['Photobooks',
#                  'Animals',
#                  'Places',
#                  'Nature',
#                  'People',
#                  'Fine Art',
#                  'Photography']:
#             return(['Photobooks',
#                  'Animals',
#                  'Places',
#                  'Nature',
#                  'People',
#                  'Fine Art',
#                  'Photography'])
#     elif mcat == 'Publishing':
#         if cat in ['Radio & Podcasts',
#                  'Art Books',
#                  'Literary Journals',
#                  'Poetry',
#                  'Calendars',
#                  'Comedy',
#                  'Letterpress',
#                  'Literary Spaces',
#                  "Children's Books",
#                  'Zines',
#                  'Academic',
#                  'Publishing',
#                  'Anthologies',
#                  'Periodicals',
#                  'Nonfiction',
#                  'Fiction',
#                  'Translations',
#                  'Young Adult']:
#             return(['Radio & Podcasts',
#                  'Art Books',
#                  'Literary Journals',
#                  'Poetry',
#                  'Calendars',
#                  'Comedy',
#                  'Letterpress',
#                  'Literary Spaces',
#                  "Children's Books",
#                  'Zines',
#                  'Academic',
#                  'Publishing',
#                  'Anthologies',
#                  'Periodicals',
#                  'Nonfiction',
#                  'Fiction',
#                  'Translations',
#                  'Young Adult'])
#     elif mcat == 'Technology':
#         if cat in [#'Technology',
#                  'Wearables',
#                  #'Apps',
#                  'Space Exploration',
#                  'Sound',
#                  #'Gadgets',
#                  #'Software',
#                  '3D Printing',
#                  'Robots',
#                  'DIY Electronics',
#                  #'Hardware',
#                  #'Web',
#                  'Makerspaces',
#                  'Camera Equipment',
#                  'Flight',
#                  'Fabrication Tools']:
#             return([#'Technology',
#                  'Wearables',
#                  #'Apps',
#                  'Space Exploration',
#                  'Sound',
#                  #'Gadgets',
#                  #'Software',
#                  '3D Printing',
#                  'Robots',
#                  'DIY Electronics',
#                  #'Hardware',
#                  #'Web',
#                  'Makerspaces',
#                  'Camera Equipment',
#                  'Flight',
#                  'Fabrication Tools'])
#         else:
#             return([cat])
#     elif mcat == 'Theater':
#         if cat in ['Spaces',
#                  'Comedy',
#                  'Festivals',
#                  'Experimental',
#                  'Musical',
#                  'Theater',
#                  'Plays',
#                  'Immersive']:
#             return(['Spaces',
#                  'Comedy',
#                  'Festivals',
#                  'Experimental',
#                  'Musical',
#                  'Theater',
#                  'Plays',
#                  'Immersive'])
#
#
#
# ## definicja


def limiter(df, mcat, cat, goal, dur, country, curr):
    goal_min = basket_goal(goal)[0]
    goal_max = basket_goal(goal)[1]
    war_goal_min = df['goal_in_usd'] >= goal_min
    war_goal_max = df['goal_in_usd'] <= goal_max

    war_mcat = df['main_category'] == mcat

    dur_min = basket_dur(dur)[0]
    dur_max = basket_dur(dur)[1]
    war_dur_min = df['duration'] >= dur_min
    war_dur_max = df['duration'] <= dur_max

    country_list = basket_country(country)
    war_country = df['country'].isin(country_list)
    # print(country_list)

    if cat != 'not considered':
        war_cat = df['category'] == cat
    else:
        war_cat = df['category'] != ''


    if curr == 'not considered':
        war_curr = df['currency'] != ''
    elif curr == 'USD':
        war_curr = df['currency'] == 'USD'
    else:
        war_curr = df['currency'] != 'USD'

    return (df.loc[(war_goal_min) & (war_goal_max) & (war_mcat) & (war_cat) & (war_dur_max) & (war_dur_min) & (war_curr) & (war_country)])




# pr_main_category = 'Technology'
# pr_category = 'Gadgets'
# #pr_category = 'not considered'
# pr_goal_usd = 700
# pr_duration = 30
# pr_country = 'United States'
# #pr_currency = 'USD'
# pr_currency = 'not considered'


# DF_limited = limiter(DF,pr_main_category,pr_category,pr_goal_usd,pr_duration,pr_country,pr_currency)
#
# print(DF_limited['currency'])
# print('ilosc "podobnych" :',DF_limited['id'].count())
# print(DF_limited[DF_limited['state'] == 'successful']['id'].count() / DF_limited['id'].count())