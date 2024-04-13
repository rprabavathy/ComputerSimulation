#include <iostream>
#include <memory>
using namespace std;

class Dish {
    public:
        virtual string getDescription() const{return "Unknown Dish";}
        virtual double getPrice() { return 0;};
};

class Accompaniment : public Dish{
    shared_ptr<Dish> dish;
    public:
        Accompaniment(const shared_ptr<Dish> &acc):dish(acc){}
        string getDescription(){return dish->getDescription();}
        double getPrice(){return dish->getPrice();}
};

class VienneseSchnitzel : public Dish{
    public:
        string getDescription(){ return "VienneseSchnitzel";}
        double getPrice(){ return 5.90; }
};

class rumpSteak : public Dish{
    public:
        string getDescription(){ return "rumpSteak";}
        double getPrice(){ return 12.50; }
};

class salmon : public Dish{
    public:
        string getDescription(){ return "Salmon";}
        double getPrice(){ return 9.90; }
};



class Chips : public Accompaniment {
    public:
        Chips(const shared_ptr<Dish>& dish):Accompaniment(dish){}
        string getDescription(){
            return Accompaniment::getDescription() +" + Chips";
        }
        double getPrice(){
            return Accompaniment::getPrice() + 2.90;
        }
};

class Salad : public Accompaniment {
   public:
        Salad(const shared_ptr<Dish>& dish):Accompaniment(dish){}
        string getDescription(){
            return Accompaniment::getDescription() +" + Salad";
        }
        double getPrice(){
            return Accompaniment::getPrice() + 7.50;
        }
};

class Pasta : public Accompaniment {
    public:
        Pasta(const shared_ptr<Dish>& dish):Accompaniment(dish){}
        string getDescription(){
            return Accompaniment::getDescription() +" + Pasta";
        }
        double getPrice(){
            return Accompaniment::getPrice() + 7.90;
        }
};

class Soup : public Accompaniment {
    public:
        Soup(const shared_ptr<Dish>& dish):Accompaniment(dish){}
        string getDescription(){
            return Accompaniment::getDescription() +" + Soup";
        }
        double getPrice(){
            return Accompaniment::getPrice() + 3.90;
        }
};

int main(){
    int dish;
    char addOn;
    cout << endl;
    cout << "Choose your Main Dish :" << endl;
    cout << "\t1. Viennese Schnitzel"<<endl; 
    cout << "\t2. Rump Steak"<<endl;
    cout << "\t3. Salmon"<<endl;
    cin >> dish;
    auto makeDish = shared_ptr<Dish>{nullptr};
    switch(dish){
        case 1:
            auto mainCourse = make_shared<VienneseSchnitzel>();
            mainDish = mainCourse;
        case 2:
            auto mainCourse = make_shared<rumpSteak>();
            mainDish = mainCourse;
        case 3:
            auto mainCourse = make_shared<salmon>();
            mainDish = mainCourse;
        default :
            cout<<"Invalid Input!"<<endl;
    }

}