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
- AIにレビューさせる時、特定観点からのレビューを指示できる

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

# Skill/Agent再利用の問題

<v-clicks>

- 便利で汎用的なものほど、他のプロジェクトでも欲しくなる
  - i.e. レビューループ、衝突の検出はプロジェクト非依存
- プロジェクト固有ではないSkill/Agentsが溜まっていく

</v-clicks>

<div v-click class="mt-3">

> プロジェクト固有ではないSkill/Agentをどうやって共有するか

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

# コピー&ペースト

---
layout: talk-content
---

# コピー&ペーストの問題点

- `.claude/skills/` や `.codex/skills` を、そのまま別のリポジトリへコピーする
- 一番簡単な方法だが、リポジトリが増えるたびにコピーが増える
- 片方の skill を改善しても、もう片方は古いまま
  - 「同じ名前の skill が、リポジトリごとに違う挙動をする」がありうる
- どれが原本なのか分からなくなる

---
layout: talk-step
step: 2
---

# ユーザーディレクトリ

---
layout: talk-content
---

# ユーザーディレクトリにskill/agentを配置

<v-clicks>

- `~/.claude/skills/` など、ユーザーディレクトリ以下に配置する
- 大抵のAIエージェントは、ユーザーディレクトリ以下のskill/agent定義も参照してくれる
- これで解決するケースも多そうではあるが、問題もある
  - 各プロジェクトがどのskill/agentを前提にしているか、わからなくなる
  - devcontainer等、隔離技術との相性が微妙（後述）

</v-clicks>

<!--
素直な解決策。
実際これで済む人は多いはずで、自分も最初はこれを試した。
-->

---
layout: talk-content
---

# AI エージェントと devcontainer

<v-clicks>

- devcontainerを用意し、devcontainer内部でAIエージェントを実行
- 作業をコンテナに閉じ込め、壊れても rebuild すれば元に戻るようにしている
  - たまに見かける「AIエージェントがプロジェクト外の重要なファイルを壊してしまった」など
- 予期せぬ事故が起きうる前提で、取り返しがつく状態を先に作っておきたい

</v-clicks>

---
layout: talk-content
---

# devcontainerとユーザーディレクトリの壁

<v-clicks>

- コンテナの中から、ホストのユーザーディレクトリは見えない
- マウントすれば見えるが……
  - 隔離の境界が薄くなる
  - プロジェクト外のディレクトリ構成に依存

</v-clicks>

---
layout: talk-diagram
---

# 境界の内と外

<div class="flex flex-col items-center" style="gap:1.8rem;">
  <div class="flex items-center justify-center gap-8">
  <div class="zone">
      <div class="ztitle">devcontainer</div>
      <div class="dbox dbox--accent">AI エージェント</div>
    </div>
    <div class="dcol">
      <div class="darrow">→</div>
      <div class="dnote">見えない</div>
    </div>
    <div class="zone">
      <div class="ztitle">ホスト</div>
      <div class="dbox dbox--soft">~/.claude/skills</div>
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

---
layout: talk-content
---

# skill/agent共有のために欲しかったもの

<v-clicks>

- 定義の原本は、一箇所だけ
- 各プロジェクトには、どれを使うかの宣言だけを置く
- 原本更新の反映は、コマンド一発で済む
- skill/agentの実体は、いつでも再取得・再配置できる（rebuildできる）

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
- 名前は「役小角：という修験者から。鬼を使役したとされる逸話。
- 今のところ、Claude と Codex に対応している

</v-clicks>

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

---
layout: talk-content
---

# enozunu summon

<v-clicks>

- `enozunu summon` で、宣言的に定義された取得元を解決して展開する
- 解決したコミットは `enozunu.lock.json` に記録され、別のマシンでも同じものが展開される

</v-clicks>

<div v-click class="mt-3">

> 更新の反映はコピー作業からコマンド一回へ
> 
> プロジェクトの前提となるskill/agentは宣言的に定義される

</div>

<!--
lock ファイルがあるので、branch 指定でも他のマシンで同じものが展開される。
追従したいときは --update を付けて lock を更新する。
CI では --frozen を付けて、lock に無いものを取りに行かせないようにしている。
-->

---
layout: talk-content
---

# 変わったこと

<v-clicks>

- `.claude` や `.codex`を丸ごと `.gitignore` に入れるようになった
  - 展開されたファイルは生成物なので、リポジトリに置く理由がない
  - 消しても `summon` で戻る
- skill と agent の定義は、専用のリポジトリで一元管理するようになった
  - 各プロジェクトが原本を指すので、同期の仕組みはそもそも要らなくなった
- 宣言定義だけをコピーして再利用している

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
- ベースを一箇所直せば、 `summon` 再実行で反映される

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
- ユーザーディレクトリでの共有も問題が残る
  - プロジェクトの前提となるskill/agentがわからなくなる
  - devcontainer などの隔離と両立しない
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
