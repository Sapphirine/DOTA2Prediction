library(data.table)



dota=fread("features2.csv",header=T)

dota1=dota
na_count <-sapply(dota1, function(y) sum(length(which(is.na(y)))))
na_count=data.frame(na_count)
na_count
na_count$na_count[1121]

head(na_count)
na_count$na_count[97]
dota2=dota1

na=c(1,2)
j=1
for(i in 1:ncol(dota1)){
  if(na_count$na_count[i] > 1000){
        
        na[j]=i
        j=j+1
      
          }
}

#na=as.data.frame(na)

rm(dota1)
dota1=dota
dota1=as.data.frame(dota1)
dota1=dota1[,-c(na)]
dim(dota1)
str(dota1)

grep("^radiant_win$", colnames(dota1))

write.csv(dota1,file="noNAtest.csv")



zcount <-sapply(dota1, function(y) sum(length(which((y==0)))))
zcount=data.frame(zcount)
zcount

z=c(1,2)
j=1
for(i in 1:ncol(dota1)){
  if(zcount$zcount[i] >= 97230){
    z[j]=i
    j=j+1
  }
}

z
dim(dota1)
dota1=dota1[,-c(z)]
write.csv(dota1,file="noNAtest.csv")

dota1=fread("noNAtest.csv",header=T)
grep("^r1_hero$", colnames(dota1))
grep("^r5_items$", colnames(dota1))


grep("^d1_hero$", colnames(dota1))
grep("^d5_items$", colnames(dota1))

usefulDota=dota1[,c(5:94,96)]

colnames(usefulDota)
grep("^r1_hero$", colnames(usefulDota))
grep("^r5_items$", colnames(usefulDota))


grep("^d1_hero$", colnames(usefulDota))
grep("^d5_items$", colnames(usefulDota))
write.csv(usefulDota,file="usefultest.csv")

dotat=fread("dota_dataset.csv",header=T)

colnames(dotat)
