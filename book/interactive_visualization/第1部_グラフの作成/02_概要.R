# ***********************************************************************************************
# Title   : Rによるインタラクティブなデータビジュアライゼーション
# Chapter : 1 グラフの作成
# Theme   : 08 3次元グラフ
# Date    : 2023/01/30
# Page    : P16 - P32
# URL     : https://plotly-r.com/
#         : https://github.com/t-kosshi/r_plotly_and_shiny_book_ja
# ***********************************************************************************************


# ＜概要＞
# - Rにおける{plotly}の活用方法は、plot_ly()とggplotly()の2つが存在する
#   --- いずれもGrammer of Graphicsを実践していて、パイプ演算子での操作が可能
#   --- どちらにも長所/短所があり、それらを使い分けることが重要


# ＜目次＞
# 0 準備
# 1 plot_ly()によるプロット
# 2 plot_ly()による系列色の指定
# 3 関数型プログラミングとしてのplot_ly()
# 4 ploly.jsの紹介
# 5 ggplotlyの紹介


# 0 準備 ---------------------------------------------------------------------------

# ライブラリ
library(tidyverse)
library(plotly)
library(Hmisc)


# データロード
data(diamonds, package = "ggplot2")

# データ確認
diamonds %>% print()
diamonds %>% glimpse()


# 1 plot_ly()によるプロット -----------------------------------------------------------

# ＜ポイント＞
# - plot_ly()は｢引数に設定するデータの種類｣や｢引数の設定方法｣によって出力されるグラフの種類が自動的に決まる


# ヒストグラム
# --- xのみをカテゴリカル変数で指定した場合
plot_ly(diamonds, x = ~cut)

# ヒートマップ
# --- xとyの両方をカテゴリカル変数で指定した場合
# --- カウント数に応じたヒートマップ
plot_ly(diamonds, x = ~cut, y = ~clarity)

# 棒グラフ
# --- xのみをカテゴリカル変数で指定、カテゴリカル変数でカラーを指定した場合
plot_ly(diamonds, x = ~cut, color = ~clarity, colors = "Accent")


# 2 plot_ly()による系列色の指定 -------------------------------------------------------

# プロット作成(色指定)
# --- 直接色を指定することはできない（指定と異なる色になってしまう）
plot_ly(diamonds, x = ~cut, color = "black")

# プロット作成(色指定)
# --- I()で色を指定すると、意図どおりの色となる
plot_ly(diamonds, x = ~cut, color = I("red"), stroke = I("black"), span = I(2))


# 3 関数型プログラミングとしてのplot_ly() -----------------------------------------------

# ＜ポイント＞
# - Rの{plotly}はGrammar of Graphicsに従って関数型プログラミングの思想で実装されている
#   --- ggplot() + ggplotly()でなくてもパイプ演算子による記述ができる


# ネストした記法
layout(
  plot_ly(diamonds, x = ~cut),
  title = "My beatiful histogram"
)

# パイプ記法
diamonds %>%
  plot_ly(x = ~cut) %>%
  layout(title = "My beatiful histogram")

# ヒストグラム作成
# --- add_histogram()を直接指定
diamonds %>%
  plot_ly() %>%
  add_histogram(x = ~cut)

# ヒストグラム作成
# --- カウント計算とadd_bars()
diamonds %>%
  count(cut) %>%
  plot_ly() %>%
  add_bars(x = ~cut, y = ~n)

# ヒストグラム作成
# --- plot_lyのパイプラインを活用
diamonds %>%
  plot_ly(x = ~cut) %>%
  add_histogram() %>%
  group_by(cut) %>%
  summarise(n = n()) %>%
  add_text(text = ~scales::comma(n), y = ~n,
           textposition = "top middle",
           cliponaxis = FALSE)

# プロットデータの確認
# --- plotly_data()を使うとグラフに使用するデータを確認することができる（デバッグ用）
diamonds %>%
  plot_ly(x = ~cut) %>%
  add_histogram() %>%
  group_by(cut) %>%
  summarise(n = n()) %>%
  plotly_data()


# 4 ploly.jsの紹介 ----------------------------------------------------------

# ＜ポイント＞
# - plotlyがどのようにして基礎となるplotly.jsの図を生成するかを学ぶことは意義深い
# - plotlyはJSON使用となっており、変換することで確認することができる


# JSON形式でplotlyを確認
p <- diamonds %>% plot_ly(x = ~cut, color = ~clarity, colors = "Accent")
plotly_json(p)

# use plotly_build() to get at the plotly.js definition
# behind *any* plotly object
b <- plotly_build(p)

# Confirm there 8 traces
b$x$data %>% length()
#> [1] 8

# Extract the `name` of each trace. plotly.js uses `name` to
# populate legend entries and tooltips
b$x$data %>% purrr::map_chr( "name")
#> [1] "IF" "VVS1" "VVS2" "VS1" "VS2" "SI1" "SI2" "I1"

# Every trace has a type of histogram
b$x$data %>% purrr::map_chr( "type") %>% unique()
#> [1] "histogram"


# 5 ggplotlyの紹介 ----------------------------------------------------------

# ＜ポイント＞
# - plotly::ggplotly()はggplot2をplotlyに変換する機能を持つ
#   --- ggplot2のきめ細やかなプロットにplotlyを適用したいケースに強い
#   --- {ggplot2}だけでなく、{ggforce}{naniar}{GGally}などにも対応している


# 図2.8 六角ビンの散布図 -----------------------

# 散布図
# --- 六角ビンを使用するとgeom_point()よりも高速
# --- ヒートマップで表示される
p <-
  diamonds %>%
    ggplot(aes(x = log(carat), y = log(price))) +
    stat_binhex(bins = 100)

# plotlyに変換
ggplotly(p)


# 図2.9 頻度ライン ---------------------------

# 頻度ライン
p <-
  diamonds %>%
    ggplot(aes(x = log(price), color = clarity)) +
    geom_freqpoly()

# plotlyに変換
ggplotly(p)


# 図2.10 頻度ラインのファセット表示 ---------------

# 頻度ライン
# --- ファセット表示
p <-
  diamonds %>%
    ggplot(aes(x = log(price), color = clarity)) +
    geom_freqpoly(stat = "density") +
    facet_wrap(~cut)

# plotlyに変換
ggplotly(p)


# 図2.11 ジッタープロット ---------------

p <-
  diamonds %>%
    ggplot(aes(x=clarity, y=log(price), color=clarity)) +
      ggforce::geom_sina(alpha = 0.1) +
      stat_summary(fun.data = "mean_cl_boot", color = "black") +
      facet_wrap(~cut)

# plotlyに変換
# --- たくさんのプロットの場合はplotly::toWebGL()を使う
ggplotly(p) %>% toWebGL()


# 図2.12 ジッタープロット ---------------

# モデル構築
# --- 価格とカラットの関係
m <- lm(log(price) ~ log(carat), data = diamonds)

# データ加工
# --- モデルの残差を列に追加
diamonds <- diamonds %>% modelr::add_residuals(m)


p <-
  diamonds %>%
    ggplot(aes(x = clarity, y = resid, color = clarity)) +
      ggforce::geom_sina(alpha = 0.1) +
      stat_summary(fun.data = "mean_cl_boot", color = "black") +
      facet_wrap(~cut)

# plotlyに変換
# --- たくさんのプロットの場合はplotly::toWebGL()を使う
toWebGL(ggplotly(p))


# 図2.13 回帰係数のプロット ---------------

# モデル構築
m <- lm(log(price) ~ log(carat) + cut, data = diamonds)

# 回帰係数のプロット
gg <- GGally::ggcoef(m)

# plotlyに変換
ggplotly(gg, dynamicTicks = TRUE)


# 図2.14 回帰係数のプロット ---------------

library(naniar)
# fake some missing data
diamonds_mod <-
  diamonds %>%
    mutate(price_miss = ifelse(diamonds$depth>60, diamonds$price, NA))

p <-
  diamonds_mod %>%
    ggplot(aes(x = clarity, y = log(price_miss))) +
    naniar::geom_miss_point(alpha = 0.1) +
    stat_summary(fun.data = "mean_cl_boot", colour = "black") +
    facet_wrap(~cut)

# plotlyに変換
# --- たくさんのプロットの場合はplotly::toWebGL()を使う
toWebGL(ggplotly(p))
