
#include <iostream>
#include <memory>
using namespace std;

class Dish {
    public:
        explicit Dish(){}
        virtual ~Dish() {}
        virtual string getDescription() const { return "";}
        virtual double getPrice() const { return 0;};
};

class Accompaniment : virtual public Dish{
    shared_ptr<Dish> dish;
    public:
        Accompaniment(const shared_ptr<Dish> &acc):dish(acc){}
        string getDescription()const override {return dish->getDescription();}
        double getPrice() const override {return dish->getPrice();}
};

//Main Course class declaration
class VienneseSchnitzel : virtual public Dish{
    public:
        string getDescription() const override { return "VienneseSchnitzel";}
        double getPrice() const override { return 5.90; }
};

class rumpSteak : virtual public Dish{
    public:
        string getDescription() const override { return "Rump Steak";}
        double getPrice() const override { return 12.50; }
};

class salmon : virtual public Dish{
    public:
        string getDescription() const override { return "Salmon";}
        double getPrice() const override { return 9.90; }
};


//Accompaniment class declaration
class Chips : public Accompaniment {
    public:
        Chips(const shared_ptr<Dish>& dish):Accompaniment(dish){}
        string getDescription() const override {
            return Accompaniment::getDescription() +" + Chips";
        }
        double getPrice() const override {
            return 2.90 + Accompaniment::getPrice();
        }
};

class Salad : public Accompaniment {
   public:
        Salad(const shared_ptr<Dish>& dish):Accompaniment(dish){}
        string getDescription() const override {
            return Accompaniment::getDescription() +" + Salad";
        }
        double getPrice() const override {
            return 7.50 + Accompaniment::getPrice();
        }
};

class Pasta : public Accompaniment {
    public:
        Pasta(const shared_ptr<Dish>& dish):Accompaniment(dish){}
        string getDescription() const override {
            return Accompaniment::getDescription() +" + Pasta";
        }
        double getPrice() const override {
            return 7.90 + Accompaniment::getPrice();
        }
};

class Soup : public Accompaniment {
    public:
        Soup(const shared_ptr<Dish>& dish):Accompaniment(dish){}
        string getDescription() const override {
            return Accompaniment::getDescription() +" + Soup";
        }
        double getPrice() const override {
            return  3.90 + Accompaniment::getPrice();
        }
};
void order(const shared_ptr<Dish> &Dish){
    cout << " Dish Ordered : " << Dish->getDescription() << endl;
    cout << " Price of the ordered Dish : " << Dish->getPrice() <<" EUR" << endl;
    cout << endl;
}
int main(){
    cout << endl;
    //Orders with Dishes
    shared_ptr<Dish> schnitzel{new VienneseSchnitzel};
    shared_ptr<Dish> sal{new salmon};
    shared_ptr<Dish> steak{new rumpSteak};
    //Orders along with Accompainments
    shared_ptr<Soup> order2 {make_shared<Soup>(schnitzel)};
    shared_ptr<Soup> order3 {make_shared<Soup>(make_shared<Pasta>(sal))};
    shared_ptr<Soup> order4 {make_shared<Soup>(make_shared<Pasta>(make_shared<Chips>(steak)))};
    shared_ptr<Soup> order5 {make_shared<Soup>(make_shared<Chips>(make_shared<Salad>(make_shared<Pasta>(schnitzel))))};
    
    order(steak);
    order(order2);
    order(order3);
    order(order4);
    order(order5);
}