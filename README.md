# -NASA-Kepler-Data-Exploration
Exploratory Data Analysis (EDA) of NASA’s Kepler exoplanet dataset using advanced SQL in BigQuery and immersive data storytelling in Power BI
#  NASA Kepler Data Exploration & Immersive Dashboard

This project is my take on analyzing NASA's Kepler space telescope registry. I combined deep-dive data exploration in SQL with data storytelling in Power BI, to build an interactive cosmic infographic instead.

---

##  SQL Data Exploration (Google BigQuery)
Before building the dashboard, I used SQL to clean the dataset, check its integrity, and find statistical trends:
* **Signal Strength (SNR):** Found the top 10 clearest confirmed discoveries based on their Signal-to-Noise Ratio.
* **Star Segmentation:** Grouped host stars by temperature into Yellow, Orange, and Red dwarfs to calculate planet discovery success rates.
* **Advanced Ranking:** Used window functions (`RANK` and `PARTITION BY`) to rank the top 20 planets inside each star category without mixing the data.
* **Correlations & Cohorts:** Built a correlation matrix (`CORR`) to see how planet/star sizes affect signal clarity across different stellar types.
* **Error Profiling:** Analyzed NASA's four data error flags to understand exactly why candidate objects were dismissed as False Positives.

---
##  Python & Automated EDA (Google Colab)
I also used Python to clean the dataset, handle missing values, and get a better understanding of the variables before visualization:
* **Data Prep & Cleaning:** Used `Pandas` to explore the raw numbers, filter out the noise, and prepare the dataset for Power BI.
* **Statistical Charts:** Used `Seaborn` and `Matplotlib` to build a clean correlation heatmap, mapping out how physical planet and star traits actually impact signal clarity.


 **[Open Notebook in Google Colab](https://colab.research.google.com/drive/1FiEv7GNgoZFuKeV6q1TJsMCGDkyBwO3z?usp=sharing)**

## 🎨 Data Storytelling (Power BI)
* **ASA-Style Interface:** Designed a clean, dark-themed UI inspired by mission control HUD screens.
* **Custom DAX Measures**

---

##  Tech Stack
* **SQL** (Google BigQuery) - Window functions, data profiling.
* **Python** (Google Colab) - Data cleaning, EDA
* **Power BI** - Custom UX/UI design, data storytelling, DAX.
