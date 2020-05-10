# import pandas as pd
# import os
# import glob

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



# file_path = (glob.glob(os.path.join(os.path.abspath(''), '**', '*kickstarter_filtered*.tsv'), recursive=True))
#
# DF = pd.read_csv(file_path[0], header = 0, sep='\t')


#koszykownik dla zadanego goal

goal_bins = [(0.00, 500.0), (500.0, 1000.0), (1000.0, 1500.0), (1500.0, 2200.0), (2200.0, 3000.0), (3000.0, 4000.0), (4000.0, 5000.0), (5000.0, 6500.0), (6500.0, 9000.0), (9000.0, 10000.0), (10000.0, 15000.0), (15000.0, 20381.13), (20381.13, 32223.0), (32223.0, 60000.0), (60000.0, 1663613900)]
bin_tab_mod = 1.2

def basket_goal(goal):
    for bin in goal_bins:
        if goal >= bin[0] and goal < bin[1] :
            goal_min = bin[0]/bin_tab_mod
            goal_max = bin[1]*bin_tab_mod
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
                'Norway',
                'Poland']
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
                      'Other',
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

# kursy walut, bo korzystamy z USD w koszykowaniu goal ,
# czyli musimy wiedzieć ile zbieramy w dolarach
kursy_walut = {'SGD': 0.7218272535233189, 'EUR': 1.1238612937944434, 'DKK': 0.14862087297218637, 'CAD': 0.8145423808817589, 'AUD': 0.8029694136890776, 'GBP': 1.5207327949927543, 'USD': 1.0, 'MXN': 0.05303800288397823, 'HKD': 0.12838130718608456, 'CHF': 1.0320771710383756, 'JPY': 0.008826237200036304, 'SEK': 0.12031274002718356, 'NZD': 0.7616139550831179, 'NOK': 0.12166770926093867, 'PLN': 0.3125}

def limiter(df, mcat, cat, goal, dur, country, curr):
    goal_usd = kursy_walut[curr] * goal

    goal_min = basket_goal(goal_usd)[0]
    goal_max = basket_goal(goal_usd)[1]
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



#
# pr_main_category = 'Technology'
# #pr_category = 'Gadgets'
# pr_category = 'not considered'
# pr_goal_usd = 5500
# pr_duration = 30
# pr_country = 'United States'
# #pr_currency = 'USD'
# pr_currency = 'USD'


# DF_limited = limiter(DF,pr_main_category,pr_category,pr_goal_usd,pr_duration,pr_country,pr_currency)
#
# print(DF_limited['currency'])
# print('ilosc "podobnych" :',DF_limited['id'].count())
# print(DF_limited[DF_limited['state'] == 'successful']['id'].count() / DF_limited['id'].count())