# 🛠️ E-commerce Dataset Cleaning (MySQL)

This project demonstrates how to clean and preprocess a dirty **e-commerce dataset** using **MySQL queries**.  
The goal is to transform raw, inconsistent data into a clean and analysis-ready dataset.  

---

## 📂 Project Files
- `cleaning_queries.sql` → Contains all SQL queries used for cleaning.  
- `ecommerce_dirty_data.csv` → Raw dataset with dirty values (sample).  

---

## ⚡ Data Cleaning Steps
✔️ Removed leading/trailing spaces  
✔️ Converted text into proper case  
✔️ Handled missing values with defaults  
✔️ Converted price, quantity & total to numeric types  
✔️ Fixed multiple date formats (DD/MM/YYYY, YYYY-MM-DD, etc.)  
✔️ Standardized city names (e.g., *lahor → Lahore*)  
✔️ Corrected category spelling errors (*eletronics → Electronics*)  
✔️ Validated and fixed email addresses  
✔️ Removed duplicates & invalid records  
✔️ Recalculated totals  

---

## 🚀 How to Run
1. Create a new database in MySQL:
   ```sql
   CREATE DATABASE Project;
   USE Project;
