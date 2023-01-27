#include<iostream>
#include<string>
#include<vector>
using namespace std;
class packet{
    public:
    int id;
    int s;
    packet(int id,int size){
        this->id=id;
        this->s=size;
    }
    string printpack(){
        return "Packet "+to_string(this->id) + " : size "+to_string(this->s);
    }
};
vector<packet> queue(int n){
    vector<packet> q;
    for(int i=0;i<n;i++){
        int id,size;
        cout<<"Enter id of packet"<<endl;
        cin>>id;
        cout<<"Enter size of packet"<<endl;
        cin>>size;
        q.push_back(packet(id,size));
    }
    return q;
}
void leakybucket(vector<packet> q){
    int leakrate,buffsize;
    cout<<"Enter leak rate of the bucket"<<endl;
    cin>>leakrate;
    cout<<"Enter buffer size of the bucket"<<endl;
    cin>>buffsize;
    int n=leakrate;
    int i=0;
    while(i<(q.size())){
        if(q[i].s>buffsize){
            cout<<"Bucket is full...packet dropped.."<<endl;
            i+=1;
            continue;
        }
        if(leakrate<q[i].s){
            leakrate=n;
            cout<<"Leak rate is reset to "<<n<<endl;
        }
        string s=q[i].printpack()+" is sent through the network";
        cout<<s<<endl;
        leakrate=leakrate-q[i].s;
        i+=1;
    }
}
int main(){
    int n;
    cout<<"Enter number of packets"<<endl;
    cin>>n;
    vector<packet> q=queue(n);
    for(int i=0;i<q.size();i++){
        cout<<q[i].printpack()<<endl;
    }
    leakybucket(q);
    return 0;
}
