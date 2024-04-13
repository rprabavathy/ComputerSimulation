// class date, IO-operators

#include <iomanip>
#include <iostream>

using namespace std;

class Date
{
private:
  int day;
  int month;
  int year;
  static inline const int daysPerMonth[]{ 31, 28, 31, 30, 31, 30, 31, 31, 30,
      31, 30, 31 };
  static const int stdYear{1970};
  static bool isLeapYear(int year)
  { return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0; }
  void checkDate();
public:
  explicit Date(int d = 1, int m = 1, int y = stdYear) : day{d}, month{m},
                                                         year{y}
  {
    checkDate();
  }
  Date(const Date& d2) : day{d2.day}, month{d2.month}, year{d2.year} {}
  int getDay() const { return day; }
  int getMonth() const { return month; }
  int getYear() const { return year; }
  void setDate(int d, int m, int y)
  {
    day = d;
    month = m;
    year = y;
    checkDate();
  }
  Date& incDay();
  Date& operator++();
  Date operator++(int);
  void print() const { cout << day << '.' << month << '.' << year << endl; }
  //Added 2 methods for Exercise 19
  int dayInYear() const;
  int operator-(const Date& d2) const;
};

//Start of method definition for Exercise 19
int Date::dayInYear() const{
	int daysInYear = 0;
	for (int i=1; i < month; i++){
		daysInYear += daysPerMonth[i];
	}
	daysInYear += day;
	if ((isLeapYear(year) == true) & (month > 2))
		daysInYear++;
	return daysInYear;
}
int Date::operator-(const Date& d2) const{ 
    int difference = 0;
    Date date(31, 12, d2.year); //last day of year
    if (d2.year < year){
      difference += date.dayInYear() - d2.dayInYear();//add days of first year
    }
    if (d2.year > year){
      difference -= date.dayInYear() - d2.dayInYear(); //add days of first year
    }
    
    if(d2.year < year){
      for (int y = d2.year + 1; y < year; y++){
        date.setDate(31, 12, y);
        difference += dayInYear(); //add days of years in between
      }
      difference += dayInYear(); //add days in last year
    }
    else if (d2.year > year){
      for (int y = year + 1; y < d2.year; y++){
        date.setDate(31, 12, y);
        difference -= dayInYear(); //substract days of years in between
      }
      difference += dayInYear();  //add days in last year
    }
    else return dayInYear() - d2.dayInYear();
    
  return abs(difference);
}
//End of Method Definition for Exercise 19

void Date::checkDate()
{
  if (year < 1 || month < 1 || month > 12 || day < 1
      || (day > daysPerMonth[month - 1]
          && !(day == 29 && month == 2 && isLeapYear(year))))
    {
      day = month = 1;
      year = stdYear;
    }
}

Date& Date::incDay()
{
  ++day;
  if (day > daysPerMonth[month - 1]
      && !(day == 29 && month == 2 && isLeapYear(year)))
    {
      day = 1;
      if (++month == 13)
        {
          month = 1;
          ++year;
        }
    }
  return *this;
}

Date& Date::operator++()
{
  incDay();
  return *this;
}

Date Date::operator++(int)
{
  Date temp{*this};
  incDay();
  return temp;
}

ostream& operator<<(ostream& os, const Date& d)
{
  os << setw(2) << setfill('0') << d.getDay() << '.'
     << setw(2) << d.getMonth() << '.'
     << d.getYear() << setfill(' ');
  return os;
}

istream& operator>>(istream& is, Date& d)
{
  int dd, mm, yy;
  is >> dd;
  is.ignore(1, '.');
  is >> mm;
  is.ignore(1, '.');
  is >> yy;
  d.setDate(dd, mm, yy);
  return is;
}

int main()
{
  Date d1, d2;
  cout <<"\nEnter a date : ";
  cin >> d1;
  cout<<endl;
  cout << "Enter a date to compute difference in days : ";
  cin >> d2;
  cout<<endl;
  cout<<"Day in Year for the date " << d1 <<" : "<< d1.dayInYear()<<endl;
  cout<<"\nDifference in days between " << d1 <<" & " << d2 << " : " << d2-d1 <<"\n";
  cout<<endl;
}