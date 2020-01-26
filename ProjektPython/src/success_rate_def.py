import pandas as pd
from IPython.display import YouTubeVideo

def success_ratio(data_frame):
    
    success_number = data_frame['state'][data_frame['state']=='successful'].count()
    failed_number = data_frame['state'][data_frame['state']=='failed'].count()
    cancelled_number = data_frame['state'][data_frame['state']=='canceled'].count()
    all_number = success_number + failed_number + cancelled_number
    
    data_frame_size = data_frame.shape[0]
    
    if success_number == 0 and failed_number == 0 and cancelled_number == 0:
        print('Sorry, for this particular setting we haven\'t found any campaign at all!\nYou are sailing some uncharted waters here!')
    elif success_number >= 0 and all_number > 0:
        success_ratio = success_number / all_number
        if data_frame.shape[0] < 10:
            print('The overall success ratio is: ',round(success_ratio,4)*100,'%')
            print('However due to lack of sufficient data this is based on a very small number of past campaigns.\nIf you\'d like to check the odds for a bigger sample, please consider changing some of the parameters (e.g. use \'not considered\' or \'other\'')
            print('FYI, here are the campaigns we found similar:')
            display(data_frame.style.format({'percentage_of_money_collected': "{:.2%}"}))
            # print(data_frame) # tutaj coś zmienić, żeby df się ładniej wyświetlało
        elif data_frame.shape[0] < 50:
            print('The overall success ratio is: ',round(success_ratio,4)*100,'%')
            print(f'However due to lack of sufficient data this is based on a limited number of past campaigns\n({data_frame_size} to be exact).\nIf you\'d like to check the odds for a bigger sample, please consider changing some of the parameters to either \'not considered\' or \'any\'')
        else:
            print('The success ratio for past campaigns similar to yours is:\n',round(success_ratio,4)*100,'%')
            print('This is based on a sample of ',data_frame_size,' previous campaigns')
         
    else:
        print('something went really wrong, contact the admin!')


# chiptune easter egg

    if pd.unique(data_frame['category']).any():
        if pd.unique(data_frame['category'])[0]=='Chiptune':
            display(YouTubeVideo('rf_p3-8fTo0', autoplay=1, loop=1))