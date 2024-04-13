## Class Glass
## Sheet 2 Exercise 5
## Prabavathy Rajasekaran (2130757)
                                                     
from Glass import Glass


#Positive case
g = Glass(250, 20)
g.fillIn(30)
g.drink(25)

print('\nGlass Object 1 ::' , g)

g3 = Glass()
print('\nGlass Object 3 ::' , g3)
g4 = Glass(100)
print('\nGlass Object 4 ::' , g4)

#Content > Volume during initialization
'''
g2 = Glass(25, 35)
print('\nGlass Object 2 ::' , g2)
'''
#FillIn exception
'''
g5 = Glass()
g5.fillIn(500)
'''

#Drink exception

g6 = Glass()
g6.drink(30)

# you should test the exceptions with try and except
