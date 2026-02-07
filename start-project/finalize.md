# finalize

프로젝트 생성을 완료하고 최종 안내를 제공하는 skill입니다.

## 설명

이 skill은 프로젝트 생성 파이프라인의 마지막 단계입니다. Git 초기화, 의존성 설치, 그리고 사용자에게 다음 단계를 안내합니다.

## 지시사항

1. `.project-config.json` 파일을 읽어 프로젝트 설정을 확인하세요.

2. **프로젝트 폴더로 이동하여 Git 초기화:**
   ```bash
   cd {project-name}
   git init
   ```

3. **의존성 설치 여부를 사용자에게 질문하세요:**
   - "지금 npm install을 실행할까요? (Yes/No)"
   - Yes인 경우 `npm install` 실행
   - No인 경우 건너뛰기

4. **README.md 생성:**
   ```markdown
   # {project-name}

   {description}

   ## 기술 스택
   - Frontend: {framework} + Vite
   - {Backend: Express.js (백엔드 포함 시)}

   ## 시작하기

   ```bash
   # 의존성 설치
   npm install

   # 개발 서버 실행
   npm run dev
   {# 백엔드 서버 실행 (별도 터미널)
   npm run server}
   ```

   ## 스크립트

   - `npm run dev` - 개발 서버 실행 (포트 3000)
   - `npm run build` - 프로덕션 빌드
   - `npm run preview` - 빌드 미리보기
   - `npm run test` - 테스트 실행
   {- `npm run server` - 백엔드 서버 실행 (포트 4000)}

   ## 프로젝트 구조

   ```
   {project-name}/
   ├── src/
   │   ├── components/
   │   ├── styles/
   │   ├── utils/
   │   └── assets/
   ├── public/
   ├── tests/
   {├── server/}
   └── package.json
   ```

   ---
   Generated with Claude Code Skills
   ```

5. **임시 설정 파일 정리:**
   - 루트 디렉토리의 `.project-config.json` 삭제

6. **최종 안내 메시지 출력:**
   ```
   ✅ 프로젝트 '{project-name}' 생성이 완료되었습니다!

   📁 생성된 구조:
      - Frontend: {framework} + Vite
      - {Backend: Express.js}
      - 테스트: Vitest

   🚀 시작하기:
      cd {project-name}
      npm install  (아직 설치하지 않은 경우)
      npm run dev

   📖 자세한 내용은 README.md를 참고하세요.
   ```

7. **이 skill은 체인의 마지막이므로 다른 skill을 호출하지 않습니다.**

## 예시

```
[/finalize 호출됨]
Claude: Git 저장소를 초기화합니다...
Claude: 지금 npm install을 실행할까요?
User: Yes
Claude: 의존성을 설치합니다...
Claude: README.md를 생성합니다...
Claude:
✅ 프로젝트 'my-awesome-app' 생성이 완료되었습니다!
...
```
