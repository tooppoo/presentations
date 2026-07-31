---
theme: default
title: GitHub Actions ハンズオン
info: |
  fork したリポジトリで workflow を動かし、独自 action を作るまでの 45 分
colorSchema: light
aspectRatio: 16/9
fonts:
  sans: Noto Sans JP
  weights: '400,500,700'
transition: fade
mdc: true
layout: talk-cover
---

::caption::

# GitHub Actions ハンズオン

::info::

2026-XX-XX

勉強会名をここに

@Philomagi

---
src: ./pages/profile.md
---

---
layout: talk-content
---

# 今日のゴール

<v-clicks>

- workflow の YAML を読めるようになる
- 自分のリポジトリで workflow を動かせるようになる
- 公開されている action を呼び出せるようになる
- 自分で action を定義できるようになる

</v-clicks>

<div v-click class="mt-2">

> 「読める」「動かせる」「作れる」の 3 つを 45 分で通す

</div>

<!--
ゴールを最初に固定する。今日は網羅ではなく、自分の手で一周させることを目指す。
-->

---
layout: talk-content
---

# 進め方

<v-clicks>

- 4 つのステップを順に進める
- 各ステップは「説明を聞く」「各自で手を動かす」の順
- コピー用のコマンドと YAML は手順書にまとめてある
- 詰まったら手を挙げる。近くの人と相談してもよい

</v-clicks>

<!--
スライドは進行の目印で、実際に見るのは手順書のほう。ここで手順書のURLを共有しておく。
-->

---
layout: talk-content
---

# 事前準備

<v-clicks>

- GitHub アカウント
- ブラウザ
- 作業はすべて GitHub の画面上で完結する
  - ローカルに clone して進めたい場合の手順も手順書にある

</v-clicks>

<div v-click class="mt-2">

題材リポジトリ: <br>
`https://github.com/tooppoo/github-actions-hands-on`

</div>

<!--
環境構築で時間を溶かさないため、ブラウザ完結を主線にする。ローカル派には手順書のフォールバックを案内する。
-->

---
layout: talk-content
---

# GitHub Actions とは

<v-clicks>

- GitHub に組み込まれた、コマンドの実行環境
- push や pull request をきっかけに動く
- テスト、Lint、ビルド、デプロイの自動化に使われる
- 何を実行するかは、リポジトリ内の YAML に書く

</v-clicks>

<div v-click class="mt-2">

> リポジトリで起きたことに反応して、用意されたマシンでコマンドを流す仕組み

</div>

<!--
CIツールという説明から入らない。「イベントに反応してコマンドが走る」という一点に絞る。
-->

---
layout: talk-diagram
---

# 用語の地図

<div class="dbody">
  <div class="flex items-start gap-6">
    <div class="dcol">
      <div class="dbox dbox--accent">workflow</div>
      <div class="dnote">.github/workflows/*.yml</div>
    </div>
    <div class="darrow">→</div>
    <div class="dcol">
      <div class="dbox">job</div>
      <div class="dnote">runner 1 台に対応</div>
    </div>
    <div class="darrow">→</div>
    <div class="dcol">
      <div class="dbox">step</div>
      <div class="dnote">run: コマンド<br>uses: action</div>
    </div>
  </div>
  <div class="dcaption">runner は GitHub が用意する仮想マシン</div>
</div>

<style scoped>
.talk-diagram .dbox { font-size: 1.4rem; padding: 0.9rem 1.6rem; }
.talk-diagram .dcol {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.6rem;
}
.talk-diagram .dnote {
  font-size: 0.95rem;
  line-height: 1.5;
  color: var(--talk-text-muted);
  text-align: center;
  min-height: 2.9em;
}
.talk-diagram .darrow { margin-top: 1.1rem; }
.talk-diagram .dcaption { font-size: 1.25rem; margin-top: 2rem; }
</style>

<!--
この3語だけ覚えれば YAML は読める。runner という言葉はここで一度出しておき、STEP 3 の checkout で回収する。
-->

---
layout: talk-content
class: code-xs
---

# workflow YAML を読む

```yaml {all|1|2-6|8-9|11-15}
name: CI
on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  check:
    runs-on: ubuntu-latest
    permissions:
      contents: read

    steps:
      - run: echo "Hello, World!"
```

<style scoped>
.talk-content h1 { height: 18%; font-size: 1.7rem; }
.talk-content pre { margin-top: 0.4em; }
</style>

<!--
クリックで上から順に、名前・きっかけ・実行するマシン・実行する中身、と辿る。
題材リポジトリに最初から入っているファイルそのもの。
-->

---
layout: talk-step
step: 1
time: 5 分
---

# リポジトリを fork する

自分のアカウントに作業用のコピーを作る

<!--
ここから手を動かす。fork の意味が曖昧な人がいる想定で、「自分のアカウント配下のコピー」と一言添える。
-->

---
layout: talk-content
---

# STEP 1 の手順

- 題材リポジトリをブラウザで開く
  - `https://github.com/tooppoo/github-actions-hands-on`
- 右上の `Fork` を押す
- Owner を自分のアカウントにして `Create fork`
- 以降の作業は、すべて fork した側のリポジトリで行う

<style scoped>
.talk-content h1 { height: 22%; font-size: 1.8rem; }
</style>

<!--
このスライドは作業中ずっと表示しておく。全項目を最初から出すのはそのため。
-->

---
layout: talk-content
---

# fork 直後の落とし穴

<v-clicks>

- fork したリポジトリでは、workflow が最初は無効になっている
- Actions タブを開くと、確認ボタンが表示される
- `I understand my workflows, go ahead and enable them` を押す
- 押すまでは、push しても何も起きない

</v-clicks>

<div v-click class="mt-2">

> fork 先で最初にやること

</div>

<!--
ここを飛ばすと STEP 2 で全員が止まる。作業前に必ず案内する。
-->

---
layout: talk-step
step: 2
time: 10 分
---

# hello-world.yml を動かす

編集して push し、Actions タブで実行を見る

<!--
最初の一周。編集からログの確認までを、自分の目で通す。
-->

---
layout: talk-content
---

# STEP 2 の手順

- `.github/workflows/hello-world.yml` を開く
- 鉛筆アイコンから編集する
- `echo` の文字列を書き換え、step をもう 1 つ足す
- `Commit directly to the main branch` を選んでコミット
- Actions タブを開き、実行されたことを確認する

<style scoped>
.talk-content h1 { height: 22%; font-size: 1.8rem; }
</style>

<!--
作業中は表示しっぱなしにする。ブランチを切ると on: の条件から外れて動かないので、main への直接コミットを指定している。
-->

---
layout: talk-content
---

# STEP 2 の変更例

```yaml
    steps:
      - run: echo "Hello, GitHub Actions!"
      - run: date
```

<v-clicks>

- `run` に書いたコマンドが runner 上で実行される
- step は上から順に実行される
- step は好きなだけ並べられる

</v-clicks>

<style scoped>
.talk-content h1 { height: 22%; font-size: 1.8rem; }
.talk-content pre { font-size: 1.05rem; }
</style>

<!--
`date` を足すのは、step が複数並ぶことと、実行のたびに結果が変わることを同時に見せるため。
-->

---
layout: talk-diagram
---

# Actions タブの読み方

<div class="dbody">
  <div class="flex items-start gap-5">
    <div class="dcol">
      <div class="dbox dbox--soft">Actions タブ</div>
      <div class="dnote">実行の一覧</div>
    </div>
    <div class="darrow">→</div>
    <div class="dcol">
      <div class="dbox">workflow run</div>
      <div class="dnote">1 回の実行</div>
    </div>
    <div class="darrow">→</div>
    <div class="dcol">
      <div class="dbox">job: check</div>
      <div class="dnote">runner 1 台分</div>
    </div>
    <div class="darrow">→</div>
    <div class="dcol">
      <div class="dbox dbox--accent">step のログ</div>
      <div class="dnote">コマンドの出力</div>
    </div>
  </div>
  <div class="dcaption">失敗したときは、赤くなった step のログを開く</div>
</div>

<style scoped>
.talk-diagram .dbox { font-size: 1.2rem; padding: 0.8rem 1.1rem; }
.talk-diagram .dcol {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.6rem;
}
.talk-diagram .dnote {
  font-size: 0.92rem;
  line-height: 1.5;
  color: var(--talk-text-muted);
  text-align: center;
}
.talk-diagram .darrow { margin-top: 0.7rem; }
.talk-diagram .dcaption { font-size: 1.2rem; margin-top: 2rem; }
</style>

<!--
ログの階層が分かっていないと、失敗したときに原因まで辿り着けない。ここで開き方を揃えておく。
-->

---
layout: talk-content
---

# 寄り道: いつ動くかを決める

<v-clicks>

- `on:` に書いたものが、workflow のきっかけになる
- `push: branches: [main]` は、main への push で動く
- `workflow_dispatch:` は手動実行を許可する
- Actions タブの `Run workflow` から、push なしで実行できる

</v-clicks>

<div v-click class="mt-2">

> 試すだけなら、毎回コミットしなくてもよい

</div>

<!--
手動実行を知っておくと、以降のステップで試行錯誤が速くなる。時間が押していたら口頭だけで流す。
-->

---
layout: talk-step
step: 3
time: 10 分
---

# README.md の中身を出力する

公開されている action を呼び出してみる

<!--
ここで uses が登場する。checkout は最も使われる action なので、最初の題材にちょうどよい。
-->

---
layout: talk-diagram
---

# なぜ checkout が要るのか

<div class="dbody">
  <div class="flex items-start gap-6">
    <div class="dcol">
      <div class="dbox">runner</div>
      <div class="dnote">ファイルは何もない</div>
    </div>
    <div class="darrow">→</div>
    <div class="dcol">
      <div class="dbox dbox--accent">actions/checkout</div>
      <div class="dnote">step を 1 つ足すだけ</div>
    </div>
    <div class="darrow">→</div>
    <div class="dcol">
      <div class="dbox dbox--soft">runner</div>
      <div class="dnote">リポジトリの内容が置かれた状態</div>
    </div>
  </div>
  <div class="dcaption">runner は毎回まっさらな状態で起動する</div>
</div>

<style scoped>
.talk-diagram .dbox { font-size: 1.3rem; padding: 0.9rem 1.4rem; }
.talk-diagram .dcol {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.6rem;
}
.talk-diagram .dnote {
  font-size: 0.95rem;
  line-height: 1.5;
  color: var(--talk-text-muted);
  text-align: center;
}
.talk-diagram .darrow { margin-top: 0.9rem; }
.talk-diagram .dcaption { font-size: 1.25rem; margin-top: 2rem; }
</style>

<!--
「リポジトリの中で動いているのだからファイルはあるはず」と思われがちなところ。runner とリポジトリは別物だと明示する。
-->

---
layout: talk-content
---

# STEP 3 の手順

```yaml
    steps:
      - uses: actions/checkout@v7
      - run: cat README.md
```

- `hello-world.yml` の `steps` を上のように書き換える
- コミットして、Actions タブで出力を確認する
- 余裕があれば `checkout` の行を消して、失敗を見てみる

<style scoped>
.talk-content h1 { height: 20%; font-size: 1.8rem; }
.talk-content pre { font-size: 1.05rem; margin-top: 0.4em; }
.talk-content ul li { font-size: 1.28rem; }
</style>

<!--
わざと失敗させる余地を残しておく。checkout がないと cat が「そんなファイルはない」で落ちる、という体験が一番残る。
-->

---
layout: talk-content
---

# uses とバージョン指定

<v-clicks>

- `uses: <owner>/<repo>@<ref>` の形で、公開された action を呼ぶ
- action は GitHub Marketplace から探せる
- `@v7` のようにバージョンを固定する
- 固定しないと、action 側の更新で急に壊れることがある

</v-clicks>

<div v-click class="mt-2">

> 自分で書かずに済むものは、たいてい誰かが action にしている

</div>

<!--
バージョン固定は運用で効いてくる話。ハンズオン中は動けばよいが、実務では必ず固定する、と一言添える。
-->

---
layout: talk-step
step: 4
time: 8 分
---

# 自分の action を作る

action.yml を書いて、同じリポジトリから呼ぶ

<!--
最後のステップ。使う側から作る側に回る。
-->

---
layout: talk-content
---

# なぜ自分で action を作るのか

<v-clicks>

- 同じ step の並びを、複数の workflow で使い回したい
- step のかたまりに名前を付けて、意図を示したい
- composite action なら、YAML を書くだけで作れる
- リポジトリの中に置けば、そのリポジトリから呼び出せる

</v-clicks>

<!--
再利用が主な動機だが、名前を付けて意図を残せるという効果も大きい。
-->

---
layout: talk-content
class: code-sm
---

# STEP 4 の手順: action.yml

`.github/actions/greet/action.yml` を新規作成する

```yaml
name: greet
description: 名前を受け取って挨拶を出力する
inputs:
  name:
    description: 挨拶する相手
    required: false
    default: World
runs:
  using: composite
  steps:
    - shell: bash
      run: echo "Hello, ${{ inputs.name }}!"
```

<style scoped>
.talk-content h1 { height: 16%; font-size: 1.6rem; }
.talk-content p { font-size: 1.1rem; margin: 0.4em 0; }
.talk-content pre { margin-top: 0.3em; }
</style>

<!--
inputs で値を受け取れることを見せる。outputs まで広げると 8 分では収まらないので、余力のある人向けに手順書へ回す。
-->

---
layout: talk-content
---

# STEP 4 の手順: 呼び出す

```yaml
    steps:
      - uses: actions/checkout@v7
      - uses: ./.github/actions/greet
        with:
          name: GitHub Actions
```

- composite の step には `shell` の指定が必要
- リポジトリ内の action は、`checkout` の後でないと呼べない

<style scoped>
.talk-content h1 { height: 18%; font-size: 1.8rem; }
.talk-content pre { font-size: 1rem; margin-top: 0.4em; }
.talk-content ul li { font-size: 1.24rem; }
</style>

<!--
STEP 3 で入れた checkout が、ここで効いてくる。パスを指定して呼ぶ以上、ファイルが runner 上にある必要がある。
-->

---
layout: talk-content
---

# まとめ

<v-clicks>

- workflow は `on` と `jobs` と `steps` の 3 つで読める
- runner はまっさらなマシン。ファイルが要るなら `checkout` する
- 公開された action は `uses` で呼び、バージョンを固定する
- step のかたまりは、composite action としてまとめられる

</v-clicks>

<div v-click class="mt-2">

> 次に読むもの: GitHub Actions 公式ドキュメント、Marketplace、reusable workflow

</div>

<!--
今日触れなかったものとして、reusable workflow、secrets、matrix、キャッシュあたりを口頭で挙げる。
-->
