<template>
  <div class="slidev-layout talk-content">
    <slot />
    <div class="talk-content__pageno"><SlideCurrentNo /></div>
  </div>
</template>

<style>
.slidev-layout.talk-content {
  position: absolute;
  inset: 0;
  padding: 0;
  background: #f4f4f5;
  color: #5c5c5c;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

/* 上部の青ヘッダー帯（最初の見出しを帯にする） */
.talk-content > h1 {
  flex: 0 0 auto;
  height: 30%;
  margin: 0;
  padding: 0 3.4rem;
  display: flex;
  align-items: center;
  background: #4a86e8;
  color: #ffffff;
  font-weight: 700;
  font-size: 2.1rem;
  letter-spacing: 0.01em;
  box-shadow: 0 7px 12px -8px rgba(0, 0, 0, 0.28);
}

/* 本文領域 */
.talk-content > :not(h1):not(.talk-content__pageno) {
  padding-left: 3.4rem;
  padding-right: 3.4rem;
}
.talk-content > :not(h1):first-of-type,
.talk-content > h1 + * {
  margin-top: 1.7rem;
}

.talk-content ul {
  list-style: none;
  padding: 0;
  margin: 0;
}
.talk-content ul li {
  position: relative;
  padding-left: 1.5rem;
  margin: 0.58em 0;
  font-size: 1.4rem;
  line-height: 1.5;
  color: #5c5c5c;
}
/* レベル1: 丸 bullet */
.talk-content ul li::before {
  content: "";
  position: absolute;
  left: 0.1rem;
  top: 0.62em;
  width: 0.5rem;
  height: 0.5rem;
  border-radius: 50%;
  background: #6b6b6b;
}
/* レベル2: 白抜きの丸、やや小さく淡く */
.talk-content ul ul {
  margin: 0.3em 0 0.3em 0.4rem;
}
.talk-content ul ul li {
  font-size: 1.2rem;
  color: #7a7a7a;
  margin: 0.42em 0;
}
.talk-content ul ul li::before {
  background: transparent;
  border: 1.5px solid #8a8a8a;
  width: 0.45rem;
  height: 0.45rem;
  top: 0.55em;
}

.talk-content p {
  font-size: 1.32rem;
  line-height: 1.6;
  margin: 0.7em 0;
}
.talk-content strong {
  color: #3a6fd0;
  font-weight: 700;
}
.talk-content blockquote {
  border-left: 4px solid #9db8e8;
  background: #eef2fb;
  color: #4f4f4f;
  margin: 0.8em 0;
  padding: 0.55em 1.1em;
  font-size: 1.16rem;
  line-height: 1.55;
}
.talk-content code {
  background: #e7e9ee;
  color: #365; /* fallback */
  border-radius: 4px;
  padding: 0.08em 0.35em;
  font-size: 0.92em;
}
.talk-content pre {
  border-radius: 8px;
  font-size: 0.95rem;
  margin: 0.6em 0;
}
.talk-content__pageno {
  position: absolute;
  right: 14px;
  bottom: 8px;
  font-size: 0.8rem;
  color: #9a9a9a;
}
</style>
