-- client の WezTerm が SSHMUX ドメインで繋いだときの、devhost 側の mux サーバーの設定。
-- wezterm-mux（client の remote_wezterm_path）が WEZTERM_CONFIG_FILE でこのファイルを読ませる。
-- devhost で GUI の WezTerm を使うときの ~/.config/wezterm とは別にしてある。
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ログインシェルは bash なので、ペインは fish で開く
config.default_prog = { "fish", "-l" }

-- nvim が同期出力 (DECSET 2026) を使えるように。terminfo は ncurses に入っているもの (Arch の /usr/share/terminfo) を使う
config.term = "wezterm"

return config
