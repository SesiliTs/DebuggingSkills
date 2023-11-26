//
//  ProductCell.swift
//  Store
//
//  Created by Baramidze on 25.11.23.
//

import UIKit

protocol ProductCellDelegate: AnyObject {
    func removeProduct(for cell: ProductCell)
    func addProduct(for cell: ProductCell)
}

class ProductCell: UITableViewCell {

    @IBOutlet weak var prodImageView: UIImageView!
    @IBOutlet weak var prodTitleLbl: UILabel!
    @IBOutlet weak var stockLbl: UILabel!
    @IBOutlet weak var descrLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var selectedQuantityLbl: UILabel!
    @IBOutlet weak var quantityModifierView: UIView!
    
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    weak var delegate: ProductCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        quantityModifierView.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupUI(){
        quantityModifierView.layer.cornerRadius = 5
        quantityModifierView.layer.borderWidth = 1
        quantityModifierView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func reload(with product: ProductModel) {
        setImage(from: product.thumbnail)
        prodTitleLbl.text = product.title
        stockLbl.text = "\(product.stock)"
        descrLbl.text = "\(product.description)"
        priceLbl.text = "\(product.price)$"
        selectedQuantityLbl.text = "\(product.selectedAmount ?? 0)"
    }
    
    private func setImage(from url: String) {
        
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.prodImageView.image = image
            }
        }
    }
    
    @IBAction func addProduct(_ sender: Any) {
        delegate?.addProduct(for: self)
        if let selectedQuantity = Int(selectedQuantityLbl.text ?? "0") {
            if selectedQuantity < Int(stockLbl.text ?? "0") ?? 0 {
                selectedQuantityLbl.text = "\(selectedQuantity + 1)"
            }
        }
    }
    
    @IBAction func removeProduct(_ sender: Any) {
        delegate?.removeProduct(for: self)
        if let selectedQuantity = Int(selectedQuantityLbl.text ?? "0") {
            if selectedQuantity > 0 {
                selectedQuantityLbl.text = "\(selectedQuantity - 1)"
            }
        }
    }
}
