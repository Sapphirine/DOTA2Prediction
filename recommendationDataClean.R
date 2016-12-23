dota=fread(file="usefultest.csv",header=T)

## matrix for recommendation
a=rep(0,97230*113)#preferecne
b=1:nrow(usefulDota)#match
b=rep(b,each=113)
c=1:113
c=rep(c,times=nrow(usefulDota))#item

recom=data.frame(b,c,a)  

grep("^d1_hero$", colnames(usefulDota))
grep("^d2_hero$", colnames(usefulDota))


t=0
for( i in 1:nrow(usefulDota)){
      t=t+1
      
      if(usefulDota$radiant_win==0){
          for(j in 1:113){
            
              
          }
          
      }
  
      else{
        
        
      }
}