# Data Engineering Project: Wastewater Database
Andrea Ceriati\
Kathryn Lesh\
Michelle Minkowitz

## Project introduction

This data engineering project works with wastewater monitoring data. Wastewater monitoring is the process of taking samples from sewage (for example, at a treatment plant) and testing it for the genetic material from certain diseases, such as Covid, flu, RSV, and others. The results give a snapshot of the prevalence of the target disease in the community served by the that sewage system (“sewershed”). To be sure, results from samples at a treatment plant only give information in a relatively large aggregate: cities or larger, as opposed to individuals or neighborhoods. However, wastewater monitoring has the enormous advantage that the entire population served by the sewershed is unequivocally captured in the tests. There is no need to rely on potentially biased sampling or heroic efforts to reach every person in the population—--and then rely on the accuracy of their responses. In the memorable words of those who study wastewater, “Everybody poops.” As a result, wastewater monitoring obtains information that cannot be reliably obtained by surveys, counting hospital or doctor office visits, tabulating lab results, and so forth. 

The CDC collects such data, which is reported from a variety of different entities. We originally looked at CDC data and downloaded it, but it seemed to be unwieldy and difficult to manage. To simplify the data management, we looked at Wastewater Scan (https://www.wastewaterscan.org), which is one of the organizations that reports data to the CDC. Wastewater Scan is under the aegis of Stanford and Emory Universities and appears to be a trustworthy data source, producing scholarly research. 

Our initial download from Wastewater Scan contains 42,813 observations from 194 collection sites spread throughout the country. The distribution of the 194 collection sites is uneven, perhaps because Wastewater Scan is a proof-of-concept project. The download contains data for a number of diseases, such as Covid, flu, and Mpox, as well as the standard control virus (Pepper mild mottle virus). Each sample is identified by a unique sample id, together with its collection site name, city, state, and sewershed population.

To enrich the data set, we constructed an API call for census data for income data and age on a county level, because a sewershed often covers an area larger than a municipality but much smaller than a state. Integration of this data set will allow the study of the disease-detection data from wastewater in concert with demographic information such as median household income and per capita income. For this particular project, we took a proof-of-concept approach and only integrated census data from the year 2022. 

## Data engineering

We integrated data from Wastewater Scan and the Census Bureau (both structured data sets) into a single relational database, with the ultimate goal of gaining insights into disease prevalence and also its correlation with demographic characteristics such as socioeconomic factors by geographical regions. The Census Bureau data was obtained via API call and consists of 3223 records of 2022 demographic data at the county level. The Wastewater Scan data was downloaded as a csv file from their website and consists of 42,813 records.

We chose PostgreSQL for the database system because it is powerful, widely used, and handles complex data relationships well. Its scalability and reliability are ideal for our large datasets. The relational database schema facilitates efficient data storage, retrieval, and analysis. 

### ETL

Data extraction from Wastewater Scan was via a csv download. Census data was obtained for 2022 via an API call documented in the ETL notebook for census data. 

Data cleaning identified and rectified inconsistencies, addressed missing values, and managed data uniqueness and duplicates. For instance, census data returned by the API call was missing information for Fairfield County, CT for 2022. We opted to use data from the previous year for the same county to maintain data continuity. In the the data sourced from Wastewater Scan, we checked for anomalies or irregularities. One issue we found was that there were sites located in different cities but sharing the same site name. We disambiguated the site name by appending the city name to the original site name. 

After cleaning, we split the wastewater data into smaller, more manageable tables, one for each disease, following standard normalization practices to optimize our database design. We added appropriate keys according to the database design described below. It is possible to visualize the database tables from the screenshots folder.

### Database design

The database design assumes that the user will want to efficiently analyze and derive insights from the combined datasets of wastewater monitoring and demographic information. This adds the potential for valuable demographic insights like median age, household income, and per capita income, strengthening analytical options.

To visualize the structure and relationships within the database, we created an Entity-Relationship Diagram (ERD). The ERD allowed us to refine our understanding of the relationships between different parts of the data and optimize smooth data retrieval and analysis. Clear connections between entities and well-defined relationships allow users to plan how they will navigate through the data to uncover insights and trends in as part of research in public health. The ERD is pictured below:

<img src="Screenshots/ERD.png" width="600">

## Data delivery 

The audience for our project is people interested in public health, perhaps specifically to show the potential benefits of wastewater monitoring as a policy tool. 

We chose Flask for a delivery tool for its simplicity, compatibility with Python, and routing capabilities. With Flask, data delivery from a SQL database involves setting up routes in the application to handle requests. These routes connect to the database, run queries, and format data (usually as JSON) before sending it to clients. This approach seamlessly integrates database content into Flask apps, delivering dynamic information to users via web browsers. Leveraging Flask's simplicity and modularity streamlines development, ensuring secure data delivery for scalable web applications.

### Data delivery prototype

Our Flask application (app.py) connects to a PostgreSQL database via the engine
* engine= create_engine('postgresql://postgres:[password]@localhost:5432/wastewater_db') 

and sets up routes to retrieve specific data. The route '/' renders an HTML template. The '/api/full_data' route fetches all data from the 'sites' table and returns it as JSON. The '/api/v1.0/<siteName>' route retrieves data related to a specific site name, including sewershed population size and samples of various contaminants. Lastly, the '/api/multi_query' route executes a complex query to retrieve demographic and contamination data for California counties in 2022. Each route uses Pandas' read_sql function to execute SQL queries and converts the results into a dictionary for JSON output.

### Future development of delivery method

In future iterations, the Flask application can be upgraded to feature a richer user interface. For example, it would be helpful to integrate Plotly for interactive data visualization. With Plotly, dynamic charts, graphs, and maps can be generated to provide users with clearer insights into wastewater data, pathogen levels, and demographic trends. Such enhancements would improve user experience and facilitate more informed decision making regarding wastewater management and public health concerns.

## Ethical and legal considerations

During the development of the wastewater database, in addition to verifying that our project was allowed by the licenses of the source data, we considered concerns regarding privacy, as well as potential data misuses. Wastewater analysis can provide information about much more than the level of diseases in a community---for example, it could be used to look at the level of drug use, illicit or otherwise. Further, even anonymized data on human subjects inherently raises privacy issues, risking inadvertent identification or disclosure of sensitive health information. For example, we learned that it is possible to take wastewater surveillance to a more granular level, sampling at particular manholes rather than at a treatment plant, or even sampling from a particular building. Depending on the goal and intention of such sampling, there is clearly a balance to be achieved between privacy and public health, and different people and communities will have differing opinions about where lines should be drawn.

Even in the aggregate, singling out communities based on certain substances or pathogens in their wastewater may lead to stigmatization and discrimination. Concerns also arise regarding potential misuse of the public health data by entities beyond public health authorities, for example by law enforcement. As technology for learning from wastewater continues to evolve, transparency and community engagement must be a high priority. Building trust with monitored communities involves clear communication, outlining data usage protocols, and actively addressing privacy concerns. Engaging communities in decision-making processes ensures alignment with their values, fostering ethical wastewater surveillance practices. 

We are grateful to have had a colleague point out a [Freakonomics Radio Podcast](https://freakonomics.com/podcast/water-water-everywhere-but-you-have-to-stop-and-think/), which helped us to think more deeply about these issues.  

## Licenses and attributions

### WastewaterSCAN: 

Data on wastewater is from [WastewaterSCAN](https://www.wastewaterscan.org/en/faqs#data), and is used under the Creative Commons license [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/deed.en). No changes were made to the original data. The results in the database are provided "as is" and without warranty of any kind. 

### CensusBureau:

Data on census is from [Census Bureau](https://www.census.gov/data/developers/about/terms-of-service.html). This product uses the Census Bureau Data API but is not endorsed or certified by the Census Bureau. No changes were made to the original data but the addition of the 2021 census data for Fairfield County, CT, that was not available in the 2022 data. The API is provided "as is" and on an "as-available" basis. The Census Bureau hereby disclaim all warranties of any kind.

