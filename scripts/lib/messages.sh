# メッセージ定義（日本語/英語）
# macOS の言語設定に応じて自動切替

typeset -gA _MSG

_load_ja() {
  # install.sh
  _MSG[icloud_sync]="iCloud Driveの設定画面でDesktopとDocumentsの同期を有効にしてください。完了しましたか？ (y/n) "
  _MSG[terminal_fda]="Terminalのフルディスクアクセス権限は付与済みですか？ (y/n) "
  _MSG[terminal_fda_guide]="設定 > プライバシーとセキュリティ > フルディスクアクセス でTerminalを追加してください。\n追加後、Terminalを再起動してから再度このスクリプトを実行してください。"
  _MSG[exit]="終了します..."
  _MSG[failed_to_run]="実行に失敗しました: %s"
  _MSG[sudo_failed]="sudo認証に失敗しました"
  _MSG[restart_prompt]="システムを再起動しますか？ (y/n) "

  # config.sh
  _MSG[config_exists]="設定ファイルが既に存在します。上書きしますか？ (y/n)"
  _MSG[enter_response]="入力してください(y/n): "
  _MSG[enter_settings]="新しい設定を入力してください:"
  _MSG[enter_computer_name]="コンピュータ名を入力: "
  _MSG[enter_hostname]="ホスト名を入力 (デフォルト: %s): "
  _MSG[enter_local_hostname]="ローカルホスト名を入力 (デフォルト: %s): "
  _MSG[new_settings]="新しい設定:"
  _MSG[save_config]="新しい設定を保存しますか？ (y/n) "
  _MSG[config_saved]="設定を保存しました: '%s'"
  _MSG[select_packages]="インストールするパッケージを選択しますか？ (y/n) "
  _MSG[select_cli]="CLIツールを選択してください:"
  _MSG[select_gui]="GUIアプリを選択してください:"
  _MSG[select_mas]="App Storeアプリを選択してください:"
  _MSG[confirm_next]="Enter:次へ"
  _MSG[confirm_done]="Enter:確定"
  _MSG[cancelled]="キャンセルされました"
  _MSG[select_complete]="パッケージ選択完了: %d 件を選択しました"
  _MSG[install_all]="全パッケージをインストールします"

  # checkbox.sh
  _MSG[checkbox_help]="↑↓:移動  Space:選択/解除  a:全選択  n:全解除  %s  q:キャンセル"
  _MSG[scroll_up]="▲ 他 %d 件"
  _MSG[scroll_down]="▼ 他 %d 件"
  _MSG[selected_count]="%d/%d 選択中"
}

_load_en() {
  # install.sh
  _MSG[icloud_sync]="Please enable Desktop and Documents sync in iCloud Drive settings. Done? (y/n) "
  _MSG[terminal_fda]="Has Terminal been granted Full Disk Access? (y/n) "
  _MSG[terminal_fda_guide]="Please add Terminal in Settings > Privacy & Security > Full Disk Access.\nAfter adding, restart Terminal and run this script again."
  _MSG[exit]="Exiting..."
  _MSG[failed_to_run]="Failed to run %s"
  _MSG[sudo_failed]="sudo authentication failed"
  _MSG[restart_prompt]="Do you want to restart the system now? (y/n) "

  # config.sh
  _MSG[config_exists]="Configuration file already exists. Do you want to overwrite it? (y/n)"
  _MSG[enter_response]="Enter your response(y/n): "
  _MSG[enter_settings]="Please enter the new settings for your configuration file:"
  _MSG[enter_computer_name]="Enter computer_name: "
  _MSG[enter_hostname]="Enter hostname (default: %s): "
  _MSG[enter_local_hostname]="Enter local_hostname (default: %s): "
  _MSG[new_settings]="New settings:"
  _MSG[save_config]="Do you want to save the new configuration? (y/n) "
  _MSG[config_saved]="New configuration saved to '%s'"
  _MSG[select_packages]="Do you want to select packages to install? (y/n) "
  _MSG[select_cli]="Select CLI tools:"
  _MSG[select_gui]="Select GUI applications:"
  _MSG[select_mas]="Select App Store applications:"
  _MSG[confirm_next]="Enter: Next"
  _MSG[confirm_done]="Enter: Confirm"
  _MSG[cancelled]="Cancelled"
  _MSG[select_complete]="Package selection complete: %d selected"
  _MSG[install_all]="Installing all packages"

  # checkbox.sh
  _MSG[checkbox_help]="↑↓:Move  Space:Toggle  a:All  n:None  %s  q:Cancel"
  _MSG[scroll_up]="▲ %d more above"
  _MSG[scroll_down]="▼ %d more below"
  _MSG[selected_count]="%d/%d selected"
}

# 言語判定
if defaults read -g AppleLanguages 2>/dev/null | head -2 | grep -q '"ja'; then
  _load_ja
else
  _load_en
fi
