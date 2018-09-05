//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
    }
}


class UnitStackView: UIStackView {
    var desciptionLabel = UILabel()
    var detailLabel = UILabel()
    var tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap) )
    
    @objc func tap() {
        print("Tap")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        desciptionLabel.text = "desciptionLabel"
        detailLabel.text = "detailLabel"
        self.addSubview(desciptionLabel)
        self.addSubview(detailLabel)
        
        self.axis = .vertical
        self.distribution = .fillEqually
        
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class DoubleUnitStackView: UIStackView {
    let firstUnitStackView = UnitStackView()
    let secondUnitStackView = UnitStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(firstUnitStackView)
        self.addSubview(secondUnitStackView)
        
        self.axis = .horizontal
        self.distribution = .fillEqually
        
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

class StackedCell: UITableViewCell {
    
    let doubleUnitStackView = DoubleUnitStackView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.doubleUnitStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(doubleUnitStackView)
        
        let constraints = [doubleUnitStackView.topAnchor.constraint(equalTo: topAnchor),
                           doubleUnitStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                           doubleUnitStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                           doubleUnitStackView.trailingAnchor.constraint(equalTo: trailingAnchor)]
        NSLayoutConstraint.activate(constraints)
    }
}

class TableVC: UITableViewController {
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Stacked Cell", for: indexPath) as! StackedCell
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(StackedCell.self, forCellReuseIdentifier: "Stacked Cell")
        
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = TableVC()
