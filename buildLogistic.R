## build logit model
grep("^r1_hero$", colnames(dota))
grep("^r2_hero$", colnames(dota))
grep("^r3_hero$", colnames(dota))
grep("^r4_hero$", colnames(dota))
grep("^r5_hero$", colnames(dota))
grep("^d1_hero$", colnames(dota))
grep("^d2_hero$", colnames(dota))
grep("^d3_hero$", colnames(dota))
grep("^d4_hero$", colnames(dota))
grep("^d5_hero$", colnames(dota))

head(dota)

dota=dota[,c(-2,-11,-20 -29 -38,-47,-56,-65,-74,-83)]

grep("^r1_items$", colnames(dota))
grep("^r2_items$", colnames(dota))
grep("^r3_items$", colnames(dota))
grep("^r4_items$", colnames(dota))
grep("^r5_items$", colnames(dota))
grep("^d1_items$", colnames(dota))
grep("^d2_items$", colnames(dota))
grep("^d3_items$", colnames(dota))
grep("^d4_items$", colnames(dota))
grep("^d5_items$", colnames(dota))



dota=dota[,c(-9,-17,-26,-35,-44,-52,-60,-68,-76,-83)]

logitfull = glm(dota$radiant_win~.-V1 ,family = binomial(link=logit), data = dota)

## seems that xp, gold, kills, level,lh are sig.
## gero and item are excleude cuz not numerical nor factoriable, can misguide the outcome

