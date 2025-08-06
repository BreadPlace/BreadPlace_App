# 빵플레이스
> 빵 덕후들을 위한 <위치 기반 베이커리 탐험> 앱
<br>

# Preview
<p align="center">
  <img src="https://github.com/user-attachments/assets/800ee30c-b58c-421f-8c55-6c6ed5f28e81" width="150" />
  <img src="https://github.com/user-attachments/assets/d777f25a-93b6-4511-a27d-1ad8fcf9dc8d" width="150" />
  <img src="https://github.com/user-attachments/assets/e3ac51cb-d653-49e5-a29d-977dd7202da8" width="150" />
  <img src="https://github.com/user-attachments/assets/cc0c96b9-fbf9-4e9c-9de5-a6a833cde77d" width="150" />
  <img src="https://github.com/user-attachments/assets/4c5f89c4-4996-440d-95e5-d351277c2eb7" width="150" />
</p>

<br>

### 💬 "맛있겠다! 여기 나중에 꼭 가봐야지!"
그런데 막상 그 근처를 방문했을 땐 깜빡한 경험, 있으신가요? <br>
빵플레이스는 아래 기능을 통해 빵 덕후들의 아쉬움을 미연에 방지하고 행복한 빵 라이프를 응원합니다. <br>

<br>

### ✨ 주요 기능
- 실시간 위치 확인으로 저장한 빵집에 가까워지면 푸시알림
- 내 주변 저장된 빵집 한눈에 확인
- 리뷰를 통해 다른 방문자가 맛있게 먹은 빵 종류 확인

<br>


# 목차 (Contents)
1.  [기능 소개 (Features)](#1-기능-소개)
2.  [프로젝트 구조 (Project Structure)](#2-프로젝트-구조)
3.  [기술 스택 (Tech Stack)](#3-기술-스택)
4.  [팀 소개 (Developers)](#4-developers)
5.  [세부 규칙 (Convention)](#5-convention)

<br>

# 1. 기능 소개

<br>

## ☑️ 베이커리 탐색
**랜덤 추천 빵집**
- 데이터베이스에 저장된 베이커리 한 곳이 무작위로 홈화면에 추천됩니다.

**메인 지도**
- 내 주변의 베이커리와 카페를 지도로 한눈에 볼 수 있습니다. (위치 기반 검색)

**베이커리 상세**
- 주소, 사진 등 베이커리 상세 정보를 확인할 수 있습니다.

| 랜덤 추천 빵집 | 메인 지도 | 베이커리 상세 |
|:-:|:-:|:-:|
| <img src = "https://github.com/user-attachments/assets/8b289654-0f57-434d-b999-6b78ebb639a9" width="180" />| <img src = "https://github.com/user-attachments/assets/463bd41a-62fb-40eb-be6d-19dcc2b00500" width="180" /> | <img src = "https://github.com/user-attachments/assets/edea8949-e2b9-4fb9-a2d1-366bfe557179" width="180" /> |!

<br>

## ☑️ 텍스트 검색 & 리뷰
**검색**
- 내 주변에 있지 않은 빵집도 텍스트로 검색하여 정보를 확인하거나, 좋아요 설정이 가능합니다.

**리뷰**
- 리뷰 작성을 통해 방문한 베이커리를 기록할 수 있습니다.
- 작성된 리뷰는 해당 베이커리 상세 화면에서 볼 수 있습니다.

| 베이커리 검색 | 리뷰 작성 |
|:-:|:-:|
| <img src = "https://github.com/user-attachments/assets/7fe3dc11-1d5b-4bbb-a9a5-851045642b1d" width="180" /> | <img src = "" width="180" /> |


<br>


## ☑️ 좋아요 & 알림
**좋아요**
- 가고 싶은 빵집 목록을 저장할 수 있습니다.

**알림**
- '좋아요'한 빵집 중에서 알림을 설정할 수 있습니다.
- 알림 설정한 베이커리 근처 100m 이내에 진입하면 푸시 알림을 전송합니다.
- 알림은 최대 20개까지 설정 가능합니다.

| 좋아요 | 알림 |
|:-:|:-:|
| <img src = "https://github.com/user-attachments/assets/be5b1df2-9f0f-4252-8822-480ef0a0f6e3" width="180" /> | <img src = "https://github.com/user-attachments/assets/c92a4997-5997-44a9-b5cd-908d89a0b53c" width="180" /> |!

<br>

## ☑️ 로그인
- 앱 탐색 중 유저 이탈 방지를 위해, 로그인이 필요한 기능에 접근할 때만 로그인을 요청합니다. ex) 좋아요

| Google | kakao |
|:-:|:-:|
| <img src = "https://github.com/user-attachments/assets/a13619a7-fa6c-4b48-b941-decee84250b9" width="180" /> | <img src = "https://github.com/user-attachments/assets/9d671502-6bde-4313-b34b-67c357b78c06" width="180" /> |!

<br>

## ☑️ 기타
**권한 안내**
- **초기 권한 안내**: 앱이 첫 실행일 경우, 선택적 권한을 안내하고 사용자에게 권한을 허용 받습니다.
- **권한 요청**: 이후 백그라운드 위치 권한 요청 등은 기능 실행에 필요한 경우에만 요청합니다. ex) 베이커리 알림 설정 클릭
  
**마이페이지**
- 디바이스 권한 설정, 닉네임 변경, 로그아웃, 회원탈퇴 등 유저에게 필요한 기능을 제공합니다.
- 이용약관, 오픈소스 라이선스, 이메일 문의 등 앱에 대한 설명도 확인할 수 있습니다.

| 초기 권한 안내 | 백그라운드 권한 요청 | 닉네임 변경 |
|:-:|:-:|:-:|
| <img src = "https://github.com/user-attachments/assets/48874a84-cab1-4816-9d81-16f2b9e2e21b" width="180" /> | <img src = "https://github.com/user-attachments/assets/69d4665e-6d38-4f08-88f5-29e83da351ca" width="180" /> | <img src = "https://github.com/user-attachments/assets/298a9c3d-3f8f-462b-87d2-f83f03687ba7" width="180" /> |!

<br>

# 2. 프로젝트 구조
## ✅ Key Architectural Patterns
- BLoC Pattern Implementation
- Clean Architecture Layers
- Dependency Injection

<br>

## ✅ High-Level Architecture Diagram
<img width="1324" height="921" alt="빵플 프로젝트 아키텍처" src="https://github.com/user-attachments/assets/bd9dc64b-fdc4-4fef-9421-02cd93e32eb8" />

<br>

## ✅ Directory Structure
```dart
lib/
├── config/                        
│   ├── constants/                 # enum, color, 예외 처리 등
│   ├── di/                        # 의존성 주입 (get_it)
│   └── routing/                   # 라우트 설정 (Go Router)
│
├── data/                          # 외부 데이터 접근 계층
│   ├── dto/                       # 서버 통신용 DTO 및 Mapper
│   ├── repositories/              # repository 구현체
│   └── services/                  # 외부 서비스(API, Firebase 등) 연동
│
├── domain/                        # 비즈니스 로직 계층
│   ├── entities/                  # 도메인 모델
│   ├── repositories/              # 추상 repository 인터페이스
│   └── usecases/                  
│
├── ui/                            # 프레젠테이션 계층 (기능별 분류)
│   ├── bakery_detail/             # 베이커리 상세 화면
│   │   ├── bloc/
│   │   └── view/
│   ├── common_widgets/            # 공통으로 쓰이는 재사용 UI 위젯
│   ├── home/                      # 홈 화면
│   ├── like/                      # 찜한 베이커리 화면
│   ├── login/                     # 로그인 화면
│   ├── mypage/                    # 마이페이지
│   ├── review/                    # 리뷰 관련 화면
│   └── search/                    # 검색 화면 및 결과 뷰
│
├── utils/                         # 범용 유틸리티 함수 및 확장 메서드
│
├── firebase_options.dart          # Firebase 초기 설정
├── oss_licenses.dart              # 오픈소스 라이선스 관리 파일
│
└── main.dart                      # 앱 진입점 (DI, Router 초기화 등)

```

<br>
<br>

# 3. 기술 스택

## ☑️ Native Platform Integration

| Platform | Technology / Library                      | Purpose                                |
|----------|--------------------------------------------|----------------------------------------|
| Android  | `GeofencingClient`, `BroadcastReceiver`    | Background geofence detection & events |
| iOS      | `CLLocationManager`, `Region Monitoring`   | Native region-based geofencing         |
| 공통     | `MethodChannel`, `EventChannel`            | Flutter ↔ Native 기능 연동 (양방향 통신)  |

<br>

## ☑️ Primary Technologies

| Component              | Technology                  | Purpose                                       |
|------------------------|-----------------------------|-----------------------------------------------|
| Framework              | Flutter               | Cross-platform mobile development             |
| State Management       | BLoC              | Reactive state management pattern             |
| Navigation             | GoRouter          | Declarative routing system                    |
| Dependency Injection   | GetIt            | Service locator pattern                       |
| Backend Services       | Firebase       | Authentication, database, storage             |
| Maps & Location        | Google Maps Flutter | Map visualization and location services       |
| Local Storage          | SharedPreferences    | Device-local data persistence                 |
| API 통신               | Retrofit + Dio              | HTTP 클라이언트, RESTful API 통신 처리         |

<br>

## ☑️ External Service Integrations

| Service             | Implementation                     | Code Entity                |
|---------------------|--------------------------------------|----------------------------|
| Authentication      | Firebase Auth + Social Logins        | FirebaseAuth, Kakao/Google SDKs |
| Database            | Cloud Firestore                      | FirestoreService           |
| File Storage        | Firebase Storage                     | FirebaseStorage            |
| Bakery Data         | Google Places API                    | GooglePlacesAPI            |
| Location Services   | Geolocator + Native APIs             | UserLocationUseCase        |
| Push Notifications  | Flutter Local Notifications + Native | Geofencing Notifications   |

<br>

# 4. Developers
| 이름 | 프로필 사진 | 담당 기능 |
|-----|---------|---------|
| 김승미 | <img src="https://github.com/joy293.png" width="120">| • Android Native Geofence <br>• 텍스트 기반 장소 검색<br> • 로그인 - Kakao<br> • 프로젝트 구조 설계<br> • 좋아요<br>• 알림<br>• 마이페이지<br>• 로컬 저장소 |
| 강   건 | <img src="https://github.com/kangsworkspace.png" width="120"> | • iOS Native Region Monitoring<br> • 주변 위치기반 베이커리 검색 <br>• 로그인 - Google <br>• 메인 지도<br>• 베이커리 상세<br>• 리뷰<br>• 파이어베이스 |

<br>

# 5. Convention
- [리뷰 가독성을 위한 변수, 함수 등의 순서 컨벤션 논의](https://github.com/BreadPlace/BreadPlace_App/discussions/46#discussion-8423620)
- [커밋 메시지 작성 효율화를 위한 컨벤션 논의](https://github.com/BreadPlace/BreadPlace_App/discussions/22#discussion-8382628)


<br>

<!-- 기술 스택 배지 (BreadPlace) -->
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/BreadPlace/BreadPlace_App)
[![닫힌 이슈 개수](https://img.shields.io/github/issues-closed/BreadPlace/BreadPlace_App)](https://github.com/BreadPlace/BreadPlace_App/issues?q=is%3Aissue+is%3Aclosed)


<!-- 기술 스택 배지 (BreadPlace) -->
[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)](https://developer.android.com)
[![iOS](https://img.shields.io/badge/iOS-000000?style=flat-square&logo=apple&logoColor=white)](https://developer.apple.com/ios)
[![Bloc](https://img.shields.io/badge/BLoC-40C4FF?style=flat-square&logo=bloc&logoColor=white)](https://bloclibrary.dev)
[![GoRouter](https://img.shields.io/badge/GoRouter-4A148C?style=flat-square&logo=flutter&logoColor=white)](https://pub.dev/packages/go_router)
[![Retrofit](https://img.shields.io/badge/Retrofit-FF4081?style=flat-square&logo=android&logoColor=white)](https://pub.dev/packages/retrofit)
[![Dio](https://img.shields.io/badge/Dio-25A2C3?style=flat-square&logo=cloudflare&logoColor=white)](https://pub.dev/packages/dio)
[![GetIt](https://img.shields.io/badge/GetIt-FF6F00?style=flat-square&logo=dependency&logoColor=white)](https://pub.dev/packages/get_it)
[![Google Maps](https://img.shields.io/badge/Google%20Maps-4285F4?style=flat-square&logo=google-maps&logoColor=white)](https://pub.dev/packages/google_maps_flutter)
