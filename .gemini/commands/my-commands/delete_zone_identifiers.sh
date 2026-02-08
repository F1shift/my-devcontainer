#!/bin/bash

# 1. 対象ディレクトリ指定
TARGET_DIR="${1}"

# エラーハンドリング: 引数チェック
if [ -z "$TARGET_DIR" ]; then
  echo "Usage: $0 <directory_path>"
  exit 1
fi

# エラーハンドリング: ディレクトリ存在チェック
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Directory '$TARGET_DIR' does not exist."
  exit 1
fi

# 2. ファイル検索
echo "Searching for '*Zone.Identifier' files in '$TARGET_DIR'..."

# findコマンドで見つかったファイルを配列に格納 (null文字区切りで安全に処理)
MATCHED_FILES=()
while IFS=  read -r -d $'\0'; do
    MATCHED_FILES+=("$REPLY")
done < <(find "$TARGET_DIR" -type f -name "*Zone.Identifier" -print0)

FILE_COUNT=${#MATCHED_FILES[@]}

# 6. 対象なし通知
if [ "$FILE_COUNT" -eq 0 ]; then
  echo "No '*Zone.Identifier' files found." >&2
  exit 0
fi

# 3. 確認プロンプト
echo "Found $FILE_COUNT file(s):"
for file in "${MATCHED_FILES[@]}"; do
  echo "  $file"
done

echo ""
read -p "Do you want to delete these files? (y/N): " CONFIRM

# "y" または "Y" 以外はキャンセル扱い
if [[ ! "$CONFIRM" =~ ^[yY]$ ]]; then
  echo "Operation cancelled."
  exit 0
fi

# 4. 削除処理
DELETED_COUNT=0
for file in "${MATCHED_FILES[@]}"; do
  rm "$file"
  if [ $? -eq 0 ]; then
    ((DELETED_COUNT++))
  else
    echo "Failed to delete: $file" >&2
  fi
done

# 5. 件数報告
echo "Deletion complete. Deleted $DELETED_COUNT file(s)."
