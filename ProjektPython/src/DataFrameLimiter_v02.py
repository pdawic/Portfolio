### DEFINICJE POTRZEBNYCH  KOSZYKÓW

#koszykownik dla zadanego goal

goal_bins = [(0.00, 500.0), (500.0, 1000.0), (1000.0, 1500.0), (1500.0, 2200.0), (2200.0, 3000.0), (3000.0, 4000.0), (4000.0, 5000.0), (5000.0, 6500.0), (6500.0, 9000.0), (9000.0, 10000.0), (10000.0, 15000.0), (15000.0, 20381.13), (20381.13, 32223.0), (32223.0, 60000.0), (60000.0, 1663613900)]
#poniżej "rozcięgnięcie koszyków, żeby zakres "podonych kwot" nie urywał się skokowo
bin_tab_mod = 1.2

def basket_goal(goal):
    if goal == 0:
        return [0,200000000]
    for bin in goal_bins:
        if goal >= bin[0] and goal < bin[1] :
            goal_min = bin[0]/bin_tab_mod
            goal_max = bin[1]*bin_tab_mod
    return[goal_min, goal_max]



# kosztkowanie w zależności od zadanego czasu trwania

def basket_dur(dur):
    if dur == 0:
        dur_min = 0
        dur_max = 100
    elif dur < 30:
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
# prosty podział: USA, Europa, Reszta świata


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

all_countries = europe_list + other_country_list + ['United States',]


def basket_country(country):
    if country == 'United States':
        return ['United States']
    elif country == 'not considered':
        return all_countries
    elif country in europe_list:
        return europe_list
    elif country in other_country_list:
        return other_country_list
    else:
        return other_country_list

'''
kursy walut, zapytanie w jupyterze, tutaj jedynie wynik
konieczne, bo korzystamy z USD w koszykowaniu goal ,
'''


kursy_walut = {'SGD': 0.7218272535233189, 'EUR': 1.1238612937944434, 'DKK': 0.14862087297218637, 'CAD': 0.8145423808817589, 'AUD': 0.8029694136890776, 'GBP': 1.5207327949927543, 'USD': 1.0, 'MXN': 0.05303800288397823, 'HKD': 0.12838130718608456, 'CHF': 1.0320771710383756, 'JPY': 0.008826237200036304, 'SEK': 0.12031274002718356, 'NZD': 0.7616139550831179, 'NOK': 0.12166770926093867, 'PLN': 0.3125, 'Specify goal in USD':1}

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

    if cat != 'not considered':
        war_cat = df['category'] == cat
    else:
        war_cat = df['category'] != ''



    return (df.loc[(war_goal_min) & (war_goal_max) & (war_mcat) & (war_cat) & (war_dur_max) & (war_dur_min) & (war_country)])


