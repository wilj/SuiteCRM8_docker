DEFAULTCOMMENT="wip skip ci"
g.commit() {
    local COMMENT
    if [ -d $1 ]; then
        COMMENT="$DEFAULTCOMMENT"
    else
        COMMENT="$*"
    fi
    
    echo "Committing ${GITPOD_REPO_ROOT} with comment '$COMMENT'"
    
    ( cd ${GITPOD_REPO_ROOT} \
        && git add . \
        && git commit -m"$COMMENT" \
        && git push )
}

g.commit-skip-ci() {
    local COMMENT
    if [ -d $1 ]; then
        COMMENT="$DEFAULTCOMMENT"
    else
        COMMENT="$* skip ci"
    fi
    gc $COMMENT
}

gc() {
    g.commit $*
}

gcs() {
    g.commit-skip-ci $*
}

g.cd-gitpod-repo-root() {
    cd $GITPOD_REPO_ROOT/
}
g.cd() {
    g.cd-gitpod-repo-root
}

g.rebash() {
    g.cd
    set -a
    . .gitpod/gitpod.bashrc 
    set +a
}

. /usr/share/doc/fzf/examples/key-bindings.bash