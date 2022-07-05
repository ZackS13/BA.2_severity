#Data Analysis for Omicron Severity
#Authors: Zachary Strasser and Hossein Estiri
#Data: 7/5/22

#Data should be pulled, clear, and organized into the following columns: with unique categorical variables
#female: 1, 0 (1 representative of female) 
#age: integer  
#race: "BLACK OR AFRICAN AMERICAN", "WHITE", "OTHER/UNKNOWN", "ASIAN"  
#hispanic: 1, 0 (1 representative of hispanic)  
#vaccine_status: integer (0 for No vaccine, 1 for First dose, 2 for Two doses, 3 for Vaccinated with Booster)  
#mortality: Y, N  
#hospitalization: Y, N  
#ventilation: Y, N  
#icu: Y, N  
#era: "Delta", "Omicron", "0post-Omicron" 
#Onset: date  
#exlihauser_index: integer  (calculated using comorbidity package on extracted ICD codes)   
#prior infection: integer (0 is first infection, 1 is one prior infection, ect.)  
#Steroids: integer (0 is none, 1 is dexamethasone is given)  
#anti.viral: integer (0 is none, 1 is remdesivir or nirmatrelvir/ritonavir is given)

#Store this table in a dataframe called glm.dat
library(survey)
library(weightit)
library(data.table)
library(dplyr)
library(lubridate)
library(tidyr)

########################################Now perform IPTW############################################

#function for IPTW weights
outglm <- function(outcome,#outcome of interest
                   dat.aoi,#data for modeling
                     group
                     
){

dat.aoi$label <- as.factor(dat.aoi[,which(colnames(dat.aoi)==outcome)])
dat.aoi <- dat.aoi[,c(1:5,10,12:16)]
dat.aoi$label <- ifelse(dat.aoi$label == "N",0,1)#as.numeric(dat.aoi$label)
W.out <- weightit(Onset_ym ~ vaccine_status+hispanic+race+age+female+elixhauser_index+prior_infection+anti-viral+Steroids,
                    data = dat.aoi, estimand = "ATT",focal ="Opost_omicron" , method = "ebal")

bal.tab(W.out, m.threshold = 0.05, disp.v.ratio=TRUE)

# Now that we have our weights stored in W.out, let's extract them and estimate our treatment effect.
dat.aoi.w <- svydesign(~1, weights = W.out$weights, data = dat.aoi)

logitMod <- svyglm(label ~ era,
design = dat.aoi.w, family=quasibinomial(link="logit"))
summary <- summary(logitMod)
lreg.or <-exp(cbind(OR = coef(logitMod), confint(logitMod))) ##CIs using profiled log-likelihood
output <- data.frame(round(lreg.or, digits=4))
output$features <- rownames(output)
rownames(output) <- NULL
ps <- data.frame(
  round(
    coef(summary(logitMod))[,4],4))#P(Wald's test)
ps$features <- rownames(ps)
rownames(ps) <- NULL
output <- merge(output,ps,by="features")
output$features <- sub('`', '', output$features, fixed = TRUE)
output$features <- sub('`', '', output$features, fixed = TRUE)
colnames(output)[3:5] <- c("2.5","97.5","P (Wald's test)")
output$outcome <- outcome
output$group <- group


###proportions
pat.agg <- dat.aoi %>% 
  dplyr::group_by(era,vaccine_status,label) %>%
  dplyr::summarise(patients=n())
pat.agg$outcome <- outcome
pat.agg$group <- group

rm(logitMod,outcome,group)


return(
  list(ORs= output,
       summary=summary,
       counts = pat.agg)
)

}

all.icu <- outglm(outcome = "icu",dat.aoi=glm.dat,group="all")
all.hospitalization <- outglm(outcome = "hospitalization",dat.aoi=glm.dat,group="all")
all.ventilation <- outglm(outcome = "ventilation",dat.aoi=glm.dat,group="all")
all.mortality <- outglm(outcome = "mortality",dat.aoi=glm.dat,group="all")



Footer
© 2022 GitHub, Inc.
Footer navigation
