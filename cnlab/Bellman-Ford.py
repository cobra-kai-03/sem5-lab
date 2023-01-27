class Graph:
    def __init__(self,n):
        self.v=n
        self.glist=[]

    def addedge(self,u,v,d):
        self.glist.append([u,v,d])
    
    def bellman(self,source):
        dist=[float("Inf")]*self.v
        dist[source]=0

        for i in range(self.v-1):
            for u,v,d in (self.glist):
                if(dist[u]!=float("Inf") and dist[u]+d<dist[v]):
                    dist[v]=dist[u]+d

        for u,v,d in (self.glist):
                if(dist[u]!=float("Inf") and dist[u]+d<dist[v]):
                    print("Graph has negative cycles")
                    return
        print("Distances calculated")
        for i in range(self.v):
            print(i," : ",dist[i])


n=int(input('Enter number of vertices  '))
m=int(input('Enter number of edges  '))
g = Graph(n)

print("The vertices are : ")
for i in range(n):
    print(i)
while(m>=1):
        a=int(input('Enter vertex1:  '))
        b=int(input('Enter vertex2:  '))
        c=int(input('Enter distance: '))
        g.addedge(a,b,c)
        m-=1

src=int(input("Enter source vertex"))
g.bellman(src)
