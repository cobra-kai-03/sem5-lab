#include<iostream>
using namespace std;
struct frame{
int num;
char str[20];
};
struct frame arr[10];
int n;

void sort1() 
{
int i,j;
struct frame temp;
for(i=0;i<n-1;i++)

for(j=0;j<n-i-1;j++)

if(arr[j].num>arr[j+1].num)
{ temp=arr[j];
arr[j]=arr[j+1];
arr[j+1]=temp;

}

}

int main()
{
int i;
cout<<"Enter the number of frames"<<endl;
cin>>n;
for(i=0;i<n;i++)
{
cout<<"Enter the frame sequence number and frame contents"<<endl;
cin>>arr[i].num>>arr[i].str;
}
sort1();
cout<<"The frame in sequences"<<endl;
for(i=0;i<n;i++)
cout<<arr[i].num<<" "<<arr[i].str<<endl;
}