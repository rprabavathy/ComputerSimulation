/*program that repeatedly reads an integer number 𝑛, prints all possible pairs of positive
numbers with product 𝑛, and checks whether 𝑛 is prime.*/
#include <iostream>
#include<limits>
using namespace std;
int main() {
	signed long int num, div; //declaration of variables
	repeat:
	cout << "\nn = ";
	cin >> num;
	if (cin.fail()) {
		cout <<endl<< "Wrong Input!!! Try again"<< endl;
		cin.clear();
		cin.ignore(numeric_limits<streamsize>::max(), '\n');
		goto repeat;
	}
	if (num > 0) {
		int j = 0;
		for (int i = 1; i <= num; ++i) {
			if (num % i == 0) {
				div = num / i;
				cout << i << " * " << div << endl;
				++j;
			}
		}
		if (j == 2) {
			cout <<"\n"<< num << " is a prime number\n"<<endl;
		}
		else {
			cout <<"\n"<< num << " is not a prime number\n" << endl;
		}
		goto repeat;
	}
	else {
		//cout << "Program Terminated\n";
		return 0;
	}
	return 0;
}