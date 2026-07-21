<template>
  <div class="slidev-layout talk-cover">
    <div class="talk-cover__inner">
      <slot />
    </div>
    <div class="talk-cover__corner" />
    <div class="talk-cover__pageno"><SlideCurrentNo /></div>
  </div>
</template>

<style>
.slidev-layout.talk-cover {
  position: absolute;
  inset: 0;
  padding: 0;
  background: #4a86e8;
  color: #ffffff;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  overflow: hidden;
}
.talk-cover__inner {
  width: 100%;
  padding: 0 6%;
}
.talk-cover h1 {
  color: #ffffff;
  font-weight: 700;
  font-size: 3.2rem;
  line-height: 1.25;
  margin: 0 0 2.2rem;
  letter-spacing: 0.01em;
}
.talk-cover p {
  color: rgba(255, 255, 255, 0.92);
  font-size: 1.05rem;
  line-height: 1.9;
  margin: 0;
}
.talk-cover a {
  color: #ffffff;
  border-bottom: 1px solid rgba(255, 255, 255, 0.5);
}
/* 右下の折り返し角 */
.talk-cover__corner {
  position: absolute;
  right: 0;
  bottom: 0;
  width: 90px;
  height: 90px;
  background: rgba(255, 255, 255, 0.14);
  clip-path: polygon(100% 0, 100% 100%, 0 100%);
}
.talk-cover__pageno {
  position: absolute;
  right: 14px;
  bottom: 8px;
  font-size: 0.8rem;
  color: rgba(255, 255, 255, 0.85);
}
</style>
