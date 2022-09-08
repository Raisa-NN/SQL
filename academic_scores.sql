-- TABLE
CREATE TABLE 'county_info' ('id' INTEGER,'unemp' REAL,'wage' REAL,'distance' REAL,'region' TEXT,'avg_county_tuition' REAL);
CREATE TABLE demo (ID integer primary key, Name varchar(20), Hint text );
CREATE TABLE reports_student_colleges(
  id INT,
  academic_score REAL,
  student_tuition INT,
  education INT,
  unemp REAL,
  wage REAL,
  distance REAL,
  region TEXT,
  avg_county_tuition REAL,
  fcollege TEXT,
  mcollege TEXT,
  home TEXT,
  urban TEXT,
  income TEXT,
  gender TEXT,
  DOB TEXT,
  ethnicity TEXT,
  academic_info_id INT,
  county_id INT,
  family_details_id INT
);
CREATE TABLE 'student_academic_info' ('id' INTEGER,'academic_score' REAL,'student_tuition' INTEGER,'education' INTEGER);
CREATE TABLE 'student_family_details' ('id' INTEGER,'fcollege' TEXT,'mcollege' TEXT,'home' TEXT,'urban' TEXT,'income' TEXT);
CREATE TABLE 'student_personal_details' ('ID' INTEGER,'gender' TEXT,'DOB' TEXT,'ethnicity' TEXT,'academic_info_id' INTEGER,'county_id' INTEGER,'family_details_id' INTEGER);
 
-- INDEX
 
-- TRIGGER
 
-- VIEW
 
