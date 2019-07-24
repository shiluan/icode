# resumeval is an application to evaluate the match of a resume as to a job description

ref:
http://web.ift.uib.no/Teori/KURS/WRK/TeX/symALL.html


<img src="https://latex.codecogs.com/svg.latex?\Large&space;x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}" title="\Large x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}" />



<img src="https://latex.codecogs.com/svg.latex?\Large&space;cos(\theta)=\frac{\sum{A.B}}{\sqrt{\sum{A^2}}{\sqrt{\sum{B^2}}}}" title="\Large x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}" />


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
