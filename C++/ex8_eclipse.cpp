//*program that reads in the lenghts 𝑎 and 𝑏 of the semiaxes of an ellipse (𝑎 > 𝑏) and
draws a filled ellipse consisting of asterisks (“*”) to the console window.*/
#include<iostream>
#include<cmath>
#include<limits>
using namespace std;
int main()
{
    float x,y,a,b;
    repeat:
    cout<<"Enter the lengths of the semiaxes of an ellipse a and b (a>b)"<<"\n";
    cin>>a>>b;
    if (cin.fail()) {
		cout <<endl<< "Wrong Input!!! Try again"<< endl;
		cin.clear();
		cin.ignore(numeric_limits<streamsize>::max(), '\n');
		goto repeat;
	}
    if(a>b){
        for(y=-b;y<=b;++y)
        {
            for(x=-a;x<=a;++x)
            {
                if(pow(x,2)*pow(b,2)+pow(y,2)*pow(a,2) <= pow(b,2)*pow(a,2))
                {
                    cout<<"*";
                }
                else
                {
                    cout<<" ";
                }
            }
            cout<<"\n";
        }
    }else{
        cout<<"Enter valid Input!!"<<endl;
        goto repeat;
    }
    return 0;
}