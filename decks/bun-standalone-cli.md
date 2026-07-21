---
theme: default
title: Bun ではじめる standalone CLI
info: |
  hokkaido.js — Bun を使った single binary CLI の配布
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

# Bun ではじめる standalone CLI

::info::

2026-07-21

hokkaido.js vol.07

<span class="hash">#hokkaido_js</span>

@Philomagi

<style scoped>
  .hash {
    color: cyan;
    text-decoration: underline;
  }
</style>

---
layout: talk-content
---

# 発表者

- @Philomagi
- WEB系プログラマ
- 自称フロントエンド寄り
- 最近は Rust とか Go とか

---
layout: talk-content
---

# 問題提起

<v-clicks>

- TypeScript で CLI を書きたい
- だが、CLIの利用者がJavaScript開発者とは限らない
- 利用者にNode.jsの導入を求めたくない
- 自作ツール `installerer` を題材に考えてみる

</v-clicks>

<!--
TypeScript でCLIを書けても、配布した先の利用者にランタイム導入を強いてよいのか、という問い。
-->

---
layout: talk-content
---

# installerer について

<v-clicks>

- GitHub Releases 向けの `install.sh` を生成するツール
- 当初はブラウザ上の Web UI のみ
- ローカルのターミナルからも使えるよう CLI を追加

</v-clicks>

<!--
まず「何をするツールか」を示す。CLIを追加した、から始めない。
-->

---
layout: talk-diagram
---

# Web UI / CLI / core の関係

<div class="dbody">
  <div class="flex items-center gap-12">
    <div class="flex flex-col gap-6">
      <div class="dbox">Web UI</div>
      <div class="dbox">CLI（追加）</div>
    </div>
    <div class="darrow s5arrow">→</div>
    <div class="dbox dbox--accent s5core">shared core<br>（ランタイム中立）</div>
  </div>
  <div class="dcaption">Web UI はそのまま、CLI を追加</div>
</div>

<style scoped>
.talk-diagram .dbox { font-size: 1.5rem; padding: 1rem 1.7rem; }
.talk-diagram .s5core { padding: 1.4rem 1.9rem; line-height: 1.4; }
.talk-diagram .s5arrow { font-size: 2.6rem; }
.talk-diagram .dcaption { font-size: 1.32rem; margin-top: 2.4rem; }
</style>

<!--
「WebアプリをCLIへ変換した」「移行した」ではない。共有coreの上に両方が乗る。
-->

---
layout: talk-content
---

# CLI 版で目指したこと

<v-clicks>

- ブラウザを開かずターミナルから使えるようにする
- JavaScript runtime を利用者に強制しない
  - installererのユースケースは、Node.js固有でないため
- GitHub Releases から一般的な CLI として配る
- installerer CLIを、自身が生成した `install.sh` で配布する

</v-clicks>

---
layout: talk-content
---

# Bun で single binary 化

<v-clicks>

- `bun build --compile` で single binary を生成
- 利用者側の Node.js や Bun が不要になる
  - 正確には「利用者が runtime を別途管理しなくてよい」
- Node.js開発者でなくても、 installerer を使える

</v-clicks>

<!--
runtimeが消えるのではなく、利用者側の管理コストが消える。
-->

---
layout: talk-content
---

# single binary生成例

```bash
bun build --compile \
  --target=bun-linux-x64-baseline \
  --outfile=installerer \
  packages/cli/src/node/main.ts

./installerer --version
```

<v-clicks>

- `--compile` で single binary を生成
- `--target` で対象とするOS・アーキテクチャを指定できる

</v-clicks>

---
layout: talk-content
---

# なぜ Bun か

<v-clicks>

- 元々 package manager / test runner / build tool として使用していた
- 元々Web用に作っていたロジックを、そのままCLIと共有できる
- TypeScript を直接 entry point にして、 single binary を生成できる

</v-clicks>

<div v-click>

> Bun を使う TypeScript プロジェクトなら、single binary CLI を既存 toolchain の延長として追加しやすい

</div>

---
layout: talk-content
---

# runtime との距離

<v-clicks>

- **shared core はランタイム中立**
  - 共通のコア部分は Node.js / Bun / ブラウザ固有 API に依存しない
- **配布 binary は別途 runtime を求めない**
  - Bun runtime は binary の中に同梱される
  - 利用者が `installerer` のためだけに runtime を入れなくて良い
- npm 版は Node.js CLI として作る = Node.js runtime 前提
  - npm を使っているから、Node.js runtime を前提にして問題ない
  - runtime 同梱を回避

</v-clicks>

---
layout: talk-diagram
---

# npm 版との関係

<div class="flex flex-col items-center gap-3">
  <div class="dbox dbox--soft">CLI source（Node.js 互換 entry point）</div>
  <div class="flex items-start justify-center gap-10 mt-1">
    <div class="flex flex-col items-center gap-2">
      <div class="darrow">↓</div>
      <div class="dbox dbox--sm">bundle → npm package</div>
      <div class="darrow">↓</div>
      <div class="dbox dbox--sm">Node.js script</div>
      <div class="dtag dtag--reuse mt-1">補助の配布ルート</div>
    </div>
    <div class="flex flex-col items-center gap-2">
      <div class="darrow">↓</div>
      <div class="dbox dbox--sm">Bun compile</div>
      <div class="darrow">↓</div>
      <div class="dbox dbox--accent dbox--sm">standalone binary</div>
      <div class="dtag dtag--bun mt-1">メインの配布ルート</div>
    </div>
  </div>
</div>

---
layout: talk-diagram
---

# single binaryの配布ルート

<div class="dbody" style="gap:0.7rem;">

  <div class="s12panel">
    <div class="s12panel__title">target 別に native runner で実行</div>
    <div class="flex items-center justify-center gap-2 flex-wrap">
      <div class="dbox dbox--accent dbox--sm s12build">
        <span>bun build --compile</span>
        <span class="s12badge">Bun 固有</span>
      </div>
      <div class="darrow">→</div>
      <div class="dbox dbox--sm">target 別 binary</div>
      <div class="darrow">→</div>
      <div class="dbox dbox--sm">archive (tar.gz)</div>
      <div class="darrow">→</div>
      <div class="dbox dbox--sm">sha256 checksum</div>
    </div>
  </div>

  <div class="darrow" style="font-size:1.4rem;">↓</div>

  <div class="s12row flex items-center justify-center gap-3">
    <div class="dbox dbox--sm s12col">release.yml</div>
    <div class="darrow">→</div>
    <div class="dbox dbox--sm s12col">GitHub Release<span class="s12sub">archive + checksum</span></div>
    <div class="darrow">→</div>
    <div class="dbox dbox--sm">install.sh で導入</div>
    <div class="darrow">→</div>
    <div class="dbox dbox--sm">binaryを<br>GitHub Releaseから<br>ダウンロード</div>
  </div>

  <div class="dcaption" style="margin-top:1.2rem;">Bun 固有は build script のみ</div>
</div>

<style scoped>
.talk-diagram .s12panel {
  border: 1.5px dashed #b7ceff;
  background: #f5f9ff;
  border-radius: 12px;
  padding: 0.9rem 1.1rem 1rem;
}
.talk-diagram .s12panel__title {
  font-size: 0.95rem;
  color: #2f66c8;
  font-weight: 700;
  text-align: center;
  margin-bottom: 0.7rem;
}
.talk-diagram .s12build { flex-direction: column; gap: 0.15rem; line-height: 1.25; padding: 0.6rem 1rem; }
.talk-diagram .s12col { flex-direction: column; gap: 0.05rem; line-height: 1.2; }
.talk-diagram .s12sub {
  display: block;
  font-size: 0.82rem;
  font-weight: 400;
  opacity: 0.9;
}
.talk-diagram .s12badge {
  display: inline-block;
  margin-top: 0.2rem;
  font-size: 0.72rem;
  font-weight: 700;
  background: #ffffff;
  color: #2f66c8;
  border-radius: 999px;
  padding: 0.05rem 0.5rem;
}
.talk-diagram .s12row { width: 100%; max-width: 820px; }
.talk-diagram .darrow { color: #9aa3b2; }
.talk-diagram .dbox .s12sub { color: #7a7a7a; }
</style>

<!--
Bun固有なのはbuild scriptまで。target別runner・archive・checksum・smoke testは言語非依存のreusable workflowへ委譲した。
GitHub Releaseの公開はrelease.ymlのpublishジョブ、smoke testはwf-installer-smoke-test（CIでinstall.shを検証）。
-->

---
layout: talk-content
---

# トレードオフ

<div class="flex flex-col items-center gap-2 mt-2 text-1.28rem">
  <div class="dbox dbox--soft" style="background:#eef2fb;border:1.5px solid #b7c8ec;border-radius:10px;padding:0.7rem 1.2rem;color:#35507f;font-weight:600;">利用者側の runtime 依存をなくす</div>
  <div style="font-size:1.8rem;color:#9aa3b2;">↕</div>
  <div class="dbox" style="background:#fff;border:1.5px solid #d2d7e0;border-radius:10px;padding:0.7rem 1.2rem;color:#4b4b4b;font-weight:600;">runtime 同梱で binary は大きくなりやすい</div>
</div>

<v-clicks>

- 配布時のサイズを取るか、可搬性を取るか
- 基本は single binary で配布、サイズを最小化したいなら npm 経由、という棲み分けもあり得るかも

</v-clicks>

---
layout: talk-content
---

# まとめ

<v-clicks>

- Bunを使うと、single binary の生成自体は比較的簡単
- single binary とのトレードオフとして、バイナリ本体のサイズ増大がある

</v-clicks>

<div v-click class="mt-2">

> Node.js runtime を利用者へ強制したくない場合、Bun single binary は有力な選択肢

</div>
