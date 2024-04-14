#!/bin/bash

# 원격 서버 정보
REMOTE_HOST="hcha.digimoon.net"
REMOTE_PORT="50022"
REMOTE_USER="hcha"
#REMOTE_DIR="www/pub"

# SFTP 연결 및 파일 다운로드 함수
download_file() {
    local FILE="$1"
    echo "다운로드할 파일: $FILE"
    echo "원격 서버에서 다운로드 중..."
    sftp -P "$REMOTE_PORT" "$REMOTE_USER@$REMOTE_HOST" <<EOF
cd $REMOTE_DIR
get "$FILE"
bye
EOF
    echo "파일 다운로드 완료"
}

# 원격 서버의 파일 목록 표시
echo "원격 서버의 파일 목록:"
sftp -P "$REMOTE_PORT" "$REMOTE_USER@$REMOTE_HOST" <<EOF
#cd $REMOTE_DIR
ls
bye
EOF

# 사용자에게 다운로드할 파일 선택 요청
echo "다운로드할 파일을 선택하세요:"
read FILENAME

# 선택한 파일을 로컬 디렉토리로 다운로드
download_file "$FILENAME"

