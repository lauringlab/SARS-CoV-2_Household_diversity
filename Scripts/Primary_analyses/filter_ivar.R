library (plyr)
library (dplyr)
library (stringr)
library (Biostrings)

variant.df <- read.table(snakemake@input[[1]],stringsAsFactors=F,comment.char = '#', header=T)

##basic filtering
variant.df<-filter (variant.df, !str_detect (ALT, "[+-]")) # remove indels 
variant.df<-mutate(variant.df,mutation=paste0(REF,POS,ALT))
#variant.df<-subset(variant.df, PASS_1=="TRUE" & PASS_2=="TRUE") # only keep variants that pass p value (0.05)
variant.df <- filter (variant.df, PVAL<=1e-5 ) # only keep variants that have a p value  less than 10^-5 
variant.df <- filter (variant.df, TOTAL_DP >=400) # total depth is  equal to or greater than 400. 


## remove variants not between 2 and 98%
 
variant.df <- filter (variant.df,ALT_FREQ <= 0.95)


filename <-snakemake@input[[1]]
filename2 <- sub(".merged.variants.tsv", "", filename)

filename_vec <- strsplit(filename2, split = "/")[[1]]
if (dim(variant.df)[1] != 0) {
variant.df$sample <- filename_vec[4]
}

write.table (variant.df, snakemake@output[[1]], quote=F, row.names=F)