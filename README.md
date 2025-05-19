## 📖 BOOKAPP 
카카오 책 검색하기 Rest API (https://developers.kakao.com/docs/latest/ko/daum-search/dev-guide#search-book) 를 이용한 심플한 책 검색 앱
</br>

## 🗓️ 프로젝트 기간
2025.05.08 ~ 2025.05.19
</br>

## 📱 실행화면


</br>

## ⚙️ 프로젝트 기능
- 카카오 REST API를 활용한 책 검색 기능
- 책 장바구니 추가 기능
- 무한 스크롤

</br>


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

</br>

## 🚨 Trouble Shooting
- Multiple commands produce '…Info.plist' 오류
- autoLayout multipliedBy 관련 오류
- 두 개의 섹션 중 첫번째 섹션만 보이는 오류
- 최근 본 책 뷰 셀 크기 오류
- 무한 스크롤 로직 오류
- 스크롤 도중 검색 시 스크롤 동작 오류
- 스크롤 도중 검색 시 검색 데이터 섞임 오류
- Cannot assign value of type 'BookResponseRepository' to type 'any BookResponseRepositoryProtocol 오류
- Class _TtC7RxSwift9AtomicInt is implemented in both ... 오류 
- BottomSheetDelegate 관련 오류
- Coordinator 조기 메모리 해제 오류


</br>

## 🔍 메모리 누수 확인
Leaks

</br>

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
