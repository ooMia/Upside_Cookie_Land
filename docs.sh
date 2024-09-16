#!/bin/bash

# Script Name: docs.sh
# Description: This script is a placeholder for future documentation tasks.
# Author: ooMia
# Date: 2024-09-16

# Function to display help
function display_help() {
    echo "Usage: $0 [option...]"
    echo
    echo "   -h, --help       Show this help message"
    echo
}

# Main script logic
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    display_help
    exit 0
fi

# 0. forge build doc
forge doc -b

# 1. docs/book 디렉토리를 docs 디렉토리 밖으로 이동
mv docs/book ../book_backup

# 2. 기존 docs 디렉토리 삭제
rm -rf docs

# 3. book_backup 디렉토리를 docs로 이름 변경
mv ../book_backup docs

# 4. remove docs/.nojekyll
rm docs/.nojekyll