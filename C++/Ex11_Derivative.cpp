
/*Exercise 10: program that computes derivative of a polynomial between degree 0 and 10!!*/
#include<iostream>
#include<cmath>
#include<limits>
using namespace std;

void printPolynomial(int coff[], int power[],int n){
    for(int i = n; i>=0; --i){
        if(coff[i]>0 ){
            cout <<"+";
            if(power[i] == 0){
                cout <<coff[i];
            }else if(power[i]>0){
                cout <<coff[i];
                cout <<"x^" << power[i];
            }else{
                break;
            }
        }
        else if(coff[i]<0){
            if(power[i] == 0){
                cout <<coff[i];
            }else if(power[i]>0){
                cout <<coff[i];
                cout <<"x^" << power[i];
            }else{
                break;
            }
        }
        else{
            cout << "";
        }
    }
}


int main(){
    unsigned int n, flag=0;
    int k;
    cout << "Please enter the degree n of the polynomial (0 ≤ n ≤ 10): " ;
    cin >> n;
    if(n<=10 && n>=0){
        int *coeff = new int[n+1];
        int *power = new int[n+1];
        int *deri = new int[n+1];
        for(int i=n; i>=0; --i){
                cout <<"coefficient coeff["<<i<<"] : ";
                cin >> coeff[i];
                power[i]=i;
                if(coeff[i]==0)
                    flag++;
        }
        if(flag==n+1){
            cout<<"p(x)=0 and so the derivative is 0.";
        }else{
            cout << "\nWhich derivative should be computed? ";
            cin >> k;
            cout << "Given Polynomial p(x) = ";
            printPolynomial(coeff,power,n);
            if(k<0){
                cout << "\n Invalid input!! Derivative can't be computed" <<endl;
                
            }else if(k==0){
                cout << "\np(x) = ";
                printPolynomial(coeff,power,n);
                cout << endl;
            }else if(k>n && k>0){
                cout << "\n Derivative of the polynomial is zero!!" <<endl;
            }
            else{
                unsigned int j=k;
                cout<<"\np";
                while(j>0){
                    cout<<"'";
                    --j;
                }
                cout<<"(x) = ";
                j=0;
                while(j<k){
                    for(int i=n; i>=0; --i){
                        coeff[i] = coeff[i]*power[i];
                        power[i] = power[i]-1;
                    }++j;
                }
                printPolynomial(coeff,power,n);
            }
        } 
    }else{
            cout <<endl<< "Wrong Input!!! Try again!!"<< endl;
    		cin.clear();
    		cin.ignore(numeric_limits<streamsize>::max(), '\n');
        }
    return 0;
}