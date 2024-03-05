from flask import Flask, render_template
from sqlalchemy import create_engine, func
import pandas as pd

#-------------
# Database Connection
#-------------
engine = create_engine('postgresql://postgres:123@localhost:5432/wastewater_db')

#-------------
# Flask Setup
#-------------
app=Flask(__name__)

#-------------
# Flask Routes  
#-------------

@app.route("/")
def home():
    return render_template("index.html")

@app.route('/api/full_data')
def getData():
    return pd.read_sql('''
                       
    SELECT *
    FROM sites
                        
    ''', engine).to_dict()
                       
##Query that retrieves the sewershed population size, and samples of covid_n, covid_s, influenaza_a, influenza_b based on the site name selected in the home route
# that calls the site names from api/full_data which generate the name for the route '/api/v1.0/<siteName>':

@app.route('/api/v1.0/<siteName>')
def siteCall(siteName):
    return pd.read_sql(f'''
        SELECT
            s.sewershed_pop,
            cn.dry_weight covid_n,
            cs.dry_weight covid_s,
            ia.dry_weight influenza_a,
            ib.dry_weight influenza_b
        FROM sites s
        JOIN samples
        USING (site_id)
        JOIN covid_n cn
        USING (sample_id)
        JOIN covid_s cs
        USING (sample_id)
        JOIN influenza_a ia
        USING (sample_id)
        JOIN influenza_b ib
        USING (sample_id)
        WHERE s.site_name = '{siteName}'                
        ''', engine).to_dict()

##Query that retrieves the median age, average household income,
##and covid_N information for each county in a specific state for a given year:

@app.route('/api/multi_query')
def multiquery():
    return pd.read_sql('''

SELECT cc.county_name,
       cc.median_age,
       cc.average_household_income,
       cn.dry_weight,
       cn.dry_weight_lci,
       cn.dry_weight_uci
FROM county_census cc
JOIN city_to_county ctc ON cc.state_fips = ctc.state_fips AND cc.county_fips = ctc.county_fips
JOIN sites s ON ctc.city = s.city AND ctc.state_abbr = s.state_abbr
JOIN samples samp ON s.site_id = s.site_id
LEFT JOIN covid_N cn ON samp.sample_id = cn.sample_id
WHERE cc.state_abbr = 'CA' AND samp.year = 2023;                               
          
    ''', engine).to_dict()


if __name__=='__main__':
    app.run()