from sklearn import decomposition
from sklearn import datasets
import numpy as np

iris = datasets.load_iris()
X = iris.data - np.mean(iris.data)
y = iris.target

pca = decomposition.PCA(n_components=4)
pca.fit(X)
X = pca.transform(X)
 

print(X[0,:])