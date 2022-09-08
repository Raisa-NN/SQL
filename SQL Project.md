# Analyzing Academic Performance and the Factors Possibly Affecting It

                                        Report By Raisa Nkweteyim

Four csv files were received containing data about students' academic performance, student family details, student personal details and student academic information. I uploaded these files unto **SQLite** and joined them to create one reporting table with all the columns included.<br>
In order to create this report and embed sql code in Jupyter Notebook, I used **'DB Browser for SQLite'** to create a database containing 4 tables representing the 4 csv files. I also need to import the sqlite3 and pandas packages for this work.<br>
I created multiple **pivot tables** and generated the graphs in **Google Sheets**.

The dataset for this work was provided by the EntryLevel team (https://www.entrylevel.net/).


```python
# Importing modules
import pandas as pd
import sqlite3 as sql
```


```python
# Creating connection to database file
database = 'academic_performance.db'
connection = sql.connect(database)
```

##### Creating the reporting table


```python
# Joining the 4 tables to make one large reports table and creating new table 'reports_student_colleges'
query = '''
CREATE TABLE reports_student_colleges AS
SELECT *
FROM student_academic_info AS sai
JOIN county_info AS ci
ON sai.id = ci.id
JOIN student_family_details AS sfd
ON ci.id = sfd.id
JOIN student_personal_details AS spd
ON sfd.id = spd.id
'''
df = pd.read_sql_query(query, connection)
df.head()

'''NB: If block of code is ran more than once, an error occurs because the reporting table (reports_student_colleges) has
already been created'''
```

*Definitions for some of the column names can be found below:*

gender: :factor indicating gender.<br>ethnicity: factor indicating ethnicity (African-American, Hispanic, Asian or other).<br>academic_score: student’s academic score throughout high school and college
<br>student_tuition: cost of tuition for the student
<br>education: the years of education the student has received
<br>fcollege: factor. Is the father a college graduate?
<br>mcollege: factor. Is the mother a college graduate?
<br>home: factor. Does the family own their home?
<br>urban: factor. Is the school in an urban area?
<br>unemp: county unemployment rate in 2020
<br>income: high or low income household based on county average
<br>wage: state hourly wage in manufacturing in 1980
<br>distance: distance from 4-year college (in 10 miles)
<br>region: factor indicating region (West, East or other)
<br>avg_county_tuition: average state 4-year college tuition (in 1000 USD)

I would like to understand the factors affecting student's academic score. 
I will divide the features into four main groups: **physiological information** which includes gender and ethnicity; 
**location** which includes the region where student lives, whether the region is urban, and the 
distance from a 4-year college; **wealth** which includes student tuition, if family owns a home, if family 
has high income or not; and **education** which includes if the father or mother had graduated college 
and how many years of education the student has received.

##### Building new tables of key metrics using sql and creating charts using pivot tables (see attached Google Sheets document and SQL file)

###### Physiological Information


```python
# Finding out the average academic score by gender
query1 = '''
SELECT gender, COUNT(gender), AVG(academic_score)
FROM reports_student_colleges
GROUP BY gender
'''
df = pd.read_sql_query(query1, connection)
df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>gender</th>
      <th>COUNT(gender)</th>
      <th>AVG(academic_score)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>female</td>
      <td>6293</td>
      <td>51.011417</td>
    </tr>
    <tr>
      <th>1</th>
      <td>male</td>
      <td>5505</td>
      <td>50.697005</td>
    </tr>
  </tbody>
</table>
</div>



Around the same average score between genders


```python
# Finding out the average academic score by ethnicity
query2 = '''
SELECT ethnicity, COUNT(ethnicity), AVG(academic_score)
FROM reports_student_colleges
GROUP BY ethnicity
'''
df = pd.read_sql_query(query2, connection)
df
# There were only 4 ethnicitites in this dataset: Asian, African American (afam), Hispanic and Other
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ethnicity</th>
      <th>COUNT(ethnicity)</th>
      <th>AVG(academic_score)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Asian</td>
      <td>3043</td>
      <td>50.737591</td>
    </tr>
    <tr>
      <th>1</th>
      <td>afam</td>
      <td>2090</td>
      <td>50.321574</td>
    </tr>
    <tr>
      <th>2</th>
      <td>hispanic</td>
      <td>1939</td>
      <td>51.353058</td>
    </tr>
    <tr>
      <th>3</th>
      <td>other</td>
      <td>4726</td>
      <td>50.986395</td>
    </tr>
  </tbody>
</table>
</div>



Around the same average academic score persists amongst ethnicities despite a difference in the number of students in each ethnic group

![avg%20academic_score%20vs%20ethnicity%20and%20gender.png](attachment:avg%20academic_score%20vs%20ethnicity%20and%20gender.png)

###### Wealth


```python
# Percentage of students who have a home and who don't
query3 = '''
SELECT
ROUND(SUM(CASE WHEN home = 'yes' THEN 1
ELSE 0 END) * 100.0 /COUNT(id), 2)  AS have_home,
ROUND(SUM(CASE WHEN home = 'no' THEN 1
ELSE 0 END) * 100.0 /COUNT(id), 2) AS not_have_home
FROM reports_student_colleges
'''
df = pd.read_sql_query(query3, connection)
df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>have_home</th>
      <th>not_have_home</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>82.34</td>
      <td>17.66</td>
    </tr>
  </tbody>
</table>
</div>



![avg%20academic_score%20vs%20home.png](attachment:avg%20academic_score%20vs%20home.png)

Although most students have homes (82.34%), the average academic score is still very similar in the two groups. It implies that having a home might not play a role in academic performance.


```python
# Percentage of students who have low income and who have high income*/
query4 = '''
SELECT
ROUND(SUM(CASE WHEN income = 'high' THEN 1
ELSE 0 END) * 100.0 /COUNT(id), 2)  AS high_income,
ROUND(SUM(CASE WHEN income = 'low' THEN 1
ELSE 0 END) * 100.0 /COUNT(id), 2) AS low_income
FROM reports_student_colleges
'''
df = pd.read_sql_query(query4, connection)
df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>high_income</th>
      <th>low_income</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>27.86</td>
      <td>72.14</td>
    </tr>
  </tbody>
</table>
</div>



Most students have low income, but average academic score remains roughly the same.
![avg%20academic_score%20vs%20income.png](attachment:avg%20academic_score%20vs%20income.png)


```python
# Any relationship between student tuition and performance? 
query5 = '''
SELECT student_tuition, AVG(academic_score)
FROM reports_student_colleges
GROUP BY student_tuition
ORDER BY student_tuition DESC
'''
df = pd.read_sql_query(query5, connection)
df.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>student_tuition</th>
      <th>AVG(academic_score)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>119987</td>
      <td>40.439999</td>
    </tr>
    <tr>
      <th>1</th>
      <td>119966</td>
      <td>55.150002</td>
    </tr>
    <tr>
      <th>2</th>
      <td>119935</td>
      <td>37.029999</td>
    </tr>
    <tr>
      <th>3</th>
      <td>119933</td>
      <td>51.290001</td>
    </tr>
    <tr>
      <th>4</th>
      <td>119914</td>
      <td>48.549999</td>
    </tr>
  </tbody>
</table>
</div>



*NB: Dataset has over 4000 rows, that's why I am displaying only the 1st 5 rows in this report.<br>*
In observing the entire output on SQLite, the results appear to be random with no inclination that tuition affects academic score as no apparent trend is observed. However, when I plotted a chart, a somewhat normal distribution was observed with students with either very low or very high tuition performing poorer than students with average tuition.
![Histogram%20of%20average%20academic_score%20by%20student%20tuition.png](attachment:Histogram%20of%20average%20academic_score%20by%20student%20tuition.png)

###### Location


```python
# urban
query6 = '''
SELECT urban, AVG(academic_score)
FROM reports_student_colleges
GROUP BY urban 
'''
df = pd.read_sql_query(query6, connection)
df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>urban</th>
      <th>AVG(academic_score)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>no</td>
      <td>50.932184</td>
    </tr>
    <tr>
      <th>1</th>
      <td>yes</td>
      <td>50.657495</td>
    </tr>
  </tbody>
</table>
</div>



Not much difference in student average academic scores irrespective of if the student lives in an urban area or not.

![count%20of%20students%20per%20%28region%20+%20urbanity%29.png](attachment:count%20of%20students%20per%20%28region%20+%20urbanity%29.png)
Graph shows that most students live in non urban areas in all the three regions in the dataset; with most students living in 'other'


```python
# distance
query7 = ''' 
SELECT distance, AVG(academic_score)
FROM reports_student_colleges
GROUP BY distance
ORDER BY distance ASC
'''
df = pd.read_sql_query(query7, connection)
df.head() # displaying just top 5 rows to save memory; graph tells better story
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>distance</th>
      <th>AVG(academic_score)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.0</td>
      <td>54.482206</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.1</td>
      <td>51.242104</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.2</td>
      <td>49.792537</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.3</td>
      <td>50.600000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.4</td>
      <td>50.268310</td>
    </tr>
  </tbody>
</table>
</div>



![avg%20academic_score%20vs%20distance.png](attachment:avg%20academic_score%20vs%20distance.png)
Graph shows that most students live with 50 miles (5x10) to a four year college. The academic scores ranged between 41.9 as the lowest score and 65.51 as the highest. This difference appears to be irrespective of the distance to a college that a student lived. Most students performed similarly to each other.

It would be interesting to see the proportion of students who lived in urban places by ethnicity.
![count%20of%20students%20per%20%28ethnicity%20+%20urbanity%29.png](attachment:count%20of%20students%20per%20%28ethnicity%20+%20urbanity%29.png)
33.38% of African Americans, 21.05% of Asians, 23.54% of Hispanics and 25.12% of other lived in urban areas 

##### Education


```python
# mother's education, father's education, years of education 
query8 = '''
SELECT mcollege, fcollege, education, academic_score
FROM reports_student_colleges
'''
df = pd.read_sql_query(query8, connection)
df.head() # displaying just top 5 rows to save memory; graph tells better story
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>mcollege</th>
      <th>fcollege</th>
      <th>education</th>
      <th>academic_score</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>no</td>
      <td>no</td>
      <td>12</td>
      <td>39.150002</td>
    </tr>
    <tr>
      <th>1</th>
      <td>yes</td>
      <td>yes</td>
      <td>12</td>
      <td>39.150002</td>
    </tr>
    <tr>
      <th>2</th>
      <td>no</td>
      <td>no</td>
      <td>12</td>
      <td>39.150002</td>
    </tr>
    <tr>
      <th>3</th>
      <td>yes</td>
      <td>yes</td>
      <td>12</td>
      <td>39.150002</td>
    </tr>
    <tr>
      <th>4</th>
      <td>no</td>
      <td>no</td>
      <td>12</td>
      <td>39.150002</td>
    </tr>
  </tbody>
</table>
</div>



![Number%20of%20moms%20who%20graduated%20from%20college.png](attachment:Number%20of%20moms%20who%20graduated%20from%20college.png)

![Number%20of%20fathers%20who%20graduated%20from%20college.png](attachment:Number%20of%20fathers%20who%20graduated%20from%20college.png)

24.23% of dads graduated while 17.91% of moms graduated.

![avg%20academic_score%20vs%20parents%20education.png](attachment:avg%20academic_score%20vs%20parents%20education.png)
The contigency table above shows that the student's average academic score was similar regardless of whether a student's mother or father graduated from college.

![avg%20academic_score%20vs%20years_of_education.png](attachment:avg%20academic_score%20vs%20years_of_education.png)
The graph above shows that student's academic performance improved with the number of years but declined on the 18th year. It is not clear if the number of years is as a result of repeating classes or pursuing higher education.

Education, wealth, location, and physiological qualities were all factors that were considered in determining the academic scores of students.
The results showed consistently that students performed similarly and had similar average academic scores. A plausible explanation for this is that most people are average. If the data collection was done right and data is balanced, these results might be a reflection of real life where most people perform similarly to each other with few people performing terribly or extremely well.

I had found it fascinating that the graph of average academic score to student tuition was a bell shape, implying that with very low or very high tuition fees resulted in very poor performance. It would be interesting to look deeper into this and understand the reasons for this trend.

It was also interesting to see that most students lived within 50 miles to 4-year universities. Since parent information was included in the dataset, I am assuming that the academic performance data provided were for high school students and not university students. It will not be unusual for university students to live near a university campus but it is intriguing for high school students.
