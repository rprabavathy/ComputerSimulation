
/*Exercise 10: program that computes the sum of the digits!!*/
#include <iostream>
#include<cmath>
#include<limits>
using namespace std;

int sum_digit(int z){
    if(z==0){
        return 0;
    }
    z = abs(z);
    return(z%10+sum_digit(z/10));
}

int main() {
    int n;
    cout <<"Enter the number n = ";
    cin >> n;
    if(cin.fail()){
        cout <<endl<< "Wrong Input!!! Try again!!"<< endl;
		cin.clear();
		cin.ignore(numeric_limits<streamsize>::max(), '\n');
    }else{
        cout<<"\nSum of the digits of the number " << n << " is " << sum_digit(n);
        cout << endl;
    }
    return 0;
}