# Stack Overflow Developer Survey 2025 Insights using PostgreSQL
A PostgreSQL-based analysis of 49K+ Stack Overflow Developer Survey 2025 responses, examining developer compensation trends and identifying key salary drivers across experience levels, programming languages, databases, platforms, and work arrangements using advanced SQL techniques.

---

## Project Structure

```
├── Developer_survey.csv        # Raw survey dataset (~49,200 rows)
├── project_stackoverflow.sql   # All SQL queries and analysis
└── README.md                   # Project documentation
```

---

## Dataset Overview

The dataset contains responses from **~49,200 developers** worldwide with the following fields:

| Column | Description |
|--------|-------------|
| `ResponseId` | Unique identifier per respondent |
| `Country` | Country of residence |
| `WorkExp` | Years of professional work experience |
| `RemoteWork` | Work arrangement (Remote / Hybrid / In-person) |
| `ConvertedCompYearly` | Yearly compensation in USD |
| `LanguageHaveWorkedWith` | Programming languages used (semicolon-separated) |
| `DatabaseHaveWorkedWith` | Databases used (semicolon-separated) |
| `PlatformHaveWorkedWith` | Platforms/tools used (semicolon-separated) |

---

## Analyses Performed

### 1. Global Median Salary
Calculates the overall global median yearly compensation using `PERCENTILE_CONT`.

### 2. Salary by Experience Level
Groups developers into 5 experience bands and computes median salary per band:
- 0–2 Years
- 3–5 Years
- 6–10 Years
- 11–15 Years
- 15+ Years

### 3. Salary by Country
Cross-tabulates median salary by country (filtered to countries with >50 respondents).

### 4. Salary by Remote Work Status
Compares median salaries across Remote, Hybrid, and In-person work arrangements.

### 5. Top 5 Highest Paying Programming Languages
Uses `UNNEST` + `STRING_TO_ARRAY` to explode multi-value fields and rank languages by median salary (min. 100 developers).

### 6. Top 5 Highest Paying Databases
Same approach applied to database technologies.

### 7. Top 5 Highest Paying Platforms
Same approach applied to cloud/platform tools.

### 8. Language × Experience Cross-Analysis
Final project query: combines language and experience level to show median salary per language per experience band.

---

## SQL Techniques Used

- `PERCENTILE_CONT` — median salary calculation
- `CASE WHEN` — experience level bucketing
- `STRING_TO_ARRAY` + `UNNEST` — multi-value column parsing
- CTEs (`WITH` clause) — query modularization
- `HAVING COUNT(*) > N` — filtering low-sample groups
- Type casting (`::NUMERIC`, `::INT`)
- `GROUP BY`, `ORDER BY`, `LIMIT`

---

## Setup & Usage

### Prerequisites
- PostgreSQL 12+ (uses `PERCENTILE_CONT` and `UNNEST`)

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/stackoverflow-survey-sql.git
   cd stackoverflow-survey-sql
   ```

2. **Create and populate the database**
   ```sql
   -- Run the CREATE TABLE statement from project_stackoverflow.sql
   DROP TABLE IF EXISTS developer_survey;
   CREATE TABLE developer_survey (...);
   ```

3. **Import the CSV data**
   ```bash
   psql -d your_database -c "\COPY developer_survey FROM 'Developer_survey.csv' CSV HEADER"
   ```

4. **Run the analysis queries**
   ```bash
   psql -d your_database -f project_stackoverflow.sql
   ```

---

## Key Insights

- **Experience pays**: Median salary increases consistently with years of experience.
- **Language matters**: Certain languages correlate strongly with higher compensation.
- **Remote work**: Remote developers tend to report higher median salaries than in-person counterparts.
- **Geography**: Country of work remains one of the strongest predictors of salary level.

---

## Tools Used
- PostgreSQL – Data storage, querying, and analysis
- pgAdmin 4 – Database management and query execution
- SQL – Data transformation, aggregation, and analytical querying
- CSV Dataset – Stack Overflow Developer Survey 2025 data source


