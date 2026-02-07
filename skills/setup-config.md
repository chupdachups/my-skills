# setup-config

프로젝트 설정 파일들을 생성하는 skill입니다.

## 설명

이 skill은 프로젝트 생성 파이프라인의 네 번째 단계입니다. Vite 설정, ESLint, Git 관련 설정 파일들을 생성합니다.

## 지시사항

1. `.project-config.json` 파일을 읽어 프로젝트 설정을 확인하세요.

2. 프로젝트 폴더 내에 다음 설정 파일들을 생성하세요:

   **vite.config.js (프레임워크별):**

   React:
   ```javascript
   import { defineConfig } from 'vite'
   import react from '@vitejs/plugin-react'

   export default defineConfig({
     plugins: [react()],
     server: { port: 3000 }
   })
   ```

   Vue:
   ```javascript
   import { defineConfig } from 'vite'
   import vue from '@vitejs/plugin-vue'

   export default defineConfig({
     plugins: [vue()],
     server: { port: 3000 }
   })
   ```

   Svelte:
   ```javascript
   import { defineConfig } from 'vite'
   import { svelte } from '@sveltejs/vite-plugin-svelte'

   export default defineConfig({
     plugins: [svelte()],
     server: { port: 3000 }
   })
   ```

3. **.gitignore 생성:**
   ```
   node_modules/
   dist/
   .env
   .env.local
   *.log
   .DS_Store
   ```

4. **.eslintrc.json 생성:**
   ```json
   {
     "env": { "browser": true, "es2022": true, "node": true },
     "extends": ["eslint:recommended"],
     "parserOptions": { "ecmaVersion": "latest", "sourceType": "module" }
   }
   ```

5. **백엔드 포함 시 .env.example 생성:**
   ```
   PORT=4000
   NODE_ENV=development
   DATABASE_URL=
   ```

6. 완료되면 "설정 파일이 생성되었습니다. 기본 컴포넌트를 생성합니다." 라고 알리세요.

7. **반드시 다음 skill을 호출하세요: `/create-components`**

## 예시

```
[/setup-config 호출됨]
Claude: 설정 파일들을 생성합니다...
Claude: vite.config.js, .gitignore, .eslintrc.json 생성 완료
Claude: 설정 파일이 생성되었습니다. 기본 컴포넌트를 생성합니다.
[/create-components 호출]
```
