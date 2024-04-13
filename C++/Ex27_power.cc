// Function Templates that returns the power x^n

#include<iostream>
#include<cmath>
#include<string>

using namespace std;

template<class T>
T power(T x , unsigned int n)
{ 
  return pow(x,n);
}

template<>
string power(string x , unsigned int n)
{ 
    string y="";
    do{
        y = y.append(x);
        --n; 
    }while(n>0);
   return y;
}


int main()
{
  cout << "power (int)\t:\t" <<power(2,6) <<endl;
  cout << "power (double)\t:\t" <<power(1.1,4) <<endl;
  cout << "power (string)\t:\t" <<power(string{"Hello;-)"},4) << endl;
    
  return 0;
}