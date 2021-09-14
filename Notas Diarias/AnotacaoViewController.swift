//
//  AnotacaoViewController.swift
//  Notas Diarias
//
//  Created by Andre Linces on 13/09/21.
//

import UIKit
import CoreData

class AnotacaoViewController: UIViewController {
   //referencia do texto
    @IBOutlet weak var texto: UITextView!
    var context: NSManagedObjectContext!
    var anotacao: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configuracoes iniciais
        self.texto.becomeFirstResponder()
        
        if anotacao != nil {//atualizar
            if let textoRecuperado = anotacao.value(forKey: "texto"){
            self.texto.text = String(describing: textoRecuperado )
            }
        }else{
            texto.text = ""
        }
        
        
        //Cria a constante utilizando a classe UIApplication para depois utlizar a context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
    }
    //referencia do botao salvar, será utilizado para salvar e atualizar.
    @IBAction func salvar(_ sender: Any) {
        
        self.salvarAnotacao()
        
        //retorna para tela inicial
        self.navigationController?.popToRootViewController(animated: true)
        
        
    }
    //Método para salvar a nova anotação
    func salvarAnotacao(){
        
        //Cria objeto para anotação
        let novaAnotacao = NSEntityDescription.insertNewObject(forEntityName: "Anotacao", into: context)
        
        //Configura anotação
        novaAnotacao.setValue(self.texto.text , forKey: "texto")
        novaAnotacao.setValue(Date() , forKey: "data")
        
        do {
            try context.save()
            print("Sucesso ao salvar anotação!")
        } catch let erro as Error {
            print( "Erro ao salvar anotação" + erro.localizedDescription )
        }
        
    }
    
    
}
