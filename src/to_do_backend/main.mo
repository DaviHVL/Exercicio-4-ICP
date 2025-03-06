// Importação do módulo Buffer
import Buffer "mo:base/Buffer";
import Nat "mo:base/Nat";

// Definição de um ator (actor)
actor {
  // Definição do tipo Tarefa
  type Tarefa = object {
    id : Nat; // Identificador único da tarefa
    categoria : Text; // Categoria da tarefa
    descricao : Text; // Descrição detalhada da tarefa 
    urgente : Bool; // Indica se a tarefa é urgente (true) ou não (false) 
    concluida : Bool; // Indica se a tarefa foi concluída (true) ou não (false) 
  };

  // Variável para armazenar o próximo ID de tarefa
  /* Esta variável será utilizada para armazenar o número do último identificador gerado para uma tarefa. 
  Ela será incrementada sempre que uma nova tarefa for adicionada */
  var idTarefa : Nat = 0;
  // Buffer para armazenar as tarefas
  var tarefas = Buffer.Buffer<Tarefa>(10);

  // Função para adicionar uma nova tarefa ao buffer 'tarefas'
  public func addTarefas(desc : Text, cat : Text, urg : Bool, con : Bool) : async () {
    idTarefa += 1;

    let t : Tarefa = {
      id = idTarefa;
      categoria = cat;
      descricao = desc;
      urgente = urg;
      concluida = con;
    };

    tarefas.add(t);
  };

  // Função para excluir uma tarefa do buffer 'tarefas' pelo ID 
  public func excluirTarefa(idExcluir : Nat) : async() {
    func localizaExcluir(i: Nat, x: Tarefa) : Bool {
      return x.id != idExcluir;
    }; 

    tarefas.filterEntries(localizaExcluir);
  };

  // Função para alterar uma tarefa existente no buffer 'tarefas'
  public func alterarTarefa(idTar : Nat, desc : Text, cat : Text, urg : Bool, con : Bool) : async (){
    let t : Tarefa = {
      id = idTar;
      categoria = cat;
      descricao = desc;
      urgente = urg;
      concluida = con;
    };

    func localizaIndex (x: Tarefa, y: Tarefa) : Bool {
      return x.id == y.id;
    }; 

    let index : ?Nat = Buffer.indexOf(t, tarefas, localizaIndex);

    switch(index){
      case(null) {};

      case(?i){
          tarefas.put(i,t);
      }
    }; 
  };

  // Função para retornar todas as tarefas do buffer 'tarefas'
  public func getTarefas() : async[Tarefa]{
    return Buffer.toArray(tarefas);
  };

  public func totalTarefasEmAndamento() : async Nat {
    var num : Nat = 0;
    for (value in tarefas.vals()){
      if (value.concluida == false){
        num += 1;
      }
    };

    return num;
  };

  public func totalTarefasConcluidas() : async Nat {
    var num : Nat = 0;
    for (value in tarefas.vals()){
      if (value.concluida == true){
        num += 1;
      }
    };

    return num;
  };

}
