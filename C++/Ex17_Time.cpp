//Exercise 17 Time Class Implementation

#include<iostream>
using namespace std;

class Time{
    //Attributes
    private:
        int hours;
        int minutes;
        bool validTime = false;
    public:
        //Method Declaration
        void printTime();
        void setTime(int,int);
        bool checkTime();
        Time(); //Standard Constructor
        Time(int,int);//Constructor with Attributes
        //Observers
        int getHrs(){return hours;}
        int getMins(){return minutes;}  
};
//Method Definition to print Time     
void Time::printTime(){
    checkTime();
    if(validTime){
        if(hours == 0)  
            cout<<"00:"<<minutes<<" hrs"<<endl;
        else if(minutes==0)
            cout<<hours<<":00 hrs"<<endl;
        else    
            cout<<hours<<":"<<minutes<<" hrs "<<endl;
    }else{
        cout<<" Invalid Time Format!!"<<endl;
    }
}
//Method Definition to assign the user Input 
void Time::setTime(int hr,int min){
    checkTime();
    if(validTime){
        this->hours = hr;
        this->minutes = min;
    }
}

bool Time::checkTime(){
    if((this->hours>=0 && this->hours<=23) && (this->minutes>=0 && this->minutes<=59)){
        validTime = true;
    }else{
        validTime = false;
    }
    return validTime;
}
//Default Constructor definition Initializing with 12:01 hrs
Time::Time(){
    this->hours = 12 ;
    this->minutes = 01;
}
//Constructor definition with attributes
Time::Time(int h, int m){
    this->hours = h;
    this->minutes = m;
}
   
int main(){
    int h, m;
    //Declaring the class Time objects
    Time tO1, tO2;
    //using the methods in class to set values
    cout<<"\nEnter the time in 24hrs Format (Hours Minutes) : ";
    cin >> h >> m;
    tO2.setTime(h,m);

    //Constructor with attributes
    cout<<"\nEnter the time in 24hrs Format (Hours Minutes) : ";
    cin >> h >> m;
    Time tO3(h,m);
    
    cout<<"\nDisplay all three Time objects created with respect to constructors and Methods:\n"<<endl;
    cout<<"Class Time which invokes default Constructor : ";
    tO1.printTime(); 
    cout<<"Class Time which use Methods  : " ;
    tO2.printTime(); 
    cout<<"Class Time which invokes Constructor with Attributes : " ;
    tO3.printTime(); 
    cout<<endl;
    cout<<"Displaying all three Time Objects using observators\n"<<endl;
    cout<<"Time Object 1 invokes default constructor " << tO1.getHrs() << ":" <<tO1.getMins() <<" hrs"<<endl;
    cout<<"Time Object 2 that use Methods " << tO2.getHrs() << ":" <<tO2.getMins() <<" hrs"<<endl;
    cout<<"Time Object 3 invokes constructor with Attributes " << tO3.getHrs() << ":" <<tO3.getMins() <<" hrs"<<endl;
    cout<<endl;
return 0;
}