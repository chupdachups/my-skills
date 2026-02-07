# add-dependencies

프로젝트 의존성(package.json)을 설정하는 skill입니다.

## 설명

이 skill은 프로젝트 생성 파이프라인의 세 번째 단계입니다. 선택한 프레임워크에 맞는 의존성을 포함한 package.json을 생성합니다.

## 지시사항

1. `.project-config.json` 파일을 읽어 프로젝트 설정을 확인하세요.

2. 프로젝트 폴더 내에 `package.json` 파일을 생성하세요:

   **기본 구조:**
   ```json
   {
     "name": "{project-name}",
     "version": "1.0.0",
     "description": "{description}",
     "type": "module",
     "scripts": {
       "dev": "vite",
       "build": "vite build",
       "preview": "vite preview",
       "test": "vitest"
     }
   }
   ```

3. 프레임워크에 따른 의존성 추가:

   **React:**
   - dependencies: react, react-dom
   - devDependencies: @vitejs/plugin-react, vite, vitest

   **Vue:**
   - dependencies: vue
   - devDependencies: @vitejs/plugin-vue, vite, vitest

   **Svelte:**
   - dependencies: svelte
   - devDependencies: @sveltejs/vite-plugin-svelte, vite, vitest

4. 백엔드 포함 시 추가 의존성:
   - dependencies: express, cors, dotenv
   - devDependencies: nodemon
   - scripts에 `"server": "nodemon server/index.js"` 추가

5. 완료되면 "package.json이 생성되었습니다. 설정 파일을 생성합니다." 라고 알리세요.

6. **반드시 다음 skill을 호출하세요: `/setup-config`**

## 예시

```
[/add-dependencies 호출됨]
Claude: 프레임워크 설정을 확인합니다: React
Claude: package.json을 생성합니다...
Claude: package.json이 생성되었습니다. 설정 파일을 생성합니다.
[/setup-config 호출]
```
