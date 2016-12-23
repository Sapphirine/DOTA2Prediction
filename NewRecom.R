## make recommendation matrix


use=apply(use,2,as.numeric)
use=as.data.frame(use)


## Create and save subset of rejection data
set.seed(10)
sample <- sample_n(use, size = 2000)

m <- matrix(0, ncol = 3, nrow = 2000*113)
m <- data.frame(m)

## matrix for recommendation
a=rep(0,2000*113)#preferecne
b=1:nrow(sample)#match
b=rep(b,each=113)
c=1:113
c=rep(c,times=nrow(sample))#item

m$X1=b
m$X2=c
m$X3=a

rm(a,b,c)

for(i in 1:2000){
  
  if(sample$radiant_win[i]==1){
      a1=(i-1)*113+sample$r1_hero[i]
      m$X3[a1]=1
      
      a2=(i-1)*113+sample$r2_hero[i]
      m$X3[a2]=1
      
      a3=(i-1)*113+sample$r3_hero[i]
      m$X3[a3]=1
      
      a4=(i-1)*113+sample$r4_hero[i]
      m$X3[a4]=1
      
      a5=(i-1)*113+sample$r5_hero[i]
      m$X3[a5]=1
  }
  else{
    
    b1=(i-1)*113+sample$d1_hero[i]
    m$X3[b1]=1
    
    b2=(i-1)*113+sample$d2_hero[i]
    m$X3[b2]=1
    
    b3=(i-1)*113+sample$d3_hero[i]
    m$X3[b3]=1
    
    b4=(i-1)*113+sample$d4_hero[i]
    m$X3[b4]=1
    
    b5=(i-1)*113+sample$d5_hero[i]
    m$X3[b5]=1
  }
}
head(sample,lis=2)

write.csv(m,file="recom2000.csv")
write.table(m,file="re2000.txt",sep=",", col.names = F, row.names = F)
