<template>
  <div class="slidev-layout talk-diagram">
    <slot />
    <PageNumber />
  </div>
</template>

<style>
.slidev-layout.talk-diagram {
  position: absolute;
  inset: 0;
  padding: 0;
  background: #f4f4f5;
  color: #5c5c5c;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  position: relative;
}

/* 上部の細い青ヘッダー帯（番号付きタイトル） */
.talk-diagram > h1 {
  flex: 0 0 auto;
  height: 15%;
  min-height: 15%;
  margin: 0;
  padding: 0 3rem;
  display: flex;
  align-items: center;
  background: #4a86e8;
  color: #ffffff;
  font-weight: 700;
  font-size: 1.6rem;
  letter-spacing: 0.01em;
  box-shadow: 0 6px 10px -8px rgba(0, 0, 0, 0.28);
}

/* 図の領域 */
.talk-diagram > :not(h1) {
  flex: 1 1 auto;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 100%;
  padding: 1.2rem 2rem;
}
.talk-diagram p {
  margin: 0;
}
.talk-diagram strong {
  color: #3a6fd0;
}

/* 図の部品 */
.talk-diagram .dbox {
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  background: #ffffff;
  border: 1.5px solid #d2d7e0;
  border-radius: 10px;
  padding: 0.7rem 1.15rem;
  font-weight: 600;
  font-size: 1.2rem;
  color: #4b4b4b;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.06);
  white-space: nowrap;
}
.talk-diagram .dbox--accent {
  background: #4a86e8;
  border-color: #4a86e8;
  color: #ffffff;
}
.talk-diagram .dbox--soft {
  background: #eef2fb;
  border-color: #b7c8ec;
  color: #35507f;
}
.talk-diagram .dbox--sm {
  font-size: 1rem;
  padding: 0.5rem 0.8rem;
}
.talk-diagram .darrow {
  color: #9aa3b2;
  font-size: 1.7rem;
  line-height: 1;
  flex: 0 0 auto;
}
.talk-diagram .dtag {
  font-size: 0.85rem;
  font-weight: 700;
  letter-spacing: 0.02em;
  padding: 0.15rem 0.6rem;
  border-radius: 999px;
}
.talk-diagram .dtag--bun {
  background: #e5efff;
  color: #2f66c8;
  border: 1px solid #b7ceff;
}
.talk-diagram .dtag--reuse {
  background: #eeeeee;
  color: #666666;
  border: 1px solid #d4d4d4;
}
.talk-diagram .dcaption {
  margin-top: 1.6rem;
  font-size: 1.12rem;
  color: #666666;
  text-align: center;
}
</style>
