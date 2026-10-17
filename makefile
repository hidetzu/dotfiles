# ROLE: client / devhost（空白区切りで複数可）。省略時は Mac が "client"、Linux が "devhost"。
ROLE ?=

.PHONY: deploy check init list

deploy: ## 設定ファイルの symlink を張る
	@bash lib/dotfiles.sh deploy $(ROLE)

check: ## symlink が正しく張られているか確かめる
	@bash lib/dotfiles.sh check $(ROLE)

init: ## パッケージやツールを入れる
	@bash lib/dotfiles.sh init $(ROLE)

list: ## 張る symlink の一覧
	@bash lib/dotfiles.sh list $(ROLE)
