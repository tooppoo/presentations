---
theme: default
title: OSS開発を通じて考える、AI開発のこれから
info: |
  2026年前半の振り返りと後半への方針。
  4つのOSSを、AI開発の問題に異なる層から対処した事例として扱う。
colorSchema: light
aspectRatio: 16/9
fonts:
  sans: Noto Sans JP
  weights: '400,500,700'
transition: fade
mdc: true
layout: talk-cover
---

# OSS開発を通じて考える、<br>AI開発のこれから

AIに任せるために、AIだけに依存しない

2026-07-21

@Philomagi

<!--
2026年前半の振り返りと、後半への方針表明。
4つのOSSを個別紹介ではなく、AI開発で生じた問題への対処事例として話す。
-->

---
layout: talk-content
---

# 2026年前半に変わったこと

<v-clicks>

- Claude や Codex を使い、個人でも複数のOSSを並行して開発できた
- コードを書くこと自体の負荷は下がった
- 代わりに、別の問いが重くなった

</v-clicks>

<!--
まず「これまで」を置く。
生産量と並行性は上がった、というのが前半の実感。
その裏で重くなった問いを次のスライドで開く。
-->

---
layout: talk-content
---

# コードより重くなった問い

<v-clicks>

- 何を作り、何をIssueとして固定するのか
- 複数エージェントの作業をどう分離するのか
- 生成された実装が正しいかを、どう確かめるのか

</v-clicks>

<div v-click class="text-1rem text-#8a8a8a mt-5">

※ 仕様・作業状態・生成結果の不確実性が、新しいボトルネックになった

</div>

<!--
問いを3つに絞る。
どれも「コードの書き方」ではなく「不確実さの扱い方」の問い。
-->

---
layout: talk-content
---

# 変わった開発スタイル

<v-clicks>

- 実装は逐語的に読むより、全体構造と危険箇所を確認する
- E2Eテストや snapshot を重視する
- AIへの依頼を、自然言語だけでなく検証可能な条件へ落とす

</v-clicks>

<div v-click class="mt-3">

> 確認の重心を、実装の逐語確認から、外部挙動・契約・差分・テスト結果へ移した

</div>

<!--
「コードレビューを軽視する」とは言わない。
確認の重心が移った、と正確に言う。
E2E＝利用者と同じように動かして確認するテスト、と一言添える。
snapshot＝前回の出力との差分を検出する方法。
-->

---
layout: talk-diagram
---

# ファジーな領域と決定論的な領域

<div class="dbody" style="gap:1.4rem;">
  <div class="dcaption" style="margin:0 0 0.6rem;font-size:1.05rem;">ファジー＝揺れが残り、人とAIが判断する領域。決定論的＝同じ入力なら同じ結果になる領域。</div>
  <div class="flex items-stretch justify-center gap-5">
    <div class="dcol">
      <div class="dtag dtag--reuse">ファジー</div>
      <div class="dbox dbox--soft dbox--sm" style="width:12rem;height:5.2rem;white-space:normal;line-height:1.4;">人間とAIが<br>探索・判断する</div>
    </div>
    <div class="dcol">
      <div class="dtag dtag--bun">機械的判定</div>
      <div class="dbox dbox--sm" style="width:12rem;height:5.2rem;white-space:normal;line-height:1.4;">ルール・入力・出力・<br>終了条件を判定する</div>
    </div>
    <div class="dcol">
      <div class="dtag dtag--bun">検証</div>
      <div class="dbox dbox--sm" style="width:12rem;height:5.2rem;white-space:normal;line-height:1.4;">実行結果が要求を<br>満たすか確認する</div>
    </div>
  </div>
  <div class="dcaption" style="margin-top:0.4rem;">

> ファジーな領域を残しつつ、決定論的に扱える領域を増やす

  </div>
</div>

<!--
これが発表全体の主張。
AIの出力そのものを完全に決定論化する、という話ではない。
3つの領域を分離することが中心。
決定論的＝同じ入力なら同じ結果になる、と一言添える。
-->

---
layout: talk-content
---

# reportage で外部挙動を固定する

<v-clicks>

- 利用者から見える挙動を、実装言語から独立して固定するE2Eツール
- 固定する対象は、標準出力・終了コード・ファイル生成など
- 内部実装が頻繁に変わるほど、外部挙動を固定する価値が上がる

</v-clicks>

<div v-click class="mt-2">

> AIがどう実装したかではなく、外部から観測できる契約を検証する

</div>

<div v-click class="text-1rem text-#8a8a8a mt-2">

※ E2Eは万能ではない。型・単体テスト・静的解析を代替せず、外部契約を保証する層

</div>

<style scoped>
.talk-content > h1 + * { margin-top: 1.2rem; }
.talk-content ul li { margin: 0.42em 0; }
</style>

<!--
Goのtestscriptは有用だが、Go依存で構造化も弱かった。
実装言語から独立させたくて作った。
AIがどう実装したかではなく、外から観測できる契約を見る。
-->

---
layout: talk-content
---

# git-kura で作業領域を制約する

<v-clicks>

- worktree を作業単位として分離し、変更対象を claim する
- 競合を機械的に検出し、非ゼロ終了でAIの処理を止める
- コンフリクト発生後ではなく、編集・コミット前に止める

</v-clicks>

<div v-click class="mt-3">

> AIの出力は揺れても、作業領域と競合状態は機械的に判定する

</div>

<!--
AIの判断を決定論化するのではなく、AIが活動する環境を決定論的に管理する。
worktree＝同じGitリポジトリから複数の独立した作業場所を作る仕組み、と一言添える。
git-kuraは要求仕様そのものの曖昧さは解消しない。
-->

---
layout: talk-diagram
---

# installerer で generator を作る

<div class="dbody" style="gap:0.9rem;">
  <div class="flex items-center gap-4">
    <div class="dbox dbox--soft dbox--sm">AIに毎回<br>成果物を生成させる</div>
    <div class="darrow">→</div>
    <div class="dbox dbox--sm">AIと一緒に<br>generator を作る</div>
    <div class="darrow">→</div>
    <div class="dbox dbox--accent dbox--sm">同じ入力から<br>同じ成果物を生成する</div>
  </div>
  <div class="dcaption" style="margin-top:1.2rem;">

> 成果物を毎回生成させず、成果物を決定論的に生成する機械をAIで作る

  </div>
</div>

<div v-click class="text-1rem text-#8a8a8a mt-2 text-center">

※ generator 自体の正しさは自明でない。入力制約と reportage のE2Eで検証する

</div>

<!--
CLIを作るたびにinstall scriptを繰り返し書くのが面倒だった。
毎回書かせるのではなく、入力から決定論的にinstallerを生成する。
generatorの正しさの検証で、reportageと接続する。
-->

---
layout: talk-content
---

# rellog で判断を人間に残す

<v-clicks>

- 変更履歴の記録を、バージョン管理や公開処理から分離する
- コミット履歴からリリースノートを完全自動生成しない
- 変更の意味づけと採否は人間側に残す

</v-clicks>

<div v-click class="mt-3">

> 候補や文章はAIに作らせても、何を重要な変更として公開するかは委譲しない

</div>

<!--
changesetsを使いたいが、Node.js前提のバージョン管理まで組み込まれ、用途に対して過剰だった。
他の3つより短く扱い、開発思想を補足する事例として置く。
-->

---
layout: talk-diagram
---

# 4つを統合するモデル

<div class="flex flex-col items-center" style="gap:0.35rem;">
  <div class="dbox dbox--soft dbox--sm" style="width:20rem;">曖昧な要求を、人間とAIで探索する</div>
  <div class="darrow" style="font-size:1.3rem;">↓</div>
  <div v-click class="dstage"><div class="dbox dbox--sm" style="width:20rem;">判断・変更意図を明示する</div><span class="dtag dtag--reuse">rellog</span></div>
  <div class="darrow" style="font-size:1.3rem;">↓</div>
  <div v-click class="dstage"><div class="dbox dbox--sm" style="width:20rem;">作業環境を制約する</div><span class="dtag dtag--bun">git-kura</span></div>
  <div class="darrow" style="font-size:1.3rem;">↓</div>
  <div v-click class="dstage"><div class="dbox dbox--sm" style="width:20rem;">決定論的に処理する</div><span class="dtag dtag--bun">installerer</span></div>
  <div class="darrow" style="font-size:1.3rem;">↓</div>
  <div v-click class="dstage"><div class="dbox dbox--accent dbox--sm" style="width:20rem;">外部挙動を検証する</div><span class="dtag dtag--bun">reportage</span></div>
</div>

<div v-click class="dcaption" style="margin-top:1rem;">

> 探索はAIと行い、判断は明示し、実行は決定論的にし、結果はE2Eで検証する

</div>

<style scoped>
.dstage { display: flex; align-items: center; gap: 0.8rem; }
.dstage .dtag { width: 6.5rem; text-align: center; flex: 0 0 auto; }
</style>

<!--
4つを個別のツールではなく、1本の流れの各層として見せる。
上から順にクリックで開く。
-->

---
layout: talk-content
---

# 2026年後半の方針

<v-clicks>

- 前半で上がったのは、開発速度と並行性
- 新しいボトルネックは、仕様・作業状態・生成結果の不確実性
- 後半は、任せる量を増やすこと自体は目的にしない

</v-clicks>

<div v-click class="mt-3">

> ファジーな領域と決定論的な領域を分離し、検証可能な開発環境を作っていく

</div>

<!--
イベントの「これから」に接続する。
「もっと任せる」を目的化せず、境界を作ることを目的にする。
-->

---
layout: talk-cover
---

# AIに書かせる開発から、<br>AIを検証可能な仕組みに<br>組み込む開発へ

@Philomagi

<!--
最後の一文で締める。
決定論化するのはAIの出力ではなく、AIを置く環境と検証の仕組み。
-->
