//Exercise 18 Class Car Implementation

#include<iostream>
using namespace std;

class Car{
    private:
        string type;
        double mileage;
    public:
        Car();
        Car(string type, double mileage);
        void drive(double);
        void tow(Car&, double);
        void print();
        string getType(){const return type;};
        double getMileage(){const return mileage;}
};
Car:: Car(string type, double mileage){
    this->type = type;
    this->mileage = mileage;
}

void Car::drive(double distance){
    mileage = mileage + distance;
}

void Car::tow(Car& obj, double distance){
    obj.drive(distance);
    mileage= mileage+distance;
}
void Car::print(){
    cout<<"Car type : " <<type << " and mileage : " <<mileage <<" km "<<endl;
}

int main(){
    double dist;
    
    cout<<"\nEnter the mileage in km of Towing car :";
    cin>>dist;
    Car towingCar{"Towing Car" , dist};
    cout<<"\nEnter the mileage in km of Trailer car : ";
    cin>>dist;
    Car trailerCar{"Trailer Car",dist};
    
    //Printing Initialised Car Information
    cout<<"\nInitialized Car Information :\n" <<endl;
    //constructor with Attributes
    towingCar.print();
    trailerCar.print(); 
    
    cout<<"\nEnter the distance in km driven by "<< towingCar.getType() <<" : ";
    cin>>dist;
    towingCar.drive(dist);
    cout<<endl;
    towingCar.print();

    cout<<"\nEnter the distance in km driven by "<< trailerCar.getType() <<" : ";
    cin>>dist;
    trailerCar.drive(dist);
    cout<<endl;
    trailerCar.print();

    //Using Constructor with Attributes
    cout<<"\nEnter the towed distance in km : ";
    cin>>dist;
    towingCar.tow(trailerCar,dist);
    cout<<endl;
    towingCar.print();
    trailerCar.print();
    cout<<endl;

    return 0;
}