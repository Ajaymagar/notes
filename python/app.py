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

'''
#map function

list_1 = [1,2,3,4,5,6,7,8]

def func(x):
    return x*x 

print(list(map(func,list_1)))
'''

# lambda function 

a = [1,2,3,4,5,6,7,8,9]

ajay = list(map(lambda x:x+5 ,a))
print(ajay)








