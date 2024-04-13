
/*Exercise 9: Program to determine roots of quadratic equations*/
#include <iostream>
#include <cmath>
#include<limits>
using namespace std;

int main(){
    double a, b, c, r1, r2, d;
    cout << "Enter the coefficients a, b and c: ";
    cin >> a >> b >> c;
    if(cin.fail()){
        cout <<endl<< "Wrong Input!!! Try again!!"<< endl;
		cin.clear();
		cin.ignore(numeric_limits<streamsize>::max(), '\n');
    }else{
        if(a!=0 && b!=0 && c!=0){
            d = pow(b,2) - 4*a*c;
            if(d>0){
                r1=(-b+sqrt(d))/(2*a);
                r2=(-b-sqrt(d))/(2*a);
                cout <<"Roots: r1 = "<< r1 <<"\tr2 = "<< r2 <<endl;
            }else if(d==0){
                r1 = -b/(2*a);
                cout << "Roots: r1 = r2 = " << r1 <<endl;
            }else{
               cout<<"Roots are complex!!!"<<endl;
            }
        }else{
            cout <<"Roots can't be computed as the input does not form a quadratic equation!!"<<endl;
        }
    }
    return 0;
}