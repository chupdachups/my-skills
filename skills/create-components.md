# create-components

기본 컴포넌트와 진입점 파일을 생성하는 skill입니다.

## 설명

이 skill은 프로젝트 생성 파이프라인의 다섯 번째 단계입니다. 프레임워크에 맞는 기본 컴포넌트와 진입점 파일을 생성합니다.

## 지시사항

1. `.project-config.json` 파일을 읽어 프로젝트 설정을 확인하세요.

2. **public/index.html 생성:**
   ```html
   <!DOCTYPE html>
   <html lang="ko">
   <head>
     <meta charset="UTF-8" />
     <meta name="viewport" content="width=device-width, initial-scale=1.0" />
     <title>{project-name}</title>
   </head>
   <body>
     <div id="app"></div>
     <script type="module" src="/src/main.{js|jsx|ts}"></script>
   </body>
   </html>
   ```

3. **프레임워크별 진입점 및 App 컴포넌트 생성:**

   **React (src/main.jsx, src/App.jsx):**
   ```jsx
   // main.jsx
   import React from 'react'
   import ReactDOM from 'react-dom/client'
   import App from './App'
   import './styles/global.css'

   ReactDOM.createRoot(document.getElementById('app')).render(<App />)
   ```
   ```jsx
   // App.jsx
   export default function App() {
     return (
       <div className="app">
         <h1>Welcome to {project-name}</h1>
         <p>{description}</p>
       </div>
     )
   }
   ```

   **Vue (src/main.js, src/App.vue):**
   ```javascript
   // main.js
   import { createApp } from 'vue'
   import App from './App.vue'
   import './styles/global.css'

   createApp(App).mount('#app')
   ```
   ```vue
   <!-- App.vue -->
   <template>
     <div class="app">
       <h1>Welcome to {project-name}</h1>
       <p>{description}</p>
     </div>
   </template>
   ```

   **Svelte (src/main.js, src/App.svelte):**
   ```javascript
   // main.js
   import App from './App.svelte'
   import './styles/global.css'

   const app = new App({ target: document.getElementById('app') })
   export default app
   ```
   ```svelte
   <!-- App.svelte -->
   <div class="app">
     <h1>Welcome to {project-name}</h1>
     <p>{description}</p>
   </div>
   ```

4. **src/styles/global.css 생성:**
   ```css
   * { margin: 0; padding: 0; box-sizing: border-box; }
   body { font-family: system-ui, sans-serif; line-height: 1.6; }
   .app { max-width: 1200px; margin: 0 auto; padding: 2rem; }
   h1 { color: #333; margin-bottom: 1rem; }
   ```

5. **백엔드 포함 시 server/index.js 생성:**
   ```javascript
   import express from 'express'
   import cors from 'cors'
   import dotenv from 'dotenv'

   dotenv.config()
   const app = express()
   const PORT = process.env.PORT || 4000

   app.use(cors())
   app.use(express.json())

   app.get('/api/health', (req, res) => {
     res.json({ status: 'ok', timestamp: new Date().toISOString() })
   })

   app.listen(PORT, () => console.log(`Server running on port ${PORT}`))
   ```

6. 완료되면 "기본 컴포넌트가 생성되었습니다. 최종 설정을 진행합니다." 라고 알리세요.

7. **반드시 다음 skill을 호출하세요: `/finalize`**

## 예시

```
[/create-components 호출됨]
Claude: React 기본 컴포넌트를 생성합니다...
Claude: main.jsx, App.jsx, global.css 생성 완료
Claude: 기본 컴포넌트가 생성되었습니다. 최종 설정을 진행합니다.
[/finalize 호출]
```
