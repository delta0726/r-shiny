# ***********************************************************************************************
# Title   : Rによるインタラクティブなデータビジュアライゼーション
# Chapter : 6 その他のトピック
# Theme   : 26 モードバーの制御
# Date    : 2023/02/02
# Page    : P267 - P270
# URL     : https://plotly-r.com/
#         : https://github.com/t-kosshi/r_plotly_and_shiny_book_ja
# ***********************************************************************************************


# ＜概要＞
# - モードバーの制御についてできることを確認する


# ＜目次＞
# 0 準備
# 1 モードバーのコントロール
# 2 プロットをダウンロードする際のコントロール


# 0 準備 ---------------------------------------------------------------------------

# ライブラリ
library(plotly)


# 1 モードバーのコントロール ---------------------------------------------------------

# モードバーを表示
# --- 右上にカーソールを当てると表示
plot_ly()

# モードバーを削除
plot_ly() %>% config(displayModeBar = FALSE)

# plotlyのロゴ削除
plot_ly() %>% config(displaylogo = FALSE)

# 指定したボタンの削除
plot_ly() %>% config(modeBarButtonsToRemove = c("zoomIn2d", "zoomOut2d"))

# 指定したボタンのみ表示
plot_ly() %>% config(modeBarButtons = list(list("zoomIn2d"), list("zoomOut2d")))


# 2 プロットをダウンロードする際のコントロール -----------------------------------------

plot_ly() %>%
  config(
    toImageButtonOptions = list(
      format = "svg",
      width = 200,
      height = 100
    )
  )