# na wszelki wypadek import biblioteki widgetów, bo czasami wywalało błędy
import ipywidgets as widgets

# widget wyboru głównej kategorii
main_category = widgets.Dropdown(
    options=['Art',
             'Fashion',
             'Music',
             'Crafts',
             'Photography',
             'Design',
             'Film & Video',
             'Food',
             'Journalism',
             'Publishing',
             'Dance',
             'Comics',
             'Technology',
             'Theater',
             'Games'],
    description='M. category',
    disabled=False,)

# widget wyboru podkategorii, który tworzy się na podstawie wyboru głównej kategorii
sub_category = widgets.Dropdown(
    description="Category")

# o tutaj jest funkcja, która wykorzystuje słownik zbudowany na zasadzie {główne kategorie: adekwatne podkategorie}, 
# żeby ustawić w dropdownie odpowiednie podkategorie
# (to jest ogólnie de facto tak, że tworzymy zmienne typu widget, które mają odpowiednie parametry)
def narrow_subcat(*args):
    sub_categories = {'Art': 
                      ['Sculpture',
                       'Conceptual Art',
                       'Illustration',
                       'Public Art',
                       'Mixed Media',
                       'Video Art',
                       'Art',
                       'Installations',
                       'Ceramics',
                       'Textiles',
                       'Painting',
                       'Digital Art',
                       'Performance Art',
             'not considered'],
                      'Comics': 
                      ['Comic Books',
                       'Events',
                       'Anthologies',
                       'Graphic Novels',
                       'Comics',
                       'Webcomics',
             'not considered'],
                      'Crafts':
                      ['Weaving',
                       'Letterpress',
                       'Crochet',
                       'Candles',
                       'Taxidermy',
                       'Crafts',
                       'Knitting',
                       'Embroidery',
                       'Pottery',
                       'Glass',
                       'Quilts',
                       'Printing',
                       'DIY',
                       'Stationery',
                       'Woodworking',
             'not considered'],
                      'Dance': 
                      ['Dance',
                       'Spaces',
                       'Residencies',
                       'Workshops',
                       'Performances',
             'not considered'],
                      'Design': 
                      ['Graphic Design',
                       'Product Design',
                       'Civic Design',
                       'Interactive Design',
                       'Architecture',
                       'Typography',
                       'Design',
             'not considered'],
                      'Fashion': 
                      ['Couture',
                         'Childrenswear',
                         'Footwear',
                         'Fashion',
                         'Accessories',
                         'Jewelry',
                         'Apparel',
                         'Ready-to-wear',
                         'Pet Fashion',
             'not considered'],
                      'Film & Video': 
                      ['Television',
                         'Horror',
                         'Film & Video',
                         'Science Fiction',
                         'Music Videos',
                         'Documentary',
                         'Family',
                         'Animation',
                         'Fantasy',
                         'Experimental',
                         'Movie Theaters',
                         'Comedy',
                         'Webseries',
                         'Festivals',
                         'Romance',
                         'Drama',
                         'Shorts',
                         'Narrative Film',
                         'Thrillers',
                         'Action',
             'not considered'],
                      'Food': 
                      ['Spaces',
                         'Vegan',
                         'Drinks',
                         'Restaurants',
                         'Food',
                         'Events',
                         'Farms',
                         'Cookbooks',
                         "Farmer's Markets",
                         'Food Trucks',
                         'Community Gardens',
                         'Small Batch',
                         'Bacon',
             'not considered'],
                      'Games': 
                      ['Playing Cards',
                         'Puzzles',
                         'Games',
                         'Mobile Games',
                         'Gaming Hardware',
                         'Video Games',
                         'Tabletop Games',
                         'Live Games',
             'not considered'],
                      'Journalism': 
                      ['Print', 
                           'Video', 
                           'Journalism', 
                           'Web', 
                           'Photo',
                           'Audio',
             'not considered'],
                      'Music': 
                      ['Classical Music',
                         'Faith',
                         'Chiptune',
                         'Blues',
                         'Indie Rock',
                         'Pop',
                         'Kids',
                         'Hip-Hop',
                         'World Music',
                         'Jazz',
                         'Latin',
                         'Metal',
                         'Comedy',
                         'Country & Folk',
                         'R&B',
                         'Rock',
                         'Music',
                         'Punk',
                         'Electronic Music',
             'not considered'],
                      'Photography': 
                      ['Photobooks',
                         'Animals',
                         'Places',
                         'Nature',
                         'People',
                         'Fine Art',
                         'Photography',
             'not considered'],
                      'Publishing': 
                      ['Radio & Podcasts',
                         'Art Books',
                         'Literary Journals',
                         'Poetry',
                         'Calendars',
                         'Comedy',
                         'Letterpress',
                         'Literary Spaces',
                         "Children's Books",
                         'Zines',
                         'Academic',
                         'Publishing',
                         'Anthologies',
                         'Periodicals',
                         'Nonfiction',
                         'Fiction',
                         'Translations',
                         'Young Adult',
             'not considered'],
                      'Technology': 
                          ['Technology',
                         'Wearables',
                         'Apps',
                         'Space Exploration',
                         'Sound',
                         'Gadgets',
                         'Software',
                         '3D Printing',
                         'Robots',
                         'DIY Electronics',
                         'Hardware',
                         'Web',
                         'Makerspaces',
                         'Camera Equipment',
                         'Flight',
                         'Fabrication Tools',
             'not considered'],
                      'Theater': 
                      ['Spaces',
                         'Comedy',
                         'Festivals',
                         'Experimental',
                         'Musical',
                         'Theater',
                         'Plays',
                         'Immersive',
             'not considered']}
                      
    sub_category.options = list(sub_categories[main_category.value]) # w tym miejscu ustawiamy parametr dropdowna

# a tutaj ustawiamy ciągły nasłuch zmian w wyborze głównej kategorii i wywołanie funkcji zmiany parametru narrow_subcat
main_category.observe(narrow_subcat) 

# widget wyboru kraju
country = widgets.Dropdown(
    options=['Australia',
             'Austria',
             'France',
             'Switzerland',
             'Belgium',
             'Denmark',
             'Canada',
             'Singapore',
             'New Zealand',
             'Hong Kong',
             'Sweden',
             'Germany',
             'Ireland',
             'Luxembourg',
             'Japan',
             'Netherlands',
             'Italy',
             'Great Britain (UK)',
             'Spain',
             'United States',
             'Mexico',
             'Norway',
             'Poland',
             'Other',
             'not considered'],
    value='not considered',
    description="Country",
    disabled=False,
)

# widget wyboru ile chcemy zebrać w kampanii
goal = widgets.BoundedIntText(
    value=0,
    min=0,
    max=1000000000,
    step=1,
    description="Goal",
    disabled=False
)


'''modyfikacja, żeby automatycznie wybierała się waluta'''

kraj_waluta = {'not considered': 'Specify goal in USD','Poland':'PLN','Other':'Specify goal in USD','Singapore': 'SGD', 'Ireland': 'EUR', 'Norway': 'NOK', 'New Zealand': 'NZD', 'Netherlands': 'EUR', 'Australia': 'AUD', 'Spain': 'EUR', 'Mexico': 'MXN', 'Hong Kong': 'HKD', 'United States': 'USD', 'Denmark': 'DKK', 'Japan': 'JPY', 'Luxembourg': 'EUR', 'Italy': 'EUR', 'Germany': 'EUR', 'Canada': 'CAD', 'Sweden': 'SEK', 'Great Britain (UK)': 'GBP', 'Belgium': 'EUR', 'Austria': 'EUR', 'Switzerland': 'CHF', 'France': 'EUR'}

# widget wyboru waluty
currency = widgets.Text(
    #options=['HKD','SGD','SEK','JPY','NOK','AUD','GBP','CHF','MXN','CAD','DKK','EUR','NZD','USD','PLN','Specify goal in USD'],
    value=kraj_waluta[country.value],
    description="Currency",
    disabled=True,

)




def set_currency(*args):
    currency.value = kraj_waluta[country.value]
    #currency.options = [kraj_waluta[country.value],]

country.observe(set_currency)



# widget wyboru czasu trwania kampanii
duration = widgets.IntSlider(
    min=0,
    max=90,
    step=1,
    value = 30,
    description='Duration',
    disabled=False,
    continuous_update=True,
    orientation='horizontal',
    readout=True,
    readout_format='d'
)

# widget do wpisania nazwy kamapanii
campaign_name = widgets.Text(
    value='Kickstarter Campaign',
    placeholder='Type something',
    description='Name',
    disabled=False
)


kursy_walut = {'SGD': 0.7218272535233189, 'EUR': 1.1238612937944434, 'DKK': 0.14862087297218637, 'CAD': 0.8145423808817589, 'AUD': 0.8029694136890776, 'GBP': 1.5207327949927543, 'USD': 1.0, 'MXN': 0.05303800288397823, 'HKD': 0.12838130718608456, 'CHF': 1.0320771710383756, 'JPY': 0.008826237200036304, 'SEK': 0.12031274002718356, 'NZD': 0.7616139550831179, 'NOK': 0.12166770926093867, 'PLN': 0.3125, 'Specify goal in USD':1}


goal_in_usd = widgets.Text(
    description="Goal in $",
    disabled=True,
)


def convert_goal_to_usd(*args):
    goal_in_usd.value = str(int(goal.value)*kursy_walut[currency.value])

goal.observe(convert_goal_to_usd)
country.observe(convert_goal_to_usd)