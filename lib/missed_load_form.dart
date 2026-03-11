import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart'; // Import your config with apiUrl
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class TruckerCompany {
  final int id;
  final String name;

  TruckerCompany(this.id, this.name);
}

class ReasonType {
  final int id;
  final String description;

  ReasonType(this.id, this.description);
}

class LMReason {
  final int id;
  final int reasonTypeId;
  final String description;

  LMReason(this.id, this.reasonTypeId, this.description);
}

class MissedLoadForm extends StatefulWidget {
  final int companyId;

  const MissedLoadForm({super.key, required this.companyId});

  @override
  State<MissedLoadForm> createState() => _MissedLoadFormState();
}

class _MissedLoadFormState extends State<MissedLoadForm> {
  TruckerCompany? selectedCompany;
  @override
  void initState() {
    super.initState();

    // Auto-select the company based on companyId from token
    selectedCompany = truckingCompanies.firstWhere(
      (company) => company.id == widget.companyId,
      orElse: () => truckingCompanies.first,
    );
  }
  DateTime selectedDate = DateTime.now();
  final TextEditingController anticipatedLoadsController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final List<TruckerCompany> truckingCompanies = [
    TruckerCompany(1, "Asante"),
    TruckerCompany(2, "Buchanan"),
    TruckerCompany(3, "Conrad"),
    TruckerCompany(4, "Daryl Harper"),
    TruckerCompany(5, "Graham Lime"),
    TruckerCompany(6, "Granvel Sullivan"),
    TruckerCompany(7, "Greenhaven"),
    TruckerCompany(8, "Jeff McCorquindale"),
    TruckerCompany(9, "Melais"),
    TruckerCompany(10, "Millport"),
    TruckerCompany(11, "OC Maillet"),
    TruckerCompany(12, "Reagon"),
    TruckerCompany(13, "Shane Donnelly"),
    TruckerCompany(14, "WeHaul"),
  ];

  final List<ReasonType> reasonTypes = [
    ReasonType(1, "General Issues"),
    ReasonType(2, "Port Related"),
    ReasonType(3, "Driver Related"),
    ReasonType(4, "Mechanical Issues/ Repairs"),
  ];

  final List<LMReason> lmReasons = [
    LMReason(1, 1, "Accident/Highway Closed"),
    LMReason(2, 1, "Delays at external warehouse"),
    LMReason(3, 1, "Delays at scales"),
    LMReason(4, 1, "No pulp"),
    LMReason(5, 1, "Returned damaged cntr"),
    LMReason(6, 1, "Tied up with import"),
    LMReason(7, 1, "Winter Weather Conditions"),
    LMReason(8, 2, "Port closure"),
    LMReason(9, 2, "Port Wait Times - HFX"),
    LMReason(10, 2, "Port Wait Times - SJ"),
    LMReason(11, 2, "Switching Ports"),
    LMReason(12, 3, "Didn’t make it on time to load"),
    LMReason(13, 3, "Driver quit"),
    LMReason(14, 3, "Driver Sick"),
    LMReason(15, 3, "Driving Hours"),
    LMReason(16, 3, "Personal reasons"),
    LMReason(17, 3, "Vacation"),
    LMReason(18, 4, "Air compressor"),
    LMReason(19, 4, "Air to Air issues/replacement"),
    LMReason(20, 4, "ECM Issues"),
    LMReason(21, 4, "Injector replacements"),
    LMReason(22, 4, "Motor Repairs"),
    LMReason(23, 4, "Motor Vehicle Inspection"),
    LMReason(24, 4, "Oil change"),
    LMReason(25, 4, "Repairs to trailer"),
    LMReason(26, 4, "Springs/Bushings"),
    LMReason(27, 4, "Tire issues"),
    LMReason(28, 4, "Turbo Failure"),
    LMReason(29, 4, "Wiper motor"),
    LMReason(30, 4, "Wiring harness"),
    LMReason(31, 1, "Other"),
    LMReason(32, 2, "Other"),
    LMReason(33, 3, "Other"),
    LMReason(34, 4, "Other"),
  ];

  List<Map<String, dynamic>> missedLoads = [];

  void addMissedLoadRow() {
    setState(() {
      int defaultTypeId = reasonTypes[0].id;
      int defaultReasonId = getFilteredReasons(defaultTypeId).first.id;
      missedLoads.add({
        'reasonTypeId': defaultTypeId,
        'reasonId': defaultReasonId,
        'missed': '',
        'notes': '',
      });
    });
  }

  List<LMReason> getFilteredReasons(int reasonTypeId) {
    return lmReasons.where((r) => r.reasonTypeId == reasonTypeId).toList();
  }

  void submitForm() async {
    final report = {
      'company': selectedCompany?.id, // Send numeric TC_ID
      'date': selectedDate.toIso8601String(),
      'loadsAnticipated': int.tryParse(anticipatedLoadsController.text) ?? 0,
      'notes': notesController.text,
      'missedLoads': missedLoads.map((entry) {
        final reasonTypeId = entry['reasonTypeId'];
        final reasonId = entry['reasonId'];
        final reason = lmReasons.firstWhere((r) => r.id == reasonId).description;

        return {
          'reasonType': reasonTypeId,
          'reason': reason,
          'missed': int.tryParse(entry['missed']) ?? 0,
          'notes': entry['notes'] ?? '',
        };
      }).toList(),
    };

    final url = Uri.parse('$apiUrl/api/reports/submit');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(report),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form Submitted Successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit: $e')),
      );
    }
  }

  void removeMissedLoadRow(int index) {
    setState(() {
      missedLoads.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Daily Trucking Report'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.asset(
              'assets/images/AV_Group_logo.jpg',
              height: 60,
              width: 60,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('authToken');

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (_) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          // DropdownButtonFormField<TruckerCompany>(
          //   value: selectedCompany,
          //   hint: const Text('Select Company'),
          //   onChanged: (value) => setState(() => selectedCompany = value),
          //   items: truckingCompanies.map((company) {
          //     return DropdownMenuItem(
          //       value: company,
          //       child: Text(company.name),
          //     );
          //   }).toList(),
          // ),
         if (selectedCompany != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Center(
              child: Text(
                'Company: ${selectedCompany!.name}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(children: [
            const Text('Date:'),
            const SizedBox(width: 12),
            Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
              child: const Text('Pick Date'),
            ),
          ]),
          const SizedBox(height: 16),

          TextFormField(
            controller: anticipatedLoadsController,
            decoration: const InputDecoration(labelText: 'Loads Anticipated'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          const Text('Missed Loads', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: missedLoads.length,
            itemBuilder: (context, index) {
              final entry = missedLoads[index];
              final selectedTypeId = entry['reasonTypeId'] as int;
              final selectedReasonId = entry['reasonId'] as int;
              final filteredReasons = getFilteredReasons(selectedTypeId);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    DropdownButtonFormField<int>(
                      value: selectedTypeId,
                      decoration: const InputDecoration(labelText: 'Reason Type'),
                      onChanged: (value) {
                        if (value != null) {
                          final newReasonId = getFilteredReasons(value).first.id;
                          setState(() {
                            entry['reasonTypeId'] = value;
                            entry['reasonId'] = newReasonId;
                          });
                        }
                      },
                      items: reasonTypes.map((rt) => DropdownMenuItem(value: rt.id, child: Text(rt.description))).toList(),
                    ),

                    DropdownButtonFormField<int>(
                      value: selectedReasonId,
                      decoration: const InputDecoration(labelText: 'Reason'),
                      onChanged: (value) => setState(() => entry['reasonId'] = value),
                      items: filteredReasons.map((r) => DropdownMenuItem(value: r.id, child: Text(r.description))).toList(),
                    ),

                    TextFormField(
                      initialValue: entry['missed'],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Missed Count'),
                      onChanged: (val) => entry['missed'] = val,
                    ),

                    TextFormField(
                      initialValue: entry['notes'],
                      decoration: const InputDecoration(labelText: 'Notes'),
                      onChanged: (val) => entry['notes'] = val,
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => removeMissedLoadRow(index),
                      ),
                    )
                  ]),
                ),
              );
            },
          ),

          ElevatedButton.icon(
            onPressed: addMissedLoadRow,
            icon: const Icon(Icons.add),
            label: const Text('Add Row'),
          ),

          const SizedBox(height: 16),
          TextFormField(
            controller: notesController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'General Notes'),
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: submitForm,
            child: const Text('Submit'),
          ),
        ]),
      ),
    );
  }
}
