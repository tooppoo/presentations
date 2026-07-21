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

# Bun ではじめる standalone CLI

hokkaido.js

2026-07-21

@Philomagi

---
layout: talk-content
---

# 発表者

<v-clicks>

- @Philomagi
- WEB系プログラマ
- 自称フロントエンド寄り
- 最近は Rust とか Go とか

</v-clicks>

---
layout: talk-content
---

# 問題提起

<v-clicks>

- TypeScript で CLI は書ける
- でも利用者に Node.js の導入を求めることになる
- CLI の利用者が JavaScript 開発者とは限らない

</v-clicks>

<!--
TypeScript でCLIを書けても、配布した先の利用者にランタイム導入を強いてよいのか、という問い。
-->

---
layout: talk-content
---

# installerer とは

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

# Web UI と CLI は core を共有する

<div class="dbody">
  <div class="flex items-center gap-12">
    <div class="flex flex-col gap-6">
      <div class="dbox">Web UI</div>
      <div class="dbox">CLI（追加）</div>
    </div>
    <div class="darrow s5arrow">→</div>
    <div class="dbox dbox--accent s5core">runtime-neutral<br>shared core</div>
  </div>
  <div class="dcaption">Web UI はそのまま残り、CLI を追加した</div>
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

# CLI で狙うこと

<v-clicks>

- ブラウザを開かずターミナルから使えるようにする
- JavaScript runtime を利用者に管理させない
- GitHub Releases から一般的な CLI として配る
- Homebrew や Scoop などへ接続しやすくする
- installerer 自身が生成した `install.sh` で配布する

</v-clicks>

---
layout: talk-content
---

# Bun で single binary 化

<v-clicks>

- `bun build --compile` で single binary を生成
- 利用者側の Node.js や Bun が不要になる
  - 正確には「利用者が runtime を別途管理しなくてよい」

</v-clicks>

<!--
runtimeが消えるのではなく、利用者側の管理コストが消える。
-->

---
layout: talk-content
---

# 最小例

```bash {1-2}
bun build --compile \
  --target=bun-linux-x64-baseline \
  --outfile=installerer \
  packages/cli/src/node/main.ts
```

生成された binary をそのまま実行する。

```bash
./installerer --version
```

<div class="text-1.05rem text-#8a8a8a mt-5">※ ライブデモは行わず、コマンドと結果のみ示す</div>

<style scoped>
.talk-content > :not(h1):first-of-type { margin-top: 2.4rem; }
</style>

---
layout: talk-content
---

# なぜ Bun か

<v-clicks>

- 既にリポジトリで package manager / test runner / build tool として使用
- TypeScript を直接 entry point にできる
- Go や Rust との優劣を主張したいわけではない

</v-clicks>

<div v-click>

> 既に Bun を使う TypeScript プロジェクトなら、single binary CLI を既存 toolchain の延長として追加できる

</div>

---
layout: talk-content
---

# 2つの runtime を混同しない

<v-clicks>

- **shared core の runtime-neutrality**
  - Node.js / Bun / ブラウザ固有 API に依存しない
- **配布 binary の runtime 不要性**
  - Bun runtime は binary の中に同梱される
  - 利用者が別途インストール・管理する必要がない
- npm 版は Node.js CLI なので runtime 非依存ではない

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
      <div class="dbox dbox--sm">Node.js で実行</div>
      <div class="dtag dtag--reuse mt-1">補助チャネル</div>
    </div>
    <div class="flex flex-col items-center gap-2">
      <div class="darrow">↓</div>
      <div class="dbox dbox--sm">Bun compile</div>
      <div class="darrow">↓</div>
      <div class="dbox dbox--accent dbox--sm">standalone binary</div>
      <div class="dtag dtag--bun mt-1">カノニカルな配布物</div>
    </div>
  </div>
</div>

---
layout: talk-diagram
---

# compile の先にあるもの

<div class="dbody" style="gap:0.55rem;">
  <div class="s12row flex items-center justify-start gap-3">
    <span class="dtag dtag--bun" style="width:9.5rem;text-align:center;">Bun 固有</span>
    <div class="dbox dbox--sm">TypeScript</div>
    <div class="darrow">→</div>
    <div class="dbox dbox--sm">bun build --compile</div>
    <div class="darrow">→</div>
    <div class="dbox dbox--accent dbox--sm">target 別 binary</div>
  </div>
  <div class="darrow" style="font-size:1.5rem;">↓</div>
  <div class="s12row flex items-center justify-start gap-3">
    <span class="dtag dtag--reuse" style="width:9.5rem;text-align:center;">reusable workflow</span>
    <div class="dbox dbox--sm">native runner 確認</div>
    <div class="darrow">→</div>
    <div class="dbox dbox--sm">archive + checksum</div>
    <div class="darrow">→</div>
    <div class="dbox dbox--sm">GitHub Releases</div>
    <div class="darrow">→</div>
    <div class="dbox dbox--sm">install.sh</div>
  </div>
  <div class="dcaption" style="margin-top:1.4rem;">single binary の生成は簡単。その先の配布設計が別途必要になる</div>
</div>

<style scoped>
.talk-diagram .s12row { width: 100%; max-width: 860px; }
.talk-diagram .darrow { color: #9aa3b2; }
</style>

<!--
single binaryの生成は簡単。だがその先の配布設計が別途必要になる。
-->

---
layout: talk-content
---

# release workflow の経緯

<v-clicks>

- multi-runner は Bun の制約から生じたわけではない
- Rust 製 CLI の release で target 別 native runner が必要だった
- その release を reusable workflow として共通化した
- Bun 製 CLI も同じ workflow に載せた

</v-clicks>

<div v-click>

> cross-platform release の複雑性を、各 repository から共通 workflow へ局所化した

</div>

---
layout: talk-content
---

# trade-off

<div class="flex flex-col items-center gap-2 mt-2 text-1.28rem">
  <div class="dbox dbox--soft" style="background:#eef2fb;border:1.5px solid #b7c8ec;border-radius:10px;padding:0.7rem 1.2rem;color:#35507f;font-weight:600;">利用者側の runtime 依存をなくす</div>
  <div style="font-size:1.8rem;color:#9aa3b2;">↕</div>
  <div class="dbox" style="background:#fff;border:1.5px solid #d2d7e0;border-radius:10px;padding:0.7rem 1.2rem;color:#4b4b4b;font-weight:600;">runtime 同梱で binary は大きくなりやすい</div>
</div>

<div v-click class="text-center mt-6 text-1.15rem text-#666">
欠点として隠さず、trade-off として示す
</div>

---
layout: talk-content
---

# まとめ

<v-clicks>

- single binary の生成自体は比較的簡単
- その先の配布設計（target 別 binary / archive / checksum / smoke test）が本題
- 複雑性は reusable workflow へ局所化できる

</v-clicks>

<div v-click class="mt-2">

> Node.js runtime を利用者へ求めたくない場合、Bun single binary は有力な選択肢

</div>

<div v-click class="text-1rem text-#8a8a8a mt-3">
すべての Node.js CLI に対する第一選択とは主張しない
</div>
