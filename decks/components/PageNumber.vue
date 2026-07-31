<template>
  <div class="page-number">
    <SlideCurrentNo /> / <SlidesTotal />
  </div>
</template>

<style scoped>
/*
 * ルート要素自体を absolute にする。
 * レイアウト側は直下の子に flex を効かせているため、
 * ここが通常フローに残ると縦方向のスペースを取ってしまう。
 */
.page-number {
  position: absolute;
  right: 14px;
  bottom: 8px;
  font-size: 0.8rem;
  color: var(--talk-page-number);
}
</style>
