#optional parameter tutorial
'''
def func(word, freq=3):
    op = word*freq
ajay = func('ajay')
#print(ajay)
'''

#static methods
'''
class person(object):
    population = 50  #class variable 
    def __init__(self,name ,age):  # Constructor methods
        self.name = name
        self.age = age
    
    @classmethod
    def getpopulation(cls):
        return cls.population

    @staticmethod
    def isadult():
        return  5 > 18

    def person_data(self):
        print(self.name + ' ' + self.age ) 


ajay = person('ajay' , '55')
print(ajay.person_data())
print(person.getpopulation())
'''


#map function
'''
list_1 = [1,2,3,4,5,6,7,8]

def func(x):
    return x*x 

print(list(map(func,list_1)))
'''


# lambda function 
'''
a = [1,2,3,4,5,6,7,8,9]

ajay = list(map(lambda x:x+5 ,a))
print(ajay)
'''


# collection module 
'''
import collections
from collections import Counter
from collections import namedtuple

point = namedtuple('point','x y z')

newP = point(3,4,5)
print(newP)
'''

# deque module
'''
import collections
from collections import deque

d = deque('hello')
d.append('4')
d.append(5)

print(d)

'''

# Unpacking a sequence of tuple into variables 
'''
ajay = (4,5)
x , y = ajay
#print(x)
#print(y)

s = "hello"
a , b , c ,d,e = s

'''

# unpacking elements from iterables of Arbitrary Length
# star expression in python
''' 
record = ('ajay' , 'juinager' , '9594157161', '797724706')
name , adderss , *phone_numbers = record

print(phone_numbers)
'''

'''
*trailing_qtrs ,current_qtr = [10,20,30,40,50,60,70,80]
trailing_avg = sum(trailing_qtrs)/len(trailing_qtrs)
print(trailing_avg , current_qtr)
'''

#line spilliting

line2 = """ ajay magar:magarajay538,
pari shendkar : parishendkar@gmail.com
"""

line = 'noboby:*:-2:-2:unpriviledge User:/var/emapty:/usr/bin'
uname , *fields , homedir ,sh = line.split(':')
#print(uname)
#print(fields)
first_name , *last_name = line2.split(':')
#print(first_name)
#print(last_name)

record = ('ACME' , 50 , 123.45,(12,18,2012))
name  , *_ , (*_ , year) = record
print(name)
print(year)

















