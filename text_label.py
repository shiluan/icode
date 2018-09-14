

##############
## softmax
##############
import math
z = [1.0, 2.0, 3.0, 4.0, 1.0, 2.0, 3.0]
z_exp = [math.exp(i) for i in z]
print([round(i, 2) for i in z_exp])
#[2.72, 7.39, 20.09, 54.6, 2.72, 7.39, 20.09]
sum_z_exp = sum(z_exp)
print(round(sum_z_exp, 2))
114.98
softmax = [round(i / sum_z_exp, 3) for i in z_exp]
print(softmax)
#[0.024, 0.064, 0.175, 0.475, 0.024, 0.064, 0.175]
sum_softmax = sum(softmax)
print(sum_softmax)



##############
## word embedding, occurrence
##############
import collections

def build_dataset(words, n_words):
    """Process raw inputs into a dataset."""
    count = [['UNK', -1]]
    count.extend(collections.Counter(words).most_common(n_words - 1))
    dictionary = dict()
    for word, _ in count:
        dictionary[word] = len(dictionary)
    data = list()
    unk_count = 0
    for word in words:
        if word in dictionary:
            index = dictionary[word]
        else:
            index = 0  # dictionary['UNK']
            unk_count += 1
        data.append(index)
    count[0][1] = unk_count
    reversed_dictionary = dict(zip(dictionary.values(), dictionary.keys()))
    return data, count, dictionary, reversed_dictionary


my_words = ['this', 'is', 'an', 'example', 'please', 'follow', 'this', 'example']
my_n_words = 4
d,n, dic, rdic = build_dataset(my_words, my_n_words)

print (d)
print(n)
print(dic)



##############
# cosine similarity
##############

#1
from scipy import spatial

dataSet1 = [3, 45, 7, 2]
dataSet2 = [3, 45, 7, 2]
dataSet2 = [3, 54, 13, 1]
result = 1 - spatial.distance.cosine(dataSet1, dataSet2)
print (result)
# 0.996258753135

#2
from sklearn.metrics.pairwise import cosine_similarity

print(cosine_similarity([1, 0, -1], [-1,-1, 0]))
# [[-0.5]]
print(cosine_similarity([3, 45, 7, 2], [3, 54, 13, 1]))
# [[ 0.99625875]]
