snv <- read.table ("all_variants_filtered", header=T)

## filter snv

Coverage <- read.table ("AvgCoverage.all", header=T)
Coverage_pass <- filter (Coverage,mean >= 200 )
snv <- filter (snv, sample %in% Coverage_pass$sample) #filter by coverage

mask_sites <- read.table ("problematic_sites_v7.txt", header=T)
snv <- filter (snv, !POS %in% mask_sites$POS)

hh <- read.csv ("Household_new_indiv.csv") ## add in household data
snv <- left_join (snv, hh, by = "sample")
snv <- filter (snv, hhid !is.na)


## get list of consensus level SNPS
hh_mutation <- read.csv ("Household_consensus_mutation_list.csv")
snv <- unite (snv, Household_mutation, hhid, POS, sep = "-", remove=F)
snv_consensus_snps <- filter (snv, Household_mutation %in% hh_mutation$Household_mutation)
write.csv (snv_consensus_snps, "consensus_level_snps.csv", row.names=F, quote=F)

## Get list of shared variants between household members

snv_shared_count <- snv %>%  count (Household_mutation) %>% filter (n>1)
snv_shared <- filter (snv, Household_mutation %in% snv_shared_count$Household_mutation)
write.csv (snv_shared, "")