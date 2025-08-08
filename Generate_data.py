import csv
import random

# --- 1. تعريف القوالب والكلمات لكل أولوية ---

# قوالب للمهام العاجلة (Urgent)
urgent_templates = [
    "Finish the {} report before the deadline",
    "Fix the critical bug in the {} system",
    "Respond immediately to the urgent email from {}",
    "Submit the {} by end of day",
    "Resolve the blocking issue with {}"
]
urgent_fillers = {
    "report": ["sales", "quarterly", "project", "financial"],
    "system": ["payment", "authentication", "database", "server"],
    "person": ["the client", "the manager", "the support team", "Mr. Ahmed"],
    "document": ["final proposal", "contract draft", "presentation slides"]
}

# قوالب للمهام الهامة (Important)
important_templates = [
    "Prepare the presentation for the {}",
    "Schedule a meeting with {} to discuss {}",
    "Plan the strategy for the upcoming {}",
    "Review the {} document thoroughly",
    "Follow up with {} regarding the project"
]
important_fillers = {
    "presentation_for": ["board meeting", "client pitch", "weekly sync", "product demo"],
    "person": ["the marketing team", "the developers", "the stakeholders", "John"],
    "topic": ["the new feature", "the budget", "the project timeline"],
    "document": ["design mockups", "technical specification", "user feedback"],
    "project": ["Q3 goals", "new marketing campaign"]
}

# قوالب للمهام العادية (Normal)
normal_templates = [
    "Buy {} from the grocery store",
    "Book a {} appointment",
    "Water the {}",
    "Call {} to check in",
    "Clean the {}"
]
normal_fillers = {
    "item": ["milk", "bread", "eggs", "vegetables"],
    "appointment": ["dentist", "doctor", "haircut"],
    "plant": ["office plants", "balcony garden", "indoor tree"],
    "person": ["mom", "a friend", "the landlord"],
    "room": ["kitchen", "office desk", "car"]
}


# --- 2. دالة لتوليد مهمة عشوائية من القوالب ---

def generate_task(template, fillers):
    task = template
    # استبدال الكلمات في القالب بكلمات عشوائية
    for key in fillers:
        if "{}" in task:  # أبسط طريقة للاستبدال
            task = task.replace("{}", random.choice(fillers[key]), 1)
    return task


# --- 3. كتابة البيانات في ملف CSV ---

def create_dataset(filename="tasks_dataset.csv", num_samples=300):
    with open(filename, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        # كتابة رأس الجدول
        writer.writerow(["task_description", "priority"])

        # توليد عدد متساوٍ من كل نوع
        samples_per_category = num_samples // 3

        # توليد المهام العاجلة
        for _ in range(samples_per_category):
            template = random.choice(urgent_templates)
            task_desc = generate_task(template, urgent_fillers)
            writer.writerow([task_desc, "High"])

        # توليد المهام الهامة
        for _ in range(samples_per_category):
            template = random.choice(important_templates)
            task_desc = generate_task(template, important_fillers)
            writer.writerow([task_desc, "Medium"])

        # توليد المهام العادية
        for _ in range(samples_per_category):
            template = random.choice(normal_templates)
            task_desc = generate_task(template, normal_fillers)
            writer.writerow([task_desc, "Low"])

    print(f"✅ Successfully generated {num_samples} samples in '{filename}'")


# --- تشغيل السكربت ---
if __name__ == "__main__":
    # ------------------------------------
    # قم بتغيير الرقم هنا
    create_dataset(num_samples=100000)
    # ------------------------------------
