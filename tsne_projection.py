import csv
import numpy as np
from sklearn.manifold import TSNE
import pandas as pd

# Read the vectors from the CSV file
vectors = []
with open('derived_data/embeddings_output_clean.csv', 'r') as f:
    reader = csv.reader(f)
    for row in reader:
        vectors.append([float(x) for x in row])

# Convert to NumPy array
vectors = np.array(vectors)

# Apply t-SNE
tsne = TSNE(n_components=2, random_state=0)
vectors_tsne = tsne.fit_transform(vectors)

# Save the 2D projections to a new CSV file
df = pd.DataFrame(vectors_tsne, columns=['TSNE1', 'TSNE2'])
df.to_csv('derived_data/tsne-projection.csv', index = False)
