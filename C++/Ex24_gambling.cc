// gambling

#include <algorithm>
#include <cstdlib>
#include <iostream>
#include <list>
#include <random>
#include <string>

using namespace std;

class Bet
{
private:
  unsigned int money;
  char result; // one of o, e, 1, 2, 3, 4, 5, 6
public:
  Bet(unsigned int m = 0, char r = '0') : money{m}, result{r} {}
  unsigned int getMoney() const { return money; }
  char getResult() const { return result; }
};

//////////////////////////////////////////////////////////////////
// Add the classes Player, HumanPlayer, and ComputerPlayer here //
//////////////////////////////////////////////////////////////////
class Player{
  protected:
    string name;
    int money;
  public:
    Player(string n, int m) : name(n), money(m) {}
    inline void win(int val) {money+=val;}
    virtual Bet bet() = 0;
    string getName() {return name;};
    int getMoney() { return money;}
};

class HumanPlayer: public Player{
public:
	HumanPlayer(string n) : Player(n,1000)  {}
  Bet bet();
};

class ComputerPlayer: public Player{
public:
	ComputerPlayer(string n) : Player(n,1000)  {}
  Bet bet();
};

Bet HumanPlayer::bet() {

  bool validBetResult = false;
  int betAmount = 0;
  char betResult;
  string dummy;
  cout << "Player " << name << ", your bet:" << endl;
  cout << "Enter amount of money to bet (you have " << money << "): ";
  cin >> betAmount;
  do{
  cout << "result (o[dd], e[ven], 1, 2, 3, 4, 5, 6): ";
  cin >> betResult;
  getline(cin, dummy); // read only one character
    if (betResult == 'o' || betResult == '1' || betResult == '3' || betResult == '5' || betResult == 'e' || betResult == '2' || betResult == '4' || betResult == '6')
    {
      validBetResult = true;

    }
    else{
      validBetResult = false;
      cout << "Enter Valid Bet Result !! " << endl ;
    }
  }while(!validBetResult);
    
 
  money -= betAmount;
  return Bet(betAmount, betResult);
}

Bet ComputerPlayer::bet() {
  int betAmount = int(money / 2) < 1 ? 1 : int(money/2);
  money -= betAmount;
  cout << "Player " << name << " bets " << money << " on an odd number" << endl;
  return Bet(betAmount, 'o');
}

int main()
{
  list<Player*> players;
  unsigned int n;
  string name;
  string dummy;
  char type;
  // setup players
  cout << "number of players: ";
  cin >> n;
  for (unsigned int i{1}; i <= n; ++i)
    {
      cout << "Player " << i << ": human or computer (enter h/c): ";
      cin >> type;
      getline(cin, dummy); // read rest of line after 'h' or 'c', at least '\n'
      cout << "player's name: ";
      getline(cin, name);
      if (type == 'h')
        players.push_back(new HumanPlayer{name});
      else
        players.push_back(new ComputerPlayer{name});
    }

  // start game
  auto plit{players.begin()};
  // intialize random number generator
  mt19937_64 rng{random_device{}()};
  uniform_int_distribution dice{1, 6};
  while (players.size() > 1)
    {
      Player* p{*plit};      // p is a pointer to the current player
      Bet b{p->bet()};       // ask player for the bet
      int r{dice(rng)};  //roll dice
      cout << "Rolled: " << r << endl;
      if ((b.getResult() == 'o' && (r == 1 || r == 3 || r == 5))
          || (b.getResult() == 'e' && (r == 2 || r == 4 || r == 6)))
        {
          p->win(2 * b.getMoney()); // add money
          cout << p->getName() << " wins " << 2 * b.getMoney()
               << ", now has " << p->getMoney() << endl;
        }
      else if (b.getResult() - '0' == r)
        {
          p->win(6 * b.getMoney());
          cout << p->getName() << " wins " << 6 * b.getMoney()
               << ", now has " << p->getMoney() << endl;
        }
      else
        cout << p->getName() << " looses, now has "
             << p->getMoney() << endl;
      if (p->getMoney() == 0)
        {
          cout << p->getName() << " leaves the game" << endl;
          auto tmpit{plit};
          --plit;
          players.erase(tmpit);
        }

      ++plit;
      if (plit == players.end())
        plit = players.begin();
    }

  // just one player left, announce the winner
  cout << "Winner: " << (*players.begin())->getName() << ", money: "
       << (*players.begin())->getMoney() << endl;
}
