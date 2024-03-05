-- Drop the table if it exists
DROP TABLE IF EXISTS  county_census, city_to_county, sites, 
samples, covid_N, covid_S, influenza_A, influenza_B, PMMoV CASCADE;

-- Create the county_census table
CREATE TABLE county_census (
  state_name VARCHAR(40),
  state_abbr CHAR(2),
  county_name VARCHAR(80),
  state_fips CHAR(2),
  county_fips CHAR(3),
  year INT,
  median_age DECIMAL,
  average_household_income DECIMAL,
  per_capita_income DECIMAL,
  PRIMARY KEY (state_fips, county_fips)
);

-- Create the city_to_county table
CREATE TABLE city_to_county (
  city VARCHAR(40),
  state_abbr CHAR(2),
  county VARCHAR(80),
  state_fips CHAR(2),
  county_fips CHAR(3),
  PRIMARY KEY (city, state_abbr),
  FOREIGN KEY (state_fips, county_fips) REFERENCES county_census(state_fips, county_fips)
);

-- Create the sites table
CREATE TABLE sites (
  site_id VARCHAR NOT NULL,
  site_name VARCHAR(120),
  city VARCHAR(40),
  state_abbr CHAR(2),
  sewershed_pop INT,
  PRIMARY KEY (site_id),
  FOREIGN KEY (city, state_abbr) REFERENCES city_to_county(city, state_abbr)
);


-- Create the samples table
CREATE TABLE samples (
  sample_id VARCHAR(30) NOT NULL,
  site_id VARCHAR NOT NULL,
  collection_date DATE NOT NULL,
  year INT NOT NULL,
  PRIMARY KEY (sample_id),
  FOREIGN KEY (site_id) REFERENCES sites(site_id)
);

-- Create the covid_N table
CREATE TABLE covid_N (
  sample_id VARCHAR(30),
  dry_weight DECIMAL,
  dry_weight_lci DECIMAL,
  dry_weight_uci DECIMAL,
  covn_id VARCHAR NOT NULL,
  PRIMARY KEY (covn_id),
  FOREIGN KEY (sample_id) REFERENCES samples(sample_id)
);

-- Create the covid_S table
CREATE TABLE covid_S (
  sample_id VARCHAR(30),
  dry_weight DECIMAL,
  dry_weight_lci DECIMAL,
  dry_weight_uci DECIMAL,
  covs_id VARCHAR NOT NULL,
  PRIMARY KEY (covs_id),
  FOREIGN KEY (sample_id) REFERENCES samples(sample_id)
);

-- Create the influenza_A table
CREATE TABLE influenza_A (
  sample_id VARCHAR(30),
  dry_weight DECIMAL,
  dry_weight_lci DECIMAL,
  dry_weight_uci DECIMAL,
  infa_id VARCHAR NOT NULL,
  PRIMARY KEY (infa_id),
  FOREIGN KEY (sample_id) REFERENCES samples(sample_id)
);

-- Create the influenza_B table
CREATE TABLE influenza_B (
  sample_id VARCHAR(30),
  dry_weight DECIMAL,
  dry_weight_lci DECIMAL,
  dry_weight_uci DECIMAL,
  infb_id VARCHAR NOT NULL,
  PRIMARY KEY (infb_id),
  FOREIGN KEY (sample_id) REFERENCES samples(sample_id)
);

-- Create the PMMoV table
CREATE TABLE PMMoV (
  sample_id VARCHAR(30),
  dry_weight DECIMAL,
  dry_weight_lci DECIMAL,
  dry_weight_uci DECIMAL,
  pmmov_id VARCHAR NOT NULL,
  PRIMARY KEY (pmmov_id),
  FOREIGN KEY (sample_id) REFERENCES samples(sample_id)
);




-- Select all rows from the county_census table
SELECT * FROM county_census;

-- Select all rows from the city_to_county table
SELECT * FROM city_to_county;

-- Select all rows from the sites table
SELECT * FROM sites;

-- Select all rows from the samples table
SELECT * FROM samples;

-- Select all rows from the covid_N table
SELECT * FROM covid_N;

-- Select all rows from the covid_S table
SELECT * FROM covid_S;

-- Select all rows from the influenza_A table
SELECT * FROM influenza_A;

-- Select all rows from the influenza_B table
SELECT * FROM influenza_B;

-- Select all rows from the influenza_B table
SELECT * FROM PMMoV;