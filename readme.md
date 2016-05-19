# Swift MVVM

There are many ways to apply MVVM concept, and this is one variant

<img src="https://raw.githubusercontent.com/rickyngk/swift-mvvm/master/assets/MVVM.png" alt="MVVM flow" height="400px"/>

In this sample, we start working with model and use some utility frameworks for easier life . We use:
  - [RxSwift & RxCocoa](https://github.com/ReactiveX/RxSwift): use for pub/sub method for data binding & UI binding
  - [RealmSwift](https://realm.io/docs/swift/latest/): use Realm for data model
  - [Alamofire](https://github.com/Alamofire/Alamofire) & RxAlamofire(https://github.com/RxSwiftCommunity/RxAlamofire): HTTP Networking

Projects structures:

    ├─ models
    ├─ stores
    ├─ views
    ├─ viewmodels
    ├─ helpers

  - **models**: contains all model class
  - **store**: interface to work with data that stores in local storage, local database or rest-api.

  - **views**: iOS View & View Controller
  - **viewmodels**: MVVM view-models
  - **helpers**: helper components

## 1. Model
We use [Realm](https://realm.io/docs/swift/latest/ "Realm") to define mode, for exmaple:

```swift
class Repo: Object {
    dynamic var id = 0;
    dynamic var full_name:String = "";
    dynamic var language:String? = ""
    
    override class func primaryKey() -> String? {
        return "id";
    }
}
```

## 2. Store
Interface to work with data that stores in local storage, local database or rest-api. Each store SHOULD BE separeted into two components: protocol and Impl. That help more easier to do unit test later

Protocol
```swift
protocol RepoStore {
    func fetchRepo(filer: String) -> Driver<[Repo]>
}
```

Implement
```swift
class RepoStoreImpl: RepoStore {
    internal func fetchRepo(query: String) -> Driver<[Repo]> {
        let query = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let url = "https://api.github.com/search/repositories?q=\(query)+in:name";
        
        return JSON(.GET, url)
            .asDriver(onErrorJustReturn: [])
            .map({ json -> [Repo] in
                guard let items = json["items"] as? [AnyObject] else {return []}
                return items.map {Repo(value: $0)}
            })
    }
}
```

## 3. ViewModels
A viewmodel take apart:
  - ViewModel <~> View: See [ViewModel Protocol](#32-viewmodel-protocol)
    + store [ViewState](#31-viewstate)
    + handle command sent from View
    + notify View whenever viewState is changed

  - ViewModel <~> Model
    + Call store API to get data
    + Handle data event retuns from store API
    + Update viewState if any

### 3.1. ViewState
ViewState is state of view - a structure contains all view's properties. For example:
```swift
struct GithubRepoViewState: ViewState {
    let isLoading: Bool
    let repoData: [Repo]
    
    init(isLoading:Bool, repoData: [Repo]) {
        self.isLoading = isLoading;
        self.repoData = repoData
    }
}
```
There're two properties in this view-state:  `isLoading`, `reportData`. Those properties will be mapped to UI components later

**Important**: all properties SHOULD be **immutable**. Any change will create a new ViewState instance. For example, we don't do this:
```swift
let vs = GithubRepoViewState(isLoading: true, [Repo]())
vs.isLoading  = false //don't do this
```
We should:
```swift
let vs = GithubRepoViewState(isLoading: true, [Repo]())
let newState = GithubRepoViewState(isLoading: false, vs.repoData)
```

### 3.2. ViewModel Protocol

```swift
protocol ViewModelProtocol: class {
    func execute(command:Any, data:AnyObject?) -> Void;
    func getViewState() -> ViewState;
    func setViewState(viewstate: ViewState) -> Void;
    var viewStateStream:PublishSubject<(ViewState, ViewState)> {get}
}
```
  - `execute`: UI call `execute` function to send a command to viewModel. This action may make viewState changed:  
  `oldViewState --> execute(command) --> newViewState`
  - get/set ViewState: View can get/set viewState snapshop. But set viewState directly from UI view is not recommended. 
  - `viewStateStream`: View subscribes this event to know when viewState changed

### 3.3 CommonViewModel
A simple implementation of ViewModel Protocol. When viewState changed, viewStateStream will raise event immediately

```swift
class CommonViewModel<T>: ViewModelProtocol {
    var onViewStateChanged: ((ViewModelProtocol, ViewState, ViewState?) -> ())?
    var viewStateStream = PublishSubject<(ViewState, ViewState)>()
    
    var viewState:T?  {
        willSet(newState) {
            let ns:ViewState = newState as! ViewState
            let current = self.viewState as? ViewState
            if (current == nil) {
                viewStateStream.onNext((ns, ViewStateNull.sharedInstance))
            } else {
                viewStateStream.onNext((ns, current!))
            }
        }
    }
    
    func execute(command:Any, data:AnyObject? = NSNull()) {}
    
    func getViewState() -> ViewState {
        return viewState! as! ViewState
    }
    
    func setViewState(vs: ViewState) {
        self.viewState = vs as? T
    }
}
```

### 3.4. Manage data model
`CommonViewModel` does not manage ViewModel <~> Model flow. We can extend it for specific purpose. 

```swift
struct GithubRepoViewState: ViewState {
    let isLoading: Bool
    let repoData: [Repo]
    
    init(isLoading:Bool, repoData: [Repo]) {
        self.isLoading = isLoading;
        self.repoData = repoData
    }
}

class GithubRepoViewModel: CommonViewModel<GithubRepoViewState> {
    internal enum Command:Int {
        case FetchData = 1
    }
    
    internal var repoStore:RepoStore?
    private let bag = DisposeBag()
    
    override func execute(command:Any, data:AnyObject? = NSNull()) {
        if let command:Command = command as? Command {
            switch command {
            case .FetchData:
                let q:String = data as! String
                self.viewState = GithubRepoViewState(isLoading: true, repoData: self.viewState!.repoData)
                self.repoStore!
                    .fetchRepo(q)
                    .driveNext({[unowned self] (repos) in
                        self.viewState = GithubRepoViewState(isLoading: false, repoData: repos)
                    })
                    .addDisposableTo(bag)
                break
            }
        }
    }

    func injectRepoStore(repoStore:RepoStore) -> GithubRepoViewModel {
        self.repoStore = repoStore
        return self
    }
}
```

In this sample, when ViewModel receive event `FecthData`, it will contact with RepoStore (a kind of store) to get data. After receiving data from store, it updates ViewState itself.

```swift
self.repoStore!
    .fetchRepo(q)
    .driveNext({[unowned self] (repos) in
        self.viewState = GithubRepoViewState(isLoading: false, repoData: repos)
    })
    .addDisposableTo(bag)
```

**Important**: viewModel does not contain StoreImpl directly, it contains Store Protocol. After creating new instance of viewModel, StoreImpl should be injected. This way helps us easy to mock storeA api for testing purpose

```swift
let viewModel = GithubRepoViewModel()
      .injectRepoStore(RepoStoreImpl())
```

## 4. View

View is any iOS UIView or UIViewController. View always contains viewModel.

In this snipet code, viewModel instance is allocated, then view subscribe to `viewStateStream` to listen any change from viewState

```swift
viewModel = GithubRepoTableViewCellViewModel()
    viewModel.viewStateStream.subscribeNext { (state) in
            let newViewState = state.0 as! GithubRepoTableViewCellViewState
            self.repoName.text = newViewState.name
        }
        .addDisposableTo(bag);
```

  - `state.0` is new state
  - `state.1` is old state
  
Any change in view should be come from viewModel State change event. For example, to update `repoName.text` (which mapped to `viewState.name` (`self.repoName.text = newViewState.name`)


```swift
self.viewModel.execute(GithubRepoTableViewCellViewModel.Command.UpdateData, data: repo)
```

In case you wanna check if a property is really changed

```swift
let newViewState = state.0 as! AwesomeViewState
let oldViewState = state.1 as? AwesomeViewState
if oldViewState == nil || oldViewState!.something != newViewState.something {
    //TODO
}
```
`oldViewState == nil` mean this is first time init, and there's no old state

