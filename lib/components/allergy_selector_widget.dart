import 'package:flutter/material.dart';

import '../services/allergy_service.dart'; // If you're using provider to manage state

class AllergySelector extends StatefulWidget {
  final List<String> selectedAllergies;

  const AllergySelector({super.key, required this.selectedAllergies});

  @override
  _AllergySelectorState createState() => _AllergySelectorState();
}

class _AllergySelectorState extends State<AllergySelector> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _allergies = [];
  List<Map<String, dynamic>> _filteredAllergies = [];

  @override
  void initState() {
    super.initState();
    _fetchAllergies();
  }

  // Fetch the allergies data
  Future<void> _fetchAllergies() async {
    AllergyService allergyService = AllergyService();
    List<Map<String, dynamic>> allergies =
        await allergyService.fetchAllergyLevelsData();
    setState(() {
      _allergies = allergies;
      _filteredAllergies = allergies;
    });
  }

  // Filter allergies based on search query
  void _filterAllergies(String query) {
    setState(() {
      _filteredAllergies = _allergies
          .where((allergy) =>
              allergy['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chọn Dị Ứng")),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterAllergies,
                decoration: InputDecoration(
                  hintText: "Tìm kiếm dị ứng...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredAllergies.length,
                itemBuilder: (context, index) {
                  var allergy = _filteredAllergies[index];
                  bool isSelected =
                      widget.selectedAllergies.contains(allergy['title']);

                  return CheckboxListTile(
                    title: Text(allergy['title']),
                    subtitle: Text(allergy['notes']),
                    value: isSelected,
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          widget.selectedAllergies.add(allergy['title']);
                        } else {
                          widget.selectedAllergies.remove(allergy['title']);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Use the selected allergies (for example, save them or update UI)
                  Navigator.pop(context, widget.selectedAllergies);
                },
                child: Text("Done"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
