import mysql.connector
import pandas as pd
import matplotlib.pyplot as plt

# Connect to MySQL database
mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  password="#########",
  database="eduflare",
  auth_plugin = "mysql_native_password"
)

# Get list of tables
mycursor = mydb.cursor()
mycursor.execute("SHOW TABLES")
tables = mycursor.fetchall()
print(tables)
dataframes = {}

# Iterate through tables and create dataframes and bar plots
for table in tables:
    # Read table into dataframe
    table_name = table[0]
    df = pd.read_sql(f"SELECT * FROM {table_name}", con=mydb)
    
    # Add dataframe to the dictionary
    dataframes[table_name] = df


# Initialize each dataframe as a global variable with the table name as the variable name
for table_name, df in dataframes.items():
    globals()[table_name] = df
# Iterate through tables and create dataframes and bar plots

#print(dataframes)
df_Learners=dataframes['learners']
df_product=dataframes['product']
df_instructor=dataframes['instructor']
df_course=dataframes['course']
df_guided_projects=dataframes['guided_projects']
df_reviews=dataframes['reviews']
df_enrollment=dataframes['enrollment']
df_invoice=dataframes['invoice']
df_invoice_items=dataframes['invoice_items']
df_university=dataframes['university']
df_company=dataframes['company']
df_student=dataframes['student']
df_working_professionals=dataframes['working_professionals']
print(df_Learners)

#1
len_df_Learners = len(df_Learners)
len_df_Student=len(df_student)
len_df_Working_Professionals=len(df_working_professionals)
print(f'Total length of Learner {len_df_Learners}')
print(f'Total length of Students {len_df_Student}')
print(f'Total length of Working Professionals {len_df_Working_Professionals}')
labels = ["Students","Working Professionals"]
values = [len_df_Student,len_df_Working_Professionals]
fig, ax = plt.subplots()
ax.pie(values, labels=labels, autopct='%1.1f%%', startangle=90)
ax.axis('equal')
ax.set_title('Number of Learners')
plt.show()
print(df_course)

#2
# Create a bar plot of 'Course Name' vs 'Duration'
df_course.plot.bar(x='course_name', y='duration_mins', rot=0)

# Set axis labels and title
plt.xlabel('Course Name')
plt.ylabel('Duration (mins)')
plt.title('Course vs Duration')
plt.xticks(rotation=90, ha='right')
plt.subplots_adjust(bottom=0.2)
# Show the plot
plt.show()


#3
counts = df_instructor['degree'].value_counts()

# create a new DataFrame with the unique values and their counts
new_df = pd.DataFrame({'name': counts.index, 'count': counts.values})

df = pd.DataFrame(new_df)

# Create a bar chart for no. of instructors vs degree
plt.bar(df["name"], df["count"])
plt.title("Number of Instructors by Degree")
plt.xlabel("Degree")
plt.ylabel("No. of Instructors")
plt.show()

#4
df_instructor.plot(x='rating', y='age', kind='scatter')

# Set the title and axis labels
plt.title("Age vs Rating")
plt.xlabel("Rating")
plt.ylabel("Age")

# Show the plot
plt.show()
