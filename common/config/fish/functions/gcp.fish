function gcp -d "Pick commits with fzf and cherry-pick"
    set range $argv
    if test (count $range) -eq 0
        set range --all
    end

    set selection (git log --oneline --decorate $range | \
        fzf --multi --reverse \
            --preview 'git show --color=always {1}' \
            --preview-window 'right:60%')

    if test -z "$selection"
        return
    end

    set hashes (printf '%s\n' $selection | awk '{print $1}')
    git cherry-pick $hashes
end
