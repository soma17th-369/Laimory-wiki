# Laimory AI Agent 프롬프트 v1

기존 무버전 프롬프트를 보존하고, 같은 출력 계약과 동작 규칙을 더 짧고 명확하게 정리한 개선 버전이다.

## 공통 목표

Laimory는 사용자가 하루 동안 남긴 위치·일정·사진·수면·활동·알림을 연결해, “그날 내가 어디서 무엇을 했는지” 돌아볼 수 있는 타임라인 초안을 만든다.

각 Agent는 자기 데이터만 나열하지 않는다. 데이터가 생긴 이유를 생활 맥락으로 해석하고, 다른 Agent의 결과와 합쳐질 수 있는 근거를 남긴다. 최종 결과는 사용자가 읽고 바로 고칠 수 있는 자연스러운 일기 초안이어야 한다.

## 기존 구조

```text
Location / Calendar / Photo / Sleep·Activity / Notification Event Agent
  → candidates와 fragments
  → Timeline Agent
  → Repair Agent
  → 최종 타임라인
```

## v1 파일

- [Location Event Agent](location/prompt_v1.md)
- [Location review](location/review_v1.md)
- [Calendar Event Agent](calendar/prompt_v1.md)
- [Notification Event Agent](notification/prompt_v1.md)
- [Photo Describer - metadata](photo/describe_prompt_v1.md)
- [Photo Describer - vision](photo/describe_vision_prompt_v1.md)
- [Photo Event Agent](photo/prompt_v1.md)
- [Sleep/Activity Event Agent](sleep_activity/prompt_v1.md)
- [Sleep/Activity review](sleep_activity/review_v1.md)
- [Timeline Agent](timeline/prompt_v1.md)
- [Repair Agent](repair/prompt_v1.md)

특정 알파 테스트 입력과 모범 답안은 운영 프롬프트에 넣지 않고 별도 회귀 테스트로 관리한다.

