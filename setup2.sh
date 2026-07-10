csld() {
    curl -L -o source.pdf $1
    bash pdftoSlides.sh source.pdf notes $2 $3
}

ptg() {
    sudo git add .
    sudo git commit -m "$1"
    sudo git push origin main
}

getNumber() {
    local str="$1"
    local num=""

    for ((i=0; i<${#str}; i++)); do
        ch="${str:i:1}"
        [[ "$ch" =~ [0-9] ]] || break
        num+="$ch"
    done

    echo "$num"
}

getFolderName() {
    local baseDir="$1"
    local topic="$2"

    # User already gave number (e.g. 30PeriodicFunctions)
    if [[ "$topic" =~ ^[0-9]+ ]]; then
        echo "$topic"
        return
    fi

    # Check if topic already exists
    for dir in "$baseDir"/*; do
        [[ -d "$dir" ]] || continue

        folder=$(basename "$dir")
        number=$(getNumber "$folder")
        name="${folder#$number}"

        if [[ "$name" == "$topic" ]]; then
            echo "$folder"
            return
        fi
    done

    # Find last topic number
    last=0
    for dir in "$baseDir"/*; do
        [[ -d "$dir" ]] || continue

        folder=$(basename "$dir")
        number=$(getNumber "$folder")

        [[ -z "$number" ]] && continue

        (( number > last )) && last=$number
    done

    echo "$((last+1))$topic"
}

mnts() {

    folderName=$(getFolderName notes "$3")

    mkdir -p "notes/$folderName"

    for ((i=$1; i<=$2; i++)); do
        for ext in png jpg jpeg; do
            if [[ -f "notes/slide$i.$ext" ]]; then
                mv -n "notes/slide$i.$ext" "notes/$folderName/"
                break
            fi
        done
    done
}

msld() {

    folderName=$(getFolderName fundamentalQuestions "$3")

    mkdir -p "fundamentalQuestions/$folderName"

    for ((i=$1; i<=$2; i++)); do
        for ext in png jpg jpeg; do
            if [[ -f "notes/slide$i.$ext" ]]; then
                mv -n "notes/slide$i.$ext" "fundamentalQuestions/$folderName/"
                break
            fi
        done
    done
}

pre(){
    mkdir $1;
    cp pdftoSlides.sh setup.sh $1;
}