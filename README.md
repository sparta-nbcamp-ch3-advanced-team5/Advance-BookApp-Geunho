## 📖 BOOKAPP 
카카오 책 검색하기 Rest API를 이용한 심플한 책 검색 앱</br>
[API 주소](https://developers.kakao.com/docs/latest/ko/daum-search/dev-guide#search-book)

## 🗓️ 프로젝트 기간
2025.05.08 ~ 2025.05.19

## 📱 실행화면
> 시연영상</br>

![Simulator Screen Recording - iPhone 16 Pro - 2025-05-19 at 11 00 53](https://github.com/user-attachments/assets/aaa3b261-9a31-4f89-974d-244f0c0043ee)
</br>

> 다크모드 화면</br>

<p align="center">
  <img src="https://github.com/user-attachments/assets/610ccd87-e076-40f0-922e-439db3f4730a" width="30%" />
  <img src="https://github.com/user-attachments/assets/ebde219a-80ca-4cbb-9f6b-fb9aba4065c3" width="30%" />
  <img src="https://github.com/user-attachments/assets/dfe45229-558c-4fb8-afaf-976cb30e2e77" width="30%" />
</p>

## ⚙️ 프로젝트 기능
- 카카오 REST API를 활용한 책 검색 기능
- 책 장바구니 추가 기능 (개수 추가, 전체 삭제, 1에서 -시 개별 삭제)
- API의 meta를 이용하여 무한 스크롤

## 🛠️ 기술 스택

### 아키텍처
- Clean Architecture + Coordinator
(MVVM에서 리팩토링)

### 데이터 처리
- CoreData

### 라이브러리
- SnapKit
- RxSwift
- SwiftLint
- Kingfisher

### UI Frameworks
- UIKit
- AutoLayout

## 🚨 Trouble Shooting
[관련링크](https://feather-cotija-f8b.notion.site/BOOKAPP-Trouble-Shooting-1f86a15498a0804290a9f87546e026b0?pvs=4)</br>
- Multiple commands produce '…Info.plist' 오류
- autoLayout multipliedBy 관련 오류
- 두 개의 섹션 중 첫번째 섹션만 보이는 오류
- 최근 본 책 뷰 셀 크기 오류
- 무한 스크롤 로직 오류
- 스크롤 도중 검색 시 스크롤 동작 오류
- 스크롤 도중 검색 시 검색 데이터 섞임 오류
- Cannot assign value of type 'BookResponseRepository' to type 'any BookResponseRepositoryProtocol 오류
- Class _TtC7RxSwift9AtomicInt is implemented in both ... 오류 
- navigateBookInfoVIew 관련 타입 오류
- Coordinator 조기 메모리 해제 오류
- 버튼 텍스트 설정 오류

## 🔍 메모리 누수 확인
![스크린샷 2025-05-19 09 07 49](https://github.com/user-attachments/assets/0a2d6175-9b03-4718-87bc-a1577af7a96e)

## 🗂️ 파일 구조
~~~
|-- BookApp
|   |-- Application
|   |   |-- AppDelegate.swift
|   |   |-- BookApp.xcdatamodeld
|   |   |   `-- BookApp.xcdatamodel
|   |   |       `-- contents
|   |   |-- Coordinator.swift
|   |   |-- DIContainer.swift
|   |   `-- SceneDelegate.swift
|   `-- Resources
|       |-- APIKeys.plist
|       |-- Assets.xcassets
|       |   |-- AccentColor.colorset
|       |   |   `-- Contents.json
|       |   |-- AppIcon.appiconset
|       |   |   `-- Contents.json
|       |   |-- Contents.json
|       |   `-- bookImage.imageset
|       |       |-- Contents.json
|       |       `-- bookImage.jpg
|       |-- Base.lproj
|       |   `-- LaunchScreen.storyboard
|       `-- Info.plist
|-- DataLayer
|   |-- DataLayer.docc
|   |   |-- DataLayer.md
|   |   `-- Resources
|   |-- DataLayer.swift
|   |-- Entity
|   |   |-- BookDTO.swift
|   |   |-- CartInfoDTO.swift
|   |   |-- CartItemDTO.swift
|   |   `-- MetaDataDTO.swift
|   |-- Repository
|   |   |-- BookResponseRepository.swift
|   |   |-- CartCoreDataRepository.swift
|   |   `-- RecentBookCoreDataRepository.swift
|   `-- Translator
|       |-- BookTranslator.swift
|       |-- CartInfoTranslator.swift
|       |-- CartItemTranslator.swift
|       `-- MetaDataTranslator.swift
|-- DomainLayer
|   |-- DomainLayer.docc
|   |   |-- DomainLayer.md
|   |   `-- Resources
|   |-- DomainLayer.swift
|   |-- Model
|   |   |-- Book.swift
|   |   |-- BookResponse.swift
|   |   |-- CartInfo.swift
|   |   |-- CartItem.swift
|   |   `-- MetaData.swift
|   |-- Protocol
|   |   |-- Repository
|   |   |   |-- BookResponseRepositoryProtocol.swift
|   |   |   |-- CartCoreDataRepositoryProtocol.swift
|   |   |   `-- RecentBookCoreDataRepositoryProtocol.swift
|   |   `-- Usecase
|   |       |-- BookResponseUsecaseProtocol.swift
|   |       |-- CartUsecaseProtocol.swift
|   |       `-- RecentBookUsecaseProtocol.swift
|   `-- Usecase
|       |-- BookResponseUsecase.swift
|       |-- CartUsecase.swift
|       `-- RecentBookUsecase.swift
|-- PresentationLayer
|   |-- Cart
|   |   |-- View
|   |   |   |-- CartItemCell.swift
|   |   |   `-- CartViewController.swift
|   |   `-- ViewModel
|   |       `-- CartViewModel.swift
|   |-- Extensions
|   |   |-- String+Extension.swift
|   |   `-- UIViewContoller+Extension.swift
|   |-- Info
|   |   |-- View
|   |   |   `-- InfoViewController.swift
|   |   `-- ViewModel
|   |       `-- InfoViewModel.swift
|   |-- PresentationLayer.docc
|   |   |-- PresentationLayer.md
|   |   `-- Resources
|   |-- PresentationLayer.swift
|   |-- Protocol
|   |   `-- Protocol.swift
|   `-- Search(Main)
|       |-- View
|       |   |-- BookInfoCell.swift
|       |   |-- RecentBookCell.swift
|       |   |-- SearchViewController.swift
|       |   `-- SectionHeaderView.swift
|       `-- ViewModel
|           `-- SearchViewModel.swift
`-- README.md
~~~
