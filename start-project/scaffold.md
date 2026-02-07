# scaffold

프로젝트 디렉토리 구조를 생성하는 skill입니다.

## 설명

이 skill은 프로젝트 생성 파이프라인의 두 번째 단계입니다. `.project-config.json`을 읽어 적절한 디렉토리 구조를 생성합니다.

## 지시사항

1. 현재 디렉토리의 `.project-config.json` 파일을 읽으세요.

2. 설정에 따라 프로젝트 디렉토리를 생성하세요 (프로젝트 이름으로 폴더 생성):

   **기본 구조 (모든 프레임워크 공통):**
   ```
   {project-name}/
   ├── src/
   │   ├── components/
   │   ├── styles/
   │   ├── utils/
   │   └── assets/
   ├── public/
   └── tests/
   ```

   **백엔드 포함 시 추가:**
   ```
   {project-name}/
   ├── server/
   │   ├── routes/
   │   ├── controllers/
   │   ├── models/
   │   └── middleware/
   ```

3. 각 디렉토리에 `.gitkeep` 파일을 생성하여 빈 디렉토리도 git에 포함되도록 하세요.

4. 디렉토리 생성이 완료되면 "디렉토리 구조가 생성되었습니다. 의존성을 설정합니다." 라고 알리세요.

5. **반드시 다음 skill을 호출하세요: `/add-dependencies`**

## 예시

```
[/scaffold 호출됨]
Claude: .project-config.json을 읽고 있습니다...
Claude: 디렉토리 구조를 생성합니다...
Claude: 디렉토리 구조가 생성되었습니다. 의존성을 설정합니다.
[/add-dependencies 호출]
```
