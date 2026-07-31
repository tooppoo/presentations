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
  background: var(--talk-bg);
  color: var(--talk-text);
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
  background: var(--talk-primary);
  color: var(--talk-on-primary);
  font-weight: 700;
  font-size: 1.6rem;
  letter-spacing: 0.01em;
  box-shadow: var(--talk-shadow-header-slim);
}

/* 図の領域 */
.talk-diagram > :not(h1):not(.page-number) {
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
  color: var(--talk-primary-strong);
}

/* 図の部品 */
.talk-diagram .dbox {
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  background: var(--talk-surface);
  border: 1.5px solid var(--talk-border);
  border-radius: 10px;
  padding: 0.7rem 1.15rem;
  font-weight: 600;
  font-size: 1.2rem;
  color: var(--talk-text-strong);
  box-shadow: var(--talk-shadow-box);
  white-space: nowrap;
}
.talk-diagram .dbox--accent {
  background: var(--talk-primary);
  border-color: var(--talk-primary);
  color: var(--talk-on-primary);
}
.talk-diagram .dbox--soft {
  background: var(--talk-surface-soft);
  border-color: var(--talk-border-soft);
  color: var(--talk-soft-text);
}
.talk-diagram .dbox--sm {
  font-size: 1rem;
  padding: 0.5rem 0.8rem;
}
.talk-diagram .darrow {
  color: var(--talk-arrow);
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
  background: var(--talk-tag-accent-bg);
  color: var(--talk-tag-accent-text);
  border: 1px solid var(--talk-tag-accent-border);
}
.talk-diagram .dtag--reuse {
  background: var(--talk-tag-neutral-bg);
  color: var(--talk-tag-neutral-text);
  border: 1px solid var(--talk-tag-neutral-border);
}
.talk-diagram .dcaption {
  margin-top: 1.6rem;
  font-size: 1.15rem;
  color: var(--talk-text-caption);
  text-align: center;
}
.talk-diagram blockquote {
  font-size: 1.16rem;
}
</style>
