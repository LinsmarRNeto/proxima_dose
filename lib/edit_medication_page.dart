import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proxima_dose/medication.dart';

class EditMedicationPage extends StatefulWidget {
  final Medication medication;

  EditMedicationPage({required this.medication});

  @override
  _EditMedicationPageState createState() => _EditMedicationPageState();
}

class _EditMedicationPageState extends State<EditMedicationPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    // Inicialize os controladores e valores iniciais com os dados existentes
    nameController.text = widget.medication.name;
    dosageController.text = widget.medication.dosage;
    selectedDate = widget.medication.nextDose;
    selectedTime = TimeOfDay.fromDateTime(widget.medication.nextDose);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Medicamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nome do Medicamento',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: dosageController,
              decoration: InputDecoration(
                labelText: 'Dosagem',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Data',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        "${DateFormat('dd/MM/yyyy').format(selectedDate)}",
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Hora',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        "${selectedTime.format(context)}",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Atualizar o medicamento
                widget.medication.name = nameController.text;
                widget.medication.dosage = dosageController.text;
                widget.medication.nextDose = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                // Retornar o medicamento atualizado
                Navigator.pop(context, widget.medication);
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
