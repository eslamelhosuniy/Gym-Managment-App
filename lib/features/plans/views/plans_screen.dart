import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_router.dart';
import '../controllers/plan_controller.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlanController>().getPlans();
    });
  }

  Widget planCard({
    required BuildContext context,
    required String id,
    required String name,
    required String price,
    required String duration,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const CircleAvatar(child: Icon(Icons.card_membership)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("$price EGP"),
                Text("$duration days",
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 18),
              onPressed: () {
                context.go("/plans/$id");
              },
          ),
        ],
      ),
    );
  }

  Widget emptyPlansView(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Plans",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "View all membership plans",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            FloatingActionButton.small(
              onPressed: () => context.go(AppRouter.addPlan),
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Column(
            children: [
              Icon(Icons.card_membership, size: 42, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                "No plans found",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                "Add a new membership plan to get started",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<PlanController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return emptyPlansView(context);
          }

          if (controller.plans.isEmpty) {
            return emptyPlansView(context);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Plans",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "View all membership plans",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  FloatingActionButton.small(
                    onPressed: () => context.go(AppRouter.addPlan),
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...controller.plans.map((plan) {
                return planCard(
                  context: context,
                  id: plan.id ?? "",
                  name: plan.planName ?? "",
                  price: plan.price.toString(),
                  duration: plan.durationDays.toString(),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}