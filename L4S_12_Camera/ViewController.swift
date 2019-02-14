//
//  ViewController.swift
//  L4S_12_Camera
//
//  Created by 鍋島 由輝 on 2019/02/14.
//  Copyright © 2019 ValJapan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraImageView: UIImageView!

    //画像加工するための元となる画像
    var originalImage: UIImage!

    //画像加工するフィルターの宣言
    var filter: CIFilter!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //"撮影する"ボタンを押したときのメソッド
    @IBAction func takePhoto() {
        //カメラが使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.camera) {

            //カメラを起動
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self

            picker.allowsEditing = true

            present(picker, animated: true, completion: nil)
        } else {
            //カメラが使えない時はエラーをコンソールに出す
            print("error")
        }
    }

    //カメラ、カメラロールを使ったときに選択肢た画像をアプリ内に表示するためのメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        cameraImageView.image = info[.editedImage]as? UIImage

        originalImage = cameraImageView.image

        dismiss(animated: true, completion: nil)
    }


    //編集した画像を保存するためのメソッド
    @IBAction func savePhoto() {

        UIImageWriteToSavedPhotosAlbum(cameraImageView.image!, nil, nil, nil)
    }

    //表示している画像にフィルター加工をするときのメソッド
    @IBAction func colorFilter() {
        let filterImage: CIImage = CIImage(image: originalImage)!

        //フィルターの設定
        filter = CIFilter(name: "CIColorControls")
        filter.setValue(filterImage, forKey: kCIInputImageKey)

        //彩度の調整
        filter.setValue(1.0, forKey: "imputSaturation")

        //明度の調整
        filter.setValue(0.5, forKey: "inputBrightness")

        //コントラストの調整
        filter.setValue(2.5, forKey: "inputContrast")

        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraImageView.image = UIImage(cgImage: cgImage!)
    }

    //カメラロールにある画像を読み込むときのメソッド
    @IBAction func openAlbum() {
        //カメラロール使えるか確認する
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {

            //カメラロールの画像を選択肢して、画像を表示するまでの一連の流れ
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self

            picker.allowsEditing = true

            present(picker, animated: true, completion: nil)
        }
    }

    //SNSに編集した画像を投稿したいときのメソッド
    @IBAction func snsPhoto() {

        //投稿するときに一緒に乗せるコメント
        let shareText = "写真加工いえい"

        //投稿する画像を選択
        let shareImage = cameraImageView.image!

        //投稿するコメントと画像の準備
        let activityItems: [Any] = [shareText, shareImage]

        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

        let excludedActivityTypes = [UIActivity.ActivityType.postToWeibo, .saveToCameraRoll, .print]

        activityViewController.excludedActivityTypes = excludedActivityTypes

        present(activityViewController, animated: true, completion: nil)
    }

}

