import pandas as pd
import matplotlib.pyplot as plt 
import plotly.express as px

filename = "./frequency-letter.txt"
df = pd.read_csv(filename, sep='\t', header=None)
df.columns = ['Language', 'Letter', 'Frequency']
df.head()

# English
data_english = df[df.Language == 'en']
plot = px.bar(data_english, x = 'Letter', y= 'Frequency', title="English Letter Frequency")
plot.show()

# Portuguese
data_portuguese = df[df.Language == 'pt']
plot = px.bar(data_portuguese, x = 'Letter', y= 'Frequency', title="Portuguese Letter Frequency")
plot.show()

# Italian
data_italian = df[df['Language'] == 'it']
plot = px.bar(data_italian, x = 'Letter', y= 'Frequency', title="Italian Letter Frequency")
plot.show()

facet_plot = px.bar(df, x="Letter", y="Frequency",
             facet_row="Language", color="Language")
facet_plot.show()