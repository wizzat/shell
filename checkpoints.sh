export CKDIR=${CKDIR-~/.ck}
export CKDEFAULT_TAG=${CKDEFAULT_TAG-default}
export CKBOUNCE_TAG=${CKBOUNCE_TAG-bounce}
mkdir -p $CKDIR


function ck {
    local TAG=${1-$CKDEFAULT_TAG}
    local TAG_CONTENTS=${2-"$PWD"}
    

    if [ -d "$TAG_CONTENTS" ]; then
        TAG_CONTENTS=`cd "$TAG_CONTENTS" && echo "$PWD"`;
        echo "$TAG_CONTENTS" > "$CKDIR/$TAG"
        echo "Checkpoint ($TAG) = $TAG_CONTENTS"
        return 0
    else
        echo "Unable to find directory $TAG_CONTENTS";
        return 1
    fi
}

function gock {
    local TAG=${1-$CKDEFAULT_TAG}
    local FILE_NAME="$CKDIR/$TAG"

    if [ ! -e "$FILE_NAME" ]; then
        if [ "$TAG" == $CKDEFAULT_TAG ]; then
            echo "
checkpoints.sh: A series of shell functions which allow you to "tag" certain directories and return to them later.
Example Usages:
    $ ck shell
    Checkpoint (shell) = /home/wizzat/work/shell

    $ ckck
    bounce               = /home/wizzat
    default              = /home/wizzat/work/fictional_company/my_current_project
    proj                 = /home/wizzat/work/fictional_company/my_current_project
    scripts              = /home/wizzat/work/fictional_company/ops/scripts
    shell                = /home/wizzat/work/shell

    $ cd && pwd
    /home/wizzat

    $ gock shell
    Currently in /home/wizzat/work/shell

    $ gock proj
    Checkpoint (bounce) = /home/wizzat/work/shell
    Currently in /home/wizzat/work/fictional_company/my_current_project

    $ delck proj
    $ ..to work
    Currently in /home/wizzat/work
            "
        else
            echo $TAG does not exist
        fi
        return 1
    fi

    local TO_DIR=`cat $FILE_NAME`
    if [ "$TO_DIR" != "$PWD" ]; then
        [ "$CKBOUNCE_TAG" ] && ck $CKBOUNCE_TAG
        cd "$TO_DIR"
        echo "Currently in $PWD"
    else
        echo "Currently in $PWD"
    fi

    return 0
}

function ckck {
    (
    printf "Matching checkpoints:\n"
    shopt -s nullglob # Executes in a subshell because of this
    for tag in $CKDIR/*$1*; do
        printf "%-20s = %s\n" `basename $tag` `cat $tag`
    done
    return 0
    )
}

function delck {
    local TAG=$1
    if [ "$TAG" ]; then
        rm -f $CKDIR/$TAG
        return 0
    else
        echo delck requires a tag to delete
        return 1
    fi
}

function ..() {
    ..to $@
}
function ..to() {
    local ORIGDIR=$PWD
    local OLDDIR=$PWD
    local TARGET=$1

    if [ -z "$TARGET" ]
    then
        cd ..
        return 0
    fi

    while [ 1 ]
    do
        OLDDIR=$PWD
        cd ..
        if [ `basename "$PWD"` == "$TARGET" ]; then
            echo "Currently in $PWD"
            return 0
        elif [ "$OLDDIR" == "$PWD" ]; then
            cd $ORIGDIR
            echo "Unable to find parent directory '$TARGET' in $PWD"
            return 1
        fi
    done
}

function _.._completion {
    local cur
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=($(compgen -W "$(pwd | sed -e 's/\// /g')" -- ${cur}))
    return 0
}

function _ck_completion {
    local cur
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=($(compgen -W "$(ls $CKDIR)" -- ${cur}))
    return 0
}

complete -F _.._completion ..to
complete -F _.._completion ..
complete -F _ck_completion delck
complete -F _ck_completion ckck
complete -F _ck_completion gock
