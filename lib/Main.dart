import 'package:flutter/material.dart';

void main() {
  runApp(const WorkoutPlannerApp());
}

class Exercise {
  final String name;
  final String muscle;
  final String equipment;

  const Exercise({
    required this.name,
    required this.muscle,
    required this.equipment,
  });
}

class WorkoutPlannerApp extends StatelessWidget {
  const WorkoutPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'برنامه بدنسازی',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepOrange,
      ),
      home: const WorkoutHomePage(),
    );
  }
}

class WorkoutHomePage extends StatefulWidget {
  const WorkoutHomePage({super.key});

  @override
  State<WorkoutHomePage> createState() => _WorkoutHomePageState();
}

class _WorkoutHomePageState extends State<WorkoutHomePage> {
  final List<Exercise> exercises = const [
    Exercise(
      name: 'پرس سینه هالتر',
      muscle: 'سینه، پشت‌بازو، جلوی سرشانه',
      equipment: 'هالتر',
    ),
    Exercise(
      name: 'پرس بالا سینه دمبل',
      muscle: 'بالاسینه، پشت‌بازو، جلوی سرشانه',
      equipment: 'دمبل',
    ),
    Exercise(
      name: 'زیربغل هالتر خم',
      muscle: 'لت، عضلات میانی پشت، جلو بازو',
      equipment: 'هالتر',
    ),
    Exercise(
      name: 'بارفیکس',
      muscle: 'لت، جلو بازو، عضلات پشت',
      equipment: 'میله بارفیکس',
    ),
    Exercise(
      name: 'پرس سرشانه دمبل',
      muscle: 'سرشانه، پشت‌بازو',
      equipment: 'دمبل',
    ),
    Exercise(
      name: 'نشر از جانب دمبل',
      muscle: 'سرشانه میانی',
      equipment: 'دمبل',
    ),
    Exercise(
      name: 'جلو بازو دمبل چکشی',
      muscle: 'جلو بازو، براکیالیس، ساعد',
      equipment: 'دمبل',
    ),
    Exercise(
      name: 'پشت بازو سیم‌کش طناب',
      muscle: 'پشت بازو',
      equipment: 'سیم‌کش',
    ),
    Exercise(
      name: 'اسکات هالتر',
      muscle: 'چهارسر ران، سرینی، همسترینگ، میان‌تنه',
      equipment: 'هالتر',
    ),
    Exercise(
      name: 'ددلیفت رومانیایی',
      muscle: 'همسترینگ، سرینی، فیله کمر',
      equipment: 'هالتر یا دمبل',
    ),
    Exercise(
      name: 'پلانک',
      muscle: 'میان‌تنه، شکم، عضلات تثبیت‌کننده',
      equipment: 'بدون تجهیزات',
    ),
    Exercise(
      name: 'کرانچ',
      muscle: 'راست شکمی',
      equipment: 'بدون تجهیزات',
    ),
  ];

  final List<Exercise> selectedExercises = [];
  String searchText = '';

  List<Exercise> get filteredExercises {
    return exercises.where((exercise) {
      final text = searchText.trim();
      return exercise.name.contains(text) || exercise.muscle.contains(text);
    }).toList();
  }

  void addExercise(Exercise exercise) {
    setState(() {
      selectedExercises.add(exercise);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${exercise.name} به برنامه امروز اضافه شد'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void removeExercise(int index) {
    setState(() {
      selectedExercises.removeAt(index);
    });
  }

  void showMyWorkout() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MyWorkoutPage(
          selectedExercises: selectedExercises,
          onRemove: removeExercise,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = filteredExercises;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('برنامه بدنسازی من'),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'برنامه امروز',
              onPressed: showMyWorkout,
              icon: Badge(
                label: Text('${selectedExercises.length}'),
                isLabelVisible: selectedExercises.isNotEmpty,
                child: const Icon(Icons.assignment),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'جست‌وجوی حرکت یا عضله',
                  hintText: 'مثلاً سینه، پا، اسکات...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.fitness_center),
                  const SizedBox(width: 8),
                  Text(
                    'آرشیو حرکات (${list.length})',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final exercise = list[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.fitness_center),
                      ),
                      title: Text(
                        exercise.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'عضلات درگیر: ${exercise.muscle}
'
                        'وسیله: ${exercise.equipment}',
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        tooltip: 'افزودن به برنامه',
                        icon: const Icon(Icons.add_circle),
                        onPressed: () => addExercise(exercise),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: showMyWorkout,
          icon: const Icon(Icons.assignment),
          label: Text('برنامه من (${selectedExercises.length})'),
        ),
      ),
    );
  }
}

class MyWorkoutPage extends StatefulWidget {
  final List<Exercise> selectedExercises;
  final void Function(int index) onRemove;

  const MyWorkoutPage({
    super.key,
    required this.selectedExercises,
    required this.onRemove,
  });

  @override
  State<MyWorkoutPage> createState() => _MyWorkoutPageState();
}

class _MyWorkoutPageState extends State<MyWorkoutPage> {
  final Map<int, int> sets = {};
  final Map<int, int> reps = {};
  final Map<int, String> weights = {};

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('برنامه امروز'),
        ),
        body: widget.selectedExercises.isEmpty
            ? const Center(
                child: Text(
                  'هنوز حرکتی به برنامه اضافه نکردی.
'
                  'از صفحه قبل روی دکمه + کنار حرکت بزن.',
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: widget.selectedExercises.length,
                itemBuilder: (context, index) {
                  final exercise = widget.selectedExercises[index];
                  final setValue = sets[index] ?? 3;
                  final repValue = reps[index] ?? 10;

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${index + 1}. ${exercise.name}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'حذف حرکت',
                                onPressed: () {
                                  widget.onRemove(index);
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          Text('عضله درگیر: ${exercise.muscle}'),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: setValue,
                                  decoration: const InputDecoration(
                                    labelText: 'ست',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: List.generate(10, (i) => i + 1)
                                      .map(
                                        (value) => DropdownMenuItem(
                                          value: value,
                                          child: Text('$value'),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      sets[index] = value ?? 3;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: repValue,
                                  decoration: const InputDecoration(
                                    labelText: 'تکرار',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: [
                                    1, 3, 5, 6, 8, 10, 12, 15, 20, 25, 30
                                  ]
                                      .map(
                                        (value) => DropdownMenuItem(
                                          value: value,
                                          child: Text('$value'),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      reps[index] = value ?? 10;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              weights[index] = value;
                            },
                            decoration: const InputDecoration(
                              labelText: 'وزن (کیلوگرم) — اختیاری',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
