

#include <cstdlib>
#include <fstream>
#include <iostream>
#include<cstring>


using namespace std;

void enDecrypt(char * argv[]) {
  
    srand(stoi(argv[1]));

    ifstream infile{argv[2]};
    ofstream outfile{argv[3]};
    char c;
    while (infile.get(c)){
            c^=(rand()%256);
            outfile << c;
    }
    // close the files
    infile.close();  // not necessary here, because the files are
    outfile.close(); // automatically closed at the end of main()
}

int main(int argc, char** argv)
{
    // check number of command line parameters
    if (argc != 4)
    {
        cerr << "Syntax: algorithm key inputfile outputfile" << endl << "algorithm = encypter/decrypter and key = random Interger Number" <<endl;
        exit(1);
    }

    if (!argv[1] && !argv[2] && !argv[3])
    {
        cerr << "Input valid sytax" << endl
             << "eg., encrpter 12345 input.txt encfile.dat" << endl
             << "or , decrypter 12345 encfile.dat decfile.dat" << endl;
        exit(1);
    }else{
        enDecrypt(argv);
    }
    return 0;    
}
