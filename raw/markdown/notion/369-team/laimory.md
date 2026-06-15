---
source_type: notion
source_url: https://app.notion.com/p/c96cdc4d240a82188d6001d73372a7d4
title: Laimory
captured_at: 2026-06-15
capture_method: Notion MCP fetch
status: raw-text-snapshot
attachment_policy: volatile Notion image URLs omitted
---

# Laimory

> "사용자의 일상과 삶을 기억하고 이해하는 Personal AI Memory"

## Background

현대인은 하루 대부분을 스마트폰과 함께 하며 사진, 위치 기록, 일정, 메시지, 검색 기록, 앱 사용 기록 등 삶의 흔적은 이미 디지털 형태로 남고 있다.

사람들은 자신의 삶을 기록하고 회고하고 싶어하기에 사진 기록, 운동 기록, 소비 기록, 회고 문화, Quantified Self와 같은 Self-Tracking 흐름은 꾸준히 확산되고 있으며, 자신의 삶을 데이터로 남기고 관리하려는 수요 또한 증가하고 있다.

하지만 내 하루의 데이터는 사진 앱, 메신저, 캘린더, 메모, 위치 기록 등 여러 서비스에 흩어져 존재하며 대부분 비정형 데이터 형태로 저장된다. 이로 인해 자신의 삶을 다시 회상하거나 흐름을 분석하는 Self-Tracking을 위해서는 많은 탐색과 정리 비용이 발생하게 된다. 또한 기존 Self-Tracking 서비스들은 사용자의 직접 입력을 전제로 하기 때문에 기록 피로와 지속성 문제를 가진다.

최근 생성형 AI와 LLM은 단순 질의응답을 넘어 대규모 비정형 컨텍스트를 이해하고 이를 기반으로 요약, 추론, 패턴 분석, 개인의 요구에 맞는 결과를 생성하는 방향으로 발전하고 있다. 이에 따라 AI 시스템에 얼마나 풍부하고 개인화된 컨텍스트를 제공할 수 있는지가 점점 더 중요해지고 있다.

현재의 AI 서비스들은 대화 맥락을 기억하거나 파일·도구를 활용하는 방향으로 빠르게 발전하고 있지만, 사용자의 실제 생활 흐름, 관계, 시간 패턴과 같은 장기적인 삶의 컨텍스트를 충분히 이해하지 못한다. 사용자의 실제 삶 데이터를 기반으로 한 Personal AI 및 AI Memory 분야 또한 빠르게 주목받고 있다.

모바일 기기는 사용자의 일상과 가장 밀접하게 연결된 개인 디바이스로서 삶의 데이터를 가장 풍부하게 담고 있으며, 사용자의 행동, 관계, 시간 흐름, 관심사 등 삶의 컨텍스트를 구성하는 핵심 매체라고 볼 수 있다.

우리는 이러한 흐름 속에서 모바일 기반의 AI 라이프 로깅 시스템이라는 방향에 주목하였다.

## Problem

사람들은 자신의 삶을 기록하고 회고하고 싶어하지만, 삶의 데이터가 여러 서비스에 파편화된 비정형 정보 형태로 존재하기 때문에 이를 직접 탐색·정리하며 Self-Tracking 하는 비용이 매우 크다.

또한 최근 AI는 대화 맥락을 기억하거나 파일·도구를 활용하는 방향으로 빠르게 발전하고 있지만, 여전히 사용자의 실제 일상과 장기적인 삶의 흐름을 이해할 수 있는 개인화된 컨텍스트는 부족하다. 이로 인해 사용자의 시간, 관계, 행동 패턴까지 이해하는 Personal AI 경험은 아직 제한적이다.

## Solution

모바일 기기 안에 흩어져 있는 사용자의 라이프 로그를 AI가 자동으로 수집·구조화·분석하여, 사용자의 삶을 "검색 가능하고 회상 가능하며 이해 가능한 형태"로 변환하는 AI 라이프 로깅 시스템.

## Core Features

### 1. 기록: AI Timeline

사진, 위치 기록, 일정, 앱 사용 기록 등을 기반으로 사용자의 하루를 자동으로 정리하고 각 순간에 대한 메모, 감정을 남길 수 있다.

Examples:

- 오늘 방문한 장소
- 오늘 수행한 일정
- 오늘 통화 및 메시지
- 오늘 찍은 사진
- 오늘 앱 사용량

이를 시간순 Timeline 형태로 제공하고 각각 메모, 감정을 기록한다.

### 2. 회고

5가지 카테고리:

#### 기억 복원

목적:

- 하루/기간을 다시 떠올리게 하기
- 감정과 맥락 회상
- 회고의 진입장벽 낮추기

이번 달의 기록들:

- 사진
- 음악
- 자주 방문한 장소
- 통계

이번 달의 순간들:

- 가장 늦게 잠든 날
- 사진을 가장 많이 찍은 날
- 가장 오래 머문 장소
- 가장 멀리 이동한 날
- 가장 활동적이었던 날
- 가장 조용했던 날
- 새벽 음악 감상이 많았던 날
- 밤 2시까지 깨어있던 날

#### 패턴 발견

목적:

- 자기 행동 인식
- 무의식 패턴 발견
- 자기이해

최근 반복 패턴:

- 최근 새벽 활동 증가
- 주말 외출 감소
- 특정 장소 방문 반복
- 늦게 잔 날엔 앱 사용량 증가
- 운동한 날에는 활기찬 날 많았음

#### 변화 인식

작성률 등 다양한 통계를 기반으로 저번달 혹은 과거와 비교.

목적:

- 변화 체감
- 장기 흐름 인식
- 성장 느낌 제공

지난달과 비교:

- 외출 빈도 +18%
- 평균 취침 시간 42분 빨라짐
- 활동 반경 감소
- 사진 촬영 증가

장기 변화:

- 3개월 전보다 야간 활동 감소
- 최근 카페 방문 증가
- 작년 같은 달보다 이동량 증가

"좋아졌다"가 아닌 "변했다"로 평가하지 않는다.

#### 회고 유도

사용자가 직접 의미를 만드는 영역.

목적:

- 단순 소비가 아니라 생각 유도
- 자기 해석
- 감정 연결

짧은 질문:

- 이번 달 가장 기억에 남는 순간은?
- 다시 돌아가고 싶은 하루가 있었나요?
- 최근 가장 자주 떠오르는 장소는?
- 가장 오래 기억될 것 같은 순간은?

#### 재방문 / 재평가

과거의 나를 현재 시점에서 다시 보게 하는 것.

과거 회상:

- 1년 전 오늘
- 6개월 전 가장 자주 갔던 장소
- 1년 전 오늘 찍은 사진
- 예전에 자주 들은 음악
- 작년 이맘때의 활동 패턴

현재만 보며 회고하는 것이 아닌 직접적인 과거 연결:

- 과거와 연결
- 계절 반복
- 시기 비교

시간이 흘렀다는 감각을 준다. 많이가 아니라 가끔, 가볍게. 새로운 탭이 아니라 알림 형식도 좋아 보인다.

### 3. Personal AI Chat

내 하루, 일주일, 한 달 등 삶의 흐름과 기록을 이해하고 있는 AI와 자연어 기반으로 자유롭게 대화할 수 있다.

사용자는 자신의 삶 전체를 하나의 기억처럼 검색·회상·분석할 수 있다.

단, 충분한 기록이 누적된 이후 활성화된다.

Examples:

- "이번 달 나는 어떻게 살았어?"
- "최근 가장 자주 만난 사람은 누구야?"
- "요즘 왜 이렇게 늦게 자는 것 같아?"
- "작년 이맘때랑 비교해서 달라진 점 있어?"
- "최근 가장 기억에 남을 만한 순간 보여줘"
- "내가 가장 자주 가는 장소는 어디야?"
- "시험 기간 때 생활 패턴 어땠어?"

AI는 Timeline, 위치 기록, 일정, 사진, 앱 사용 패턴 등 삶의 데이터를 기반으로 사용자의 기억을 복원하고 행동 흐름을 분석한다.

## Difference notes

Compared services mentioned in the Notion page:

- Rewind / Limitless
- AI journaling apps: Day One, Rosebud, Reflectly
- Apple Journal
- Google Journal
- Momento
- 마이모리
- Daylio

Laimory positioning captured in the comparison table:

- Target: digital natives broadly, Android users, people without existing record habits.
- Platform: Native Android, all Android devices.
- Data source: photos, location, app usage, schedule, calls, mobile device data, emotion/thought text.
- Core problem: life data fragmentation, record fatigue, and AI's limited awareness of daily life.
- Automation: fully automated + multisource.
- Reflection: 5 structured memory/reflection modes.
- AI: life-context memory and AI conversation.
- Access/pricing: partial paid model, differentiated AI features, all Android devices.
- Current status: Android opportunity, automatic recording + reflection + AI integration.

## First Meet

- 20대 대학생: 기록에 관심이 있지만 기존 기록 방식이 오래 걸려 지속하지 못하고, 사진/캘린더/위치 기록/메신저 등 모바일에 많은 데이터를 남기는 사용자.
- 20대 대학생: 다양한 활동과 외출이 잦고, Android 사용자, 기록에 관심이 많거나 꾸준히 기록하며 모바일 기기를 적극적으로 사용.
- 30대 직장인: 모바일에 사진, 일정 등 다양한 데이터를 남기고 하루를 잘 기록하고 싶지만 실천하지 못하며, 과거를 회상하고 싶은 사용자.

## Deprecated problem notes

- 삶의 데이터가 너무 흩어져 있다.
- 기존 기록 서비스는 지속되기 어렵다.
- 사람들은 자신의 삶을 기억하지 못한다.
- 기존 라이프 로깅 및 AI 기록 서비스는 삶의 맥락을 충분히 이해하지 못한다.
- 사람들은 자신의 삶을 객관적으로 이해하기 어렵다.

## Planning review preparation links

- AI·SW마에스트로 제17기 369팀 프로젝트 기획심의 보고서: https://app.notion.com/p/dd4cdc4d240a832f8286017888f6f3c9
- 기획심의 발표(260529) 스크립트: https://app.notion.com/p/c6acdc4d240a8254b1e4018e56bd5b1c
