def success_ratio(data_frame):
    
    
    if data_frame['state'][data_frame['state']=='successful'].count()>0 and (data_frame['state'][data_frame['state']=='failed'].count()+data_frame['state'][data_frame['state']=='canceled'].count())>0:
        success_ratio = (data_frame['state'][data_frame['state']=='successful'].count())/(data_frame['state'][data_frame['state']=='failed'].count()+data_frame['state'][data_frame['state']=='canceled'].count()+data_frame['state'][data_frame['state']=='successful'].count())
        if data_frame.shape[0] < 50:
            print('Dear user, due to the fact that the database is limited based on your criterias we suggested to change subcategories, country of your business to not considered')
        print('Overall success ratio is: ',round(success_ratio,2)*100,'%')
        return success_ratio
    else:
        print('No data available')