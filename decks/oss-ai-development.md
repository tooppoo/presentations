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

::caption::

# OSS開発を通じて考える<br>AI開発のこれから

::info::

2026-07-21

SAPPORO ENGINEER BASE #15

#seb_sapporo

@Philomagi

<!--
2026年前半の振り返りと、後半への方針表明。
4つのOSSを個別紹介ではなく、AI開発で生じた問題への対処事例として話す。
-->

---
src: ./pages/profile.md
---

---
layout: talk-content
---

# 2026年前半に変わったこと

<v-clicks>

- Claude や Codex を使い、個人でも複数のOSSを並行して開発できた
- コードを書くこと自体の負荷は下がった
- 実装レイヤの代わりに、違うレイヤの負荷が大きくなりつつある

</v-clicks>

<!--
まず「これまで」を置く。
生産量と並行性は上がった、というのが前半の実感。
その裏で重くなった問いを次のスライドで開く。
-->

---
layout: talk-content
---

# 負荷の比重が大きくなったレイヤ

<v-clicks>

- 複数AIエージェントの作業をどう分離するのか
- どこまでをAIエージェントに任せ、どこからは任せないのか
- **生成された実装が正しいかを、どう確かめるのか**

</v-clicks>

<div v-click class="text-1rem text-#8a8a8a mt-5">

> ※ 作業状態の管理、AIに委任する範囲、生成結果の不確実性が、問題の中心になった

</div>

<!--
問いを3つに絞る。
どれも「コードの書き方」ではなく「不確実さの扱い方」の問い。
-->

---
layout: talk-content
---

# 開発スタイル・方針の変化

<v-clicks>

- 複数のAIエージェントに並行で作業させる
- 「生成する仕組み」をAIに生成させる
  - プログラム、ドキュメントなど
- 実装結果は逐語的に読むより、全体構造と入出力の結果検証を重視

</v-clicks>

<div v-click class="mt-3">

> 並行実装、自動生成の実装、入出力契約の検証に重点が移動

</div>

---
layout: talk-diagram
---

# 開発における2つの領域

<div class="dbody" style="gap:1.4rem;">
  <ul>
    <li>ファジー＝揺れが残り、同じ入力が必ずしも同じ結果とならない領域</li>
    <li>決定論的＝同じ入力なら同じ結果になる領域</li>
  </ul>
  <div class="flex items-stretch justify-center gap-5">
    <div class="dcol">
      <div class="dtag dtag--reuse">ファジー</div>
      <div class="dbox dbox--soft dbox--sm" style="width:12rem;height:5.2rem;white-space:normal;line-height:1.4;">
        人間とAIが<br>探索・判断する
      </div>
    </div>
    <div class="dcol">
      <div class="dtag dtag--bun">決定論的</div>
      <div class="dbox dbox--sm" style="width:12rem;height:5.2rem;white-space:normal;line-height:1.4;">
        プログラムで<br>自動化・定式化する
      </div>
    </div>
  </div>
  <div class="dcaption" style="margin-top:0.4rem;">

> ファジーな領域が残ることは受け入れつつ、決定論的に扱える領域を増やす

  </div>
</div>

---
layout: talk-diagram
---

# OSS開発を通じてのアプローチ

<div class="flex flex-col items-center" style="gap:0.5rem;">
  <div class="prow">
    <div class="dbox dbox--sm pbox">並行作業の衝突を防ぐ</div>
    <div class="darrow">→</div>
    <span class="dtag dtag--bun ptool">git-kura</span>
  </div>
  <div class="prow">
    <div class="dbox dbox--sm pbox">コードを生成するコード</div>
    <div class="darrow">→</div>
    <span class="dtag dtag--bun ptool">installerer</span>
  </div>
  <div class="prow">
    <div class="dbox dbox--sm pbox">入出力特化のE2E</div>
    <div class="darrow">→</div>
    <span class="dtag dtag--bun ptool">reportage</span>
  </div>
</div>

<div class="dcaption" style="margin-top:0; padding:0; flex:0;">

> ファジーな領域を減らす + 人間が注意を払う範囲を限定するためのOSS開発

</div>

<style scoped>
.prow { display: flex; align-items: center; gap: 0.9rem; }
.prow .pbox { width: 26rem; justify-content: flex-start; text-align: left; padding-left: 1rem; white-space: normal; }
.prow .ptool { width: 8.5rem; text-align: center; flex: 0 0 auto; font-size: 1rem; }
.prow .darrow { flex: 0 0 auto; }
</style>

---
layout: talk-content
---

# reportage : 入出力特化のE2Eテスト

<v-clicks>

- 入出力を実装言語から独立して検証する
- 標準出力・エラー出力・終了コード・ファイルの検証に特化
- AIが内部実装を頻繁に変えるほど、外部から見た挙動を固定する価値が上がる

</v-clicks>

<div v-click class="mt-2">

> 詳細ではなく、観測可能な振る舞いの検証に焦点を当てる

> 人間は、観測可能な振る舞いへ重点的に注意を向ける

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
layout: talk-diagram
---

# reportage : 実際のコード例

![reportage](./assets/oss/reportage.png){style="width:auto; height:400px; margin:auto;"}

---
layout: talk-content
---

# git-kura : 並行作業の衝突検知

<v-clicks>

- worktree を作業単位として分離
- 変更対象のファイルを明示的に宣言させる
- 競合を機械的に検出し、非ゼロ終了でAIの処理を止める
- コンフリクト発生後ではなく、編集・コミット前に止める

</v-clicks>

<div v-click>

> AIの出力・作業内容は揺れても、作業領域と競合状態は機械的に判定する

</div>

<!--
AIが活動する環境を決定論的に管理する。
worktree＝同じGitリポジトリから複数の独立した作業場所を作る仕組み。
git-kuraは要求仕様そのものの曖昧さは解消しない。
-->

---
layout: talk-diagram
---

# git-kura : 実際の衝突ログ

![git-kura](./assets/oss/git-kura.png){style="width:auto; height:400px; margin:auto;"}

---
layout: talk-content
---

# installerer : installerの機械的生成

<v-clicks>

- install.sh をAIから生成すると、入力規約や出力結果がブレる可能性
  - 結果を安定して保障できない
- install.sh を生成するためのツール = `installerer` を、AIを使って作成
- `installerer` は、同じ入力には常に同じ shell script を生成する

</v-clicks>

<div v-click>

> コードではなく、コードを作るコードをAIで作る

> コードによるコード生成結果は安定して検証可能

</div>

<!--
install.sh を CLI ごとに書くのが面倒だった。
毎回書く代わりに、配布の規約（資産の命名やチェックサム）を入力として宣言し、installerer で install.sh を生成する。
installerer 自身が生成器で、その正しさは reportage の E2E で確かめる。
「毎回 AI に書かせず、決定論的に生成する」位置づけ。
-->

---
layout: talk-diagram
---

# installerer : web UI

![installerer](./assets/oss/installerer.png){style="width:auto; height:450px; margin:auto;"}

---
layout: talk-diagram
---

# 3つを統合するモデル

<div class="flex flex-col items-center" style="gap:0.35rem;">
  <div v-click class="dbox dbox--soft dbox--sm" style="width:27rem;">曖昧な要求を、人間とAIで探索する</div>
  <div class="darrow" style="font-size:1.3rem;">↓</div>
  <div v-click class="dstage">
    <div class="dbox dbox--sm" style="width:27rem;">
      作業の制約を明示
      <span class="dtag dtag--bun" style="margin-left: 1rem;">git-kura</span>
    </div>
  </div>
  <div class="darrow" style="font-size:1.3rem;">↓</div>
  <div v-click class="dstage">
    <div class="dbox dbox--sm" style="width:27rem;">
      安定した結果を得る仕組み作り
      <span class="dtag dtag--bun" style="margin-left: 1rem;">installerer</span>
    </div>
  </div>
  <div class="darrow" style="font-size:1.3rem;">↓</div>
  <div v-click class="dstage">
    <div class="dbox dbox--sm" style="width:27rem;">
      外部挙動の重点的検証
      <span class="dtag dtag--bun" style="margin-left: 1rem;">reportage</span>
    </div>
  </div>
</div>

<div v-click class="dcaption" style="margin-top:1rem;">

> 制約を明示し、結果を安定させ、外部契約に注力する

</div>

<style scoped>
.dstage { display: flex; align-items: center; gap: 0.8rem; }
.dstage .dtag { width: 6.5rem; text-align: center; flex: 0 0 auto; }
</style>

<!--
3つを個別のツールではなく、1本の流れの各層として見せる。
-->

---
layout: talk-content
---

# これまでとこれから

<v-clicks>

- （これまで）AIにより、開発速度と並行性は向上した
  - 問題の中心は、実装よりも並行実装・委任範囲・生成結果の不確実性へ
- （これから）ファジーな領域と決定論的な領域を分離し、後者を検証可能にする
- ファジーな領域は無くせないことを前提に、いかに決定論的領域に寄せ、注力すべき範囲を絞るか
  - AIの登場により、現実的な範囲になってきた？

</v-clicks>

<div v-click class="mt-3">

> AIを前提としつつ、検証可能・把握可能な仕組みを構築する開発へ

</div>

---
layout: talk-content
---

# これから作りたいもの

<v-clicks>

- 仕様の記述に形式手法を取り入れたい
- 形式手法で証明された仕様と、実装・テストの対応関係がネック
- 仕様-テスト（戦略、設計、ケース）-E2E実装を紐づけるツールを作る？
  - それぞれのartifactをnominal typeと見なして、リンクさせる
  - 関連付けが保証された仕様・テスト・E2E実装
- 仕様、テスト、E2E実装を見れば「OK」と判断できる環境づくりが目標

</v-clicks>

<!--
イベントの「これから」に接続する。
「もっと任せる」を目的化せず、境界を作ることを目的にする。
-->
