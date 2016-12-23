
dotaNum=apply(dota,2,as.numeric)
dotaNum=as.data.frame(dotaNum)
par(mfrow=c(2,2))
sapply(1:ncol(dotaNum), function(index) (hist(dotaNum[,index],
                                           main = c(colnames(dotaNum)[index]))))

sapply(1:ncol(dotaNum), function(index) (boxplot(dotaNum[,index]~dotaNum$radiant_win,
                                              main = c(colnames(dotaNum)[index]))))

par(mfrow=c(1,1))

dotaNum=dotaNum[,-1]
M=cor(dotaNum[,1:7])
corrplot(M, type="upper")#,title="Corrlation plot of Radiant player 1")
dim(M)

for(i in seq(1,80)){
  
  for (j in seq(1,73)){
    if(is.na(M[i,j]==T)){
      break
    }
    
    if(M[i,j]>0.8 && i<j){
      print(c(i,j,M[i,j])  )
    }
    
  }}

## ex and gold are only factors




### do histogram

##Radiant
dotaNum$sumGoldR=dotaNum$r1_gold+dotaNum$r2_gold+dotaNum$r3_gold+dotaNum$r4_gold+dotaNum$r5_gold
dotaNum$sumExpR=dotaNum$r1_xp+dotaNum$r2_xp+dotaNum$r3_xp+dotaNum$r4_xp+dotaNum$r5_xp

##Dire

dotaNum$sumGoldD=dotaNum$d1_gold+dotaNum$d2_gold+dotaNum$d3_gold+dotaNum$d4_gold+dotaNum$d5_gold
dotaNum$sumExpD=dotaNum$d1_xp+dotaNum$d2_xp+dotaNum$d3_xp+dotaNum$d4_xp+dotaNum$d5_xp

##

    ## gold compare
dotaNum$GoldCom=rep(0,nrow(dotaNum))
for(i in 1:nrow(dotaNum)){
  
  if(dotaNum$sumGoldR[i]>dotaNum$sumGoldD[i]){
    dotaNum$GoldCom[i]=1
  }
  else if(dotaNum$sumGoldR[i] < dotaNum$sumGoldD[i])
  {
    dotaNum$GoldCom[i]=0
  }
  
  else{
    dotaNum$GoldCom[i]=3
    
  }
}  
 
    

dsExpEqual <-  dotaNum %>%  
  group_by(GoldCom) 

dsCount<-  dplyr::summarise(dsExpEqual, count=n())
dsCount

jobLess <- dotaNum %>%
  filter(radiant_win==1)%>% #3 indicates  Unemployed
  group_by(GoldCom) %>% 
  dplyr::summarise(count=n())%>% 
  mutate(Percet = count/dsCount$count*100)
jobLess

jobLess <- dotaNum %>%
  filter(radiant_win==0)%>% #3 indicates  Unemployed
  group_by(GoldCom) %>% 
  dplyr::summarise(count=n())%>% 
  mutate(Percet = count/dsCount$count*100)
jobLess

### so if R gold > D gold, then win rate 67%, lose 32%
### so if R gold < D gold, then win rate 62.8%, lose 37.2%
## id wuqual, then 48.9 vs 51.1
# more gold menas higher win prob


## exp compare
dotaNum$ExpCom=rep(0,nrow(dotaNum))
for(i in 1:nrow(dotaNum)){
  
  if(dotaNum$sumExpR[i]>=dotaNum$sumExpD[i]){
    dotaNum$ExpCom[i]=1
  }
  else{
    dotaNum$ExpCom[i]=0
  }
}   


dotaNum$ExpComEqual=rep(0,nrow(dotaNum))

for(i in 1:nrow(dotaNum)){
  
  if(dotaNum$sumExpR[i]>dotaNum$sumExpD[i]){
    dotaNum$ExpComEqual[i]=1
  }
  else if(dotaNum$sumExpR[i]<dotaNum$sumExpD[i]){
    dotaNum$ExpComEqual[i]=0
  }
  else{
    dotaNum$ExpComEqual[i]=3
    
  }
}   

dsExpEqual <-  dotaNum %>%  
  group_by(ExpComEqual) 

dsCount<-  dplyr::summarise(dsExpEqual, count=n())
dsCount

jobLess <- dotaNum %>%
  filter(radiant_win==1)%>% #3 indicates  Unemployed
  group_by(ExpComEqual) %>% 
  dplyr::summarise(count=n())%>% 
  mutate(Percet = count/dsCount$count*100)
jobLess

jobLess <- dotaNum %>%
  filter(radiant_win==0)%>% #3 indicates  Unemployed
  group_by(ExpComEqual) %>% 
  dplyr::summarise(count=n())%>% 
  mutate(Percet = count/dsCount$count*100)
jobLess

## if R experience > dire, then r's win rate =65.58%, fail rate = 34.41%
#                  <            d's          =60.48%,            = 39.51
# if eaqual experience, then 50% vs 50%

## so 





















#dotaGold=dotaNum[dotaNum$sumGoldR>=dotaNum$sumGoldD,]
#dotaExp=dotaNum[dotaNum$sumExpR>=dotaNum$sumExpD,]
ds <-  dotaNum %>%  
  group_by(GoldCom) 

dsCount<-  dplyr::summarise(ds, count=n())
dsCount

jobLess <- dotaNum %>%
  filter(radiant_win==1)%>% #3 indicates  Unemployed
  group_by(GoldCom) %>% 
  dplyr::summarise(count=n())%>% 
  mutate(Percet = count/dsCount$count*100)
jobLess


jobLess <- dotaNum %>%
  filter(radiant_win==0)%>% #3 indicates  Unemployed
  group_by(GoldCom) %>% 
  dplyr::summarise(count=n())%>% 
  mutate(Percet = count/dsCount$count*100)
jobLess

#######
dsEx <-  dotaNum %>%  
  group_by(ExpCom) 

dsCount<-  dplyr::summarise(dsEx, count=n())
dsCount

jobLess <- dotaNum %>%
  filter(radiant_win==1)%>% #3 indicates  Unemployed
  group_by(ExpCom) %>% 
  dplyr::summarise(count=n())%>% 
  mutate(Percet = count/dsCount$count*100)

jobLess1 <- dotaNum %>%
  filter(radiant_win==0)%>% #3 indicates  Unemployed
  group_by(ExpCom) %>% 
  dplyr::summarise(count=n())%>% 
  mutate(Percet = count/dsCount$count*100)

# Generate data
c <- ggplot(jobLess, aes(factor(ExpCom)))
p<-ggplot(data=jobLess, aes(x=ExpCom, y=Percet)) +
  geom_bar(stat="identity", fill="steelblue")+
  theme_minimal()+ ylim(0,100)
p 

# By default, uses stat="bin", which gives the count in each category
ggplot(jobLess, aes(x = factor(ExpCom), y = jobLess$Percet)) + geom_bar(stat = "identity")
