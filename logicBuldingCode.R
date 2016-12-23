

load("DotaNumeric.Rdata")
use=dotaNum
use=as.data.frame(use)

mode(use[,1])
noHero=use[, -grep("hero", colnames(use))]
grep("^d1_level$", colnames(use))
noHero=noHero[,-1]

a=use
a=a[,-1]
noHero=a
x11=noHero[,1:40]

x22=noHero[,41:81]


## x1 x11 x2 x22

noHeroandItem=cbind(x11,x22)

noHeroandItem=noHeroandItem[, -grep("items", colnames(noHeroandItem))]

d11=d1[, grep("gold", colnames(d1))]
d12=d1[, grep("_xp", colnames(d1))]
d13=d1[, grep("win", colnames(d1))]
 dd=cbind(d11,d12,d13)
 logitfull1 = glm(dd$d13~. ,family = binomial(link=logit), data = dd)
 summary(logitfull1)
 
 
 
 library(ROCR)
 p <- predict(logitfull1, newdata=subset(dd, type="response"))
 pr <- prediction(p, dd$d13)
 prf <- performance(pr, measure = "tpr", x.measure = "fpr")
 plot(prf,main="ROC curve")
 abline(a=0,b=1)
 
 auc <- performance(pr, measure = "auc")
 auc <- auc@y.values[[1]]
 auc
 
 stargazer(logitfull1, type="text",out="logitOUt.txt")
 stargazer(logitfull, type="text",out="logitOUt2.txt")
 
 

d=fread(file="DotaNum.csv",header=T)
d=as.data.frame(d)

d1=d[,3:75]


logitfull = glm(noHeroandItem$radiant_win~. ,family = binomial(link=logit), data = noHeroandItem)
summary(logitfull)

logitfull = glm(d1$radiant_win~. ,family = binomial(link=logit), data =d1)
summary(logitfull)
library(ROCR)
p <- predict(logitfull, newdata=subset(d1, type="response"))
pr <- prediction(p, d1$radiant_win)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)

auc <- performance(pr, measure = "auc")
auc <- auc@y.values[[1]]
auc

# 71%



## only have ex and gold

onlyExandGold1=noHeroandItem[, grep("_xp", colnames(noHeroandItem))]
onlyExandGold2=noHeroandItem[, grep("gold", colnames(noHeroandItem))]
onlyExandGold=cbind(onlyExandGold1,onlyExandGold2,y)
dim(onlyExandGold)


logitfull = glm(y~. ,family = binomial(link=logit), data =onlyExandGold)
summary(logitfull)


library(ROCR)
p <- predict(logitfull, newdata=subset(onlyExandGold, type="response"))
pr <- prediction(p, noHeroandItem$radiant_win)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)

auc <- performance(pr, measure = "auc")
auc <- auc@y.values[[1]]
auc


