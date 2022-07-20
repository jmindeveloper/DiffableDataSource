# DiffableDataSource

## 개요

**TableViw** 혹은 **CollectionView**를 그리기 위한 데이터를 관리하고 UI를 업데이트

( 해당 글에선 tableView로 설명 )

기존 DataSource와 달리 달라진 부분을 추적하여 자연스럽게 UI를 업데이트 (애니메이션 효과)

## 왜 필요함?

기존 dataSoruce는 데이터가 업데이트되면 **tableView.reloadData()**로 동기화를 해 주었다

하지만 위 메서드는 tableView를 한번에 업데이트 하므로 애니메이션 효과가 적용이 안되 사용자 경험에 나쁘다

하지만 DiffableDataSource같은 경우는 변경된 데이터가 자연스러운 애니메이션 효과로 적용되는것을 볼 수 있다

### DiffableDataSource를 사용함으로서 얻게되는 이점

- 추가적인 작업이 없어도 자연스러운 애니메이션효과가 적용된다
- 개선된 DataSource는 완벽하게 동기적인 버그나 예외, 충돌을 피할 수 있게 해준다
- UI 데이터의 동기화 부분 대신 앱의 동적인 데이터와 내용에 집중할 수 있다

## 어떻게 사용함?

1. DiffableDataSource를 tableView에 연결
    - DiffableDataSource는 **Generic Class**이다
    - 해당 Generic 타입은 Hashable를 준수해야 한다
    - 그외에는 일반 DataSource의 cellForItemAt 메서드를 사용할때처럼 하면 된다
    - 코드
        
        ```swift
        private func configureDiffableDataSource() {
        		dataSource = UITableViewDiffableDataSource<TableViewSection, Item>(tableView: tableView) { table, indexPath, item -> UITableViewCell? in
        				guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? Cell else { return UITableViewCell() }
        				cell.label.text = item.content
        				return cell
        		}
        }
        ```
        
2. dataSource에 snapshot 적용
    - tableView에 보여줄 data가 바뀔때마다 새로운 Snapshot을 만들어서 dataSource에 apply 해줘야 한다
    - snapshot은 section 및 item으로 구성되있다
    - section, item을 추가, 삭제하여 표시할 내용을 구성한다
    - 코드
        
        ```swift
        private func applySnapshot() {
        		var snapshot = NSDiffableDataSourceSnapshot<TableViewSection, Item>()
            snapshot.appendSections([.main])
            snapshot.appendItems(tableViewItem)
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
        ```
        

## 왜 Hashable 해야함?

apply시 각 hashValue를 비교하여 바뀐부분을 인지하기 때문

### 만약 Hashable 프로토콜을 채택했지만 hashValue가 같다면?

앱이 죽음

반드시 각 인스턴스마다 hashValue가 다르게 해줘야함

가장 좋은 방법은 타입에 UUID 프로퍼티를 하나 넣어주는것임

- 코드
    
    ```swift
    struct Item: Hashable {
        // id로 모든 Item 인스턴스가 같은 값을 가지지 못하도록 해줌
        let id = UUID().uuidString
        let content: String
        
        init(content: String) {
            self.content = content
        }
        
        // 해쉬함수
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
    
    // 만약 id가 없어 content로만 hashValue를 만든다면
    // content가 같은 인스턴스들은 hashValue가 같기때문에
    // 앱이 죽음ㅋ
    ```
    
[Notion](https://serious-hamburger-920.notion.site/DiffableDataSource-1d51afdc631844bf9cd637237c4b307b)
