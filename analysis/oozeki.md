## 追加: 大関限定



```r
library(data.table)
library(dplyr)
```

```
## Warning: package 'dplyr' was built under R version 3.1.1
```

```
## 
## Attaching package: 'dplyr'
## 
##  以下のオブジェクトはマスクされています (from 'package:data.table') : 
## 
##      between, last 
## 
##  以下のオブジェクトはマスクされています (from 'package:stats') : 
## 
##      filter 
## 
##  以下のオブジェクトはマスクされています (from 'package:base') : 
## 
##      intersect, setdiff, setequal, union
```

```r
library(ggplot2)
library(stringr)
```


```r
dat_winlose = fread("./winLoseDataTable.dat.tmp") %>% 
  mutate(WIN_FLG = ifelse(V8 == "W", 1, 0)) %>% 
  mutate(LOSE_FLG= ifelse(V8 == "L", 1, 0)) %>% 
  filter(WIN_FLG + LOSE_FLG > 0) %>% 
  select(V1:V5, WIN_FLG,LOSE_FLG)
dat_winlose
```

```
##           V1 V2 V3     V4         V5 WIN_FLG LOSE_FLG
##      1: 1988  1  1   横綱 千代の富士       1        0
##      2: 1988  1  1   横綱 千代の富士       1        0
##      3: 1988  1  1   横綱 千代の富士       1        0
##      4: 1988  1  1   横綱 千代の富士       1        0
##      5: 1988  1  1   横綱 千代の富士       1        0
##     ---                                              
## 416330: 1923  9  5 十両13       豊錦       1        0
## 416331: 1923  9  5 十両13       豊錦       0        1
## 416332: 1923  9  5 十両13       豊錦       1        0
## 416333: 1923  9  5 十両13       豊錦       1        0
## 416334: 1923  9  5 十両13       豊錦       1        0
```

## 普段の大関の勝率


```r
dat_oozeki = dat_winlose %>% 
  filter(str_detect(V4, "大関")) %>% 
  summarise(NUM = length(WIN_FLG), WIN = sum(WIN_FLG), WIN_RATE = mean(WIN_FLG))
dat_oozeki
```

```
##      NUM   WIN WIN_RATE
## 1: 19354 12347 0.637956
```
普段の大関の勝率は``0.637956`` 

負け越したかどうか. 

```r
dat_oozeki_mod = dat_winlose %>% filter(str_detect(V4,"大関"))

dat_oozeki_mod_year = 
  dat_oozeki_mod %>% 
  setnames(c("EMP", "EMP_YEAR", "MONTH", "CLASS", "NAME", "WIN_FLG", "LOSE_FLG")) %>% 
  mutate(YEAR = EMP + EMP_YEAR) %>% 
  select(YEAR, MONTH, CLASS, NAME, WIN_FLG,LOSE_FLG)

## 負け越したかどうか
dat_oozeki_makekoshi = 
  dat_oozeki_mod_year %>% 
  group_by(YEAR,MONTH,CLASS,NAME) %>% 
  summarise(WIN = sum(WIN_FLG), LOSE=sum(LOSE_FLG)) %>% 
  mutate(MAKEKOSHI_FLG = (WIN<LOSE)) %>% 
  group_by(add=FALSE) %>% 
  arrange(NAME, YEAR,MONTH) 

dat_oozeki_maebasyo_makekoshi = 
  dat_oozeki_makekoshi %>% 
  group_by(NAME) %>% 
  mutate(MAEBASYO_MAKEKOSHI_FLG = c(FALSE, head(MAKEKOSHI_FLG, length(MAKEKOSHI_FLG)-1))) %>% 
  select(YEAR,MONTH,NAME,MAEBASYO_MAKEKOSHI_FLG)
dat_oozeki_maebasyo_makekoshi
```

```
## Source: local data table [1,403 x 4]
## Groups: NAME
## 
##    YEAR MONTH     NAME MAEBASYO_MAKEKOSHI_FLG
## 1  1951     9   三根山                  FALSE
## 2  1952     1   三根山                  FALSE
## 3  1952     3   三根山                  FALSE
## 4  1952     5   三根山                  FALSE
## 5  1952     9   三根山                  FALSE
## 6  1953     1   三根山                   TRUE
## 7  1953     3   三根山                  FALSE
## 8  1953     5   三根山                   TRUE
## 9  1974     1 三重ノ海                  FALSE
## 10 1974     3 三重ノ海                  FALSE
## ..  ...   ...      ...                    ...
```


```r
dat_oozeki_mod_year_day = 
  dat_oozeki_mod_year %>% 
  group_by(YEAR,MONTH,CLASS,NAME) %>% 
  mutate(DAY = 1:length(WIN_FLG))  

## 最終日の結果
dat_oozeki_mod_year_day_lastday_win = 
  dat_oozeki_mod_year_day %>% 
  filter(DAY==15) %>%
  mutate(LASTDAY_WIN_FLG = ifelse(WIN_FLG == 1, 1, 0)) %>% 
  select(YEAR,MONTH,CLASS,NAME,LASTDAY_WIN_FLG)

dat_oozeki_mod_year_day_lastday_win
```

```
## Source: local data table [1,122 x 5]
## Groups: YEAR, MONTH, CLASS, NAME
## 
##    YEAR MONTH    CLASS     NAME LASTDAY_WIN_FLG
## 1  1937     5     大関   前田山               1
## 2  1937     5     大関     鏡岩               0
## 3  1938     1     大関   前田山               0
## 4  1938     1     大関   羽黒山               1
## 5  1938     5     大関   前田山               0
## 6  1939     1     大関 安藝ノ海               0
## 7  1939     1     大関   羽黒山               1
## 8  1939     1 張出大関   前田山               0
## 9  1939     5     大関 安藝ノ海               0
## 10 1939     5     大関   羽黒山               1
## ..  ...   ...      ...      ...             ...
```

```r
dat_win_lose = 
  dat_oozeki_mod_year %>% 
  group_by(YEAR,MONTH, CLASS,NAME) %>% 
  summarise(WIN = sum(WIN_FLG), LOSE = sum(LOSE_FLG))

dat_oozeki_lastday = 
  merge(dat_win_lose, dat_oozeki_mod_year_day_lastday_win, 
      by = c("YEAR", "MONTH", "CLASS", "NAME"))

## 14日目までの成績と, 15日目に勝ったかどうか
dat_oozeki_14day = 
  dat_oozeki_lastday %>%
  mutate(WIN_14 = ifelse(LASTDAY_WIN_FLG == 1, WIN-1, WIN)) %>% 
  mutate(LOSE_14 = ifelse(LASTDAY_WIN_FLG == 0, LOSE-1, LOSE)) %>%
  select(YEAR,MONTH,CLASS,NAME,WIN_14,LOSE_14,LASTDAY_WIN_FLG)

dat_oozeki_14day %>% 
  filter(NAME == "貴ノ浪")
```

```
##     YEAR MONTH    CLASS   NAME WIN_14 LOSE_14 LASTDAY_WIN_FLG
##  1: 1994     3 張出大関 貴ノ浪     11       3               1
##  2: 1994     5     大関 貴ノ浪      9       5               0
##  3: 1994     7     大関 貴ノ浪     11       3               1
##  4: 1994     9     大関 貴ノ浪     12       2               0
##  5: 1994    11     大関 貴ノ浪     11       3               1
##  6: 1995     1     大関 貴ノ浪     11       3               0
##  7: 1995     3     大関 貴ノ浪      8       6               1
##  8: 1995     5     大関 貴ノ浪      6       8               0
##  9: 1995     7     大関 貴ノ浪      9       5               0
## 10: 1995     9     大関 貴ノ浪      7       7               1
## 11: 1995    11     大関 貴ノ浪      9       5               0
## 12: 1996     1     大関 貴ノ浪     13       1               1
## 13: 1996     3     大関 貴ノ浪     11       3               0
## 14: 1996     5     大関 貴ノ浪     12       2               0
## 15: 1996     7     大関 貴ノ浪     12       2               0
## 16: 1996     9     大関 貴ノ浪      9       5               0
## 17: 1996    11     大関 貴ノ浪     10       4               1
## 18: 1997     1     大関 貴ノ浪      6       8               0
## 19: 1997     3     大関 貴ノ浪     10       4               1
## 20: 1997     5     大関 貴ノ浪      9       5               1
## 21: 1997     7     大関 貴ノ浪      8       6               1
## 22: 1997     9     大関 貴ノ浪     11       3               1
## 23: 1997    11     大関 貴ノ浪     13       1               1
## 24: 1998     1     大関 貴ノ浪     10       4               0
## 25: 1998     3     大関 貴ノ浪      8       6               0
## 26: 1998     5     大関 貴ノ浪     10       4               1
## 27: 1998     7     大関 貴ノ浪      9       5               0
## 28: 1998     9     大関 貴ノ浪      9       5               1
## 29: 1998    11     大関 貴ノ浪      8       6               0
## 30: 1999     1     大関 貴ノ浪      6       8               0
## 31: 1999     3     大関 貴ノ浪     12       2               0
## 32: 1999     5     大関 貴ノ浪      9       5               0
## 33: 1999     7     大関 貴ノ浪      8       6               0
## 34: 1999    11     大関 貴ノ浪      6       8               0
## 35: 2000     3     大関 貴ノ浪      7       7               0
## 36: 2000     5     大関 貴ノ浪      6       8               0
##     YEAR MONTH    CLASS   NAME WIN_14 LOSE_14 LASTDAY_WIN_FLG
```

前場所で負け越したかどうかで場合分けして勝率計算します. 

```r
dat_oozeki_14day %>% 
  merge(dat_oozeki_maebasyo_makekoshi, by = c("YEAR", "MONTH", "NAME")) %>% 
  filter(WIN_14 == 7 & LOSE_14 == 7) %>% 
  summarise(LASTDAY_WIN_RATE = mean(LASTDAY_WIN_FLG))
```

```
##    LASTDAY_WIN_RATE
## 1:         0.755814
```

```r
dat_oozeki_14day %>% 
  merge(dat_oozeki_maebasyo_makekoshi, by = c("YEAR", "MONTH", "NAME")) %>% 
  filter(WIN_14 == 7 & LOSE_14 == 7)%>% 
  group_by(MAEBASYO_MAKEKOSHI_FLG) %>% 
  summarise(NUM = n(), WIN = sum(LASTDAY_WIN_FLG),LASTDAY_WIN_RATE = mean(LASTDAY_WIN_FLG))
```

```
## Source: local data table [2 x 4]
## 
##   MAEBASYO_MAKEKOSHI_FLG NUM WIN LASTDAY_WIN_RATE
## 1                  FALSE  71  51        0.7183099
## 2                   TRUE  15  14        0.9333333
```



```r
dat_oozeki_14day %>% 
  merge(dat_oozeki_maebasyo_makekoshi, by = c("YEAR", "MONTH", "NAME")) %>% 
  filter(WIN_14 == 7 & LOSE_14 == 7) %>%  
  filter(MAEBASYO_MAKEKOSHI_FLG == 1)
```

```
##     YEAR MONTH     NAME    CLASS WIN_14 LOSE_14 LASTDAY_WIN_FLG
##  1: 1948     9   汐ノ海 張出大関      7       7               1
##  2: 1956     5     松登 張出大関      7       7               1
##  3: 1961    11     栃光 張出大関      7       7               1
##  4: 1963     9   北葉山 張出大関      7       7               1
##  5: 1963    11     豊山 張出大関      7       7               1
##  6: 1964     1   北葉山     大関      7       7               1
##  7: 1965     5   玉乃島     大関      7       7               1
##  8: 1975     7 三重ノ海 張出大関      7       7               1
##  9: 1986     7     朝潮 張出大関      7       7               1
## 10: 2000     3   貴ノ浪     大関      7       7               0
## 11: 2001     3     出島     大関      7       7               1
## 12: 2003     5   武双山     大関      7       7               1
## 13: 2006     3     魁皇     大関      7       7               1
## 14: 2009     5 千代大海     大関      7       7               1
## 15: 2013     5   琴欧洲     大関      7       7               1
##     MAEBASYO_MAKEKOSHI_FLG
##  1:                   TRUE
##  2:                   TRUE
##  3:                   TRUE
##  4:                   TRUE
##  5:                   TRUE
##  6:                   TRUE
##  7:                   TRUE
##  8:                   TRUE
##  9:                   TRUE
## 10:                   TRUE
## 11:                   TRUE
## 12:                   TRUE
## 13:                   TRUE
## 14:                   TRUE
## 15:                   TRUE
```



だめ. 前場所でも大関, という条件が抜けているからやり直し





