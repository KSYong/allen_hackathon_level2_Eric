>## 제1회 iOS 해커톤 - with 루나 at the 앨런 스쿨 참가 레포지토리

# ERIC'S WEATHER APP

</br>

## 프로젝트 소개

</br>

메인 화면, 설정, 도시 검색 화면으로 구성된 간단한 날씨 앱 입니다.

* 대회 참가 기간 : 2022년 10월 5일 ~ 2022년 10월 11일 

* 팀원 : 권승용 [https://github.com/KSYong]

* 구동 화면
  * 도시 탐색 <p align="center"><img src="https://user-images.githubusercontent.com/22342277/195771925-68ceecc5-296b-4203-a0d5-ed1be89ebaad.gif" style="width:300px"/></p>

  * 위치 설정 끄기<p align="center"><img src="https://user-images.githubusercontent.com/22342277/195776617-5139184c-e880-4654-a6a2-d1f3b9559917.gif" style="width:300px"/></p>
  
  * 위치 설정 켜기 및 현재 위치로 이동<p align="center"><img src="https://user-images.githubusercontent.com/22342277/195775564-717939a5-4927-4a8f-a5b3-14aba70706ea.gif" style="width:300px"/></p>

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

* **SF Symbol 멀티컬러 적용**
    * 날씨 앱의 아이콘 시인성을 높이기 위해 SF Symbol을 사용하였습니다. 
    * 기본 설정인 Monochrome 보다는 Multicolor 옵션이 시인성이 좋을 것이라고 생각해 Multicolor 옵션을 적용해 보았습니다.

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

* ### 앱에게 위치 권한이 없을 때, 앱을 실행하면 SearchView가 두 번 나타나는 문제
   * 문제 발생 이유
        * CLLocationManagerDelegate의 locationManagerDidChangeAuthorization은 권한 설정이 변경될 때 마다 호출되는데, 해당 함수 안에서 앱이 위치 권한이 없는 경우의 performSegue를 실행했기 때문에 생긴 문제이다. 
    * 문제 해결 방법
        * Bool 변수를 추가해 원하는 조건 아래에서만 perofrmSegue가 실행되도록 하였다.
             ```swift
            if !gpsPermission && !didSelectCity {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showSearchVC", sender: self)
                }
            }
            ```
* ### 앱이 백그라운드에서 포어그라운드로 돌아올 때 UISwitch가 업데이트되지 않는 문제
  * 문제 발생 이유
    * 뷰컨트롤러의 라이프 사이클 함수는 앱이 inactive 상태에서 active 상태로 바뀔 때는 호출되지 않는다는 점을 모르고, 뷰 라이프 사이클 함수에 UISwitch 상태 업데이트 함수를 구현하였다.
  * 문제 해결 방법
    * NotificationCenter를 활용해 .didBecomeActiveNotification이 감지될 때, 즉 앱이 active 상태로 들어설 때 UISwitch 업데이트 함수를 실행하도록 변경해 주었다.
      ```swift
         // NotificationCenter를 활용해 현재 위치 사용 설정을 완료 후 되돌아왔음을 알고, 스위치 정보를 업데이트한다.
         NotificationCenter.default.addObserver(self, selector: #selector(activateSwitch), name: UIApplication.didBecomeActiveNotification, object: nil)
         
         ...
         
         // 옵저버 사용 후에는 꼭 deinit에서 할당 해제를 잊지 말자
         deinit {
            if let observer = observer {
              NotificationCenter.default.removeObserver(observer)
            }
          }
      ```
 * ### 라이트모드 및 다크모드 적용 시 테마가 달라지는 문제
   * 문제 발생 이유
     * system 폰트 및 컬러를 사용하였기 때문에 light/dark 모드에 따라 색이 변하는 문제가 있었다.
   * 문제 해결 방법
     * 각 뷰들에 대한 설정을 각각 바꿔주는 것 보다는 viewDidLoad() 시에 강제 다크 모드를 적용하여 문제를 해결하였다.
       ```swift
        override func viewDidLoad() {
          super.viewDidLoad()
          overrideUserInterfaceStyle = .dark
        }
        ```
        
 * ### 뷰컨트롤러는 다크 모드가 강제 적용되었지만, 네비게이션 컨트롤러는 적용되지 않는 문제
   * 문제 발생 이유
     * 네비게이션 컨트롤러가 별개의 뷰컨트롤러로 취급되기 때문에 따로 .overrideUserInterfaceStyle 적용을 통해 강제 다크 모드를 적용해 주어야 한다.
   * 문제 해결 방법
     * 네비게이션컨트롤러에도 다크모드 강제 적용하여 해결
       ```swift
         override func viewDidLoad() {
           super.viewDidLoad()
           self.navigationController?.overrideUserInterfaceStyle = .dark
         }
        ```
* ### changing items while animating can result in a corrupted navigation bar 오류 
  * 문제 발생 양상
    * performSegue를 통해 도시 탐색 화면으로 이동 후, 네비게이션바의 Back 버튼을 탭해서 메인 화면으로 돌아가면 해당 에러 메시지와 함께 앱이 멈추는 현상 (실제 디바이스에서만 발생) 
  * 문제 발생 이유
    * 메인 뷰에서는 네비게이션 바를 숨기는데, 해당 로직은 다음과 같다. 
      ```swift
      // MainViewController.swift
      override func viewWillLayoutSubViews() {
        super.viewWillLayoutSubView()
        self.navigationController?.setNavigationBarHidden(true, animated:true)
      }
      ```
    * 도시 탐색 뷰에서는 네비게이션 바를 다시 보이게 한다. 
      ```swift
      // SearchViewController.swift
      override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
      }
      ```
    * 해당 오류는 navigation controller에 등록되어 있는 뷰의 pop이나 push가 완료되지 않았을 때 pop이나 push를 하려고 할 때 나타난다고 한다. 처음에는 앱이 멈추는 이유를 찾기 어려웠는데, 차근차근 디버깅해본 결과 네비게이션 바를 숨기고 나타내는 과정에서 문제가 있었다. 
   * 문제 해결 방법
     * 메인 뷰 컨트롤러 내부에서 네비게이션 바를 숨기고 보이는 로직을 모두 처리하게 하였다. 또한 viewWillLayoutSubView() 가 아닌 viewWillAppear(), viewWillDisappear()에서 해당 동작을 수행하였다.
       ```swift
       override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          self.navigationController?.isNavigationBarHidden = true
       }
    
       override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          self.navigationController?.isNavigationBarHidden = false
       }  
       ```
</br>

## Commit Convention

커밋 컨벤션은 Udacity Git Commit Message Style Guide 를 따릅니다.

* feat: A new feature
* fix: A bug fix
* docs: Changes to documentation
* style: Formatting, missing semi colons, etc; no code change
* refactor: Refactoring production code
* test: Adding tests, refactoring test; no production code change
* chore: Updating build tasks, package manager configs, etc; no production code change



