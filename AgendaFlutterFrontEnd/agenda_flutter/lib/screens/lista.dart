import 'package:agenda_flutter/models/agenda.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'cadastro.dart';

//Widget dinâmico
class ListagemScreen extends StatefulWidget {
  const ListagemScreen({Key? key}) : super(key: key);

  @override
  State<ListagemScreen> createState() => _ListagemScreenState();
}
//parte lógica da tela de lista
class _ListagemScreenState extends State<ListagemScreen> {
  late Future<List<Agenda>> agenda;
  List<Agenda> listaCompleta = [];
  List<Agenda> listaFiltrada = [];

  final TextEditingController _searchController = TextEditingController();

//Chama a função com o método GET e cria um filtro
  @override
  void initState() {
    super.initState();
    carregarAgendamentos();

    _searchController.addListener(() {
      _filtrarAgendamentos(_searchController.text);
    });
  }

  void carregarAgendamentos() {
    agenda = ApiService.listarAgendas();
    agenda.then((dados) {
      setState(() {
        listaCompleta = dados;
        listaFiltrada = dados;
      });
    });
  }
//busca agendas pelo nome, se não tiver algo para buscar retorna a lista completa
  void _filtrarAgendamentos(String filtro) {
    setState(() {
      if (filtro.isEmpty) {
        listaFiltrada = listaCompleta;
      } else {
        listaFiltrada = listaCompleta
            .where((ag) => ag.nomePaciente.toLowerCase().contains(filtro.toLowerCase()))
            .toList();
      }
    });
  }
//limpa controller
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agendamentos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar por nome do paciente',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Agenda>>(
              future: agenda,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && listaCompleta.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError && listaCompleta.isEmpty) {
                  return const Center(child: Text('Erro ao carregar dados'));
                } else if (listaFiltrada.isEmpty) {
                  return const Center(child: Text('Nenhum agendamento encontrado'));
                }
                //Exibe as Agendas
                return ListView.builder(
                  itemCount: listaFiltrada.length,
                  itemBuilder: (context, index) {
                    final ag = listaFiltrada[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(ag.nomePaciente),
                        subtitle: Text(
                          '${ag.dataConsulta} - ${ag.horaConsulta} (${ag.tipoTratamento})\n${ag.cidade}/${ag.estado} - ${ag.localidade}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CadastroScreen(agenda: ag),
                                  ),
                                );
                                carregarAgendamentos();
                              },
                            ),
                            //Botão de Delete
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirmado = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Excluir'),
                                    content: const Text('Deseja realmente excluir este agendamento?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text('Excluir'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmado == true) {
                                  final sucesso = await ApiService.excluirAgenda(ag.id!);
                                  if (sucesso) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Agendamento excluído com sucesso')),
                                    );
                                    carregarAgendamentos();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Erro ao excluir agendamento')),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CadastroScreen()),
          );
          carregarAgendamentos();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
