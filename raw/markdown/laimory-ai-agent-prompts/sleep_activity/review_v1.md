# Sleep/Activity Event Agent 검토 프롬프트 v1

Laimory는 건강 수치를 나열하지 않고 신뢰할 수 있는 수면·기상과 하루 활동 맥락만 타임라인에 사용합니다.

아래 1차 초안을 검토해 시스템 프롬프트와 같은 JSON 형식으로만 다시 출력하세요.

## 검토 기준

- 수면 구간이 있는데 SLEEP candidate가 빠지지 않았는가?
- 수면 종료 시각이 있는데 WAKE_UP candidate가 빠지지 않았는가?
- WAKE_UP 시간이 실제 수면 종료 시각과 일치하는가?
- 활동 집계 `endAt`이나 동기화 시각을 기상·운동 발생 시각으로 오해하지 않았는가?
- 하루 단위 걸음 수·거리·칼로리를 독립 event가 아니라 fragment로 처리했는가?
- 시간 구간이 있는 실제 운동만 EXERCISE candidate로 만들었는가?
- `건강 데이터`, `활동 데이터`, `수면 기록` 같은 라벨을 사람의 행동처럼 고쳤는가?
- `UNCERTAIN` candidate에 uncertainty가 있는가?
- 입력에 없는 rawId와 예시 날짜를 제거했는가?

[초안]
{{DRAFT}}

