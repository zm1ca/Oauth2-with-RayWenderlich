/// Copyright (c) 2017 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import OAuthSwift

class ViewController: UIViewController, UINavigationControllerDelegate {
  
  // MARK: - Private properties
  private var imagePicker = UIImagePickerController()
  
  @IBOutlet private var imageView: UIImageView!
  @IBOutlet private var hatImage: UIImageView!
  @IBOutlet private var glassesImage: UIImageView!
  @IBOutlet private var moustacheImage: UIImageView!
  
  // MARK: - Private methods

  private func openPhoto() {
    imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
    imagePicker.delegate = self
    present(imagePicker, animated: true, completion: nil)
  }
  
  private func presentAlert(_ title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  private func snapshot() -> Data {
    let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
    let fullScreenshot = renderer.image { ctx in
      view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
    }
    UIImageWriteToSavedPhotosAlbum(fullScreenshot, nil, nil, nil)
    return UIImageJPEGRepresentation(fullScreenshot, 0.5) ?? Data()
  }
  
  // MARK: - Gesture Action
  
  @IBAction private func move(_ recognizer: UIPanGestureRecognizer) {
    guard let recognizerView = recognizer.view else { return }
    let translation = recognizer.translation(in: view)
    recognizerView.center = CGPoint(x:recognizerView.center.x + translation.x,
                                    y:recognizerView.center.y + translation.y)
    recognizer.setTranslation(CGPoint.zero, in: view)
  }
  
  @IBAction private func pinch(_ recognizer: UIPinchGestureRecognizer) {
    guard let recognizerView = recognizer.view else { return }
    recognizerView.transform = recognizerView.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
    recognizer.scale = 1
  }
  
  @IBAction private func rotate(_ recognizer: UIRotationGestureRecognizer) {
    guard let recognizerView = recognizer.view else { return }
    recognizerView.transform = recognizerView.transform.rotated(by: recognizer.rotation)
    recognizer.rotation = 0
  }
  
  // MARK: - Menu Action
  
  @IBAction private func openCamera(_ sender: AnyObject) {
    openPhoto()
  }
  
  @IBAction private func hideShowHat(_ sender: AnyObject) {
    hatImage.isHidden = !hatImage.isHidden
  }
  
  @IBAction private func hideShowGlasses(_ sender: AnyObject) {
    glassesImage.isHidden = !glassesImage.isHidden
  }
  
  @IBAction private func hideShowMoustache(_ sender: AnyObject) {
    moustacheImage.isHidden = !moustacheImage.isHidden
  }
  
  @IBAction private func share(_ sender: AnyObject) {
    let oauthswift = OAuth2Swift(
      consumerKey: "1019735259146-tp1fjva4hcfa2dkoaisjh7ece5dr18pj.apps.googleusercontent.com",
      consumerSecret: "",
      authorizeUrl: "https://accounts.google.com/o/oauth2/auth",
      accessTokenUrl: "https://accounts.google.com/o/oauth2/token",
      responseType: "code"
    )
    oauthswift.allowMissingStateCheck = true
    
    oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)
    guard let rwURL = URL(string: "com.zm1caps.Incognito:/oauth2Callback") else { return }
    
    oauthswift.authorize(
      withCallbackURL: rwURL,
      scope: "https://www.googleapis.com/auth/drive",
      state: "",
      success: { credential, response, parameters in
        oauthswift.client.postImage(
          "https://www.googleapis.com/upload/drive/v2/files",
          parameters: parameters,
          image: self.snapshot(),
          success: { response in
            if let _ = try? JSONSerialization.jsonObject(with: response.data, options: []) {
              self.presentAlert("Success", message: "Successfully uploaded!")
            }
          },
          failure: { error in
            self.presentAlert("Error", message: error.localizedDescription)
          })
      },
      failure: { error in
        self.presentAlert("Error", message: error.localizedDescription)
      }
    )
    
    
    
  }
  
}

extension ViewController: UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    imagePicker.dismiss(animated: true, completion: nil)
    imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
  }
}

extension ViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_: UIGestureRecognizer,
                         _ shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
    return true
  }
}
