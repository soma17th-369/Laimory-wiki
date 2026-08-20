# Laimory AI 타임라인 핵심 개선 요구사항

## 1. 목적

이번 개선은 현재 Agent 구조인

```text
Event Agents → Timeline Agent → Repair Agent
```

를 유지하면서 다음 네 가지를 우선 개선한다.

1. Timeline Agent가 사용자의 하루를 높은 수준에서 복원하고 일기처럼 설명하도록 한다.
2. Location Agent가 여러 위치·이동 기록을 하나의 이동·체류 흐름으로 추론하도록 한다.
3. Repair Agent가 데이터 정합성, 최종 타임라인의 의미, 일기 품질을 검증하도록 한다.
4. Fragment의 의미와 우선순위를 모든 Event Agent와 Timeline Agent가 동일하게 이해하도록 한다.

이번 단계의 작업 범위는 위 네 가지와 관련된 프롬프트 및 검증 코드다.

---

# 2. 공통 제품 비전

모든 Agent는 다음 high-level vision을 공유해야 한다.

> Laimory는 센서 데이터, 캘린더, 사진, 알림이 생긴 원인이 된 사용자의 실제 하루를 예측하고 복원해, 사용자가 읽고 수정할 수 있는 일기형 타임라인으로 만든다.

Event Agent는 자기 데이터 유형을 전문적으로 해석한다. Timeline Agent는 각 결과의 관계와 맥락을 종합해 사용자가 실제로 어떤 하루를 보냈는지 최종적으로 재구성한다. Repair Agent는 그 결과가 이 비전을 충족하는지 검증한다.

---

# 3. Timeline Agent 개선

## 3.1 핵심 역할

Timeline Agent는 Event Agent의 candidate와 fragment를 종합해 사용자의 하루를 재구성한다.

각 candidate와 fragment를 힌트로 삼아 다음 질문에 답해야 한다.

> 이 정보들을 남긴 사용자는 이날 언제, 어디서, 누구와, 무엇을, 어떻게, 왜 했는가?

최종 결과에는 가능한 근거 범위 안에서 다음 내용이 자연스럽게 연결되어야 한다.

- 언제 발생했는가
- 어디서 시작하고 어디로 이동했는가
- 장거리 이동의 출발지와 도착지, 도착 후 이어진 지역 내 이동은 무엇인가
- 누구와 관련된 일이었는가
- 무엇을 했는가
- 어떤 방식으로 이동하거나 활동했는가
- 왜 그 행동을 했을 가능성이 있는가
- 그 사건이 하루 전체에서 어떤 의미를 가졌는가
- 데이터가 비어 있는 시간대와 그로 인해 확정할 수 없는 내용은 무엇인가

최종 타임라인은 사용자가 읽었을 때 자신의 하루를 떠올릴 수 있는 일기 초안이어야 한다.

## 3.2 Timeline Agent 프롬프트에 추가할 핵심 문구

Timeline Agent 시스템 프롬프트 첫 부분에 아래 의미를 명확히 추가한다.

> Candidate와 fragment를 하루의 단서로 사용해, 그 정보를 남긴 사용자가 실제로 어떤 하루를 보냈는지 예측하고 복원한다. 최종 결과는 언제, 어디서, 누구와, 무엇을, 어떻게, 왜 했는지가 가능한 근거 범위에서 드러나는 자연스러운 하루의 기록이어야 한다.

> 하루의 중심 서사를 설명하는 핵심 사건을 선택하고 시간순으로 연결한다. 여러 candidate와 fragment의 관계와 맥락을 종합해 실제 사건을 구체적으로 재구성한다.

> Location Agent가 복원한 이동·체류 흐름을 중심 일정과 주변 활동에 연결해 하나의 연속된 하루 흐름으로 구성한다. Location Agent가 표시한 데이터 공백과 불확실성은 최종 event에 그대로 반영한다.

> 첫 출력에서 핵심 사건, 사건 사이의 관계, 근거에 맞는 구체성, 자연스러운 일기 흐름을 모두 갖춘 완결된 타임라인을 생성한다.

## 3.3 Timeline Agent 구성 원칙

- Location Agent가 제공한 이동·체류 흐름과 중심 캘린더 일정이 하루의 큰 흐름을 구성한다.
- Location Agent가 충분한 근거로 구성한 장거리 여정, 독립 방문, 생활 장소 체류, 산책·근거리 외출, 귀가 candidate는 그 의미와 구체성을 최종 event에 승계한다.
- 다른 source는 Location candidate의 물리적 사건에 활동 목적·사람·일정 의미와 confidence를 보강한다. Location 자체로 충분한 물리적 사건은 독립적인 최종 event로 구성한다.
- User Memory가 확인한 집·학교·회사 체류는 생활 장소에서 보낸 시간으로 표현하고, 실제 업무·수업 의미는 Calendar·Photo·Notification 근거가 함께 지지할 때 확정한다.
- 의미 있는 각 Location candidate는 최종 event 또는 근거가 명시된 warning으로 처리 상태를 남긴다.
- 중심 서사를 설명하는 핵심 사건을 우선 배치한다.
- 중심 일정은 전후 이동, 체류, 관련 활동과 연결해 하루에서 차지한 의미를 설명한다.
- 같은 사건을 가리키는 candidate는 하나의 event로 병합한다.
- fragment는 관련 candidate 또는 최종 event의 보조 근거로 연결한다.
- 핵심 사건은 모두 반영하고, 보조 사건은 독립적인 의미와 근거가 충분할 때 event로 구성한다.

## 3.4 근거 우선순위와 융합 원칙

- Calendar·Location·Photo candidate는 Timeline 구성의 1차 핵심 근거로 사용한다.
- Calendar는 사용자가 직접 입력한 계획·일정명·예정 시간·장소 의도, Location은 직접 측정된 위치·체류·이동·출발지·도착지, Photo는 실제 촬영 시점과 이미지에 보이는 장면·활동·장소명에 높은 우선순위를 가진다.
- Notification candidate와 fragment는 상대적으로 낮은 2차 맥락 근거로 사용해 관련 사건의 사람·대화방·주제·목적·결제·예약·교통 시점을 풍성하게 구성한다.
- 코드 정책과 Notification raw가 직접 제공하는 수신, 결제 완료, 예약 확정, 교통 일정은 해당 사실의 직접 근거로 사용한다. 독립적인 의미와 근거가 충분한 Notification candidate는 자체 event로 구성할 수 있다.
- 같은 그룹의 반복 Notification은 하나의 맥락으로 평가하고, 서로 다른 source의 일치는 독립적인 교차 근거로 평가한다.
- Event Agent의 confidence는 해당 source 범위에서 candidate 의미가 성립하는 확신도다. Timeline Agent는 source별 직접성, 데이터 품질, 독립적인 source의 일치, 충돌과 uncertainty를 종합해 최종 event의 confidence와 inferenceLevel을 결정한다.
- 근거의 신뢰도와 사건의 중요도는 각각 판단한다.

---

# 4. Location Agent 개선

## 4.1 핵심 역할

Location Agent는 하루의 STAY와 MOVEMENT를 연결해 상위 이동·체류 흐름을 추론한다.

하루 위치 데이터 전체를 보고 다음을 추론해야 한다.

- 어디서 출발했는가
- 어디에서 어디까지 이동했는가
- 여러 이동 구간이 하나의 여정인가
- 이동 중간의 짧은 STAY가 실제 방문인지 센서 분절인지
- 서로 다른 이동 사이의 시간 공백 동안 체류했을 가능성이 있는가
- 최종적으로 어디에 얼마나 머물렀는가
- 나갔다가 돌아온 흐름인지
- 장거리 이동, 지역 간 이동, 환승 또는 귀가 흐름인지
- 위치·활동 데이터가 어느 시점부터 끊겼는가
- 데이터 공백으로 인해 장소·활동·귀가 여부를 어디까지 확정할 수 있는가

## 4.2 Location Agent 프롬프트에 추가할 핵심 문구

> 하루의 위치 기록 전체를 시간순으로 해석한다. 여러 이동과 짧은 체류가 하나의 연속된 여정을 가리키면 출발지와 최종 도착지 중심의 하나의 이동 candidate로 병합한다.

> 서로 다른 MOVEMENT 사이에 시간 공백이 있고 그 구간에 명시적인 이동 기록이 없다면, 이전 도착지 또는 다음 출발지에서 체류했을 가능성을 검토한다. 센서 누락 가능성을 반영해 근거의 강도에 맞는 confidence와 표현을 사용한다.

> 중간 STAY가 짧고 전체 경로가 한 방향으로 이어지며 최종적으로 다른 지역이나 교통 거점에 도착하면, 중간 STAY를 실제 방문보다 이동 중 위치 분절로 판단할 수 있다.

> 시간, 거리, 좌표 변화, 출발지, 도착지, 이동 수단, 전후 흐름을 함께 분석한다. 센서의 transport 라벨은 계산된 속도와 이동 맥락상 현실적인 경우에만 이동 수단의 근거로 사용한다.

> 장거리 이동은 출발지, 주요 도착지, 도착 후 이어진 지역 내 이동을 연결한 하나의 상위 여정 candidate로 생성한다. 관련된 모든 STAY와 MOVEMENT rawId를 해당 candidate의 `sourceRefs`에 보존한다.

> 위치 또는 활동 데이터가 끊긴 구간은 마지막으로 확인된 시각·장소·활동과 공백의 시작 시점을 명시한다. 공백 이후의 장소·활동·귀가 여부는 확인 가능한 근거의 범위와 confidence를 candidate 또는 fragment에 포함한다.

## 4.3 Location Agent가 생성해야 하는 후보 수준

목표 후보 예시:

- 한 지역에서 다른 지역의 주요 교통 거점까지 장거리 교통수단으로 이동한 여정
- 주요 교통 거점 도착 후 중심 일정이 있는 지역으로 이동
- 오전까지 주거지로 보이는 장소에 머물다가 외출

## 4.4 Location Agent 검증용 코드 요구사항

아래 항목은 기존 Location 입력 DTO의 값으로 코드 내부에서 계산하거나 검증한다. Agent 입력은 기존 DTO를 그대로 사용한다.

### 필수 전처리

- 모든 STAY와 MOVEMENT 시간순 정렬
- 이동별 거리와 소요시간 계산
- 평균 속도 계산
- 이동수단과 평균 속도의 현실성 검사
- 이전 도착지와 다음 출발지의 위치 차이 계산
- 연속 MOVEMENT 사이의 시간 공백 계산
- Location 데이터의 마지막 관측 시각과 수집 공백 구간 계산
- 짧은 중간 STAY 표시
- 출발지와 최종 도착지의 도시·지역 변화 표시

### 검증 코드

- 장거리 이동 raw가 여러 개 존재하지만 상위 여정 candidate가 없는 경우 경고
- 상위 여정 candidate에 출발지·주요 도착지·도착 후 이동 또는 관련 rawId가 누락된 경우 오류
- 위치·활동 데이터 공백이 있지만 마지막 관측 정보와 불확실성 범위가 candidate 또는 fragment에 없는 경우 오류
- 물리적으로 불가능한 WALKING/IN_VEHICLE 분류를 그대로 사용한 경우 경고
- 모든 이동 rawId가 candidate 또는 fragment 중 어디에도 포함되지 않은 경우 오류
- 중간 짧은 STAY가 여러 개의 독립 방문 candidate로 생성된 경우 검토 요청

---

# 5. Notification Event Agent 개선

## 5.1 핵심 역할

Notification Event Agent는 알림을 예약·결제·업무·소통 등 사용자의 하루와 관련된 사건 후보와 맥락으로 해석한다.

알림은 종류에 따라 의미가 다르다. 결제·예약·교통·업무 알림은 실제 행동과 직접 연결될 가능성이 높고, 메신저 알림은 상대가 보낸 메시지라는 한계를 가지지만 반복 연락, 구체적인 주제, 관계 맥락, 사용자 열람·응답 근거가 있으면 소통 자체가 의미 있는 하루 사건이 될 수 있다.

## 5.2 Notification Event Agent 프롬프트에 추가할 핵심 원칙

- 메신저 알림은 상대가 보낸 메시지의 수신 근거다. 사용자의 발신·답장은 해당 근거가 있을 때만 반영한다. 반복 연락, 구체적인 주제, 관계 맥락, 사용자 열람·응답 근거가 있으면 소통 자체를 의미 있는 candidate로 만들 수 있다.
- 같은 상대·대화방·주제의 알림은 하나의 소통 흐름으로 묶을 수 있다. 비연속 메시지는 각 메시지의 실제 시각과 간격이 드러나도록 표현한다.
- 결제, 송금, 예약, 교통, 업무 알림은 실제 행동과 연결될 가능성이 높은 근거로 우선 검토한다.
- 메신저 알림의 `title`에 명시된 값은 기본적으로 보낸 사람 또는 대화방 이름으로 해석한다. 관계명은 User Memory에 등록된 경우에만 사용하며, 그 외에는 입력에 있는 이름을 사용한다.
- 메신저 알림의 `text`를 통해 어떤 내용의 소통이 이루어졌는지 추론한다. 예: 단순 안부, 업무, 일정 조율, 정산, 식사, 예약, 이동 관련 소통.
- 사용자의 답장 근거가 있는 경우에는 양방향 대화로 표현한다. 수신 근거만 있는 경우에는 `연락이 이어졌다`, `관련 메시지를 받았다`, `소통 정황이 있었다`처럼 근거 범위에 맞게 표현한다.
- 소통의 내용과 반복성이 충분하고 사용자의 하루에서 의미가 크다면 독립 candidate가 될 수 있다. 그렇지 않으면 관련 일정이나 활동을 보강하는 fragment로 남긴다.
- JWT, 인증 토큰, 개인정보가 포함된 알림은 `개발 관련 인증 정보가 공유됨`처럼 민감 내용을 제거한 수준으로 요약한다.

## 5.3 Candidate와 Fragment 판단 기준

### Candidate로 고려할 수 있는 경우

- 예약 확정, 결제 완료, 송금, 교통 일정처럼 실제 행동과 직접 연결되는 알림
- 업무 지시, 회의 조율, 일정 변경처럼 하루의 행동에 영향을 준 소통
- 같은 상대와 구체적인 주제로 반복된 연락이 있고, 사용자 열람·응답 또는 다른 근거가 함께 있어 소통 자체가 의미 있는 사건으로 볼 수 있는 경우

### Fragment로 남길 경우

- candidate로 확정하기에는 약하지만 다른 사건의 맥락을 설명할 수 있는 메시지
- 진행 중인 회의·업무·프로젝트를 보강하는 Discord 또는 메신저 알림
- 식사나 공동 비용 가능성을 암시하지만 그 성격을 확정할 수 없는 정산 요청
- 관계나 주제가 불분명한 짧은 연락

Notification fragment도 다른 Event Agent의 fragment와 마찬가지로 candidate에 포함되지 않은 raw item을 보존한 가장 낮은 우선순위의 단서로 취급한다. Timeline Agent는 이를 관련 candidate의 사람·주제·목적·confidence를 보강하는 근거로 사용한다.

## 5.4 Notification 검증 코드 요구사항

- 메신저 알림의 `title`, `text`, 앱 정책을 기준으로 발신자·대화방·주제를 구조화한다.
- 같은 상대·대화방·주제의 알림을 그룹화하되 각 메시지의 실제 시각은 보존한다.
- 비연속 메시지를 하나의 긴 연속 시간 구간으로 저장하지 않는다.
- Agent에 전달된 각 Notification raw item이 candidate 또는 fragment에 포함되는지 확인한다.
- candidate에 포함되지 않은 유효 알림이 이유 없이 유실되지 않았는지 확인한다.
- 민감한 토큰, 개인정보, 인증 문자열이 candidate, fragment, 최종 event 설명에 노출되지 않았는지 검사한다.
- User Memory에 없는 관계명이 임의로 생성되지 않았는지 검사한다.
- Notification fragment가 최종 event의 근거로 사용되었으면 해당 rawId가 `sourceRefs`에 포함됐는지 확인한다.

---

# 6. Repair Agent 개선

## 6.1 핵심 역할

Repair Agent는 데이터 정합성, 사용자의 하루에 대한 복원 수준, 중심 서사, 일기 품질을 검증하는 최종 품질 관리자다.

## 6.2 Repair Agent 프롬프트에 추가할 핵심 문구

> Timeline Agent의 결과에 대해 데이터 정합성과 함께 candidate와 fragment의 종합 여부, 사용자의 실제 하루에 대한 설명 수준, 일기 품질을 검증한다.

> 결과만 읽었을 때 사용자가 언제, 어디서, 누구와, 무엇을, 어떻게, 왜 했는지가 근거가 허용하는 범위에서 드러나는지 확인한다.

> 가장 중요한 이동, 중심 일정, 주요 체류가 누락됐는지 확인하고, 작은 단서만 나열되어 하루의 중심 서사가 사라지지 않았는지 검증한다.

> 장거리 이동의 출발지·주요 도착지·도착 후 지역 내 이동, 중심 일정과 전후 활동의 연결, 데이터 공백에 따른 불확실성이 근거에 맞게 표현됐는지 확인한다.

## 6.3 Repair Agent high-level 검증 질문

- 이 결과만 읽어도 이날 어떤 하루였는지 이해할 수 있는가?
- 출발, 주요 이동, 목적지, 중심 활동이 자연스럽게 연결되는가?
- 지역 간 이동이 출발지부터 주요 도착지와 도착 후 이동까지 하나의 여정으로 구성되었는가?
- 중심 일정이 전후 이동·체류·관련 활동과 연결되었는가?
- 데이터가 끊긴 이후의 내용이 확인된 근거와 불확실성의 범위 안에서 표현되었는가?
- 핵심 candidate가 모두 반영되고 중요도에 맞게 강조되었는가?
- 동일한 사건의 여러 source가 하나의 일관된 사건으로 통합되었는가?
- 사건 설명이 위치·데이터 기록의 의미와 맥락까지 전달하는가?
- 근거가 충분한 내용은 구체적이고 명확하게 표현되었는가?
- 각 표현의 확신 수준이 근거의 강도와 일치하는가?
- 사용자가 읽고 수정할 수 있는 자연스러운 일기체인가?

## 6.4 Repair Agent 도구 사용 요구사항

다음 문제가 있으면 해당 도구를 사용해야 한다.

- Location 상위 여정이 누락됨 → `rerun_event_agent(Location)`
- Location의 데이터 공백·마지막 관측 정보·불확실성 범위가 누락됨 → `rerun_event_agent(Location)`
- 후보는 충분하지만 중심 서사가 잘못 구성됨 → `rerun_timeline_agent`
- 개별 event의 문장·시간·중요도만 잘못됨 → `update_event`
- 근거 없이 생성된 event → `delete_event`
- 관련 event가 불필요하게 분리됨 → 병합 도구 또는 Timeline 재실행

전체 Timeline 재실행은 핵심 서사 자체가 잘못된 경우에만 사용한다.

---

# 7. Photo 검증 요구사항

사진은 사용자가 직접 선택해 입력하는 방식으로 변경되었으므로, 선택된 사진은 모두 의도적으로 포함된 중요한 입력으로 간주한다.

따라서 정상적으로 description이 생성된 선택 사진은 기존 candidate·fragment와 최종 event의 `sourceRefs`로 추적한다.

## 7.1 Photo Event Agent의 사진 활용 원칙

- Photo Event Agent는 선택된 사진을 가능한 한 모두 event candidate 생성에 사용한다.
- 사진의 의미와 촬영 시각이 실제 순간을 설명할 수 있으면 candidate로 만든다.
- 의미와 촬영 시간이 같은 활동을 가리키는 여러 사진은 하나의 candidate로 융합할 수 있다. 이때 해당 candidate의 `sourceRefs`에 포함된 모든 사진 rawId를 보존한다.
- 서로 다른 활동을 보여주는 사진은 각각 해당 활동의 candidate에 사용한다.
- 사진만으로 사건의 의미를 제안하기 어려울 때만 fragment로 남기고, Vision 실패나 해석 불가능 등 처리할 수 없는 경우에는 제외 이유를 명시한다.

## 7.2 Timeline Agent의 사진 포함 및 귀속 원칙

- Timeline Agent는 Photo Event Agent가 전달한 사진을 가능한 한 모두 최종 타임라인에 포함한다.
- 사진을 반드시 독립 event로 만들 필요는 없다. 사진의 의미·시간과 가장 잘 맞는 위치, 일정, 식사, 업무, 만남 등의 event에 병합하는 것을 우선한다.
- 정상적으로 처리된 하나의 사진 item은 최종적으로 정확히 하나의 event에 종속되며, 하나의 사진 rawId는 한 최종 event의 `sourceRefs`와 UI에만 존재한다.
- 하나의 최종 event에는 같은 사건을 보여주는 여러 사진 item이 종속될 수 있다. 즉, 사진 item과 최종 event의 관계는 `N:1`이다.
- 사진을 어느 event에 귀속할지는 사진의 의미와 촬영 시각을 우선하고, 위치 근거가 있으면 함께 사용한다.
- 사진을 fragment로 병합해 사용한 경우에도 해당 사진 rawId는 귀속된 하나의 최종 event의 `sourceRefs`에 포함한다.
- Vision 또는 Event Agent 호출 실패는 기존 오류 처리와 Timeline warning으로 전달한다.

## 7.3 코드 Validator의 필수 검증

아래 항목은 사진 rawId 집합과 단계별 결과를 코드가 결정론적으로 대조해 검증한다.

- 사용자가 선택한 사진 수 기록
- Vision 처리에 전달된 사진 수 확인
- description이 생성된 사진 수 확인
- Photo Event Agent 입력 및 출력 수 확인
- 각 사진 rawId가 candidate 또는 fragment에 포함됐는지 확인
- 각 사진 rawId가 최종 Timeline event의 `sourceRefs`에 포함됐는지 확인
- UI에서 사진이 표시되는 대표 event가 지정됐는지 확인
- 동일 사진이 여러 event UI에 중복 표시되지 않는지 확인
- 정상 처리된 각 사진 rawId가 정확히 하나의 최종 event에만 포함됐는지 확인
- 하나의 event에 여러 사진이 병합된 경우 모든 사진 rawId가 해당 event에 보존됐는지 확인

## 7.4 실패 처리

- 정상적으로 description이 생성된 사진은 기존 Photo candidate 또는 fragment에 포함한다.
- Vision 또는 Event Agent 호출 실패는 기존 코드 오류 처리와 Timeline의 `warnings`를 사용한다.
- 사진 귀속은 기존 Photo candidate·fragment와 최종 event의 `sourceRefs`로 표현한다.

---

# 8. Candidate와 Fragment 정의

## 8.1 Candidate

Candidate는 해당 Event Agent가 독립적인 하루 사건으로 제안할 만큼 의미와 근거가 충분한 결과다.

예:

- 한 도시에서 다른 도시로 이동
- 팀 정기 회의 일정
- 음식 사진을 근거로 한 저녁 식사 후보
- 예약 확정 알림을 근거로 한 일정 후보

## 8.2 Fragment

Fragment는 **독립 candidate를 구성할 만큼 의미와 근거가 충분하지 않은 유효 raw item을 보존한 낮은 우선순위의 근거 조각**이다.

Fragment는 다음 특징을 갖는다.

- 독립 event candidate를 만들기에는 근거가 약하다.
- candidate의 근거가 되기에는 약한 유효 raw item을 보존한다.
- Timeline Agent가 다른 candidate의 의미, 시간, 장소, 사람, 목적, confidence를 보강하는 데 사용할 수 있다.
- 기본 우선순위는 candidate보다 낮다.
- 광고, 중복, 명백한 노이즈는 fragment로도 남기지 않아도 된다.

예:

- 회의 시간대에 도착한 Discord 개발 메시지
- 식사 가능성을 암시하지만 단독으로 확정하기 어려운 결제 요청
- 같은 사람에게서 반복적으로 수신된 짧은 메시지
- 이동 candidate에 포함되지 않은 약한 위치 조각

## 8.3 Event Agent 프롬프트 요구사항

모든 Event Agent 프롬프트에 다음 정의를 동일하게 추가한다.

> Candidate는 독립적인 하루 사건으로 제안할 수 있을 만큼 의미와 근거가 모인 결과다.

> Fragment는 독립 candidate를 구성할 만큼 의미와 근거가 충분하지 않은 유효 raw item을 보존한 낮은 우선순위의 단서다. Timeline Agent가 다른 candidate의 의미·시간·장소·사람·목적·confidence를 보강하는 데 사용할 수 있다.

> 각 raw item은 동일한 의미의 candidate와 fragment 중 한 곳에만 저장한다.

> 독립 candidate의 근거가 부족한 유효 raw item은 가능한 한 fragment로 남긴다.

모든 Event Agent의 `confidence`는 자기 source 범위 안에서 candidate 의미가 성립하는 확신도로 통일한다. `inferenceLevel`은 source가 직접 제공한 사실, source 내부의 결합 근거, 맥락 추론, 불확실성을 구분한다. 최종 event의 confidence와 inferenceLevel은 Timeline Agent가 다시 결정한다.

## 8.4 Timeline Agent의 Fragment 사용 규칙

- candidate를 최종 event 구성의 우선 근거로 사용한다.
- fragment는 시간·장소·주제가 맞는 candidate의 보조 근거로 연결한다.
- fragment를 사용하면 해당 rawId를 최종 event의 `sourceRefs`에 포함한다.
- 여러 fragment가 함께 하나의 의미 있는 사건을 충분히 설명할 때만 새로운 event로 승격한다.
- 새로운 event로 승격할 때는 fragment의 수보다 결합된 의미와 근거의 충분성을 기준으로 삼는다.
- 최종 event의 근거로 채택된 fragment만 해당 event에 연결한다.

## 8.5 Fragment 검증 코드

- Agent에 전달된 각 유효 raw item이 candidate 또는 fragment에 포함되는지 확인
- 같은 rawId가 동일 의미의 candidate와 fragment에 중복 포함되지 않았는지 확인
- candidate에 포함되지 않은 유효 raw가 이유 없이 유실되지 않았는지 확인
- Timeline에서 fragment를 근거로 사용했는데 sourceRefs가 누락되지 않았는지 확인
- 낮은 우선순위 fragment만으로 핵심 event가 생성된 경우 Repair 검토 대상으로 표시

---

# 9. 구현 우선순위

이번 단계에서는 다음 순서로만 수정한다.

## 1순위 — 프롬프트

1. Timeline Agent high-level mission 강화
2. Location Agent의 상위 이동·체류 흐름 추론 규칙 추가
3. Repair Agent의 high-level 일기 품질 검증 추가
4. Notification Event Agent의 소통·결제·예약 해석 원칙 추가
5. Photo Event Agent의 전체 사진 candidate 활용 및 Timeline Agent의 사진 단일 귀속 규칙 추가
6. 모든 Event Agent 및 Timeline Agent에 candidate/fragment 정의 통일

## 2순위 — 검증 코드

1. Location 시간·거리·속도·데이터 수집 공백 전처리
2. 장거리 이동 candidate 누락 검사
3. 선택 사진의 기존 candidate·fragment 및 최종 event `sourceRefs` 포함 검사
4. Agent 입력 raw item의 candidate/fragment 포함 검사
5. Notification 그룹화·민감정보·관계명 검증
6. fragment sourceRefs 보존 및 중복 검사

## 이번 단계에서 하지 않는 것

- Agent 구조 전면 재설계
- 새로운 Agent 추가
- 모든 데이터 유형의 프롬프트 전면 수정
- 중요도 시스템의 대규모 스키마 변경

Sleep/Activity Agent는 현재 활성 상태를 유지하고 시스템 프롬프트를 `prompt_v2.md`로 교체한다.

---

# 10. 완료 기준

다음 조건을 만족하면 이번 핵심 개선이 완료된 것으로 본다.

- Timeline 결과가 하루의 중심 서사를 가진 일기처럼 읽힌다.
- 최종 event 설명에서 가능한 범위의 육하원칙이 드러난다.
- Location Agent가 여러 이동·체류 raw를 상위 여정과 체류 흐름으로 복원한다.
- 지역 간 장거리 이동이 출발지와 주요 도착지를 포함한 하나의 핵심 여정으로 생성된다.
- Timeline Agent가 중심 일정을 전후 이동·체류·관련 활동과 연결해 표현한다.
- Location Agent가 위치·활동 데이터의 마지막 관측 정보와 공백 이후의 불확실성 범위를 생성한다.
- Repair Agent가 핵심 이동, 중심 일정, 사건 사이의 관계, 데이터 공백의 불확실성을 검증한다.
- 정상적으로 description이 생성된 선택 사진이 candidate 또는 fragment와 최종 event `sourceRefs`에서 이유 없이 누락되지 않는다.
- 정상 처리된 사진은 가능한 한 모두 최종 타임라인에 포함되고, 각 사진 item은 정확히 하나의 최종 event에만 종속된다.
- 같은 의미와 시간의 여러 사진은 하나의 event로 병합될 수 있으며, 병합된 모든 사진 rawId가 해당 event의 `sourceRefs`에 보존된다.
- Notification Agent가 발신자·대화방·주제를 올바르게 해석하고, 수신과 양방향 대화를 구분한다.
- 의미 있는 소통은 candidate로 만들 수 있고, 약한 알림은 fragment로 보존된다.
- JWT·인증 토큰·개인정보가 최종 일기에 노출되지 않는다.
- Candidate에 포함되지 않은 유효 raw가 fragment로 보존된다.
- Timeline Agent가 fragment를 낮은 우선순위의 보조 근거로 올바르게 활용한다.
- Fragment가 사용된 최종 event에는 해당 rawId가 sourceRefs로 보존된다.
- Calendar·Location·Photo의 높은 우선순위 근거가 최종 event에 유지되고, Notification의 사람·주제·목적·시점 정보가 관련 사건을 풍성하게 보강한다.
- 최종 confidence와 inferenceLevel이 source 직접성, 독립적인 교차 근거, 충돌과 uncertainty에 맞게 결정된다.

---

# 11. 코딩 작업 전달 전 보완사항

- 각 Event Agent는 자신의 raw input, 코드가 제공한 메타데이터·정책, User Memory로 근거화할 수 있는 범위까지 추론한다. 여러 source를 결합해야 하는 실제 활동 의미는 Timeline Agent가 확정한다.
- Notification은 기존 `appDictionary`, `detectedAppName`, `appPolicy`, category를 그대로 사용한다. 앱 식별, category, 필드 의미, 개인정보 마스킹과 검색·광고·시스템 알림 제외는 코드가 결정론적으로 처리한다.
- Location은 기존 Location raw만으로 장거리 이동, 체류, 집·학교·회사 같은 장소 역할, 산책·근거리 외출 가능성, 귀가 가능성, Location 기록의 관측 공백을 담당한다. 식사·회의·실제 업무·수업처럼 여러 source가 필요한 의미는 Timeline이 확정한다.
- Timeline은 Location candidate의 시간·장소·상위 여정·생활 장소·산책·귀가 추론을 최종 event의 기본 근거로 승계하고, 충분한 Location candidate를 구체적인 최종 event로 구성한다.
- 코드 Validator는 기존 DTO를 기준으로 schema, rawId, timezone과 요청 window, 중복, 사진 귀속, candidate·fragment 포함 여부를 결정적으로 검사한다. Repair는 기존 입력인 `[draft]`, `[근거 원본]`, `[사용 가능한 도구]`, `[지금까지 실행한 도구]`로 중심 서사, 사건 병합, 근거와 표현의 일치, 일기 품질을 검증한다.
- Timeline과 Repair는 Calendar·Location·Photo를 1차 핵심 근거로, Notification을 상대적으로 낮은 2차 맥락 근거로 사용한다. Notification이 직접 제공하는 결제·예약·수신 사실과 충분한 독립 candidate는 해당 의미를 유지한다.
- Sleep/Activity는 현재 활성 상태를 유지하고 시스템 프롬프트만 `prompt_v2.md`로 교체한다.
- 기존 코드 DTO와 JSON schema가 유일한 입출력 계약이다. `prompt_v2.md`의 입출력 예시는 각 기존 `prompt.md`와 동일한 필드·중첩 구조·enum을 사용한다. 의미 품질 개선은 해당 Agent의 기존 필드 안에서 구현한다.

---

# 12. 구현 시 기존 코드에서 확인할 사항

추가로 결정받아야 할 질문은 없다. 코딩 작업에서는 기존 구현을 먼저 확인하고 다음 범위를 유지한다.

- 기존 DTO, JSON schema, enum과 Agent 입력 구조를 그대로 사용한다.
- Sleep/Activity Agent는 현재 활성 상태를 유지하고 시스템 프롬프트만 `prompt_v2.md`로 교체한다.
- Photo Metadata fallback description은 촬영 시각, GPS와 기존 장소 정보를 사용해 코드에서 생성한다.
- Photo rawId는 하나의 최종 event에만 귀속한다. 다른 source의 rawId는 같은 시간 맥락에서 서로 다른 사실을 직접 지지할 때 여러 event에 사용할 수 있다.
- 장거리 이동은 Location raw의 출발지·도착지와 지역 변화를 중심으로 해석한다. 20분 이하의 중간 STAY는 상위 여정 안의 위치 분절로 처리한다.
- Notification은 기존 앱 사전, `appPolicy`, category와 입력 필드만 사용한다. 메신저의 열람·답장·발신 근거가 기존 입력에 없으면 수신 근거로 해석한다.
- Calendar·Location·Photo의 우선순위와 Notification의 보강 역할은 Timeline과 Repair 프롬프트에서 적용한다.
- 사건 중요도는 별도 필드 없이 Timeline의 중심 서사 선택과 Repair 검증에 사용한다.
- 기존 Validator의 구조 검증·재시도 정책과 기존 Repair 도구·반복 횟수·재실행 교체 범위는 현재 코드 동작을 유지한다.
- 사용자의 답변으로 해결되는 시간·장소·활동 충돌은 question, 데이터 품질과 시스템 한계는 warning으로 표현한다.
