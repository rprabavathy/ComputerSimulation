

#include <iostream>
#include <string>
#include <set>
#include <type_traits>

using namespace std;

class Literature {
    protected:
    string title;
    
    public:
    Literature():title("") {}
    Literature(string t):title(t) {}
    
};

class Journal;

class Paper : protected Literature
{
private:
    string author;
    Journal *journal = nullptr;

    public:
    Paper():author("") {}
    Paper(string t, string a): Literature(t), author(a) {}
    void publishedIn(Journal &j);
    friend ostream& operator<<(ostream &os, const Paper& p);
};

class Journal: protected Literature {
    private:
    int volume;

    public:
    Journal(): volume(),toc() {}
    Journal(string t, int vol): Literature(t), volume(vol) {}
    void publish(Paper &p);
    void printTOC();
    int getVol() { return volume; }
    string getTitle() { return title; }
};

void Paper::publishedIn(Journal &j) {
    
    if (journal != nullptr) {
        cerr << ("Error: Paper Already published in Journal " + j.getTitle() + "; Duplicate avoided") << endl;
    }
    else
        journal = &j;

}

ostream &operator<<(ostream &os, const Paper& p) {

    cout << p.author << ", \"" << p.title << "\", ";
    if (p.journal) {
        cout << p.journal->getTitle() << ", vol. " << p.journal->getVol() << endl;
    } 
    return os;
}

void Journal::publish(Paper &p) {
    try
    {
        p.publishedIn(*this);
        toc.emplace(&p);
    }
    catch (exception e) {
        
    } 
}


void Journal::printTOC() {
    int i = 0;
    for(auto it:toc)
        cout << "Paper "<< i++ << ": " << *it;
}


int main()
{
    Journal J1("Nat. Rev. Phys", 3);
    Paper dmd("Physics-informed machine learning", "G. E. Karniadakis, I. G. Kevrekidis, L. Lu, P. Perdikaris, S. Wang, and L. Yang");
    J1.publish(dmd);
   
    J1.printTOC();
    dmd.publishedIn(J1);
    J1.printTOC();
    return 0;
}