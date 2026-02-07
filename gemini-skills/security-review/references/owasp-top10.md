# OWASP Top 10 - 2021

웹 애플리케이션 보안 취약점 Top 10 (2021년 버전)

## A01:2021 - Broken Access Control (접근 제어 취약점)

### 설명
사용자가 권한 밖의 리소스에 접근하거나 작업을 수행할 수 있는 취약점

### 검사 항목
- [ ] URL 조작으로 다른 사용자 데이터 접근 가능 여부
- [ ] API 엔드포인트에 적절한 권한 검사 존재 여부
- [ ] CORS 설정이 적절한지 확인
- [ ] JWT 토큰 검증이 올바른지 확인

### 코드 패턴 (위험)
```javascript
// 위험: 사용자 ID를 직접 사용
app.get('/user/:id', (req, res) => {
  const user = db.getUser(req.params.id);  // 권한 검사 없음
});
```

---

## A02:2021 - Cryptographic Failures (암호화 실패)

### 설명
민감한 데이터가 적절히 보호되지 않는 취약점

### 검사 항목
- [ ] 민감 데이터가 평문으로 저장되는지 확인
- [ ] 약한 암호화 알고리즘 사용 여부 (MD5, SHA1)
- [ ] 하드코딩된 암호화 키 존재 여부
- [ ] HTTPS 강제 여부

### 코드 패턴 (위험)
```javascript
// 위험: 약한 해시 알고리즘
const hash = crypto.createHash('md5').update(password).digest('hex');

// 위험: 하드코딩된 키
const SECRET_KEY = "my-secret-key-12345";
```

---

## A03:2021 - Injection (인젝션)

### 설명
신뢰할 수 없는 데이터가 명령어나 쿼리에 삽입되는 취약점

### 검사 항목
- [ ] SQL 쿼리에 사용자 입력 직접 연결 여부
- [ ] 명령어 실행에 사용자 입력 사용 여부
- [ ] LDAP, XPath 쿼리에 입력 검증 여부

### 코드 패턴 (위험)
```javascript
// 위험: SQL Injection
const query = `SELECT * FROM users WHERE name = '${userInput}'`;

// 위험: Command Injection
exec(`ls ${userPath}`);

// 위험: NoSQL Injection
db.collection.find({ username: req.body.username });
```

### 안전한 패턴
```javascript
// 안전: Parameterized Query
const query = 'SELECT * FROM users WHERE name = ?';
db.query(query, [userInput]);

// 안전: ORM 사용
User.findOne({ where: { name: userInput } });
```

---

## A04:2021 - Insecure Design (안전하지 않은 설계)

### 설명
설계 단계에서의 보안 결함

### 검사 항목
- [ ] 비즈니스 로직에 rate limiting 존재 여부
- [ ] 중요 작업에 재인증 요구 여부
- [ ] 실패 시나리오 처리 적절성

---

## A05:2021 - Security Misconfiguration (보안 설정 오류)

### 설명
보안 설정이 적절히 구성되지 않은 취약점

### 검사 항목
- [ ] 디버그 모드가 프로덕션에서 비활성화되는지
- [ ] 기본 계정/비밀번호 변경 여부
- [ ] 불필요한 기능/포트 비활성화 여부
- [ ] 에러 메시지에 민감 정보 노출 여부

### 코드 패턴 (위험)
```javascript
// 위험: 상세한 에러 메시지
app.use((err, req, res, next) => {
  res.status(500).json({ error: err.stack });
});

// 위험: CORS 전체 허용
app.use(cors({ origin: '*' }));
```

---

## A06:2021 - Vulnerable Components (취약한 구성요소)

### 설명
알려진 취약점이 있는 라이브러리/프레임워크 사용

### 검사 항목
- [ ] 의존성에 알려진 CVE 존재 여부
- [ ] 오래된 버전의 라이브러리 사용 여부
- [ ] 사용하지 않는 의존성 존재 여부

---

## A07:2021 - Authentication Failures (인증 실패)

### 설명
인증 메커니즘의 취약점

### 검사 항목
- [ ] 약한 비밀번호 허용 여부
- [ ] 브루트포스 공격 방어 존재 여부
- [ ] 세션 관리가 적절한지
- [ ] 토큰 만료 설정 존재 여부

### 코드 패턴 (위험)
```javascript
// 위험: 약한 비밀번호 정책
if (password.length >= 4) { /* OK */ }

// 위험: 세션 고정
req.session.userId = user.id;  // 세션 재생성 없음
```

---

## A08:2021 - Software and Data Integrity Failures

### 설명
소프트웨어 업데이트, CI/CD, 역직렬화 관련 취약점

### 검사 항목
- [ ] 안전하지 않은 역직렬화 사용 여부
- [ ] 서명되지 않은 데이터 신뢰 여부
- [ ] CI/CD 파이프라인 보안

### 코드 패턴 (위험)
```javascript
// 위험: 안전하지 않은 역직렬화
const obj = JSON.parse(userInput);
eval(obj.code);

// 위험: YAML 역직렬화
yaml.load(userInput);  // yaml.safeLoad 사용 필요
```

---

## A09:2021 - Security Logging and Monitoring Failures

### 설명
보안 이벤트 로깅/모니터링 부재

### 검사 항목
- [ ] 로그인 실패 로깅 여부
- [ ] 중요 작업 감사 로그 존재 여부
- [ ] 로그에 민감 정보 포함 여부

---

## A10:2021 - Server-Side Request Forgery (SSRF)

### 설명
서버가 외부 리소스를 요청할 때 발생하는 취약점

### 검사 항목
- [ ] 사용자 제공 URL에 대한 검증 여부
- [ ] 내부 네트워크 접근 차단 여부
- [ ] URL 화이트리스트 사용 여부

### 코드 패턴 (위험)
```javascript
// 위험: 검증 없는 URL fetch
const response = await fetch(req.body.url);

// 위험: 이미지 URL 직접 사용
const image = await downloadImage(userProvidedUrl);
```

---

## 참고 자료

- OWASP Top 10 공식: https://owasp.org/Top10/
- OWASP Cheat Sheet Series: https://cheatsheetseries.owasp.org/
- CWE Top 25: https://cwe.mitre.org/top25/
