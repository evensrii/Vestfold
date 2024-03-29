library(tidyverse)

theme_set(theme_bw()) #set ggplot2 theme
setwd("C:/Users/eve1509/OneDrive - Vestfold og Telemark fylkeskommune/Github/Telemark/Data/08_Folkehelse og levek�r/R - FHUS fylkesvis/")
getwd()

kommune_raw <- read_csv("input/V&T.csv") #Datasett med kommuner
#land <- read_csv("input/V&Tlandgr.csv") #Info om landbakgrunn, men ikke kommune

# Ctrl + Shift + M = %>%

# "Group_by" tilsvarer de gruppene (og undergruppene) man �nsker p� x-aksen. Rekkef�lge betyr ikke n�dvendigvis noe.

# -------------------------- Tilf�ye innvandrerstatus til tabell med landbakgrunn ----------------------- #

#land <- land %>% 
#  mutate(Innvandrerstatus = case_when(QFVT_7_8D != "JEG HAR BODD I NORGE HELE LIVET" ~ "Innvandrere",
#                                      QFVT_7_8 == "NEI" | (QFVT_7_8 == "JA" & QFVT_7_8D == "JEG HAR BODD I NORGE HELE LIVET") ~ "Ikke-innvandrere"))

#unique(land$Innvandrerstatus)
#land %>% count(Innvandrerstatus)

#Innvandrere: Er selv, eller har forelder(e) som er f�dt i utlandet, OG har selv ikke bodd i Norge hele livet.

#Ikke-innvandrere: Verken selv eller forelder f�dt i utlandet, og har bodd i Norge hele livet.

## Sette opp datasett

kommune <- kommune_raw %>% rename(alder = alderkat,
                            kj�nn = Kjonn_Kode,
                            utdanning = utdannelse,
                            trivsel_n�rmilj� = QFVT_1_1,
                            trygg_n�rmilj� = QFVT_6_17,
                            org_aktivitet = QFVT_1_9,
                            annen_aktivitet = QFVT_1_10,
                            egen_helse = QFVT_2_1,
                            egen_tannhelse = QFVT_2_2,
                            tannlegebes�k = QFVT_2_3,
                            kost_b�r = QFVT_4_5,
                            kost_gr�nt = QFVT_4_6,
                            skader = QFVT_5_1,
                            forn�yd_livet = QFVT_6_1) %>%
  mutate(
    org_aktivitet_kat = case_when(
      org_aktivitet == "DAGLIG" ~ "MINST �N GANG I UKA",
      org_aktivitet == "UKENTLIG" ~ "MINST �N GANG I UKA",
      org_aktivitet == "1-3 GANGER PER M�NED" ~ "MINDRE ENN �N GANG I UKA",
      org_aktivitet == "SJELDNERE" ~ "MINDRE ENN �N GANG I UKA",
      org_aktivitet == "ALDRI" ~ "MINDRE ENN �N GANG I UKA"
    )
  ) %>%
  mutate(
    annen_aktivitet_kat = case_when(
      annen_aktivitet == "DAGLIG" ~ "MINST �N GANG I UKA",
      annen_aktivitet == "UKENTLIG" ~ "MINST �N GANG I UKA",
      annen_aktivitet == "1-3 GANGER PER M�NED" ~ "MINDRE ENN �N GANG I UKA",
      annen_aktivitet == "SJELDNERE" ~ "MINDRE ENN �N GANG I UKA",
      annen_aktivitet == "ALDRI" ~ "MINDRE ENN �N GANG I UKA"
    )
  ) %>%
  mutate(
    egen_helse_kat = case_when(
      egen_helse == "SV�RT GOD" ~ "GOD ELLER SV�RT GOD",
      egen_helse == "GOD" ~ "GOD ELLER SV�RT GOD",
      egen_helse == "VERKEN GOD ELLER D�RLIG" ~ "MINDRE ENN GOD ELLER SV�RT GOD",
      egen_helse == "D�RLIG" ~ "MINDRE ENN GOD ELLER SV�RT GOD",
      egen_helse == "SV�RT D�RLIG" ~ "MINDRE ENN GOD ELLER SV�RT GOD"
    )
  ) %>%
  mutate(
    kost_b�r_kat = case_when(
      kost_b�r == "SJELDEN/ALDRI" ~ "Sjeldnere enn daglig",
      kost_b�r == "1-3 GANGER PER M�NED" ~ "Sjeldnere enn daglig",
      kost_b�r == "1 GANG PER UKE" ~ "Sjeldnere enn daglig",
      kost_b�r == "2-3 GANGER PER UKE" ~ "Sjeldnere enn daglig",
      kost_b�r == "4-6 GANGER PER UKE" ~ "Sjeldnere enn daglig",
      kost_b�r == "1 GANG PER DAG" ~ "Daglig",
      kost_b�r == "FLERE GANGER PER DAG" ~ "Daglig"
    )
  ) %>%
  mutate(
    kost_gr�nt_kat = case_when(
      kost_gr�nt == "SJELDEN/ALDRI" ~ "Sjeldnere enn daglig",
      kost_gr�nt == "1-3 GANGER PER M�NED" ~ "Sjeldnere enn daglig",
      kost_gr�nt == "1 GANG PER UKE" ~ "Sjeldnere enn daglig",
      kost_gr�nt == "2-3 GANGER PER UKE" ~ "Sjeldnere enn daglig",
      kost_gr�nt == "4-6 GANGER PER UKE" ~ "Sjeldnere enn daglig",
      kost_gr�nt == "1 GANG PER DAG" ~ "Daglig",
      kost_gr�nt == "FLERE GANGER PER DAG" ~ "Daglig"
    )
  ) %>%
  mutate(
    forn�yd_livet_kat = case_when(
      forn�yd_livet == "0 - IKKE FORN�YD I DET HELE TATT" ~ "0",
      forn�yd_livet == "1" ~ "1",
      forn�yd_livet == "2" ~ "2",
      forn�yd_livet == "3" ~ "3",
      forn�yd_livet == "4" ~ "4",
      forn�yd_livet == "5" ~ "5",
      forn�yd_livet == "6" ~ "6",
      forn�yd_livet == "7" ~ "7",
      forn�yd_livet == "8" ~ "8",
      forn�yd_livet == "9" ~ "9",
      forn�yd_livet == "10 - SV�RT FORN�YD" ~ "10",
      forn�yd_livet == "VET IKKE" ~ "VET IKKE"
    )
  ) %>%
  mutate(
    trygg_n�rmilj�_kat = case_when(
      trygg_n�rmilj� == "0 - IKKE TRYGG I DET HELE TATT" ~ "IKKE TRYGG",
      trygg_n�rmilj� == "1" ~ "IKKE TRYGG",
      trygg_n�rmilj� == "2" ~ "IKKE TRYGG",
      trygg_n�rmilj� == "3" ~ "IKKE TRYGG",
      trygg_n�rmilj� == "4" ~ "IKKE TRYGG",
      trygg_n�rmilj� == "5" ~ "IKKE TRYGG",
      trygg_n�rmilj� == "6" ~ "TRYGG",
      trygg_n�rmilj� == "7" ~ "TRYGG",
      trygg_n�rmilj� == "8" ~ "TRYGG",
      trygg_n�rmilj� == "9" ~ "TRYGG",
      trygg_n�rmilj� == "10 - SV�RT TRYGG" ~ "TRYGG"
    )
  ) %>%
  mutate(
    utdanning_kat = case_when(
      utdanning == "H�y(Uni>2)" ~ "H�yere utdanning",
      utdanning == "Vgs/fag/h�y/uni<2" ~ "Videreg�ende skole",
      utdanning == "Grunnskole/tilsv." ~ "Grunnskole"
    )
  ) %>% 
  mutate(
    skader_kat = case_when(
      skader == "JA, EN" ~ "JA",
      skader == "JA, FLERE" ~ "JA",
      skader == "NEI" ~ "NEI"
    )
  ) %>% 
  mutate(
    tannlegebes�k_kat = case_when(
      tannlegebes�k == "0-2 �R SIDEN" ~ "NEI",
      tannlegebes�k == "3-5 �R SIDEN" ~ "JA",
      tannlegebes�k == "MER ENN 5 �R SIDEN" ~ "JA"
    )
  ) %>% 
  mutate(
    trivsel_n�rmilj�_kat = case_when(
      trivsel_n�rmilj� == "I STOR GRAD" ~ "I STOR GRAD",
      trivsel_n�rmilj� == "I NOEN GRAD" ~ "MINDRE ENN STOR GRAD",
      trivsel_n�rmilj� == "I LITEN GRAD" ~ "MINDRE ENN STOR GRAD",
      trivsel_n�rmilj� == "IKKE I DET HELE TATT" ~ "MINDRE ENN STOR GRAD"
    )
  ) %>% 
  mutate(
    egen_tannhelse_kat = case_when(
      egen_tannhelse == "SV�RT GOD" ~ "GOD ELLER SV�RT GOD",
      egen_tannhelse == "GOD" ~ "GOD ELLER SV�RT GOD",
      egen_tannhelse == "VERKEN GOD ELLER D�RLIG" ~ "MINDRE ENN GOD",
      egen_tannhelse == "D�RLIG" ~ "MINDRE ENN GOD",
      egen_tannhelse == "SV�RT D�RLIG" ~ "MINDRE ENN GOD"
    )
  ) %>% 
  mutate(
    kj�nn = case_when(
      kj�nn == "K" ~ "Kvinner",
      kj�nn == "M" ~ "Menn",
    )
  )
 

#Filtrere p� kun relevante variabler

df_kommuner <- kommune %>% select(kommunenr,
                                  alder,
                                  kj�nn,
                                  utdanning_kat,
                                  trivsel_n�rmilj�_kat,
                                  trygg_n�rmilj�_kat,
                                  org_aktivitet_kat,
                                  annen_aktivitet_kat,
                                  egen_helse_kat,
                                  egen_tannhelse_kat,
                                  tannlegebes�k_kat,
                                  kost_b�r_kat,
                                  kost_gr�nt_kat,
                                  skader_kat,
                                  forn�yd_livet_kat)


## Kommunevise datasett

df_vestfold <- df_kommuner %>% filter(kommunenr %in% c("3801", "3802", "3803", "3804", "3805", "3811"))
df_telemark <- df_kommuner %>% filter(kommunenr %in% c("3806","3807","3808","3812","3813","3814","3815","3816","3817","3818","3819","3820","3821","3822","3823","3824","3825"))

dfList <- list(df_vestfold, df_telemark)

##### Egen helse

egen_helse <- lapply(dfList, function(x) {
  egen_helse <- x %>% 
    group_by(egen_helse_kat) %>% 
    summarise(n = n()) %>% 
    na.omit() %>%
    mutate(andel = round((n/sum(n)*100),1))
})

egen_helse_vestfold <- egen_helse[[1]]
egen_helse_telemark <- egen_helse[[2]]

write.table(egen_helse_vestfold, "output/egen_helse_vestfold.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")
write.table(egen_helse_telemark, "output/egen_helse_telemark.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")

##### Egen helse X Kj�nn og utdanningsniv�

egenhelse_utdanning <- lapply(dfList, function(x) {
  egenhelse_utdanning <- x %>% 
    group_by(utdanning_kat, kj�nn, egen_helse_kat) %>% 
    summarise(n = n()) %>% 
    na.omit() %>%
    group_by(utdanning_kat, kj�nn, egen_helse_kat) %>% 
    summarise(totalt = sum(n)) %>% 
    group_by(utdanning_kat, kj�nn) %>% 
    mutate(andel = round((totalt/sum(totalt)*100),1)) %>% 
    filter(egen_helse_kat == "GOD ELLER SV�RT GOD") %>% 
    select(-egen_helse_kat, -totalt)
  
  egenhelse_utdanning_pivot <- pivot_wider(egenhelse_utdanning, names_from = kj�nn, values_from = andel)
  })

egenhelse_utdanning_vestfold <- egenhelse_utdanning[[1]]
egenhelse_utdanning_telemark <- egenhelse_utdanning[[2]]

write.table(egenhelse_utdanning_vestfold, "output/egenhelse_utdanning_vestfold.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")
write.table(egenhelse_utdanning_telemark, "output/egenhelse_utdanning_telemark.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")



##### B�r

b�r <- lapply(dfList, function(x) {
  b�r <- x %>% 
    group_by(kost_b�r_kat) %>% 
    summarise(n = n()) %>% 
    na.omit() %>%
    mutate(andel = round((n/sum(n)*100),1))
})

b�r_vestfold <- b�r[[1]]
b�r_telemark <- b�r[[2]]

write.table(b�r_vestfold, "output/b�r_vestfold.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")
write.table(b�r_telemark, "output/b�r_telemark.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")


##### Gr�nnsaker

gr�nnsaker <- lapply(dfList, function(x) {
  gr�nnsaker <- x %>% 
    group_by(kost_gr�nt_kat) %>% 
    summarise(n = n()) %>% 
    na.omit() %>%
    mutate(andel = round((n/sum(n)*100),1))
})

gr�nnsaker_vestfold <- gr�nnsaker[[1]]
gr�nnsaker_telemark <- gr�nnsaker[[2]]

write.table(gr�nnsaker_vestfold, "output/gr�nnsaker_vestfold.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")
write.table(gr�nnsaker_telemark, "output/gr�nnsaker_telemark.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")

##### Gr�nnsaker X Kj�nn og utdanningsniv�

kost_gr�nt_utdanning <- lapply(dfList, function(x) {
  kost_gr�nt_utdanning <- x %>% 
    group_by(utdanning_kat, kj�nn, kost_gr�nt_kat) %>% 
    summarise(n = n()) %>% 
    na.omit() %>%
    group_by(utdanning_kat, kj�nn, kost_gr�nt_kat) %>% 
    summarise(totalt = sum(n)) %>% 
    group_by(utdanning_kat, kj�nn) %>% 
    mutate(andel = round((totalt/sum(totalt)*100),1)) %>% 
    filter(kost_gr�nt_kat == "Daglig") %>% 
    select(-kost_gr�nt_kat, -totalt)
  
  kost_gr�nt_utdanning_pivot <- pivot_wider(kost_gr�nt_utdanning, names_from = kj�nn, values_from = andel)
})

kost_gr�nt_utdanning_vestfold <- kost_gr�nt_utdanning[[1]]
kost_gr�nt_utdanning_telemark <- kost_gr�nt_utdanning[[2]]

write.table(kost_gr�nt_utdanning_vestfold, "output/kost_gr�nt_utdanning_vestfold.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")
write.table(kost_gr�nt_utdanning_telemark, "output/kost_gr�nt_utdanning_telemark.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")

##### Organisert aktivitet X Kj�nn og utdanningsniv�

org_aktivitet_utdanning <- lapply(dfList, function(x) {
  org_aktivitet_utdanning <- x %>% 
    group_by(utdanning_kat, kj�nn, org_aktivitet_kat) %>% 
    summarise(n = n()) %>% 
    na.omit() %>%
    group_by(utdanning_kat, kj�nn, org_aktivitet_kat) %>% 
    summarise(totalt = sum(n)) %>% 
    group_by(utdanning_kat, kj�nn) %>% 
    mutate(andel = round((totalt/sum(totalt)*100),1)) %>% 
    filter(org_aktivitet_kat == "MINST �N GANG I UKA") %>% 
    select(-org_aktivitet_kat, -totalt)
  
  org_aktivitet_utdanning_pivot <- pivot_wider(org_aktivitet_utdanning, names_from = kj�nn, values_from = andel)
})

org_aktivitet_utdanning_vestfold <- org_aktivitet_utdanning[[1]]
org_aktivitet_utdanning_telemark <- org_aktivitet_utdanning[[2]]

write.table(org_aktivitet_utdanning_vestfold, "output/org_aktivitet_utdanning_vestfold.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")
write.table(org_aktivitet_utdanning_telemark, "output/org_aktivitet_utdanning_telemark.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")


##### Organisert aktivitet X Kj�nn og ALDER

org_aktivitet_alder <- lapply(dfList, function(x) {
  org_aktivitet_alder <- x %>% 
    group_by(alder, kj�nn, org_aktivitet_kat) %>% 
    summarise(n = n()) %>% 
    na.omit() %>%
    group_by(alder, kj�nn, org_aktivitet_kat) %>% 
    summarise(totalt = sum(n)) %>% 
    group_by(alder, kj�nn) %>% 
    mutate(andel = round((totalt/sum(totalt)*100),1)) %>% 
    filter(org_aktivitet_kat == "MINST �N GANG I UKA") %>% 
    select(-org_aktivitet_kat, -totalt)
  
  org_aktivitet_alder_pivot <- pivot_wider(org_aktivitet_alder, names_from = kj�nn, values_from = andel)
})

org_aktivitet_alder_vestfold <- org_aktivitet_alder[[1]]
org_aktivitet_alder_telemark <- org_aktivitet_alder[[2]]

write.table(org_aktivitet_alder_vestfold, "output/org_aktivitet_alder_vestfold.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")
write.table(org_aktivitet_alder_telemark, "output/org_aktivitet_alder_telemark.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")



##### Annen aktivitet X Kj�nn og utdanningsniv�

annen_aktivitet_utdanning <- lapply(dfList, function(x) {
  annen_aktivitet_utdanning <- x %>% 
    group_by(utdanning_kat, kj�nn, annen_aktivitet_kat) %>% 
    summarise(n = n()) %>% 
    na.omit() %>%
    group_by(utdanning_kat, kj�nn, annen_aktivitet_kat) %>% 
    summarise(totalt = sum(n)) %>% 
    group_by(utdanning_kat, kj�nn) %>% 
    mutate(andel = round((totalt/sum(totalt)*100),1)) %>% 
    filter(annen_aktivitet_kat == "MINST �N GANG I UKA") %>% 
    select(-annen_aktivitet_kat, -totalt)
  
  annen_aktivitet_utdanning_pivot <- pivot_wider(annen_aktivitet_utdanning, names_from = kj�nn, values_from = andel)
})

annen_aktivitet_utdanning_vestfold <- annen_aktivitet_utdanning[[1]]
annen_aktivitet_utdanning_telemark <- annen_aktivitet_utdanning[[2]]

write.table(annen_aktivitet_utdanning_vestfold, "output/annen_aktivitet_utdanning_vestfold.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")
write.table(annen_aktivitet_utdanning_telemark, "output/annen_aktivitet_utdanning_telemark.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")

##### Egen tannhelse

egen_tannhelse <- lapply(dfList, function(x) {
  egen_tannhelse <- x %>% 
    group_by(egen_tannhelse_kat) %>% 
    summarise(n = n()) %>% 
    na.omit() %>%
    mutate(andel = round((n/sum(n)*100),1))
})

egen_tannhelse_vestfold <- egen_tannhelse[[1]]
egen_tannhelse_telemark <- egen_tannhelse[[2]]

write.table(egen_tannhelse_vestfold, "output/egen_tannhelse_vestfold.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")
write.table(egen_tannhelse_telemark, "output/egen_tannhelse_telemark.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")


##### Egen tannhelse X Kj�nn og utdanningsniv�

egen_tannhelse_utdanning <- lapply(dfList, function(x) {
  egen_tannhelse_utdanning <- x %>% 
    group_by(utdanning_kat, kj�nn, egen_tannhelse_kat) %>% 
    summarise(n = n()) %>% 
    na.omit() %>%
    group_by(utdanning_kat, kj�nn, egen_tannhelse_kat) %>% 
    summarise(totalt = sum(n)) %>% 
    group_by(utdanning_kat, kj�nn) %>% 
    mutate(andel = round((totalt/sum(totalt)*100),1)) %>% 
    filter(egen_tannhelse_kat == "GOD ELLER SV�RT GOD") %>% 
    select(-egen_tannhelse_kat, -totalt)
  
  egen_tannhelse_utdanning_pivot <- pivot_wider(egen_tannhelse_utdanning, names_from = kj�nn, values_from = andel)
})

egen_tannhelse_utdanning_vestfold <- egen_tannhelse_utdanning[[1]]
egen_tannhelse_utdanning_telemark <- egen_tannhelse_utdanning[[2]]

write.table(egen_tannhelse_utdanning_vestfold, "output/egen_tannhelse_utdanning_vestfold.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")
write.table(egen_tannhelse_utdanning_telemark, "output/egen_tannhelse_utdanning_telemark.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")


##### Egen tannhelse X Kj�nn og alder

egen_tannhelse_alder <- lapply(dfList, function(x) {
  egen_tannhelse_alder <- x %>% 
    group_by(alder, kj�nn, egen_tannhelse_kat) %>% 
    summarise(n = n()) %>% 
    na.omit() %>%
    group_by(alder, kj�nn, egen_tannhelse_kat) %>% 
    summarise(totalt = sum(n)) %>% 
    group_by(alder, kj�nn) %>% 
    mutate(andel = round((totalt/sum(totalt)*100),1)) %>% 
    filter(egen_tannhelse_kat == "GOD ELLER SV�RT GOD") %>% 
    select(-egen_tannhelse_kat, -totalt)
  
  egen_tannhelse_alder_pivot <- pivot_wider(egen_tannhelse_alder, names_from = kj�nn, values_from = andel)
})

egen_tannhelse_alder_vestfold <- egen_tannhelse_alder[[1]]
egen_tannhelse_alder_telemark <- egen_tannhelse_alder[[2]]

write.table(egen_tannhelse_alder_vestfold, "output/egen_tannhelse_alder_vestfold.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")
write.table(egen_tannhelse_alder_telemark, "output/egen_tannhelse_alder_telemark.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")

##### Trivsel n�rmilj� X Kj�nn og alder

trivsel_n�rmilj�_alder <- lapply(dfList, function(x) {
  trivsel_n�rmilj�_alder <- x %>% 
    group_by(alder, kj�nn, trivsel_n�rmilj�_kat) %>% 
    summarise(n = n()) %>% 
    na.omit() %>%
    group_by(alder, kj�nn, trivsel_n�rmilj�_kat) %>% 
    summarise(totalt = sum(n)) %>% 
    group_by(alder, kj�nn) %>% 
    mutate(andel = round((totalt/sum(totalt)*100),1)) %>% 
    filter(trivsel_n�rmilj�_kat == "I STOR GRAD") %>% 
    select(-trivsel_n�rmilj�_kat, -totalt)
  
  trivsel_n�rmilj�_alder_pivot <- pivot_wider(trivsel_n�rmilj�_alder, names_from = kj�nn, values_from = andel)
})

trivsel_n�rmilj�_alder_vestfold <- trivsel_n�rmilj�_alder[[1]]
trivsel_n�rmilj�_alder_telemark <- trivsel_n�rmilj�_alder[[2]]

write.table(trivsel_n�rmilj�_alder_vestfold, "output/trivsel_n�rmilj�_alder_vestfold.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")
write.table(trivsel_n�rmilj�_alder_telemark, "output/trivsel_n�rmilj�_alder_telemark.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")


##### Skade X Kj�nn og alder

skader_alder <- lapply(dfList, function(x) {
  skader_alder <- x %>% 
    group_by(alder, kj�nn, skader_kat) %>% 
    summarise(n = n()) %>% 
    na.omit() %>%
    group_by(alder, kj�nn, skader_kat) %>% 
    summarise(totalt = sum(n)) %>% 
    group_by(alder, kj�nn) %>% 
    mutate(andel = round((totalt/sum(totalt)*100),1)) %>% 
    filter(skader_kat == "JA") %>% 
    select(-skader_kat, -totalt)
  
  skader_alder_pivot <- pivot_wider(skader_alder, names_from = kj�nn, values_from = andel)
})

skader_alder_vestfold <- skader_alder[[1]]
skader_alder_telemark <- skader_alder[[2]]

write.table(skader_alder_vestfold, "output/skader_alder_vestfold.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")
write.table(skader_alder_telemark, "output/skader_alder_telemark.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")

##### Trygg i n�rmilj�et (6-10)

trygg_n�rmilj� <- lapply(dfList, function(x) {
  trygg_n�rmilj� <- x %>%
    group_by(trygg_n�rmilj�_kat) %>% 
    summarise(n = n()) %>% 
    na.omit() %>% 
    mutate(andel = round((n/sum(n)*100),1))
})

trygg_n�rmilj�_vestfold <- trygg_n�rmilj�[[1]]
trygg_n�rmilj�_telemark <- trygg_n�rmilj�[[2]]

write.table(trygg_n�rmilj�_vestfold, "output/trygg_n�rmilj�_vestfold.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")
write.table(trygg_n�rmilj�_telemark, "output/trygg_n�rmilj�_telemark.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")

##### Trygg i n�rmilj�et (6-10) X Kj�nn

trygg_n�rmilj�_kj�nn <- lapply(dfList, function(x) {
  trygg_n�rmilj�_kj�nn <- x %>%
    group_by(kj�nn, trygg_n�rmilj�_kat) %>% 
    summarise(n = n()) %>% 
    na.omit() %>%
    mutate(andel = round((n/sum(n)*100),1))
})

trygg_n�rmilj�_kj�nn_vestfold <- trygg_n�rmilj�_kj�nn[[1]]
trygg_n�rmilj�_kj�nn_telemark <- trygg_n�rmilj�_kj�nn[[2]]

write.table(trygg_n�rmilj�_kj�nn_vestfold, "output/trygg_n�rmilj�_kj�nn_vestfold.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")
write.table(trygg_n�rmilj�_kj�nn_telemark, "output/trygg_n�rmilj�_kj�nn_telemark.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")

##### Forn�yd med livet (6-10)

forn�yd_livet <- lapply(dfList, function(x) {
  forn�yd_livet <- x %>%
  filter(forn�yd_livet_kat != "VET IKKE") %>%
  mutate(
    forn�yd_livet = case_when(
      forn�yd_livet_kat == "0" ~ "IKKE FORN�YD MED LIVET",
      forn�yd_livet_kat == "1" ~ "IKKE FORN�YD MED LIVET",
      forn�yd_livet_kat == "2" ~ "IKKE FORN�YD MED LIVET",
      forn�yd_livet_kat == "3" ~ "IKKE FORN�YD MED LIVET",
      forn�yd_livet_kat == "4" ~ "IKKE FORN�YD MED LIVET",
      forn�yd_livet_kat == "5" ~ "IKKE FORN�YD MED LIVET",
      forn�yd_livet_kat == "6" ~ "FORN�YD MED LIVET",
      forn�yd_livet_kat == "7" ~ "FORN�YD MED LIVET",
      forn�yd_livet_kat == "8" ~ "FORN�YD MED LIVET",
      forn�yd_livet_kat == "9" ~ "FORN�YD MED LIVET",
      forn�yd_livet_kat == "10" ~ "FORN�YD MED LIVET")) %>% 
  group_by(forn�yd_livet) %>% 
  summarise(n = n()) %>% 
  mutate(andel = round((n/sum(n)*100),1))
})

forn�yd_livet_vestfold <- forn�yd_livet[[1]]
forn�yd_livet_telemark <- forn�yd_livet[[2]]

write.table(forn�yd_livet_vestfold, "output/forn�yd_livet_vestfold.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")
write.table(forn�yd_livet_telemark, "output/forn�yd_livet_telemark.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")



##### Forn�yd med livet X Kj�nn og alder

# Vestfold

forn�yd_livet_alder_vestfold <- df_vestfold %>% 
  filter(forn�yd_livet_kat != "VET IKKE") %>% 
  group_by(alder, kj�nn) %>% 
  summarise(avg = round(mean(as.numeric(forn�yd_livet_kat)),2)) %>% 
  na.omit()

forn�yd_livet_alder_vestfold_pivot <- pivot_wider(forn�yd_livet_alder_vestfold, names_from = kj�nn, values_from = avg)
write.table(forn�yd_livet_alder_vestfold_pivot, "output/forn�yd_livet_alder_vestfold.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")

# Telemark

forn�yd_livet_alder_telemark <- df_telemark %>% 
  filter(forn�yd_livet_kat != "VET IKKE") %>% 
  group_by(alder, kj�nn) %>% 
  summarise(avg = round(mean(as.numeric(forn�yd_livet_kat)),2)) %>% 
  na.omit()

forn�yd_livet_alder_telemark_pivot <- pivot_wider(forn�yd_livet_alder_telemark, names_from = kj�nn, values_from = avg)
write.table(forn�yd_livet_alder_telemark_pivot, "output/forn�yd_livet_alder_telemark.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")

#### Tannlegebes�k x alder

# Vestfold

tannlegebes�k_alder_vestfold <- df_vestfold %>% 
  group_by(alder, tannlegebes�k_kat) %>% 
  summarise(n = n()) %>% 
  na.omit() %>%
  group_by(alder, tannlegebes�k_kat) %>% 
  summarise(totalt = sum(n)) %>% 
  group_by(alder) %>% 
  mutate(andel = round((totalt/sum(totalt)*100),1)) %>% 
  filter(tannlegebes�k_kat == "JA") %>% 
  select(-tannlegebes�k_kat, -totalt)

write.table(tannlegebes�k_alder_vestfold, "output/tannlegebes�k_alder_vestfold.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")

# Telemark

tannlegebes�k_alder_telemark <- df_telemark %>% 
  group_by(alder, tannlegebes�k_kat) %>% 
  summarise(n = n()) %>% 
  na.omit() %>%
  group_by(alder, tannlegebes�k_kat) %>% 
  summarise(totalt = sum(n)) %>% 
  group_by(alder) %>% 
  mutate(andel = round((totalt/sum(totalt)*100),1)) %>% 
  filter(tannlegebes�k_kat == "JA") %>% 
  select(-tannlegebes�k_kat, -totalt)

write.table(tannlegebes�k_alder_telemark, "output/tannlegebes�k_alder_telemark.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")


#### Tannlegebes�k x utdanning

# Vestfold

tannlegebes�k_utdanning_vestfold <- df_vestfold %>% 
  group_by(utdanning_kat, tannlegebes�k_kat) %>% 
  summarise(n = n()) %>% 
  na.omit() %>%
  group_by(utdanning_kat, tannlegebes�k_kat) %>% 
  summarise(totalt = sum(n)) %>% 
  group_by(utdanning_kat) %>% 
  mutate(andel = round((totalt/sum(totalt)*100),1)) %>% 
  filter(tannlegebes�k_kat == "JA") %>% 
  select(-tannlegebes�k_kat, -totalt)

write.table(tannlegebes�k_utdanning_vestfold, "output/tannlegebes�k_utdanning_vestfold.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")

# Telemark

tannlegebes�k_utdanning_telemark <- df_telemark %>% 
  group_by(utdanning_kat, tannlegebes�k_kat) %>% 
  summarise(n = n()) %>% 
  na.omit() %>%
  group_by(utdanning_kat, tannlegebes�k_kat) %>% 
  summarise(totalt = sum(n)) %>% 
  group_by(utdanning_kat) %>% 
  mutate(andel = round((totalt/sum(totalt)*100),1)) %>% 
  filter(tannlegebes�k_kat == "JA") %>% 
  select(-tannlegebes�k_kat, -totalt)

write.table(tannlegebes�k_utdanning_telemark, "output/tannlegebes�k_utdanning_telemark.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")


#### Tannhelse x Tid siden siste tannlegebes�k

df_tann <- kommune_raw %>% rename(egen_tannhelse = QFVT_2_2, tannlegebes�k = QFVT_2_3) %>%
  mutate(
    egen_tannhelse_kat = case_when(
      egen_tannhelse == "SV�RT GOD" ~ "GOD ELLER SV�RT GOD",
      egen_tannhelse == "GOD" ~ "GOD ELLER SV�RT GOD",
      egen_tannhelse == "VERKEN GOD ELLER D�RLIG" ~ "VERKEN GOD ELLER D�RLIG",
      egen_tannhelse == "D�RLIG" ~ "D�RLIG ELLER SV�RT D�RLIG",
      egen_tannhelse == "SV�RT D�RLIG" ~ "D�RLIG ELLER SV�RT D�RLIG"
    )
  ) %>% 
  select(kommunenr, egen_tannhelse_kat, tannlegebes�k)

df_tann_v <- df_tann %>% filter(kommunenr %in% c("3801", "3802", "3803", "3804", "3805", "3811"))
df_tann_t <- df_tann %>% filter(kommunenr %in% c("3806","3807","3808","3812","3813","3814","3815","3816","3817","3818","3819","3820","3821","3822","3823","3824","3825"))

## Vestfold

tannhelse_tannbes�k_vestfold <- df_tann_v %>% 
  group_by(egen_tannhelse_kat, tannlegebes�k) %>% 
  summarise(n = n()) %>% 
  na.omit() %>%
  group_by(egen_tannhelse_kat, tannlegebes�k) %>% 
  summarise(totalt = sum(n)) %>% 
  group_by(tannlegebes�k) %>% 
  mutate(andel = round((totalt/sum(totalt)*100),1)) %>% 
  select(-totalt)

tannhelse_tannbes�k_vestfold_pivot <- pivot_wider(tannhelse_tannbes�k_vestfold, names_from = egen_tannhelse_kat, values_from = andel)
write.table(tannhelse_tannbes�k_vestfold_pivot, "output/tannhelse_tannbes�k_vestfold.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")

## Telemark

tannhelse_tannbes�k_telemark <- df_tann_t %>% 
  group_by(egen_tannhelse_kat, tannlegebes�k) %>% 
  summarise(n = n()) %>% 
  na.omit() %>%
  group_by(egen_tannhelse_kat, tannlegebes�k) %>% 
  summarise(totalt = sum(n)) %>% 
  group_by(tannlegebes�k) %>% 
  mutate(andel = round((totalt/sum(totalt)*100),1)) %>% 
  select(-totalt)

tannhelse_tannbes�k_telemark_pivot <- pivot_wider(tannhelse_tannbes�k_telemark, names_from = egen_tannhelse_kat, values_from = andel)
write.table(tannhelse_tannbes�k_telemark_pivot, "output/tannhelse_tannbes�k_telemark.csv", sep = ";", dec = ",", quote = FALSE, row.names = FALSE, col.names = TRUE, fileEncoding = "utf8")


