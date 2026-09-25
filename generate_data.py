import pandas as pd
import numpy as np
from datetime import datetime, timedelta

# Create 500 days of dates starting from Jan 1, 2025
dates = [datetime(2025, 1, 1) + timedelta(days=i) for i in range(500)]

# Generate randomized business data
np.random.seed(42)
products = np.random.choice(['Salt', 'Seasoning', 'Tomato Paste'], 500)
regions = np.random.choice(['Lagos', 'Ibadan', 'Abuja', 'Kano'], 500)
revenue = np.random.normal(150000, 25000, 500).round(2)
units_sold = np.random.randint(100, 500, 500)

# Build the DataFrame
df = pd.DataFrame({
    'sale_date': dates,
    'region': regions,
    'product_line': products,
    'units_sold': units_sold,
    'revenue_ngn': revenue
})

# Export to CSV
df.to_csv('dummy_financials.csv', index=False)
print("Success! dummy_financials.csv has been created in your folder.")