# resumeval is an application to evaluate the match of a resume as to a job description



ref:
http://web.ift.uib.no/Teori/KURS/WRK/TeX/symALL.html

markdown cheatsheet:
https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#code

<img src="https://latex.codecogs.com/svg.latex?\Large&space;x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}" title="\Large x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}" />



The cosine similarity formula :

<img src="https://latex.codecogs.com/svg.latex?\Large&space;cos(\theta)=\frac{\sum{A.B}}{\sqrt{\sum{A^2}}{\sqrt{\sum{B^2}}}}" title="\Large x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}" />

$${x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}}$$

Python code calculating consine similarity: 

``` for python
from scipy import spatial

a = [1,1,2,1,1,2,2,2]
b = [0,1,0,0,0,0,0,0]
result = 1 - spatial.distance.cosine(a, b)
print(result)


from numpy import dot
from numpy.linalg import norm

#a, b = [1, 0, -1], [-1,-1, 0]

cos_sim = dot(a, b)/(norm(a)*norm(b))
print(cos_sim)
```


```
'''
import numpy as np
import matplotlib.pyplot as plt
objects = ('Python', 'C++', 'Java', 'Perl', 'Scala', '
y_pos = np.arange(len(objects))
performance = [10,8,6,4,2,1]
plt.bar(y_pos, performance, align='center', alpha=0.5)
plt.xticks(y_pos, objects)
plt.ylabel('Usage')
plt.title('Programming language usage')
plt.show()
plt.ion()
'''

print('xyz')


#
# score the match of a text with a phrase  
# e.g. 'business management certificate'
# given text 'I obtained certificate of business manag
#
phrase = 'business management certificate'
text = 'I obtained certificate of business management 
gram1 = ['business', 'managment', 'certificate']
gram2 = ['business management', 'management certificat
gram3 = ['business management certificate']
gram1_score = [1,1,1];
gram2_score = [1,0]
gram3_score = [0]
score = sum(ln(i+1): for i in gram1_score)
score += sum(i^2: for i in gram2_score)
score += sum(i^3: for i in gram3_score)

```

```


def n_gram_sum(gram_freq):
  gsum = sum([np.log(x/(i+1)+1) for i, x in enumerate(gram_freq)])
  return gsum



def n_gram_total(n):
  r = np.arange(n)
  s = sum([np.log((n-i)/(i+1)+1) for i in r])
  return s

def n_gram_score(ng_freq):
  s = n_gram_sum(ng_freq)
  t = n_gram_total(len(ng_freq))
  return s/t


#tests
print(n_gram_score([3,2,1])) #score = 1.0
print(n_gram_score([0,0,0])) #score = 0.0

print(n_gram_score([4,3,2,1])) #score = 1.0
print(n_gram_score([0,0,0,0])) #score = 0.0

print(n_gram_score([3,1,0,0])) # score=0.55 (between 0 and 1) for a 4-word term matching

### example
#
# score the match of a text with a phrase  
# e.g. 'business management certificate'
# given text 'I obtained certificate of business management in 1969'
#
term = 'business management certificate'
term_type = 'strong'
# for 'weak term type score only is based on gram_1'

text = 'I obtained certificate of business management in 1969'

gram1 = ['business', 'managment', 'certificate']
gram2 = ['business management', 'management certificate']
gram3 = ['business management certificate']

gram1_emb = [1,1,1];
gram2_emb = [1,0]
gram3_emb = [0]

gram_freq = [3,1,0]
print(n_gram_score([3,1,0,])) # score = 0.76

```
