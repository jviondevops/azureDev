while IFS= read -r line; do
    echo "Text read from file: $line"
    terraform state rm $line
done < "$1"
