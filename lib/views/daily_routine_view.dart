import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/care_task_model.dart';
import '../providers/staff_duty_provider.dart';
import '../theme/app_theme.dart';
import 'bed_turning_view.dart';

class DailyRoutineView extends StatefulWidget {
  const DailyRoutineView({super.key});

  @override
  State<DailyRoutineView> createState() => _DailyRoutineViewState();
}

class _DailyRoutineViewState extends State<DailyRoutineView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openAddTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _AddCareTaskSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StaffDutyProvider>();
    final tasks = provider.todayTasks;
    final completedCount = tasks.where((t) => t.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Routine & Bedside Care'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: AppTheme.slate500,
          indicatorColor: AppTheme.primaryBlue,
          indicatorWeight: 3,
          tabs: [
            Tab(
              icon: const Icon(Icons.checklist_rounded),
              text: 'Care Tasks ($completedCount/${tasks.length})',
            ),
            const Tab(
              icon: Icon(Icons.airline_seat_flat_rounded),
              text: '2h Bed Turning',
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task_rounded, color: AppTheme.primaryBlue),
            tooltip: 'Add Care Task',
            onPressed: () => _openAddTaskModal(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Daily Tasks Checklist
          _TasksChecklistTab(tasks: tasks),

          // Tab 2: Bed Turning Log
          const BedTurningView(),
        ],
      ),
    );
  }
}

class _TasksChecklistTab extends StatelessWidget {
  final List<CareTaskModel> tasks;

  const _TasksChecklistTab({required this.tasks});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<StaffDutyProvider>();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isDone = task.isCompleted;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => provider.toggleCareTask(task.id),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: isDone,
                    onChanged: (_) => provider.toggleCareTask(task.id),
                    activeColor: AppTheme.emeraldGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isDone ? AppTheme.emerald50 : AppTheme.blueLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                task.timeSlot,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isDone ? AppTheme.emerald800 : AppTheme.primaryBlue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              task.category.titleEn,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.slate500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDone ? AppTheme.slate400 : AppTheme.slate900,
                            decoration: isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task.instructions,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDone ? AppTheme.slate400 : AppTheme.slate600,
                          ),
                        ),
                        if (isDone && task.completedAt != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.check_circle_rounded, size: 14, color: AppTheme.emeraldGreen),
                              const SizedBox(width: 4),
                              Text(
                                'Completed at ${DateFormat('hh:mm a').format(task.completedAt!)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.emeraldGreen,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Add Custom Care Task Bottom Sheet
class _AddCareTaskSheet extends StatefulWidget {
  const _AddCareTaskSheet();

  @override
  State<_AddCareTaskSheet> createState() => _AddCareTaskSheetState();
}

class _AddCareTaskSheetState extends State<_AddCareTaskSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _timeCtrl = TextEditingController(text: '03:00 PM');
  final _instructionsCtrl = TextEditingController();
  TaskCategory _category = TaskCategory.medication;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _timeCtrl.dispose();
    _instructionsCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<StaffDutyProvider>().addCustomTask(
            title: _titleCtrl.text.trim(),
            timeSlot: _timeCtrl.text.trim(),
            category: _category,
            instructions: _instructionsCtrl.text.trim(),
          );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppTheme.slate200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Add Bedside Care Task',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.slate900,
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    hintText: 'e.g. Assist with gentle walking / Physiotherapy',
                    prefixIcon: Icon(Icons.task_alt_rounded),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Please enter task title' : null,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _timeCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Time Slot',
                          hintText: '03:00 PM',
                          prefixIcon: Icon(Icons.access_time_rounded),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<TaskCategory>(
                        initialValue: _category,
                        decoration: const InputDecoration(labelText: 'Category'),
                        items: TaskCategory.values
                            .map((c) => DropdownMenuItem(value: c, child: Text(c.titleEn, style: const TextStyle(fontSize: 12))))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _category = val);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _instructionsCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Specific Instructions',
                    hintText: 'e.g. Ensure wheelchair footrests are folded back first',
                    prefixIcon: Icon(Icons.notes_rounded),
                  ),
                ),
                const SizedBox(height: 18),

                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Add to Today\'s Schedule', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
