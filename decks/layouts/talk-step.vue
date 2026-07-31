<script setup>
defineProps({
  // frontmatter の step / time をそのまま受け取る
  step: { type: [Number, String], default: null },
  time: { type: String, default: '' },
})
</script>

<template>
  <div class="slidev-layout talk-step">
    <div class="talk-step__body">
      <div v-if="step !== null" class="talk-step__badge">STEP {{ step }}</div>
      <slot />
      <div v-if="time" class="talk-step__time">目安 {{ time }}</div>
    </div>
    <PageNumber />
  </div>
</template>

<style>
.slidev-layout.talk-step {
  position: absolute;
  inset: 0;
  padding: 0;
  background: var(--talk-bg);
  color: var(--talk-text);
  display: flex;
  overflow: hidden;
}

.talk-step__body {
  width: 100%;
  padding: 0 6%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
}

.talk-step__badge {
  background: var(--talk-primary);
  color: var(--talk-on-primary);
  font-weight: 700;
  font-size: 1.1rem;
  letter-spacing: 0.14em;
  padding: 0.35rem 1.5rem;
  border-radius: 999px;
  box-shadow: var(--talk-shadow-box);
}

.talk-step h1 {
  margin: 1.4rem 0 0;
  color: var(--talk-primary-strong);
  font-weight: 700;
  font-size: 2.6rem;
  line-height: 1.3;
  letter-spacing: 0.01em;
}

.talk-step p {
  margin: 0.9rem 0 0;
  font-size: 1.28rem;
  line-height: 1.6;
  color: var(--talk-text);
}

.talk-step__time {
  margin-top: 2rem;
  font-size: 1rem;
  color: var(--talk-text-subtle);
}
</style>
