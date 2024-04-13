// class date, IO-operators

#include <iomanip>
#include <iostream>
#include <string>

using namespace std;

class DateException
  {
  public:
    enum class DatesExcType { unknown, dayError, monthError,yearError,leapyearError, allInvalid };
  private:
    DatesExcType type;
    string where;
  public:
    DateException() : type{DatesExcType::unknown} {}
    DateException(DatesExcType met) : type{met} {}
    DateException(DatesExcType met, const string w)
      : type{met}, where{w} {}
    std::string what() const;
  }; 


string DateException::what() const
  {
    ostringstream os;
    os << "\n";
    switch (type)
      {
        case DatesExcType::dayError:
          os << "invalid day : " << where;
          break;
        case DatesExcType::monthError:
          os << "invalid month : " << where;
          break;
        case DatesExcType::yearError:
          os << "invalid year : " << where;
          break;
        case DatesExcType::leapyearError:
          os << "no leap year : " << where;
          break;
        case DatesExcType::allInvalid:
          os << "invalid day : " << where;
          os << "\ninvalid month : " << where;
          os << "\nno leap year : " << where;
        break;

        default: //unknown
          os << "unknown error";
          break;
      }
    /*if(!where.empty())
     os << (": " + where);*/
    return os.str();
  }

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
    Date() : day{1}, month{1}, year{stdYear} {}
    explicit Date(int d , int m, int y) : day{d}, month{m}, year{y}
    {
    cout << "Checking constructor:"<<endl;
    try{
      checkDate();
      cout << "no error in constructing date " << setw(2) << setfill('0') << day << '.'<< setw(2) << month << '.'
      << year << setfill(' ') << endl;
    }catch(DateException exp){
        cout<<"Error in creating/setting date";
        cerr << exp.what() << endl;
    }
   }
  Date(const Date& d2) : day{d2.day}, month{d2.month}, year{d2.year} {}
  int getDay() const { return day; }
  int getMonth() const { return month; }
  int getYear() const { return year; }
  void setDate(int d, int m, int y)
  {
    cout<<"Checking setDate:" << endl;
    day = d;
    month = m;
    year = y;
     try{
    checkDate();
    cout << "no error in setting date " << setw(2) << setfill('0') << day << '.' << setw(2) << month << '.'
     << year << setfill(' ') << endl;  
      }catch(DateException exp){
        cout<<"Error in creating/setting date";
        cerr << exp.what() << endl;
    }
  }

  Date& incDay();
  Date& operator++();
  Date operator++(int);
  void print() const { cout << day << '.' << month << '.' << year << endl; }
};

void Date::checkDate()
{  
  if(day < 1 && month < 1 && year < 1){
    throw DateException{DateException::DatesExcType::allInvalid,to_string(-1)};
  }
  if(day == 29 && month == 2 && !isLeapYear(year)){
      throw DateException{DateException::DatesExcType::leapyearError,to_string(year)};
  }

  if(day < 1 ||  (day > daysPerMonth[month - 1] && !(day == 29 && month == 2 && isLeapYear(year)))){
    throw DateException{DateException::DatesExcType::dayError,to_string(day)};
  }

  
  if(month < 1 || month > 12){
    throw DateException{DateException::DatesExcType::monthError,to_string(month)};
  }

  if (year < 1){
    throw DateException{DateException::DatesExcType::yearError,to_string(year)};
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
  Date d1{dd,mm,yy};
  d.setDate(dd, mm, yy);
  return is;
}

int main()
{
    Date d;
    cout << "Enter day, month, and year: ";
    cin >> d;

}
