/*Computations of different Volume Cube Cuboid and Sphere repeatedly shows a menu of possible actions*/
#include<iostream>
#include<cmath>
using namespace std;
const double pi{3.1415927};

//methods to calculate volume of cube, cuboid, sphere
double volume(float a){  return(pow(a,3)); }
double volume(float a, float b, float c){ return(a*b*c); }
double volumeSphere(float r){ return(4*pi*pow(r,3)/3); }

int main(){
    char s;
    float a, b, c;
    do{
        cout<<"choose type: "<<endl<<"(c) cuboid"<<endl<<"(C) cube"<<endl<<"(s) sphere"<<endl<<"(x) exit"<<endl;
        cin>>s;
        switch(s){
            case 'c':
                cout<<"side lengths a, b, c :";
                cin>>a>>b>>c;
                cout<<"volume: " << volume(a,b,c)<<endl;
                break;
            case 'C':
                cout<<"side lengths a :";
                cin>>a;
                cout<<"volume: " << volume(a)<<endl;
                break;
            case 's':
                cout<<"radius r :";
                cin>>a;
                cout<<"volume: " << volumeSphere(a)<<endl;
                break;
            case 'x':
                //cout<<"Program Terminated!! ";
                break;
            default :
                cout<<"Invalid Input!"<<endl;
                break;
        }
    }while (s!='x'); // The program executes until the use enter 'x'
    return 0;
}