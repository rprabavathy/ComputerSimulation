
#include<iostream>
#include<string>
using namespace std;

//Medium
class Medium
{
	protected:
		double capacity; 
	public:
		Medium(double cap): capacity(cap){}
		friend ostream & operator<<(ostream & os, const Medium & obj);
};

ostream & operator<<(ostream & os, const Medium & obj)
{
	os<<"Medium Capacity\t: "<<obj.capacity<< " GB" << endl;
	return os;
}

//HardDisk
class HardDisk: public Medium
{
	protected:
		unsigned int partitions;
	public:
		HardDisk (double cap,unsigned int pn):Medium(cap), partitions(pn) {}
		
	friend ostream & operator<<(ostream & os, const HardDisk & obj);	
};
ostream & operator<<(ostream & op, const HardDisk & obj)
{
		op <<"Harddisk Capacity\t: " << obj.capacity<< " GB"  << endl;
		op <<"No of Partitions\t: " << obj.partitions << endl;
		return op;
}

//OpticalDisk
class OpticalDisk: public Medium
{
	protected:
		string title;
	public:
		OpticalDisk(double cap, string t):Medium(cap),title(t){}
		friend ostream & operator<<(ostream & os, const OpticalDisk & obj);
};

ostream & operator<<(ostream & os, const OpticalDisk & obj)
{
	os << "Optical Disk Capacity\t: " << obj.capacity<< " GB"  << endl;
	os << "Title\t: " << obj.title << endl;
	return os;
}

//CD
class CD: public OpticalDisk 
{
	protected:
		bool WoN;
	public:
		CD(double cap,string t ,bool wr):OpticalDisk(cap,t),WoN{wr} {}
		friend ostream & operator<<(ostream & os, const CD & obj);
};
ostream & operator<<(ostream & os, const CD & obj)
{
    os << "CD capacity\t: " << obj.capacity<< " GB"  << endl;
    os << "Title\t\t: " << obj.title<<endl;
    os << "Writable\t: " << ((obj.WoN == 1) ? "true" : "false" ) <<endl;
    return os;
}

enum class Type{ROM=0, RWp, RWm, RAM};

//DVD
class DVD: public OpticalDisk
{
	protected:
		Type format;
	public:
		DVD(double cap,string t, Type f):OpticalDisk(cap,t), format(f) {}
		friend ostream & operator<<(ostream & op, const DVD & obj);
};

ostream & operator<<(ostream & os, const DVD & obj)
{
		os << "DVD Capacity \t: "<< obj.capacity << " GB"<<endl;
		os << "Title \t\t: " << obj.title<<endl;
	switch(obj.format)
		{
		case Type::ROM:
			os<<"Format of DVD\t: DVD-ROM "<<endl;
			break;
		case Type::RWp:
			os<<"Format of DVD\t: DVD+R(W) "<<endl;	
			break;
		case Type::RWm:
			os<<"Format of DVD\t: DVD-R(W) "<<endl;
			break;
        case Type::RAM:
			os<<"Format of DVD\t: DVD-RAM "<<endl;
			break;
		default:
			os<<"Format of Medium\t: unknown "<<endl;
		}
		return os;
}



//test function
int main()
{
	// Size only in GB
	CD a (1,"CD_Title",true);
	cout<<a<<endl;
	DVD b (32,"DVD_Title",Type::ROM);
	cout<<b<<endl;
	HardDisk c(1000,5);
	cout<<c<<endl;
	return 0;
}