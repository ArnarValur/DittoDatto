# Norwegian Address Autocomplete Spec

This document outlines the design and integration plan for providing real address autocomplete functionality in our forms, using Norway's official open-data registers.

---

## 🎯 Goal
When a user begins typing in the **Address** field (e.g., `"Skolega..."`):
1. Query an open Norwegian address register.
2. Present a dropdown list of matching real addresses (e.g., `"Skolegata 9 - 3046 Drammen"`).
3. Upon selection, automatically populate three separate form fields:
   * **Address** (Street & number)
   * **Postal Code**
   * **City**

---

## 🌐 API Source: Kartverket (Geonorge)
We will use the **Sentralt stedsnavnregister (SSR) / Adresse-API** provided by Kartverket (The Norwegian Mapping Authority).

* **API Endpoint:** `https://ws.geonorge.no/adresser/v1/sok`
* **Authentication:** None (open and free REST API).
* **Search Param:** `sok=<query>`
* **Result Limit:** `treffPerSide=5` (optimal for dropdown performance).

### Sample Request
`GET https://ws.geonorge.no/adresser/v1/sok?sok=Skolegata+9+Drammen&treffPerSide=5`

### Sample JSON Response
```json
{
  "adresser": [
    {
      "adressetekst": "Skolegata 9",
      "postnummer": "3046",
      "poststed": "DRAMMEN",
      "kommunenavn": "DRAMMEN"
    }
  ]
}
```

---

## 🛠️ Flutter Implementation Strategy

We will replace the existing standard `TextField` for the `addressCtrl` inside [companies_screen.dart](file:///home/solmundur/Projects/DittoDatto/apps/admin/lib/features/companies/companies_screen.dart#L329-L333) with a standard Flutter **`Autocomplete<Map<String, dynamic>>`** widget. 

### 1. Fetch Integration
A helper function to query the API with debouncing and query length guard (min 3 characters):

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchAddresses(String query) async {
  if (query.trim().length < 3) return [];
  
  final url = Uri.parse(
    'https://ws.geonorge.no/adresser/v1/sok?sok=${Uri.encodeComponent(query)}&treffPerSide=5'
  );
  
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(json['adresser'] ?? []);
    }
  } catch (e) {
    // Fail silently, return empty list
  }
  return [];
}
```

### 2. Autocomplete Widget Layout
Using the built-in `Autocomplete` class to handle dropdown rendering, selection, and binding back to our controllers:

```dart
Autocomplete<Map<String, dynamic>>(
  optionsBuilder: (TextEditingValue textEditingValue) {
    return fetchAddresses(textEditingValue.text);
  },
  displayStringForOption: (option) => 
      "${option['adressetekst']} - ${option['postnummer']} ${option['poststed']}",
  onSelected: (Map<String, dynamic> selection) {
    setState(() {
      addressCtrl.text = selection['adressetekst'] ?? '';
      postalCtrl.text = selection['postnummer'] ?? '';
      cityCtrl.text = selection['poststed'] ?? '';
    });
  },
  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
    // Keep internal controller in-sync with our external state
    controller.text = addressCtrl.text;
    controller.addListener(() {
      addressCtrl.text = controller.text;
    });
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: const InputDecoration(labelText: 'Address'),
    );
  },
)
```

---

## 📋 Steps to Execute

1. **Add `http` package** if not already in `pubspec.yaml` dependencies.
2. **Implement Fetcher**: Put the fetch logic inside a shared helper or directly inside the screen repository.
3. **Refactor UI**: Swap the existing static Address `TextField` with the `Autocomplete` widget in `companies_screen.dart`.
4. **Test & Verify**: Type partial Norwegian addresses (e.g. `"Skolegata 9"`, `"Storgata"`) and confirm auto-filling of City and Postal Code.
