import UIKit
import os.log

class ArtWorkViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {
    //MARK: Props
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var artWorkNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    //TODO: Set new names to years, if they are
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    //these two
    @IBOutlet weak var genreText: UILabel!
    @IBOutlet weak var genrePicker: UIPickerView!
    @IBOutlet weak var descrText: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddArtWorkMode = presentingViewController is UINavigationController
        if isPresentingInAddArtWorkMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
        
    }
    //MARK: Vars
    var years : [String] = []
    var genres = [ "Ампир", "Ар бюрт", "Барокко","Баухаус", "Кубизм‎", "Минимализм", "Модернизм", "Метамодернизм", "Неоромантизм", "Романтизм", "Символизм", "Постмодернизм", "Экспрессионизм‎"]
    var artWork: ArtWork?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        nameTextField.delegate = self
        if let artWork = artWork {
            navigationItem.title = artWork.name
            nameTextField.text = artWork.name
            text.text = artWork.year
            genreText.text = artWork.genre
            descrText.text = artWork.descriptionT
            photoImageView.image = artWork.image
        
        }
        updateSaveButtonState()
        descrText.delegate = self
        for item in 1400...2018 {
            let myString = String(item)
            years.append(myString)
        }
        picker.delegate = self
        picker.dataSource = self
        //\\
        genrePicker.delegate = self
        genrePicker.dataSource = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == picker{
            return years.count
        }
        if pickerView == genrePicker{
            return genres.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var temp = ""
        if pickerView == picker{
            temp = years[row]}
        else if pickerView == genrePicker{
            temp = genres[row]}
        return temp
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == picker{
            return text.text = years[row]
        }
        if pickerView == genrePicker {
            return genreText.text = genres[row]
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //artWorkNameLabel.text = textField.text
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    //hide the keyboard from the textview
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            descrText.resignFirstResponder()
            return false
        }
        return true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    //MARK: Nav
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = nameTextField.text ?? ""
        let descriptionT = descrText.text ?? ""
        let genre = genreText.text ?? ""
        let year = text.text ?? ""
        let image = photoImageView.image

    artWork = ArtWork(name: name, descriptionT:descriptionT, genre: genre, year: year, image: image)
    }
    
    //MARK: Actions
    
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}
