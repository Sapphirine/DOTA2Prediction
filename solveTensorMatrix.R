# after eda

load("DotaNumeric.Rdata")


m <- matrix(0, ncol = 227, nrow = nrow(dotaNum))
m <- data.frame(m)
m$X227=dotaNum$radiant_win

use=fread(file="usefultest.csv",header=T)
  
for(i in 1:nrow(dotaNum)){
  
  a1=as.numeric(use$r1_hero[i])
  a2=as.numeric(use$r2_hero[i])
  a3=as.numeric(use$r3_hero[i])
  a4=as.numeric(use$r4_hero[i])
  a5=as.numeric(use$r5_hero[i])

    m[i,a1]= m[i,a1]+1
      
  m[i,a2]=  m[i,a2]+1
   m[i,a3]=   m[i,a3] +1

 m[i,a4]=m[i,a4]+1
 m[i,a5]=m[i,a5]+1
  
  ## D
  b1=as.numeric(use$d1_hero[i])
  b2=as.numeric(use$d2_hero[i])
  b3=as.numeric(use$d3_hero[i])
  b4=as.numeric(use$d4_hero[i])
  b5=as.numeric(use$d5_hero[i])
  
  it=113
  
 m[i,b1+it]= m[i,b1+it]+1
  m[i,b2+it] = m[i,b2+it]+1
  m[i,b3+it]=m[i,b3+it]+1
  m[i,b4+it]=m[i,b4+it]+1
 m[i,b5+it]=m[i,b5+it]+1
    
}

write.csv(m,file="HeroMatrix.csv")





save(dotaNum, file = 'DotaNumeric.RData')
write.csv(dotaNum,file="DotaNum.csv")
hero$X=0:(nrow(dotaNum)-1)
write.csv(hero,file="HeroMatrix.csv")

head(hero)
hero=hero[,-1]
x1=hero[,1:113]
x2=hero[,114:226]
y=hero[,227]


mode(use[,1])
noHero=use[, -grep("hero", colnames(use))]
grep("^d1_level$", colnames(use))
noHero=noHero[,-1]


x11=noHero[,1:40]

x22=noHero[,41:81]


## x1 x11 x2 x22

heroAndGold=cbind(x1,x11,x2,x22)
colnames(heroAndGold)

write.csv(heroAndGold,file="HeroAndGoldMatrix.csv")


heroAndGold
