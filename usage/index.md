## Printoon の使用方法

<p align="center">
    ← <a href="../setup-linux/">VirtualBox の準備</a>
</p>

<br>


### Printoon のインストール

Linux デスクトップで Ctrl + Alt + T を押してターミナルを開きます。

次のコマンドを 1 行ずつ入力してください。

```bash
sudo apt update
sudo apt install git
git clone https://github.com/rtanpo440/printoon
cd printoon
sudo ./install.sh
```

最後のコマンドが終了する時 “Printoon installation complete.” と表示されれば成功です。


### Nintendo Switch とペアリング

ここで、Nintendo Switch を起動します。HOME 画面から “コントローラー” > ”持ちかた/順番を変える” を選択して接続画面を表示させてください。

Bluetooth が有効なのを確認して、次のコマンドを実行します。

```bash
sudo ./connect.sh
```

ペアリングが完了すると “Pairing complete!” と表示されます。これでついに、プロットの準備が整いました!!


### 画像のプロット

1. デスクトップの左下にあるアイコンからアプリのランチャーを表示すると Printoon のアイコンが作成されていますのでクリックします。
2. プロットする画像をダイアログから選択します。そのまま / キーを押すとファイルパスを手打ちできます。画像は自動で 320x120 にリサイズされた上でディザリング加工され、その結果が別名で同じ場所に保存されます。
3. 反転モードを使用するか質問されます。デフォルトでは黒い部分で A ボタンを押す操作をしますが、もし白い部分をプロットしたいときは、Splatoon 2 の投稿画面上でキャンバスを黒色に塗りつぶし、一番細い消しゴムを選択している状態で “はい” をクリックします。そうでなければ、一番細い鉛筆を選択して “いいえ” を選択します。
4. 次のダイアログでは、プロットされる画像をプレビューするときは “はい” をクリックします。画像ビューアーが起動しプレビューできます。確認が終わったらビューアーのウィンドウを閉じて、プロットを行う場合は “はい” をクリックします。
5. プロットを行います。画像によって所要時間は異なりますが、おおよそ 1 時間かかります。

途中で自動ドット打ちをキャンセルする場合はキーボードの Ctrl + C を押してください。
