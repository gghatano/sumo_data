相撲の勝敗データを作る
===



## 内容

htmls/にhtmlが全部あります


## 成果物

勝ち負け同数の状態で迎えた最終日の勝敗を集計します. 

これは, 別に力士ID必要ありませんので, データがグチャグチャでも出来ます. 

## やること

```{sh}
for file in `ls htmls`
do
echo $file
./getWinLoseLine.tmp.bash "htmls/"$file
done
```
## 問題


- 部屋名+年齢に謎スペース問題

H18-3.htmlの白鳳とか

- データ変形... 


目標の形

2013,4,横綱,白鳳,鶴竜,W
2013,4,横綱,白鳳,鶴竜,W
2013,4,横綱,白鳳,鶴竜,W
2013,4,横綱,白鳳,鶴竜,W
2013,4,横綱,白鳳,鶴竜,W
2013,4,横綱,白鳳,鶴竜,W

- 部屋データが無い場合の処理

十両だけっぽいからなんとかなる





- 略称問題 ... 

千代大海 -> 千大海 
日出ノ国 -> 日出国

のような略称は? 

