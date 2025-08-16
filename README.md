# World Layoffs Data Analysis using MySQL

## 📌 Introduction
This project focuses on analyzing a **global layoffs dataset** to identify patterns and trends across industries, companies, and countries. The workflow includes **data cleaning** and **exploratory data analysis (EDA)** using SQL queries to uncover valuable insights.

The dataset contains layoff records from various companies worldwide, providing an opportunity to practice real-world data cleaning and advanced SQL techniques.

---

## ⚙️ Steps Covered
1. **Data Cleaning**
   - Removed duplicate records using window functions.
   - Handled missing values with self-joins and conditional logic.
   - Standardized company names and industry categories.
   - Converted date fields into proper formats for time-series analysis.

2. **Exploratory Data Analysis (EDA)**
   - Identified companies with maximum and minimum layoffs.
   - Ranked top companies by total layoffs.
   - Analyzed layoffs by **industry, location, country, year, and month**.
   - Calculated **rolling totals** (overall and India-specific) to understand trends.

3. **Insights Generation**
   - Determined industries most affected by layoffs.
   - Discovered year-wise and country-wise layoff distributions.
   - Tracked top 5 companies with layoffs each year.

---

## 🛠️ Tech Stack
- **Database:** MySQL
- **Concepts Used:** Window Functions, Common Table Expressions (CTEs), Aggregations, Ranking Queries

---

## 📊 Sample Queries & Outputs
```sql
-- Top 5 companies with highest layoffs in 2022
WITH company_rank AS (
    SELECT company, YEAR(date) AS year, SUM(total_laid_off) AS total_laid_off,
           DENSE_RANK() OVER(PARTITION BY YEAR(date) ORDER BY SUM(total_laid_off) DESC) AS rank_num
    FROM layoffs_eda
    WHERE YEAR(date) = 2022
    GROUP BY company, YEAR(date)
)
SELECT * FROM company_rank WHERE rank_num <= 5;
```
<img width="410" height="443" alt="image" src="https://github.com/user-attachments/assets/ff69e098-0bf3-454e-83d9-82d0e59e2b09" />

---

## 🔑 Key Insights
- **Tech industry** experienced the highest layoffs during 2022–2023.
- Several startups laid off **100% of employees** due to funding issues.
- The **United States** recorded the highest layoffs, followed by India and Europe.
- **Rolling totals** revealed a significant spike in layoffs during early 2023.

---

## 📂 Project Files
- `World_Layoff_DataCleaning_Project_In_MYSQL.sql` → SQL script for cleaning the dataset.
- `World_Layoff_EDA_Project.sql` → SQL script for EDA and insights.
- `layoffs.csv` → Raw dataset (if allowed to share, else add source link).

---

## 🚀 How to Use
1. Import the dataset into your MySQL environment.
2. Run the **Data Cleaning SQL script**.
3. Run the **EDA SQL script** to reproduce the analysis.
4. Explore and extend the queries to derive your own insights.



## 📢 Author
👤 **Saravanan S**  
💼 Aspiring Data Scientist | AI & ML Enthusiast  
🔗 [GitHub Profile](https://github.com/Saravanansubramaniyan123) | [LinkedIn](https://www.linkedin.com/in/saravanan-data-scientist/)

---


## 📸 Output
<img width="1420" height="468" alt="image" src="https://github.com/user-attachments/assets/25b58e6f-e9d8-40e1-a173-0ba289ff890d" />

---

💡 *This project demonstrates SQL data cleaning skills useful for Data Analyst and Data Science roles.*
