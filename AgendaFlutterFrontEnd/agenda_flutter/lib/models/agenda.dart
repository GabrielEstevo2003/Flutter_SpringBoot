class Agenda {
  String? id;
  String nomePaciente;
  String dataConsulta;
  String horaConsulta;
  String tipoTratamento;
  String cep;
  String cidade;
  String estado;
  String localidade;
  String? observacoes;

//fazer com que os atributos sejam 
  Agenda({
    this.id,
    required this.nomePaciente,
    required this.dataConsulta,
    required this.horaConsulta,
    required this.tipoTratamento,
    required this.cep,
    required this.cidade,
    required this.estado,
    required this.localidade,
    this.observacoes,
  });

//Recebe um Json e converte ele em um objeto
  factory Agenda.fromJson(Map<String, dynamic> json) {
    return Agenda(
      id: json['id'],
      nomePaciente: json['nomePaciente'],
      dataConsulta: json['dataConsulta'],
      horaConsulta: json['horaConsulta'],
      tipoTratamento: json['tipoTratamento'],
      cep: json['cep'],
      cidade: json['cidade'],
      estado: json['estado'],
      localidade: json['localidade'],
      observacoes: json['observacoes'],
    );
  }

//Converte objeto para Json, para transferi-lo à API
  Map<String, dynamic> toJson() {
    return {
      'nomePaciente': nomePaciente,
      'dataConsulta': dataConsulta,
      'horaConsulta': horaConsulta,
      'tipoTratamento': tipoTratamento,
      'cep': cep,
      'cidade': cidade,
      'estado': estado,
      'localidade': localidade,
      'observacoes': observacoes,
    };
  }
}
