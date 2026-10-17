local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

local target = wezterm.target_triple
local is_mac = target:find("darwin") ~= nil
local is_linux = target:find("linux") ~= nil

-- フォント
if is_linux then
    config.font = wezterm.font_with_fallback({ "Noto Sans Mono" })
else
    config.font = wezterm.font_with_fallback({ "FiraCode Nerd Font", "PlemolJP Console NF" })
end
config.font_size = 16.0

-- 配色 (iceberg風、旧alacrittyから移植)
config.colors = {
    foreground = "#d2d4de",
    background = "#161821",
    ansi = {
        "#161821",
        "#e27878",
        "#b4be82",
        "#e2a478",
        "#84a0c6",
        "#a093c7",
        "#89b8c2",
        "#c6c8d1",
    },
    brights = {
        "#6b7089",
        "#e98989",
        "#c0ca8e",
        "#e9b189",
        "#91acd1",
        "#ada0d3",
        "#95c4ce",
        "#d2d4de",
    },
    -- フッダー (タブバー) を一段明るくしてピンク寄りに
    tab_bar = {
        background = "#2a1f33",
        active_tab = { bg_color = "#f7a8b8", fg_color = "#1f1426", intensity = "Bold" },
        inactive_tab = { bg_color = "#2a1f33", fg_color = "#c8b6d4" },
        inactive_tab_hover = { bg_color = "#3a2b46", fg_color = "#f7a8b8", italic = true },
        new_tab = { bg_color = "#2a1f33", fg_color = "#f7a8b8" },
        new_tab_hover = { bg_color = "#3a2b46", fg_color = "#ffd1dc" },
    },
}

-- ウィンドウ
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.automatically_reload_config = true
config.window_background_opacity = 0.85
-- nvim 等が同期出力 (DECSET 2026) を使えるよう wezterm 用 terminfo を要求
-- terminfo は client/init/wezterm-terminfo.sh で入れる (macOS には無い)
config.term = "wezterm"
if is_mac then
    config.macos_window_background_blur = 20
end

-- ステータスバーをフッダーとして使う
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.status_update_interval = 1000

-- devhost への接続 (Host 名は ~/.ssh/config のもの)
-- SSHMUX: devhost の mux サーバーに繋ぐ。切れてもペインは devhost に残り、attach し直せる。
--         devhost に client と同じビルドの wezterm が要る (wezterm-match で確かめる)
-- SSH:    mux を使わない予備 (ビルドが揃わないとき用)。cwd は OSC 7 から env -C で引き継ぐ
local dev_hosts = { "arch" }
config.ssh_domains = {}
for _, host in ipairs(dev_hosts) do
    table.insert(config.ssh_domains, {
        name = "SSHMUX:" .. host,
        remote_address = host,
        multiplexing = "WezTerm",
        remote_wezterm_path = "~/.local/bin/wezterm-mux",
    })
    table.insert(config.ssh_domains, {
        name = "SSH:" .. host,
        remote_address = host,
        multiplexing = "None",
        assume_shell = "Posix",
        default_prog = { "fish", "-l" },
    })
end

-- アプリレベルのキー修飾子 (mac=CMD, linux=CTRL)
local app_mod = is_mac and "CMD" or "CTRL"

-- リーダーキー
config.leader = {
    key = "t",
    mods = "CTRL",
    timeout_milliseconds = 1000,
}

-- ステータスバーの左に 2 秒ほど出すメッセージ (window_id → { text, expires })。
-- macOS の通知 (toast_notification) は、署名の無い nightly では許可されず表示されない
local flash = {}
local render_left_status -- 色の定義の後、update-status の手前で中身を入れる
local function flash_message(window, text)
    flash[window:window_id()] = { text = text, expires = os.time() + 2 }
    render_left_status(window)
end

config.keys = {
    -- フォントサイズ
    { key = "=", mods = app_mod, action = act.IncreaseFontSize },
    { key = "+", mods = app_mod, action = act.IncreaseFontSize },
    { key = "0", mods = app_mod, action = act.ResetFontSize },
    { key = "-", mods = app_mod, action = act.DecreaseFontSize },

    -- 検索 / コピーモード
    { key = "f", mods = app_mod, action = act.Search("CurrentSelectionOrEmptyString") },
    { key = "F", mods = "CTRL",  action = act.Search("CurrentSelectionOrEmptyString") },
    {
        key = "X",
        mods = "CTRL",
        action = act.Multiple({
            act.ActivateCopyMode,
            act.CopyMode("MoveToViewportMiddle"),
        }),
    },
    -- 直前コマンド出力をクリップボードへ (要 OSC 133 シェル統合)
    -- SSHMUX のペインでは使えない: zone は devhost の mux サーバーにあり、mux の通信で client に渡らない
    {
        key = "Y",
        mods = "CTRL",
        action = wezterm.action_callback(function(window, pane)
            local zones = pane:get_semantic_zones("Output")
            if #zones == 0 then
                flash_message(window, "No output zones (SSHMUX panes have none)")
                return
            end
            local last = zones[#zones]
            local text = pane:get_text_from_semantic_zone(last)
            window:copy_to_clipboard(text)
            flash_message(window, "Copied last output")
        end),
    },

    -- スクロール
    { key = "PageUp",    mods = "SHIFT",  action = act.ScrollByPage(-1) },
    { key = "PageDown",  mods = "SHIFT",  action = act.ScrollByPage(1) },
    { key = "UpArrow",   mods = app_mod,  action = act.ScrollByLine(-1) },
    { key = "DownArrow", mods = app_mod,  action = act.ScrollByLine(1) },
    { key = "Home",      mods = app_mod,  action = act.ScrollToTop },
    { key = "End",       mods = app_mod,  action = act.ScrollToBottom },

    -- タブ
    { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
    { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
    { key = "x", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },
    {
        key = ",",
        mods = "LEADER",
        action = act.PromptInputLine({
            description = "Rename Tab",
            action = wezterm.action_callback(function(window, _, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        }),
    },

    -- ペイン分割
    { key = "v", mods = "LEADER",       action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "s", mods = "LEADER",       action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

    -- ペイン移動 (リーダー経由)
    { key = "h", mods = "LEADER",       action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = "LEADER",       action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "LEADER",       action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = "LEADER",       action = act.ActivatePaneDirection("Right") },

    -- ペイン移動 (Vim風即時)
    { key = "h", mods = "ALT",          action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = "ALT",          action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "ALT",          action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = "ALT",          action = act.ActivatePaneDirection("Right") },

    -- ペイン入れ替え (ローテーション)
    { key = "{", mods = "LEADER|SHIFT", action = act.RotatePanes("CounterClockwise") },
    { key = "}", mods = "LEADER|SHIFT", action = act.RotatePanes("Clockwise") },

    -- ペインズーム切替
    { key = "z", mods = "LEADER",       action = act.TogglePaneZoomState },

    -- ランチャー
    { key = "m", mods = "LEADER",       action = act.ShowLauncher },
}

-- devhost の mux に attach (前に開いていたタブが戻る。無ければ新しいタブ) / 今のドメインから detach
table.insert(config.keys, { key = "a", mods = "LEADER", action = act.AttachDomain("SSHMUX:" .. dev_hosts[1]) })
table.insert(config.keys, { key = "d", mods = "LEADER", action = act.DetachDomain("CurrentPaneDomain") })

-- ステータスバー: LEADER状態 (左) / IP・バッテリー・ホスト・時刻 (右)
local cache = {
    lan_ip = { value = "", fetched_at = 0, ttl = 30 },
    wan_ip = { value = "", fetched_at = 0, ttl = 300 },
    battery = { value = "", fetched_at = 0, ttl = 30 },
}

local function cached(key, fetch)
    local now = os.time()
    if (now - cache[key].fetched_at) >= cache[key].ttl then
        local ok, val = pcall(fetch)
        if ok and val and val ~= "" then
            cache[key].value = val
        end
        cache[key].fetched_at = now
    end
    return cache[key].value
end

local function trim(s)
    return (s:gsub("%s+$", ""))
end

local function get_lan_ip()
    return cached("lan_ip", function()
        if is_mac then
            for _, iface in ipairs({ "en0", "en1" }) do
                local ok, stdout = wezterm.run_child_process({ "ipconfig", "getifaddr", iface })
                if ok and stdout and stdout ~= "" then
                    return trim(stdout)
                end
            end
        elseif is_linux then
            local ok, stdout = wezterm.run_child_process({
                "sh",
                "-c",
                "hostname -I 2>/dev/null | awk '{print $1}'",
            })
            if ok and stdout and stdout ~= "" then
                return trim(stdout)
            end
        end
        return "?"
    end)
end

local function get_wan_ip()
    return cached("wan_ip", function()
        local ok, stdout = wezterm.run_child_process({
            "curl",
            "-4",
            "-s",
            "--max-time",
            "2",
            "https://ifconfig.me",
        })
        if ok and stdout and stdout ~= "" then
            return trim(stdout)
        end
        return "?"
    end)
end

local function get_battery()
    return cached("battery", function()
        local infos = wezterm.battery_info()
        if not infos or #infos == 0 then
            return ""
        end
        local b = infos[1]
        local pct = math.floor(b.state_of_charge * 100 + 0.5)
        local icon = "🔋"
        if b.state == "Charging" then
            icon = "⚡"
        elseif b.state == "Full" then
            icon = "🔌"
        end
        return string.format("%s %d%%", icon, pct)
    end)
end

-- フッダー配色 (pastel pop)
local pink = "#f7a8b8"
local mint = "#a8e6cf"
local peach = "#ffd6a5"
local lilac = "#caa6f7"
local cream = "#fff1c1"
local heart = " ♥ "

-- SSH 先の区別: SSH ドメインのペインか、前面で ssh が動いていたら、接続先ごとの色をタブ・フッダー・背景に出す
-- キーは ~/.ssh/config の Host 名。載っていない接続先は default
local ssh_styles = {
    arch = { color = mint, background = "#13201b" },
    default = { color = lilac, background = "#1c1726" },
}

-- 値を取る ssh のオプション (この次の引数は接続先ではない)
local ssh_opts_with_arg = {}
for c in ("BbcDEeFIiJLlmOopQRSWw"):gmatch(".") do
    ssh_opts_with_arg["-" .. c] = true
end

-- ssh の argv から接続先 (user@ と :port を除いた Host 名) を取り出す
local function ssh_host_from_argv(argv)
    local i = 2
    while i <= #argv do
        local a = argv[i]
        if ssh_opts_with_arg[a] then
            i = i + 2
        elseif a:sub(1, 1) == "-" then
            i = i + 1
        else
            a = a:gsub("^ssh://", "")
            a = a:gsub("^.*@", "")
            a = a:gsub(":%d+$", "")
            return a
        end
    end
    return nil
end

-- ペインの接続先: SSH ドメイン (SSHMUX:arch / SSH:arch) ならその Host 名、
-- ローカルなら前面で動いている ssh の接続先 (どちらでもなければ nil)
local function ssh_host(pane)
    if not pane then
        return nil
    end
    -- detach した後などに、もう mux に無いペインで呼ばれると例外になる
    local ok, domain = pcall(pane.get_domain_name, pane)
    if not ok then
        return nil
    end
    local host = domain and domain:match("^SSHMUX:(.+)") or domain and domain:match("^SSH:(.+)")
    if host then
        return host
    end
    local info_ok, info = pcall(pane.get_foreground_process_info, pane)
    if not info_ok or not info or not info.argv or not info.executable then
        return nil
    end
    if info.executable:match("[^/]+$") ~= "ssh" then
        return nil
    end
    return ssh_host_from_argv(info.argv)
end

local function ssh_style(host)
    return ssh_styles[host] or ssh_styles.default
end

-- ペインのディレクトリ (OSC 7 から。ホームは ~ に縮める)
local function pane_cwd(pane)
    local url = pane:get_current_working_dir()
    if not url or not url.file_path then
        return ""
    end
    return (url.file_path:gsub("(.)/$", "%1"):gsub("^/home/[^/]+", "~"):gsub("^/Users/[^/]+", "~"))
end

-- ペインの一覧: 全タブのペインを 接続先・ディレクトリ・タイトル でファジー検索して移る
table.insert(config.keys, {
    key = "w",
    mods = "LEADER",
    action = wezterm.action_callback(function(window, pane)
        local choices = {}
        for _, mux_window in ipairs(wezterm.mux.all_windows()) do
            for _, t in ipairs(mux_window:tabs_with_info()) do
                for _, p in ipairs(t.tab:panes_with_info()) do
                    table.insert(choices, {
                        id = tostring(p.pane:pane_id()),
                        label = string.format(
                            "%d: %-7s %-32s %s",
                            t.index + 1,
                            ssh_host(p.pane) or "local",
                            pane_cwd(p.pane),
                            p.pane:get_title()
                        ),
                    })
                end
            end
        end
        window:perform_action(
            act.InputSelector({
                title = "Panes",
                fuzzy = true,
                choices = choices,
                action = wezterm.action_callback(function(_, _, id)
                    local target = id and wezterm.mux.get_pane(tonumber(id))
                    if target then
                        target:activate()
                    end
                end),
            }),
            pane
        )
    end),
})

-- タブ: SSH 中のタブだけ接続先の色にして、タイトルの頭に接続先を出す (それ以外は既定の表示)
wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
    local host = ssh_host(wezterm.mux.get_pane(tab.active_pane.pane_id))
    if not host then
        return nil
    end
    local style = ssh_style(host)
    local title = tab.tab_title ~= "" and tab.tab_title or tab.active_pane.title
    local text = wezterm.truncate_right(string.format(" %d: [%s] %s ", tab.tab_index + 1, host, title), max_width)
    if tab.is_active then
        return {
            { Background = { Color = style.color } },
            { Foreground = { Color = "#1f1426" } },
            { Attribute = { Intensity = "Bold" } },
            { Text = text },
        }
    end
    return {
        { Background = { Color = config.colors.tab_bar.background } },
        { Foreground = { Color = style.color } },
        { Text = text },
    }
end)

-- 背景: アクティブなペインが SSH 中なら接続先の色に寄せる (変わった時だけ上書きする)
local function apply_ssh_background(window, host)
    local overrides = window:get_config_overrides() or {}
    local want = host and ssh_style(host).background or nil
    local current = overrides.colors and overrides.colors.background or nil
    if want == current then
        return
    end
    if want then
        local colors = {}
        for k, v in pairs(config.colors) do
            colors[k] = v
        end
        colors.background = want
        overrides.colors = colors
    else
        overrides.colors = nil
    end
    window:set_config_overrides(overrides)
end

-- 左: LEADER 押下中はその表示、それ以外は flash_message のメッセージ (期限切れなら空)
render_left_status = function(window)
    if window:leader_is_active() then
        window:set_left_status(wezterm.format({
            { Background = { Color = pink } },
            { Foreground = { Color = "#1f1426" } },
            { Attribute = { Intensity = "Bold" } },
            { Text = " ♥ LEADER ♥ " },
            "ResetAttributes",
            { Text = " " },
        }))
        return
    end
    local id = window:window_id()
    local f = flash[id]
    if f and os.time() <= f.expires then
        window:set_left_status(wezterm.format({
            { Foreground = { Color = cream } },
            { Text = " " .. f.text .. " " },
        }))
        return
    end
    flash[id] = nil
    window:set_left_status("")
end

wezterm.on("update-status", function(window, pane)
    local host = ssh_host(pane)
    apply_ssh_background(window, host)

    render_left_status(window)

    -- 右: 各セクションを別カラー、間に ♥ を挟んで明るくポップに
    local segs = {}
    local function push(color, text)
        if text and text ~= "" then
            table.insert(segs, { color = color, text = text })
        end
    end

    push(mint, get_lan_ip() .. " : " .. get_wan_ip())
    push(peach, get_battery())
    if host then
        push(ssh_style(host).color, "⇄ " .. host)
    else
        push(lilac, wezterm.hostname())
    end
    push(cream, wezterm.strftime("%Y-%m-%d %H:%M"))

    local out = { { Text = " " } }
    for i, s in ipairs(segs) do
        if i > 1 then
            table.insert(out, { Foreground = { Color = pink } })
            table.insert(out, { Text = heart })
        end
        table.insert(out, { Foreground = { Color = s.color } })
        table.insert(out, { Text = s.text })
    end
    table.insert(out, { Text = " " })
    window:set_right_status(wezterm.format(out))
end)

return config
