>## 제1회 iOS 해커톤 - with 루나 at the 앨런 스쿨 참가 레포지토리

# ERIC'S WEATHER APP

</br>

## 프로젝트 소개

</br>

메인 화면, 설정, 도시 검색 화면으로 구성된 간단한 날씨 앱 입니다.

* 대회 참가 기간 : 2022년 10월 5일 ~ 2022년 10월 11일 

* 팀원 : 권승용 [https://github.com/KSYong]

</br>

## 개발 환경 및 라이브러리

* **Xcode 13**
    * Xcode 14 가 출시되었지만, Xcode 13이 더 안정적이라고 판단하여 13으로 진행했습니다. 
* **UIKit**
    * UIKit을 좀 더 연습해 보고 싶었습니다.
    * UIKit 사용자가 많아 추후 있을 코드 리뷰 스터디에서 용이하다고 판단했습니다.

* **라이브러리**
    * 외부 라이브러리 없이 URLSession만 사용해 API 통신을 구현하였습니다. 

</br>

## 핵심 경험

* **델리게이트 패턴에 대한 이해**
    * 세그웨이를 통한 뷰컨트롤러의 이동에서 데이터를 전달할 때 델리게이트 패턴을 사용하였습니다.

* **앱이 백그라운드에서 포어그라운드로 돌아왔을 때 특정 작업 처리 구현**
    *  위치 권한 허용 여부를 묻는 팝업창은 처음 앱을 구동할 때만 나타납니다. 
    * 따라서 위치 권한 허용 여부를 변경하기 위해서는 디바이스의 설정 화면으로 안내할 필요가 있었습니다.

    * 이후 설정을 마치고 앱으로 되돌아왔을 때, 즉 포어그라운드 상태가 되었을 때 변경 사항을 곧바로 반영할 필요가 있었습니다.
    
    * 이를 위해서 백그라운드에서 포어그라운드 상태가 되는 시점에 시행되는 작업을 구현하였습니다.

* **URLSession을 활용한 API 통신**
    * URLSession을 활용해 가져온 JSON 데이터를 파싱하여 구조체에 저장 후 활용해 보았습니다.

* **CoreLocation을 활용한 위치 정보 다루기**
    * 앱의 위치 권한 획득 여부에 따라 서로 다른 뷰를 띄우도록 구현해 보았습니다.
    * 현재 위치의 위.경도 정보를 받아와 API 통신해 보았습니다.

</br>

## 폴더 구조

```
📦allen_hackathon_level2
 ┣ 📂Assets.xcassets
 ┃ ┣ 📂AccentColor.colorset
 ┃ ┃ ┗ 📜Contents.json
 ┃ ┣ 📂AppIcon.appiconset
 ┃ ┃ ┗ 📜Contents.json
 ┃ ┗ 📜Contents.json
 ┣ 📂Base.lproj
 ┃ ┣ 📜LaunchScreen.storyboard
 ┃ ┗ 📜Main.storyboard
 ┣ 📂Controllers
 ┃ ┣ 📜MainViewController.swift // 홈 뷰 컨트롤러
 ┃ ┣ 📜PrivacyViewController.swift // 개인정보처리방침 모달 화면 뷰 컨트롤러
 ┃ ┣ 📜SearchViewController.swift // 도시 이름 검색 화면 뷰 컨트롤러
 ┃ ┗ 📜SettingsTableViewController.swift // 설정 화면 뷰 컨트롤러
 ┣ 📂Helpers
 ┃ ┣ 📜Constants.swift 
 ┃ ┗ 📜Storage.swift 
 ┣ 📂Models
 ┃ ┣ 📜DataManager.swift
 ┃ ┗ 📜WeatherData.swift
 ┣ 📂Networking
 ┃ ┗ 📜NetworkManager.swift
 ┣ 📂Views
 ┃ ┗ 📜SearchTableViewCell.swift
 ┣ 📜AppDelegate.swift
 ┣ 📜Info.plist
 ┗ 📜SceneDelegate.swift
```


</br>

## 문제 및 해결 과정

</br>

작성 예정

</br>



