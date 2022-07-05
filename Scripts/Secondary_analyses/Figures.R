library (ggplot2)
library (dplyr)


## Figure 1
PR <- read.csv ("Data/Epiweek_sampling/PR_Epiweek_cases_PropSequencing.csv")
NY <- read.csv ("Data/Epiweek_sampling/NY_Epiweek_cases_PropSequencing.csv")
UT <- read.csv ("Data/Epiweek_sampling/UT_Epiweek_cases_PropSequencing.csv")

 
ALL_locations <- bind_rows (PR, NY, UT) 

 gp1 <- ALL_locations %>% ggplot() + 
  geom_bar(mapping = aes(x = EPIWEEK, y = Participants.with.new.infection), stat = "identity", fill = "grey70") + 
  geom_line(mapping = aes(x = EPIWEEK, y = Proportion_cases_sequenced * 30, group=1)) + 
  scale_y_continuous(name = ("Number of infections in households"), limits = c(0, 15))+ theme_bw() + theme (axis.text.x = element_text(angle = 45, hjust = 1, size =8))+
scale_x_discrete(breaks = PR$EPIWEEK[seq(1, length(PR$EPIWEEK), by = 2)])+ facet_grid (rows=vars(Location))

gp1<- gp1 %+% scale_y_continuous(name = ("Number of infections in households"), sec.axis = sec_axis(~ . /30  , name = "Proportion of cases sequenced statewide"), limits = c(0, 15))


ggsave ("Figure1.pdf", plot = gp1)

## Figure 2 and 3 were created in USHER

## Figure 4

hh_snps <- read.csv ("Data/intrahost_Variants/hh_snps_consensus_and_polymorphisms_5_to_95.csv")

hh_snps$Frequency[hh_snps$Frequency ==0] <- NA

ggplot (hh_snps, aes (CDC_Specimen, Frequency))+ geom_point (aes (color=Mutation, shape=Variant_fixed, fill=Mutation ))+ scale_shape_manual(values=c (22,23,21))+facet_wrap (vars(Household), scales = "free_x")+theme_bw()+theme(axis.text.x = element_text(angle = 30, hjust = 1))+ xlab ("")

ggsave ("Figure_4.pdf")