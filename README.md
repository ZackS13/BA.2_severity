# BA.2_severity
Author: Zachary Strasser and Hossein Estiri

Code for analyzing omicron BA.2 lineage data

This code is meant to calculate adjusted OR with IPTW

Patient data cannot be shared. The analysis requires data formatted in the following matter. This can be a CSV or dataframe. THE FOLLOWING DATA IS NOT REAL AND PROVIDED ONLY FOR UNDERSTANDING THE TABLE FORMATTING

| female | age | race | hispanic | vaccine_status | mortality | hospitalization | ventilation | icu | era | Onset | elixhauser_index | prior_infection | Steroids | anti-viral |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |:---: |
| 1 | 99 | BLACK OR AFRICAN AMERICAN | 0 | 0 | Y | Y | N | N |  Delta | 2021-09-15 | 7 |  0 | 1 | 1 |
| 1 | 80 | WHITE | 0 | 0 | N | Y| Y | Y |  Omicron | 2021-12-20 | 4 |  0 | 1 | 1 |

The following lists the possible values for each of the columns and how the patient data should be cleaned and organized.

female: 1, 0 (1 representative of female) <br> 
age: integer  <br> 
race: "BLACK OR AFRICAN AMERICAN", "WHITE", "OTHER/UNKNOWN", "ASIAN"  <br> 
hispanic: 1, 0 (1 representative of hispanic)  <br> 
vaccine_status: integer (0 for No vaccine, 1 for First dose, 2 for Two doses, 3 for Vaccinated with Booster)  <br> 
mortality: Y, N  <br> 
hospitalization: Y, N  <br> 
ventilation: Y, N  <br> 
icu: Y, N  <br> 
era: "Delta", "Omicron", "0post-Omicron" <br> 
Onset: date  <br> 
exlihauser_index: integer  (calculated using comorbidity package on extracted ICD codes)   <br> 
prior infection: integer (0 is first infection, 1 is one prior infection, ect.)  <br> 
Steroids: integer (0 is none, 1 is dexamethasone is given)  <br> 
anti.viral: integer (0 is none, 1 is remdesivir or nirmatrelvir/ritonavir is given)

