## Prabavathy Rajasekaran(2130757)
##  Sheet 1 Exercise 2 : Circumference of the Ellipse

from math import *

def main():
    try:
        #read inputs of semi-major & minor axes 
        a = float(input("Enter the Elliptic major axis a :"))
        b = float(input("Enter the Elliptic minor axis b :"))
        t = float(input("Enter the relative tolerance t :"))

        #Considering geometric series of 2^n till n = 24 
        for i in range(0, 24):
            n = int(2* pow(2, i))
            cn = circumference(a,b,n)
            cn2 = circumference(a,b,n//2)
            acc = abs((cn-cn2)/cn)
            if(acc <= t):
                break 
            else: 
                print("Circumference of the ellipse n = 2^%d is %f " %(i+1,cn))
    except Exception as e:
        print(type(e),' : ', e)

def length(x1,y1,x2,y2):
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2) * 1.0)

def ellipse(a,b,t):
    return (cos(t) * a, sin(t) * b)

def circumference(a,b,n):
    deg = degrees(pi) * 2 / n 
    i = 0
    PtsList , distance = [] , 0
    for i in range(n):
        angle = i * deg
        PtsList.append(ellipse(a,b, angle))
        
    for j in range(len(PtsList)):
        distance = distance + length(PtsList[j-1][0],PtsList[j-1][1],PtsList[j][0],PtsList[j][1])
    return distance

if __name__ == '__main__':
    main()