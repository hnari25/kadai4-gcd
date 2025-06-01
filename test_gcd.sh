#!/bin/sh

echo "test_gcd.sh スクリプト開始 (実行結果表示バージョン)"

# --- テスト対象のスクリプト ---
GCD_SCRIPT="./gcd.sh"

# --- 一時ファイル用のプレフィックス ---
TMP_PREFIX="/tmp/test_gcd_$$" # 念のため一時ファイルは使う

# --- テスト結果カウンター ---
tests_run=0

# --- ヘルパー関数: テスト実行 (結果表示バージョン) ---
# 引数1: テスト名
# 引数2: gcd.sh に渡す引数 (文字列全体をダブルクォートで囲む)
run_test_and_show_output() {
  name="$1"
  args_str="$2"

  tests_run=$((tests_run + 1))
  echo "--------------------------------------"
  echo "テスト実行: $name"
  echo "コマンド: $GCD_SCRIPT $args_str"

  # gcd.sh を実行し、標準出力と標準エラー出力をそれぞれ一時ファイルに保存
  # eval を使って引数文字列を適切に展開してコマンドを実行
  eval "$GCD_SCRIPT $args_str" > "${TMP_PREFIX}_actual_stdout.txt" 2> "${TMP_PREFIX}_actual_stderr.txt"
  actual_status=$? # 直前のコマンドの終了ステータスを取得

  echo "  実際の終了ステータス: $actual_status"

  # 標準出力の内容を表示 (ファイルが空でなければ)
  if [ -s "${TMP_PREFIX}_actual_stdout.txt" ]; then # -s はファイルが存在し、かつ空でない場合に真
    echo "  実際の標準出力:"
    cat "${TMP_PREFIX}_actual_stdout.txt"
  else
    echo "  実際の標準出力: (なし)"
  fi

  # 標準エラー出力の内容を表示 (ファイルが空でなければ)
  if [ -s "${TMP_PREFIX}_actual_stderr.txt" ]; then
    echo "  実際の標準エラー出力:"
    cat "${TMP_PREFIX}_actual_stderr.txt"
  else
    echo "  実際の標準エラー出力: (なし)"
  fi
}

# --- テストケース (呼び出しと結果表示) ---

# 正常系テスト
run_test_and_show_output "正常系: 10 と 25 の最大公約数" "10 25" "5" "" "0"
run_test_and_show_output "正常系: 25 と 10 の最大公約数" "25 10" "5" "" "0"
run_test_and_show_output "正常系: 7 と 13 の最大公約数 (素数同士)" "7 13" "1" "" "0"
# ... (他のテストケースも同様に関数名を run_test_and_show_output に変更してください) ...
run_test_and_show_output "正常系: 100 と 1 の最大公約数" "100 1" "1" "" "0"
run_test_and_show_output "正常系: 12 と 12 の最大公約数" "12 12" "12" "" "0"
run_test_and_show_output "正常系: 大きな数 12345 と 567890" "12345 567890" "5" "" "0"

# エラー系テスト: 引数の数
run_test_and_show_output "エラー系: 引数なし" "" "" "エラー: 2つの自然数を引数として入力してください。" "1"
run_test_and_show_output "エラー系: 引数1つ" "10" "" "エラー: 2つの自然数を引数として入力してください。" "1"
run_test_and_show_output "エラー系: 引数3つ" "10 20 30" "" "エラー: 2つの自然数を引数として入力してください。" "1"

# エラー系テスト: 引数の型 (自然数でない)
run_test_and_show_output "エラー系: 引数1が文字" "abc 10" "" "エラー: 引数は2つとも1以上の自然数である必要があります。" "1"
run_test_and_show_output "エラー系: 引数2が文字" "10 xyz" "" "エラー: 引数は2つとも1以上の自然数である必要があります。" "1"
run_test_and_show_output "エラー系: 引数1が0" "0 10" "" "エラー: 引数は2つとも1以上の自然数である必要があります。" "1"
run_test_and_show_output "エラー系: 引数2が負の数" "10 -5" "" "エラー: 引数は2つとも1以上の自然数である必要があります。" "1"


# --- 後処理 ---
rm -f "${TMP_PREFIX}"_*.txt # 作成した一時ファイルを削除
echo "--------------------------------------"
echo "テスト実行サマリー: ${tests_run}件のテストを実行し、出力を表示しました。"

echo "test_gcd.sh スクリプト終了 (実行結果表示バージョン)"
