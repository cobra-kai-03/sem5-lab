class frame:
    def __init__(self,seqno,cont):
        self.seq_no=seqno
        self.content=cont
    def printframe(self):
        print(self.seq_no," : ",self.content)

def sort(frames):
    n=len(frames)
    for i in range(n):
        for j in range(n-i-1):
            if(frames[j].seq_no>frames[j+1].seq_no):
                temp=frames[j]
                frames[j]=frames[j+1]
                frames[j+1]=temp


n=int(input("Enter number of frames"))

frames=[]
for i in range(n):
    seqno=int(input("Enter seq number"))
    cont=input("Enter content")
    frames.append(frame(seqno,cont))

print("Before sort")
for i in range(n):
    frames[i].printframe()

sort(frames)
print("After sort")
for i in range(n):
    frames[i].printframe()
# print(frames)

