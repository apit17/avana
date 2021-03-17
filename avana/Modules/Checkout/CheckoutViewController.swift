//
//  CheckoutViewController.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/17/21.
//

import UIKit
import RxSwift
import RxCocoa

class CheckoutViewController: UIViewController {
    fileprivate let viewModel: CheckoutViewModel
    fileprivate let router: CheckoutRouter
    fileprivate let disposeBag = DisposeBag()

    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!

    private var selectedProof: UIImage?

    init(withViewModel viewModel: CheckoutViewModel, router: CheckoutRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayout()
        setupRx()
    }
}

// MARK: Setup
private extension CheckoutViewController {

    func setupViews() {
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.register(UINib(nibName: String(describing: ProductTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ProductTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: PaymentProofTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PaymentProofTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }

    func setupLayout() {
        customerLabel.text = viewModel.customerName

        submitButton.layer.cornerRadius = 6
        submitButton.layer.borderWidth = 1.5
        submitButton.layer.borderColor = UIColor.systemGray6.cgColor
    }

    func setupRx() {
        submitButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.handleSubmit()
            }).disposed(by: disposeBag)
    }

    func handleSubmit() {
        if let _ = selectedProof {
            self.router.dismiss()
        } else {
            let alert = UIAlertController(title: "", message: "Please upload your document proof first.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }

    func presentPicker() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true

        let alert = UIAlertController(title: "", message: "Select document source", preferredStyle: .actionSheet)
        let document = UIAlertAction(title: "Document", style: .default) { [weak self] (_) in
            self?.present(documentPicker, animated: true, completion: nil)
        }

        let gallery = UIAlertAction(title: "Photo Library", style: .default) { [weak self] (_) in
            picker.sourceType = .photoLibrary
            self?.present(picker, animated: true, completion: nil)
        }

        let camera = UIAlertAction(title: "Camera", style: .default) { [weak self] (_) in
            picker.sourceType = .camera
            self?.present(picker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(document)
        alert.addAction(gallery)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    func drawPDFfromURL(url: URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }
        let dpi: CGFloat = 300.0 / 72.0
        let pageRect = page.getBoxRect(.mediaBox)

        let renderer = UIGraphicsImageRenderer(size: CGSize(width: pageRect.size.width * dpi, height: pageRect.size.height * dpi))

        let img1 = renderer.jpegData(withCompressionQuality: 1.0, actions: { cnv in
            UIColor.white.set()
            cnv.fill(pageRect)
            cnv.cgContext.translateBy(x: 0.0, y: pageRect.size.height * dpi)
            cnv.cgContext.scaleBy(x: dpi, y: -dpi)
            cnv.cgContext.drawPDFPage(page)

        })
        let img2 = UIImage(data: img1)
        return img2
    }

    func getImageHeight(cellFrame: CGSize, image: UIImage) -> CGFloat {
        let widthOffset = image.size.width - cellFrame.width
        let widthOffsetPercentage = (widthOffset * 100) / image.size.width
        let heightOffset = (widthOffsetPercentage * image.size.height) / 100
        let effectiveHeight = image.size.height - heightOffset
        return effectiveHeight
    }
}

extension CheckoutViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.sections[indexPath.section] {
        case .product:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductTableViewCell.self), for: indexPath) as! ProductTableViewCell
            if let product = viewModel.product {
                cell.configure(viewModel: ProductViewModel(product: product))
            }
            return cell
        case .proof:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PaymentProofTableViewCell.self), for: indexPath) as! PaymentProofTableViewCell
            var cellFrame = cell.frame.size
            cellFrame.height =  cellFrame.height - 15
            cellFrame.width =  cellFrame.width - 15
            if let image = selectedProof {
                cell.proofImage.image = image
                cell.imageHeight.constant = getImageHeight(cellFrame: cellFrame, image: image)
            } else {
                let image = UIImage(systemName: "folder.badge.plus", withConfiguration: UIImage.SymbolConfiguration(weight: .light)) ?? UIImage()
                cell.proofImage.image = image
                cell.imageHeight.constant = 50
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.sections[indexPath.section] == .proof {
            presentPicker()
        }
    }
}

extension CheckoutViewController: UIDocumentPickerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            return
        }
        selectedProof = drawPDFfromURL(url: url)
        tableView.reloadData()
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        selectedProof = info[.editedImage] as? UIImage
        dismiss(animated: true) {
            self.tableView.reloadData()
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
