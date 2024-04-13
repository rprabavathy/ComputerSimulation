
#include <iomanip>
#include<iostream>
#include<cmath>
#define _USE_MATH_DEFINES
using namespace std;

class Angle{
    private:
        int degrees;
        int minutes;
        double seconds;
        
    public:
        explicit Angle(int d=0, int m=0, double s=0):degrees{d},minutes{m},seconds{s} {normalise();}
        Angle (const Angle& a2) : degrees{a2.degrees},minutes{a2.minutes},seconds{a2.seconds}{}

        int getDegrees() const {return degrees;}
        int getMinutes() const{return minutes;}
        double getSeconds() const{return seconds;}

        void set(int d, int m, double s){
            degrees=d;
            minutes=m;
            seconds=s;
            normalise();
        }
        
        double getAsDegrees() const;
        double toRadian() const;
        void normalise();
        Angle operator+(const Angle& a2) const;
        friend ostream& operator<<(ostream& os, const Angle& ang);
        friend istream& operator>>(istream& is, Angle& ang);
        
};

double Angle ::  getAsDegrees() const{
    return (degrees  + (double) minutes/60 + seconds/3600);
}

double Angle :: toRadian() const{
    return (getAsDegrees() * M_PI / 180);
}

void Angle :: normalise(){
    if(degrees<0 || minutes<0 || seconds<0){
        Angle();
    }else{
        if(seconds>=60){
            minutes = minutes + (seconds/60);
            seconds = fmod(seconds,60);
        }
        if(minutes>=60){
            degrees = degrees + (minutes/60);
            minutes = minutes % 60;
        }
        if(degrees>=360){
            degrees = degrees % 360;
        }
    }
}

Angle Angle :: operator+(const Angle& A1) const{
    Angle A2;
    A2.degrees = degrees + A1.getDegrees();   
    A2.minutes = minutes + A1.getMinutes();
    A2.seconds = seconds + A1.getSeconds();
    A2.normalise();
    return A2;
}

ostream& operator<<(ostream& os, const Angle& ang){
    os << ang.getDegrees()  << "°"
       << ang.getMinutes() << "'" 
      << ang.getSeconds() << "\"";
	return os;  
}


istream& operator>>(istream& is, Angle& ang){
    int deg, min;
    double sec;
    is >> deg;
    is.ignore(2, ' ');
    is >> min;
    is.ignore(1);
    is >> sec;
    is.ignore(1);
    ang.set(deg, min, sec);
    return is;
}

int main(){
    Angle  a2, a3;
    // Professor the code works when I input the angle in the form of deg.min.sec and not working when I input with deg°min'sec''
    cout<<"\n Input an angles in format of (d.m.s) : \n";
    cin >> a2 >> a3;
    cout << "Normalised Angle Format :" << endl
         <<"(1) : " << a2.getDegrees() << "°" << a2.getMinutes() <<"'" << a2.getSeconds() << endl
         <<" in terms of fraction : " << a2.getAsDegrees() << endl
         <<" in terms of radians : " << a2.toRadian() << endl
         << endl << "(2) : " << a3.getDegrees() << "°" << a3.getMinutes() <<"'" << a3.getSeconds() << endl 
         <<" in terms of fraction : " << a3.getAsDegrees() << endl
         <<" in terms of radians : " << a3.toRadian() << endl
         << "\n Summation : sum ( " <<a2 <<" , " << a3 <<" ) = " << a2+a3 << endl;
}