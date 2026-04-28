# 📊 Gravity Bookstore BI Solution (DWH + SSIS + SSAS + Power BI)

## 📌 Overview
This project presents an end-to-end Business Intelligence solution for a bookstore system. It transforms a normalized OLTP database into a dimensional Data Warehouse, then builds analytical capabilities using SSIS, SSAS Multidimensional, and Power BI.

The goal of this project is to enable efficient reporting and support business decision-making through structured data modeling and analytical processing.

---

## 🏗️ Architecture


OLTP Database → SSIS (ETL) → Data Warehouse → SSAS Cube → Power BI Dashboard


---

## 🧱 Data Warehouse Design

- Converted a **3NF OLTP schema** into a **dimensional model (snowflake/star schema)**
- Designed:
  - Fact tables:
    - `Fact_book_sales`
    - `Fact_order_status`
  - Dimension tables:
    - `Dim_Book`
    - `Dim_Customer`
    - `Dim_Address`
    - `DimDate`
    - `DimTime`
    - `Dim_shipping_method`
    - `Dim_status`
  - Bridge tables:
    - `Bridge_Book_author`
    - `Bridge_customer_address`

### 🔑 Key Design Concepts
- Defined **fact table grain** at the order line level
- Used **surrogate keys (SK)** and **business keys (BK)**
- Implemented **degenerate dimension** (`order_id`)
- Handled **many-to-many relationships** using bridge tables

---

## 🔄 ETL Pipeline (SSIS)

- Built ETL workflows using **SQL Server Integration Services (SSIS)**
- Extracted data from OLTP database and loaded into the DWH
- Applied transformations:
  - Aggregated data to calculate:
    - `quantity`
    - `total_amount`
  - Mapped business keys to surrogate keys
- Used a **staging approach** for efficient and scalable processing
- Implemented **Slowly Changing Dimensions (SCD)** handling

---

## 📦 OLAP Cube (SSAS Multidimensional)

- Developed a **multidimensional cube** using SSAS
- Created:
  - Measure Group:
    - Based on `Fact_book_sales`
  - Measures:
    - Total Sales (`total_amount`)
    - Quantity
    - Unit Price

### 📊 Dimensions & Hierarchies

- **Date Dimension**
  - Hierarchy: Year → Month → Day
  - Additional attributes: Quarter, Holidays

- **Address Dimension**
  - Hierarchy: Country → City

- **Time Dimension**
  - Hierarchy: AM/PM → Hour

- **Other Dimensions**
  - Book (Publisher, Language)
  - Customer
  - Shipping Method

---

## 📈 Power BI Dashboard

- Built a dashboard connected to the analytical model
- Visualized:
  - Sales trends over time
  - Geographic distribution of sales
  - Product-level performance
- Enabled interactive filtering using hierarchies and dimensions

---

## 🛠️ Tech Stack

- **SQL Server**
- **SSIS (SQL Server Integration Services)**
- **SSAS Multidimensional**
- **Power BI**

---

## 📂 Project Structure

```
gravity-bookstore-bi/

│── README.md
│
├── 01_Data_Warehouse/
│ ├── schema.sql
│ └── schema_diagram.png
│
├── 02_ETL_SSIS/
│ ├── SSIS_Project/
│ └── screenshots/
│ └── etl_flow.png
│
├── 03_OLAP_SSAS/
│ └── SSAS_Project/
│
├── 04_PowerBI/
│ ├── dashboard.pbix
│ └── dashboard.png
│
└── docs/
└── project_overview.md

```
---

## 🚀 Key Features

- End-to-end BI pipeline from OLTP to dashboard
- Dimensional modeling (Star/Snowflake Schema)
- ETL pipeline with transformations and SCD handling
- Multidimensional cube with hierarchies
- Interactive data visualization

---

## 🧠 Key Learnings

- Designing scalable Data Warehouse schemas
- Building efficient ETL pipelines using SSIS
- Understanding OLAP concepts and cube design
- Applying analytical thinking to business data
- Integrating multiple BI tools into one solution

---

## 📌 Future Improvements

- Implement additional KPIs (e.g., average order value, customer segmentation)
- Optimize ETL performance and automation
- Extend cube with advanced calculations
- Enhance dashboard interactivity

---

## 👤 Author

**Abdallah Ashraf Ismail**  
AI & Data Engineering Enthusiast  
