import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proxima_dose/edit_medication_page.dart';
import 'package:proxima_dose/medication.dart';
import 'package:proxima_dose/add_medication_page.dart';

class HomePage extends StatefulWidget {
  final List<Medication> medications;

  HomePage({required this.medications});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<bool> isMedicationTaken = List.generate(
      100, (index) => false); // Substitua 100 pelo tamanho máximo esperado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Próxima Dose'),
      ),
      body: widget.medications.isEmpty
          ? Center(
              child: Text('Nenhum Lembrete criado'),
            )
          : ListView.builder(
              itemCount: widget.medications.length,
              itemBuilder: (context, index) {
                Medication medication = widget.medications[index];
                String formattedDateTime =
                    DateFormat('dd/MM/yyyy HH:mm').format(medication.nextDose);

                return ListTile(
                  title: Text(medication.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dosagem: ${medication.dosage}'),
                      Text('Data e Hora: $formattedDateTime'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          isMedicationTaken[index]
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: isMedicationTaken[index] ? Colors.green : null,
                        ),
                        onPressed: () {
                          // Marcar lembrete como tomado
                          setState(() {
                            isMedicationTaken[index] =
                                !isMedicationTaken[index];
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Navegar para a página de edição
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditMedicationPage(
                                medication: medication,
                              ),
                            ),
                          ).then((result) {
                            // Atualizar a lista quando a página de edição for concluída
                            if (result != null && result is Medication) {
                              setState(() {
                                widget.medications[index] = result;
                              });
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Excluir lembrete da lista
                          setState(() {
                            widget.medications.removeAt(index);
                            isMedicationTaken.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Navegar para a página de edição
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditMedicationPage(
                          medication: medication,
                        ),
                      ),
                    ).then((result) {
                      // Atualizar a lista quando a página de edição for concluída
                      if (result != null && result is Medication) {
                        setState(() {
                          widget.medications[index] = result;
                        });
                      }
                    });
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar para a página de adição
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMedicationPage(),
            ),
          ).then((result) {
            // Atualizar a lista quando a página de adição for concluída
            if (result != null && result is Medication) {
              setState(() {
                widget.medications.add(result);
                isMedicationTaken.add(false);
              });
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
