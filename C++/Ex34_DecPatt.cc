
#include <iostream>
using namespace std;

class Dish {
    public:
        virtual ~Dish(){}
        virtual string getDescription(){return "Unknown Dish";}
        virtual double getPrice(){ return 0;};
};

class Accompaniment : public Dish{
    Dish *dish;
    public:
        Accompaniment(Dish *dish1):dish(dish1){}
        string getDescription(){return this->dish->getDescription();}
        double getPrice(){return this->dish->getPrice();}
};

class VienneseSchnitzel : public Dish{
    public:
        string getDescription(){ return "VienneseSchnitzel";}
        double getPrice(){ return 20.0; }
};

class rumpSteak : public Dish{
    public:
        string getDescription(){ return "rumpSteak";}
        double getPrice(){ return 30.5; }

};

class salmon : public Dish{
    public:
        string getDescription(){ return "Salmon ";}
        double getPrice(){ return 9.52; }

};



class Chips : public Accompaniment {
    public:
        Chips(Dish *dish):Accompaniment(dish){}
        string getDescription(){
            return Accompaniment::getDescription() +" + Chips ";
        }
        double getPrice(){
            return Accompaniment::getPrice() + 3.20;
        }
};

class Salad : public Accompaniment {
   public:
        Salad(Dish *dish):Accompaniment(dish){}
        string getDescription(){
            return Accompaniment::getDescription() +" + Salad ";
        }
        double getPrice(){
            return Accompaniment::getPrice() + 3.20;
        }
};

class Pasta : public Accompaniment {
    public:
        Pasta(Dish *dish):Accompaniment(dish){}
        string getDescription(){
            return Accompaniment::getDescription() +" + Pasta ";
        }
        double getPrice(){
            return Accompaniment::getPrice() + 3.20;
        }
};

class Soup : public Accompaniment {
    public:
        Soup(Dish *dish):Accompaniment(dish){}
        string getDescription(){
            return Accompaniment::getDescription() +" + Soup";
        }
        double getPrice(){
            return Accompaniment::getPrice() + 3.20;
        }
};

void Restaurant(Dish* dish){
    cout << " Dish Ordered : " << dish->getDescription() << endl;
    cout << " Price of the ordered Dish : " << dish->getPrice() << endl;
}

int main(){
    Dish* Vien = new VienneseSchnitzel;
    Restaurant(Vien);

    Accompaniment* chip = new Chips(Vien);
    Restaurant(chip);
    Accompaniment* salat = new Salad(chip);
    Restaurant(salat);
    Accompaniment* pas = new Pasta(salat);
    Restaurant(pas);
    Accompaniment* soup = new Soup(pas);
    Restaurant(soup);

    Dish* steak = new rumpSteak;
    Restaurant(steak);

    Accompaniment* chip1 = new Chips(steak);
    Restaurant(chip1);
    Accompaniment* salat1 = new Salad(chip1);
    Restaurant(salat1);
    Accompaniment* pas1 = new Pasta(salat1);
    Restaurant(pas1);
    Accompaniment* soup1 = new Soup(pas1);
    Restaurant(soup1);

    Dish* sal = new salmon;
    Restaurant(sal);

    Accompaniment* chip2 = new Chips(sal);
    Restaurant(chip2);
    Accompaniment* salat2 = new Salad(chip2);
    Restaurant(salat2);
    Accompaniment* pas2 = new Pasta(salat2);
    Restaurant(pas2);
    Accompaniment* soup2 = new Soup(pas2);
    Restaurant(soup2);


}