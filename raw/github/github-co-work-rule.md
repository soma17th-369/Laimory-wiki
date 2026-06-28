## **Branch Rule**

|**Commit Type**|**Description**|
|---|---|
|main|테스트 완료 후 배포용|
|dev|개발 커밋 통합용|
|feat|작업 브랜치 (기능 개발용)|
|fix|작업 브랜치 (버그 수정용)|
|refactor|작업 브랜치 (코드 리팩토링)|

dev 브랜치 에서 작업 브랜치를 생성하고

**(중요) 브랜치 명에 이슈 번호를 기입한다. ex) feat/#33, fix/#25 ..**

## **Commit Convention**

|**Commit Type**|**Description**|
|---|---|
|feat|Add new features|
|fix|Fix bugs|
|docs|Modify documentation|
|style|Code formatting, missing semicolons, no changes to the code itself|
|refactor|Code refactoring|
|test|Add test code, refactor test code|
|chore|Modify package manager, and other miscellaneous changes (e.g., .gitignore)|
|design|Change user UI design, such as CSS|
|comment|Add or modify necessary comments|
|rename|Only changes to file or folder names or locations|
|remove|Only performing the action of deleting files|

커밋 메시지는 Commit Type 다음 콜론 (:) 을 붙이고 간단한 작업 내용을 기재한다.

ex) feat : 엄청난 신기능 개발, refactor : 획기적인 성능 개선

## Issue

이슈는 Feature, Refactor, Bug 총 3가지 이고 제목 및 내용은 다음과 같다.

<aside>

✨ Feature - 혁신적인 기능

```
## 🛠️ 계획된 개발 기능
<!--어떠한 기능 / 화면을 만드는지 적습니다.-->

## 🛠 기능 구현 세부사항
<!--해당 기능들이 요구하는 사항 등을 적습니다.-->

## 🛠 참고사항
<!--해당 기능들에 있어 특이사항을 적습니다.-->

## 💾 DB 변경사항
<!--DB 변경사항을 적습니다.-->

## 📝 check-lists
- [ ]
```

</aside>

<aside>

🎨 Refactor - 엄청난 개선

```
## 🛠️ 계획된 리팩토링할 기능
<!--어떠한 기능 / 화면을 리팩토링하는지 적습니다.-->

## 🛠 사유
<!--해당 기능에서 "왜?" 리팩토링하는지 적습니다.-->

## 📝 check-lists
- [ ]

```

</aside>

<aside>

🐛 Bug - 심각한 버그

```
## 🛠️ 발견된 버그 기능
<!--어떤 부분에서 버그가 나오는지 기입합니다.-->

## 🌎 발견된 환경
- 서버 (dev, prod):
- 발생 API:
- 에러 코드:

## 💻 에러 로그
<!--에러 로그를 기입합니다.-->
```

```
## 💡 해결방안
<!--해당 에러를 어떻게 해결할 것인지, 어떻게 임시적 처리를 진행해야 하는지 상세히 기입합니다.-->
```

</aside>

## Pull Request

PR 의 제목은 Issue 를 따른다. 부가적인 명시가 필요하다면 [issue 제목] : [부가적인 사항] 이런 식으로 네이밍한다.

```
## 관련 이슈
<!-- 해결한 문제를 지정하는 Issue Index에 연결해야 합니다. -->

- Resolves : 

## 작업 사항
<!-- 해당 Pull Request에서 수행한 작업 목록을 제시해야 합니다. -->

## DB 변경 사항
<!-- 작업 사항이 DB에 영향이 있는 작업이라면 변경 사항을 적어야 합니다. -->

## 참고 사항
<!-- 기능을 만들기 위해 다른사람들이 참고해야할 사항을 적습니다. -->

## 변경된 API
<!-- 프론트엔드 개발자와 공유하기 위해 텔레그램을 통해 공유될 API 변동사항을 적습니다. ex) [API description](명세서 링크) -->

```