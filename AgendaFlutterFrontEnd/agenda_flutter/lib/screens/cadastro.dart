// screens/cadastro.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/viacep_service.dart';
import '../models/agenda.dart';
import '../services/api_service.dart';

class CadastroScreen extends StatefulWidget {
  final Agenda? agenda;

  const CadastroScreen({Key? key, this.agenda}) : super(key: key);

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
//manipulação dos atributos pelo texto
  final nomeController = TextEditingController();
  final dataController = TextEditingController();
  final horaController = TextEditingController();
  final tipoController = TextEditingController();
  final cepController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  final localidadeController = TextEditingController();
  final observacoesController = TextEditingController();

//função para buscar corretamente o endereço passando o Cep de forma correta.
  Future<void> buscarEndereco() async {
    final cep = cepController.text.replaceAll(RegExp(r'\D'), '');
    if (cep.length == 8) {
      final endereco = await ViaCEPService.buscarEndereco(cep);
      if (endereco != null) {
        setState(() {
          cidadeController.text = endereco['localidade'] ?? '';
          estadoController.text = endereco['uf'] ?? '';
          localidadeController.text = endereco['bairro'] ?? '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CEP inválido ou não encontrado')),
        );
      }
    }
  }
// permite que os campos da interface exibam os dados previamente armazenados.
  @override
  void initState() {
    super.initState();
    if (widget.agenda != null) {
      final ag = widget.agenda!;
      nomeController.text = ag.nomePaciente;
      dataController.text = ag.dataConsulta;
      horaController.text = ag.horaConsulta;
      tipoController.text = ag.tipoTratamento;
      cepController.text = ag.cep;
      cidadeController.text = ag.cidade;
      estadoController.text = ag.estado;
      localidadeController.text = ag.localidade;
      observacoesController.text = ag.observacoes ?? '';
    }
  }
//limpam os controladores
  @override
  void dispose() {
    nomeController.dispose();
    dataController.dispose();
    horaController.dispose();
    tipoController.dispose();
    cepController.dispose();
    cidadeController.dispose();
    estadoController.dispose();
    localidadeController.dispose();
    observacoesController.dispose();
    super.dispose();
  }
//Tela de cadastro com os labels e inputs
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Agendamento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Paciente',
                ),
                //"validator" faz com que o campo seja obrigatório 
                validator:
                    (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: dataController,
                decoration: const InputDecoration(
                  labelText: 'Data (YYYY-MM-DD)',
                ),
                validator:
                    (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    dataController.text = DateFormat(
                      'yyyy-MM-dd',
                    ).format(picked);
                  }
                },
              ),
              TextFormField(
                controller: horaController,
                decoration: const InputDecoration(labelText: 'Hora (HH:mm)'),
                validator:
                    (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    horaController.text = picked.format(context);
                  }
                },
              ),
              TextFormField(
                controller: tipoController,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Tratamento',
                ),
                validator:
                    (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: cepController,
                      decoration: const InputDecoration(labelText: 'CEP'),
                      validator:
                    (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                    ),
                  ),
                  //Chama o ViaCEP
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: buscarEndereco,
                  ),
                ],
              ),
              TextFormField(
                controller: cidadeController,
                decoration: const InputDecoration(labelText: 'Cidade'),
                readOnly: true,
              ),
              TextFormField(
                controller: estadoController,
                decoration: const InputDecoration(labelText: 'Estado'),
                readOnly: true,
              ),
              TextFormField(
                controller: localidadeController,
                decoration: const InputDecoration(labelText: 'Bairro'),
                readOnly: true,
              ),
              TextFormField(
                controller: observacoesController,
                decoration: const InputDecoration(labelText: 'Observações'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final agendamento = Agenda(
                      id: widget.agenda?.id,
                      nomePaciente: nomeController.text,
                      dataConsulta: dataController.text,
                      horaConsulta: horaController.text,
                      tipoTratamento: tipoController.text,
                      cep: cepController.text,
                      cidade: cidadeController.text,
                      estado: estadoController.text,
                      localidade: localidadeController.text,
                      observacoes: observacoesController.text,
                    );

                    bool sucesso;
                    if (widget.agenda != null) {
                      sucesso = await ApiService.atualizarAgenda(agendamento);
                    } else {
                      sucesso = await ApiService.salvarAgenda(agendamento);
                    }

                    if (sucesso) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Salvo com sucesso')),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Erro ao salvar')),
                      );
                    }
                  }
                },
                child: Text(
                  widget.agenda != null ? 'Atualizar' : 'Salvar Agendamento',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
