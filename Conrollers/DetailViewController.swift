//
//  DetailViewController.swift
//  ToDoApp
//
//  Created by 최정은 on 2023/09/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    lazy var buttons: [UIButton] = [redButton, greenButton, blueButton, purpleButton]
    
    let toDoDataManager = ToDoDataManager.shared
    
    let hintText = "텍스트를 여기에 입력하세요."
    
    // ToDo 색깔 구분을 위해 임시적으로 숫자저장하는 변수
    // (나중에 어떤 색상이 선택되어 있는지 쉽게 파악하기 위해)
    var temporaryNum: Int64? = 0
    
    var toDoData: ToDoData? {
        didSet{
            temporaryNum = toDoData?.color
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        configureUI()
    }
    
    func setup() {
        mainTextView.delegate = self
        
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 10
        
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 8
        
        buttons.forEach { button in
            button.layer.cornerRadius = button.frame.height / 2
        }
        
        clearButton()
    }
    
    func configureUI() {
        
        if let toDoData = self.toDoData {
            
            title = "메모 수정하기"
            
            temporaryNum = toDoData.color
            mainTextView.text = toDoData.memoText
            saveButton.setTitle("UPDATE", for: .normal)
            
            mainTextView.textColor = .black
            mainTextView.becomeFirstResponder()
        }
        else
        {
            title = "새로운 메모 생성하기"
            
            saveButton.setTitle("SAVE", for: .normal)
            
            mainTextView.text = hintText
            mainTextView.textColor = .lightGray
            
            
        }
        
        setUIColor( temporaryNum ?? 0 )
    }
    

    // MARK: - 버튼 색 초기화
    func clearButton(){
        buttons.forEach { button in
            button.backgroundColor = MyColor(rawValue: Int64(button.tag))?.backgoundColor
            button.setTitleColor(MyColor(rawValue: Int64(button.tag))?.buttonColor, for: .normal)
        }
    }
    
    // MARK: - 선택된 버튼 색으로 UI 변경
    func setUIColor(_ num: Int64){
        buttons[Int(num)].backgroundColor = MyColor(rawValue: num)?.buttonColor
        buttons[Int(num)].setTitleColor(.white, for: .normal)
        
        backView.backgroundColor = MyColor(rawValue: num)?.backgoundColor
        saveButton.backgroundColor = MyColor(rawValue: num)?.buttonColor
    }
    
    // MARK: - 버튼 선택 이벤트
    @IBAction func colorButtonTapped(_ sender: UIButton) {
        
        temporaryNum = Int64(sender.tag)

        clearButton()
        setUIColor( temporaryNum ?? 0 )
    }
    
   
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        if let toDoData = self.toDoData{
            
            toDoData.memoText = mainTextView.text
            toDoData.color = temporaryNum ?? 0
            
            toDoDataManager.updateToDoData(newToDoData: toDoData) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        else
        {
            toDoDataManager.insertToDoData(toDoText: mainTextView.text, colorInt: temporaryNum ?? 0) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension DetailViewController: UITextViewDelegate{
    
    // 입력을 시작할때
    // (텍스트뷰는 플레이스홀더가 따로 있지 않아서, 플레이스 홀더처럼 동작하도록 직접 구현)
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == hintText {
            mainTextView.text = nil
            mainTextView.textColor = .black
        }
    }
    
    // 입력이 끝났을때
    func textViewDidEndEditing(_ textView: UITextView) {
        // 비어있으면 다시 플레이스 홀더처럼 입력하기 위해서 조건 확인
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            mainTextView.text = hintText
            mainTextView.textColor = .lightGray
        }
    }
    
}
