library(foreign)
library(TraMineR)
library(TraMineRextras)
setwd("~/github/local/sequence_course/Day-5/")


# Open SPSS data (data is in SPELL format)
bfsp <- read.spss("bfsp1.sav", to.data.frame=TRUE)
head(bfsp)

## reading personal data file (one row per person))
bfdata <- read.table("bfsp2.txt")
head(bfdata)

## transforming spell data into STS form
bf.sts <- seqformat(bfsp, from="SPELL", to="STS",
                    begin="begin", end="end", status="states",
                    pdata=bfdata, pvar=c("idpers", "birthyr"), limit=16)

## creating sequence object and making a d-plot
bf.seq <- seqdef(bf.sts)
seqdplot(bf.seq)

## compressed SPS form
bf.sps <- seqformat(bf.seq, from="STS", to="SPS", compressed=TRUE)

## SRS form
bf.srs <- seqformat(bf.seq, from="STS", to="SRS")

## cross tabulating state in T with state in T-2
table(bf.srs[, "T"], bf.srs[ , "T-2"])

## turning the state-sequence object into person-period data
bf.ppers <- toPersonPeriod(bf.seq)
head(bf.ppers)

## reverting the person-period data into STS form
bf.ppers$period <- bf.ppers$timestamp + 1
bfpp.sts <- seqformat(bf.ppers, from="SPELL", to="STS", id="id", begin="period", end="period", process=FALSE, limit=16)
head(bf.sts)