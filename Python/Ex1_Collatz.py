# Prabavathy Rajasekaran(2130757)
# Sheet 1 Exercise 1 : Collatz Conjecture

def main():   
    try:
        n = int(input('Enter a Positive Integer : '))
        if n > 0:
            collatzList = collatz(n)
            print(collatzList)
        else:
            print('Enter a Valid Input!!')
    except ValueError:
        print('WARNING!! Input a Valid Integer!!')

def collatz(n):
    lst =[n]
    if n == 1 :
        return lst               
    elif (n % 2):
        lst.extend(collatz(n*3+1)) 
    else:
        lst.extend(collatz(n//2))   
    return lst

if __name__ == '__main__':
    main()