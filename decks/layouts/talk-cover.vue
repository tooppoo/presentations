<template>
  <div class="slidev-layout talk-cover">
    <div class="talk-cover__inner">
      <div class="talk-cover__space" />
      <div class="talk-cover__caption">
        <slot name="caption" />
      </div>
      <div class="talk-cover__info">
        <slot name="info" />
      </div>
    </div>
    <div class="talk-cover__corner" />
    <PageNumber />
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
.slidev-layout h1 + p {
  /* override */
  margin: 0;
  opacity: 1;
}

.talk-cover__inner {
  height: 100%;
  width: 100%;
  padding: 0 6%;
  display: flex;
  flex-direction: column;
}
.talk-cover__space {
  height: 30%;
}
.talk-cover__caption {
  height: 30%;
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
}
.talk-cover__info {
  height: 40%;
}
.talk-cover h1 {
  color: #ffffff;
  font-weight: 700;
  font-size: 3.2rem;
  line-height: 1.25;
  margin: 0;
  letter-spacing: 0.01em;
}
.talk-cover p {
  color: rgba(255, 255, 255, 0.92);
  font-size: 1.40rem;
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
</style>
