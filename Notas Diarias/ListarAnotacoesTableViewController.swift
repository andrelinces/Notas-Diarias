//
//  ListarAnotacoesTableViewController.swift
//  Notas Diarias
//
//  Created by Andre Linces on 13/09/21.
//

import UIKit
import CoreData

class ListarAnotacoesTableViewController: UITableViewController {
    
    var context: NSManagedObjectContext!
    var anotacoes: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Cria a constante utilizando a classe UIApplication para depois utlizar a context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.recuperarAnotacoes()
        
    }
    
    func recuperarAnotacoes(){
        
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Anotacao")
        
        
        
        do {
            let anotacoesRecuperadas  =  try context.fetch(requisicao)
            
            self.anotacoes = anotacoesRecuperadas as! [NSManagedObject]
            //teste para verificar se esta funcionando, exibindo o que já esta salvo no banco de dados.
            print(self.anotacoes)
            self.tableView.reloadData()
        } catch let erro as Error {
            print( "Erro ao recuperar as anotações" + erro.localizedDescription )
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.anotacoes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print para testar o funcionamento do método
        //print(indexPath.row)
        
        //Removendo a seleção da célula, para não ficar selecionada após clicar.
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let indice = indexPath.row
        let anotacao = self.anotacoes[ indice ]
        //Para passar os dados para a outra tela quando o usuário clicar na célula
        performSegue(withIdentifier: "verAnotacao", sender: anotacao)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "verAnotacao"{
            
            let viewDestino = segue.destination as! AnotacaoViewController
            viewDestino.anotacao = sender as? NSManagedObject
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaReuso", for: indexPath)
        
        //configura a célula
        let anotacao = self.anotacoes [ indexPath.row ]
        let textoRecuperado = anotacao.value(forKey: "texto")
        let dataRecuperada = anotacao.value(forKey: "data")
        
        //formatar a data
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm "
        
        let novaData = dateFormatter.string( from: dataRecuperada as! Date )
        
        celula.textLabel?.text = textoRecuperado as? String
        celula.detailTextLabel?.text = novaData
        
        return celula
        
    }
    
}
