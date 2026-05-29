import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const AlHaibaApp());
}

class AlHaibaApp extends StatelessWidget {
  const AlHaibaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق الهيبة المحاسبي',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'AE'), 
      ],
      locale: const Locale('ar', 'AE'),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> products = [
    {"id": "1", "name": "ألمنيوم قطاع خاص", "cost": 100.0, "price": 150.0, "stock": 15},
    {"id": "2", "name": "إكسسوار مطبخ ملكي", "cost": 20.0, "price": 35.0, "stock": 40},
  ];

  double totalSales = 0.0;
  double totalProfits = 0.0;

  final nameController = TextEditingController();
  final costController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();

  void sellProduct(Map<String, dynamic> product) {
    setState(() {
      if (product['stock'] > 0) {
        product['stock']--;
        totalSales += product['price'];
        totalProfits += (product['price'] - product['cost']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم بيع وحدة من: ${product['name']}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تنبيه: الكمية نفدت من المخزن!')),
        );
      }
    });
  }

  void addNewProduct() {
    if (nameController.text.isEmpty || costController.text.isEmpty || priceController.text.isEmpty || stockController.text.isEmpty) {
      return;
    }
    setState(() {
      products.add({
        "id": DateTime.now().toString(),
        "name": nameController.text,
        "cost": double.parse(costController.text),
        "price": double.parse(priceController.text),
        "stock": int.parse(stockController.text),
      });
      nameController.clear();
      costController.clear();
      priceController.clear();
      stockController.clear();
    });
    Navigator.of(context).pop();
  }

  void shareReportAndBackup() {
    String report = """
📊 **تقرير مبيعات ونسخ احتياطي - تطبيق الهيبة** 📊
----------------------------------
💰 إجمالي المبيعات: $totalSales
📈 الأرباح الصافية: $totalProfits
----------------------------------
📦 **حالة المخزن الحالية:**
""";
    
    for (var prod in products) {
      report += "\n- ${prod['name']} (المتبقي: ${prod['stock']} | سعر البيع: ${prod['price']})";
    }

    report += "\n\n----------------------------------\nتم التوليد والنسخ الاحتياطي تلقائياً للواتساب.";
    
    Share.share(report, subject: 'النسخ الاحتياطي والتقرير اليومي');
  }

  @override
  void dispose() {
    nameController.dispose();
    costController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مطابخ الهيبة - إدارة المخزن والمبيعات', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.blueGrey.shade800,
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload_rounded, color: Colors.white),
            onPressed: shareReportAndBackup,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.green.shade50,
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('إجمالي المبيعات', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          Text('$totalSales', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.blue.shade50,
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('الأرباح الصافية', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                          Text('$totalProfits', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('البضاعة المتوفرة في المخزن:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () => showFormDialog(context),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('إضافة صنف', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey.shade700),
                )
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final prod = products[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(prod['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      subtitle: Text('المخزون الحالي: ${prod['stock']} \nالتكلفة: ${prod['cost']} | البيع: ${prod['price']}'),
                      trailing: ElevatedButton.icon(
                        icon: const Icon(Icons.monetization_on, size: 18),
                        label: const Text('بيع وحدة'),
                        onPressed: () => sellProduct(prod),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade700, foregroundColor: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة صنف جديد للمخزن'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'اسم الصنف')),
              TextField(controller: costController, decoration: const InputDecoration(labelText: 'سعر التكلفة'), keyboardType: TextInputType.number),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'سعر البيع'), keyboardType: TextInputType.number),
              TextField(controller: stockController, decoration: const InputDecoration(labelText: 'الكمية الابتدائية'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('إلغاء')),
          ElevatedButton(onPressed: addNewProduct, child: const Text('حفظ في المخزن')),
        ],
      ),
    );
  }
}
