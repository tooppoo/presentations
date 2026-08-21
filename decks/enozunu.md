---
theme: default
title: skill と agent のコピペをやめる
info: |
  ゆるWeb勉強会@札幌 #31 で話す、AI エージェントの skill / agent 定義を
  リポジトリ間で共有するための CLI、enozunu の紹介。
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

# skill と agent の<br>コピペをやめる

::info::

2026-08-22

ゆるWeb勉強会@札幌 #31

<span class="hash">#ゆるWeb札幌</span>

@Philomagi

<style scoped>
  .hash {
    color: var(--talk-on-primary-accent);
    text-decoration: underline;
  }
</style>

<!--
テーマは「最近のお気に入りツール・フレームワーク紹介」。
紹介するのは enozunu という自作の CLI。
ただし前半はツールの話をせず、コピペ運用で詰んだ話をする。
-->

---
src: ./pages/profile.md
---

---
layout: talk-content
---

# skill と agent

<v-clicks>

- AI エージェントに作法を仕込むためのファイル群
  - プロジェクト直下の `.claude/` などに置くと、エージェントが読んでくれる
- **skill**：手順書。「レビューはこう進める」を Markdown で書いておく
- **agent**：役割を絞った下請け。専用の指示と道具を渡して呼び出す

</v-clicks>

<!--
Claude Code や Codex を使っていない人向けに、ここだけ用語を揃える。
要するに、毎回口で説明していた作法をファイルに書き出したもの。
-->

---
layout: talk-content
---

# Skill/Agent導入で嬉しいこと

<v-clicks>

- 修正 → subagent にレビューさせる → 再修正、のループを skill 化
- `git-kura` を使わせる skill で、並行作業の衝突をマージ前に検出
- AIにレビューサせる時、特定観点からのレビューを指示できる

</v-clicks>

<!--
まず順調だった話から入る。
レビューのループは、自分がやらせたい手順をそのまま書いただけのもの。
git-kura のほうは、複数エージェントを並行で走らせたときに同じファイルを触っていないかを先に見る。
どちらも「毎回言うのが面倒だからファイルにした」という動機で書いている。
-->

---
layout: talk-content
---

# 別のリポジトリでも使いたくなる

<v-clicks>

- 便利な作法ほど、他のプロジェクトでも欲しくなる
- レビューのループも衝突の検出も、リポジトリを選ばない

</v-clicks>

<div v-click class="mt-3">

> プロジェクト固有ではない作法が、手元に溜まっていく

</div>

<!--
ここが分岐点。
プロジェクト固有の作法ならその場に置いておけばいい。
共通の作法だと気付いた瞬間に、置き場所の問題が生まれる。
-->

---
layout: talk-step
step: 1
---

# コピペした

`.claude/skills/` を、そのまま次のリポジトリへコピーする

<!--
最初にやったことを正直に言う。
その場では動くし、5秒で終わる。
-->

---
layout: talk-content
---

# その結果

<v-clicks>

- リポジトリが増えるたびにコピーが増える
- 片方の skill を改善しても、もう片方は古いまま
- 同じ名前の skill が、リポジトリごとに違う挙動をする
  - どれが原本なのか分からなくなる

</v-clicks>

<!--
コピーが3つ4つになった頃から、どれを直せばいいのか分からなくなった。
一番効いたのは、レビュー skill を改善したのに別のリポジトリでは古い基準でレビューされる状況。
同じ名前なのに結果が違うので、原因の切り分けに時間を取られる。
-->

---
layout: talk-content
---

# コピペの何が嫌なのか

<v-clicks>

- バージョン管理は、できている
  - 各リポジトリで git 管理されているし、履歴も残る
- 足りないのは**同期の仕組み**。更新を他へ配る手段がコピペしかない

</v-clicks>

<div v-click class="mt-3">

> 版が管理できないのではなく、版を揃える手段がない

</div>

<!--
ここは誤解されやすいので明示的に否定しておく。
git 管理から漏れているわけではない。
各コピーはそれぞれ正しく履歴を持っている。
問題は、それらのあいだに親子関係がないこと。
-->

---
layout: talk-step
step: 2
---

# ユーザーディレクトリに置けばいい

`~/.claude/skills/` なら、全プロジェクトから見える

<!--
素直な解決策。
実際これで済む人は多いはずで、自分も最初はこれを試した。
-->

---
layout: talk-content
---

# AI エージェントは devcontainer の中にいる

<v-clicks>

- 作業をコンテナに閉じ込め、壊れても rebuild すれば元に戻るようにしている
- 予期せぬ事故が起きうる前提で、取り返しがつく状態を先に作っておきたい

</v-clicks>

<div v-click class="mt-3">

> 不便だから使っているのではなく、隔離してほしくて使っている

</div>

<!--
ここで前提を一つ挟む。
エージェントに任せる範囲を広げるほど、想定外の操作が起きる確率は上がる。
それを止める方向ではなく、起きても戻せる方向で対処している。
-->

---
layout: talk-content
---

# 壁

<v-clicks>

- コンテナの中から、ホストのユーザーディレクトリは見えない
- マウントすれば見えるが、それは隔離を薄くすることでもある
- 事故を防ぐための境界が、そのまま skill の共有を塞ぐ

</v-clicks>

<!--
ここが二段目の落差。
devcontainer をやめる、あるいはホームディレクトリをマウントすれば解決はする。
ただしどちらも、事故が起きても戻せるという前提を削る方向の解決になる。
隔離を保ったまま共有したい、というのがここでの要求。
-->

---
layout: talk-diagram
---

# 境界の内と外

<div class="flex flex-col items-center" style="gap:1.8rem;">
  <div class="flex items-center justify-center gap-8">
    <div class="zone">
      <div class="ztitle">ホスト</div>
      <div class="dbox dbox--soft">~/.claude/skills</div>
    </div>
    <div class="dcol">
      <div class="darrow">✕</div>
      <div class="dnote">見えない</div>
    </div>
    <div class="zone">
      <div class="ztitle">devcontainer</div>
      <div class="dbox dbox--accent">AI エージェント</div>
    </div>
  </div>
  <div class="dcaption" style="margin-top:0;">

> 隔離のための境界が、そのまま共有の障害になる

  </div>
</div>

<style scoped>
.zone {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.9rem;
  border: 1.5px dashed var(--talk-border);
  border-radius: 12px;
  padding: 1.4rem 1.8rem;
}
.ztitle {
  font-size: 1rem;
  font-weight: 700;
  letter-spacing: 0.04em;
  color: var(--talk-text-muted);
}
.dcol .darrow { font-size: 3rem; }
.dcol .dnote {
  font-size: 1.2rem;
  font-weight: 700;
  color: var(--talk-text-caption);
}
</style>

<!--
図で見せたいのは、境界が一つあるという事実だけ。
左の資産に右から手が届かない。
-->

---
layout: talk-content
---

# 欲しかったもの

<v-clicks>

- 定義の原本は、一箇所だけ
- 各プロジェクトには、どれを使うかの宣言だけを置く
- 更新の反映は、コマンド一発
- 展開された実体は、捨ててよいものにする

</v-clicks>

<!--
要件として書き出すと4行で済む。
最後の1行が効いていて、実体が捨てられるなら git 管理する理由もなくなる。

質疑で出そうなので補足しておく。
submodule でも近いことはできるが、実体がリポジトリの一部として残るので最後の1行を満たさない。
また、Claude と Codex で置き場所が違うため、取得と配置を分けて書ける形が欲しかった。
-->

---
layout: talk-content
---

# enozunu

<v-clicks>

- 宣言された取得元を、各エージェントのネイティブなパスへ展開する CLI
- 名前は役小角から。鬼を使役したとされる役行者にあやかっている
- Rust 製で、Claude と Codex に対応している

</v-clicks>

<!--
ようやくツールの話。
役割は変換ではなく配置で、取ってきたものをそのまま置くだけ。
URL は最後のスライドに出すので、ここでは読み上げない。
-->

---
layout: talk-content
class: code-xs head-xs
---

# enozunu.kdl

```kdl
enozunu config-version=1 {
  provider {
    skills {
      skill "subagent-review-loop" {
        git {
          url "https://github.com/tooppoo/catalog-agent-tools"
          branch "main"
          path "common/skills/subagent-review-loop"
        }
      }
    }
  }
  consumer {
    claude {
      use-skills "subagent-review-loop"
    }
  }
}
```

<!--
4枚目で話したレビューのループが、この skill にあたる。
provider が「どこから取ってくるか」、consumer が「どれを誰に渡すか」。
取得元は git のほかに gist とローカルパスが書ける。
agent も同じ形で、agents ブロックに宣言する。
このリポジトリの実物では、skill を3つと agent を1つ宣言している。
-->

---
layout: talk-content
---

# enozunu summon

<v-clicks>

- `enozunu summon` で、宣言された取得元を解決して展開する
- 解決したコミットは `enozunu.lock.json` に記録され、別のマシンでも同じものが展開される

</v-clicks>

<div v-click class="mt-3">

> 更新の反映が、コピー作業からコマンド一回になった

</div>

<!--
lock ファイルがあるので、branch 指定でも他のマシンで同じものが展開される。
追従したいときは --update を付けて lock を更新する。
CI では --frozen を付けて、lock に無いものを取りに行かせないようにしている。
-->

---
layout: talk-content
---

# 生成物は gitignore する

<v-clicks>

- `.claude` と `.agents`（Claude と Codex の展開先）を、丸ごと `.gitignore` に入れた
- 展開されたファイルは生成物なので、リポジトリに置く理由がない
- 消しても `summon` で戻る

</v-clicks>

<!--
ここが体験として一番変わったところ。
それまで .claude はレビュー対象の一部だったが、今は見なくてよいものになった。
diff に skill の中身が出てこなくなるだけでも、だいぶ静かになる。
-->

---
layout: talk-content
---

# 変わったこと

<v-clicks>

- skill と agent の定義は、専用のリポジトリで一元管理するようになった
  - 各プロジェクトが原本を指すので、同期の仕組みはそもそも要らなくなった
- 各プロジェクトへは、宣言定義だけをコピーして再利用している

</v-clicks>

<!--
最初に欲しかった「同期の仕組み」は、作らずに済んだ。
参照に変えたので、同期する対象が無くなった。
ただし2行目のとおり、宣言ファイル自体のコピーは残っている。
-->

---
layout: talk-content
---

# これから

<v-clicks>

- 宣言定義のコピーは、まだ手作業のまま残っている
- リモート URL に置いた宣言を、ベースとして継承できるようにしたい
  - `tsconfig.json` の `extends` のイメージ
- ベースを一箇所直せば、宣言を持つ全プロジェクトに効く

</v-clicks>

<!--
構想段階で、まだ実装していない。
skill 本体のコピペは無くなったが、宣言ファイルには同じ問題が一段小さい形で残っている。
同じ手を宣言ファイルにも適用できるはず、というのが今の見立て。
-->

---
layout: talk-content
class: head-xs
---

# まとめ

<v-clicks>

- 共通の作法をコピペで配ると、原本が分からなくなる
- ユーザーディレクトリでの共有は、devcontainer の隔離と両立しない
- 宣言だけを共有し、実体は生成物として捨てられるようにした

</v-clicks>

<div v-click class="repo-link">

<https://github.com/tooppoo/enozunu>

</div>

<style scoped>
.repo-link {
  margin-top: 1.6rem;
}
.repo-link p {
  font-size: 1.8rem;
  font-weight: 700;
}
.repo-link a {
  color: var(--talk-primary-strong);
  border-bottom: 2px solid var(--talk-border-soft);
}
</style>

<!--
skill と agent の管理をスムーズにするための道具として紹介した。
同じ痛みを持っている人がいれば、試してもらえると嬉しい。
質疑のあいだ、この画面を出したままにしておく。
-->
