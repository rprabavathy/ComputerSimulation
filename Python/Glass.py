## Class Glass
## Sheet 2 Exercise 5
## Prabavathy Rajasekaran (2130757)

class Glass:
    def __str__(self):
        return '\nVolume : '+str(self.volume) + '\nContent : ' + str(self.content)

    def __init__(self, volume =  None , content = None):
        if volume is None  and content is None :
            self.volume = 250.0
            self.content = 0.0
        elif volume is not None and content is None :
            self.volume = volume
            self.content = 0.0
        elif volume is not None  and content is not None :
            if content > volume :
                raise Exception('Content is high to initialize Glass Object')
            else:
                self.volume = volume
                self.content = content
        else : # i.e. volume is None and content is not None
            if content > volume : # i.e. compares number with None
                raise Exception('Content is high to initialize Glass Object')
            else:
                self.volume = volume
                self.content = content

    def fillIn(self,amount):
        if self.content + amount > self.volume:
            raise Exception('Amount too high!!')
        else:
            self.content += amount

    def drink(self,amount):
        if self.content - amount < 0 :
            raise Exception('No enough content!!')
        else:
            self.content -= amount
