
export path:
  pnpm export --format pdf --output export/{{ path }} {{ path }}

build path:
  pnpm build --output dist/ {{ path }}
