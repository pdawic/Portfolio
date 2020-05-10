from tkinter import *
from tkinter import ttk
from ttkthemes import themed_tk as tk
from PIL import Image, ImageTk

from sklearn import preprocessing
import xgboost as xgb


import pickle
import numpy as np
import pandas as pd
import tkinter.messagebox




with open("Analiza_Modeli/model_reg.pickle", 'rb') as file:
    trained_regmodel = pickle.load(file)

with open("Analiza_Modeli/model_class.pickle", 'rb') as file:
    trained_classmodel = pickle.load(file)

trained_regmodel
trained_classmodel

with open("encoders.pickle", 'rb') as file2:
    encoders = pickle.load(file2)

encoders

version = 'v0.102'

####### pomocnicze zmienne listy itp #####################


kursy_walut = {'SGD': 0.7218272535233189, 'EUR': 1.1238612937944434, 'DKK': 0.14862087297218637, 'CAD': 0.8145423808817589, 'AUD': 0.8029694136890776, 'GBP': 1.5207327949927543, 'USD': 1.0, 'MXN': 0.05303800288397823, 'HKD': 0.12838130718608456, 'CHF': 1.0320771710383756, 'JPY': 0.008826237200036304, 'SEK': 0.12031274002718356, 'NZD': 0.7616139550831179, 'NOK': 0.12166770926093867, 'PLN': 0.3125, 'Specify goal in USD':1}

kraj_waluta = {'not considered': 'Specify goal in USD','Poland':'PLN','Other':'Specify goal in USD','Singapore': 'SGD', 'Ireland': 'EUR', 'Norway': 'NOK', 'New Zealand': 'NZD', 'Netherlands': 'EUR', 'Australia': 'AUD', 'Spain': 'EUR', 'Mexico': 'MXN', 'Hong Kong': 'HKD', 'United States': 'USD', 'Denmark': 'DKK', 'Japan': 'JPY', 'Luxembourg': 'EUR', 'Italy': 'EUR', 'Germany': 'EUR', 'Canada': 'CAD', 'Sweden': 'SEK', 'Great Britain (UK)': 'GBP', 'Belgium': 'EUR', 'Austria': 'EUR', 'Switzerland': 'CHF', 'France': 'EUR'}

chosen_main_cat = ''
chosen_country = ''
chosen_subcat = ''
chosen_currency = ''

chosen_goal = ''
chosen_main_cat_cat = ''
chosen_duration = 30




############# definicje fukcji ##########


# pomocnicza z kursu tkinter
def doNothing():
    print("ok ok I won't...")



# sprawdzenie i użycie testowe wybranych w widźetach parametrów
def checkParamas():
    tmpCAT = catMenu.get()
    tmpCNTR = countryMenu.get()
    tmpSUBCAT = subcatMenu.get()
    tmpGOAL = goalSpinbox.get()
    tmpDUR = durationSpinbox.get()

    global chosen_main_cat
    chosen_main_cat = tmpCAT

    global chosen_duration
    chosen_duration = tmpDUR

    global chosen_country
    chosen_country = tmpCNTR

    global chosen_subcat
    chosen_subcat = tmpSUBCAT

    global chosen_goal
    chosen_goal = tmpGOAL

    global  chosen_main_cat_cat
    chosen_main_cat_cat = f"{chosen_main_cat}>{chosen_subcat}"

    if tmpCAT != '' and tmpCNTR != '' and tmpSUBCAT != '' and tmpGOAL != '' and tmpDUR != '':
        localCURR = kraj_waluta[tmpCNTR]
        global chosen_currency
        chosen_currency = localCURR
        localGOAL = round(float(tmpGOAL) / kursy_walut[localCURR], 1)
        paramInfolabel.configure(text = f"Your Campaign's main category: {tmpCAT}\n"
                                        f"Your Campaing's sub category : {tmpSUBCAT}\n"
                                        f"Your Campaign's launch country: {tmpCNTR}\n"
                                        f"Your Campaign's duration: {tmpDUR}\n"
                                        f"Your Campaign's goal is {tmpGOAL} USD ({localGOAL} in {localCURR} ).\n"
                                        f"All parameters selected. Check your chances... EVALUATE CAMPAIGN")
    else:
        paramInfolabel.configure(text=f"Not all parameters selected!")


#pomocnicza funkcja sprawdzająca (w konsoli) czy została zapisana wartość globalnej zmiennej main_chosen
def run_magic():
    print(chosen_main_cat)


#kodowanie podanych danych
def input_encode():
    global enc_main_cat_cat
    enc_main_cat_cat = encoders['main_cat_cat'].transform([chosen_main_cat_cat])
    global enc_country
    enc_country = encoders['country'].transform([chosen_country])
    global enc_currency
    enc_currency = encoders['currency'].transform([chosen_currency])


def predict_pledged():
    input_encode()
    data = pd.DataFrame(data = {'main_cat_cat': enc_main_cat_cat, 'country':enc_country, 'duration' : float(chosen_duration), 'currency': enc_currency, 'goal_in_usd': float(chosen_goal)})

    preds = trained_regmodel.predict(data)
    pred_succes = trained_classmodel.predict(data)
    if pred_succes.mean() == 1 and preds.mean() > int(chosen_goal):
        resultlabel.configure(text=f"Propably you WILL SUCCED !! \n"
                                   f"You may have a chance to reach even higher GOAL : {preds.mean().round()}$!")
    elif pred_succes.mean() == 1 and preds.mean() < int(chosen_goal):
        resultlabel.configure(text=f"Propably you WILL SUCCED !! \n"
                                   f"The GOAL you've chosen looks JUST OK!")

    elif pred_succes.mean() == 0 and preds.mean() < int(chosen_goal) and preds.mean() > 0:
        resultlabel.configure(text=f"Propably you WILL LOOSE $$$. \n"
                                   f"You may have a chance to collect around : {preds.mean().round()}$.")

    else:
        resultlabel.configure(text=f"Propably you WILL LOOSE money. \n"
                                   f"For your campaign, we CANNOT suggest a reasonable GOAL.")


######### lista podkategorii do wyboru dla poszczególnych wybrbanych main_category
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
                           'Performance Art'],
                      'Comics':
                          ['Comic Books',
                           'Events',
                           'Anthologies',
                           'Graphic Novels',
                           'Comics',
                           'Webcomics'],
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
                           'Woodworking'],
                      'Dance':
                          ['Dance',
                           'Spaces',
                           'Residencies',
                           'Workshops',
                           'Performances'],
                      'Design':
                          ['Graphic Design',
                           'Product Design',
                           'Civic Design',
                           'Interactive Design',
                           'Architecture',
                           'Typography',
                           'Design'],
                      'Fashion':
                          ['Couture',
                           'Childrenswear',
                           'Footwear',
                           'Fashion',
                           'Accessories',
                           'Jewelry',
                           'Apparel',
                           'Ready-to-wear',
                           'Pet Fashion'],
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
                           'Action'],
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
                           'Bacon'],
                      'Games':
                          ['Playing Cards',
                           'Puzzles',
                           'Games',
                           'Mobile Games',
                           'Gaming Hardware',
                           'Video Games',
                           'Tabletop Games',
                           'Live Games'],
                      'Journalism':
                          ['Print',
                           'Video',
                           'Journalism',
                           'Web',
                           'Photo',
                           'Audio'],
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
                           'Electronic Music'],
                      'Photography':
                          ['Photobooks',
                           'Animals',
                           'Places',
                           'Nature',
                           'People',
                           'Fine Art',
                           'Photography'],
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
                           'Young Adult'],
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
                           'Fabrication Tools'
                           ],
                      'Theater':
                          ['Spaces',
                           'Comedy',
                           'Festivals',
                           'Experimental',
                           'Musical',
                           'Theater',
                           'Plays',
                           'Immersive'],
                      '':
                          ['choose main category first']
                           }


#funkcja, która daje listę podkategorii do wyboru na podstawie wybranej kategorii
def narrow_subcat(event):
    tmpCAT = catMenu.get()
    subcatMenu.configure(values = sub_categories[tmpCAT])






################### definicja interfesju ############
'''
Tkinter opiera się o "ramki" - frames, w których upakowuje się poszczególne fragmentu interfejsu:
- przyciski
- pola tekstowe
- menu wybieralne
- slidery
- okienka inputu
i pewnie jeszce wiele innych

ramek może być wiele poziomów, sam stosuje poniżej "ramki w większych ramkach"

'''



# ***** GUI start *****


#root - główna, najbardziej zewnętrzna ramka, definiowana jako klasa ThemedTk (themed, zeby skorzystać z predefiniowanego styu)
# "okno programu, nazwa root wzięta z kursu"

root = tk.ThemedTk()
root.geometry('1000x600')
root.set_theme("clearlooks")




# ***** The Toolbar - górny pasek z przyciakami  *****

#pierwsza zewnętrzna ramka, umieszczamy ją w oknie 'root', "pakujemy" na górze
toolbar = ttk.Frame(root)
toolbar.pack(side = TOP)

#### poniżej definicja przycików używanych, które "pakujemy" w w ramce "toolbar"
#### w dalszej części na podobnej zasadzie są zdefiniowane i "upakowane" pozostałe elementy interfejsu

# *** toolbar buttons *****
insertButt = ttk.Button(toolbar, text="UPDATE PARAMETERS", command=checkParamas)
insertButt.pack(side=LEFT, padx=10, pady=10)

testButt = ttk.Button(toolbar, text="EVALUATE CAMAPIGN", command=predict_pledged)
testButt.pack(side=LEFT, padx=10, pady=10)

quitButt = ttk.Button(toolbar, text="Quit", command=root.quit)
quitButt.pack(side=RIGHT, padx=10, pady=10)








# ***** Menus Frame *****


menuFrame = Frame(root)
menuFrame.configure(padx = 30,pady = 10)


menuFrame.pack(side = TOP)

MenusLabel1 = ttk.Label(menuFrame, text = 'Please specify campaign parameters',font = ('Helvetica', 20, 'bold'), anchor = CENTER )
MenusLabel1.pack(side = TOP, pady = 20)


#** Main Category selector *****

catMenuFrame = Frame(menuFrame, padx = 2, pady = 2)

mcats = ['Art',
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
             'Games']

catMenuLabel = ttk.Label(catMenuFrame, text = 'Choose Main Category    ', anchor = N )
catMenuLabel.pack(side = LEFT)

catMenu = ttk.Combobox(catMenuFrame, values = mcats)
#poniżej odpalenie funkcji, która zawęża podkategorie na podstawie wybranej głównej kategorii
catMenu.bind('<<ComboboxSelected>>', narrow_subcat )
catMenu.pack(side = LEFT)

catMenuFrame.pack(side = TOP)

# ** Sub Category selector *****

subcatMenuFrame = Frame(menuFrame, padx = 2, pady = 2)


subcatMenuLabel = ttk.Label(subcatMenuFrame, text = 'Choose Sub-Category     ' )
subcatMenuLabel.pack(side = LEFT)

subcatMenu = ttk.Combobox(subcatMenuFrame, values = sub_categories[chosen_main_cat])
subcatMenu.pack(side = LEFT)

subcatMenuFrame.pack(side = TOP)


# ** Country selector *****
countryMenuFrame = Frame(menuFrame, padx = 2, pady = 2)


country_list = [ 'Australia',
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
                'Norway']

countryMenuLabel = ttk.Label(countryMenuFrame, text = 'Choose Country          ' )
countryMenuLabel.pack(side = LEFT)

countryMenu = ttk.Combobox(countryMenuFrame, values = country_list)
countryMenu.pack(side = LEFT)

countryMenuFrame.pack(side = TOP)



# ** Goal selector *****
goalMenuFrame = Frame(menuFrame, padx = 2, pady = 2)


goalMenuLabel = ttk.Label(goalMenuFrame, text = 'Set Goal in USD         ' )
goalMenuLabel.pack(side = LEFT)

min_goal = 1
max_goal = 1000000


goalSpinbox = ttk.Spinbox(goalMenuFrame, from_ = min_goal, to = max_goal, increment=50, command = checkParamas)
goalButton = Button(goalMenuFrame, text="OK", command=checkParamas)



goalSpinbox.pack(side = LEFT)

goalButton.pack(side = LEFT, padx = 5)


goalMenuFrame.pack(side = TOP)


# slider poniżej


#przyznam, że w sumie średnio mi się ten slider podoba, do przegadania czy go nie wywalić

sliderFrame = Frame(menuFrame, padx = 2, pady = 2)

goalSlider = Scale(sliderFrame, orient = HORIZONTAL, showvalue = 0, from_ = min_goal, to = max_goal, length = 300, variable = IntVar )
goalSlider.configure(command = goalSpinbox.set)
goalSlider.pack(side = TOP, padx = 0, fill = X )



########### SLIDER GOAL WYŁĄCZONY PONIŻEJ


#sliderFrame.pack(side = TOP)


# ** Duration selector *****
durationMenuFrame = Frame(menuFrame, padx = 2, pady = 2)


durationMenuLabel = ttk.Label(durationMenuFrame, text = 'Choose campaign duration ' )
durationMenuLabel.pack(side = LEFT)

min_dur = 1
max_dur = 90


durationSpinbox = ttk.Spinbox(durationMenuFrame, from_ = min_dur, to = max_dur, increment = 1, command=checkParamas)
durationButton = Button(durationMenuFrame, text="OK", command=checkParamas)


#durationSpinbox.pack(side = LEFT)

#durationButton.pack(side = LEFT, padx = 5)

def dur_slider_contr(event):
    durationSpinbox.set(event)
    checkParamas()

durSlider = Scale(durationMenuFrame, orient = HORIZONTAL, showvalue = 1, from_ = min_dur, to = max_dur, length = 300, variable = IntVar )
durSlider.set(30)

durSlider.configure(command = dur_slider_contr)
durSlider.pack(side = LEFT, padx = 5, fill = X )


durationMenuFrame.pack(side = TOP)


# ### SLIDER DLA DURATION
#
# slider2Frame = Frame(menuFrame, padx = 2, pady = 2)
#
#
#
#
#
#
#
# slider2Frame.pack(side = TOP)



# ***** Main Window showing result *****


mainFrame1 = Frame(root)
mainFrame1.pack(side = TOP, pady = 40)



paramInfolabel = ttk.Label(mainFrame1, text = 'choose campaign parameters',font = ('Times', 11, 'bold'))

paramInfolabel.pack(side = TOP, anchor = CENTER, fill = BOTH)


resultlabel = ttk.Label(mainFrame1, text = '', font = ('Times', 15, 'bold'))

resultlabel.pack(side = TOP, anchor = CENTER, fill = BOTH, pady = 20)



# ***** Status Bar *****

status = ttk.Label(root, text=f"PandP, ML_project, {version}", relief=GROOVE, anchor=W)

status.pack(side=BOTTOM, fill=X)


durationSpinbox.set(30)

checkParamas()




# "włączenie" programu, interfejs musi się zawierać pomiędzy "otwarciem" roota i jego "mainloop'em", trochę jak w html'u
root.mainloop()


