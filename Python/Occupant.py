## Class Occupant

from Room import *
import re 

class Occupant(Room):
    # do not use inheritance here
    # an occupant is not a room, but an occupant has a room
    
    def __str__(self):
        return str(self.familyName)+', '+str(self.givenName)+' '+str(self.room)
    
    def __init__(self, fn , gn, R):
       self.familyName = fn
       self.givenName = gn
       r = re.split(r'\.',R)
       self.room = Room(r[0],r[1],r[2])
