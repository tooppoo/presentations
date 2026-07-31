---
theme: default
title: GitHub Actions ハンズオン
info: |
  fork したリポジトリで workflow を動かし、独自 action を作るまでの 45 分

  開催が決まったら、表紙の日付と勉強会名を埋めること。
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
class: head-sm
---

# 進め方

<div class="timetable">

| | 内容 | 目安 |
| --- | --- | --- |
| 説明 | GitHub Actions の読み方 | 12 分 |
| STEP 1 | リポジトリを fork する | 4 分 |
| STEP 2 | hello-world.yml を動かす | 8 分 |
| STEP 3 | README.md を出力する | 8 分 |
| STEP 4 | 自分の action を作る | 7 分 |
| 予備 | 質問、詰まったときの対応 | 6 分 |

</div>

- 各ステップは「説明を聞く」「各自で手を動かす」の順
- 詰まったら手を挙げる。近くの人と相談してもよい

<style scoped>
.talk-content table {
  width: 100%;
  border-collapse: collapse;
  font-size: 1.05rem;
  margin: 0.2em 0 0.6em;
}
.talk-content th, .talk-content td {
  border-bottom: 1px solid var(--talk-border);
  padding: 0.32em 0.6em;
  text-align: left;
}
.talk-content th { color: var(--talk-primary-strong); }
.talk-content td:last-child { text-align: right; white-space: nowrap; }
.talk-content ul li { font-size: 1.15rem; margin: 0.3em 0; }
</style>

<!--
時間の約束を最初に見せる。押したときに削るのは予備と STEP 3 の寄り道で、STEP 4 は削らない。
-->

---
layout: talk-content
class: head-sm
---

# 事前準備

- GitHub アカウント
- ブラウザ
- 作業はすべて GitHub の画面上で完結する
  - ローカルに clone して進めたい場合の手順も手順書にある

<div class="mt-3 links">

題材リポジトリ: `https://github.com/tooppoo/github-actions-hands-on`

手順書: `https://github.com/tooppoo/github-actions-hands-on/blob/main/docs/hands-on.md`

</div>

<style scoped>
.talk-content .links p { font-size: 1.1rem; margin: 0.3em 0; }
</style>

<!--
環境構築で時間を溶かさないため、ブラウザ完結を主線にする。
このスライドは URL を確認したい人が戻ってくる先になるので、クリック送りにしない。
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
  <div class="dnest dnest--wf">
    <div class="dnest__label">workflow</div>
    <div class="dnest__note">.github/workflows/*.yml</div>
    <div class="dnest dnest--job">
      <div class="dnest__label">job</div>
      <div class="dnest__note">runner 1 台に対応</div>
      <div class="dnest dnest--step">
        <div class="dnest__label">step</div>
        <div class="dnest__note">run: コマンド / uses: action</div>
      </div>
    </div>
  </div>
  <div class="dcaption">workflow が job を含み、job が step を含む</div>
</div>

<style scoped>
.talk-diagram .dnest {
  width: 100%;
  border: 1.5px solid var(--talk-border);
  border-radius: 12px;
  background: var(--talk-surface);
  padding: 0.7rem 1rem 0.9rem;
}
.talk-diagram .dnest--wf {
  width: 62%;
  border-color: var(--talk-primary);
  background: var(--talk-surface-soft);
}
.talk-diagram .dnest--job { margin-top: 0.5rem; }
.talk-diagram .dnest--step { margin-top: 0.5rem; }
.talk-diagram .dnest__label {
  font-size: 1.25rem;
  font-weight: 700;
  color: var(--talk-primary-strong);
}
.talk-diagram .dnest__note {
  font-size: 0.92rem;
  color: var(--talk-text-muted);
  margin-top: 0.15rem;
}
.talk-diagram .dcaption { font-size: 1.2rem; margin-top: 1.6rem; }
</style>

<!--
矢印にしないのは、「workflow の次に job が動く」と読まれると次の YAML の入れ子と結びつかないため。
runner という言葉はここで一度出しておき、STEP 3 の checkout で回収する。
-->

---
layout: talk-content
class: code-sm head-xs
---

# workflow YAML を読む

<p class="code-caption"><code>.github/workflows/hello-world.yml</code></p>

```yaml {all|1|2-6|8-10|11-12|14-15}
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

<!--
クリックで上から順に、名前・きっかけ・実行するマシン・権限・実行する中身、と辿る。
permissions は「この job に与える権限」。checkout に必要な最小限だけ書いてある、と一言添える。
題材リポジトリに最初から入っているファイルそのもの。
ファイル名は hello-world.yml だが name: は CI。Actions タブに並ぶのは name: の値のほう、と一言添える。
-->

---
layout: talk-step
step: 1
time: 4 分
---

# リポジトリを fork する

自分のアカウントに作業用のコピーを作る

<!--
ここから手を動かす。fork の意味が曖昧な人がいる想定で、「自分のアカウント配下のコピー」と一言添える。
-->

---
layout: talk-content
class: head-sm
---

# STEP 1 の手順

- 題材リポジトリをブラウザで開く
  - `https://github.com/tooppoo/github-actions-hands-on`
- 右上の `Fork` を押す
- Owner を自分のアカウントにして `Create fork`
- **Actions タブを開き、確認ボタンを押す**
  - `I understand my workflows, go ahead and enable them`
- 以降の作業は、すべて fork した側のリポジトリで行う

<!--
このスライドは作業中ずっと表示しておく。全項目を最初から出すのはそのため。
4 つ目を落とすと STEP 2 で全員が止まるので、次のスライドで理由まで説明する。
-->

---
layout: talk-content
class: head-sm
---

# なぜ有効化が要るのか

- fork したリポジトリでは、workflow が最初は無効になっている
  - 他人の書いた workflow が、fork した瞬間に動くのを防ぐため
- Actions タブを開くと、確認ボタンが表示される
- 押すまでは、push しても何も起きない

<div class="mt-2">

> fork 先で最初にやること

</div>

<!--
ここを飛ばすと STEP 2 で全員が止まる。理由まで話すと、押し忘れたときに自力で気付ける。
クリック送りにしないのは、作業直前の注意喚起を一覧で見せたいため。
-->

---
layout: talk-step
step: 2
time: 8 分
---

# hello-world.yml を動かす

編集して push し、Actions タブで実行を見る

<!--
最初の一周。編集からログの確認までを、自分の目で通す。
-->

---
layout: talk-content
class: head-sm
---

# STEP 2 の手順

<p class="code-caption"><code>.github/workflows/hello-world.yml</code></p>

```yaml
    steps:
      - run: echo "Hello, GitHub Actions!"
      - run: date
```

- 鉛筆アイコンから編集し、`steps` を上のように書き換える
- `Commit directly to the main branch` を選んでコミットする
- Actions タブを開き、実行されたことを確認する
  - 一覧に並ぶ名前は、ファイル名ではなく `name:` の値（`CI`）

<style scoped>
.talk-content ul li { font-size: 1.2rem; margin: 0.35em 0; }
</style>

<!--
作業中は表示しっぱなしにする。手順と書き換える中身を 1 枚に載せているのはそのため。
ブランチを切ると on: の条件から外れて動かないので、main への直接コミットを指定している。
`date` を足すのは、step が複数並ぶことと、実行のたびに結果が変わることを同時に見せるため。
run に書いたコマンドが runner 上で走ること、step が上から順に実行され、いくつでも並べられることは口頭で補う。
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
.talk-diagram .dnote { font-size: 0.92rem; }
.talk-diagram .darrow { margin-top: 0.7rem; }
.talk-diagram .dcaption { font-size: 1.2rem; margin-top: 2rem; }
</style>

<!--
矢印はここでは画面を掘っていく順序を指す。ログの階層が分かっていないと、失敗の原因まで辿り着けない。
-->

---
layout: talk-content
class: head-sm
---

# 寄り道: いつ動くかを決める

<v-clicks>

- `on:` に書いたものが、workflow のきっかけになる
- `on.push.branches` に `main` を書くと、main への push で動く
- `workflow_dispatch:` は手動実行を許可する
  - Actions タブの `Run workflow` から、push なしで実行できる

</v-clicks>

<div v-click class="mt-2">

> 試すだけなら、毎回コミットしなくてもよい

</div>

<!--
手動実行を知っておくと、以降のステップで試行錯誤が速くなる。
時間が押していたらこのスライドは飛ばす。ここが最初の削りどころ。
-->

---
layout: talk-step
step: 3
time: 8 分
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
.talk-diagram .darrow { margin-top: 0.9rem; }
.talk-diagram .dcaption { font-size: 1.25rem; margin-top: 2rem; }
</style>

<!--
矢印はここでは runner の状態が変わる前後を指す。
「リポジトリの中で動いているのだからファイルはあるはず」と思われがちなところ。runner とリポジトリは別物だと明示する。
-->

---
layout: talk-content
class: head-sm
---

# STEP 3 の手順

<p class="code-caption"><code>.github/workflows/hello-world.yml</code></p>

```yaml
    steps:
      - uses: actions/checkout@v7
      - run: cat README.md
```

- `steps` を上のように書き換え、main へ直接コミットする
- Actions タブで、README.md の中身が出力されたことを確認する
- 余裕があれば `checkout` の行を消して、失敗を見てみる

<style scoped>
.talk-content ul li { font-size: 1.2rem; margin: 0.35em 0; }
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
time: 7 分
---

# 自分の action を作る

action.yml を書いて、公開 action と同じ書き方で呼ぶ

<!--
最後のステップ。使う側から作る側に回る。ここは時間が押しても削らない。
-->

---
layout: talk-content
---

# なぜ自分で action を作るのか

<v-clicks>

- 同じ step の並びを、複数の workflow で使い回したい
- step のかたまりに名前を付けて、意図を示したい
- composite action なら、YAML を書くだけで作れる
- `actions/checkout` と同じ `<owner>/<repo>` の形で呼べる

</v-clicks>

<div v-click class="mt-2">

> 自作の action も、公開されている action も、呼ぶ側から見れば同じ

</div>

<!--
再利用が主な動機だが、名前を付けて意図を残せるという効果も大きい。
4 つ目が STEP 4 の狙い。特別な呼び方を覚えるのではなく、STEP 3 で使った uses がそのまま効く。
-->

---
layout: talk-content
class: code-sm head-xs
---

# STEP 4 の手順

<div class="two-column step4">
<div class="column">

<p class="code-caption">新規作成: リポジトリのルートに <code>action.yml</code></p>

```yaml
name: greet
description: 挨拶を出力する
runs:
  using: composite
  steps:
    - shell: bash
      run: echo "Hello, GitHub Actions!"
```

</div>
<div class="column">

<p class="code-caption">書き換え: <code>.github/workflows/hello-world.yml</code></p>

```yaml
    steps:
      - uses: <owner>/github-actions-hands-on@main
```

- `<owner>` は自分の GitHub アカウント名
- `action.yml` を先にコミットしてから workflow を書き換える
- composite の `run` step には `shell` の指定が必要
- `checkout` は要らない。action は GitHub 側から取得される

</div>
</div>

<style scoped>
.talk-content .two-column { display: flex; gap: 1.6rem; }
.talk-content .column { width: 50%; }
.talk-content .code-caption { font-size: 0.95rem; }
.talk-content ul li { font-size: 0.95rem; margin: 0.3em 0; }
/* 右カラムの uses は 1 行が長いので、この列だけさらに詰める */
.talk-content .step4 .column:last-child pre { font-size: 12px !important; }
</style>

<!--
2 つのファイルを同時に触るので、1 枚に並べて作業中ずっと表示しておく。
呼び方が actions/checkout@v7 と同じ形になっている点を指摘する。ここが STEP 4 の山。
checkout が要らないのは、リポジトリのファイルを読むのではなく、runner が action を取りに行くため。
STEP 3 とちょうど裏返しになっているので、対比で説明する。
順序を逆にすると、action.yml がまだ main に無い状態で参照して失敗する。
今日は定義して動かすところまで。値を渡す inputs と受け取る outputs は、まとめで名前を挙げるだけにする。
-->

---
layout: talk-content
class: code-sm head-sm
---

# 余裕があれば: action を増やす

<p class="code-caption">新規作成: <code>actions/bye/action.yml</code></p>

```yaml
name: bye
description: 別れの挨拶を出力する
runs:
  using: composite
  steps:
    - shell: bash
      run: echo "Bye!"
```

<p class="code-caption">呼び出し: リポジトリ名のあとにディレクトリを続ける</p>

```yaml
      - uses: <owner>/github-actions-hands-on/actions/bye@main
```

<!--
1 つのリポジトリに複数の action を置ける。ルートの action.yml はそのまま残してよい。
時間が余った人向け。全員でやる必要はない。
-->

---
layout: talk-content
---

# まとめ

<v-clicks>

- workflow は `on` と `jobs` と `steps` の 3 つで読める
- runner はまっさらなマシン。ファイルが要るなら `checkout` する
- 公開された action は `uses` で呼び、バージョンを固定する
- 自作の action も、同じ `<owner>/<repo>` の形で呼べる

</v-clicks>

<div v-click class="mt-2">

> 次に読むもの: action の inputs と outputs、reusable workflow、GitHub Actions 公式ドキュメント

</div>

<!--
今日作った action は値を受け取らない。引数を渡すのが inputs、結果を返すのが outputs。
ほかに触れなかったものとして、secrets、matrix、キャッシュあたりを口頭で挙げる。
-->
